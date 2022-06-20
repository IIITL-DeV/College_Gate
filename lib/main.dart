import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyCompleteProfile.dart';
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/complete_profile.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:college_gate/panel/warden/wardenhome.dart';
import 'package:college_gate/firebase_options.dart';
import 'package:college_gate/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:splash_screen_view/SplashScreenView.dart';
import 'panel/gaurd/gaurd_home.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
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
  }

  Widget getScreen() {
    if (FirebaseAuth.instance.currentUser != null) {
      String? getemail = FirebaseAuth.instance.currentUser!.email;
      if (getemail != null && getemail.length >= 11) {
        getemail = getemail.substring(getemail.length - 12);
      }

      String? fullemail = FirebaseAuth.instance.currentUser!.email;
      bool isstudent = fullemail!.contains(new RegExp(r'[0-9]'));
      if (FirebaseAuth.instance.currentUser!.email ==
          "iiitlcollegegate12@gmail.com") return gaurdHome();
      if ("@iiitl.ac.in" == getemail && isstudent == true) {
        FirebaseFirestore.instance
            .collection('studentUser')
            .doc((FirebaseAuth.instance.currentUser)!.email)
            .get()
            .then((value) {
          String? idcard = value.data()!['idcard'].toString();
          if (idcard == "empty")
            return completeProfile();
          else
            return studentHome();
        });
      } else if ("@iiitl.ac.in" == getemail)
        FirebaseFirestore.instance
            .collection('facultyUser')
            .doc((FirebaseAuth.instance.currentUser)!.email)
            .get()
            .then((value) {
          String? idcard = value.data()?['ProfilePic'];
          if (idcard == "empty")
            return FacultyCompleteProfile();
          else
            return FacultyHome();
        });
    }
    return gaurdHome();
  }

  @override
  Widget build(BuildContext context) {
    Widget example1 = SplashScreenView(
      navigateRoute: getScreen(),
      duration: 500,
      imageSize: 500,
      imageSrc: "assets/from.png",
      // text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      backgroundColor: Colors.white,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Color(0xFF01579B)
        // Color(0xFF388E3C),
      ],
    );
    Widget example2 = SplashScreenView(
      navigateRoute: SignIn(),
      imageSize: 500,
      duration: 500,
      imageSrc: "assets/from.png",
      // text: "College Gate",
      textType: TextType.ColorizeAnimationText,
      textStyle: TextStyle(
        fontSize: 40.0,
      ),
      colors: [
        Color(0xFF388E3C),
        Color(0xFF01579B),
      ],
      backgroundColor: Colors.white,
    );

    return ScreenUtilInit(
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                );
              if (snapshot.hasError)
                return Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.black,
                  ),
                );
              if (snapshot.hasData) {
                return example1;
              } else
                return example2;
            },
          )),
      designSize: const Size(375, 812),
    );
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
      fontSize: 14.sp);
}
