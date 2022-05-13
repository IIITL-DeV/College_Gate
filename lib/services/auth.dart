import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/gaurd/gaurd_home.dart';
import 'package:college_gate/UI/student/complete_profile.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:college_gate/UI/warden/wardenhome.dart';
import 'package:college_gate/helperfunctions/sp_helper.dart';
import 'package:college_gate/services/database.dart';
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

    final User? user = userCredentialResult.user;

    User? userDetails = userCredentialResult.user;
    if (userCredentialResult != null) {
      SharedPreferenceHelper().saveUserEmail(userDetails!.email);
      SharedPreferenceHelper().saveUserId(userDetails.uid);
      SharedPreferenceHelper()
          .saveUserName(userDetails.email?.replaceFirst(RegExp(r"\.[^]*"), ""));
      SharedPreferenceHelper().saveDisplayName(userDetails.displayName);
      SharedPreferenceHelper().saveUserProfileUrl(userDetails.photoURL);

      Map<String, dynamic> studentUserInfoMap = {
        "userid": userDetails.uid,
        "email": userDetails.email,
        "enrollment": userDetails.email?.replaceAll("@iiitl.ac.in", ""),
        //replaceFirst(RegExp(r"\.[^]*"), ""),
        "name": userDetails.displayName,
        "profileUrl": userDetails.photoURL,
        "exitisapproved": null,
        "entryisapproved": null,
      };

      DatabaseMethods()
          .addStudentUserInfoToDB(userDetails.uid, studentUserInfoMap)
          .then((s) {
        if (FirebaseAuth.instance.currentUser!.email ==
            "iiitlcollegegate12@gmail.com") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => gaurdHome()));
        } else if (FirebaseAuth.instance.currentUser!.email ==
            "singhanu3113@gmail.com") {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => wardenHome()));
        } else if (userCredentialResult.additionalUserInfo!.isNewUser) {
          if (user != null) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => completeProfile()));
          }
        } else {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => studentHome()));
        }
      });
    }
  }

  Future logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
    auth.signOut();
  }
}
