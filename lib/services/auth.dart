import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/gaurd/gaurd_home.dart';
import 'package:college_gate/UI/student/complete_profile.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:college_gate/UI/warden/wardenhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthMethods {
  final FirebaseAuth auth = FirebaseAuth.instance;
  String? roomno, phoneno, signinas;

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
          await FirebaseFirestore.instance
              .collection("studentUser")
              .doc(userDetails.email)
              .set({
            "userid": userDetails.uid,
            "email": userDetails.email,
            "enrollment": userDetails.email!.replaceAll("@iiitl.ac.in", ""),
            "name": userDetails.displayName,
            "exitisapproved": null,
            "entryisapproved": null,
            "room": null,
            "phone": null,
            "idcard": null,
            "signinas": null,
          });
          await Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => completeProfile()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => studentHome()));
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
