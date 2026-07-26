class LooseInterval {
  final double value;
  final double? start;
  final double? end;

  const LooseInterval({
    required this.value,
    this.start,
    this.end,
  });
}

class StrictInterval {
  final double value;
  final double start;
  final double end;

  const StrictInterval({
    required this.value,
    required this.start,
    required this.end,
  });

  const StrictInterval.unitary({
    required this.value,
  })  : start = 0.0,
        end = 1.0;
}
