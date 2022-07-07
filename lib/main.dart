import 'dart:convert';
import 'package:college_gate/services/auth.dart';
import 'package:http/http.dart' as http;
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:college_gate/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'panel/gaurd/gaurd_home.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fluttertoast/fluttertoast.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<MyApp> {
  void initState() {
    requestPermission();
    loadFCM();
    listenFCM();
    super.initState();
  }

  void loadFCM() async {
    if (!kIsWeb) {
      var channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        enableVibration: true,
      );
      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.

      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  void listenFCM() async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null && !kIsWeb) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              "123",
              "ANU",
              icon: "@mipmap/launcher_icon",
            ),
          ),
        );
      }
    });
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }
  }

  Widget getScreen() {
    return AuthMethods().signInWithGoogle(context);
    // return Center(child: CircularProgressIndicator());
    // String? getemail = FirebaseAuth.instance.currentUser!.email;

    // bool isstudent = getemail!.contains(new RegExp(r'[0-9]'));
    // getemail = getemail.substring(getemail.length - 12);
    // if (FirebaseAuth.instance.currentUser!.email == "collegegate@iiitl.ac.in")
    //   return gaurdHome();
    // else if ("@iiitl.ac.in" == getemail && isstudent == true) {
    //   return studentHome();
    //   // });
    // } else if ("@iiitl.ac.in" == getemail && isstudent == false) {
    //   // await FirebaseFirestore.instance
    //   //     .collection('facultyUser')
    //   //     .doc((FirebaseAuth.instance.currentUser)!.email)
    //   //     .get()
    //   //     .then((value) {
    //   //   String? idcard = value.data()?['ProfilePic'];
    //   //   if (idcard == "empty") return FacultyCompleteProfile();

    //   return FacultyHome();
    //   // });
    // }
    // return SignIn();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(),
          home: StreamBuilder<User?>(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (BuildContext context, snapshot) {
              try {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Container(
                    color: Colors.white,
                    child: Center(
                        child: CircularProgressIndicator(
                            // backgroundColor: Colors.white,
                            )),
                  );
                else if (snapshot.hasError)
                  return Container(
                    color: Colors.white,
                    child: Center(
                        child: CircularProgressIndicator(
                            // backgroundColor: Colors.white,
                            )),
                  );
                else if (snapshot.hasData) {
                  return AuthMethods().signInWithGoogle(context);
                } else
                  return SignIn();
              } catch (e) {
                return Container(
                  color: Colors.white,
                  child: Center(
                      child: CircularProgressIndicator(
                          // backgroundColor: Colors.white,
                          )),
                );
              }
            },
          )),
      designSize: const Size(375, 812),
    );
  }
}

void sendPushMessage(String body, String title, String token) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization':
            'key=AAAATJ-qFwk:APA91bGo60cYWNc5st2be2OSLvMHm9eEF7TFrz2dEkLrdl6nBWgTjz-CC_6UOWHj2xApzNtpOyRj-_3_w-RRC2Yc-iXfEh_5NkTgxH3sIYoA3GhE6NNSgdAMeYHcXf0w_5Ck5mZR1U0B',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title,
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": token,
        },
      ),
    );
    print('done');
  } catch (e) {
    print("error push notification");
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
