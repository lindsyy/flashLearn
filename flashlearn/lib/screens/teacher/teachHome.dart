import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/home.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flashlearn/screens/teacher/account.dart';
import 'package:flashlearn/screens/teacher/addSub.dart';
import 'package:flashlearn/screens/teacher/note.dart';
import 'package:flashlearn/screens/teacher/qrcode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class teacherScreen extends StatelessWidget {
  const teacherScreen({super.key, required this.id});
  final String id;

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
            dropdownColor: colorY100,
            hint: Container(
              padding: EdgeInsets.only(left: 34),
              child: Text('Teacher'),
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
                      builder: (context) => teachAddScreen(),
                    ));
              }

              if (value == 'account') {
                Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => teachAccountScreen(),
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
                .where('teachId',
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
                      child: Card(
                        elevation: 5,
                        color: color100,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          children: [
                            ListTile(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    CupertinoPageRoute(
                                      builder: (context) => teachNoteScreen(
                                        id: data.id,
                                      ),
                                    ));
                              },
                              title: Text(data['title']),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  qrcodeScreen(
                                                      subjectId: data.id),
                                            ));
                                      },
                                      icon: Icon(Icons.qr_code_2_outlined)),
                                  IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('subject')
                                            .doc(data.id)
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete_outlined)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
