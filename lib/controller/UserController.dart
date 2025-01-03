import 'package:flutter/material.dart';
import 'package:travel_lanka/model/UserModel.dart';
import 'package:travel_lanka/view/MainPage.dart';
import 'package:travel_lanka/view/SignInPage.dart';

class UserController {
  final UserModel _userModel = UserModel();

  // Sign up user
  Future<void> signUpUser(BuildContext context, String username, String email, String password) async {
    try {
      await _userModel.addUser(username, email, password);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Sign Up successful!')),
      );

      // Navigate to SignInPage after successful sign up
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SignInPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign up: $e')),
      );
    }
  }

  // Sign in user
  Future<void> signInUser(BuildContext context, String email, String password) async {
    try {
      var userData = await _userModel.signInUser(email, password);
      // Navigate to MainPage
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainPage(email: email, username: userData['username']),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }
}

