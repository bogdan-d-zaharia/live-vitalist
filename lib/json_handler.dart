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

  /// Converts maps to lists from nested structures.
  static dynamic mapToListRecursive(dynamic value) {
    if (value is Map) {
      return value.entries.map((entry) {
        return {'k': entry.key, 'v': mapToListRecursive(entry.value)};
      }).toList();
    } else if (value is List) {
      return value.map((e) {
        return mapToListRecursive(e);
      }).toList();
    } else {
      return value;
    }
  }

  static dynamic reverseMapToListRecursive(dynamic value) {
    /// 'v' might not exist because firebase doesn't store empty maps or lists.
    bool isValidMap(dynamic e) {
      return (e is Map) && e.containsKey('k') && (e.length <= 2);
    }

    if (value is List) {
      if (value.isNotEmpty && value.every(isValidMap)) {
        return Map.fromEntries(value
            .map((e) => MapEntry(e['k']!, reverseMapToListRecursive(e['v']))));
      } else {
        return value.map(reverseMapToListRecursive).toList();
      }
    } else {
      return value;
    }
  }
}
