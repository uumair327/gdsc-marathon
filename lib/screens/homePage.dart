import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:marathon/screens/quizPage.dart';
import 'package:marathon/screens/scanner.dart';
import 'package:sign_in_button/sign_in_button.dart';

import '../utils/constants.dart';
import 'Map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 2;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState(){
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    final items = <Widget>[
      Icon(
        Icons.quiz,
        size: 30,
        color: kLightGray,
      ),
      Icon(
        Icons.camera,
        size: 30,
        color: kLightGray,
      ),
      Icon(
        Icons.map,
        size: 30,
        color: kLightGray,
      ),
    ];

    final screens = <Widget>[
      QuizPage(),
      ScannerPage(),
      MapPage(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: Text("Marathon"),
        leading: Padding(
          child: Image.asset("images/logo.png"),
          padding: EdgeInsets.all(13.0),
        ),
        backgroundColor: kWhite,
        centerTitle: true,
        actions: [
          _user != null ? _signOut(): Text("Hi"),
        ],
      ),
      backgroundColor: kLightGray,
      body: SafeArea(
        child: screens[index],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        items: items,
        backgroundColor: Colors.transparent,
        color: kGreen,
        height: 60,
        index: index,
        onTap: (index) => setState(() {
          this.index = index;
        }),
      ),
    );
  }

  Widget _signOut(){
    return TextButton(onPressed: _auth.signOut, child: const Text("Sign Out"));
  }
}