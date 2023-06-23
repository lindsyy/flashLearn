import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/student/account.dart';
import 'package:flashlearn/screens/student/addSub.dart';
import 'package:flashlearn/screens/home.dart';
import 'package:flashlearn/screens/student/note.dart';
import 'package:flashlearn/screens/student/scan.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({super.key});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        backgroundColor: colorY100,
        title: Text(
          'FlashLearn',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => homScreen(),
              )),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        actions: [
          DropdownButton(
            style: TextStyle(backgroundColor: colorY100),
            dropdownColor: colorY100,
            hint: Container(
              padding: EdgeInsets.only(left: 34),
              child: Icon(
                Icons.add_card_rounded,
                size: 25,
                color: Colors.black,
              ),
            ),
            items: [
              DropdownMenuItem(
                child: Text(
                  'Add Subject',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'addSub',
              ),
              DropdownMenuItem(
                child: Text(
                  'Scan',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'scan',
              ),
              DropdownMenuItem(
                child: Text(
                  'Account',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'account',
              ),
              DropdownMenuItem(
                child: Text(
                  'Logout',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                value: 'logout',
              ),
            ],
            onChanged: (value) {
              if (value == 'addSub') {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => addSubScreen(),
                    ));
              }
              if (value == 'scan') {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => scanScreen(),
                    ));
              }

              if (value == 'account') {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => accountScreen(),
                    ));
              }

              if (value == 'logout') {
                FirebaseAuth.instance.signOut();
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => homScreen(),
                    ));
              }
            },
          )
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 15,
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('subject')
                .where('studId',
                    isEqualTo: FirebaseAuth.instance.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              final document = snapshot.data!.docs;
              return Expanded(
                child: ListView.builder(
                  itemCount: document.length,
                  itemBuilder: (context, index) {
                    final data = document[index];
                    return Container(
                      margin: EdgeInsets.only(top: 8),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8, right: 8),
                        child: Card(
                          elevation: 5,
                          color: color100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: ListTile(
                            trailing: IconButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('subject')
                                      .doc(data.id)
                                      .delete();
                                },
                                icon: Icon(Icons.delete_outline_rounded)),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => noteScreen(
                                      id: data.id,
                                    ),
                                  ));
                            },
                            title: Text(data['title']),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // Expanded(
          //     child: ListView.builder(
          //   itemCount: 3,
          //   itemBuilder: (context, index) {
          //     return Container(
          //       margin: EdgeInsets.only(top: 8),
          //       child: Card(
          //         child: ListTile(
          //           title: Text('Subject'),
          //         ),
          //       ),
          //     );
          //   },
          // )),
        ],
      ),
    );
  }
}
