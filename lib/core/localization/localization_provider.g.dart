// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'localization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Localization)
final localizationProvider = LocalizationProvider._();

final class LocalizationProvider
    extends $NotifierProvider<Localization, String> {
  LocalizationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'localizationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$localizationHash();

  @$internal
  @override
  Localization create() => Localization();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$localizationHash() => r'a612cd43807bf38fce6a31ebebfda9055be4c5ab';

abstract class _$Localization extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<String, String>, String, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
