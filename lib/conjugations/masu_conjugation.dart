import 'dart:collection';

import 'package:ganbareru/conjugations/conjugation.dart';

class MasuConjugation extends Conjugation {
  static final MasuConjugation _instance = MasuConjugation._internal();

  factory MasuConjugation() {
    return _instance;
  }

  MasuConjugation._internal() : super(HashMap.of({
    'する' : 'します',
    'はいる' : 'はります',
    'かえる' : 'かえります',
    'はしる' : 'はしります'
  }));

  @override
  String convertGodan(String dictionaryForm) {
    final String romanji = kanaKit.toRomaji(dictionaryForm);
    return '${kanaKit.toKana('${romanji.substring(0, romanji.length - 1)}i')}ます';
  }

  @override
  String convertIchidan(String dictionaryForm) {
    return '${dictionaryForm.substring(0, dictionaryForm.length - 1)}ます';
  }
}
