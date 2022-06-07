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
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.gallery,
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      File? croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile!.path,
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Edit',
              toolbarColor: Color(0Xff15609c),
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          ));
      if (croppedFile != null) {
        setState(() {
          _imageFile = croppedFile;
        });
      }
    }
  }
  // Future<Null> _cropImage() async {
  //   File? croppedFile = await ImageCropper().cropImage(
  //       sourcePath: _imageFile!.path,
  //       aspectRatioPresets: Platform.isAndroid
  //           ? [
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio16x9
  //             ]
  //           : [
  //               CropAspectRatioPreset.original,
  //               CropAspectRatioPreset.square,
  //               CropAspectRatioPreset.ratio3x2,
  //               CropAspectRatioPreset.ratio4x3,
  //               CropAspectRatioPreset.ratio5x3,
  //               CropAspectRatioPreset.ratio5x4,
  //               CropAspectRatioPreset.ratio7x5,
  //               CropAspectRatioPreset.ratio16x9
  //             ],
  //       androidUiSettings: AndroidUiSettings(
  //           toolbarTitle: 'Cropper',
  //           toolbarColor: Colors.deepOrange,
  //           toolbarWidgetColor: Colors.white,
  //           initAspectRatio: CropAspectRatioPreset.original,
  //           lockAspectRatio: false),
  //       iosUiSettings: IOSUiSettings(
  //         title: 'Cropper',
  //       ));
  //   if (croppedFile != null) {
  //     //  state = AppState.cropped;
  //     setState(() {
  //       _imageFile = croppedFile;
  //     });
  //   }
  // }

  var idcard;

  Future uploadImageToFirebase(BuildContext context) async {
    String fileName = FirebaseAuth.instance.currentUser!.email.toString();
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
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: heightMobile * 0.05),
            Text(
              "Select Your Profile Picture",
              style: TextStyle(
                color: Color(0Xff15609c),
                fontSize: heightMobile * 0.025,
                // fontStyle: FontStyle.itali
              ),
            ),
            SizedBox(height: 6),
            // Text(
            //   "NOTE: IMMUTABLE",
            //   style: TextStyle(
            //       color: Colors.red,
            //       fontSize: heightMobile * 0.015,
            //       fontStyle: FontStyle.italic),
            // ),
            SizedBox(height: heightMobile * 0.03),
            Container(
              //decoration: Decor,
              //width: double.infinity,
              height: heightMobile * 0.4,
              // margin: const EdgeInsets.only(
              //     left: 10.0, right: 10.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: _imageFile != null
                    ? Image.file(_imageFile!)
                    : FlatButton(
                        child: Icon(
                          Icons.photo,
                          color: Color(0Xff15609c),
                          size: 50,
                          //semanticLabel: "Take Picture",
                        ),
                        onPressed: pickImage,
                      ),
              ),
            ),
            SizedBox(
              height: heightMobile * 0.08,
            ),
            Container(
              child: _imageFile != null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          child: Icon(
                            Icons.photo,
                            color: Color(0Xff15609c),
                            size: 30,
                          ),
                          onTap: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                        SizedBox(
                          width: widthMobile * 0.3,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Color(0Xff15609c),
                            size: 30,
                          ),
                          onTap: () {
                            _cropImage();
                          },
                        )
                      ],
                    )
                  : Text(""),
            ),

            SizedBox(
              height: heightMobile * 0.07,
            ),
            //uploadImageButton(context),
            Padding(
              padding: EdgeInsets.all(heightMobile * 0.02),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(heightMobile * 0.017),
                    minimumSize: Size(widthMobile, heightMobile * 0.028),
                    alignment: Alignment.center,
                    primary: const Color(0xFF14619C)),
                onPressed: () async => {
                  if (_imageFile != null)
                    {
                      uploadImageToFirebase(context),
                      await Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => studentHome())),
                    }
                  else
                    {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content:
                                Text('Please select your profile picture.')),
                      ),
                    }
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
