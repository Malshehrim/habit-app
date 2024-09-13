import 'package:flutter/material.dart';
import 'package:habit/theme/theme_provider.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  const HabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: isCompleted
            ? Colors.green
            : Theme.of(context).colorScheme.secondary,
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
      child: ListTile(
        title: Text(text),
        leading: Checkbox(
          value: isCompleted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
