// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nutrient_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Nutrients)
final nutrientsProvider = NutrientsProvider._();

final class NutrientsProvider
    extends $NotifierProvider<Nutrients, NutrientState> {
  NutrientsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'nutrientsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$nutrientsHash();

  @$internal
  @override
  Nutrients create() => Nutrients();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(NutrientState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<NutrientState>(value),
    );
  }
}

String _$nutrientsHash() => r'00ab9343e19aace9960a3dc9ab767654dd209d8f';

abstract class _$Nutrients extends $Notifier<NutrientState> {
  NutrientState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<NutrientState, NutrientState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<NutrientState, NutrientState>,
        NutrientState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
