import 'package:fruit_market/main.dart';

class AuthService {
  Future<bool> register(String email, String pass) async {
    try {
      await cloud.auth.signUp(password: pass, email: email);
      return true;
    } catch (e) {
      print("Register Error: $e");
      return false;
    }
  }

  Future<bool> signIn(String email, String pass) async {
    try {
      await cloud.auth.signInWithPassword(email: email, password: pass);
      return true;
    } catch (e) {
      print("SignIn Error: $e");
      return false;
    }
  }

  Future<bool> signOut() async {
    try {
      await cloud.auth.signOut();
      return true;
    } catch (e) {
      print("SignOut Error: $e");
      return false;
    }
  }
}
