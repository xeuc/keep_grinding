// ___    _        _     _    
//  |  _ | \ _    |_) _ (_| _ 
//  | (_)|_/(_)   |  (_|__|(/_

import 'package:flutter/material.dart';


import 'package:keep_grinding/db.dart';
import 'package:keep_grinding/notification_service.dart';
import 'package:keep_grinding/pages/todo/add_button/add_task.dart';
import 'package:keep_grinding/pages/todo/task.dart';
import 'package:keep_grinding/util.dart';


class ToDoPage extends StatefulWidget {
  const ToDoPage({super.key});

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

const DEFAULT_BUTTON_TEXT = "Default Title";


class _ToDoPageState extends State<ToDoPage> with WidgetsBindingObserver {

    @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    ScheduleManager();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      ScheduleManager();
    }
  }

  void ScheduleManager() async {
    var dbHelper = DatabaseHelper();
    var remindDates = dbHelper.getRemindDateNameSync();
    DateTime now = DateTime.now();

    for (var dateString in remindDates) {
      DateTime targetDate = DateTime.parse(dateString);

      if (now.isAfter(targetDate)) {
        setState(() {
          remindUser();
        });
        return;
      }

      Duration delay = targetDate.difference(now);
      Future.delayed(delay, () {
        setState(() {
          remindUser();
        });
      });
    }
  }

  void remindUser() {
    // when schedule time arise
    // TODO: end notif to user
    NotificationService().showNotification("notifTest", "I am a notification");

  }

  List<Task> tasks_2 = [];
  Task currentTask = Task();

  List<String> titles = [];
  List<IconData> icons = [];
  List<String> point = [];


  final int _currentValue = 3;
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

  void resetCurrentTask() {
    setState(() {
      currentTask = Task(); // Réinitialise currentTask
    });
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
                          subtitle: const Text("2 Days remainings."),
                          leading: Text(point[index], style: const TextStyle(
                            fontSize: 25,
                            color: Colors.blue,
                          )),
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
                    Text('SEE MORE'), // Automatic while scrolling??? todo
                  ],
                ),
              ),
            ],
          ),
        ),

        // The button to add task, present at the bottom of the creen, at the bottom of the bottom navigation bar
        addButton(resetCurrentTask, currentTask, context, setState, _currentValue, _controller, userInput),

      ],
    );


  }
}

