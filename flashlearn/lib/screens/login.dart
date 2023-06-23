import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flashlearn/screens/home.dart';
import 'package:flashlearn/screens/student/studHome.dart';
import 'package:flashlearn/screens/style.dart';
import 'package:flashlearn/screens/teacher/teachHome.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class loginScreen extends StatefulWidget {
  const loginScreen({super.key});

  @override
  State<loginScreen> createState() => _loginScreenState();
}

class _loginScreenState extends State<loginScreen> {
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorY300,
      appBar: AppBar(
        title: Text(
          'Login Your Account',
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
                  height: 300,
                  child: Image.asset(
                      'assets/images/Two factor authentication-bro.png')),
              SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextFormField(
                  controller: emailController,
                  validator: ((value) {
                    if (value == null || value.isEmpty) {
                      return '*Required. Please enter valid email address';
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
                    obscureText: obscurePassword,
                    controller: passwordController,
                    validator: ((value) {
                      if (value == null || value.isEmpty) {
                        return '*Required. Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password should be more than 6 characters';
                      }
                      return null;
                    }),
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
                height: 25,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: login,
                    child: Text(
                      'Login your Account',
                      style: TextStyle(color: Colors.black, fontSize: 18),
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
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    //login
    if (_formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Processing..');
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )
          .then((UserCredential) async {
        //fetch from the firestone
        String collectionPath = 'users';
        String userId = UserCredential.user!.uid;
        final docSnapshot = await FirebaseFirestore.instance
            .collection(collectionPath)
            .doc(userId)
            .get();
        dynamic data = docSnapshot.data();
        Widget landingScreen;
        if (data['type'] == 'Student') {
          landingScreen = StudentScreen();
        } else {
          landingScreen = teacherScreen(
            id: userId,
          );
        }
        // if (data['type'] == 'Client') {
        //   landingScreen = clientScreen(UserId: userId);
        // } else {
        //   landingScreen = establishmentScreen();
        // }

        // print(UserCredential);
        EasyLoading.dismiss();
        Navigator.push(context,
            CupertinoPageRoute(builder: (((context) => landingScreen))));
      }).catchError((err) {
        print(err);
        EasyLoading.showError('Invalid email and/or password');
      });
    }
  }
}
