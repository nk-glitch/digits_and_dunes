import 'dart:math';
import '../models/question.dart';

class QuestionService {
  final Random _random = Random();

  List<Question> generateQuestions(int level) {
    List<Question> questions = [];

    for (int i = 0; i < 5; i++) {
      int num1 = _random.nextInt(10 * level) + 1;
      int num2 = _random.nextInt(10 * level) + 1;
      String questionText = "";
      int correctAnswer = 0;
      List<int> choices = [];

      if (level <= 3) {
        // Addition & Subtraction
        if (_random.nextBool()) {
          questionText = "$num1 + $num2 = ?";
          correctAnswer = num1 + num2;
        } else {
          questionText = "$num1 - $num2 = ?";
          correctAnswer = num1 - num2;
        }
      } else if (level <= 6) {
        // Multiplication & Division
        if (_random.nextBool()) {
          questionText = "$num1 × $num2 = ?";
          correctAnswer = num1 * num2;
        } else {
          num1 = num1 * num2; // Ensure divisible
          questionText = "$num1 ÷ $num2 = ?";
          correctAnswer = num1 ~/ num2;
        }
      } else {
        // Mixed Operations
        int operation = _random.nextInt(4);
        switch (operation) {
          case 0:
            questionText = "$num1 + $num2 = ?";
            correctAnswer = num1 + num2;
            break;
          case 1:
            questionText = "$num1 - $num2 = ?";
            correctAnswer = num1 - num2;
            break;
          case 2:
            questionText = "$num1 × $num2 = ?";
            correctAnswer = num1 * num2;
            break;
          case 3:
            num1 = num1 * num2;
            questionText = "$num1 ÷ $num2 = ?";
            correctAnswer = num1 ~/ num2;
            break;
        }
      }

      choices.add(correctAnswer);
      while (choices.length < 4) {
        int fakeAnswer = correctAnswer + _random.nextInt(10) - 5;
        if (fakeAnswer != correctAnswer && !choices.contains(fakeAnswer)) {
          choices.add(fakeAnswer);
        }
      }
      choices.shuffle();

      questions.add(Question(
        questionText: questionText,
        options: choices.map((e) => e.toString()).toList(),
        correctAnswer: correctAnswer.toString(),
      ));
    }

    return questions;
  }
}
