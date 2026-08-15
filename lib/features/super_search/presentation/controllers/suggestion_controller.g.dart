// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'suggestion_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SuggestionController)
final suggestionControllerProvider = SuggestionControllerFamily._();

final class SuggestionControllerProvider
    extends $NotifierProvider<SuggestionController, int> {
  SuggestionControllerProvider._(
      {required SuggestionControllerFamily super.from,
      required SuperBarSuggestions super.argument})
      : super(
          retry: null,
          name: r'suggestionControllerProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$suggestionControllerHash();

  @override
  String toString() {
    return r'suggestionControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SuggestionController create() => SuggestionController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SuggestionControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suggestionControllerHash() =>
    r'b05588337b00c129625ad646fe4a46edcae14633';

final class SuggestionControllerFamily extends $Family
    with
        $ClassFamilyOverride<SuggestionController, int, int, int,
            SuperBarSuggestions> {
  SuggestionControllerFamily._()
      : super(
          retry: null,
          name: r'suggestionControllerProvider',
          dependencies: null,
          $allTransitiveDependencies: null,
          isAutoDispose: true,
        );

  SuggestionControllerProvider call(
    SuperBarSuggestions suggestions,
  ) =>
      SuggestionControllerProvider._(argument: suggestions, from: this);

  @override
  String toString() => r'suggestionControllerProvider';
}

abstract class _$SuggestionController extends $Notifier<int> {
  late final _$args = ref.$arg as SuperBarSuggestions;
  SuperBarSuggestions get suggestions => _$args;

  int build(
    SuperBarSuggestions suggestions,
  );
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<int, int>;
    final element = ref.element
        as $ClassProviderElement<AnyNotifier<int, int>, int, Object?, Object?>;
    return element.handleCreate(
        ref,
        () => build(
              _$args,
            ));
  }
}
