// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'aliment_bank.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AlimentOrder)
final alimentOrderProvider = AlimentOrderProvider._();

final class AlimentOrderProvider
    extends $NotifierProvider<AlimentOrder, Set<String>> {
  AlimentOrderProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentOrderProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentOrderHash();

  @$internal
  @override
  AlimentOrder create() => AlimentOrder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Set<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Set<String>>(value),
    );
  }
}

String _$alimentOrderHash() => r'3abc71ac35f610240de664d1c991a742c868a38d';

abstract class _$AlimentOrder extends $Notifier<Set<String>> {
  Set<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Set<String>, Set<String>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Set<String>, Set<String>>, Set<String>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LastUsedQuantities)
final lastUsedQuantitiesProvider = LastUsedQuantitiesProvider._();

final class LastUsedQuantitiesProvider
    extends $AsyncNotifierProvider<LastUsedQuantities, Quantities> {
  LastUsedQuantitiesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'lastUsedQuantitiesProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$lastUsedQuantitiesHash();

  @$internal
  @override
  LastUsedQuantities create() => LastUsedQuantities();
}

String _$lastUsedQuantitiesHash() =>
    r'50acc2109973a9caff1df0fe620c913877617416';

abstract class _$LastUsedQuantities extends $AsyncNotifier<Quantities> {
  FutureOr<Quantities> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Quantities>, Quantities>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<Quantities>, Quantities>,
        AsyncValue<Quantities>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CustomAliments)
final customAlimentsProvider = CustomAlimentsProvider._();

final class CustomAlimentsProvider
    extends $NotifierProvider<CustomAliments, Map<String, AlimentData>> {
  CustomAlimentsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'customAlimentsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$customAlimentsHash();

  @$internal
  @override
  CustomAliments create() => CustomAliments();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, AlimentData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, AlimentData>>(value),
    );
  }
}

String _$customAlimentsHash() => r'de9e2a88677e1139e28e431e8aaa54ff2c66da3f';

abstract class _$CustomAliments extends $Notifier<Map<String, AlimentData>> {
  Map<String, AlimentData> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<Map<String, AlimentData>, Map<String, AlimentData>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, AlimentData>, Map<String, AlimentData>>,
        Map<String, AlimentData>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(AlimentCatalogs)
final alimentCatalogsProvider = AlimentCatalogsProvider._();

final class AlimentCatalogsProvider
    extends $NotifierProvider<AlimentCatalogs, Map<String, AlimentCatalog>> {
  AlimentCatalogsProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentCatalogsProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentCatalogsHash();

  @$internal
  @override
  AlimentCatalogs create() => AlimentCatalogs();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, AlimentCatalog> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, AlimentCatalog>>(value),
    );
  }
}

String _$alimentCatalogsHash() => r'51b093aa9eee43c60a9780d44a36e9ab5b80a94b';

abstract class _$AlimentCatalogs
    extends $Notifier<Map<String, AlimentCatalog>> {
  Map<String, AlimentCatalog> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref
        as $Ref<Map<String, AlimentCatalog>, Map<String, AlimentCatalog>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<String, AlimentCatalog>, Map<String, AlimentCatalog>>,
        Map<String, AlimentCatalog>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(alimentBank)
final alimentBankProvider = AlimentBankProvider._();

final class AlimentBankProvider extends $FunctionalProvider<AlimentBankState,
    AlimentBankState, AlimentBankState> with $Provider<AlimentBankState> {
  AlimentBankProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentBankProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentBankHash();

  @$internal
  @override
  $ProviderElement<AlimentBankState> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AlimentBankState create(Ref ref) {
    return alimentBank(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AlimentBankState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AlimentBankState>(value),
    );
  }
}

String _$alimentBankHash() => r'196f0867584568a34f2295806851c177923979bf';

@ProviderFor(AlimentBankController)
final alimentBankControllerProvider = AlimentBankControllerProvider._();

final class AlimentBankControllerProvider
    extends $NotifierProvider<AlimentBankController, void> {
  AlimentBankControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'alimentBankControllerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$alimentBankControllerHash();

  @$internal
  @override
  AlimentBankController create() => AlimentBankController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$alimentBankControllerHash() =>
    r'db47d71083ac1aaa0d24678df61d23b748f6cc09';

abstract class _$AlimentBankController extends $Notifier<void> {
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
