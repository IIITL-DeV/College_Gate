import 'package:date_format/date_format.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:google_fonts/google_fonts.dart';

class AboutUs extends StatefulWidget {
  const AboutUs({Key? key}) : super(key: key);

  @override
  State<AboutUs> createState() => _AboutUsState();
}

class _AboutUsState extends State<AboutUs> {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("About Team", style: TextStyle(fontSize: 21.sp)),
        toolbarHeight: 56.h,
        elevation: 1,
        backgroundColor: Color(0Xff15609c),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            dragStartBehavior: DragStartBehavior.down,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  _productWidget(),
                  Divider(
                      // height: 5.h,
                      ),
                  Center(
                    child: Text(
                      "To report any bug or for any queries feel free to contact us.",
                      style:
                          TextStyle(color: Color(0Xff15609c), fontSize: 9.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    height: 2,
                  ),
                  Center(
                    child: Text(
                      "© 2019 Indian Insitute of Information Technology Lucknow. All rights reserved.",
                      style:
                          TextStyle(color: Color(0Xff15609c), fontSize: 9.sp),
                      textAlign: TextAlign.center,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _productWidget() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height * .75,
      child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1 / 1.5,
              mainAxisSpacing: 20,
              crossAxisSpacing: 20),
          padding: EdgeInsets.all(20),
          scrollDirection: Axis.vertical,
          children: [
            ProductCard(
              image: "assets/anu.jpg",
              name: "Anu Kumari",
              phone: "+919324121272",
              title: "Software Developer",
              subtitle: "(Back-End)",
            ),
            ProductCard(
              image: "assets/nik.jpg",
              name: "Jagnik C.",
              phone: "+917856009040",
              title: "Software Developer",
              subtitle: "(UI/UX)",
            ),
            ProductCard(
              image: "assets/kratika.jpg",
              name: "Kratika Jain",
              phone: "+919929160355",
              title: "Product Designer",
              subtitle: "(Product Documentation)",
            ),
            ProductCard(
              image: "assets/Sameer.jpeg",
              name: "Sameer Makar",
              phone: "+919549571425",
              title: "Q/A Engineer",
              subtitle: "",
            ),
            // ProductCard(
            //   image: "assets/profile_darkbluecolor.png",
            //   name: "Vishal Krishna Singh",
            //   phone: "Vishal Krishna Singh",
            //   title: "Supervisor",
            // ),
            // ProductCard(
            //   image: "assets/profile_darkbluecolor.png",
            //   name: "Vishal Krishna Singh",
            //   phone: "Vishal Krishna Singh",
            //   title: "Supervisor",
            // ),
          ].toList()),
    );
  }
}

class ProductCard extends StatelessWidget {
  String? image;

  String? title;

  String? name;
  String subtitle;
  String? phone;

  ProductCard(
      {Key? key,
      required this.image,
      required this.title,
      required this.subtitle,
      required this.name,
      required this.phone})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        // color: Color(0Xff15609c),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        boxShadow: <BoxShadow>[
          BoxShadow(color: Color(0xfff8f8f8), blurRadius: 15, spreadRadius: 10),
        ],
      ),
      margin: EdgeInsets.symmetric(vertical: 0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            // Positioned(
            //   left: 0,
            //   top: 0,
            //   child: IconButton(
            //     icon: Icon(
            //       product.isliked ? Icons.favorite : Icons.favorite_border,
            //       color:
            //           product.isliked ? LightColor.red : LightColor.iconColor,
            //     ),
            //     onPressed: () {},
            //   ),
            // ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                // SizedBox(height: product.isSelected ? 15 : 0),
                Expanded(
                  child: Stack(
                    alignment: Alignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundImage: AssetImage(image!),
                        radius: 60,
                        backgroundColor: Color(0Xff15609c),
                      ),
                    ],
                  ),
                ),
                // SizedBox(height: 5),
                TitleText(
                  text: title!,
                  fontSize: 13,
                  color: Color(0Xff15609c),
                ),
                TitleText(
                  text: subtitle,
                  fontSize: 8,
                  color: Color.fromARGB(255, 96, 146, 188),
                ),
                SizedBox(
                  height: 4,
                ),
                TitleText(
                  text: name!,
                  fontSize: 12,
                  color: Colors.grey,
                ),
                TitleText(
                  text: phone!,
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TitleText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;
  final FontWeight fontWeight;
  const TitleText(
      {Key? key,
      required this.text,
      this.fontSize = 4,
      this.color = Colors.green,
      this.fontWeight = FontWeight.w800})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Text(text,
        textAlign: TextAlign.center,
        style: GoogleFonts.mulish(
            fontSize: fontSize, fontWeight: fontWeight, color: color));
  }
}
