// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_check_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appCheck)
final appCheckProvider = AppCheckProvider._();

final class AppCheckProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  AppCheckProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'appCheckProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$appCheckHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return appCheck(ref);
  }
}

String _$appCheckHash() => r'a767159780b5e664269e72c468487db718201542';
