
import 'package:flutter/material.dart';

class Task {
  int id;
  String name;
  int pointReward;
  bool isCompleted;
  DateTime notifyMeDate;
  DateTime dueDate;
  bool isRecurring;
  int numberPickerStep;
  bool isStepUpdated;
  int backupStep;

  Task({
    this.id = 0,
    this.name = "Default task title",
    this.pointReward = 1,
    this.isCompleted = false,

    DateTime? notifyMeDate,
    DateTime? dueDate,
    this.isRecurring = false,
    this.numberPickerStep = 1,
    this.isStepUpdated = false,
    this.backupStep = 1,

  })  : notifyMeDate = notifyMeDate ?? DateTime.utc(0),
        dueDate = dueDate ?? DateTime.utc(0);

  Color getNotifIconColor() { return notifyMeDate != DateTime.utc(0) ? Colors.blue : Colors.grey; }
  void setNotifIconColor(DateTime date) { notifyMeDate = date; }

  Color getDueDateIconColor() { return dueDate != DateTime.utc(0) ? Colors.blue : Colors.grey; }
  void setDueDateIconColor(DateTime date) { dueDate = date; }

  Color getRecuringIconColor() { return isRecurring ? Colors.blue : Colors.grey; }
  bool getIsRecuringStatus() { return isRecurring; }
  void setRecuringIconColor(bool isRecurringParam) { isRecurring = isRecurringParam; }


}
