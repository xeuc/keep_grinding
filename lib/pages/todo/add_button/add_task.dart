

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/due_date_icon.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/notify_icon.dart';
import 'package:keep_grinding/pages/todo/add_button/icons_behavior/recurring_icon.dart';
import 'package:keep_grinding/pages/todo/task.dart';
import 'package:numberpicker/numberpicker.dart';

var MAX_INT = 2147483647;

Material addButton(VoidCallback resetCurrentTask, Task currentTask, BuildContext context, setState, int _currentValue, _controller, userInput) {
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
          // itemCount: 4, // dont work
          textMapper: (numberText) => displayNumber2(numberText),
          value: currentTask.pointReward,
          step: currentTask.numberPickerStep,
          infiniteLoop: false,
          haptics: true,
          minValue: 0,
          maxValue: MAX_INT,

          // onChanged: (value) => setState(() => {
          //   currentTask.pointReward = value,
          //   mStep = calculateStep(value),
          // }),
          onChanged: (value) {
            // print("value: " + value.toString());

            currentTask.pointReward = value;
            // currentTask.numberPickerStep = calculateStep(value);
            // currentTask.pointReward = value + currentTask.numberPickerStep;

            // TODO: resolve the bug that changing both walue and step here make NumberPicker crazy
            // and directly goes to the max number in a fraction of second. 

            // currentTask.backupStep = value;
            setState(() {});
            // setState(() {
            //   currentTask.pointReward = value;
            //   // if (currentTask.isStepUpdated) {
            //   //   currentTask.isStepUpdated = false;
            //   //   return;
            //   // }
            //   var newStep = calculateStep(value);
            //   currentTask.backupStep
            //   currentTask.numberPickerStep = newStep;
            //   currentTask.isStepUpdated = true;
            // });
          },
          
          

          
        ),
      ),

      // TODO: create the "quick win button"
      // dbHelper.addTaskSyncro(currentTask.name, currentTask.pointReward - 1, now, "", false, true);
      // Blue "plus" add button
      trailing: IconButton(
        icon: const Icon(Icons.add),
        color: Colors.blue,
        onPressed: () {
          FocusScope.of(context).unfocus();
          var dbHelper = DatabaseHelper();
          // userInput = userInput.isEmpty ? DEFAULT_BUTTON_TEXT : userInput;
          dbHelper.addTaskSyncro(currentTask.name, currentTask.pointReward - 1,
            currentTask.notifyMeDate.toString(), currentTask.dueDate.toString(), false, false);

          // Ajoute le titre et le sous-titre entrés
          setState(() {
            _controller.clear();
            resetCurrentTask();
          });
        },
      ),
    ),
  );
}

const suffixes = ["", "K", "M", "B", "T"];




String displayNumber(String numberText) {

  var len = numberText.length;

  var quotient = len ~/ 3;
  var remainder = len % 3;

  // Trouver le nombre à afficher
  String numberToDisplay;
  if (remainder == 0) {
    numberToDisplay = numberText.substring(0, 3); // Prendre les 3 premiers chiffres si aucun reste
    quotient--; // Ajuster l'indice du suffixe
  } else {
    numberToDisplay = numberText.substring(0, remainder); // Prendre les chiffres restants
  }

  // Ajouter le suffixe correspondant
  var suffix = (quotient >= 0 && quotient < suffixes.length) ? suffixes[quotient] : "";

  // Retourner le résultat final
  return "$numberToDisplay$suffix";
}



String displayNumber2(String numberText) {
  var len = numberText.length;
  // len = len > MAX_INT.toString().length ? MAX_INT.toString().length : len;
  var quotient = (len - 1) ~/ 3;
  var remainder = len % 3;
  // r = 0 show 3 digit, 1 show 1, 2 show 2.
  // not performant way to do it but funny :D
  var amountDigitToDisplay = remainder + 3*(remainder-1)*(remainder-2)/2;
  
  var numberToDisplay = numberText.substring(0, amountDigitToDisplay.toInt()); 

  // suffix if k for kilo, M for mili, etc..
  var suffix = suffixes[quotient];

  // return result like "2k"
  return "$numberToDisplay$suffix";
}


int calculateStep(int value) {
  var stringValue = value.toString();
  var stepBase = /*int.parse(stringValue[0]) **/ pow(10, stringValue.length - 1).toInt();
  print("---BEGIN-------------------------------------------");
  print("stringValue: " + stringValue);
  print("stepBase: " + stepBase.toString());
  print("---END-------------------------------------------");
  return stepBase;
}
