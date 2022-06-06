import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/panel/guest/faculty_appointment.dart';
import 'package:college_gate/panel/warden/viewimage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacultyList extends StatefulWidget {
  bool isStudent;
  FacultyList({Key? key,
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
          backgroundColor: Color(0Xff15609c),
          leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
                size: heightMobile * 0.028,
              ),
              onPressed: () => {Navigator.pop(context)}),
          title: Text(
            "Faculty List",
            style:
                TextStyle(color: Colors.white, fontSize: heightMobile * 0.026),
            textAlign: TextAlign.center,
          ),
          centerTitle: true,
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
                          Text("No Faculty Registered!",
                              style: TextStyle(
                                fontSize: heightMobile * 0.04,
                                fontWeight: FontWeight.w300,
                                color: Color(0Xff14619C),
                              )),
                        ],
                      ));
                }

                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final chatItem = snapshot.data!.docs[index];
                        return Padding(
                          padding: EdgeInsets.all(heightMobile * 0.008),
                          child: Card(
                            elevation: 3.5,
                            child: SizedBox(
                              height: cardheight,
                              width: widthMobile * 0.9,
                              child: ListView(
                                children: [
                                  ListTile(
                                    isThreeLine: false,
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  faculty_appointment(
                                                      email:
                                                          chatItem["email"], isStudent: widget.isStudent,)));
                                    },
                                    title: Text(
                                      "${chatItem["name"]}",
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: cardheight * 0.2,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text(
                                      "${chatItem["Designation"]}",
                                      //overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                          fontSize: cardheight * 0.13),
                                    ),
                                    leading: ConstrainedBox(
                                      constraints: BoxConstraints(
                                        minWidth: widthMobile * 0.1,
                                        minHeight: cardheight * 0.4,
                                        maxWidth: widthMobile * 0.2,
                                        maxHeight: cardheight * 0.55,
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
                      }),
                );
              }
              return Center(child: CircularProgressIndicator());
            }));
  }
}
