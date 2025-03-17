import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/question_viewmodel.dart';
import 'level_complete_screen.dart';

class LevelPage extends StatelessWidget {
  final int worldIndex;
  final int level;

  const LevelPage({
    Key? key, 
    required this.worldIndex,
    required this.level,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => QuestionViewModel(level),
      child: Scaffold(
        appBar: AppBar(title: Text('Level $level')),
        body: Consumer<QuestionViewModel>(
          builder: (context, questionViewModel, child) {
            if (questionViewModel.questions.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
              itemCount: questionViewModel.questions.length,
              itemBuilder: (context, index) {
                final question = questionViewModel.questions[index];
                      final selectedAnswer = questionViewModel.selectedAnswers[index];

                      return Card(
                        margin: const EdgeInsets.all(8.0),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Question ${index + 1}:',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                question.questionText,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 12),
                              ...question.options.map((option) => 
                                ListTile(
                                  title: Text(option),
                                  leading: Radio<String>(
                                    value: option,
                                    groupValue: selectedAnswer,
                                    onChanged: (value) {
                                      if (value != null) {
                                        questionViewModel.selectAnswer(index, value);
                                      }
                                    },
                                  ),
                                  tileColor: selectedAnswer == option 
                                      ? Colors.blue.withOpacity(0.1) 
                                      : null,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: questionViewModel.allQuestionsAnswered
                        ? () {
                            final accuracy = questionViewModel.calculateAccuracy();
                            final stars = questionViewModel.calculateStars();
                            
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => LevelCompleteScreen(
                                  accuracy: accuracy,
                                  stars: stars,
                                  worldIndex: worldIndex,
                                  level: level,
                                ),
                              ),
                            );
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                    ),
                    child: const Text(
                      'Submit',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
