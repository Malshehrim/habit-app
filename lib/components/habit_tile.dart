import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class HabitTile extends StatelessWidget {
  final bool isCompleted;
  final String text;
  final void Function(bool?)? onChanged;
  final void Function(BuildContext)? editHabit;
  final void Function(BuildContext)? deletHabit;
  const HabitTile({
    super.key,
    required this.isCompleted,
    required this.text,
    required this.onChanged,
    required this.editHabit,
    required this.deletHabit,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          children: [
            //edit option
            SlidableAction(
              // padding: const EdgeInsets.all(28),
              backgroundColor: Colors.grey.shade800,
              icon: Icons.settings,
              borderRadius: BorderRadius.circular(8),
              onPressed: editHabit,
            ),
            SlidableAction(
              backgroundColor: Colors.red,
              icon: Icons.delete,
              borderRadius: BorderRadius.circular(8),
              onPressed: deletHabit,
            ),
          ],
        ),
        child: GestureDetector(
          onTap: () {
            if (onChanged != null) {
              // toggle completion status

              onChanged!(!isCompleted);
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isCompleted
                  ? Colors.green
                  : Theme.of(context).colorScheme.secondary,
            ),
            padding: const EdgeInsets.all(12),
            // margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 25),
            child: ListTile(
              title: Text(
                text,
                style: TextStyle(
                  color: isCompleted
                      ? Colors.white
                      : Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              leading: Checkbox(
                activeColor: Colors.green,
                value: isCompleted,
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
