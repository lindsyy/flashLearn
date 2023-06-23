import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class teachAddScreen extends StatefulWidget {
  const teachAddScreen({super.key});

  @override
  State<teachAddScreen> createState() => _teachAddScreenState();
}

class _teachAddScreenState extends State<teachAddScreen> {
  final _formKey = GlobalKey<FormState>();
  final collectionPath = 'subject';
  final subjectController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        title: Text(
          'Add Subject',
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
        child: Column(
          children: [
            SizedBox(
              height: 15,
            ),
            TextFormField(
              controller: subjectController,
              decoration: InputDecoration(labelText: 'Subject'),
            ),
            SizedBox(
              height: 25,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    EasyLoading.show(status: 'Subject Adding...');
                    await FirebaseFirestore.instance
                        .collection(collectionPath)
                        .add({
                      'title': subjectController.text,
                      'teachId': FirebaseAuth.instance.currentUser!.uid,
                    });
                    EasyLoading.dismiss();
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Add Subject',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
