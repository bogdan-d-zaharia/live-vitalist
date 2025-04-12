import 'dart:collection';

import 'file_handler.dart';
import 'models/reference_fields_model.dart';

abstract class Aliment {
  /// There will always be a default unit.
  Aliment({
    required this.servingSize,
    this.unit,
  });

  double servingSize;
  String? unit;

  AlimentData get getAliment;

  Map<String, double> get fields;

  Map<String, dynamic> toJson();

  @override
  String toString() {
    return toJson().toString();
  }
}

class TemporaryAliment extends Aliment {
  /// There will always be a default unit.
  TemporaryAliment({
    required this.alimentData,
    required super.servingSize,
    super.unit,
  });

  AlimentData alimentData;

  @override
  AlimentData get getAliment => alimentData;

  @override
  Map<String, double> get fields {
    Map<String, double> result = {};

    /* Doesn't output supplimentary fields. */
    for (final field in NutrientsHandler.model.keys) {
      if (alimentData.referenceFields.containsKey(field)) {
        result[field] = alimentData.referenceFields[field]! *
            servingSize /
            alimentData.referenceSize *
            (alimentData.unitSizes?[unit] ?? 1.0);
      }
    }

    return result;
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'alimentData': alimentData.toJson(),
      'servingSize': servingSize,
      if (unit != null) 'unit': unit!,
    };
  }

  factory TemporaryAliment.fromJson(Map<String, dynamic> json) {
    return TemporaryAliment(
      alimentData: AlimentData.fromJson(json['alimentData']),
      servingSize: json['servingSize'],
      unit: json['unit'],
    );
  }
}

/// This class will search for the aliment in the aliment bank
/// and scale it to the serving size.
class InstancedAliment extends Aliment {
  /// There will always be a default unit.
  InstancedAliment({
    required this.alimentID,
    required super.servingSize,
    super.unit,
  });

  String alimentID;

  @override
  AlimentData get getAliment => AlimentBank.getAliment(alimentID);

  @override
  Map<String, double> get fields {
    final AlimentData aliment = AlimentBank.getAliment(alimentID);

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

  @override
  Map<String, Object> toJson() {
    return {
      'alimentID': alimentID,
      'servingSize': servingSize,
      if (unit != null) 'unit': unit!,
    };
  }

  factory InstancedAliment.fromJson(Map<String, dynamic> json) {
    return InstancedAliment(
      alimentID: json['alimentID'],
      servingSize: json['servingSize'],
      unit: json['unit'],
    );
  }
}

/// This class stores, saves and loads the defined aliments.
abstract final class AlimentBank {
  static Map<String, AlimentData> aliments = {};
  static Queue<String> mruIDs = Queue<String>();

  static AlimentData getAliment(String alimentID) {
    final AlimentData? aliment = AlimentBank.aliments[alimentID];
    if (aliment == null) throw Exception("Aliment not found!");
    return aliment;
  }

  static void moveToFront(String alimentID) {
    if (!aliments.containsKey(alimentID)) return;

    mruIDs.remove(alimentID); /* Remove if existing. */
    mruIDs.addFirst(alimentID);
  }

  static List<String> get sortedKeys {
    return mruIDs.toList()
      ..addAll(aliments.keys.where((id) => !mruIDs.contains(id)));
  }

  static Map<String, dynamic> toJson() {
    return {
      'aliments': aliments.map((id, aliment) => MapEntry(id, aliment.toJson())),
      'mruIDs': mruIDs.toList(),
    };
  }

  static void fromJson(Map<String, dynamic> json) {
    if (!json.containsKey('aliments')) {
      aliments = json.map(
          (id, alimentJson) => MapEntry(id, AlimentData.fromJson(alimentJson)));
    } else {
      aliments = (json['aliments'] as Map<String, dynamic>)
          .map<String, AlimentData>((id, alimentJson) =>
              MapEntry(id, AlimentData.fromJson(alimentJson)));
    }

    if (json.containsKey('mruIDs')) {
      mruIDs = Queue<String>.from(json['mruIDs']);
    }
  }

  /// [ IO_FUNCTION ]
  static Future<void> save() async {
    return StorageHandler.saveJson('alimentBank', toJson(), doBackup: true);
  }

  /// [ IO_FUNCTION ]
  static Future<void> load() async {
    return StorageHandler.loadJson('alimentBank').then((json) {
      fromJson(json ?? {});
    });
  }
}

class AlimentData {
  AlimentData({
    required this.name,
    required this.referenceSize,
  });

  String name;
  double referenceSize;

  /* Keeping them separated so that they can take default values if not set. */
  Map<String, double> referenceFields = {};
  Map<String, double>? unitSizes;

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'referenceSize': referenceSize,
      'referenceFields': referenceFields,
      if (unitSizes != null && unitSizes!.isNotEmpty) 'unitSizes': unitSizes,
    };
  }

  factory AlimentData.fromJson(Map<String, dynamic> json) {
    AlimentData result = AlimentData(
      name: json['name'] as String,
      referenceSize: json['referenceSize'] as double,
    );

    if (json.containsKey('referenceFields')) {
      result.referenceFields = (json['referenceFields'] as Map<String, dynamic>)
          .map((key, value) => MapEntry(key, value as double));
    }

    result.unitSizes = (json['unitSizes'] as Map<String, dynamic>?)
        ?.map((key, value) => MapEntry(key, value as double));

    return result;
  }
}
