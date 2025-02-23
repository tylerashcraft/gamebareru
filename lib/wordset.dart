import 'dart:collection';

class WordSet {
  String title;
  String description;
  final LinkedHashMap<String, String> map;

  WordSet(this.title, this.description, List<String> terms, List<String> definitions) :
      map = LinkedHashMap()..addEntries(List.generate(terms.length, (int i) => MapEntry(terms[i], definitions[i])));
}
