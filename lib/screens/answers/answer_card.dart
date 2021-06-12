import 'package:brew_crew/models/answer.dart';
import 'package:flutter/material.dart';

class AnswerCard extends StatefulWidget {
  final Answer answer;

  AnswerCard(this.answer);

  @override
  _AnswerCardState createState() => _AnswerCardState();
}

class _AnswerCardState extends State<AnswerCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          children: [
            ListTile(
              leading: Icon(Icons.account_circle),
            ),
          ],
        ),
      ),
    );
  }
}
