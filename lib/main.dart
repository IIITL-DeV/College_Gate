import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/student/complete_profile.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:college_gate/UI/warden/wardenhome.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'UI/gaurd/gaurd_home.dart';
import 'UI/student/exit_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
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
      if (FirebaseAuth.instance.currentUser!.email ==
          "iiitlcollegegate12@gmail.com") return gaurdHome();
      if (FirebaseAuth.instance.currentUser!.email == "singhanu3113@gmail.com")
        return wardenHome();
      return studentHome();
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: getScreen(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/logocg.png",
      text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Color(0xFF01579B),
        Color(0xFF388E3C),
      ],
      backgroundColor: Colors.white,
    );
    Widget example2 = SplashScreenView(
      navigateRoute: SignIn(),
      duration: 5000,
      imageSize: 130,
      imageSrc: "assets/logocg.png",
      text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Color(0xFF01579B),
        Colors.blue,
        Colors.green,
      ],
      backgroundColor: Colors.white,
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
