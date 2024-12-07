// | | |_ o  | 
// |_| |_ |  | 

import 'package:flutter/material.dart';


const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

class ToDo {
  final String name;
  final String dueDate;
  final String reminderDate;
  final bool favourite;

  const ToDo({
    required this.name,
    required this.dueDate,
    required this.reminderDate,
    required this.favourite,
  });

  // Convert a Dog into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, Object?> toMap() {
    return {
      'name': name,
      'dueDate': dueDate,
      'reminderDate': reminderDate,
      'favourite': favourite,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Dog{name: $name, dueDate: $dueDate, reminderDate: $reminderDate, favourite: $favourite}';
  }
}

