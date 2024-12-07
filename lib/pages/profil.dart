import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import '../util.dart';


class ProfilPage extends StatefulWidget {
  const ProfilPage({super.key});

  @override
  State<ProfilPage> createState() => _ProfilPageState();
}

class _ProfilPageState extends State<ProfilPage> {
  @override
  Widget build(BuildContext context) {

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text('Profil', style: optionStyle),
        Text('Welcome to Page profil'),
        Text('Nombre de point est: ${getNumberOfPoints()}'),
        
        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            setState(() {
              addPoint(10);
            });
          },
          child: Text('ADD 10 points'),
        ),

        TextButton(
          style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.blue),
          ),
          onPressed: () {
            setState(() {
              addPoint(-10);
            });
          },
          child: Text('REM 10 points'),
        ),

      ],
    );
  }
}

int getNumberOfPoints() {
  var dbHelper = DatabaseHelper();
  
  return dbHelper.getNumberOfPointsSync();
}

int addPoint(int pts) {
  var dbHelper = DatabaseHelper();
  dbHelper.addPoint(pts);
  return 0;
}