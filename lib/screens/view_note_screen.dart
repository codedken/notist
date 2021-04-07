import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../widgets/components/elevated_button.dart';
import '../constants.dart';

class ViewNoteScreen extends StatefulWidget {
  final Map<String, dynamic>? doc;
  final DocumentReference? docRef;
  final String? formattedDate;
  ViewNoteScreen({
    @required this.doc,
    @required this.docRef,
    @required this.formattedDate,
  });
  @override
  _ViewNoteScreenState createState() => _ViewNoteScreenState();
}

class _ViewNoteScreenState extends State<ViewNoteScreen> {
  void _deleteNote() async {
    await widget.docRef!.delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          padding: EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton1(
                      child: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    ElevatedButton(
                      child: Text(
                        'Delete',
                        style: kTextStyle.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _deleteNote();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.red[400],
                        ),
                        padding: MaterialStateProperty.all(
                          EdgeInsets.symmetric(
                            horizontal: 12.0,
                            vertical: 8.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20.0),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.doc!['title'],
                      style: kTextStyle.copyWith(
                        fontSize: 28,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      widget.formattedDate!,
                      style: kTextStyle.copyWith(
                        fontSize: 14,
                        color: Colors.white60,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    Divider(),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.7,
                      child: Text(
                        widget.doc!['description'],
                        style: kTextStyle.copyWith(
                          color: Colors.grey.shade100,
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
