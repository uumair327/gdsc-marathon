import 'package:flutter/material.dart';
import 'package:marathon/firestore/questions.dart';
import 'package:marathon/screens/scanner.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  // Map<String, List<Map<String, dynamic>>> quizData = {
  //   'easy': [
  //     {
  //       'question': 'What is the capital of France?',
  //       'options': ['Paris', 'Berlin', 'London', 'Madrid'],
  //       'correctAnswer': 'Paris',
  //     },
  //   ],
  //   'medium': [
  //     {
  //       'question': 'What is the largest mammal on Earth?',
  //       'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Lion'],
  //       'correctAnswer': 'Blue Whale',
  //     },
  //   ],
  //   'hard': [
  //     {
  //       'question': 'Who wrote the tragedy play "Macbeth"?',
  //       'options': ['Shakespeare', 'Homer', 'Virgil', 'Dante'],
  //       'correctAnswer': 'Shakespeare',
  //     },
  //   ],
  // };

  var quizData;

  @override
  void initState() {
    super.initState();
    fetchQuestions().then((questions) {
      setState(() {
        quizData = questions;
      });
    });
  }

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
                        quizData[0]['name'],
                        style: const TextStyle(fontSize: 20),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ...List.generate(
                    quizData[0]['options'].length,
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
                              quizData[0]['options'][index],
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
    final String correctAnswer =
        quizData[selectedDifficulty]![currentQuestionIndex]['correctAnswer'];
    final String selectedAnswer =
        quizData[selectedDifficulty]![currentQuestionIndex]['options']
            [selectedOptionIndex];

    if (selectedAnswer == correctAnswer) {
      // Handle correct answer logic
      print('Correct!');
    } else {
      // Handle incorrect answer logic
      print('Incorrect!');
    }
    //moveToScannerPage(); // Change to navigate to ScannerPage
  }

  void moveToScannerPage() {
    // Navigate to ScannerPage
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ScannerPage()),
    );
  }
}
