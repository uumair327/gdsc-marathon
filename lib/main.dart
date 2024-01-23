import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'utils/constants.dart';

void main() => runApp(Marathon());

class Marathon extends StatefulWidget {
  const Marathon({super.key});

  @override
  State<Marathon> createState() => _MarathonState();
}

class _MarathonState extends State<Marathon> {
  int index = 1;
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.quiz, size:30, color: kLightGray,),
      Icon(Icons.camera, size: 30,color: kLightGray,),
      Icon(Icons.map, size: 30, color: kLightGray,),
    ];
    return MaterialApp(
      title: "Marathon App",
      home: Scaffold(

        appBar: AppBar(
          title: Text("Marathon"),
          leading: Padding(child: Image.asset("images/logo.png"), padding: EdgeInsets.all(13.0),),
          backgroundColor: kWhite,
          centerTitle: true,
        ),

        backgroundColor: kLightGray,

        body: SafeArea(
          child: Text("$index"),
        ),

        bottomNavigationBar: CurvedNavigationBar(
          items: items,
          backgroundColor: kLightGray,
          color: kGreen,
          height: 60,
          index: index,
          onTap: (index)=>setState(() {
            this.index = index;
          }),
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
    ;
  }
}
