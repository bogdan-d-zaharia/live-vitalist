// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'super_search_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SuperSearch)
final superSearchProvider = SuperSearchProvider._();

final class SuperSearchProvider
    extends $NotifierProvider<SuperSearch, SuperSearchState> {
  SuperSearchProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'superSearchProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$superSearchHash();

  @$internal
  @override
  SuperSearch create() => SuperSearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuperSearchState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuperSearchState>(value),
    );
  }
}

String _$superSearchHash() => r'746522b0fa5d097c6088f7292d49e863c5549d98';

abstract class _$SuperSearch extends $Notifier<SuperSearchState> {
  SuperSearchState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SuperSearchState, SuperSearchState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<SuperSearchState, SuperSearchState>,
        SuperSearchState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
