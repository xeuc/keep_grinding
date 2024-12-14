import 'package:flutter/material.dart';
import 'package:keep_grinding/pages/todo/task.dart';

Row recurringButton(Task currentTask, BuildContext context, setState) {

  String? selectedFrequency;
  
  return Row(
    children: [
      IconButton(
        icon: const Icon(Icons.replay_rounded),
        color: currentTask.getRecuringIconColor(),
        onPressed: () {
          setState(() {
            FocusScope.of(context).unfocus();


showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0), // Coins arrondis
                  ),
                  elevation: 5,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0), // Padding à l'intérieur
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFrequency = "Every Minute";
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Every Minute'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFrequency = "Every Hour";
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Every Hour'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFrequency = "Every Day";
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Every Day'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFrequency = "Every Month";
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Every Month'),
                        ),
                        TextButton(
                          onPressed: () {
                            setState(() {
                              selectedFrequency = "Every Year";
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Every Year'),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
              

            currentTask.setRecuringIconColor(!currentTask.getIsRecuringStatus());
          });
        },
      ),

      if (currentTask.isRecurring)
        IconButton(
          icon: const Icon(Icons.delete),
          color: Colors.red,
          onPressed: () {
            setState(() {
              currentTask.setDueDateIconColor(DateTime.utc(0));
              currentTask.setRecuringIconColor(false);
            });
          },
        ),

    ],
  );
}