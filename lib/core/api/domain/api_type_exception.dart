class ApiTypeException implements Exception {
  final String message;
  const ApiTypeException([this.message = 'Unexpected type in API call.']);
}
