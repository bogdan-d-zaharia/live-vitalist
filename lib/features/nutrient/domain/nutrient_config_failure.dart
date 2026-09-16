enum NutrientConfigFailureReason { notFound, selectionChanged, dayChanged }

class NutrientConfigFailure implements Exception {
  final NutrientConfigFailureReason reason;
  final String? configId;

  const NutrientConfigFailure(this.reason, {this.configId});
}
