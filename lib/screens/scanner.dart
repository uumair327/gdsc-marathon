import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:marathon/firestore/userdata.dart';
import 'package:marathon/screens/quizPage.dart';
import 'package:marathon/screens/stopwatch_provider.dart';
import 'package:marathon/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late StopWatchTimer stopwatch;
  bool marathonStarted = false;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  var score=0;

  @override
  void initState() {
    super.initState();
    stopwatch = context.read<StopwatchProvider>().stopwatch;
    stopwatch.rawTime.listen((value) {
      setState(() {}); // Update UI when stopwatch changes
    });
    getScore().then((value) => setState(() {
      score=value;
    }));
  }

  Future<int> getScore() async {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Reference to the users collection in Firestore
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Get the document snapshot for the current user
      DocumentSnapshot snapshot = await users.doc(user.uid).get();

      // Check if the user document exists
      if (snapshot.exists) {
        // Cast snapshot.data() to Map<String, dynamic>
        Map<String, dynamic> userData = snapshot.data() as Map<String, dynamic>;

        // Get the score from the user's data
        int score = userData['score'] ?? 0;
        return score;
      } else {
        // User document doesn't exist
        throw Exception('User document does not exist');
      }
    } else {
      // User is not authenticated
      throw Exception('User not authenticated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: kRed, borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          const Text(
                            'Timer:',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                          StreamBuilder<int>(
                            stream: stopwatch.rawTime,
                            initialData: stopwatch.rawTime.value,
                            builder: (context, snap) {
                              final value = snap.data!;
                              final displayTime =
                                  StopWatchTimer.getDisplayTime(value);
                              return Column(
                                children: <Widget>[
                                  Text(
                                    displayTime,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 23,
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                              child: CircleAvatar(
                                backgroundColor: kLightRed,
                                child: Text('$score'),
                              ),
                            ),
                            Text("Score")
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 18.0),
                          child: Column(
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(
                                    vertical: 0, horizontal: 5),
                                child: const CircleAvatar(
                                    backgroundColor: kLightRed,
                                    child: Icon(
                                      LucideIcons.flame,
                                      color: kRed,
                                    )),
                              ),
                              Text("Calories")
                            ],
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    if (marathonStarted)
                      Container(
                        margin: const EdgeInsets.all(40),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: kLightYellow),
                        child: IconButton(
                          onPressed: () {
                            _openQRScanner(context);
                          },
                          icon: const Icon(Icons.qr_code),
                          iconSize: 64,
                          color: kLightRed,
                        ),
                      ),
                    if (!marathonStarted)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            marathonStarted = true;
                            stopwatch.onStartTimer();
                          });
                        },
                        child: const Text(
                          'Start Marathon',
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _openQRScanner(BuildContext context) {
    _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
      context: context,
      onCode: (scannedCode) {
        // Handle the scanned code as needed
        if (scannedCode == "Checkpoint 1") {
          updateCheckpoint(1, stopwatch.rawTime.value);
        } else if (scannedCode == "Checkpoint 2") {
          updateCheckpoint(2, stopwatch.rawTime.value);
        } else if (scannedCode == "Checkpoint 3") {
          updateCheckpoint(3, stopwatch.rawTime.value);
        } else {
          // Handle other scanned code values
        }
      },
    );
  }
}
