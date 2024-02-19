import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marathon/screens/quizPage.dart';
import 'package:marathon/screens/scanner.dart';

import '../utils/constants.dart';
import 'Map.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int index = 1;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  void updateIndex(int index){
    setState(() {
      this.index = index;
    });
  }


  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(
        Icons.quiz,
        size: 30,
        color: kLightGray,
      ),
      const Icon(
        Icons.camera,
        size: 30,
        color: kLightGray,
      ),
      const Icon(
        Icons.map,
        size: 30,
        color: kLightGray,
      ),
    ];

    final screens = <Widget>[
      const QuizPage(),
      ScannerPage(),
      const MapPage(),
    ];

    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        title: const Text("Marathon"),
        leading: Padding(
          padding: const EdgeInsets.all(13.0),
          child: Image.asset("images/logo.png"),
        ),
        backgroundColor: kWhite,
        centerTitle: true,
        actions: [
          _user != null ? _signOut() : const Text("Hi"),
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

  Widget _signOut() {
    return TextButton(onPressed: _auth.signOut, child: const Text("Sign Out"));
  }
}

