import 'package:brew_crew/models/auth_result.dart';
import 'package:brew_crew/models/user.dart';
import 'package:brew_crew/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel _userFromFirebaseUser(User user) {
    return user != null ? UserModel(uid: user.uid) : null;
  }

  Stream<UserModel> get user {
    return _auth.authStateChanges().map(_userFromFirebaseUser);
  }

  // Future signInAnon() async {
  //   try {
  //     UserCredential userCredential = await _auth.signInAnonymously();
  //     User user = userCredential.user;
  //     return user;
  //   } catch (e) {
  //     print(e.toString());
  //     return null;
  //   }
  // }

  Future signInEmail(String email, String password) async {
    try {
      UserCredential user = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return AuthResult(true, null);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        return AuthResult(false, e.code);
      } else if (e.code == 'wrong-password') {
        return AuthResult(false, e.code);
      }
    }
  }

  Future signup(String name, String usn, String branch, int sem, String email,
      String password) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      String uid = userCredential.user.uid;

      await DatabaseService(uid: uid)
          .updateUserData(name, usn, sem, branch, email);

      return AuthResult(true, null);
    } on FirebaseAuthException catch (e) {
      return AuthResult(false, e.code);
    }
  }

  Future signout() async {
    await _auth.signOut();
    return "signout successful";
  }
}
