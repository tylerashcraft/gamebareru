import 'package:flutter/material.dart';
import 'package:ganbareru/questions/question.dart';

class FreeResponseQuestion extends Question {
  final String _term;
  final String _definition;
  final TextEditingController _controller = TextEditingController();
  
  FreeResponseQuestion(this._term, this._definition, {super.key, super.showAnswerController});

  @override
  bool isCorrect() {
    return _controller.text == _definition;
  }

  @override
  State<StatefulWidget> createState() => _FreeResponseQuestionState();
}

class _FreeResponseQuestionState extends State<FreeResponseQuestion> {
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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: widget._controller,
              decoration: const InputDecoration(
                labelText: 'Answer',
                border: OutlineInputBorder()
              ),
            ),
          )
        ],
      ),
    );
  }
}
