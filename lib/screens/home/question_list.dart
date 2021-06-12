import 'package:brew_crew/models/question.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/question_tile.dart';
import 'package:brew_crew/utils/spinner/loading_spinner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';

class QuestionList extends StatefulWidget {
  @override
  _QuestionListState createState() => _QuestionListState();
}

class _QuestionListState extends State<QuestionList> {
  @override
  Widget build(BuildContext context) {
    final questions = Provider.of<List<Question>>(context);
    final user = Provider.of<UserModel>(context);
    bool loading = true;
    // questions.docs.forEach(
    //   (element) {
    //     print(element['Question']);
    //     print(element['Tags']);
    //   },
    // );
    if (questions != null) {
      setState(() {
        loading = false;
      });
    }
    print(user.uid);
    return loading
        ? Loading()
        : ListView.builder(
            itemBuilder: (context, index) {
              return QuestionTile(questions[index]);
            },
            itemCount: questions.length,
          );
    // return Container(
    //   child: Text('HEllo'),
    // );
  }
}
