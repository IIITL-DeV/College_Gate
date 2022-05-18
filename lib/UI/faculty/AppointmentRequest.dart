import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppointmentRequest extends StatefulWidget {
  const AppointmentRequest({Key? key}) : super(key: key);

  @override
  _AppointmentRequestState createState() => _AppointmentRequestState();
}

class _AppointmentRequestState extends State<AppointmentRequest> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.2;
    return Scaffold(
        body: ListView.builder(
      shrinkWrap: true,
      itemCount: 5,
      itemBuilder: (context, index) {
        //final chatItem = snapshot.data!.docs[index];
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
                    title: Text(
                      "Kratika Jain",
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: cardheight * 0.13,
                          fontWeight: FontWeight.bold),
                    ),
                    //Phone number and Time
                    subtitle: Container(
                        child: Column(
                      children: [
                        SizedBox(
                          height: cardheight * 0.04,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.add_call,
                              size: cardheight * 0.07,
                            ),
                            SizedBox(
                              width: widthMobile * 0.02,
                            ),
                            Text(
                              "7856009040",
                              style: TextStyle(fontSize: cardheight * 0.09),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: cardheight * 0.03,
                        ),
                        Row(
                          children: [
                            Icon(
                              Icons.access_alarm,
                              size: cardheight * 0.08,
                            ),
                            SizedBox(
                              width: widthMobile * 0.02,
                            ),
                            Text(
                              "13:36 | 19-05-2022",
                              style: TextStyle(
                                fontSize: cardheight * 0.08,
                                backgroundColor: Color(0XffD1F0E8),
                              ),
                            ),
                          ],
                        )
                      ],
                    )),
                    //Id Image
                    //Room Number
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        //SizedBox(height: cardheight * 0.07),
                        Text(
                          "Guest",
                          style: TextStyle(
                              fontSize: cardheight * 0.09,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: cardheight * 0.07),
                        InkWell(
                            onTap: () {
                              dialogBox();
                            },
                            child: Text(
                              "Description",
                              style: TextStyle(
                                  fontSize: heightMobile * 0.016,
                                  color: Color(0Xff15609c)),
                            )
                            // Icon(
                            //   CupertinoIcons.arrowtriangle_down_circle_fill,
                            //   size: cardheight * 0.14 ,
                            //   color: Color(0Xff14619C),
                            // ),
                            )
                        //Text("${chatItem["enrollment"]}",style: TextStyle(fontSize: cardheight * 0.09, fontWeight: FontWeight.bold),),
                        //SizedBox(height: cardheight * 0.1,)
                      ],
                    ),
                    contentPadding: EdgeInsets.fromLTRB(cardheight * 0.1,
                        cardheight * 0.1, cardheight * 0.1, cardheight * 0.05),
                  ),
                  SizedBox(
                    height: cardheight * 0.05,
                  ),
                  //Accept, Decline button
                  Column(
                    children: [
                      Container(
                          child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: cardheight * 0.25,
                            width: widthMobile * 0.42,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: Text(
                                "Accept",
                                style: TextStyle(
                                  fontSize: cardheight * 0.1,
                                  color: Colors.white,
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0Xff19B38D)),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: widthMobile * 0.03,
                          ),
                          Container(
                            height: cardheight * 0.25,
                            width: widthMobile * 0.42,
                            child: ElevatedButton(
                              onPressed: () {
                                rescheduleBox();
                              },
                              child: Text(
                                "Decline",
                                style: TextStyle(
                                  fontSize: cardheight * 0.1,
                                  color: Colors.red[700],
                                ),
                              ),
                              style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.white),
                              ),
                            ),
                          )
                        ],
                      )),
                      SizedBox(
                        height: cardheight * 0.1,
                      )
                    ],
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
    ));
  }

  Future<dynamic> dialogBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double widthMobile = MediaQuery.of(context).size.width;
          double heightMobile = MediaQuery.of(context).size.height;
          return AlertDialog(
            title: Text(
              "Description",
              style: TextStyle(
                  fontSize: heightMobile * 0.027, color: Color(0Xff15609c)),
            ),
            content: Container(
              // constraints: BoxConstraints(
              //   maxHeight: double.infinity,
              // ),
              child: Text(
                'Hellr...i.Jagnik',
                //softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: heightMobile * 0.021,
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> rescheduleBox() {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          double widthMobile = MediaQuery.of(context).size.width;
          double heightMobile = MediaQuery.of(context).size.height;
          return AlertDialog(
            elevation: 3,
            title: Column(
              children: [
                Text(
                  "Are you sure you want to decline?",
                  style: TextStyle(fontSize: heightMobile * 0.026),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Description",
                      style: TextStyle(
                          fontSize: heightMobile * 0.018,
                          color: Color(0Xff15609c)),
                    ))
              ],
            ),
            content: Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8.0),
                color: Colors.white70,
                border: Border.all(
                  width: 0.1,
                ),
              ),
              child: Text(
                'Hellr...i.Jagnik...Hellr...i.Jagnik...Hellr...i.Jagnik...Hellr...i.Jagnik....Hellr...i.Jagnik...Hellr...i.Jagnik....Hellr...i.Jagnik....Hellr...i.Jagnik',
                //softWrap: true,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: heightMobile * 0.022,
                ),
              ),
            ),
            actions: [
              Column(
                children: [
                  Container(
                      child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Reschedule",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.white,
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color(0Xff19B38D)),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.03,
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.05,
                        width: MediaQuery.of(context).size.width * 0.35,
                        child: ElevatedButton(
                          onPressed: () {},
                          child: Text(
                            "Decline",
                            style: TextStyle(
                              fontSize:
                                  MediaQuery.of(context).size.height * 0.02,
                              color: Colors.red[700],
                            ),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(Colors.white),
                          ),
                        ),
                      )
                    ],
                  )),
                  SizedBox(
                    height: 10,
                  )
                ],
              ),
            ],
          );
        });
  }
}
