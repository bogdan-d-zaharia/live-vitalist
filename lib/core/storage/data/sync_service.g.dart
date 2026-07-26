// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// To solve data conflicts, we can either:
/// 1. Save & Load intelligently
/// 2. Append (intelligently) / Overwrite (brute)
///    the cloud with local data,
///        then delete everything local (to force online download)
///        then pull from cloud
/// We are going to use the second option.

@ProviderFor(SyncService)
final syncServiceProvider = SyncServiceProvider._();

/// To solve data conflicts, we can either:
/// 1. Save & Load intelligently
/// 2. Append (intelligently) / Overwrite (brute)
///    the cloud with local data,
///        then delete everything local (to force online download)
///        then pull from cloud
/// We are going to use the second option.
final class SyncServiceProvider extends $NotifierProvider<SyncService, void> {
  /// To solve data conflicts, we can either:
  /// 1. Save & Load intelligently
  /// 2. Append (intelligently) / Overwrite (brute)
  ///    the cloud with local data,
  ///        then delete everything local (to force online download)
  ///        then pull from cloud
  /// We are going to use the second option.
  SyncServiceProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncServiceProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  SyncService create() => SyncService();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncServiceHash() => r'b84afe58784a460c91e90bd6cae502bab9f1b58d';

/// To solve data conflicts, we can either:
/// 1. Save & Load intelligently
/// 2. Append (intelligently) / Overwrite (brute)
///    the cloud with local data,
///        then delete everything local (to force online download)
///        then pull from cloud
/// We are going to use the second option.

abstract class _$SyncService extends $Notifier<void> {
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
