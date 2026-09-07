// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(NotificationHandler)
final notificationHandlerProvider = NotificationHandlerProvider._();

final class NotificationHandlerProvider
    extends $AsyncNotifierProvider<NotificationHandler, bool?> {
  NotificationHandlerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'notificationHandlerProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$notificationHandlerHash();

  @$internal
  @override
  NotificationHandler create() => NotificationHandler();
}

String _$notificationHandlerHash() =>
    r'206bbed19eb8b63f45a256ecd808768c065346cd';

abstract class _$NotificationHandler extends $AsyncNotifier<bool?> {
  FutureOr<bool?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool?>, bool?>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<AsyncValue<bool?>, bool?>,
        AsyncValue<bool?>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
