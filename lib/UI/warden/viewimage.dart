import 'package:flutter/material.dart';

class viewImage extends StatefulWidget {
  String idcardurl;
  viewImage(this.idcardurl);

  @override
  _viewImageState createState() => _viewImageState();
}

class _viewImageState extends State<viewImage> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          child: Hero(
              tag: widget.idcardurl, child: Image.network(widget.idcardurl))),
      onTap: () {
        Navigator.pop(context);
      },
    );
  }
}
