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
  final List<String> _terms = List.empty(growable: true);
  final List<String> _definitions = List.empty(growable: true);
  List<Question> _questions = List.empty(growable: true);
  int _multipleChoiceQuestionsCount = 0;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < HomePage.selectedWordSets.length; i++) {
      if (HomePage.selectedWordSets[i]) {
        _terms.addAll(HomePage.wordSets[i].terms);
        _definitions.addAll(HomePage.wordSets[i].definitions);
      }
    }
  }

  void submit() {
    for (Question question in _questions) {
      question.showAnswerController.value = true;
    }
  }

  void generateQuestions() {
    // TODO convert to bidirectional hashmap and fix bug where the first choice is always the answer because of not
    // TODO reinserting at the right index

    _questions = List.empty(growable: true);

    Random random = Random();
    List<String> terms = List.of(_terms);
    List<String> definitions = List.of(_definitions);

    for (int i = 0; i < _multipleChoiceQuestionsCount && terms.isNotEmpty; i++) {
      int index = random.nextInt(terms.length);
      String definition = definitions.removeAt(index);

      List<String> answerChoices = List.empty(growable: true);
      answerChoices.add(definition);
      definitions.shuffle(random);
      answerChoices.addAll(definitions.take(3));

      _questions.add(MultipleChoiceQuestion(terms.removeAt(index), definition, answerChoices));
      definitions.add(definition);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Test'),
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
