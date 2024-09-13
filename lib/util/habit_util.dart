bool isHabitCompletedToday(List<DateTime> completDate) {
  final today = DateTime.now();
  return completDate.any(
    (date) =>
        date.year == today.year &&
        date.month == today.month &&
        date.day == today.day,
  );
}
