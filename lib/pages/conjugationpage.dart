import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ganbareru/conjugations/conjugation.dart';
import 'package:ganbareru/conjugations/masu_conjugation.dart';
import 'package:ganbareru/pages/homepage.dart';
import 'package:ganbareru/questions/free_response_question.dart';

class ConjugationPage extends StatefulWidget {
  const ConjugationPage({super.key});

  @override
  State<ConjugationPage> createState() => _ConjugationPageState();
}

class _ConjugationPageState extends State<ConjugationPage> {
  final List<MapEntry<String, String>> _words = List.empty(growable: true);
  final HashMap<Conjugation, bool> _conjugationMap = HashMap();
  FreeResponseQuestion? _question;
  bool _canCheckAnswer = true;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < HomePage.selectedWordSets.length; i++) {
      if (HomePage.selectedWordSets[i]) {
        _words.addAll(HomePage.wordSets[i].map.entries);
      }
    }
  }

  void _checkAnswer() {
    if (_canCheckAnswer) {
      _canCheckAnswer = false;
      _question!.showAnswerController.value = true;
      Future.delayed(const Duration(milliseconds: 500), () {
        _generateQuestion();
        _canCheckAnswer = true;
      });
    }
  }

  void _generateQuestion() {
    final Random random = Random();
    final MapEntry<String, String> wordPair = _words[random.nextInt(_words.length)];
    final Iterable<Conjugation> conjugations = _conjugationMap.keys.toList()..shuffle(random);
    setState(() => _question = FreeResponseQuestion(wordPair.key, conjugations.first.convert(wordPair.value)));
  }

  @override
  Widget build(BuildContext context) {
    if (_words.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Please select a word set with terms and definitions')
        ),
      );
    }

    Size size = MediaQuery.sizeOf(context);

    return KeyboardListener(
      focusNode: FocusNode(),
      onKeyEvent: (KeyEvent keyEvent) async {
        if (keyEvent.logicalKey == LogicalKeyboardKey.enter) {
          _checkAnswer();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Conjugation Practice'),
          actions: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (BuildContext context) => StatefulBuilder(
                  builder: (BuildContext context, Function(void Function()) setState) {
                    return AlertDialog(
                      title: const Text('Settings'),
                      content: SizedBox(
                        width: size.width / 2,
                        height: size.height / 2,
                        child: ListView(
                          children: [
                            ExpansionTile(
                              title: const Text('Verbs'),
                              children: [
                                CheckboxListTile(
                                  title: const Text('〜ます'),
                                  value: _conjugationMap[MasuConjugation()] ?? false,
                                  onChanged: (bool? value) => setState(() => _conjugationMap[MasuConjugation()] = value!)
                                )
                              ],
                            )
                          ],
                        )
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context, 'Generate');
                            _generateQuestion();
                          },
                          child: const Text('Generate')
                        )
                      ],
                    );
                  }
                )
              ),
              icon: const Icon(Icons.settings)
            )
          ],
        ),
        body: _question ?? Container(),
        floatingActionButton: FloatingActionButton(
          onPressed: _checkAnswer,
          child: const Icon(Icons.check),
        ),
      ),
    );
  }
}
