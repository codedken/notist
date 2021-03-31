import 'package:flutter/material.dart';

import './add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF070706),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        backgroundColor: Colors.grey[700],
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteScreen(),
            ),
          ).then((value) => setState(() {}));
        },
      ),
      appBar: AppBar(
        backgroundColor: Color(0xFF070706),
        elevation: 0,
        title: Text(
          'Notes',
          style: TextStyle(
            color: Colors.white70,
          ),
        ),
      ),
      body: Center(
        child: Text('Notes !'),
      ),
    );
  }
}
