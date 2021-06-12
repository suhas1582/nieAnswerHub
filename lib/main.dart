import 'package:brew_crew/models/answer.dart';
import 'package:brew_crew/models/question.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:brew_crew/services/auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:brew_crew/screens/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './models/user.dart';
import './models/question.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<UserModel>.value(
          value: AuthService().user,
        ),
        StreamProvider<List<Question>>.value(
          value: DatabaseService().questions,
        ),
        StreamProvider<List<Answer>>.value(
          value: DatabaseService().answers,
        ),
      ],
      child: MaterialApp(
        theme: ThemeData.dark(),
        debugShowCheckedModeBanner: false,
        home: Wrapper(),
      ),
    );
  }
}
