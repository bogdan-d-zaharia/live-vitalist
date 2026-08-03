import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/animated_gradient_background.dart';
import 'package:live_vitalist/core/theme/app_background_theme.dart';

class GradientScaffold extends StatelessWidget {
  const GradientScaffold({
    super.key,
    this.appBar,
    required this.body,
    this.extendBodyBehindAppBar = false,
  });

  final PreferredSizeWidget? appBar;
  final Widget body;
  final bool extendBodyBehindAppBar;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppBackgroundTheme.of(context).washColor,
      extendBodyBehindAppBar: extendBodyBehindAppBar,
      appBar: appBar,
      body: AnimatedGradientBackground(child: body),
    );
  }
}
