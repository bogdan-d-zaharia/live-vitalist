// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'day_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SelectedDates)
final selectedDatesProvider = SelectedDatesProvider._();

final class SelectedDatesProvider
    extends $NotifierProvider<SelectedDates, List<DateTime>> {
  SelectedDatesProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedDatesProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedDatesHash();

  @$internal
  @override
  SelectedDates create() => SelectedDates();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<DateTime> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<DateTime>>(value),
    );
  }
}

String _$selectedDatesHash() => r'41a9ca0670076b20f8ef210a7688829ee4c0570b';

abstract class _$SelectedDates extends $Notifier<List<DateTime>> {
  List<DateTime> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<DateTime>, List<DateTime>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<DateTime>, List<DateTime>>,
        List<DateTime>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.

@ProviderFor(DayCache)
final dayCacheProvider = DayCacheProvider._();

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.
final class DayCacheProvider
    extends $NotifierProvider<DayCache, Map<DateTime, Day>> {
  /// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.
  DayCacheProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayCacheProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$dayCacheHash();

  @$internal
  @override
  DayCache create() => DayCache();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<DateTime, Day> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<DateTime, Day>>(value),
    );
  }
}

String _$dayCacheHash() => r'1e31dab2324059be675800d4c49f872d92bf842a';

/// Reactive `Map<DateTime, Day>`, loaded on demand, auto-saved on edit.

abstract class _$DayCache extends $Notifier<Map<DateTime, Day>> {
  Map<DateTime, Day> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<DateTime, Day>, Map<DateTime, Day>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<Map<DateTime, Day>, Map<DateTime, Day>>,
        Map<DateTime, Day>,
        Object?,
        Object?>;
    return element.handleCreate(ref, build);
  }
}

/// Returns the list of Day objects for currently selected dates

@ProviderFor(selectedDays)
final selectedDaysProvider = SelectedDaysProvider._();

/// Returns the list of Day objects for currently selected dates

final class SelectedDaysProvider extends $FunctionalProvider<
        AsyncValue<List<Day>>, List<Day>, FutureOr<List<Day>>>
    with $FutureModifier<List<Day>>, $FutureProvider<List<Day>> {
  /// Returns the list of Day objects for currently selected dates
  SelectedDaysProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'selectedDaysProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$selectedDaysHash();

  @$internal
  @override
  $FutureProviderElement<List<Day>> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<List<Day>> create(Ref ref) {
    return selectedDays(ref);
  }
}

String _$selectedDaysHash() => r'b38f41b29882f0c9eb686a6bb326e434be264ad7';

@ProviderFor(CachedSelectedDays)
final cachedSelectedDaysProvider = CachedSelectedDaysProvider._();

final class CachedSelectedDaysProvider
    extends $NotifierProvider<CachedSelectedDays, List<Day>> {
  CachedSelectedDaysProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'cachedSelectedDaysProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$cachedSelectedDaysHash();

  @$internal
  @override
  CachedSelectedDays create() => CachedSelectedDays();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Day> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Day>>(value),
    );
  }
}

String _$cachedSelectedDaysHash() =>
    r'b403d69291038299bd330023bef7a8ad642e5f7f';

abstract class _$CachedSelectedDays extends $Notifier<List<Day>> {
  List<Day> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<Day>, List<Day>>;
    final element = ref.element as $ClassProviderElement<
        AnyNotifier<List<Day>, List<Day>>, List<Day>, Object?, Object?>;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(averageDayCached)
final averageDayCachedProvider = AverageDayCachedProvider._();

final class AverageDayCachedProvider extends $FunctionalProvider<Day, Day, Day>
    with $Provider<Day> {
  AverageDayCachedProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'averageDayCachedProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$averageDayCachedHash();

  @$internal
  @override
  $ProviderElement<Day> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Day create(Ref ref) {
    return averageDayCached(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Day value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Day>(value),
    );
  }
}

String _$averageDayCachedHash() => r'e652e68b9a80c444969b8a225698bfe540e472ee';
