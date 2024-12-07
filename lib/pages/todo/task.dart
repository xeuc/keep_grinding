
class Task {
  final int id;
  final String name;
  final int pointReward;
  final String remindDate;
  final String dueDate;
  final bool isRecurring;
  final bool isCompleted;

  Task({
    required this.id,
    required this.name,
    required this.pointReward,
    required this.remindDate,
    required this.dueDate,
    required this.isRecurring,
    required this.isCompleted,
  });
}
