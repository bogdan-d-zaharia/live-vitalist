import 'package:live_vitalist/core/domain/intervals.dart';

class NormalizationData {
  final double startPoint;
  final double endPoint;
  final double fallback;

  const NormalizationData({
    required this.startPoint,
    required this.endPoint,
    required this.fallback,
  });

  static const NormalizationData preset = NormalizationData(
    startPoint: 1.0 / 3.0,
    endPoint: 2.0 / 3.0,
    fallback: 0.8,
  );

  static const NormalizationData thirds = NormalizationData(
    startPoint: 1.0 / 3.0,
    endPoint: 2.0 / 3.0,
    fallback: 2.0 / 3.0,
  );
}

extension StrictIntervalNormalization on StrictInterval {
  StrictInterval normalize(NormalizationData nd) {
    late double v;
    if (value <= start) {
      v = value * nd.startPoint / start;
    } else if (value <= end) {
      final distance = value - start;
      final conversion = (nd.endPoint - nd.startPoint) / (end - start);
      v = nd.startPoint + distance * conversion;
    } else {
      final distance = value - end;
      final conversion = (1.0 - nd.endPoint) / start;
      v = nd.endPoint + distance * conversion;
    }
    return StrictInterval(
      value: v,
      start: nd.startPoint,
      end: nd.endPoint,
    );
  }
}

extension LooseIntervalNormalization on LooseInterval {
  StrictInterval normalize(NormalizationData nd) {
    if (start != null && end != null) {
      return StrictInterval(
        value: value,
        start: start!,
        end: end!,
      ).normalize(nd);
    } else if (end != null) {
      return StrictInterval(
        value: value * nd.fallback / end!,
        start: 0.0,
        end: nd.fallback,
      );
    } else if (start != null) {
      return StrictInterval(
        value: value * nd.fallback / start!,
        start: nd.fallback,
        end: 1.0,
      );
    } else {
      return StrictInterval(
        value: 1.0,
        start: 0.0,
        end: 1.0,
      );
    }
  }
}
