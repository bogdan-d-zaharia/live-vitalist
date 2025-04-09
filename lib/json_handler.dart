import 'dart:convert';

abstract final class JsonHandler {
  static String decodeIndented(dynamic json) {
    return JsonEncoder.withIndent('  ').convert(json);
  }

  static dynamic convertIntsToDoubles(dynamic value) {
    if (value is int) {
      return value.toDouble();
    } else if (value is List) {
      return value.map(convertIntsToDoubles).toList();
    } else if (value is Map) {
      return value.map(
          (key, val) => MapEntry(key as String, convertIntsToDoubles(val)));
    } else {
      return value;
    }
  }

  static dynamic removeNullsDeep(dynamic value) {
    if (value is Map) {
      return value.map((k, v) => MapEntry(k, removeNullsDeep(v)))
        ..removeWhere((k, v) => v == null);
    } else if (value is List) {
      return value.map(removeNullsDeep).where((v) => v != null).toList();
    } else {
      return value;
    }
  }

  static Map<String, dynamic> forceStringKeys(Map<dynamic, dynamic> json) {
    return json.map((key, value) {
      final String newKey = key as String;

      if (value is Map<dynamic, dynamic>) {
        return MapEntry(newKey, forceStringKeys(value));
      } else if (value is List) {
        return MapEntry(newKey,
            value.map((e) => e is Map ? forceStringKeys(e) : e).toList());
      } else {
        return MapEntry(newKey, value);
      }
    });
  }

  static Map<String, dynamic> processJson(
    Map json, {
    bool intToDouble = true,
    bool removeNulls = false,
  }) {
    Map result = !removeNulls ? json : removeNullsDeep(json);
    if (intToDouble) result = convertIntsToDoubles(result);
    return forceStringKeys(result);
  }
}
