
import 'package:flutter/material.dart';
import 'package:keep_grinding/db.dart';
import 'package:numberpicker/numberpicker.dart';



class AddButton extends StatefulWidget {
  // const AddButton({super.key});

  final List<String> titles;
  final List<String> subtitles;
  final List<IconData> icons;
  final List<String> point;
  final Function(String title, String subtitle, IconData icon) onAddItem; // Callback

  const AddButton({super.key, 
    required this.titles,
    required this.subtitles,
    required this.icons,
    required this.point,
    required this.onAddItem,
  });

  @override
  _AddButtonState createState() => _AddButtonState();
}

const DEFAULT_BUTTON_TEXT = "Default Title";


class _AddButtonState extends State<AddButton> {
  Color _iconColor = Colors.grey;
  Color _iconColor2 = Colors.grey;
  Color _iconColor3 = Colors.grey;

  int _currentValue = 3;
  String userInput = DEFAULT_BUTTON_TEXT;

  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // return Text('Je sbouttonnnnnnnnnnnnnnte !');
    return Material(
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
              widget.onAddItem(
                'List ${widget.titles.length + 1}',
                userInput.isEmpty ? DEFAULT_BUTTON_TEXT : userInput,
                Icons.zoom_out_sharp,
              );

              // Réinitialiser userInput après ajout
              _controller.clear();
              userInput = '';
            });
          },
        ),
      ),
    );

  }
}
