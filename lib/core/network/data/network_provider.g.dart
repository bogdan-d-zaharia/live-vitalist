// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(network)
final networkProvider = NetworkProvider._();

final class NetworkProvider
    extends $FunctionalProvider<INetwork, INetwork, INetwork>
    with $Provider<INetwork> {
  NetworkProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'networkProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$networkHash();

  @$internal
  @override
  $ProviderElement<INetwork> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  INetwork create(Ref ref) {
    return network(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(INetwork value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<INetwork>(value),
    );
  }
}

String _$networkHash() => r'85df3dd5a1c166adab58c73c9b48523cbfd8492e';
