import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:marathon/firebase_options.dart';
import 'package:marathon/screens/loginPage.dart';
import 'package:marathon/screens/stopwatch_provider.dart';
import 'package:provider/provider.dart';

import './screens/homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const Marathon());
}

class Marathon extends StatefulWidget {
  const Marathon({super.key});

  @override
  State<Marathon> createState() => _MarathonState();
}

class _MarathonState extends State<Marathon> {
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

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => StopwatchProvider()),
      ],
      child: MaterialApp(
        title: "Marathon App",
        home: _user != null ? const HomePage() : const LoginPage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
