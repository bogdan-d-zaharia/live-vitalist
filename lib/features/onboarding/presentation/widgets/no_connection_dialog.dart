import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';

class NoConnectionDialog extends StatelessWidget {
  const NoConnectionDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.all(24.0),
      child: CustomCard(
        padding: EdgeInsets.fromLTRB(26.0, 24.0, 26.0, 12.0),
        logo: Icon(Icons.error_outline_rounded),
        title: "No internet access",
        child: Column(
          spacing: 4.0,
          children: [
            Text(
              "Please connect to the internet in order to accept our Terms and Conditions, and with our Privacy Policy.",
              textAlign: TextAlign.center,
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: SizedBox(
                width: double.infinity,
                child: Center(child: Text('Continue')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Future<void> showNoConnectionDialog(BuildContext context) async {
  return showDialog(
    context: context,
    builder: (context) => NoConnectionDialog(),
  );
}
