import 'dart:collection';

import 'package:kana_kit/kana_kit.dart';

abstract class Conjugation {
  final KanaKit kanaKit = const KanaKit();
  final HashMap<String, String> specialCasesMap;

  Conjugation(this.specialCasesMap);

  String convert(String dictionaryForm) {
    if (specialCasesMap[dictionaryForm] == null) {
      if (dictionaryForm.endsWith('る')) {
        // vowel of last kana before る
        final String romanji = kanaKit.toRomaji(dictionaryForm[dictionaryForm.length - 2]);
        switch (romanji[romanji.length - 1]) {
          case 'e' || 'i':
            return convertIchidan(dictionaryForm);
          default:
            return convertGodan(dictionaryForm);
        }
      }
      return convertGodan(dictionaryForm);
    }
    return specialCasesMap[dictionaryForm]!;
  }

  String convertGodan(String dictionaryForm);

  String convertIchidan(String dictionaryForm);
}
