import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Add User
  Future<void> addUser(String username, String email, String password) async {
    try {
      await users.add({
        'username': username,
        'email': email,
        'password': password,
      });
    } catch (e) {
      throw Exception('Failed to sign up: $e');
    }
  }

  // Sign In User
  Future<Map<String, dynamic>> signInUser(String email, String password) async {
    try {
      var userQuery = await users.where('email', isEqualTo: email).get();

      if (userQuery.docs.isEmpty) {
        throw Exception('No user found with this email');
      }

      var userData = userQuery.docs.first.data() as Map<String, dynamic>;
      if (userData['password'] == password) {
        return userData;
      } else {
        throw Exception('Incorrect password');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
