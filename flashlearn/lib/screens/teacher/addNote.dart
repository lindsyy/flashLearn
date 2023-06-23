import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class teachAddNoteScreen extends StatefulWidget {
  const teachAddNoteScreen({super.key, required this.id});
  final String id;

  @override
  State<teachAddNoteScreen> createState() => _teachAddNoteScreenState();
}

class _teachAddNoteScreenState extends State<teachAddNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final collectionPath = 'notes';
  final noteController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        title: Text(
          'Add Notes',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: colorY100,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: TextFormField(
                  controller: noteController,
                  minLines: 3,
                  maxLines: 10,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                      labelText: 'Note', border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Container(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      side: BorderSide(width: 1.3, color: Colors.black),
                      backgroundColor: colorY100,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    onPressed: () async {
                      EasyLoading.show(status: 'Note Adding...');
                      await FirebaseFirestore.instance
                          .collection(collectionPath)
                          .add({
                        'sub_id': widget.id,
                        'note': noteController.text,
                      });
                      EasyLoading.dismiss();
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      'Add Note',
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
