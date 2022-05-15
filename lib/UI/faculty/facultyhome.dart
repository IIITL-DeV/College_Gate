import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'AppointmentRequest.dart';
import 'facultyProfile.dart';

class FacultyHome extends StatefulWidget {
  const FacultyHome({Key? key}) : super(key: key);

  @override
  _FacultyHomeState createState() => _FacultyHomeState();
}

class _FacultyHomeState extends State<FacultyHome> {
  int _currentIndex = 1;
  final List<Widget> _pages = <Widget>[
    facultyProfile(),
    AppointmentList(),
    AppointmentRequest()
  ];

  void _onTapTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        iconSize: heightMobile * 0.038,
        selectedIconTheme: IconThemeData(color: Color(0Xff15609c), size: heightMobile * 0.042),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        // this will be set when a new tab is tapped
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outlined),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.calendar_today),
            label: 'Appointment',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications_none),
            label: 'Request',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onTapTapped,
      ),
      appBar: AppBar(
          backgroundColor: Color(0Xff15609c),
          title: Text("College Gate",style: TextStyle(fontSize: heightMobile * 0.025)),
          actions: [
            InkWell(
              onTap: () {

              },
              child: Container(
                  padding: EdgeInsets.symmetric(horizontal: heightMobile * 0.024),
                  child: Icon(
                    Icons.exit_to_app,
                    color: Colors.deepPurple[50],
                    size: heightMobile * 0.027,
                  )),
            )
          ]),
      body: Container(
        child: _pages.elementAt(_currentIndex),
      ),
    );
  }
}

class AppointmentList extends StatefulWidget {
  const AppointmentList({Key? key}) : super(key: key);

  @override
  _AppointmentListState createState() => _AppointmentListState();
}

class _AppointmentListState extends State<AppointmentList> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.195;
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
                                "Jagnik Chaurasiya",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                    fontSize: cardheight * 0.13, fontWeight: FontWeight.bold),
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
                                          Text("7856009040", style: TextStyle(fontSize: cardheight * 0.09),),
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
                                            "11:05 | 19-05-2022",
                                            style: TextStyle(
                                              fontSize: cardheight * 0.08,
                                              backgroundColor: Color(0XffD1F0E8),
                                            ),
                                          ),
                                        ],
                                      ),
                                     ]
                                  )),
                              //Id Image
                              //Room Number
                              trailing: Text("LIT2019059", style: TextStyle(fontSize: cardheight * 0.09, fontWeight: FontWeight.bold),),
                              contentPadding:
                              EdgeInsets.fromLTRB(cardheight * 0.1,cardheight * 0.1,cardheight * 0.1,cardheight * 0.05),
                            ),
                            SizedBox(
                              height: cardheight * 0.05,
                            ),
                            //Accept, Decline button
                            Column(
                              children: [
                                Container(
                                  height: cardheight * 0.25,
                                  width: widthMobile * 0.88,
                                  child: OutlinedButton(
                                    onPressed: (){

                                    },
                                    child: Text('Reschedule' ,style: TextStyle(fontSize: heightMobile * 0.022,color: Color(0Xff19B38D)), ),
                                    style: OutlinedButton.styleFrom(
                                      side: BorderSide(color: Color(0Xff19B38D), width: 2),
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(6),
                                      ),
                                    ),),
                                  ),
                                  // ElevatedButton(
                                  //   onPressed: () {
                                  //
                                  //   },
                                  //   child: Text(
                                  //     "Reschedule",
                                  //     style: TextStyle(
                                  //       fontSize: cardheight * 0.1,
                                  //       color: Colors.white,
                                  //     ),
                                  //   ),
                                  //   style: ButtonStyle(
                                  //     side: MaterialStateProperty.all(value),
                                  //     backgroundColor:
                                  //     MaterialStateProperty.all<Color>(
                                  //         Color(0Xff19B38D)),
                                  //   ),
                                  // ),
                                ),
                                SizedBox(height: cardheight * 0.1,)
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
              ),
        );
  }
}

