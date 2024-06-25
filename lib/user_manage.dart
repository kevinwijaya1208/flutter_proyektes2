import 'package:firebase_auth/firebase_auth.dart';

class UserManager {
  static User? currentUser;

  static void updateUser(User? user) {
    currentUser = user;
  }

  static User? getUser() {
    return currentUser;
  }
}
