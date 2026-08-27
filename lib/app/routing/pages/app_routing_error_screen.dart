import 'package:flutter/material.dart';

class AppRoutingErrorScreen extends StatelessWidget {
  const AppRoutingErrorScreen({super.key, this.error});

  final Exception? error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(24.0),
            child: Text(
              error == null
                  ? 'The requested page could not be opened.'
                  : 'The requested page could not be opened:\n$error',
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
