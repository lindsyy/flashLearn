import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/student/studHome.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class addSubScreen extends StatefulWidget {
  const addSubScreen({super.key});

  @override
  State<addSubScreen> createState() => _addSubScreenState();
}

class _addSubScreenState extends State<addSubScreen> {
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
          onPressed: () => Navigator.push(
              context,
              CupertinoPageRoute(
                builder: (context) => StudentScreen(),
              )),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: subjectController,
                decoration: InputDecoration(
                    labelText: 'Subject',
                    labelStyle: TextStyle(color: colorY100)),
              ),
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
                  onPressed: () async {
                    EasyLoading.show(status: 'Subject Adding...');
                    await FirebaseFirestore.instance
                        .collection(collectionPath)
                        .add({
                      'title': subjectController.text,
                      'studId': FirebaseAuth.instance.currentUser!.uid,
                    });
                    print('added subject');
                    EasyLoading.dismiss();
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.3, color: Colors.black),
                    backgroundColor: colorY100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Add Subject',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
