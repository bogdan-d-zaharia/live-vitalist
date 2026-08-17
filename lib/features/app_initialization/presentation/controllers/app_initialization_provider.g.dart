// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(AppInitialization)
final appInitializationProvider = AppInitializationProvider._();

final class AppInitializationProvider
    extends $AsyncNotifierProvider<AppInitialization, AppInitState> {
  AppInitializationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appInitializationProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appInitializationHash();

  @$internal
  @override
  AppInitialization create() => AppInitialization();
}

String _$appInitializationHash() => r'7a7d1c4c9051b9dcbfca3ee65cc5c1734660d41e';

abstract class _$AppInitialization extends $AsyncNotifier<AppInitState> {
  FutureOr<AppInitState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<AppInitState>, AppInitState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<AppInitState>, AppInitState>,
        AsyncValue<AppInitState>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
