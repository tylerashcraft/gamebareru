import 'package:flutter/material.dart';
import 'package:ganbareru/pages/homepage.dart';

class FlashcardsPage extends StatefulWidget {
  const FlashcardsPage({super.key});

  @override
  State<FlashcardsPage> createState() => _FlashcardsPageState();
}

class _FlashcardsPageState extends State<FlashcardsPage> {
  final List<MapEntry<String, String>> _wordSet = List.empty(growable: true);
  int _index = 0;
  bool _showDefinition = false;

  @override
  void initState() {
    super.initState();

    for (int i = 0; i < HomePage.selectedWordSets.length; i++) {
      if (HomePage.selectedWordSets[i]) {
        _wordSet.addAll(HomePage.wordSets[i].map.entries);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_wordSet.isEmpty) {
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
              _showDefinition ? _wordSet[_index].value : _wordSet[_index].key,
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
            onPressed: () => setState(() => _wordSet.shuffle()),
            child: const Icon(Icons.shuffle),
          ),
          const SizedBox(width: 4.0),
          FloatingActionButton(
            onPressed: () => setState(() {
              if (_index != _wordSet.length - 1) {
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
