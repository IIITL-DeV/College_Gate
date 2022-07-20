import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/faculty/facultyhome.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:mime/mime.dart';
import 'package:college_gate/services/ui_helper.dart'
if (dart.library.io) 'package:college_gate/services/mobile_ui_helper.dart'
if (dart.library.html) 'package:college_gate/services/web_ui_helper.dart';

ImagePicker picker = ImagePicker();
//import 'package:image_picker/image_picker.dart';

class facultyidcard extends StatefulWidget {
  final bool isnewuser;

  facultyidcard({Key? key, required this.isnewuser}) : super(key: key);
  @override
  _facultyidcardState createState() => _facultyidcardState();
}

class _facultyidcardState extends State<facultyidcard> {
  File? _imageFile = null;
  Uint8List? img = null;
  ///NOTE: Only supported on Android & iOS
  ///Needs image_picker plugin {https://pub.dev/packages/image_picker}
  final picker = ImagePicker();

  Future pickImage() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 30,
    );
    final imagedata = await pickedFile?.readAsBytes();
    setState(() {
      _imageFile = File(pickedFile!.path);
      img = imagedata;
    });
  }

  Future<void> _cropImage() async {
    if (_imageFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
          sourcePath: _imageFile!.path,
          uiSettings: buildUiSettings(context),
      );
      if (croppedFile != null) {
        setState(() {
          _imageFile = File(croppedFile.path);
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

    String? mimeType = lookupMimeType(_imageFile!.path);
    final metadata = SettableMetadata(
        contentType: mimeType ?? 'image/jpeg',
        customMetadata: {'picked-file-path': fileName});
    UploadTask uploadTask;
    //late StorageUploadTask uploadTask = firebaseStorageRef.putFile(_imageFile);
    if(!kIsWeb){
      uploadTask = ref.putFile(File(_imageFile!.path), metadata);
    } else {
      uploadTask = ref.putData(img!, metadata);
    }

    //uploadTask = ref.putFile(File(_imageFile!.path), metadata);

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
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 21.sp, child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 12.w,
            ),
            Text("College Gate", style: TextStyle(fontSize: 21.sp)),
            //SizedBox(width: 50.w,),
          ],
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          children: [
            SizedBox(height: 50.h),
            Text(
              "Select Your Profile Picture",
              style: TextStyle(
                color: Color(0Xff15609c),
                fontSize: 19.h,
                // fontStyle: FontStyle.itali
              ),
            ),
            SizedBox(height: 6.h),
            // Text(
            //   "NOTE: IMMUTABLE",
            //   style: TextStyle(
            //       color: Colors.red,
            //       fontSize: heightMobile * 0.015,
            //       fontStyle: FontStyle.italic),
            // ),
            SizedBox(height: 30.h),
            Container(
              //decoration: Decor,
              //width: double.infinity,
              height: 300.h,
              // margin: const EdgeInsets.only(
              //     left: 10.0, right: 10.0, top: 10.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30.0),
                child: _imageFile != null
                    ? kIsWeb ? Image.memory(img!) : Image.file(_imageFile!)
                    : TextButton(
                        child: Icon(
                          Icons.photo,
                          color: Color(0Xff15609c),
                          size: 50.sp,
                          //semanticLabel: "Take Picture",
                        ),
                        onPressed: pickImage,
                      ),
              ),
            ),
            SizedBox(
              height: 50.h,
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
                            size: 30.sp,
                          ),
                          onTap: () {
                            setState(() {
                              _imageFile = null;
                            });
                          },
                        ),
                        SizedBox(
                          width: 100.w,
                        ),
                        GestureDetector(
                          child: Icon(
                            Icons.edit,
                            color: Color(0Xff15609c),
                            size: 30.sp,
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
              height: 60.h,
            ),
            //uploadImageButton(context),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25.w),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(15.0),
                    ),
                    padding: EdgeInsets.all(12),
                    minimumSize: Size(MediaQuery.of(context).size.width, 38.h),
                    alignment: Alignment.center,
                    primary: const Color(0xFF14619C)),
                onPressed: () async => {
                  if (_imageFile != null)
                    {
                      uploadImageToFirebase(context),
                      await widget.isnewuser
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FacultyHome()))
                          : {
                              Navigator.of(context).pop(),
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => FacultyHome()))
                            },
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
                    fontSize: 16.sp,
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
