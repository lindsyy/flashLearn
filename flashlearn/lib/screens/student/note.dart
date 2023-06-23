import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlearn/screens/student/addNote.dart';
import 'package:flashlearn/screens/student/noteEdit.dart';
import 'package:flashlearn/screens/student/studHome.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class noteScreen extends StatefulWidget {
  const noteScreen({super.key, required this.id});
  final String id;

  @override
  State<noteScreen> createState() => _noteScreenState();
}

class _noteScreenState extends State<noteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        backgroundColor: colorY100,
        title: Text('Subject Note',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600)),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => StudentScreen(),
              ),
            );
          },
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => addNoteScreen(
                      id: widget.id,
                    ),
                  ),
                );
              },
              icon: Icon(
                Icons.add_box_outlined,
                color: Colors.black,
              ))
        ],
      ),
      body: Column(
        children: [
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('notes')
                .where('sub_id', isEqualTo: widget.id)
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
                      child: Padding(
                        padding:
                            const EdgeInsets.only(left: 13, right: 13, top: 10),
                        child: Card(
                          elevation: 5,
                          color: color100,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              ListTile(
                                title: Text(
                                  data['note'],
                                  style: TextStyle(fontSize: 18),
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () async {
                                        await FirebaseFirestore.instance
                                            .collection('notes')
                                            .doc(data.id)
                                            .delete();
                                      },
                                      icon: Icon(Icons.delete_outline_outlined),
                                      color: colorY600,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            CupertinoPageRoute(
                                              builder: (context) =>
                                                  noteEditScreen(
                                                noteId: data.id.toString(),
                                              ),
                                            ));
                                      },
                                      icon: Icon(Icons.edit_note_outlined),
                                      color: colorY600,
                                    ),
                                  ],
                                ),
                              ),
                            ],
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
          //   child: ListView.builder(
          //     itemCount: 5,
          //     itemBuilder: (context, index) {
          //       return Container(
          //         margin: EdgeInsets.only(top: 15),
          //         child: Card(
          //           child: Text(
          //             'aksjak',
          //             style: TextStyle(fontSize: 18),
          //           ),
          //         ),
          //       );
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
