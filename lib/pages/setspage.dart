import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:gamebareru/pages/homepage.dart';
import 'package:gamebareru/wordset.dart';
import 'package:quiver/collection.dart';

class SetsPage extends StatefulWidget {
  const SetsPage({super.key});

  @override
  State<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends State<SetsPage> {
  List<String> _leftWords = List.empty(growable: true);
  List<String> _rightWords = List.empty(growable: true);
  bool _creatingWordSet = false;
  String _title = 'Untitled';
  String _description = 'A generic description';

  void _uploadWordSet() {
    // TODO: Implement uploading via JSON files
    throw UnimplementedError();
  }

  void _addWordPair() {
    setState(() {
      _leftWords.add('');
      _rightWords.add('');
    });
  }

  void _saveWordSet() {
    HashBiMap<String, String> wordPairs = HashBiMap();

    for (int i = 0; i < _leftWords.length; i++) {
      wordPairs[_leftWords[i]] = _rightWords[i];
    }

    setState(() {
      HomePage.wordSets.add(WordSet(_title, _description, wordPairs));
      _leftWords = List.empty(growable: true);
      _rightWords = List.empty(growable: true);
      _title = 'Untitled';
      _description = 'A generic description';
      _creatingWordSet = false;
    });
  }

  void _editWordSet(int index) {

  }

  @override
  Widget build(BuildContext context) {
    if (_creatingWordSet) {
      return Scaffold(
        body: Row(
          children: [
            Flexible(
              child: ListView(
                children: List.of([
                  Card(
                    child: ListTile(
                      title: TextField(
                        onChanged: (String title) => setState(() => _title = title),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Type the set title'
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextField(
                        onChanged: (String description) => setState(() => _description = description),
                        decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Type the set description'
                        ),
                      ),
                    ),
                  )
                ])..addAll(List.generate(_leftWords.length, (index) => Card(
                  child: Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: TextField(
                            onChanged: (String word) => setState(() => _leftWords[index] = word),
                            decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Type a word'
                            ),
                          ),
                        ),
                      ),
                      Flexible(
                        child: ListTile(
                          title: TextField(
                            onChanged: (String word) => setState(() => _rightWords[index] = word),
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Type a word'
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ))),
              ),
            ),
          ],
        ),
        floatingActionButton: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            FloatingActionButton(
              onPressed: _saveWordSet,
              mini: true,
              child: const Icon(Icons.save),
            ),
            const SizedBox(height: 4),
            FloatingActionButton(
              onPressed: _addWordPair,
              child: const Icon(Icons.add),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: ListView(
        children: List.generate(HomePage.wordSets.length, (int index) => Card(
          child: ListTile(
            leading: const Icon(Icons.abc),
            title: Text(HomePage.wordSets[index].title),
            subtitle: Text(HomePage.wordSets[index].description),
            onTap: () => _editWordSet(index),
          )
        )),
      ),
      floatingActionButton: SpeedDial(
        icon: Icons.add,
        activeIcon: Icons.close,
        children: [
          SpeedDialChild(
            child: const Icon(Icons.upload),
            onTap: _uploadWordSet
          ),
          SpeedDialChild(
            child: const Icon(Icons.add),
            onTap: () => setState(() => _creatingWordSet = true)
          )
        ],
      ),
    );
  }
}
