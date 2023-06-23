import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/home.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flashlearn/screens/teacher/teachHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class RegTScreen extends StatefulWidget {
  const RegTScreen({super.key});

  @override
  State<RegTScreen> createState() => _RegTScreenState();
}

class _RegTScreenState extends State<RegTScreen> {
  final _formKey = GlobalKey<FormState>();

  var obscurePassword = true;
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final collectionPath = 'users';

  void registerTeach() async {
    EasyLoading.show(status: 'Processing....');
    //register Firebase auth
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      if (userCredential.user == null) {
        throw FirebaseAuthException(code: 'null-usercredential');
      }
      //created user account -> uid
      String uid = userCredential.user!.uid;
      await FirebaseFirestore.instance.collection(collectionPath).doc(uid).set({
        'name': nameController.text,
        'address': addressController.text,
        'email': emailController.text,
        'password': passwordController.text,
        'type': 'Teacher',
      });
      EasyLoading.showSuccess('User account created');
      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => teacherScreen(
            id: uid,
          ),
        ),
      );
      // Navigator.push(
      //   context,
      //   CupertinoPageRoute(
      //     builder: ((context) => StudentScreen(UserId: uid)),
      //   ),
      // );
    } on FirebaseAuthException catch (ex) {
      EasyLoading.dismiss();
      if (ex.code == 'weak-password') {
        EasyLoading.showError('Your password has weak complexity');
        return;
      }
      if (ex.code == 'email-already-in-use') {
        EasyLoading.showError(
            ('Your email is already in use. Please enter another email'));
        return;
      }
      if (ex.code == 'null-usercredential') {
        EasyLoading.showError(
            ('An error occured while creating your account. Please try again'));
        return;
      }
    }
  }

  void validateInput() {
    //cause form to validate
    if (_formKey.currentState!.validate()) {
      QuickAlert.show(
          context: context,
          type: QuickAlertType.confirm,
          text: null,
          title: 'Are you sure?',
          confirmBtnText: 'Yes',
          cancelBtnText: 'No',
          onConfirmBtnTap: (() {
            Navigator.pop(context);
            registerTeach();
          }));
    }
    ;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY300,
      appBar: AppBar(
        title: Text(
          'Register as Teacher',
          style: TextStyle(color: Colors.black45),
        ),
        backgroundColor: color100,
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (context) => homScreen(),
                  ));
            },
            icon: Icon(
              Icons.arrow_back_ios_new,
              color: Colors.black,
            )),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                  width: 340,
                  height: 380,
                  child: Image.asset(
                      'assets/images/Two factor authentication-bro.png')),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: nameController,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your Name';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      labelText: 'Name',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: addressController,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your Address';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                      labelText: 'Address',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder()),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter your Email';
                    }
                    if (!EmailValidator.validate(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  }),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(fontSize: 18),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 60,
                  child: TextFormField(
                    controller: passwordController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your Password';
                      }
                      return null;
                    }),
                    obscureText: obscurePassword,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      labelStyle: TextStyle(fontSize: 18),
                      border: OutlineInputBorder(),
                      suffix: IconButton(
                        onPressed: () {
                          setState(() {
                            obscurePassword = !obscurePassword;
                          });
                        },
                        icon: Icon(obscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 46,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: validateInput,
                    child: Text(
                      'Register Account',
                      style: TextStyle(color: Colors.black, fontSize: 21),
                    ),
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      side: BorderSide(width: 1.3, color: colorY100),
                      backgroundColor: color200,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
