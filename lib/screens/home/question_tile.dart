import 'package:brew_crew/models/question.dart';
import 'package:flutter/material.dart';
import '../answers/answer_list.dart';

class QuestionTile extends StatelessWidget {
  final Question question;

  QuestionTile(this.question);

  List<Widget> _createChildren(List<dynamic> tags) {
    return new List<Widget>.generate(tags.length, (index) {
      return Card(
        elevation: 6,
        child: Text(tags[index].toString()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AnswersPage(question: this.question)))
      },
      child: Card(
        child: ListTile(
          title: Text(question.question),
          subtitle: Row(
            children: new List.from([Text('Tags: ')])
              ..addAll(this._createChildren(question.tags)),
          ),
        ),
      ),
    );
  }
}
