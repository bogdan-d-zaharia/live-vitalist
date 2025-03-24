import 'file_handler.dart';
import 'models/reference_fields_model.dart';

/// This class will search for the aliment in the aliment bank
/// and scale it to the serving size.
class ServedAliment {
  /// There will always be a default unit.
  ///
  /// Priority:
  /// `aliment` `<` `alimentID`
  ServedAliment({
    required this.alimentID,
    Aliment? aliment,
    required this.servingSize,
    this.unit,
  }) : _aliment = aliment;

  String? alimentID;
  Aliment? _aliment;
  double servingSize;
  String? unit;

  Aliment get aliment {
    if (alimentID != null) {
      return AlimentBank.getAliment(alimentID!);
    } else if (_aliment != null) {
      return _aliment!;
    } else {
      throw Exception(
          "There must be defined at least one between 'alimentID' and 'aliment'.");
    }
  }

  set aliment(Aliment other) {
    alimentID = null;
    _aliment = other;
  }

  Map<String, double> get fields {
    Map<String, double> result = {};

    for (final field in NutrientsHandler.model.keys) {
      if (aliment.referenceFields.containsKey(field)) {
        result[field] = aliment.referenceFields[field]! *
            servingSize /
            aliment.referenceSize *
            (aliment.unitSizes?[unit] ?? 1.0);
      }
    }

    return result;
  }

  Map<String, Object> toJson() {
    return {
      if (alimentID != null) 'alimentID': alimentID!,
      'servingSize': servingSize,
      if (unit != null) 'unit': unit!,
      if (alimentID == null) 'aliment': aliment.toJson(),
    };
  }

  factory ServedAliment.fromJson(Map<String, dynamic> json) {
    return ServedAliment(
      alimentID: json['alimentID'],
      servingSize: json['servingSize'],
      unit: json['unit'],
      aliment: json.containsKey('aliment')
          ? Aliment.fromJson(json['aliment'])
          : null,
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

  static Aliment getAliment(String alimentID) {
    Aliment? aliment = AlimentBank.aliments[alimentID];
    if (aliment == null) throw Exception("Aliment not found!");
    return aliment;
  }

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

  /* Keeping them separated so that they can take default values if not set. */
  Map<String, double> referenceFields = {};
  Map<String, double>? unitSizes;

  //TODO: Not used
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
      if (unitSizes != null && unitSizes!.isNotEmpty) 'unitSizes': unitSizes,
    };
  }

  factory Aliment.fromJson(Map<String, dynamic> json) {
    Aliment result = Aliment(
      name: json['name'] as String,
      referenceSize: json['referenceSize'] as double,
    );

    result.referenceFields = (json['referenceFields'] as Map<String, dynamic>)
        .map((key, value) => MapEntry(key, value as double));

    result.unitSizes = (json['unitSizes'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, value as double));

    return result;
  }
}
