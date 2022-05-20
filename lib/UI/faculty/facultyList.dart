import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class FacultyList extends StatefulWidget {
  const FacultyList({Key? key}) : super(key: key);

  @override
  _FacultyListState createState() => _FacultyListState();
}

class _FacultyListState extends State<FacultyList> {
  @override
  Widget build(BuildContext context) {
    double widthMobile = MediaQuery.of(context).size.width;
    double heightMobile = MediaQuery.of(context).size.height;
    double cardheight = heightMobile * 0.095;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0Xff15609c),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: heightMobile * 0.028,
                child: Image.asset("assets/cg_white.png")),
            SizedBox(
              width: 10,
            ),
            Text("College Gate",
                style: TextStyle(fontSize: heightMobile * 0.028)),
          ],
        ),
      ),
      body: SingleChildScrollView(
        physics:  BouncingScrollPhysics(),
        child: ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: 10,
            itemBuilder: (context, index) {
            return Padding(
              padding: EdgeInsets.all(heightMobile * 0.007),
              child: Card(
                elevation: 3.5,
                child: SizedBox(
                  height: cardheight,
                  width: widthMobile * 0.9,
                  child: ListView(
                    children: [
                      ListTile(
                        isThreeLine: false,
                        onTap: (){
                        },
                        title: Text(
                          "Dr. Vishal Krishna Singh",
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: cardheight * 0.2, fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          "Deputy Registrar Deputy Registrar Deputy Registrar Deputy Registrar",
                          //overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: cardheight * 0.15),
                        ),
                        leading: ConstrainedBox(
                            constraints: BoxConstraints(
                              minWidth: widthMobile * 0.08,
                              minHeight: cardheight * 0.28,
                              maxWidth: widthMobile * 0.17,
                              maxHeight: cardheight * 0.45,
                            ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: Image.asset(
                              "assets/entry.png",
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
        }),
      ),
    );
  }
}
