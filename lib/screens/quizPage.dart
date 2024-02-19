import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:marathon/firestore/questions.dart';
import 'package:marathon/firestore/userdata.dart';
import 'package:marathon/screens/scanner.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  var quizData;
  var chk;

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((questions) {
      setState(() {
        quizData = questions;
      });
    });

    getCurrentCheckpoint().then((checkpoint) {
      setState(() {
        chk = checkpoint;
      });
    });
  }


  int currentCheckpoint = -1;
  int currentQuestionIndex = 0;
  String selectedDifficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Quiz Page'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButton<String>(
                    value: selectedDifficulty,
                    onChanged: (String? newValue) {
                      setState(() {
                        selectedDifficulty = newValue!;
                        currentQuestionIndex = 0;
                      });
                    },
                    items: ['easy', 'medium', 'hard']
                        .map(
                          (value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(
                              value,
                              style: const TextStyle(fontSize: 18),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 20),
                  Card(
                    elevation: 4.0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        quizData
                            .where((e) =>
                                e["checkpoint"] == chk &&
                                e["difficulty"] == selectedDifficulty
                              )
                            .toList()[0]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    quizData
                        .where((e) =>
                            e["checkpoint"] == chk &&
                            e["difficulty"] == selectedDifficulty)
                        .toList()[0]['options']
                        .length,
                    (index) => Column(
                      children: [
                        const SizedBox(height: 10, width: double.infinity),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.all(30.0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4.0),
                              ),
                            ),
                            onPressed: () {
                              checkAnswer(index);
                            },
                            child: Text(
                              quizData
                                  .where((e) =>
                                      e["checkpoint"] == chk &&
                                      e["difficulty"] == selectedDifficulty)
                                  .toList()[0]['options'][index],
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void checkAnswer(int selectedOptionIndex) {
    FirebaseFirestore db = FirebaseFirestore.instance;
    db.collection("questions")
        .where("difficulty", isEqualTo: selectedDifficulty )
        .where("checkpoint", isEqualTo: chk)
        .get()
        .then((querysnapshot) {
          final data = querysnapshot.docs[0].data() as Map<String, dynamic>;
          int correctOption = data["correctOption"];
          String difficulty = data["difficulty"];
          print("s $selectedOptionIndex");
          print("c $correctOption");
          if(selectedOptionIndex == correctOption){
            if(difficulty == "easy"){
              updateScore(1);
            }else if(difficulty == "medium"){
              updateScore(2);
            }else if(difficulty == "hard"){
              updateScore(3);
            }
            moveToScannerPage();
          }
        });
  }

  void moveToScannerPage() {
    // Navigate to ScannerPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScannerPage()),
    );
  }
}
