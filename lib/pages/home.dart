//                 _     _    
// |_| _ __  _    |_) _ (_| _ 
// | |(_)|||(/_   |  (_|__|(/_




import 'package:flutter/material.dart';
import 'package:keep_grinding/pages/profil.dart';
import 'package:keep_grinding/pages/todo/todo.dart';
import 'wish/shop.dart';



class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  void _incrementCounter() {
    setState(() {
      // do whatever
    });
  }

  int _selectedIndex = 2;
  final List<Widget> _widgetOptions = <Widget>[
      const ShoppingPage(),
      const ProfilPage(),
      const ToDoPage(),
    ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var colorScheme = Theme.of(context).colorScheme;


    return Scaffold(
      // APPBAR
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
        title: Text(widget.title),
      ),

      // BODY
      body: ColoredBox(
        color: colorScheme.surfaceContainerHigh,
        child: Center(child: _widgetOptions.elementAt(_selectedIndex))
      ),
      

      

      // BOTTOM BAR
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[

          // Wish button
          const BottomNavigationBarItem(
            icon: Icon(Icons.shop),
            label: 'Wish',
          ),

          // Profil fancy button
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
 
                Container(
                  width: 60,
                  height: 60,
                  
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.blue,
                  ),
                ),
                Icon(Icons.person, size: 30, color: Colors.white),
              ],
            ),
            label: '', // todo: trouver une autre solution #refactor
          ),


          // ToDo page button
          const BottomNavigationBarItem(
            icon: Icon(Icons.pending_actions),
            label: 'ToDo',
          ),

          
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,

      ),

    );
  }
}
