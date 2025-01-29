import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import 'package:keep_grinding/notification_service.dart';

import 'pages/home.dart';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// |V| _  o __ 
// | |(_| | | |

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  runApp(const KeepGrinding());
}

// class KeepGrinding extends StatelessWidget {
//   const KeepGrinding({super.key});

//   @override
//   Widget build(BuildContext context) {
//       // DATABASE
//       // Initialize the database helper
//       var dbHelper = DatabaseHelper();
      
//       // Open the database (specify your database path, e.g., 'todo_list.db')
//       await dbHelper.initDatabase('todo_list.db');
      
//       // Create tables
//       await dbHelper.tryCreateTaskTable();
//       await dbHelper.tryCreateRecurringTasksTable();
      
//       // You can now use the database safely
//       print("Database initialized and tables created!");

//       // Remember to close the database when the app exits
//       dbHelper.closeDatabase();


//     return MaterialApp(
//       title: 'Keep Grinding',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
//         useMaterial3: true,
//       ),
//       home: const MyHomePage(title: 'Keep Grinding on t\'as dit'),
//     );
//   }
// }

Future<void> initializeDatabase() async {
  var dbHelper = DatabaseHelper();
  await dbHelper.initDatabase('todo_list.db');
  // await dbHelper.initDatabase('/data/data/uz.mycompany.myapp/databases/database.db');
  await dbHelper.tryCreateTaskTable();
  await dbHelper.tryCreateWishesTable();
  await dbHelper.tryCreateRecurringTasksTable();
  dbHelper.tryCreatePointTableSync();
  dbHelper.tryCreatePointTransactionTableSync();
  

  // await dbHelper.addTask("goto_poo", 3, '2024-12-01 18:00:00', '2024-12-01 18:00:00', false, false);
  // await dbHelper.removeTask("goto_poo");

  var tasks = await dbHelper.getTasks();
  debugPrint("tasks are:");
  debugPrint("$tasks\n");
}


class KeepGrinding extends StatelessWidget {
  const KeepGrinding({super.key});

  Future<void> _initializeApp() async {
    // Initialise la base de données
    // while (true) {}
    await initializeDatabase();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Keep Grinding',
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light, // Aligne la luminosité avec ThemeData
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark, // Aligne la luminosité avec ThemeData
        ),
      ),

      // themeMode: ThemeMode.system, 
      themeMode: ThemeMode.dark, 
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initializeApp(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Erreur : ${snapshot.error}'),
            );
          }

          return const MyHomePage(title: 'Keep Grinding on t\'as dit');
        },
      ),
    );
  }
}



// notif 
// load screen 
// Trois point pour modifier + Suprimer ou complete
// NON, swipe droite complete, swipe gauche DEL 
// See more button
//  xp
//  daily gifl claimed
// sql injection