import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:marathon/firestore/userdata.dart';
// import 'package:marathon/screens/quizPage.dart';
import 'package:marathon/screens/stopwatch_provider.dart';
import 'package:marathon/utils/constants.dart';
import 'package:provider/provider.dart';
import 'package:qr_bar_code_scanner_dialog/qr_bar_code_scanner_dialog.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:pedometer/pedometer.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';


Random random = Random();
int cal = random.nextInt(55 - 23 + 1) + 23;

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  late StopWatchTimer stopwatch;
  bool marathonStarted = false;
  final _qrBarCodeScannerDialogPlugin = QrBarCodeScannerDialog();
  var score=0;
  //pedometer initializations
  late Stream<StepCount> _stepCountStream;
  late Stream<PedestrianStatus> _pedestrianStatusStream;
  late String _steps = '0';
  late String _status = '--';


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
    initPlatformState();
  }

  //step count
  void onStepCount(StepCount event) {
    if (kDebugMode) {
      print(event);
    }
    setState(() {
      _steps = event.steps.toString();
    });
  }

  void onStepCountError(error) {
    if (kDebugMode) {
      print('onStepCountError: $error');
    }
    setState(() {
      _steps = 'Step Count not available';
    });
  }

  //Pedastrian Status- Walking, Running, Stopped,etc
  void onPedestrianStatusChanged(PedestrianStatus event) {
    DateTime timeStamp = event.timeStamp;
    if (kDebugMode) {
      print(event);
    }
    if (kDebugMode) {
      print(timeStamp);
    }
    setState(() {
      _status = event.status;
    });
  }

  void onPedestrianStatusError(error) {
    if (kDebugMode) {
      print('onPedestrianStatusError: $error');
    }
    setState(() {
      _status = 'Pedestrian Status not available';
    });
    if (kDebugMode) {
      print(_status);
    }
  }

  Future<void> initPlatformState() async {
    // Init streams
    _pedestrianStatusStream =  Pedometer.pedestrianStatusStream;
    _stepCountStream = Pedometer.stepCountStream;

    // Listen to streams and handle errors
    _stepCountStream.listen(onStepCount).onError(onStepCountError);
    _pedestrianStatusStream
        .listen(onPedestrianStatusChanged)
        .onError(onPedestrianStatusError);

    if (!mounted) return;
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                            const SizedBox(height: 10),
                            Container(
                              margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                              child: CircleAvatar(
                                backgroundColor: kLightRed,
                                child: Text('$score'),
                              ),
                            ),
                            const Text("Score"),
                          ],
                        ),

                      ],
                    ),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        //   child: Container(
                        //     margin: const EdgeInsets.symmetric(
                        //       vertical: 0,
                        //       horizontal: 5,
                        //     ),
                        //     decoration: BoxDecoration(
                        //         color: kLightRed, borderRadius: BorderRadius.circular(10)),
                        //         width: 90,
                        //     padding: const EdgeInsets.all(10),
                        //     child: Column(
                        //       crossAxisAlignment: CrossAxisAlignment.center,
                        //       children: [
                        //         const Text(
                        //           'Steps',
                        //           style: TextStyle(
                        //             fontSize: 18,
                        //             fontWeight: FontWeight.bold,
                        //           ),
                        //         ),
                        //         const SizedBox(height: 8),
                        //         Text(
                        //           _steps,
                        //           style: const TextStyle(fontSize: 20),
                        //         ),
                        //       ],
                        //     ),
                        //   ),
                        // ),
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 0.0),
                        //   child: Column(
                        //     children: [
                        //       Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        //         child: Stack(
                        //           children: [
                        //             // CircleAvatar with flame icon
                        //             const CircleAvatar(
                        //               backgroundColor: kLightRed,
                        //               radius: 25.0,
                        //               child: Icon(
                        //                 LucideIcons.flame,
                        //                 color: kRed,
                        //                 size: 19,
                        //               ),
                        //             ),
                        //             // Text with calorie value and unit
                        //             Positioned(
                        //               bottom: 1, // Adjust positioning as needed
                        //               right: 12, // Adjust positioning as needed
                        //               child: Text(
                        //                 (((int.parse(_steps) * cal.toDouble()) / 1000) / 1000).toStringAsFixed(2),
                        //                 style: const TextStyle(
                        //                   fontSize: 10,
                        //                   fontWeight: FontWeight.bold,
                        //                   color: Colors.black87, // White text on red background
                        //                 ),
                        //               ),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //       const Text("Calories"),
                        //       const SizedBox(height: 10),
                        //       Container(
                        //         margin: const EdgeInsets.symmetric(vertical: 0, horizontal: 5),
                        //         child: CircleAvatar(
                        //           backgroundColor: kLightRed,
                        //           child: Text('$score'),
                        //         ),
                        //       ),
                        //       const Text("Score"),
                        //     ],
                        //   ),
                        // ),
                        Container(
                          width: 230,
                          height: 115,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(18.0)),
                            color: Color.fromRGBO(210, 4, 45, 0.8),
                          ),
                          child: Padding(padding: const EdgeInsets.all(15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: 80,
                                  height: 80,
                                  child: SfRadialGauge(
                                    enableLoadingAnimation: true,
                                    // backgroundColor: Colors.indigo,
                                    axes: <RadialAxis>[
                                      RadialAxis(
                                        showLabels: false,
                                        showTicks: false,
                                        startAngle: 270,
                                        endAngle: 270,
                                        minimum: 0,
                                        maximum: 26000,
                                        radiusFactor: 1.1,
                                        axisLineStyle: const AxisLineStyle(
                                          color: Color.fromRGBO(250, 160, 160,0.5),
                                          thicknessUnit: GaugeSizeUnit.factor,
                                          thickness: 0.1,
                                        ),
                                        pointers: <GaugePointer>[
                                          RangePointer(
                                            value: double.parse(_steps),
                                            cornerStyle: CornerStyle.bothCurve,
                                            enableAnimation: true,
                                            animationDuration: 1200,
                                            animationType: AnimationType.ease,
                                            sizeUnit: GaugeSizeUnit.factor,
                                            color: const Color.fromRGBO(253, 254, 255,1.0),
                                            width: 0.1,
                                          ),
                                        ],
                                        annotations: <GaugeAnnotation>[
                                          GaugeAnnotation(
                                            angle: 0,
                                            positionFactor: 0.1,
                                            widget:
                                            Text.rich( TextSpan(
                                                children:[
                                                  TextSpan(text: "${_steps} \n",
                                                    style: const TextStyle(
                                                      fontSize: 17.5,
                                                      fontWeight: FontWeight.w600,
                                                      color: Color.fromRGBO(253, 254, 255, 1.0),
                                                      // fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                  const TextSpan(text: 'Steps',
                                                    style: TextStyle(
                                                      fontSize: 15,
                                                      fontWeight: FontWeight.w500,
                                                      color: Color.fromRGBO(136, 8, 8, 1.0),
                                                      // fontStyle: FontStyle.italic,
                                                    ),
                                                  ),
                                                ]
                                            )
                                            )
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 18,),
                                SizedBox(
                                  // color: Colors.indigoAccent,
                                  width: 100,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                      _status,
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Color.fromRGBO(136, 8, 8, 1.0),
                                        // fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                      const Text.rich( TextSpan(
                                          children:[
                                            TextSpan(text: 'Goal: ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(136, 8, 8, 1.0),
                                                // fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                            TextSpan(text: '25000',
                                              style: TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(253, 254, 255, 1.0),
                                                // fontStyle: FontStyle.italic,
                                              ),
                                            ),
                                          ]
                                      )
                                      ),
                                      const Divider(
                                        height: 13,
                                        thickness: 2,
                                        // indent: 20,
                                        endIndent: 0,
                                        color: Color.fromRGBO(136, 8, 8, 1.0),
                                      ),
                                      Text.rich( TextSpan(
                                        children:[
                                          TextSpan(text: ((((double.parse(_steps)*cal)/1000)/1000).toStringAsFixed(2)).toString() ,
                                              style: const TextStyle(
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                                color: Color.fromRGBO(253, 254, 255, 1.0),
                                                // fontStyle: FontStyle.italic,
                                              ),
                                          ),
                                          const TextSpan(text: ' kcal',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w500,
                                              color: Color.fromRGBO(136, 8, 8, 1.0),
                                              // fontStyle: FontStyle.italic,
                                            ),
                                          ),
                                        ]
                                      )
                                      )
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 5,)
                      ],
                    ),
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
