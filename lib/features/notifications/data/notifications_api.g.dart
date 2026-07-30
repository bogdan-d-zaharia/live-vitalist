// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(notificationsApi)
final notificationsApiProvider = NotificationsApiProvider._();

final class NotificationsApiProvider extends $FunctionalProvider<
    INotificationsApi,
    INotificationsApi,
    INotificationsApi> with $Provider<INotificationsApi> {
  NotificationsApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationsApiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationsApiHash();

  @$internal
  @override
  $ProviderElement<INotificationsApi> $createElement(
          $ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INotificationsApi create(Ref ref) {
    return notificationsApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INotificationsApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INotificationsApi>(value),
    );
  }
}

String _$notificationsApiHash() => r'b01469c31fa1996b8505f3afd24ab818a7ed2117';
