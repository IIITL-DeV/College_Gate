import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyCompleteProfile.dart';
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/gaurd/gaurd_home.dart';
import 'package:college_gate/panel/student/complete_profile.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:college_gate/panel/warden/wardenhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    if (getemail != null && getemail.length >= 11) {
      getemail = getemail.substring(getemail.length - 12);
    }

    String? fullemail = userDetails.email;

    bool isstudent = fullemail!.contains(new RegExp(r'[0-9]'));

    if (userCredentialResult != null) {
      if (FirebaseAuth.instance.currentUser!.email ==
          "iiitlcollegegate12@gmail.com") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => gaurdHome()));
      } else if (FirebaseAuth.instance.currentUser!.email ==
          "singhanu3113@gmail.com") {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => wardenHome()));
      } else if (userCredentialResult.additionalUserInfo!.isNewUser) {
        if (userDetails != null) {
          if ("@iiitl.ac.in" == getemail) {
            print(getemail);
            if (isstudent == true) {
              print("ohhhh yessssssssssssssssss");
              await FirebaseFirestore.instance
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
                "idcard": null,
              });
              await Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => completeProfile()));
            } else {
              await FirebaseFirestore.instance
                  .collection("facultyUser")
                  .doc(userDetails.email)
                  .set({
                "userid": userDetails.uid,
                "email": userDetails.email,
                "name": userDetails.displayName,
                "officeno": null,
                "Designation": null,
                "phone": null,
                "ProfilePic": null,
              });
              await Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => FacultyCompleteProfile()));
            }
          } else {
            SnackBar(
              content: Text("Unauthorized email address"),
            );
          }
        }
      } else {
        print(getemail);
        if ("@iiitl.ac.in" == getemail) {
          if (isstudent == true) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => studentHome()));
          } else {
            await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => FacultyHome()));
          }
        } else {
          SnackBar(
            content: Text("Unauthorized email address"),
          );
        }
      }
    }
    ;
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    auth.signOut();
  }
}
