enum LegalDocument {
  termsOfUse,
  privacyPolicy,
}

class LegalRequirement {
  final LegalDocument document;
  final String version;
  final String? oldVersion;

  LegalRequirement({
    required this.document,
    required this.version,
    required this.oldVersion,
  });
}

abstract interface class ILegalHandler {
  Future<List<LegalRequirement>> fetch();
  Future<void> accept(List<LegalRequirement> requirements);
}
