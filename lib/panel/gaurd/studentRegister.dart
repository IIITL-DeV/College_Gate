import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StudentRegister extends StatefulWidget {
  const StudentRegister({Key? key}) : super(key: key);

  @override
  _StudentRegisterState createState() => _StudentRegisterState();
}

class _StudentRegisterState extends State<StudentRegister> {
  List<String>? filePath;
  List<List<String>> rows = [];

  String _mailBody =
      '<p>Greetings of the day,</p>\n <p>Please find the attached document of the student register compiled at ${DateFormat('HH:mm').format(DateTime.now())} on ${DateFormat('dd-MM-yyyy').format(DateTime.now())} .</p> \n <p>Regards,<br>College Gate</p>';

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.absolute.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    filePath = ['$path/Student Register.csv'];
    return File('$path/Student Register.csv').create();
  }

  getCsv() async {
    File f = await _localFile;

    // String header = "Name,Enrollment Number,Purpose,Exit,Entry\n";

    String csv = const ListToCsvConverter().convert(rows);

    f.writeAsString(csv);
  }

  sendMailAndAttachment() async {
    await FlutterEmailSender.send(Email(
      body:
          'Please find the data of Student Register in the CSV file attached below.',
      subject:
          'Register for ${DateFormat('dd-MM-yyyy').format(DateTime.now())} | ${DateFormat('HH:mm').format(DateTime.now())}',
      recipients: ['collegegate@iiitl.ac.in'],
      isHTML: true,
      attachmentPaths: filePath,
    ));
  }

  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentRegister")
        .orderBy("exitdatetime", descending: true)
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
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.w500),
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
                        SizedBox(
                          height: 30.h,
                        ),
                        Text("No Entry",
                            style: TextStyle(
                              fontSize: 28.sp,
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

                String exittime = chatItem["exitdatetime"] == null
                    ? "Home"
                    : DateFormat('HH:mm')
                        .format(chatItem["exitdatetime"].toDate());
                String exitdate = chatItem["exitdatetime"] == null
                    ? "Home"
                    : DateFormat('dd-MM-yyyy')
                        .format(chatItem["exitdatetime"].toDate());
                // ignore: unnecessary_statements
                rows.add(<String>[
                  chatItem.get('name').toString(),
                  chatItem.get('enrollment').toString(),
                  chatItem["purpose"] == null ? "Home" : chatItem["purpose"],
                  "${exittime} | ${exitdate}",
                  "${DateFormat('HH:mm').format(chatItem["entrydatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["entrydatetime"].toDate())}",
                ]);

                // print("SHUUUUUU");
                print(rows.toString());

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
                            isThreeLine: true,
                            title: Row(
                              // mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    "${chatItem["name"]}",
                                    textAlign: TextAlign.start,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Expanded(
                                  child: Text("${chatItem["enrollment"]}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                      )),
                                ),
                              ],
                            ),
                            subtitle: Column(
                              children: [
                                SizedBox(
                                  height: 8.h,
                                ),
                                // SizedBox(
                                //   width: 12.w,
                                // ),
                                // Text(
                                //   "Room ${chatItem["room"]}",
                                //   textAlign: TextAlign.start,
                                //   style: TextStyle(
                                //     fontWeight: FontWeight.w600,
                                //     fontSize: 13.sp,
                                //   ),
                                // ),
                                // SizedBox(
                                //   width: 8.w,
                                // ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  // mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 11.sp,
                                      color: Color.fromARGB(255, 22, 180, 140),
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                    Text(
                                      chatItem["exitdatetime"] == null
                                          ? "HOME | HOME"
                                          : "${DateFormat('HH:mm').format(chatItem["exitdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["exitdatetime"].toDate())}",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromARGB(255, 22, 180, 140),
                                      size: 11.sp,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      chatItem["entrydatetime"] == null
                                          ? "OUT | OUT"
                                          : "${DateFormat('HH:mm').format(chatItem["entrydatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["entrydatetime"].toDate())}",
                                      style: TextStyle(
                                        fontSize: 11.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 12.w, vertical: 5.h),
                          ),
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
          'CSV File',
          style: TextStyle(fontSize: 15.sp),
        ),
        icon: Icon(
          Icons.download,
          size: 20.sp,
        ),
        backgroundColor: Color(0Xff15609c),
      ),
    );
  }
}
