import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flashlearn/screens/teacher/addNote.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class teachNoteScreen extends StatefulWidget {
  const teachNoteScreen({super.key, required this.id});
  final String id;

  @override
  State<teachNoteScreen> createState() => _teachNoteScreenState();
}

class _teachNoteScreenState extends State<teachNoteScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        backgroundColor: colorY100,
        title: Text(
          'Subject Note',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back_ios_new, color: Colors.black)),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => teachAddNoteScreen(
                      id: widget.id,
                    ),
                  ),
                );
              },
              icon: Icon(Icons.add_box_rounded, color: Colors.black))
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
                      margin: EdgeInsets.only(top: 15),
                      child: Card(
                        child: ListTile(
                          title: data['note'],
                        ),
                        // child: Text(
                        //   data['note'],
                        //   style: TextStyle(fontSize: 18),
                        // ),
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
