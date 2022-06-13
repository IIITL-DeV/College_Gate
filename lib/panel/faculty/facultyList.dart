import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/guest/faculty_appointment.dart';
import 'package:college_gate/panel/student/studentfacutlyappointment.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class FacultyList extends StatefulWidget {
  bool isStudent;
  FacultyList({
    Key? key,
    required this.isStudent,
  }) : super(key: key);

  @override
  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance.collection("facultyUser").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.095;
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 56.h,
          backgroundColor: Color(0Xff15609c),
          centerTitle: true,
          title: Text(
            "Faculty List",
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
          ),
        ),
        body: StreamBuilder(
            stream: stream,
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                int value;
                value = snapshot.data!.docs.length;
                if (value == 0 || value == null) {
                  print("issssss$value");
                  return SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 150.h),
                        child: Column(
                          children: <Widget>[
                            //SizedBox(height: 266.h),
                            Image.asset(
                              'assets/nonotices.png',
                              //fit: BoxFit.fitWidth,
                              width: 228.w,
                              height: 228.h,
                              alignment: Alignment.center,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text("List Empty",
                                style: TextStyle(
                                  fontSize: 25.sp,
                                  fontWeight: FontWeight.w300,
                                  color: Color(0Xff14619C),
                                )),
                          ],
                        ),
                      ));
                }

                return ListView.builder(

                    shrinkWrap: true,
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final chatItem = snapshot.data!.docs[index];
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 5.h),
                        child: Card(
                          elevation: 2,
                          child: SizedBox(
                            height: 80.h,
                            child: ListView(
                              physics: const NeverScrollableScrollPhysics(),
                              children: [
                                ListTile(
                                  isThreeLine: false,
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => widget
                                                    .isStudent
                                                ? studentfacultyappointment(
                                                    email: chatItem["email"])
                                                : faculty_appointment(
                                                    email: chatItem["email"],
                                                    isStudent:
                                                        widget.isStudent,
                                                  )));
                                  },
                                  title: Text(
                                    "${chatItem["name"]}",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    "${chatItem["Designation"]}",
                                    //overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 11.sp),
                                  ),
                                  leading: ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 30.w,
                                      minHeight: 50.h,
                                      maxWidth: 60.h,
                                      maxHeight: 55.h,
                                    ),
                                    child: GestureDetector(
                                        child: Hero(
                                          tag: chatItem["ProfilePic"]!,
                                          child: Image.network(
                                              "${chatItem["ProfilePic"]}",
                                              fit: BoxFit.contain),
                                        ),
                                        onTap: () async {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return viewImage(
                                                chatItem["ProfilePic"]);
                                          }));
                                        }),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      );
                    });
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
