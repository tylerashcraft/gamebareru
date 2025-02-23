import 'dart:collection';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gamebareru/questions/multiple_choice_question.dart';
import 'package:gamebareru/questions/question.dart';
import 'package:gamebareru/pages/homepage.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  final HashMap<String, String> _map = HashMap();
  List<Question> _questions = List.empty(growable: true);
  int _multipleChoiceQuestionsCount = 0;
  int _score = -1;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < HomePage.selectedWordSets.length; i++) {
      if (HomePage.selectedWordSets[i]) {
        _map.addAll(HomePage.wordSets[i].map);
      }
    }
  }

  void submit() {
    _score = 0;
    for (Question question in _questions) {
      question.showAnswerController.value = true;
      if (question.isCorrect()) {
        _score++;
      }
    }
    
    setState(() {});
  }

  void generateQuestions() {
    _score = -1;
    _questions = List.empty(growable: true);

    Random random = Random();
    List<String> terms = List.of(_map.keys);
    List<String> definitions = List.of(_map.values);

    for (int i = 0; i < _multipleChoiceQuestionsCount && terms.isNotEmpty; i++) {
      String term = terms.removeAt(random.nextInt(terms.length));
      String definition = _map[term]!;
      List<String> answerChoices = List.empty(growable: true);

      // Move the correct answer to answer choices
      answerChoices.add(definition);
      definitions.remove(definition);

      // Pick 3 other answer choices
      definitions.shuffle(random);
      answerChoices.addAll(definitions.take(3));
      answerChoices.shuffle(random);

      // Rebuild definitions
      definitions.add(definition);

      _questions.add(MultipleChoiceQuestion(term, definition, answerChoices));
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Test ${_score == -1 ? '' : '$_score/${_questions.length}'}'),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Generate Test'),
                content: SizedBox(
                  width: size.width / 2,
                  height: size.height / 2,
                  child: ListView(
                    children: [
                      TextField(
                        keyboardType: TextInputType.number,
                        onChanged: (String input) => _multipleChoiceQuestionsCount = int.tryParse(input) ?? 0,
                        decoration: const InputDecoration(
                          labelText: 'Number of Multiple Choice Questions',
                          border: OutlineInputBorder()
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context, 'Generate');
                      generateQuestions();
                    },
                    child: const Text('Generate')
                  )
                ],
              )
            ),
            icon: const Icon(Icons.settings)
          )
        ],
      ),
      body: ListView(
        children: _questions,
      ),
      floatingActionButton: ElevatedButton(
        onPressed: submit,
        child: const Text('Submit'),
      ),
    );
  }
}
