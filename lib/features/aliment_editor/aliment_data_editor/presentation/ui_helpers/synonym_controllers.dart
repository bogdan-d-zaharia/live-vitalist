import 'package:flutter/material.dart';

class SynonymControllers {
  final Map<String, TextEditingController> _names = {};
  final Map<String, TextEditingController> _values = {};

  TextEditingController name(String key) => _names[key]!;
  TextEditingController value(String key) => _values[key]!;

  void sync(Map<String, double> synonyms) {
    for (final key in List.of(_names.keys)) {
      if (!synonyms.containsKey(key)) {
        _names.remove(key)?.dispose();
        _values.remove(key)?.dispose();
      }
    }

    for (final entry in synonyms.entries) {
      if (_names[entry.key] != null) {
        update(entry.key, entry.value);
      } else {
        add(entry.key, entry.value);
      }
    }
  }

  void rename(String oldKey, String newKey) {
    _names[newKey] = _names.remove(oldKey)!;
    _values[newKey] = _values.remove(oldKey)!;
  }

  void add(String key, double value) {
    _names[key] = TextEditingController(text: key);
    _values[key] = TextEditingController(text: value.toString());
  }

  void update(String key, double value) {
    _names[key]!.text = key;
    _values[key]!.text = value.toString();
  }

  void remove(String key) {
    _names.remove(key)?.dispose();
    _values.remove(key)?.dispose();
  }

  void dispose() {
    for (final ctrl in _names.values) {
      ctrl.dispose();
    }
    for (final ctrl in _values.values) {
      ctrl.dispose();
    }
  }
}
