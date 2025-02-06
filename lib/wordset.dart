import 'package:quiver/collection.dart';

class WordSet {
  String title;
  String description;
  HashBiMap<String, String> words;

  WordSet(this.title, this.description, this.words);
}
