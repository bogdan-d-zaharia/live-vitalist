// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

final class OnboardingControllerProvider
    extends $NotifierProvider<OnboardingController, OnboardingControllerState> {
  OnboardingControllerProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'onboardingControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingControllerState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingControllerState>(value),
    );
  }
}

String _$onboardingControllerHash() =>
    r'38492e6ee2bdf2f822b75abe63cf3d86e2a74105';

abstract class _$OnboardingController
    extends $Notifier<OnboardingControllerState> {
  OnboardingControllerState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<OnboardingControllerState, OnboardingControllerState>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<OnboardingControllerState, OnboardingControllerState>,
        OnboardingControllerState,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}
