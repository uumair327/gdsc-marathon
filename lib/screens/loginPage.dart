import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sign_in_button/sign_in_button.dart';
import "package:cloud_firestore/cloud_firestore.dart";

import '../firestore/userdata.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;

  @override
  void initState() {
    super.initState();

    _auth.authStateChanges().listen((event) {
      setState(() {
        _user = event;
      });
    });
  }

  void _handleGoogleSignIn() {
    try {
      GoogleAuthProvider _googleAuthProvider = GoogleAuthProvider();
      _auth.signInWithProvider(_googleAuthProvider).then((value) => {
        setUser(value.additionalUserInfo?.profile?["email"])
      });
    } catch (e) {
      print("The Following Error Occured: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: SizedBox(
        height: 50,
        child: SignInButton(Buttons.google,
            text: "Sign In With Google", onPressed: _handleGoogleSignIn),
      )),
    );
  }
}
