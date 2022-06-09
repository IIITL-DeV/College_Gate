import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({Key? key}) : super(key: key);

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  List<String>? filePath;
  List<List<String>> rows = [];

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = ['$path/data.csv'];
    return File('$path/data.csv').create();
  }

  getCsv() async {
    File f = await _localFile;

    String csv = const ListToCsvConverter().convert(rows);

    f.writeAsString(csv);
  }

  sendMailAndAttachment() async {
    await FlutterEmailSender.send(Email(
      body: 'Hey, the CSV made it!',
      subject: 'Register for ${DateTime.now().toString()}',
      recipients: ['iiitlcollegegate12@gmail.com'],
      isHTML: true,
      attachmentPaths: filePath,
    ));
  }

  var stream;
  @override
  void initState() {
    super.initState();
    rows = [
      <String>[
        "name",
        "purpose",
        "room",
        "exitdate",
        "exittime",
        "entrydate",
        "entrytime",
      ]
    ];
    stream = FirebaseFirestore.instance
        .collection("studentRegister")
        // .orderBy(
        //   "purpose",
        // )
        .where("purpose", isEqualTo: "Outing")
        // .orderBy("purpose")
        .orderBy("exitdate", descending: true)
        .orderBy("exittime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    //double widthMobile = MediaQuery.of(context).size.width;
    //double heightMobile = MediaQuery.of(context).size.height;
    // double cardheight = heightMobile * 0.13;
    // if(cardheight>101) cardheight = 100;
    //print(cardheight);

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Text(
          "Student Register",
          style: TextStyle(fontSize: 20.sp,fontWeight: FontWeight.w500),
        ),
      ),
      // appBar: AppBar(
      //     backgroundColor: Color(0Xff15609c),
      //     title: Text(
      //       "College Gate",
      //       style: TextStyle(fontSize: heightMobile * 0.025),
      //     ),
      //     actions: [
      //       InkWell(
      //         onTap: () {
      //           AuthMethods().logout().then((s) {
      //             Navigator.pushReplacement(context,
      //                 MaterialPageRoute(builder: (context) => SignIn()));
      //           });
      //         },
      //         child: Container(
      //             padding:
      //                 EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
      //             child: Icon(
      //               Icons.exit_to_app,
      //               color: Colors.deepPurple[50],
      //               size: heightMobile * 0.027,
      //             )),
      //       )
      //     ]),
      body: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                        SizedBox(height: 30.h,),
                        Text("No Entry",
                            style: TextStyle(
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w300,
                              color: Color(0Xff14619C),
                            )),
                      ],
                    ),
                  ));
            } else
              return ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final chatItem = snapshot.data!.docs[index];
                  // ignore: unnecessary_statements
                  rows.add(<String>[
                    chatItem.get('name').toString(),
                    chatItem.get('purpose').toString(),
                    chatItem.get('room').toString(),
                    chatItem.get('exitdate').toString(),
                    chatItem.get('exittime').toString(),
                    chatItem.get('entrydate').toString(),
                    chatItem.get('entrytime').toString()
                  ]);

                  // print("SHUUUUUU");
                  // print(rows.toString());

                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.w,vertical: 5.h),
                    child: Card(
                      elevation: 2.5,
                      child: SizedBox(
                        height: 80.h,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: Text(
                                "${chatItem["name"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text("${chatItem["enrollment"]}",
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                  )),
                              contentPadding: EdgeInsets.symmetric(horizontal: 12.w),
                            ),
                            Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: 12.w,),
                                Text(
                                  "Room ${chatItem["room"]}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13.sp,
                                  ),
                                ),
                                SizedBox(width: 8.w,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [ //SizedBox(height: 5),
                                    Icon(
                                      Icons.access_alarm,
                                      size: 13.sp,
                                      color:
                                      Color.fromARGB(255, 22, 180, 140),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      chatItem["exittime"] == null
                                          ? "IN | IN"
                                          :
                                      "${chatItem["exittime"]} | ${chatItem["exitdate"]}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                    SizedBox(width: 4.w,),
                                    Icon(
                                      Icons.arrow_forward,
                                      color:
                                          Color.fromARGB(255, 22, 180, 140),
                                      size: 13.sp,
                                    ),
                                    SizedBox(width: 4.w,),
                                    Text(
                                      chatItem["entrytime"] == null
                                          ? "OUT | OUT"
                                          :
                                      "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 10.h,)
                          ],
                        ),
                      ),
                    ),
                  );
                },
              );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          // Add your onPressed code here!
          try {
            final result = await InternetAddress.lookup('google.com');
            if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
              await getCsv().then((v) {
                setState(() {});
                sendMailAndAttachment().whenComplete(() {
                  setState(() {});
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Data Sent')),
                  );
                });
              });
            }
          } on SocketException catch (_) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text(
                      'Connect your device to the internet, and try again')),
            );
          }
        },
        label: Text(
          'csv File',
          style: TextStyle(fontSize: 18.sp),
        ),
        icon: Icon(
          Icons.download,
          size: 24.sp,
        ),
        backgroundColor: Color(0Xff15609c),
      ),
    );
  }
}
