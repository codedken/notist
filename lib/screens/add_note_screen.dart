import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../widgets/components/elevated_button.dart';
import '../constants.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String?> _authData = {
    'title': '',
    'description': '',
    'createdAt': DateTime.now().toString(),
  };

  CollectionReference _notes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');

  void _submitNote() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _formKey.currentState!.save();

    await _notes.add(_authData);
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
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton1(
                        child: Icon(Icons.arrow_back_ios),
                        onPressed: () {
                          Navigator.pop(context);
                        }),
                    Text(
                      'Add a note',
                      style: kTextStyle.copyWith(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton1(
                      child: Text(
                        'Save',
                        style: kTextStyle.copyWith(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      onPressed: () {
                        _submitNote();
                      },
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        style: kTextStyle.copyWith(
                          fontSize: 28,
                          color: Colors.white,
                        ),
                        autocorrect: false,
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (value) {
                          _authData['title'] = value;
                        },
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter a title';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 5.0),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: TextFormField(
                          style: kTextStyle.copyWith(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Description',
                            border: InputBorder.none,
                          ),
                          maxLines: 20,
                          onSaved: (value) {
                            _authData['description'] = value;
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return '';
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
