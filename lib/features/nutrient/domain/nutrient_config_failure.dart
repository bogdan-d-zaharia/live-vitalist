enum NutrientConfigFailureReason {
  notFound,
  selectionChanged,
  dayChanged,
  lastConfig
}

class NutrientConfigFailure implements Exception {
  final NutrientConfigFailureReason reason;
  final String? configId;

  const NutrientConfigFailure(this.reason, {this.configId});
}
