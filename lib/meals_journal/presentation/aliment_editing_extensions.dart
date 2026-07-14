import 'package:flutter/material.dart';
import 'package:live_vitalist/aliment/domain/aliment.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor.dart';
import 'package:live_vitalist/aliment_editor/instance_editor.dart';

extension InstanceEditing on InstancedAliment {
  Future<InstancedAliment?> pushEditingScreen(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InstanceEditor(
          initialAliment: this,
        ),
      ),
    );
  }
}

extension TemporaryEditing on TemporaryAliment {
  Future<TemporaryAliment?> pushEditingScreen(BuildContext context) async {
    final newData = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlimentDataEditor(
          initialData: alimentData,
        ),
      ),
    );
    return newData != null ? copyWith(alimentData: newData) : null;
  }
}

extension AlimentEditing on Aliment {
  Future<Aliment?> pushEditingScreen(BuildContext context) async {
    return switch (this) {
      InstancedAliment a => a.pushEditingScreen(context),
      TemporaryAliment b => b.pushEditingScreen(context),
      Aliment _ => null,
    };
  }
}

extension AlimentDataEditing on AlimentData {
  Future<AlimentData?> pushEditingScreen(BuildContext context) async {
    return await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AlimentDataEditor(
          initialData: this,
        ),
      ),
    );
  }
}
