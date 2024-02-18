import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:marathon/firestore/userdata.dart';
import 'package:marathon/screens/quizPage.dart';
import 'package:marathon/utils/constants.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class ScannerPage extends StatefulWidget {
  ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final stopwatch = StopWatchTimer(onChange: (value) {
    final displayTime = StopWatchTimer.getDisplayTime(value);
  });
  bool marathonStarted = false;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();

  String _printDuration(Duration duration) {
    String milliseconds = (duration.inMilliseconds % 1000)
        .toString()
        .padLeft(2, "0"); // this one for the miliseconds
    String seconds = ((duration.inMilliseconds ~/ 1000) % 60)
        .toString()
        .padLeft(2, "0"); // this is for the second
    String minutes =
        ((duration.inMilliseconds ~/ 1000) ~/ 60).toString().padLeft(2, "0");
    return "$minutes : $seconds : $milliseconds";
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() async {
    super.dispose();
    await stopwatch.dispose(); // Need to call dispose function.
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      _openQRScanner(context);
    });

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
                      ],
                    )
                  ],
                ),
                Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: kLightYellow),
                      child: IconButton(
                        onPressed: () {
                          _qrBarCodeScannerDialogPlugin.getScannedQrBarCode(
                            context: context,
                            onCode: (scannedCode) {
                              // Check the scanned code value
                              if (scannedCode == "GDSC: Check Point 2") {
                                // Navigate to QuizPage if the scanned code matches
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const QuizPage()),
                                );
                              } else {
                                // Handle other scanned code values
                              }
                            },
                          );
                        },
                        icon: const Icon(Icons.qr_code),
                        iconSize: 64,
                        color: kLightRed,
                      ),
                    ),
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
        if(scannedCode == "Checkpoint 1"){
          updateCheckpoint(1);
        }else if(scannedCode == "Checkpoint 2"){
          updateCheckpoint(2);
        }else if(scannedCode == "Checkpoint 3"){
          updateCheckpoint(3);
        }
      },
    );
  }
}
