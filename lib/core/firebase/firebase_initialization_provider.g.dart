// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'firebase_initialization_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(firebaseInitialization)
final firebaseInitializationProvider = FirebaseInitializationProvider._();

final class FirebaseInitializationProvider
    extends $FunctionalProvider<AsyncValue<void>, void, FutureOr<void>>
    with $FutureModifier<void>, $FutureProvider<void> {
  FirebaseInitializationProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'firebaseInitializationProvider',
          isAutoDispose: false,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$firebaseInitializationHash();

  @$internal
  @override
  $FutureProviderElement<void> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<void> create(Ref ref) {
    return firebaseInitialization(ref);
  }
}

String _$firebaseInitializationHash() =>
    r'6378f5b3a55b3aa699ff6f410627c0ad15102c97';
