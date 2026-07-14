import 'package:flutter/material.dart';

class ElementWidget extends StatelessWidget {
  const ElementWidget({
    required this.title,
    required this.subTitle,
    required this.onTap,
    this.onLongPress,
    required this.additional,
    super.key,
  });

  final String title;
  final String subTitle;
  final void Function() onTap;
  final void Function()? onLongPress;
  final List<Widget> additional;

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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium
                          ?.copyWith(fontSize: 16.0, letterSpacing: -0.5),
                    ),
                    if (subTitle != '')
                      Text(
                        subTitle,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.0,
                          color: Colors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          ...additional,
        ],
      ),
    );
  }
}
