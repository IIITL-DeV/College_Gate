import 'dart:io';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/signIn.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';

class studentRegister extends StatefulWidget {
  const studentRegister({Key? key}) : super(key: key);

  @override
  _studentRegisterState createState() => _studentRegisterState();
}

class _studentRegisterState extends State<studentRegister> {
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
    // final Email email = Email(
    //   body: 'Hey, the CSV made it!',
    //   subject: 'Register for ${DateTime.now().toString()}',
    //   recipients: ['iiitlcollegegate12@gmail.com'],
    //   isHTML: true,
    //   attachmentPaths: filePath,
    // );

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
        //      .where("exitisapproved", isEqualTo: false)
        .where("purpose", isEqualTo: "Outing")
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
          backgroundColor: Color(0Xff15609c),
          title: Text("College Gate"),
          actions: [
            InkWell(
              onTap: () {
                AuthMethods().logout().then((s) {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => SignIn()));
                });
              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
                  )),
            )
          ]),
      body: StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            int value;
            value = snapshot.data!.docs.length;
            if (value == 0 || value == null) {
              print("issssss$value");
              return SizedBox(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 200),
                      Image.asset(
                        'assets/nonotices.png',
                        //fit: BoxFit.fitWidth,
                        width: 280.0,
                        height: 280,
                        alignment: Alignment.center,
                      ),
                      Text("No Entry/Exit",
                          style: TextStyle(
                            fontSize: 30.0,
                            fontWeight: FontWeight.w300,
                            color: Color(0Xff14619C),
                          )),
                    ],
                  ));
            }
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
                  padding: const EdgeInsets.all(3.0),
                  child: Card(
                    elevation: 3.5,
                    child: Expanded(
                      child: SizedBox(
                        height: 110,
                        child: ListView(
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            ListTile(
                              title: Text(
                                "${chatItem["name"]}",
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold),
                              ),
                              trailing: Text("${chatItem["enrollment"]}"),
                              contentPadding:
                                  EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                SizedBox(
                                  width: 6,
                                ),
                                Text(
                                  "Room ${chatItem["room"]}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                //SizedBox(height: 5),
                                Text(
                                  "${chatItem["exittime"]} | ${chatItem["exitdate"]}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    backgroundColor: Color(0XffD1F0E8),
                                  ),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Color(0XffD1F0E8),
                                  size: 11,
                                ),
                                Text(
                                  "${chatItem["entrytime"]} | ${chatItem["entrydate"]}",
                                  style: TextStyle(
                                    fontSize: 12.0,
                                    backgroundColor: Color(0XffD1F0E8),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
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
        label: const Text('csv File'),
        icon: const Icon(Icons.download),
        backgroundColor: Color(0Xff15609c),
      ),
    );
  }
}
