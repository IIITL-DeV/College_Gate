import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class guestRegister extends StatefulWidget {
  const guestRegister({Key? key}) : super(key: key);

  @override
  _guestRegisterState createState() => _guestRegisterState();
}

class _guestRegisterState extends State<guestRegister> {
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
      body:
          'Please find the data to Guest Register in the CSV file attached below.',
      subject:
          'Register for ${DateFormat('dd-MM-yyyy').format(DateTime.now())} | ${DateFormat('HH:mm').format(DateTime.now())}',
      recipients: ['iiitlcollegegate12@gmail.com'],
      isHTML: true,
      attachmentPaths: filePath,
    ));
  }

  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("guestRegister")
        .where("exitisapproved", isEqualTo: false)
        .orderBy("entrydatetime", descending: true)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // final tab = new TabBar(tabs: <Tab>[
    //   new Tab(text: "Exit Requests"),
    //   new Tab(text: "Entry Requests"),
    // ]);
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 56.h,
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Text(
          "Guest Register",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.w500),
        ),
      ),
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
                rows.add(<String>[
                  chatItem.get('name').toString(),
                  chatItem.get('vehicleno').toString(),
                  chatItem.get('purpose').toString(),
                  "${DateFormat('HH:mm').format(chatItem["exitdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["exitdatetime"].toDate())}",
                  "${DateFormat('HH:mm').format(chatItem["entrydatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["entrydatetime"].toDate())}",
                ]);

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                  child: Card(
                    elevation: 2.5,
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
                                  child: Text("${chatItem["vehicleno"]}",
                                      textAlign: TextAlign.end,
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                      )),
                                ),
                              ],
                            ),

                            subtitle: Column(
                              children: [
                                SizedBox(
                                  height: 10.h,
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
                                      size: 13.sp,
                                      color: Color.fromARGB(255, 22, 180, 140),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      chatItem["exitdatetime"] == null
                                          ? "IN | IN"
                                          : "${DateFormat('HH:mm').format(chatItem["exitdatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["exitdatetime"].toDate())}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Color.fromARGB(255, 22, 180, 140),
                                      size: 13.sp,
                                    ),
                                    SizedBox(
                                      width: 4.w,
                                    ),
                                    Text(
                                      chatItem["entrydatetime"] == null
                                          ? "OUT | OUT"
                                          : "${DateFormat('HH:mm').format(chatItem["entrydatetime"].toDate())} | ${DateFormat('dd-MM-yyyy').format(chatItem["entrydatetime"].toDate())}",
                                      style: TextStyle(
                                        fontSize: 13.sp,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            // contentPadding:
                            //     EdgeInsets.fromLTRB(12.w, 0, 12.w, 0),
                          ),
                        ],
                      ),
                    ),
                  ),
                );

                // return ListTile(
                //   leading: Text(
                //     chatItem["name"] ?? '',
                //     style: TextStyle(
                //         //fontWeight: FontWeight.bold,
                //         fontSize: 20),
                //   ),
                //   subtitle: Column(
                //     children: <Widget>[
                //       ElevatedButton(
                //           child: Text('Accept'),
                //           onPressed: () {
                //             FirebaseFirestore.instance
                //                 .collection("studentUser")
                //                 .doc(chatItem["userid"])
                //                 .update({"exitisapproved": true}).then((_) {
                //               print("success!");
                //             });
                //           })
                //     ],
                //   ),
                // );
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
