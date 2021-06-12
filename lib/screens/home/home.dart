import 'package:brew_crew/models/question.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/home/question_list.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:brew_crew/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final _authInstance = AuthService();
  final _formkey = GlobalKey<FormState>();

  final questionController = TextEditingController();
  final tagsController = TextEditingController();

  var currentIndex = 0;

  List<dynamic> _processInputTags(String tags) {
    tags = tags.trim();
    List<dynamic> tagsList = tags.split('#');
    tagsList = tagsList.sublist(1);
    // print(tagsList);
    return tagsList;
  }

  void clearInputs() {
    questionController.text = '';
    tagsController.text = '#general';
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    this.tagsController.text = '#general';

    final _dbService = new DatabaseService(uid: user.uid);

    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          TextButton(
            child: Icon(Icons.account_box_rounded),
            onPressed: () async {
              await _authInstance.signout();
            },
          ),
        ],
      ),
      body: QuestionList(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Form(
                key: this._formkey,
                child: Container(
                  height: 200,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            TextFormField(
                              controller: questionController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              validator: (value) =>
                                  value == '' ? 'Enter a question' : null,
                              decoration: InputDecoration(
                                labelText: 'Question',
                              ),
                            ),
                            TextFormField(
                              controller: tagsController,
                              validator: (value) =>
                                  value == '' ? 'Enter appropriate tags' : null,
                              decoration: InputDecoration(
                                  labelText: 'Tags',
                                  hintText: 'Eg: #general #year3 etc'),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                TextButton(
                                  child: Text('Cancel'),
                                  onPressed: () {
                                    Navigator.pop(context);
                                    questionController.text = '';
                                    tagsController.text = '#general';
                                  },
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                ElevatedButton(
                                  child: Text('Ask Question'),
                                  onPressed: () async {
                                    if (this._formkey.currentState.validate()) {
                                      final List<dynamic> tagsList =
                                          _processInputTags(
                                              tagsController.text);
                                      Question question = new Question(
                                          question: questionController.text,
                                          tags: tagsList);
                                      Navigator.pop(context);
                                      await _dbService.addQuestion(question);
                                      questionController.text = '';
                                      tagsController.text = '#general';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: this.currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
            // title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
            // title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fireplace),
            label: 'Dept',
            // title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Profile',
            // title: Text('Home'),
          ),
        ],
        onTap: (index) {
          setState(() {
            this.currentIndex = index;
          });
          print('Index pressed: $index');
        },
      ),
    );
  }
}
