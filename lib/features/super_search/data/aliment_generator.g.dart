// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aliment_generator.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fills in the nutritional data of an aliment by asking Gemini, through
/// Firebase AI Logic, about the given input. The app never holds an API
/// key: Firebase authorizes and bills the request on the app's project.

@ProviderFor(AlimentGenerator)
final alimentGeneratorProvider = AlimentGeneratorProvider._();

/// Fills in the nutritional data of an aliment by asking Gemini, through
/// Firebase AI Logic, about the given input. The app never holds an API
/// key: Firebase authorizes and bills the request on the app's project.
final class AlimentGeneratorProvider
    extends $NotifierProvider<AlimentGenerator, void> {
  /// Fills in the nutritional data of an aliment by asking Gemini, through
  /// Firebase AI Logic, about the given input. The app never holds an API
  /// key: Firebase authorizes and bills the request on the app's project.
  AlimentGeneratorProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentGeneratorProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentGeneratorHash();

  @$internal
  @override
  AlimentGenerator create() => AlimentGenerator();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$alimentGeneratorHash() => r'6f3291dcebe53ec365983e65df3cd111828fe8b7';

/// Fills in the nutritional data of an aliment by asking Gemini, through
/// Firebase AI Logic, about the given input. The app never holds an API
/// key: Firebase authorizes and bills the request on the app's project.

abstract class _$AlimentGenerator extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<void, void>, void, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}
