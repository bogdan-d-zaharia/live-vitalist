import 'aliment.dart';
import 'file_handler.dart';

class Day {
  /// Creates an empty day.
  Day();

  List<ServedAliment> breakfast = [];
  List<ServedAliment> lunch = [];
  List<ServedAliment> dinner = [];

  Map<String, double>? _cachedIntake;

  static Map<String, double> sumFields(List<ServedAliment> servedAliments) {
    final Map<String, double> result = {};

    for (var servedAliment in servedAliments) {
      //! WARNING: Summation happening multiple times.
      final Map<String, double> servedFields = servedAliment.fields;

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
          .map((e) => ServedAliment.fromJson(e))
          .toList();
    }

    if (json['lunch'] != null) {
      lunch = (json['lunch']! as List<dynamic>)
          .map((e) => ServedAliment.fromJson(e))
          .toList();
    }

    if (json['dinner'] != null) {
      dinner = (json['dinner']! as List<dynamic>)
          .map((e) => ServedAliment.fromJson(e))
          .toList();
    }
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  Future<void> save(DateTime date) async {
    _cachedIntake = sumFields([...breakfast, ...lunch, ...dinner]);
    return FileHandler.saveJson(toJson(), date: date);
  }

  /// [ IO_FUNCTION ]
  ///
  /// `intl.DateFormat('d_M_y').format(date)` is used internally,
  /// as such, hours, minutes, seconds etc. don't matter.
  Future<void> load(DateTime date) async {
    await FileHandler.loadJson(date: date).then((json) {
      fromJson(json);
    });
  }

  List<ServedAliment> totalServedAliments() {
    /* We broke the `servedAliment` into its 2 components,
     the String `alimentID` and the double `servingSize`. */

    /* `[t]otal[S]erved[A]liment[s]` */
    final Map<String, double> tsas = {};
    /* `[s]erved[T]emporary[A]liment[s]` */
    final List<ServedAliment> stas = [];

    for (final List<ServedAliment> meal in [breakfast, lunch, dinner]) {
      for (final ServedAliment sa in meal) {
        if (sa.alimentID != null) {
          tsas[sa.alimentID!] = (tsas[sa.alimentID] ?? 0.0) + sa.servingSize;
        } else {
          stas.add(sa);
        }
      }
    }

    final List<ServedAliment> totalServedAliments = tsas.entries
        .map((e) => ServedAliment(alimentID: e.key, servingSize: e.value))
        .toList()
      ..addAll(stas);

    return totalServedAliments;
  }

  Map<ServedAliment, double> topIntakeAliments(String nutrient, {trim = true}) {
    /* Start unsorted. */
    /* ~ {'Egg': 500.0 vitA, 'Potato: 10.0 vitA'}, then sort by value. */
    final Map<ServedAliment, double> result = totalServedAliments()
        .asMap()
        .map((key, value) => MapEntry(value, value.fields[nutrient] ?? 0.0))
      ..removeWhere((key, value) => ((trim) && (value == 0.0)));

    /* Return sorted. */
    return (result.entries.toList()
          ..sort((a, b) => (b.value - a.value).sign.toInt()))
        .asMap()
        .map((key, value) => value);
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
