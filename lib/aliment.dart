import 'file_handler.dart';
import 'models/reference_fields_model.dart';

/// This class will search for the aliment in the aliment bank
/// and scale it to the serving size.
class ServedAliment {
  ServedAliment({
    required this.alimentID,
    required this.servingSize,

    /// String? unit,
  })

  ///  : unit = unit ?? AlimentBank.aliments[alimentID]!.units.keys.first
  ;

  String alimentID;
  double servingSize;

  /// String unit;

  Map<String, double> get fields {
    Aliment? aliment = AlimentBank.aliments[alimentID];
    if (aliment == null) throw Exception("Aliment not found!");

    Map<String, double> result = {};

    for (final field in NutrientsHandler.model.keys) {
      /// TODO: Perhaps use .contains()
      if (aliment.referenceFields[field] != null) {
        result[field] = aliment.referenceFields[field]! *
            servingSize /
            aliment.referenceSize;
      }
    }

    return result;
  }

  Map<String, Object> toJson() {
    return {
      'alimentID': alimentID,
      'servingSize': servingSize,
    };
  }

  factory ServedAliment.fromJson(Map<String, dynamic> json) {
    return ServedAliment(
      alimentID: json['alimentID'],
      servingSize: json['servingSize'],
    );
  }

  @override
  String toString() {
    return toJson().toString();
  }
}

/// This class stores, saves and loads the defined aliments.
abstract final class AlimentBank {
  static Map<String, Aliment> aliments = {};

  static Map<String, dynamic> toJson() {
    return aliments.map(
      (id, aliment) => MapEntry(id, aliment.toJson()),
    );
  }

  static void fromJson(Map<String, dynamic> json) {
    aliments = json.map(
      (id, alimentJson) => MapEntry(id, Aliment.fromJson(alimentJson)),
    );
  }

  /// [ IO_FUNCTION ]
  static Future<void> save() async {
    return FileHandler.saveJsonAndBackup(toJson(), name: 'alimentBank');
  }

  /// [ IO_FUNCTION ]
  static Future<void> load() async {
    return FileHandler.loadJson(name: 'alimentBank').then((json) {
      fromJson(json);
    });
  }
}

class Aliment {
  Aliment({
    required this.name,
    required this.referenceSize,
  });

  String name;
  double referenceSize;

  /// Keeping them separated so that they can take default values if not set.
  Map<String, double> referenceFields = {};

  /// Map<String, double> units = {'g': 1.0};

  /// TODO: Not used
  void setField(String fieldName, double amount) {
    if (!NutrientsHandler.model.containsKey(fieldName)) {
      throw Exception('FIELD DOES NOT EXISTS!');
    }

    referenceFields[fieldName] = amount;
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'referenceSize': referenceSize,
      'referenceFields': referenceFields,

      /// 'units': units,
    };
  }

  factory Aliment.fromJson(Map<String, dynamic> json) {
    Aliment result = Aliment(
      name: json['name'] as String,
      referenceSize: json['referenceSize'] as double,
    );

    result.referenceFields = (json['referenceFields'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as double));

    /// final Map<String, double> units = (json['units'] as Map<String, dynamic>)
    ///     .map((key, value) => MapEntry(key, value as double));
    /// if (units.isNotEmpty) result.units = units;

    return result;
  }
}
