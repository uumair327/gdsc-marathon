import 'package:flutter/material.dart';

class QuizPage extends StatefulWidget {
  const QuizPage({Key? key}) : super(key: key);

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  final Map<String, List<Map<String, dynamic>>> quizData = {
    'easy': [
      {
        'question': 'What is the capital of France?',
        'options': ['Paris', 'Berlin', 'London', 'Madrid'],
        'correctAnswer': 'Paris',
      },
      {
        'question': 'Which planet is known as the Red Planet?',
        'options': ['Earth', 'Mars', 'Venus', 'Jupiter'],
        'correctAnswer': 'Mars',
      },
      // Add more questions for the easy level
    ],
    'medium': [
      {
        'question': 'What is the largest mammal on Earth?',
        'options': ['Elephant', 'Blue Whale', 'Giraffe', 'Lion'],
        'correctAnswer': 'Blue Whale',
      },
      {
        'question': 'In which year did Christopher Columbus reach America?',
        'options': ['1492', '1607', '1776', '1835'],
        'correctAnswer': '1492',
      },
      // Add more questions for the medium level
    ],
    'hard': [
      {
        'question': 'Who wrote the tragedy play "Macbeth"?',
        'options': ['Shakespeare', 'Homer', 'Virgil', 'Dante'],
        'correctAnswer': 'Shakespeare',
      },
      {
        'question': 'What is the capital of Bhutan?',
        'options': ['Thimphu', 'Kathmandu', 'Dhaka', 'Colombo'],
        'correctAnswer': 'Thimphu',
      },
      // Add more questions for the hard level
    ],
  };

  int currentQuestionIndex = 0;
  String selectedDifficulty = 'easy';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Page'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
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
                    quizData[selectedDifficulty]![currentQuestionIndex]
                        ['question'],
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(
                quizData[selectedDifficulty]![currentQuestionIndex]['options']
                    .length,
                (index) => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.blue,
                    onPrimary: Colors.white,
                    padding: const EdgeInsets.all(16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () {
                    checkAnswer(index);
                  },
                  child: Text(
                    quizData[selectedDifficulty]![currentQuestionIndex]
                        ['options'][index],
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
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

    moveToNextQuestion();
  }

  void moveToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < quizData[selectedDifficulty]!.length - 1) {
        currentQuestionIndex++;
      } else {
        print('Quiz completed for $selectedDifficulty level!');
      }
    });
  }
}
