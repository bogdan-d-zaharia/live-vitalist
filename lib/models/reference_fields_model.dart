import 'package:flutter/material.dart';

import '../file_handler.dart';

abstract final class NutrientsHandler {
  // TODO: Perhaps separate the lowerLimit and upperLimit from the extra data
  // *Extra Data - The base model
  // "kcals": {
  //   "unit": "kcal",
  //   "translations": {
  //     "ENG": "Calories",
  //     "ROU": "Calorii",
  //   },
  // }

  // *Perhaps a limit map
  // "kcals": {
  //   "lowerLimit":
  // }

  /// TODO: At launch, set disabled by default.
  static Map<String, Map<String, dynamic>> model = {
    "kcals": {
      "unit": "kcal",
      "lowerLimit": 3300.0,
      "translations": {
        "ENG": "Calories",
        "ROU": "Calorii",
      },
      "tags": [
        "starred",
      ]
    },

    // Main
    "protein": {
      "unit": "g",
      "lowerLimit": 100.0,
      "translations": {
        "ENG": "Protein",
        "ROU": "Proteine",
      },
      "tags": [
        "starred",
      ]
    },
    "fats": {
      "unit": "g",
      "lowerLimit": 83.3,
      "upperLimit": 116.7,
      "translations": {
        "ENG": "Fats",
        "ROU": "Grasimi",
      }
    },
    "satFats": {
      "unit": "g",
      "upperLimit": 25.0,
      "translations": {
        "ENG": "Saturated fats",
        "ROU": "Grasimi saturate",
      }
    },
    "carbs": {
      "unit": "g",
      "lowerLimit": 375.0,
      "upperLimit": 525.0,
      "translations": {
        "ENG": "Carbohydrates",
        "ROU": "Carbohidrati",
      }
    },
    "sugars": {
      "unit": "g",
      "upperLimit": 56.0,
      "translations": {
        "ENG": "Sugars",
        "ROU": "Zaharuri",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "fibers": {
      "unit": "g",
      "lowerLimit": 38.0,
      "translations": {
        "ENG": "Fibers",
        "ROU": "Fibre",
      },
      // "tags": [
      //   "disabled",
      // ]
    },

    // Important
    "cholesterol": {
      "unit": "mg",
      "lowerLimit": 100.0,
      "upperLimit": 300.0,
      "translations": {
        "ENG": "Cholesterol",
        "ROU": "Colesterol",
      },
    },
    "omega3": {
      "unit": "g",
      "lowerLimit": 2.0,
      "upperLimit": 4.0,
      "translations": {
        "ENG": "Omega-3",
        "ROU": "Omega-3",
      },
      // "tags": [
      //   "disabled",
      // ]
    },

    // Vitamins
    "vitaminA": {
      "unit": "mcg",
      "lowerLimit": 1200.0,
      "upperLimit": 3000.0,
      "translations": {
        "ENG": "Vitamin A (Retinol)",
        "ROU": "Vitamina A (Retinol)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB1": {
      "unit": "mg",
      "lowerLimit": 1.2,
      "translations": {
        "ENG": "Vitamin B1 (Thiamin)",
        "ROU": "Vitamina B1 (Tiamina)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB2": {
      "unit": "mg",
      "lowerLimit": 1.3,
      "translations": {
        "ENG": "Vitamin B2 (Riboflavin)",
        "ROU": "Vitamina B2 (Riboflavină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB3": {
      "unit": "mg",
      "lowerLimit": 16.0,
      "upperLimit": 35.0,
      "translations": {
        "ENG": "Vitamin B3 (Niacin)",
        "ROU": "Vitamina B3 (Niacină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB4": {
      "unit": "mg",
      "lowerLimit": 550.0,
      "upperLimit": 3500.0,
      "translations": {
        "ENG": "Vitamin B4 (Choline)",
        "ROU": "Vitamina B4 (Colină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB5": {
      "unit": "mg",
      "lowerLimit": 5.0,
      "translations": {
        "ENG": "Vitamin B5 (Pantothenic acid)",
        "ROU": "Vitamina B5 (Acid pantotenic)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB6": {
      "unit": "mg",
      "lowerLimit": 1.3,
      "upperLimit": 100.0,
      "translations": {
        "ENG": "Vitamin B6 (Pyridoxine)",
        "ROU": "Vitamina B6 (Piridoxină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB7": {
      "unit": "mcg",
      "lowerLimit": 30.0,
      "translations": {
        "ENG": "Vitamin B7 (Biotin)",
        "ROU": "Vitamina B7 (Biotină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB9": {
      "unit": "mcg",
      "lowerLimit": 400.0,
      "upperLimit": 1000.0,
      "translations": {
        "ENG": "Vitamin B9 (Folate)",
        "ROU": "Vitamina B9 (Folat)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminB12": {
      "unit": "mcg",
      "lowerLimit": 2.4,
      "translations": {
        "ENG": "Vitamin B12 (Cobalamin)",
        "ROU": "Vitamina B12 (Cobalamină)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminC": {
      "unit": "mg",
      "lowerLimit": 300.0,
      "upperLimit": 2000.0,
      "translations": {
        "ENG": "Vitamin C (Ascorbic acid)",
        "ROU": "Vitamina C (Acid ascorbic)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminD2": {
      "unit": "mcg",
      "lowerLimit": 15.0,
      "upperLimit": 100.0,
      "translations": {
        "ENG": "Vitamin D2 (Ergocalciferol)",
        "ROU": "Vitamina D2 (Ergocalciferol)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminD3": {
      "unit": "mcg",
      "lowerLimit": 15.0,
      "upperLimit": 100.0,
      "translations": {
        "ENG": "Vitamin D3 (Cholecalciferol)",
        "ROU": "Vitamina D3 (Colecalciferol)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminE": {
      "unit": "mg",
      "lowerLimit": 15.0,
      "upperLimit": 1000.0,
      "translations": {
        "ENG": "Vitamin E (Alpha-tocopherol)",
        "ROU": "Vitamina E (Alfa-tocoferol)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminK1": {
      "unit": "mcg",
      "lowerLimit": 120.0,
      "translations": {
        "ENG": "Vitamin K1 (Phylloquinone)",
        "ROU": "Vitamina K1 (Filochinonă)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "vitaminK2": {
      "unit": "mcg",
      "lowerLimit": 120.0,
      "translations": {
        "ENG": "Vitamin K2 (Menaquinone)",
        "ROU": "Vitamina K2 (Menachinonă)",
      },
      // "tags": [
      //   "disabled",
      // ]
    },

    // Minerals
    "calcium": {
      "unit": "mg",
      "lowerLimit": 1000.0,
      "upperLimit": 2500.0,
      "translations": {
        "ENG": "Calcium",
        "ROU": "Calciu",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "sodium": {
      "unit": "mg",
      "lowerLimit": 1500.0,
      "upperLimit": 2300.0,
      "translations": {
        "ENG": "Sodium",
        "ROU": "Sodiu",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "potassium": {
      "unit": "mg",
      "lowerLimit": 4700.0,
      "translations": {
        "ENG": "Potassium",
        "ROU": "Potasiu",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "iron": {
      "unit": "mg",
      "lowerLimit": 8.0,
      "upperLimit": 45.0,
      "translations": {
        "ENG": "Iron",
        "ROU": "Fier",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "zinc": {
      "unit": "mg",
      "lowerLimit": 11.0,
      "upperLimit": 40.0,
      "translations": {
        "ENG": "Zinc",
        "ROU": "Zinc",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
    "magnesium": {
      "unit": "mg",
      "lowerLimit": 400.0,
      "upperLimit": 600.0,
      "translations": {
        "ENG": "Magnesium",
        "ROU": "Magneziu",
      },
      // "tags": [
      //   "disabled",
      // ]
    },
  };

  static Map<String, dynamic> toJson() {
    return model;
  }

  static void fromJson(Map<String, dynamic> json) {
    model = json.map((key, value) => MapEntry(key, value));
    // <String, Map<String, dynamic>>
  }

  static Future<void> save() async {
    return StorageHandler.saveJson('nutrients', toJson(), doBackup: true);
  }

  static Future<void> load() async {
    try {
      final json = await StorageHandler.loadJson('nutrients');
      if (json.isNotEmpty) fromJson(json);
    } catch (e) {
      //  ignore: empty_catches
    }
  }

  // #region //* FUNCTIONS FOR HANDLING FIELDS. *//

  static double linearMap(
      double value, double inMin, double inMax, double outMin, double outMax) {
    final double inLength = inMax - inMin;
    final double outLength = outMax - outMin;
    final double inNormalised = (value - inMin) / inLength;
    return inNormalised * outLength + outMin;
    // return outMin + ((value - inMin) * (outMax - outMin) / (inMax - inMin));
  }

  /// TODO: Optimise.
  /// [0.0, lower]    -> [0.0, 1.0]
  /// [lower, upper]  -> 1.0
  /// [lower, inf]    -> [1.0, inf]
  /// [0.0, upper]    -> [0.0, 1.0]
  /// [upper, inf]    -> [1.0, inf]
  ///
  /// ABS:
  /// [0.0, lower]    -> [0.0, 1.0]
  /// [lower, inf]    -> 1.0
  /// [lower, upper]  -> 1.0
  /// [0.0, upper]    -> 1.0, ( lower in [0.0, upper] )
  /// [upper, inf]    -> [1.0, inf]
  static double? getRatio(
      double? amount, double? lower, double? upper, bool abs) {
    if (amount == null || (lower == null && upper == null)) return null;

    if (!abs) {
      if (lower != null) {
        if (amount <= lower) {
          return amount / lower;
        }
        if (upper != null && amount <= upper) {
          return 1;
        }
        return amount / lower;
      }

      /// (upper != null) surely.
      return amount / upper!;

      // if (lower != null && amount <= lower) {
      //   return linearMap(amount, 0.0, lower, -1.0, 0.0);
      // } else if ((lower != null && amount >= lower) &&
      //     (upper != null && amount <= upper)) {
      //   return linearMap(amount, lower, upper, 0.0, 1.0);
      // } else if (upper != null) {
      //   return amount / upper;
      // }
    } else {
      if (lower != null && amount <= lower) {
        return linearMap(amount, 0.0, lower, 0.0, 1.0);
      } else if (lower != null && upper == null) {
        return 1.0;
      } else if (upper != null) {
        if (amount <= upper) return 1.0;
        return amount / upper;
      }
    }

    return null;
  }

  static double? getFieldRatio(double amount, String field) {
    final double? lower = NutrientsHandler.model[field]!['lowerLimit'];
    final double? upper = NutrientsHandler.model[field]!['upperLimit'];
    return getRatio(amount, lower, upper, true);
  }

  //TODO: Imported material for this alone.
  // Perhaps move, if it's not this function's place.
  static List<Widget> widMajorMinorLabels(String label, {TextStyle? style}) {
    style ??= TextStyle(letterSpacing: -0.0);

    var x = label.indexOf('(');
    x = x != -1 ? x : label.length;

    final label1 = label.substring(0, x);
    final label2 = label.substring(x);
    return [
      Text(label1, style: style),
      Text(
        label2,
        style: style.copyWith(
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    ];
  }

  /* Tags */
  static List<String> getTags(String field) {
    final List<dynamic> protoTags =
        NutrientsHandler.model[field]!['tags'] ?? [];
    return protoTags.map((e) => e as String).toList();
  }

  static bool hasTag(String field, String tag) {
    return getTags(field).contains(tag);
  }

  static List<Widget> tagsToWidgets(List<String> tags) {
    final List<Widget> result = [];

    if (tags.contains('starred')) {
      result.add(Icon(Icons.star_rounded));
    }

    return result;
  }

  // #endregion //* FUNCTIONS FOR HANDLING FIELDS. *//
}
