import 'package:ganbareru/questions/question.dart';
import 'package:flutter/material.dart';

class MultipleChoiceQuestion extends Question {
  final String _term;
  final String _definition;
  final List<String> _answerChoices;
  final ValueNotifier<String> _selectedAnswerController;

  MultipleChoiceQuestion(this._term, this._definition, this._answerChoices, {super.key, super.showAnswerController,
    ValueNotifier<String>? selectedAnswerController})
      : _selectedAnswerController = selectedAnswerController ?? ValueNotifier('');

  @override
  bool isCorrect() {
    return _selectedAnswerController.value == _definition;
  }

  @override
  State<StatefulWidget> createState() => _MultipleChoiceQuestionState();
}

class _MultipleChoiceQuestionState extends State<MultipleChoiceQuestion> {
  @override
  Widget build(BuildContext context) {
    widget.showAnswerController.addListener(() => setState(() {}));

    return Card(
      color: widget.showAnswerController.value ? widget.isCorrect() ? Colors.green[100] : Colors.red[100] : Theme.of
        (context).cardColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget._term,
                  style: const TextStyle(
                    fontSize: 48
                  ),
                ),
                if (widget.showAnswerController.value)
                  ...[Icon(widget.isCorrect() ? Icons.check : Icons.close)]
              ]
            ),
          ),
          ...List.generate(widget._answerChoices.length, (int index) => RadioListTile<String>(
            value: widget._answerChoices[index],
            groupValue: widget._selectedAnswerController.value,
            onChanged: (String? selectedAnswer) {
              if (!widget.showAnswerController.value) {
                setState(() => widget._selectedAnswerController.value = selectedAnswer ?? '');
              }
            },
            title: Text(widget._answerChoices[index]),
          ))
        ],
      ),
    );
  }
}
