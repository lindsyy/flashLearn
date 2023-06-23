import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class accountScreen extends StatefulWidget {
  const accountScreen({super.key});

  @override
  State<accountScreen> createState() => _accountScreenState();
}

class _accountScreenState extends State<accountScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final addController = TextEditingController();
  final emailControlller = TextEditingController();
  final passController = TextEditingController();
  final collectionPath = 'users';
  var obscurePassword = true;

  @override
  void initState() {
    // TODO: implement initState
    fetchdata();
    super.initState();
  }

  void fetchdata() async {
    final user = FirebaseAuth.instance.currentUser;
    final uid = user!.uid;
    final DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection(collectionPath)
        .doc(uid)
        .get();
    if (snapshot.exists) {
      setState(() {
        dynamic data = snapshot.data();
        nameController.text = data['name'];
        addController.text = data['address'];
        emailControlller.text = data['email'];
        passController.text = data['password'];
      });
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      //get the current user ID
      final user = FirebaseAuth.instance.currentUser;
      final uid = user!.uid;

      //Update the user document with the new details

      await FirebaseFirestore.instance
          .collection(collectionPath)
          .doc(uid)
          .update({
        'name': nameController.text,
        'address': addController.text,
        'email': emailControlller.text,
        'password': passController.text,
      });
      //Display a success message to the user
      EasyLoading.showSuccess('Account has been updated');
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
          'Account',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back_ios_new, color: Colors.black),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: TextFormField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Name',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: TextFormField(
                    controller: addController,
                    decoration: InputDecoration(
                      labelText: 'Address',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: TextFormField(
                    controller: emailControlller,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                  child: Container(
                    height: 60,
                    child: TextFormField(
                      obscureText: obscurePassword,
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(),
                        suffix: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword = !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 25,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
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
                        'Update',
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
        ),
      ),
    );
  }
}
