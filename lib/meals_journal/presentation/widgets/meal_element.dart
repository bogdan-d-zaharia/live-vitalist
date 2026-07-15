import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class MealElement extends StatelessWidget {
  const MealElement({
    required this.title,
    required this.subtitle,
    required this.onTap,
    required this.onLongPress,
    required this.onAdd,
    super.key,
  });

  final String title;
  final String subtitle;
  final void Function() onTap;
  final void Function() onLongPress;
  final void Function() onAdd;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onTap,
              onLongPress: onLongPress,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title),
                        Text(
                          subtitle,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12.0,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          VerticalDivider(
            color: Palette.divGrey,
            thickness: 0.5,
            width: 0.0,
            indent: 8.0,
            endIndent: 8.0,
          ),
          AspectRatio(
            aspectRatio: 1.0,
            child: InkWell(
              onTap: onAdd,
              child: Center(child: Icon(Icons.add_rounded)),
            ),
          ),
        ],
      ),
    );
  }
}
