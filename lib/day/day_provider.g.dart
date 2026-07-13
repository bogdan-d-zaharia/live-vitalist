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

String _$dayCacheHash() => r'b05aaf653a758b2b40756b7c02116c044eda6bfa';

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

String _$selectedDaysHash() => r'85e1606a4fb0e4050d89467cce31227f4aecc706';

@ProviderFor(averagedDay)
final averagedDayProvider = AveragedDayProvider._();

final class AveragedDayProvider extends $FunctionalProvider<Day, Day, Day>
    with $Provider<Day> {
  AveragedDayProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'averagedDayProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$averagedDayHash();

  @$internal
  @override
  $ProviderElement<Day> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Day create(Ref ref) {
    return averagedDay(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Day value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Day>(value),
    );
  }
}

String _$averagedDayHash() => r'3bcffc747d034d3a3eef6ee017d09ee92906076b';
