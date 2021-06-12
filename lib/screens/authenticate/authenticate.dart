import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/screens/authenticate/sign_up.dart';
import 'package:flutter/material.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignInPage = true;

  void toggleAuthForms() {
    setState(() {
      this.showSignInPage = !this.showSignInPage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.showSignInPage
          ? SignIn(this.toggleAuthForms)
          : SignUp(this.toggleAuthForms),
    );
  }
}
