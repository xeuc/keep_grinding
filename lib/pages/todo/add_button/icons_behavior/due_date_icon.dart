import 'package:flutter/material.dart';
import 'package:keep_grinding/pages/todo/task.dart';

Row dueDateButton(Task currentTask, BuildContext context, setState) {
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.calendar_month),
        color: currentTask.getDueDateIconColor(),
        onPressed: () async {
          FocusScope.of(context).unfocus();
          // Affiche un Date Picker
          DateTime? selectedDate = await showDatePicker(
            helpText: "Select the task due date",
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020), // Date minimale
            lastDate: DateTime(2100), // Date maximale
          );
      
          // Si une date est choisie, met à jour l'état
          if (selectedDate != null) {
            setState(() {
              currentTask.setDueDateIconColor(selectedDate);
            });
          }
        },
      ),

      // Affiche l'icône de suppression uniquement si une date est définie
      if (currentTask.dueDate != DateTime.utc(0))
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            setState(() {
              currentTask.setDueDateIconColor(DateTime.utc(0));
            });
          },
        ),

    ],
  );
}