import 'package:flutter/material.dart';
import 'package:keep_grinding/pages/todo/task.dart';

Row notifyButton(Task currentTask, BuildContext context, setState) {
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.notifications),
        color: currentTask.getNotifIconColor(),
        onPressed: () async {
          FocusScope.of(context).unfocus();

          // Affiche un Date Picker
          DateTime? selectedDate = await showDatePicker(
            helpText: "Select notify date",
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2020), // Date minimale
            lastDate: DateTime(2100), // Date maximale
          );
          FocusScope.of(context).unfocus();

      
          TimeOfDay? selectedTime = await showTimePicker( // todo
            initialTime: TimeOfDay.now(),
            context: context,
          );
          FocusScope.of(context).unfocus();


          // Si une date est choisie, met à jour l'état
          if (selectedDate != null) {
            setState(() {
          FocusScope.of(context).unfocus();

              currentTask.setNotifIconColor(selectedDate);
          FocusScope.of(context).unfocus();

            });
          }
          FocusScope.of(context).unfocus();

        },
      ),

      // Affiche l'icône de suppression uniquement si une date est définie
      if (currentTask.notifyMeDate != DateTime.utc(0))
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            setState(() {
              currentTask.setNotifIconColor(DateTime.utc(0));
            });
          },
        ),

    ],
  );
}