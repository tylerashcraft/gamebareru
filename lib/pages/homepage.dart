import 'package:flutter/material.dart';
import 'package:ganbareru/pages/setspage.dart';
import 'package:ganbareru/pages/flashcardspage.dart';
import 'package:ganbareru/pages/testpage.dart';
import 'package:ganbareru/wordset.dart';

class HomePage extends StatefulWidget {
  static final List<WordSet> wordSets = List.empty(growable: true);
  static final List<bool> selectedWordSets = List.empty(growable: true);

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const SetsPage(),
    const FlashcardsPage(),
    const TestPage()
  ];
  int _navigationRailIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
            selectedIndex: _navigationRailIndex,
            onDestinationSelected: (index) => setState(() => _navigationRailIndex = index),
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Sets')),
              NavigationRailDestination(icon: Icon(Icons.style), label: Text('Flashcards')),
              NavigationRailDestination(icon: Icon(Icons.edit_document), label: Text('Test'))
            ]
        ),
        Flexible(child: _pages[_navigationRailIndex])
      ],
    );
  }
}
