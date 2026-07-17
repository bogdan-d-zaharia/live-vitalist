import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class AlimentPickerField extends StatelessWidget {
  final String? alimentName;
  final Function() onTap;

  const AlimentPickerField({
    required this.alimentName,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final name = alimentName ?? 'Select aliment';

    return MiniCard(
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16.0, vertical: 12.0),
                child: Text(
                  name,
                  softWrap: true,
                  style: TextStyle(
                    color: alimentName != null ? null : Colors.grey[700],
                  ),
                ),
              ),
            ),
            const Icon(Icons.arrow_drop_down_rounded, size: 42.0),
          ],
        ),
      ),
    );
  }
}
