import 'package:firebase_auth/firebase_auth.dart';

class Emailpassword{

  final _auth = FirebaseAuth.instance;

  Future<User?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      return credential.user; // Returns the user object if successful
    } on FirebaseAuthException catch (e) {
      // Handles specific Firebase errors, such as email already in use
      if (e.code == 'email-already-in-use') {
        throw Exception("The email is already in use. Please try another email to login.");
      } else {
        throw Exception(e.message ?? "An error occurred");
      }
    } catch (e) {
      // Handles general errors
      throw Exception("Error: $e");
    }
  }

  // Method to log in an existing user using email and password
  Future<User?> loginUserWithEmailAndPassword(String email, String password) async {
    try {
      // Logs in the user with Firebase Authentication
      final credential = await _auth.signInWithEmailAndPassword(email: email, password: password);
      return credential.user; // Returns the logged-in user object
    } catch (e) {
      // Prints error message if login fails
      print("Error $e");
      return null; // Returns null if login fails
    }
  }
}