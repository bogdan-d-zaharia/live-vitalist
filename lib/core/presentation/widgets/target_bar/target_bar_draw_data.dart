import 'package:flutter/material.dart';

class TargetBarDrawData {
  final List<Widget> stackAddons;
  final double height;
  final double radius;
  final Widget? pill;
  final bool isPillForeground;

  const TargetBarDrawData({
    this.stackAddons = const [],
    this.height = 12.0,
    this.radius = 6.0,
    this.pill,
    this.isPillForeground = false,
  });
}
