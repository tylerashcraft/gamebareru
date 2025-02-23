import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gamebareru/pages/homepage.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<String> _terms = List.empty(growable: true);
  final List<String> _definitions = List.empty(growable: true);
  int _index = 0;
  bool _showDefinition = false;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < HomePage.selectedWordSets.length; i++) {
      if (HomePage.selectedWordSets[i]) {
        _terms.addAll(HomePage.wordSets[i].map.keys);
        _definitions.addAll(HomePage.wordSets[i].map.values);
      }
    }
  }

  void shuffle() {
    setState(() {
      Random random = Random();
      _terms.shuffle(random);
      _definitions.shuffle(random);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_terms.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('Please select a word set with terms and definitions')
        ),
      );
    }

    return Scaffold(
      body: GestureDetector(
        onTap: () => setState(() => _showDefinition = !_showDefinition),
        child: Card(
          child: Center(
            child: Text(
              _showDefinition ? _definitions[_index] : _terms[_index],
              style: TextStyle(
                fontSize: MediaQuery.sizeOf(context).longestSide / 20
              ),
            ),
          )
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FloatingActionButton(
            onPressed: () => setState(() {
              if (_index != 0) {
                _index--;
                _showDefinition = false;
              }
            }),
            child: const Icon(Icons.navigate_before)
          ),
          const SizedBox(width: 4.0),
          FloatingActionButton(
            onPressed: shuffle,
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(width: 4.0),
          FloatingActionButton(
            onPressed: () => setState(() {
              if (_index != _terms.length - 1) {
                _index++;
                _showDefinition = false;
              }
            }),
            child: const Icon(Icons.navigate_next),
          ),
        ],
      ),
    );
  }
}
