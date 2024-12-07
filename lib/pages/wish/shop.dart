//  __       _     _     _    
// (_ |_  _ |_)   |_) _ (_| _ 
// __)| |(_)|     |  (_|__|(/_

import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import '../../util.dart';
import 'add_button.dart';


class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {

  List<String> titles = [];
  List<String> subtitles = [];
  List<IconData> icons = [];

  late List<String> tasks;

  void loadTasks() {
    var dbHelper = DatabaseHelper();
    var loadedTasks = dbHelper.getWishesNameSync(); // Récupère les tâches depuis la base de données
    setState(() {
      tasks = loadedTasks; // Mets à jour la liste des tâches
    });
  }

  void deleteTask(String taskName) {
    var dbHelper = DatabaseHelper();
    var points = dbHelper.getPointFromWishName(taskName);
    dbHelper.addPoint(-points);
    dbHelper.removeLastWishesSync(taskName); // Supprime la tâche de la base de données
    loadTasks(); // Recharge les tâches pour mettre à jour l'affichage
  }

  @override
  Widget build(BuildContext context) {
    loadTasks();
    return CustomScrollView(
      slivers: [


        // Title
        const SliverToBoxAdapter(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('WishList', style: optionStyle),
              Text('Welcome to Page wish'),
            ],
          ),
        ),


        // Button fancy
        // AddButton(titles: titles, subtitles: subtitles, icons: icons,), // A mettre tout en bas
        AddButton(
            titles: titles,
            subtitles: subtitles,
            icons: icons,
            onAddItem: (String title, String subtitle, IconData icon) {
              setState(() {
                titles.add(title);
                subtitles.add(subtitle);
                icons.add(icon);
              });
            }),


        // List
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return Card(
                child: ListTile(
                  onTap: () {
                    setState(() {
                      
                    });
                  },
                  // title: Text(titles[index]),
                  title: Text(tasks[index]),
                  subtitle: const Text("bonjour, je suis un sous titre d'une tache, gros bisou."),
                  trailing: IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () {
                        deleteTask(tasks[index]); // Supprime la tâche quand l'icône est pressée
                      },
                    ),
                ),
              );
            },
            childCount: tasks.length,
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
      
    );

  }
}


