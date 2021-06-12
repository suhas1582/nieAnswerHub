import 'package:brew_crew/models/answer.dart';
import 'package:brew_crew/models/question.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/answers/answer_card.dart';
import 'package:brew_crew/services/database.dart';
import '../home/question_tile.dart';
import 'package:brew_crew/utils/spinner/loading_spinner.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AnswersPage extends StatefulWidget {
  AnswersPage({this.question});

  final Question question;

  @override
  _AnswersPageState createState() => _AnswersPageState();
}

class _AnswersPageState extends State<AnswersPage> {
  List<Answer> filterRelaventAnswers(List<Answer> answers) {
    return answers
        .where((element) => element.qid == widget.question.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    List<Answer> answers = Provider.of<List<Answer>>(context);
    UserModel user = Provider.of<UserModel>(context);

    bool loading = true;

    if (answers != null) {
      setState(() {
        loading = false;
      });
    }

    answers = filterRelaventAnswers(answers);

    return Scaffold(
      appBar: AppBar(
        title: Text('QnA'),
      ),
      body: loading
          ? Loading()
          : SingleChildScrollView(
              child: Column(
                children: [
                  QuestionTile(widget.question),
                  answers.isEmpty
                      ? Center(
                          child: Container(
                            child:
                                Text('No Answers yet! Be the first to answer'),
                            margin: EdgeInsets.all(30),
                          ),
                        )
                      : answers.map((answer) {
                          return AnswerCard(answer);
                        }).toList() as Widget,
                ],
              ),
            ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          DatabaseService(uid: user.uid).getUserById();
        },
      ),
    );
  }
}
