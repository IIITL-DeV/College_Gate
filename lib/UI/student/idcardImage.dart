import 'package:flutter/material.dart';
import 'dart:io';
//import 'package:image_picker/image_picker.dart';

class idcardImage extends StatefulWidget {
  @override
  _idcardImageState createState() => _idcardImageState();
}

class _idcardImageState extends State<idcardImage> {
  late File image;
  late String imgUrl;
  Future getImage() async {
    //var img = await ImagePicker.pickImage(source: ImageSource.gallery);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SingleChildScrollView(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Column(children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    height: 400,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        InkWell(
                          child: CircleAvatar(
                            radius: 100,
                            backgroundImage: image != null
                                ? FileImage(image)
                                : NetworkImage("null") as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ]))));
  }
}
