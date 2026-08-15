import 'dart:ui';

import 'package:flutter/material.dart';

class OptionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? footer;
  final bool isSelected;
  final VoidCallback onTap;

  const OptionCard({
    super.key,
    required this.icon,
    required this.title,
    this.footer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final radius = BorderRadius.circular(20.0);

    final primary = colors.primaryContainer;
    final baseColor = isSelected ? primary : colors.surfaceContainerLow;
    final contentColor =
        isSelected ? colors.onPrimaryContainer : colors.onSurface;

    return AnimatedContainer(
      duration: Duration(milliseconds: 128),
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            blurRadius: 12.0,
            offset: Offset(0.0, 4.0),
            color: colors.shadow.withValues(alpha: isSelected ? 0.14 : 0.08),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: radius,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  baseColor.withValues(alpha: isSelected ? 0.9 : 0.8),
                  baseColor.withValues(alpha: isSelected ? 0.8 : 0.6),
                ],
              ),
              border: Border.all(
                color: colors.onSurface.withValues(alpha: 0.08),
                width: 0.5,
              ),
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: primary.withValues(alpha: 1),
                highlightColor: primary,
                onTap: onTap,
                borderRadius: radius,
                child: Container(
                  width: double.infinity,
                  constraints: BoxConstraints(minHeight: 92.0),
                  padding:
                      EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 42.0,
                        color: contentColor,
                        shadows: [Shadow(color: contentColor, blurRadius: 1.0)],
                      ),
                      SizedBox(width: 16.0),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              title,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: contentColor,
                              ),
                            ),
                            if (footer != null) ...[
                              SizedBox(height: 2.0),
                              Text(
                                footer!,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: contentColor.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
