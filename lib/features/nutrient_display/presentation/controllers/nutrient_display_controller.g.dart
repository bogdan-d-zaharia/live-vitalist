// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrient_display_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NutrientDisplayController)
final nutrientDisplayControllerProvider = NutrientDisplayControllerProvider._();

final class NutrientDisplayControllerProvider
    extends $NotifierProvider<NutrientDisplayController, NutrientDisplayState> {
  NutrientDisplayControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nutrientDisplayControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nutrientDisplayControllerHash();

  @$internal
  @override
  NutrientDisplayController create() => NutrientDisplayController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutrientDisplayState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutrientDisplayState>(value),
    );
  }
}

String _$nutrientDisplayControllerHash() =>
    r'0f666155c4e3864e1cbd8a1d235468469d0ebe6e';

abstract class _$NutrientDisplayController
    extends $Notifier<NutrientDisplayState> {
  NutrientDisplayState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NutrientDisplayState, NutrientDisplayState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NutrientDisplayState, NutrientDisplayState>,
        NutrientDisplayState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
