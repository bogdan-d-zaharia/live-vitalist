import 'package:flutter/material.dart';
import 'package:live_vitalist/core/presentation/widgets/mini_card.dart';

class SelectorSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const SelectorSearchBar({
    required this.controller,
    required this.onChanged,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MiniCard(
      child: Row(
        children: [
          const SizedBox(
            width: 42.0,
            height: 42.0,
            child: Icon(Icons.search_rounded),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Search aliment',
                border: InputBorder.none,
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
