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

String _$selectedDatesHash() => r'f0888036ec0a49ac8f4e08957c7522f23ea0a6e3';

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

/// `Map<DateTime, Day>`

@ProviderFor(DayCache)
final dayCacheProvider = DayCacheProvider._();

/// `Map<DateTime, Day>`
final class DayCacheProvider
    extends $NotifierProvider<DayCache, Map<DateTime, Day>> {
  /// `Map<DateTime, Day>`
  DayCacheProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'dayCacheProvider',
          isAutoDispose: false,
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

String _$dayCacheHash() => r'e4d517de5ca04165890884e453b72b6983a5897c';

/// `Map<DateTime, Day>`

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

@ProviderFor(syncSelectedDays)
final syncSelectedDaysProvider = SyncSelectedDaysProvider._();

final class SyncSelectedDaysProvider
    extends $FunctionalProvider<List<Day>?, List<Day>?, List<Day>?>
    with $Provider<List<Day>?> {
  SyncSelectedDaysProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncSelectedDaysProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncSelectedDaysHash();

  @$internal
  @override
  $ProviderElement<List<Day>?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  List<Day>? create(Ref ref) {
    return syncSelectedDays(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Day>? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Day>?>(value),
    );
  }
}

String _$syncSelectedDaysHash() => r'6608a212387593c21a79ee2f8e34dec85ab7f979';

@ProviderFor(syncAverageDay)
final syncAverageDayProvider = SyncAverageDayProvider._();

final class SyncAverageDayProvider extends $FunctionalProvider<Day, Day, Day>
    with $Provider<Day> {
  SyncAverageDayProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'syncAverageDayProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$syncAverageDayHash();

  @$internal
  @override
  $ProviderElement<Day> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Day create(Ref ref) {
    return syncAverageDay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Day value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Day>(value),
    );
  }
}

String _$syncAverageDayHash() => r'37215235fbaf4cc70ff6b4a8d6954881490fa5f8';
