import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import './login_screen.dart';
import '../constants.dart';
import '../screens/view_note_screen.dart';

import './add_note_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  CollectionReference notes = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('notes');
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
        actions: [
          TextButton(
            child: Text(
              'Logout',
              style: kTextStyle.copyWith(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Sign Out'),
                  content: Text('Are you sure you want to logout?'),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        await FirebaseAuth.instance.signOut();
                        Navigator.pop(ctx);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LoginScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'Yes',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(ctx);
                      },
                      child: Text(
                        'No',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          SizedBox(width: 16.0),
        ],
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(12.0),
        child: FutureBuilder<QuerySnapshot>(
          future: notes.get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else {
              if (snapshot.data!.docs.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No notes yet',
                      style: kTextStyle.copyWith(
                        color: Colors.white,
                        fontSize: 20.0,
                      ),
                    ),
                    SizedBox(height: 12.0),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddNoteScreen(),
                          ),
                        ).then((value) => setState(() {}));
                      },
                      child: Text('Start creating notes'),
                    )
                  ],
                );
              }
              return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (ctx, i) {
                  final Map<String, dynamic>? noteDoc =
                      snapshot.data?.docs[i].data();
                  DateTime created = DateTime.parse(noteDoc!['createdAt']);
                  final cardRandomColor = Colors.grey[700];
                  final formattedDate =
                      DateFormat.yMMMd().add_jm().format(created);
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewNoteScreen(
                            doc: noteDoc,
                            docRef: snapshot.data!.docs[i].reference,
                            formattedDate: formattedDate,
                          ),
                        ),
                      ).then((value) => setState(() {}));
                    },
                    child: Card(
                      color: cardRandomColor,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              noteDoc['title'],
                              style: kTextStyle.copyWith(
                                fontSize: 26,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Container(
                              alignment: Alignment.topRight,
                              child: Text(
                                formattedDate,
                                style: kTextStyle.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
