import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/homepagecard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
//import 'package:image_picker/image_picker.dart';

class idcardImage extends StatefulWidget {
  @override
  _idcardImageState createState() => _idcardImageState();
}

class _idcardImageState extends State<idcardImage> {
  File? _imageFile = null;

  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.getImage(
      source: ImageSource.camera,
    );

    setState(() {
      _imageFile = File(pickedFile!.path);
    });
  }

  // Future<Null> _cropImage() async {
  //   File? croppedFile = await ImageCropper.cropImage(
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
  //     _imageFile = croppedFile;
  //     setState(() {
  //       state = AppState.cropped;
  //     });
  //   }
  // }

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
    var idcard;
    uploadTask.whenComplete(() async {
      try {
        idcard = await ref.getDownloadURL();
      } catch (onError) {
        print("Error");
      }

      print(idcard);
      await FirebaseFirestore.instance
          .collection('studentUser')
          .doc((FirebaseAuth.instance.currentUser!).uid)
          .set({'idcard': idcard}, SetOptions(merge: true));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        title: Text("College Gate"),
      ),
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          // Container(
          //   height: 360,
          //   decoration: BoxDecoration(
          //     borderRadius: BorderRadius.only(
          //         bottomLeft: Radius.circular(250.0),
          //         bottomRight: Radius.circular(10.0)),
          //   ),
          // ),
          Container(
            // margin: const EdgeInsets.only(top: 80),
            child: Column(
              children: <Widget>[
                SizedBox(height: 100),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Text(
                      "Scan your ID Card",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        //fontStyle: FontStyle.italic
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Stack(
                    children: <Widget>[
                      Container(
                        //decoration: Decor,
                        //width: double.infinity,
                        height: 600,
                        // margin: const EdgeInsets.only(
                        //     left: 10.0, right: 10.0, top: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30.0),
                          child: _imageFile != null
                              ? Image.file(_imageFile!)
                              : FlatButton(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    color: Colors.blue,
                                    size: 50,
                                  ),
                                  onPressed: pickImage,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                //uploadImageButton(context),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        minimumSize: const Size(400, 50),
                        alignment: Alignment.center,
                        primary: const Color(0xFF14619C)),
                    onPressed: () => {
                      uploadImageToFirebase(context),
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => studentHome())),
                    },
                    child: const Text(
                      'Submit',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
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
            child: FlatButton(
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
