import 'package:brew_crew/models/answer.dart';
import 'package:brew_crew/models/question.dart';
import 'package:brew_crew/models/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {
  final String uid;

  DatabaseService({this.uid});

  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  final CollectionReference questionCollection =
      FirebaseFirestore.instance.collection('Questions');

  final CollectionReference answerCollection =
      FirebaseFirestore.instance.collection('answers');

  Future<void> updateUserData(
      String name, String usn, int sem, String branch, String email) async {
    return await userCollection
        .doc(uid)
        .set({
          'name': name,
          'usn': usn,
          'sem': sem,
          'branch': branch,
          'email': email
        })
        .then((value) => print('User Added'))
        .catchError((error) => print(error));
  }

  Future<UserModel> getUserById() async {
    var document = await userCollection.doc(uid).get();
    print(document);
    return UserModel();
  }

  List<Question> _questionListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      // print(doc.id);
      return Question(
        question: doc['Question'],
        tags: doc['Tags'],
        id: doc.id,
      );
    }).toList();
  }

  List<Answer> _answerListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Answer(
        answer: doc['answer'],
        qid: doc['question'],
        userId: doc['user'],
      );
    }).toList();
  }

  Future<void> addQuestion(Question question) async {
    print(question.tags);
    return await questionCollection
        .add({
          'Question': question.question,
          'Tags': question.tags,
          'user': this.uid
        })
        .then((value) => print('Question Added'))
        .catchError((error) => print(error));
  }

  void _userFromSnapshot() {
    print(userCollection.doc(uid).snapshots());
  }

  // Stream<UserModel> get userProfile {
  //   return userCollection.doc(uid).snapshots().map();
  // }

  Stream<List<Answer>> get answers {
    return answerCollection.snapshots().map(_answerListFromSnapshot);
  }

  Stream<List<Question>> get questions {
    return questionCollection.snapshots().map(_questionListFromSnapshot);
  }
}
