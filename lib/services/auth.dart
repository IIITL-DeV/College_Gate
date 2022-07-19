import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/main.dart';
import 'package:college_gate/panel/faculty/facultyCompleteProfile.dart';
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/gaurd/gaurd_home.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:college_gate/panel/student/complete_profile.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;

  getCurrentUser() async {
    return await auth.currentUser;
  }

  signInWithGoogle(BuildContext context) async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await _googleSignIn.signIn();
    final GoogleSignInAuthentication? googleSignInAuthentication =
        await googleSignInAccount?.authentication;

    final AuthCredential mycredential = GoogleAuthProvider.credential(
      idToken: googleSignInAuthentication?.idToken,
      accessToken: googleSignInAuthentication?.accessToken,
    );

    UserCredential? userCredentialResult =
        await auth.signInWithCredential(mycredential);

    User? userDetails = userCredentialResult.user;

    String? getemail = userDetails!.email;
    bool isstudent = getemail!.contains(new RegExp(r'[0-9]'));

    getemail = getemail.substring(getemail.length - 12);

    if (FirebaseAuth.instance.currentUser!.email == "collegegate@iiitl.ac.in") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => gaurdHome()));
    } else if (userCredentialResult.additionalUserInfo!.isNewUser) {
      if ("@iiitl.ac.in" == getemail) {
        print(getemail);
        if (isstudent == true) {
          print("ohhhh yessssssssssssssssss");
          FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance
                .collection("studentUser")
                .doc(userDetails.email)
                .set({
              "userid": userDetails.uid,
              "email": userDetails.email,
              "enrollment": userDetails.email!
                  .replaceAll("@iiitl.ac.in", "")
                  .toUpperCase(),
              "name": userDetails.displayName,
              "exitisapproved": null,
              "entryisapproved": null,
              "purpose": null,
              "exitdatetime": null,
              "entrydatetime": null,
              "hostelno": null,
              "room": null,
              "phone": null,
              "idcard": "empty",
              "token": token,
            });
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => completeProfile()));
          });
        } else {
          FirebaseMessaging.instance.getToken().then((token) {
            FirebaseFirestore.instance
                .collection("facultyUser")
                .doc(userDetails.email)
                .set({
              "userid": userDetails.uid,
              "email": userDetails.email,
              "name": userDetails.displayName,
              "officeno": null,
              "Designation": null,
              "phone": null,
              "ProfilePic": "empty",
              "token": token,
            });
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => FacultyCompleteProfile()));
          });
        }
      } else {
        await flutterToast(
          "Only users with IIIT Lucknow email domain can sign in",
        );
        await AuthMethods().auth.signOut();
        await GoogleSignIn().signOut();
        return SignIn();
      }
    } else {
      print(getemail);
      if ("@iiitl.ac.in" == getemail) {
        if (isstudent == true) {
          String id;
          FirebaseFirestore.instance
              .collection("studentUser")
              .doc(userDetails.email)
              .get()
              .then((value) => {
                    id = value.data()!['idcard'].toString(),
                    if (id == "empty")
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => completeProfile()))
                      }
                    else
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => studentHome())),
                      }
                  });
        } else {
          String fid;
          FirebaseFirestore.instance
              .collection("facultyUser")
              .doc(userDetails.email)
              .get()
              .then((value) => {
                    fid = value.data()!['ProfilePic'].toString(),
                    if (fid == "empty")
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FacultyCompleteProfile()))
                      }
                    else
                      {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => FacultyHome())),
                      }
                  });
        }
      } else {
        await flutterToast(
          "Only users with IIIT Lucknow email domain can sign in",
        );
        await AuthMethods().auth.signOut();
        // await GoogleSignIn().signOut();
        return SignIn();
      }
    }
  }

  Future logout() async {
    await auth.signOut();
    await GoogleSignIn().disconnect();
  }
}
