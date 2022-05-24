import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyProfile.dart';
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:college_gate/panel/student/homepagecard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

ImagePicker picker = ImagePicker();
//import 'package:image_picker/image_picker.dart';

class facultyidcard extends StatefulWidget {
  @override
  _facultyidcardState createState() => _facultyidcardState();
}

class _facultyidcardState extends State<facultyidcard> {
  File? _imageFile = null;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}

  ImagePicker picker = ImagePicker();

  // Future captureImage() async {
  //   final pickedFile = await picker.getImage(
  //     source: ImageSource.camera,
  //   );

  //   setState(() {
  //     _imageFile = File(pickedFile!.path);
  //   });
  // }

  Future pickImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  var idcard;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = basename(_imageFile!.path);
    Reference ref =
        FirebaseStorage.instance.ref().child('uploads').child('/$fileName');

    final metadata = SettableMetadata(
        contentType: 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    uploadTask = ref.putFile(File(_imageFile!.path), metadata);

    UploadTask task = await Future.value(uploadTask);
    Future.value(uploadTask)
        .then((value) => {print("Upload file path ${value.ref.fullPath}")})
        .onError((error, stackTrace) =>
            {print("Upload file path error ${error.toString()} ")});

    uploadTask.whenComplete(() async {
      try {
        idcard = await ref.getDownloadURL();
      } catch (onError) {
        print("Error");
      }

      print(idcard);
      await FirebaseFirestore.instance
          .collection('facultyUser')
          .doc((FirebaseAuth.instance.currentUser!).email)
          .update(
        {'ProfilePic': idcard},
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: heightMobile * 0.028,
                child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 10,
            ),
            Text("College Gate",
                style: TextStyle(fontSize: heightMobile * 0.028)),
          ],
        ),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          Container(
            // margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                SizedBox(height: heightMobile * 0.1),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Upload Profile Picture",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: heightMobile * 0.025,
                        //fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
                SizedBox(height: heightMobile * 0.01),

                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        //decoration: Decor,
                        //width: double.infinity,
                        height: heightMobile * 0.6,
                        // margin: const EdgeInsets.only(
                        //     left: 10.0, right: 10.0, top: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // ClipRRect(
                            //   borderRadius: BorderRadius.circular(30.0),
                            //   child: _imageFile != null
                            //       ? Image.file(_imageFile!)
                            //       : FlatButton(
                            //           child: Icon(
                            //             Icons.add_a_photo,
                            //             color: Colors.blue,
                            //             size: 50,
                            //             //semanticLabel: "Take Picture",
                            //           ),
                            //           onPressed: captureImage,
                            //         ),
                            // ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30.0),
                              child: _imageFile != null
                                  ? Image.file(_imageFile!)
                                  : FlatButton(
                                      child: Icon(
                                        Icons.photo,
                                        color: Colors.blue,
                                        size: 50,
                                        //semanticLabel: "Take Picture",
                                      ),
                                      onPressed: pickImage,
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: heightMobile * 0.2,
                ),
                //uploadImageButton(context),
                Padding(
                  padding: EdgeInsets.all(heightMobile * 0.02),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: Size(widthMobile, heightMobile * 0.055),
                        alignment: Alignment.center,
                        primary: const Color(0xFF14619C)),
                    onPressed: () => {
                      uploadImageToFirebase(context),
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => FacultyHome())),
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: heightMobile * 0.022,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget uploadImageButton(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 5.0, horizontal: 16.0),
            margin: const EdgeInsets.only(
                top: 30, left: 20.0, right: 20.0, bottom: 20.0),
            child: ElevatedButton(
              onPressed: () {},
              child: Text(
                "Upload Image",
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
