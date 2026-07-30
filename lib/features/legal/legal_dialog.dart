import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:live_vitalist/features/legal/data/legal_handler.dart';
import 'package:live_vitalist/features/legal/domain/legal_types.dart';
import 'package:live_vitalist/features/legal/presentation/widgets/legal_dialog_button.dart';
import 'package:live_vitalist/features/legal/presentation/widgets/legal_prerequisites_text.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';

class LegalDialog extends ConsumerWidget {
  final List<LegalRequirement> requirements;
  const LegalDialog({super.key, required this.requirements});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CustomCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Please Accept Our Terms',
                style: TextStyle(fontSize: 24.0),
              ),
              SizedBox(height: 12.0),
              LegalPrerequisitesText(),
              Text(
                  'You can review the Privacy Policy and Terms of Use at any time from the app\'s Settings, accessible via the ⋮ menu in the top-right corner.'),
              SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  LegalDialogButton(
                    onPressed: () async {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Closing the app...'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      await Future.delayed(Duration(seconds: 3));
                      SystemNavigator.pop();
                    },
                    label: Text("Exit App"),
                    backgroundColor: Colors.red,
                  ),
                  SizedBox(width: 12.0),
                  LegalDialogButton(
                    onPressed: () async {
                      await ref.read(legalHandlerProvider).accept(requirements);
                      if (context.mounted) Navigator.pop(context, true);
                    },
                    label: Text("I Agree"),
                    backgroundColor: Colors.blue,
                  ),
                  SizedBox(width: 6.0),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<bool> showLegalDialog(
  BuildContext context,
  List<LegalRequirement> requirements,
) async {
  final bool? isAccepted = await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) => LegalDialog(requirements: requirements),
  );
  return isAccepted ?? false;
}
