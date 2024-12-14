

import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/due_date_icon.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/notify_icon.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/recurring_icon.dart';
import 'package:keep_grinding/pages/todo/task.dart';
import 'package:keep_grinding/pages/todo/todo.dart';
import 'package:numberpicker/numberpicker.dart';

Material addButton(Task currentTask, BuildContext context, setState, int _currentValue, _controller, userInput) {
  return Material(
    color: Colors.transparent,
    child: ListTile(
      title: TextField(
        controller: _controller,
        onChanged: (value) {
          setState(() {
            currentTask.name = value;
          });
        },
        decoration: const InputDecoration(
          hintText: 'Enter a ToDo here',
        ),
      ),
      subtitle: Row(
        // mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [

          // #1 Notify button
          notifyButton(currentTask, context, setState),

          // #2 Due Date button
          dueDateButton(currentTask, context, setState),
          
          // #3 Recurence Often button
          recurringButton(currentTask, context, setState),
        ],
      ),

      // Num of point the user want to be rewarded compliting the task in creation process
      leading: SizedBox(
        width: MediaQuery.of(context).size.width / 8,
        height: MediaQuery.of(context).size.height,
        child: NumberPicker(
          textStyle: const TextStyle(
            fontSize: 30,
            color: Colors.blue,
          ),
          value: _currentValue,
          infiniteLoop: true,
          haptics: true,
          minValue: 0,
          maxValue: 99,
          onChanged: (value) => setState(() => _currentValue = value),
        ),
      ),

      // Blue "plus" add button
      trailing: IconButton(
        icon: const Icon(Icons.add),
        color: Colors.blue,
        onPressed: () {
          FocusScope.of(context).unfocus();
          var dbHelper = DatabaseHelper();
          // userInput = userInput.isEmpty ? DEFAULT_BUTTON_TEXT : userInput;
          dbHelper.addTaskSyncro( currentTask.name, _currentValue - 1,
            '2024-12-01 18:00:00', '2024-12-01 18:00:00', false, false,
          );

          // Ajoute le titre et le sous-titre entrés
          setState(() {
            _controller.clear();
            userInput = '';
          });
        },
      ),
    ),
  );
}


