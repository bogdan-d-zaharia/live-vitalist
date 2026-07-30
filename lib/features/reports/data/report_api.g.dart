// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportApi)
final reportApiProvider = ReportApiProvider._();

final class ReportApiProvider
    extends $FunctionalProvider<IReportApi, IReportApi, IReportApi>
    with $Provider<IReportApi> {
  ReportApiProvider._()
      : super(
          from: null,
          argument: null,
          retry: null,
          name: r'reportApiProvider',
          isAutoDispose: true,
          dependencies: null,
          $allTransitiveDependencies: null,
        );

  @override
  String debugGetCreateSourceHash() => _$reportApiHash();

  @$internal
  @override
  $ProviderElement<IReportApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  IReportApi create(Ref ref) {
    return reportApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(IReportApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<IReportApi>(value),
    );
  }
}

String _$reportApiHash() => r'7770c7990f60a7d1d8bf787c582f40f78cabefd2';
