import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:ganbareru/pages/homepage.dart';
import 'package:ganbareru/wordset.dart';

class SetsPage extends StatefulWidget {
  const SetsPage({super.key});

  @override
  State<SetsPage> createState() => _SetsPageState();
}

class _SetsPageState extends State<SetsPage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  List<TextEditingController> _termControllers = List.empty(growable: true);
  List<TextEditingController> _definitionControllers = List.empty(growable: true);
  int _editingIndex = -1;

  void _uploadWordSet() {
    // TODO: Implement uploading via JSON files
    throw UnimplementedError();
  }

  void _addWordPair() {
    setState(() {
      _termControllers.add(TextEditingController());
      _definitionControllers.add(TextEditingController());
    });
  }

  void _saveWordSet() {
    WordSet wordSet = WordSet(_titleController.text == '' ? 'Untitled' : _titleController.text,
        _descriptionController.text == '' ? 'A generic description' : _descriptionController.text,
        List.generate(_termControllers.length, (int index) => _termControllers[index].text),
        List.generate(_definitionControllers.length, (int index) => _definitionControllers[index].text));
    setState(() {
      if (_editingIndex < HomePage.wordSets.length) {
        HomePage.wordSets[_editingIndex] = wordSet;
      } else {
        HomePage.wordSets.add(wordSet);
      }
      _titleController = TextEditingController();
      _descriptionController = TextEditingController();
      _termControllers = List.empty(growable: true);
      _definitionControllers = List.empty(growable: true);
      _editingIndex = -1;
    });
  }

  void _editWordSet(int index) {
    setState(() {
      _editingIndex = index;
      _titleController = TextEditingController(text: HomePage.wordSets[_editingIndex].title);
      _descriptionController = TextEditingController(text: HomePage.wordSets[_editingIndex].description);
      _termControllers = List.empty(growable: true);
      _definitionControllers = List.empty(growable: true);

      HomePage.wordSets[_editingIndex].map.forEach((String key, String value) {
        _termControllers.add(TextEditingController(text: key));
        _definitionControllers.add(TextEditingController(text: value));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_editingIndex != -1) {
      return Scaffold(
        body: Row(
          children: [
            Flexible(
              child: ListView(
                children: List.of([
                  Card(
                    child: ListTile(
                      title: TextField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Title'
                        ),
                      ),
                    ),
                  ),
                  Card(
                    child: ListTile(
                      title: TextField(
                      controller: _descriptionController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Description'
                        ),
                      ),
                    ),
                  )
                ])..addAll(List.generate(_termControllers.length, (index) => Card(
                  child: Row(
                    children: [
                      Flexible(
                        child: ListTile(
                          title: TextField(
                            controller: _termControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Term'
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => setState(() {
                          _termControllers.removeAt(index);
                          _definitionControllers.removeAt(index);
                        }),
                        icon: const Icon(Icons.highlight_remove)
                      ),
                      Flexible(
                        child: ListTile(
                          title: TextField(
                            controller: _definitionControllers[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Definition'
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
            const SizedBox(height: 4.0),
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
            trailing: Checkbox(
              value: HomePage.selectedWordSets[index],
              onChanged: (bool? value) => setState(() => HomePage.selectedWordSets[index] = value!)
            ),
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
            onTap: () => setState(() {
              _editingIndex = HomePage.wordSets.length;
              HomePage.selectedWordSets.add(false);
            })
          )
        ],
      ),
    );
  }
}
