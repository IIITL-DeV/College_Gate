import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

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
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = widthMobile * heightMobile * 0.00033;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Text(
          "Student Register",
          style: TextStyle(fontSize: heightMobile * 0.027),
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
                  width: widthMobile,
                  height: heightMobile,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: heightMobile * 0.13),
                      Image.asset(
                        'assets/nonotices.png',
                        //fit: BoxFit.fitWidth,
                        width: widthMobile * 0.8,
                        height: heightMobile * 0.4,
                        alignment: Alignment.center,
                      ),
                      Text("No Entry/Exit",
                          style: TextStyle(
                            fontSize: heightMobile * 0.04,
                            fontWeight: FontWeight.w300,
                            color: Color(0Xff14619C),
                          )),
                    ],
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

                  print("SHUUUUUU");
                  print(rows.toString());

                  return Padding(
                    padding: EdgeInsets.all(heightMobile * 0.008),
                    child: Card(
                      elevation: 3.5,
                      child: SizedBox(
                        height: cardheight,
                        width: widthMobile,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: Text(
                                "${chatItem["name"]}",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: cardheight * 0.18,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text("${chatItem["enrollment"]}",
                                  style: TextStyle(
                                    fontSize: cardheight * 0.13,
                                  )),
                              contentPadding: EdgeInsets.fromLTRB(
                                  cardheight * 0.13,
                                  cardheight * 0.1,
                                  cardheight * 0.14,
                                  cardheight * 0),
                            ),
                            Row(
                              // mainAxisAlignment:
                              //     MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(width: cardheight* 0.14,),
                                Text(
                                  "Room ${chatItem["room"]}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: cardheight * 0.13,
                                  ),
                                ),
                                SizedBox(width: cardheight* 0.08,),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [ //SizedBox(height: 5),
                                    Icon(
                                      Icons.access_alarm,
                                      size: cardheight * 0.12,
                                      color:
                                      Color.fromARGB(255, 22, 180, 140),
                                    ),
                                    SizedBox(
                                      width: cardheight * 0.05,
                                    ),
                                    Text(
                                      chatItem["exittime"] == null
                                          ? "IN | IN"
                                          :
                                      "${chatItem["exittime"]} | ${chatItem["exitdate"]}",
                                      style: TextStyle(
                                        fontSize: cardheight * 0.13,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                    SizedBox(width: cardheight* 0.05,),
                                    Icon(
                                      Icons.arrow_forward,
                                      color:
                                          Color.fromARGB(255, 22, 180, 140),
                                      size: cardheight * 0.1,
                                    ),
                                    SizedBox(width: cardheight* 0.05,),
                                    Text(
                                      chatItem["entrytime"] == null
                                          ? "OUT | OUT"
                                          :
                                      "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                      style: TextStyle(
                                        fontSize: cardheight * 0.13,
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            )
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
          style: TextStyle(fontSize: heightMobile * 0.02),
        ),
        icon: Icon(
          Icons.download,
          size: heightMobile * 0.035,
        ),
        backgroundColor: Color(0Xff15609c),
      ),
    );
  }
}
