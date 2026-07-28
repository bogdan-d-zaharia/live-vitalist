// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'legal_handler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(legalHandler)
final legalHandlerProvider = LegalHandlerProvider._();

final class LegalHandlerProvider
    extends $FunctionalProvider<ILegalHandler, ILegalHandler, ILegalHandler>
    with $Provider<ILegalHandler> {
  LegalHandlerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'legalHandlerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$legalHandlerHash();

  @$internal
  @override
  $ProviderElement<ILegalHandler> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ILegalHandler create(Ref ref) {
    return legalHandler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ILegalHandler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ILegalHandler>(value),
    );
  }
}

String _$legalHandlerHash() => r'3e06702ba5e0532fb078d4a5a8710855bc36b445';
