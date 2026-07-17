import 'package:flutter/material.dart';
import 'package:live_vitalist/aliment/data/aliment_bank.dart';
import 'package:live_vitalist/aliment/domain/aliment_data.dart';
import 'package:live_vitalist/aliment_editor/aliment_data_editor/aliment_data_editor.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class AddAlimentButton extends StatelessWidget {
  final AlimentBank notifier;
  final Function() onAdded;

  const AddAlimentButton({
    required this.notifier,
    required this.onAdded,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: InkWell(
        onTap: () async {
          final AlimentData? aliment = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  AlimentDataEditor(initialData: AlimentData.empty),
            ),
          );
          if (aliment == null) return;

          final id = aliment.hashCode.toString();
          notifier.setAliment(id, aliment);
          onAdded();
        },
        child: Row(
          children: const [
            SizedBox(width: 42.0, height: 42.0, child: Icon(Icons.add_rounded)),
            Text('Add Aliment'),
          ],
        ),
      ),
    );
  }
}
