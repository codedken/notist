import 'package:flutter/material.dart';
import '../widgets/components/elevated_button.dart';
import '../constants.dart';

class AddNoteScreen extends StatefulWidget {
  @override
  _AddNoteScreenState createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> _authData = {
    'title': '',
    'description': '',
  };

  void _submitNote() {
    if (!_formKey.currentState.validate()) {
      return;
    }

    _formKey.currentState.save();
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
                        ),
                      ),
                      onPressed: () {},
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        style: kTextStyle.copyWith(
                          fontSize: 28,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Title',
                          border: InputBorder.none,
                        ),
                        onSaved: (value) {
                          _authData['title'] = value;
                        },
                        validator: (value) {
                          if (value.isEmpty) {
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
                            if (value.isEmpty) {
                              return 'Enter a description';
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
