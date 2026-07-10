import 'package:flutter/material.dart';
import 'package:live_vitalist/custom_card.dart';

class ReauthenticateDialog extends StatelessWidget {
  const ReauthenticateDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomCard(
        headerSpace: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              'You must authenticate first before we can delete your account associated with Google.',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 12.0),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context, true),
              icon: const Icon(Icons.delete, color: Colors.white),
              label: const Text("Re-authenticate and delete"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ConfirmDeletionDialog extends StatelessWidget {
  final String text;
  final VoidCallback onConfirm;

  const ConfirmDeletionDialog({
    super.key,
    required this.text,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: CustomCard(
        headerSpace: 0.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(text, style: const TextStyle(fontSize: 16.0)),
            const SizedBox(height: 12.0),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    label: const Text("Cancel"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12.0),
                SizedBox(
                  width: 100.0,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      onConfirm();
                    },
                    icon: const Icon(Icons.delete, color: Colors.white),
                    label: const Text("Delete"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
