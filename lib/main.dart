import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:college_gate/panel/warden/wardenhome.dart';
import 'package:college_gate/firebase_options.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'panel/gaurd/gaurd_home.dart';
import 'package:fluttertoast/fluttertoast.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    super.initState();
    new Future.delayed(
      const Duration(seconds: 3),
    );
  }

  Widget? getScreen() {
    if (FirebaseAuth.instance.currentUser != null) {
      String? getemail = FirebaseAuth.instance.currentUser!.email;
      if (getemail != null && getemail.length >= 11) {
        getemail = getemail.substring(getemail.length - 12);
      }

      String? fullemail = FirebaseAuth.instance.currentUser!.email;
      bool isstudent = fullemail!.contains(new RegExp(r'[0-9]'));
      if (FirebaseAuth.instance.currentUser!.email ==
          "iiitlcollegegate12@gmail.com") return gaurdHome();
      if (FirebaseAuth.instance.currentUser!.email == "singhanu3113@gmail.com")
        return wardenHome();
      if ("@iiitl.ac.in" == getemail && isstudent == true)
        return studentHome();
      else if ("@iiitl.ac.in" == getemail)
        return FacultyHome();
      else
        return SignIn();
    } else
      return SignIn();
  }

  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: getScreen(),
      // duration: 5000,
      imageSize: 130,
      imageSrc: "assets/cg_white.png",
      text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      backgroundColor: Color(0xFF01579B),
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Colors.white,
        // Color(0xFF388E3C),
      ],
    );
    Widget example2 = SplashScreenView(
      navigateRoute: SignIn(),
      imageSize: 130,
      imageSrc: "assets/cg_white.png",
      text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Colors.white,
      ],
      backgroundColor: Color(0xFF01579B),
    );

    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        home: FutureBuilder(
          future: AuthMethods().getCurrentUser(),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData)
              return example1;
            else
              return example2;
          },
        ));
  }
}


Future<bool?> flutterToast(String str) {
  return Fluttertoast.showToast(
      msg: str.toString(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.CENTER,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0);
}
