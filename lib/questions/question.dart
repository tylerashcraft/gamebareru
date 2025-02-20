import 'package:flutter/cupertino.dart';

abstract class Question extends StatefulWidget {
  final ValueNotifier<bool> showAnswerController;

  Question({super.key, ValueNotifier<bool>? showAnswerController}) :
      showAnswerController = showAnswerController ?? ValueNotifier(false);

  bool isCorrect();
}
