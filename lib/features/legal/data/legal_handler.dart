import 'package:live_vitalist/core/api/domain/api_type_exception.dart';
import 'package:live_vitalist/core/network/data/network_provider.dart';
import 'package:live_vitalist/core/network/domain/network_interface.dart';
import 'package:live_vitalist/features/legal/domain/legal_types.dart';
import 'package:live_vitalist/features/settings/data/settings_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'legal_handler.g.dart';

class LegalHandler implements ILegalHandler {
  final INetwork _networkHandler;
  LegalHandler(this._networkHandler);

  @override
  Future<List<LegalRequirement>> fetch() async {
    final json = await _networkHandler.get('load-legal-versions');
    try {
      final acceptedTerms = SettingsData.termsVersion;
      final acceptedPrivacy = SettingsData.privacyVersion;

      return [
        if (json['termsOfUse'] != acceptedTerms)
          LegalRequirement(
            document: LegalDocument.termsOfUse,
            version: json['termsOfUse'],
            oldVersion: acceptedTerms,
          ),
        if (json['privacyPolicy'] != acceptedPrivacy)
          LegalRequirement(
            document: LegalDocument.privacyPolicy,
            version: json['privacyPolicy'],
            oldVersion: acceptedPrivacy,
          ),
      ];
    } catch (e) {
      throw ApiTypeException();
    }
  }

  @override
  Future<void> accept(List<LegalRequirement> requirements) async {
    for (final requirement in requirements) {
      switch (requirement.document) {
        case LegalDocument.termsOfUse:
          SettingsData.termsVersion = requirement.version;
        case LegalDocument.privacyPolicy:
          SettingsData.privacyVersion = requirement.version;
      }
    }
  }
}

@riverpod
ILegalHandler legalHandler(Ref ref) {
  final INetwork network = ref.watch(networkProvider);
  return LegalHandler(network);
}
