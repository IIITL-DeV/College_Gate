import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:college_gate/UI/student/idcardview.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String? _profilePicUrl =
          "https://lh3.googleusercontent.com/a/AATXAJxUk4eg4_2mYAEOjU7K6dx46JYR1Q6HW0WlMPEn=s96-c",
      _username,
      _enrollmentNo,
      _email,
      _roomno,
      _phoneno;
  // getThisUserInfo() async {
  //   QuerySnapshot querySnapshot = await DatabaseMethods().getUserInfo();
  //   //jab where order by krte hai toh query snapshot bnti hai mtlb collection of doc but hame pata hai ke sirf he data aayega toh haam [0] index use kr rhe wo extract krne ke liye

  //   setState(() {
  //     name = "${querySnapshot.docs[0]["name"]}";
  //     profilePicUrl = "${querySnapshot.docs[0]["profileUrl"]}";
  //     enrollmentNo = "${querySnapshot.docs[0]["enrollment"]}";
  //     email = "${querySnapshot.docs[0]["email"]}";
  //     print(name);
  //   });
  // }
  Future<void> _getprofilepicUrl() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _profilePicUrl = value.data()!['profileUrl'].toString();
      });
    });
  }

  Future<void> _getemail() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _email = value.data()!['email'].toString();
      });
    });
  }

  Future<void> _getUserName() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _username = value.data()!['name'].toString();
      });
    });
  }

  Future<void> _getrollno() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _enrollmentNo = value.data()!['enrollment'].toString();
      });
    });
  }

  Future<void> _getphoneno() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _phoneno = value.data()!['phone'].toString();
      });
    });
  }

  Future<void> _getroomno() async {
    FirebaseFirestore.instance
        .collection('studentUser')
        .doc((await FirebaseAuth.instance.currentUser!).uid)
        .get()
        .then((value) {
      setState(() {
        _roomno = value.data()!['room'].toString();
      });
    });
  }

  @override
  void initState() {
    super.initState();

    _getUserName();
    _getprofilepicUrl();
    _getrollno();
    _getemail();
    _getphoneno();
    _getroomno();
  }

  String? dropdownValue;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    if (_username == null) {
      return Center(child: CircularProgressIndicator());
    }
    return Scaffold(
        // appBar: AppBar(
        //     backgroundColor: Color(0Xff15609c),
        //     title: Text("College Gate"),
        //     actions: [
        //       InkWell(
        //         onTap: () {
        //           AuthMethods().logout().then((s) {
        //             Navigator.pushReplacement(context,
        //                 MaterialPageRoute(builder: (context) => SignIn()));
        //           });
        //         },
        //         child: Container(
        //             padding: EdgeInsets.symmetric(horizontal: 16),
        //             child: Icon(
        //               Icons.exit_to_app,
        //               color: Colors.deepPurple[50],
        //             )),
        //       )
        //     ]),
        body: SingleChildScrollView(
          child: Container(
          // height: MediaQuery.of(context).size.height,
           width: widthMobile,
            padding: EdgeInsets.symmetric(
              vertical: heightMobile * 0.04, horizontal: widthMobile * 0.08),
            child: Form(
              key: _formKey,
              child: Center(
                  child: Column(
                children: [
                  SizedBox(height: heightMobile * 0.025),
                  SizedBox(
                    height: heightMobile * 0.14,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(1500),
                      child: Image.network(
                        _profilePicUrl!,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.016),
                  Text(
                    _username!,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: heightMobile * 0.024,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.01),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Enrollnment Number'),
                    initialValue: _enrollmentNo,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Email'),
                    initialValue: _email,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                    readOnly: true,
                  ),
                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration:
                        const InputDecoration(labelText: 'Phone Number'),
                    initialValue: _phoneno,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                  ),

                  SizedBox(height: heightMobile * 0.009),
                  TextFormField(
                    decoration: const InputDecoration(labelText: 'Room number'),
                    initialValue: _roomno,
                    style: TextStyle(
                      fontSize: heightMobile * 0.021,
                    ),
                  ),
                  SizedBox(height: heightMobile * 0.06),
                  ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(15.0),
                          ),
                          primary: Color(0Xff15609c),
                          padding: EdgeInsets.all(heightMobile * 0.017),
                          // padding: const EdgeInsets.all(10),
                          minimumSize: Size(widthMobile, heightMobile * 0.028)),
                      child: Text(
                        'Save Details',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: heightMobile * 0.02,
                        ),
                      ),
                      onPressed: (){
                        /////

                      })

                  // SizedBox(height: heightMobile * 0.02),
                  // Row(children: [
                  //   Text("ID Card",
                  //       style: TextStyle(
                  //         fontSize: heightMobile * 0.021,
                  //       )),
                  //   SizedBox(
                  //     width: widthMobile * 0.54,
                  //   ),
                  //   GestureDetector(
                  //     onTap: () {
                  //       Navigator.push(context,
                  //           MaterialPageRoute(builder: (context) => viewID()));
                  //     },
                  //     child: Text(
                  //       "View",
                  //       style: TextStyle(
                  //         color: Colors.blue,
                  //         fontSize: heightMobile * 0.021,
                  //       ),
                  //     ),
                  //   )
                  // ]),

                  // Container(
                  //   height: 50,
                  //   width: MediaQuery.of(context).size.width,
                  //   margin: EdgeInsets.all(0),
                  //   child: DropdownButtonHideUnderline(
                  //     child: GFDropdown(
                  //       padding: const EdgeInsets.all(15),
                  //       borderRadius: BorderRadius.circular(5),
                  //       border:
                  //           const BorderSide(color: Colors.black12, width: 1),
                  //       dropdownButtonColor: Colors.white,
                  //       value: dropdownValue,
                  //       onChanged: (newValue) {
                  //         setState(() {
                  //           dropdownValue = newValue as String?;
                  //         });
                  //         print('value issssssssssssssss   $dropdownValue');
                  //       },
                  //       //                 onChanged: (newValue) =>
                  //       //     setState(() => dropdownValue = newValue as String?),
                  //       // validator: (value) => value == null ? 'field required' : null,
                  //       hint: Text("Sign in as"),
                  //       items: ['Student', 'Gatekeeper', 'Warden']
                  //           .map((value) => DropdownMenuItem(
                  //                 value: value,
                  //                 child: Text(value),
                  //               ))
                  //           .toList(),
                  //     ),
                  //   ),
                  // ),

                  //   SizedBox(height: 50.0),

                  //   ElevatedButton(
                  //       style: ElevatedButton.styleFrom(
                  //           shape: new RoundedRectangleBorder(
                  //             borderRadius: new BorderRadius.circular(15.0),
                  //           ),
                  //           primary: Color(0Xff15609c),
                  //           padding: const EdgeInsets.all(13),
                  //           minimumSize: const Size(double.infinity, 30)),
                  //       child: const Text(
                  //         'Done',
                  //         style: TextStyle(
                  //           color: Colors.white,
                  //           fontSize: 16,
                  //         ),
                  //       ),
                  //       onPressed: () async {
                  //         if (_formKey.currentState!.validate()) {
                  //           ScaffoldMessenger.of(context).showSnackBar(
                  //             const SnackBar(content: Text('Processing Data')),
                  //           );
                  //           studentHome();
                  //           await FirebaseFirestore.instance
                  //               .collection('studentUser')
                  //               .doc((await FirebaseAuth.instance.currentUser!)
                  //                   .uid)
                  //               .set({'room': _roomno}, SetOptions(merge: true));
                  //           // print("room no issssssssssssss $_roomno");

                  //           await FirebaseFirestore.instance
                  //               .collection('studentUser')
                  //               .doc((await FirebaseAuth.instance.currentUser!)
                  //                   .uid)
                  //               .set(
                  //                   {'phone': _phoneno}, SetOptions(merge: true));
                  //           // print("room no issssssssssssss $_roomno");

                  //           await FirebaseFirestore.instance
                  //               .collection('studentUser')
                  //               .doc((await FirebaseAuth.instance.currentUser!)
                  //                   .uid)
                  //               .set({'signinas': dropdownValue},
                  //                   SetOptions(merge: true));
                  //         } else {
                  //           print("Not validated");
                  //         }
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) => studentHome()));
                  //       })

                  //   // GestureDetector(
                  //   //   onTap: () => {
                  //   //     if (_formKey.currentState!.validate())
                  //   //       {
                  //   //         ScaffoldMessenger.of(context).showSnackBar(
                  //   //           const SnackBar(
                  //   //               content: Text('Processing Data')),
                  //   //         ),
                  //   //         studentHome()
                  //   //       }
                  //   //     else
                  //   //       {print("Not validated")},
                  //   //   },
                  //   //   child: Container(
                  //   //       decoration: BoxDecoration(
                  //   //         borderRadius: BorderRadius.circular(15),
                  //   //         color: Color(0Xff15609c),
                  //   //       ),
                  //   //       height: 50,
                  //   //       width: 510,
                  //   //       //color: Colors.blue[800],
                  //   //       child: Center(
                  //   //         child: Text("Done",
                  //   //             style: TextStyle(
                  //   //                 color: Colors.white, fontSize: 15)),
                  //   //       )),
                  //   // ),
                ],
              )))),
    ));
  }
}
