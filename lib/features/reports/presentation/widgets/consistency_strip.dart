import 'package:flutter/material.dart';
import 'package:live_vitalist/core/theme/palette.dart';

class ConsistencyStrip extends StatelessWidget {
  final List<bool> days;
  const ConsistencyStrip({super.key, required this.days});

  static const _labels = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  @override
  Widget build(BuildContext context) {
    final labelStyle = Palette.dayViewLabel.copyWith(height: 1.0);
    final count = days.fold(0, (count, day) => count += day ? 1 : 0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Text('Consistency', style: Palette.dayViewBold),
            Spacer(),
            Text('$count / 7 days on target', style: Palette.highlight),
          ],
        ),
        SizedBox(height: 14.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            for (int i = 0; i < days.length; ++i)
              Column(
                children: [
                  Text(_labels[i], style: labelStyle),
                  SizedBox(height: 8.0),
                  Container(
                    width: 22.0,
                    height: 22.0,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: days[i] ? Palette.green : Colors.transparent,
                      border: Border.all(color: Palette.green, width: 1.5),
                    ),
                    child: days[i]
                        ? Icon(
                            Icons.check_rounded,
                            size: 13.0,
                            color: Colors.black,
                          )
                        : null,
                  ),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
