import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:flutter/material.dart';

class w_log extends StatefulWidget {
  const w_log({Key? key}) : super(key: key);

  @override
  _w_logState createState() => _w_logState();
}

class _w_logState extends State<w_log> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentUser")
        .where("exitisapproved", isEqualTo: true)
        .where("entryisapproved", isEqualTo: null)
        .where("purpose", isEqualTo: "Home")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    // final tab = new TabBar(tabs: <Tab>[
    //   new Tab(text: "Exit Requests"),
    //   new Tab(text: "Entry Requests"),
    // ]);
    return Scaffold(
        // appBar: new PreferredSize(
        //   preferredSize: tab.preferredSize,
        //   child: new Card(
        //     //elevation: 26.0,
        //     // color: Color(0Xff14619C),
        //     child: tab,
        //   ),
        // ),
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
                    Text("No logs",
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
              return Padding(
                padding: const EdgeInsets.all(3.0),
                child: Card(
                  elevation: 3.5,
                  child: Expanded(
                    child: SizedBox(
                      height: 115,
                      child: ListView(
                        children: [
                          ListTile(
                            onTap: () {}, //Zoom Image Function
                            //name
                            title: Text(
                              "${chatItem["name"]}",
                              style: TextStyle(
                                  fontSize: 18.0, fontWeight: FontWeight.bold),
                            ),

                            //Phone number and Time
                            subtitle: Container(
                                child: Column(
                              children: [
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.add_call,
                                      size: 12.0,
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Text("${chatItem["phone"]}"),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.access_alarm,
                                      size: 12.0,
                                    ),
                                    SizedBox(
                                      width: 6.0,
                                    ),
                                    Text(
                                      "${chatItem["time"]} | ${chatItem["date"]}",
                                      style: TextStyle(
                                        backgroundColor: Color(0XffD1F0E8),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                            //Id Image
                            leading: ConstrainedBox(
                              constraints: BoxConstraints(
                                minWidth: 54,
                                minHeight: 54,
                                maxWidth: 74,
                                maxHeight: 74,
                              ),
                              child: GestureDetector(
                                  child: Hero(
                                    tag: chatItem["idcard"],
                                    child: Image.network(
                                        "${chatItem["idcard"]}",
                                        fit: BoxFit.contain),
                                  ),
                                  onTap: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return viewImage(chatItem["idcard"]);
                                    }));
                                  }),
                            ),
                            //Room Number
                            trailing: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                SizedBox(height: 17),
                                Text("${chatItem["room"]}"),
                                SizedBox(height: 3),
                                Text("${chatItem["enrollment"]}"),
                              ],
                            ),
                            contentPadding:
                                EdgeInsets.fromLTRB(20.0, 24.0, 24.0, 0),
                          ),
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
    ));
  }
}
