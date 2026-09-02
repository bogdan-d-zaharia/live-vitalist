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

String _$alimentOrderHash() => r'c930cf5d9cea9f8f34e65477bd2e6ff3c1d6922d';

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

String _$customAlimentsHash() => r'3f0c5a0fe4bbc8db78d33c2f3d0b3e87972c79a9';

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

String _$alimentCatalogsHash() => r'db411960059ad68e0029e4778cadbbf33d90ae44';

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

String _$alimentBankHash() => r'b78947180dc51381eb5b4f97f95385048a6e6bfc';

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
    r'f6af5b2546a64a7e3f68508c489d89f667302c0d';

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
