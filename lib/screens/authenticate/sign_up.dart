import 'package:brew_crew/models/auth_result.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/screens/authenticate/sign_in.dart';
import 'package:brew_crew/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/auth.dart';
import '../../utils/dialog/show_dialog.dart';
import '../../utils/spinner/loading_spinner.dart';

class SignUp extends StatefulWidget {
  Function toggleForms;

  SignUp(this.toggleForms);

  @override
  _SignUpState createState() => _SignUpState();
}

enum inputValidated {
  VALIDATED,
  NAME_ERROR,
  BRANCH_ERROR,
  YEAR_ERROR,
  EMAIL_ERROR,
  PASSWORD_ERROR,
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();

  final nameController = TextEditingController();
  final branchController = TextEditingController();
  final yearController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usnController = TextEditingController();

  Iterable<RegExpMatch> matches;

  bool validateEmail(String email) {
    RegExp exp = new RegExp(r'(.*)@nie\.ac\.in');
    matches = exp.allMatches(email);
    return matches.isNotEmpty;
  }

  final _formKey = GlobalKey<FormState>();

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: loading
          ? Loading()
          : Scaffold(
              appBar: AppBar(
                title: Text('Sign into Brew Crew'),
              ),
              body: Form(
                key: _formKey,
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Enter a name' : null,
                            controller: nameController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Name',
                            ),
                          ),
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Enter USN' : null,
                            controller: usnController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'USN',
                            ),
                          ),
                          TextFormField(
                            validator: (value) => value.isEmpty ||
                                    int.parse(value) < 0 ||
                                    int.parse(value) > 8
                                ? 'Enter a valid Semester'
                                : null,
                            controller: yearController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Semester',
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          TextFormField(
                            validator: (value) =>
                                value.isEmpty ? 'Enter a Branch' : null,
                            controller: branchController,
                            maxLength: 3,
                            autofocus: false,
                            decoration: InputDecoration(
                                labelText: 'Branch',
                                hintText: 'Eg: CSE, ISE, etc.,'),
                          ),
                          TextFormField(
                            validator: (value) {
                              return value == '' ? 'Enter an email' : null;
                            },
                            controller: emailController,
                            autofocus: false,
                            decoration: InputDecoration(
                              labelText: 'Email',
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                          TextFormField(
                            validator: (value) => value.isEmpty ||
                                    value.length < 6
                                ? 'Enter a valid password of 6 or more characters'
                                : null,
                            controller: passwordController,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                          ),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18),
                                  ),
                                ),
                              ),
                              onPressed: () async {
                                bool isEmailValid =
                                    validateEmail(emailController.text);
                                if (_formKey.currentState.validate() &&
                                    isEmailValid) {
                                  setState(() {
                                    loading = true;
                                  });
                                  AuthResult result = await _auth.signup(
                                      nameController.text,
                                      usnController.text,
                                      branchController.text,
                                      int.parse(yearController.text),
                                      emailController.text,
                                      passwordController.text);
                                  if (mounted) {
                                    setState(() {
                                      loading = false;
                                    });
                                  }
                                  if (!result.isAuthSuccessful) {
                                    if (result.errMsg ==
                                        'email-already-in-use') {
                                      showMyDialog(
                                          context,
                                          'Email already exists',
                                          'The email entered already exists. Please choose a different email.');
                                    }
                                  }
                                } else if (!isEmailValid) {
                                  showMyDialog(context, 'Use only NIE mail ID',
                                      'Please only use NIE mail ID to sign up to the paltform');
                                }
                              },
                              child: Text('Sign up'),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              widget.toggleForms();
                            },
                            child: Text('Login Here...'),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
    );
  }
}
