import 'package:college_gate/UI/signIn.dart';
import 'package:college_gate/UI/warden/viewimage.dart';
import 'package:college_gate/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class gaurdlog extends StatefulWidget {
  // const guard_profile({Key? key}) : super(key: key);

  @override
  _gaurdlogState createState() => _gaurdlogState();
}

class _gaurdlogState extends State<gaurdlog> {
  var stream;
  @override
  void initState() {
    super.initState();
    stream = FirebaseFirestore.instance
        .collection("studentUser")
        .where("exitisapproved", isEqualTo: true)
        // .where("entryisappr")
        .where("purpose", isEqualTo: "Outing")
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.13;
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
                    Text("No logs",
                        style: TextStyle(
                          fontSize: heightMobile * 0.04,
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
                padding: EdgeInsets.all(heightMobile * 0.01),
                child: Card(
                  elevation: 3.5,
                  child: SizedBox(
                    height: cardheight,
                    width: widthMobile * 0.9,
                    child: ListView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        ListTile(
                          onTap: () {}, //Zoom Image Function
                          //name
                          title: Text(
                            "${chatItem["name"]}",
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                                fontSize: cardheight * 0.18, fontWeight: FontWeight.bold),
                          ),

                          //Phone number and Time
                          subtitle: Container(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: cardheight * 0.06,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.add_call,
                                        size: cardheight * 0.11,
                                      ),
                                      SizedBox(
                                        width: widthMobile * 0.02,
                                      ),
                                      Text("${chatItem["phone"]}", style: TextStyle(fontSize: cardheight * 0.13),),
                                    ],
                                  ),
                                  SizedBox(
                                    height: cardheight * 0.03,
                                  ),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.access_alarm,
                                        size: cardheight * 0.12,
                                      ),
                                      SizedBox(
                                        width: widthMobile * 0.02,
                                      ),
                                      Text(
                                        "${chatItem["time"]} | ${chatItem["date"]}",
                                        style: TextStyle(
                                          fontSize: cardheight * 0.13,
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
                              minWidth: widthMobile * 0.07,
                              minHeight: cardheight * 0.25,
                              maxWidth: widthMobile * 0.15,
                              maxHeight: cardheight * 0.55,
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
                              SizedBox(height: cardheight * 0.1),
                              Text("${chatItem["room"]}", style: TextStyle(fontSize: cardheight * 0.13, fontWeight: FontWeight.bold),),
                              SizedBox(height: heightMobile * 0.004),
                              Text("${chatItem["enrollment"]}",style: TextStyle(fontSize: cardheight * 0.13, fontWeight: FontWeight.bold),),
                            ],
                          ),
                          contentPadding:
                          EdgeInsets.fromLTRB(cardheight * 0.13,cardheight * 0.1,cardheight * 0.14,cardheight * 0.1),
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
    ));
  }
}
