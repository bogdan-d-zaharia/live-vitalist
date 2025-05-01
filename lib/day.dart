import 'aliment.dart';
import 'file_handler.dart';
import 'package:intl/intl.dart' as intl;

class Day {
  /// Creates an empty day.
  Day();

  List<Aliment> breakfast = [];
  List<Aliment> lunch = [];
  List<Aliment> dinner = [];

  Map<String, double>? _cachedIntake;

  static Map<String, double> sumFields(List<Aliment> aliments) {
    final Map<String, double> result = {};

    for (var aliment in aliments) {
      //! WARNING: Summation happening multiple times.
      final Map<String, double> servedFields = aliment.fields;

      for (final field in servedFields.keys) {
        result[field] = (result[field] ?? 0.0) + servedFields[field]!;
      }
    }

    return result;
  }

  Map<String, double> get intake {
    _cachedIntake ??= sumFields([...breakfast, ...lunch, ...dinner]);
    return _cachedIntake!;
  }

  Map<String, dynamic> toJson() {
    return {
      'breakfast': breakfast.map((e) => e.toJson()).toList(),
      'lunch': lunch.map((e) => e.toJson()).toList(),
      'dinner': dinner.map((e) => e.toJson()).toList(),
    };
  }

  void fromJson(Map<String, dynamic> json) {
    if (json['breakfast'] != null) {
      breakfast = (json['breakfast']! as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).containsKey('alimentID')
              ? InstancedAliment.fromJson(e)
              : TemporaryAliment.fromJson(e))
          .toList();
    }

    if (json['lunch'] != null) {
      lunch = (json['lunch']! as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).containsKey('alimentID')
              ? InstancedAliment.fromJson(e)
              : TemporaryAliment.fromJson(e))
          .toList();
    }

    if (json['dinner'] != null) {
      dinner = (json['dinner']! as List<dynamic>)
          .map((e) => (e as Map<String, dynamic>).containsKey('alimentID')
              ? InstancedAliment.fromJson(e)
              : TemporaryAliment.fromJson(e))
          .toList();
    }
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used,
  /// as such, hours, minutes, seconds etc. don't matter.
  Future<void> save(DateTime date) async {
    _cachedIntake = sumFields([...breakfast, ...lunch, ...dinner]);
    final fileName = intl.DateFormat('d_M_y').format(date);
    return StorageHandler.saveJson(fileName, toJson());
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used,
  /// as such, hours, minutes, seconds etc. don't matter.
  Future<bool> load(DateTime date) async {
    //TODO: Perhaps merge days when logging in to cloud.
    final fileName = intl.DateFormat('d_M_y').format(date);
    final json = await StorageHandler.loadJson(fileName);
    fromJson(json ?? {});
    return json != null;
  }

  List<Aliment> totalAliments() {
    /* We broke the `instancedAliment` into its 2 components,
     the String `alimentID` and the double `servingSize`. */

    /* `totalInstancedAliments` */
    final Map<String, double> tias = {};
    /* `totalTemporaryAliments` */
    final List<TemporaryAliment> ttas = [];

    for (final List<Aliment> meal in [breakfast, lunch, dinner]) {
      for (final Aliment sa in meal) {
        if (sa is InstancedAliment) {
          //TODO: Persistant unit, if only `medium` is used express in portions,
          // else in the desired 1.0 unit like grams.

          final double unitScale = sa.getAliment.unitSizes?[sa.unit] ?? 1.0;
          tias[sa.alimentID] =
              (tias[sa.alimentID] ?? 0.0) + sa.servingSize * unitScale;
        } else if (sa is TemporaryAliment) {
          ttas.add(sa);
        }
      }
    }

    final List<Aliment> totalServedAliments = tias.entries
        .map<Aliment>(
            (e) => InstancedAliment(alimentID: e.key, servingSize: e.value))
        .toList()
      ..addAll(ttas);

    return totalServedAliments;
  }

  Map<Aliment, double> topIntakeAliments(String nutrient, {trim = true}) {
    /* Start unsorted. */
    /* ~ {'Egg': 500.0 vitA, 'Potato: 10.0 vitA'}, then sort by value. */
    final Map<Aliment, double> result = totalAliments()
        .asMap()
        .map((key, value) => MapEntry(value, value.fields[nutrient] ?? 0.0))
      ..removeWhere((key, value) => ((trim) && (value == 0.0)));

    /* Return sorted. */
    return Map.fromEntries(result.entries.toList()
      ..sort((a, b) => (b.value - a.value).sign.toInt()));
  }

  factory Day.sumDays(List<Day> days) {
    final Day day = Day();
    for (final Day subday in days) {
      day.breakfast.addAll(subday.breakfast);
      day.lunch.addAll(subday.lunch);
      day.dinner.addAll(subday.dinner);
    }
    return day;
  }
}
