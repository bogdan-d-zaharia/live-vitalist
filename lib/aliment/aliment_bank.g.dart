// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aliment_bank.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlimentBank)
final alimentBankProvider = AlimentBankProvider._();

final class AlimentBankProvider
    extends $NotifierProvider<AlimentBank, AlimentBankState> {
  AlimentBankProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentBankProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentBankHash();

  @$internal
  @override
  AlimentBank create() => AlimentBank();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlimentBankState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlimentBankState>(value),
    );
  }
}

String _$alimentBankHash() => r'a0e7ad1ac0013080818cc52d40db843d8ac9ac78';

abstract class _$AlimentBank extends $Notifier<AlimentBankState> {
  AlimentBankState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AlimentBankState, AlimentBankState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AlimentBankState, AlimentBankState>,
        AlimentBankState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
