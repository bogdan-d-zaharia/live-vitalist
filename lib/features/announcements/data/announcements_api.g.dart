// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'announcements_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(announcementsApi)
final announcementsApiProvider = AnnouncementsApiProvider._();

final class AnnouncementsApiProvider extends $FunctionalProvider<
    IAnnouncementsApi,
    IAnnouncementsApi,
    IAnnouncementsApi> with $Provider<IAnnouncementsApi> {
  AnnouncementsApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'announcementsApiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$announcementsApiHash();

  @$internal
  @override
  $ProviderElement<IAnnouncementsApi> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IAnnouncementsApi create(Ref ref) {
    return announcementsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IAnnouncementsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IAnnouncementsApi>(value),
    );
  }
}

String _$announcementsApiHash() => r'c02270bb539824f082f1c8fa548fca5dff6fb8db';
