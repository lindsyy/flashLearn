import 'package:firebase_core/firebase_core.dart';
import 'package:flashlearn/firebase_options.dart';
import 'package:flashlearn/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(flashLearn());
}

class flashLearn extends StatelessWidget {
  const flashLearn({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      // home: StreamBuilder(
      //   builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      //     print(snapshot);

      //     if (snapshot.hasData) {
      //       var uid = FirebaseAuth.instance.currentUser!.uid;
      //       print(uid);
      //       return teacherScreen();
      //     } else {
      //       homScreen();
      //     }
      //   },
      //    stream: FirebaseAuth.instance.authStateChanges(),
      // ),

      home: homScreen(),
      builder: EasyLoading.init(),
      theme: ThemeData(
        fontFamily: GoogleFonts.montserrat().fontFamily,
        textTheme: const TextTheme(
          titleMedium: TextStyle(
            fontSize: 18,
          ),
          titleSmall: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
