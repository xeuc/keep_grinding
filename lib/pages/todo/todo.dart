// ___    _        _     _    
//  |  _ | \ _    |_) _ (_| _ 
//  | (_)|_/(_)   |  (_|__|(/_

import 'package:flutter/material.dart';


import 'package:keep_grinding/db.dart';
// import 'package:keep_grinding/pages/todo/task.dart';
import 'package:keep_grinding/util.dart';
import 'package:numberpicker/numberpicker.dart';


class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

const DEFAULT_BUTTON_TEXT = "Default Title";


class _ToDoPageState extends State<ToDoPage> {

  // List<Task> tasks_2 = [];
  // Task current_task;

  List<String> titles = [];
  List<IconData> icons = [];
  List<String> point = [];

  Color _iconColor = Colors.grey;
  Color _iconColor2 = Colors.grey;
  Color _iconColor3 = Colors.grey;

  int _currentValue = 3;
  String userInput = DEFAULT_BUTTON_TEXT;
  
  final TextEditingController _controller = TextEditingController();

  late List<String> tasks;

  void loadTasks() {
    var dbHelper = DatabaseHelper();
    var loadedTasks = dbHelper.getTasksNameSync(); // Récupère les tâches depuis la base de données
    var loadedPoints = dbHelper.getPointsNameSync(); // Récupère les tâches depuis la base de données
    setState(() {
      tasks = loadedTasks;
      point = loadedPoints;
    });
  }

  void deleteTask(String taskName) {
    var dbHelper = DatabaseHelper();
    var points = dbHelper.getPointFromTaskName(taskName);
    dbHelper.addPoint(points);
    dbHelper.removeLastTaskSync(taskName); // Supprime la tâche de la base de données
    loadTasks(); // Recharge les tâches pour mettre à jour l'affichage
  }

  @override
  Widget build(BuildContext context) {
    loadTasks();
    return Column(
      children: [
        Expanded(
          child: CustomScrollView(
            slivers: [
          
              // Title
              const SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('ToDo-List', style: optionStyle),
                    Text('Welcome to Page todo'),
                  ],
                ),
              ),
          
              // List
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: tasks.length,
                  (context, index) {
                    return Card(
                      child: Dismissible(
                        onDismissed: (DismissDirection direction) {
                          setState(() {
                            tasks.removeAt(index);
                          });
                        },
                        key: ValueKey<String>(tasks[index]),
                        child: ListTile(
                          onTap: () {setState(() {});},
                          title: Text(tasks[index]),
                          leading: Text(point[index]),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () { deleteTask(tasks[index]); },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
          
              // Show more history
              const SliverToBoxAdapter(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('SEE MORE'), // et ya pas de boutton history, il s'affiche auto
                  ],
                ),
              ),
            ],
          ),
        ),

        // Fancy add button
        Material(
          color: Colors.transparent,
          child: ListTile(
            title: TextField(
              controller: _controller,
              onChanged: (value) {
                setState(() {
                  userInput = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Enter subtitle here',
              ),
            ),
            subtitle: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications),
                  color: _iconColor,
                  onPressed: () {
                    setState(() {
                      _iconColor = _iconColor == Colors.blue ? Colors.grey : Colors.blue;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.calendar_month),
                  color: _iconColor2,
                  onPressed: () {
                    setState(() {
                      _iconColor2 = _iconColor2 == Colors.blue ? Colors.grey : Colors.blue;
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.replay_rounded),
                  color: _iconColor3,
                  onPressed: () {
                    setState(() {
                      _iconColor3 = _iconColor3 == Colors.blue ? Colors.grey : Colors.blue;
                    });
                  },
                ),
              ],
            ),
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
            trailing: IconButton(
              icon: const Icon(Icons.add),
              color: Colors.blue,
              onPressed: () {
                var dbHelper = DatabaseHelper();

                userInput = userInput.isEmpty ? DEFAULT_BUTTON_TEXT : userInput;
                dbHelper.addTaskSyncro(
                  userInput,
                  _currentValue - 1,
                  '2024-12-01 18:00:00',
                  '2024-12-01 18:00:00',
                  false,
                  false,
                );

                // Ajoute le titre et le sous-titre entrés
                setState(() {
                  _controller.clear();
                  userInput = '';
                });
              },
            ),
          ),
        ),



      ],
    );


  }
}






// dark mode