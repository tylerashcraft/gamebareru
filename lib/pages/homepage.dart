import 'package:flutter/material.dart';
import 'package:gamebareru/pages/setspage.dart';
import 'package:gamebareru/pages/flashcardspage.dart';
import 'package:gamebareru/wordset.dart';

class HomePage extends StatefulWidget {
  static final List<WordSet> wordSets = List.empty(growable: true);

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Widget> _pages = [
    const SetsPage(),
    const FlashcardsPage()
  ];
  int _navigationRailIndex = 0;

  void onNavigationRailDestinationSelected(int index) {
    setState(() => _navigationRailIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        NavigationRail(
            selectedIndex: _navigationRailIndex,
            onDestinationSelected: onNavigationRailDestinationSelected,
            destinations: const [
              NavigationRailDestination(icon: Icon(Icons.book), label: Text('Sets')),
              NavigationRailDestination(icon: Icon(Icons.style), label: Text('Flashcards'))
            ]
        ),
        Flexible(child: _pages[_navigationRailIndex])
      ],
    );
  }
}
