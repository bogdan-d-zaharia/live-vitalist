import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:live_vitalist/features/authentication/presentation/widgets/auth_dialog_button.dart';
import 'package:live_vitalist/features/authentication/presentation/widgets/auth_prerequisites_text.dart';
import 'package:live_vitalist/core/presentation/widgets/custom_card.dart';

class AuthPrivacyPolicyDialog extends StatelessWidget {
  final Function() onEnter;
  const AuthPrivacyPolicyDialog({super.key, required this.onEnter});

  @override
  Widget build(BuildContext context) {
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
              AuthPrerequisitesText(),
              Text(
                  'You can review the Privacy Policy and Terms of Use at any time from the app\'s Settings, accessible via the ⋮ menu in the top-right corner.'),
              SizedBox(height: 12.0),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AuthDialogButton(
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
                  AuthDialogButton(
                    onPressed: onEnter,
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
