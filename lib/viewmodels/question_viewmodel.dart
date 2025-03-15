import 'package:flutter/material.dart';
import '../models/question.dart';
import '../services/question_service.dart';

class QuestionViewModel extends ChangeNotifier {
  final QuestionService _questionService = QuestionService();
  List<Question> _questions = [];
  Map<int, String> _selectedAnswers = {}; // Track selected answers
  List<Question> get questions => _questions;
  Map<int, String> get selectedAnswers => _selectedAnswers;

  QuestionViewModel(int level) {
    _loadQuestions(level);
  }

  void _loadQuestions(int level) {
    _questions = _questionService.generateQuestions(level);
    notifyListeners();
  }

  void selectAnswer(int questionIndex, String answer) {
    _selectedAnswers[questionIndex] = answer;
    notifyListeners();
  }

  bool get allQuestionsAnswered => 
      _selectedAnswers.length == _questions.length;

  double calculateAccuracy() {
    if (_questions.isEmpty) return 0.0;
    int correctAnswers = 0;
    
    _selectedAnswers.forEach((index, answer) {
      if (_questions[index].correctAnswer == answer) {
        correctAnswers++;
      }
    });

    return correctAnswers / _questions.length;
  }

  int calculateStars() {
    double accuracy = calculateAccuracy();
    if (accuracy >= 0.9) return 3;
    if (accuracy >= 0.7) return 2;
    if (accuracy >= 0.5) return 1;
    return 0;
  }
}
