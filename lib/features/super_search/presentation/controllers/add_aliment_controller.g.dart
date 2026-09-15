// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_aliment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AddAliment)
final addAlimentProvider = AddAlimentProvider._();

final class AddAlimentProvider
    extends $NotifierProvider<AddAliment, AddAlimentState> {
  AddAlimentProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'addAlimentProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$addAlimentHash();

  @$internal
  @override
  AddAliment create() => AddAliment();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AddAlimentState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AddAlimentState>(value),
    );
  }
}

String _$addAlimentHash() => r'138d6d007648185c79a0ccb6f5ea0394b8530c93';

abstract class _$AddAliment extends $Notifier<AddAlimentState> {
  AddAlimentState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AddAlimentState, AddAlimentState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AddAlimentState, AddAlimentState>,
        AddAlimentState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
