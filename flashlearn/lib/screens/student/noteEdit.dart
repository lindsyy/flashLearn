import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class noteEditScreen extends StatefulWidget {
  const noteEditScreen({super.key, required this.noteId});
  final String noteId;

  @override
  State<noteEditScreen> createState() => _noteEditScreenState();
}

class _noteEditScreenState extends State<noteEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final noteController = TextEditingController();
  final collectionPath = 'notes';

  @override
  void initState() {
    // TODO: implement initState
    fetchdata();
    super.initState();
  }

  void fetchdata() async {
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(widget.noteId)
        .get();
    if (snapshot.exists) {
      setState(() {
        dynamic data = snapshot.data();
        noteController.text = data['note'];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(widget.noteId)
          .update({
        'note': noteController.text,
      });
      //Display a success message to the user
      EasyLoading.showSuccess('Notes has been updated');
      Navigator.pop(context);
      fetchdata();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY500,
      appBar: AppBar(
        backgroundColor: colorY100,
        title: Text(
          'Edit Your Note',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 35),
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
              padding: const EdgeInsets.only(left: 13, right: 13),
              child: Container(
                height: 46,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitForm,
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(width: 1.3, color: Colors.black),
                    backgroundColor: colorY100,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Update Note',
                    style: TextStyle(
                        fontSize: 18,
                        color: Colors.black,
                        fontWeight: FontWeight.w700),
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
