// ignore_for_file: unused_local_variable, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebasematerial/model/user_model.dart';

class AuthController {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final CollectionReference usersCollection =
      FirebaseFirestore.instance.collection('users');

  bool get success => false;

  Future<UserModel?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final UserCredential userCredential = await auth
          .signInWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final DocumentSnapshot snapshot =
            await usersCollection.doc(user.uid).get();

        final UserModel currentUser = UserModel(
          name: snapshot['name'] ?? '',
          email: user.email ?? '',
          uId: user.uid,
        );
      }
    } catch (e) {
      print('Error signing in: $e');
    }
    return null;
  }

  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String name) async {
    try {
      final UserCredential userCredential = await auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        final UserModel newUser =
            UserModel(name: name, email: user.email ?? '', uId: user.uid);
        await usersCollection.doc(newUser.uId).set(newUser.toMap());
        return newUser; // Mengembalikan objek UserModel setelah registrasi berhasil
      }
    } catch (e) {
      print('Error registering user: $e');
    }

    return null; // Mengembalikan null jika terjadi kesalahan registrasi
  }

  // UserModel? getCurrentUser() {
  //   final User? user = auth.currentUser;
  //   if (user != null) {
  //     return UserModel.fromFirebaseUser(user);
  //   }
  //   return null;
  // }
  UserModel? getCurrentUser() {
    final User? user = auth.currentUser;
    if (user != null) {
      return UserModel(
        name: '',
        email: user.email ?? '',
        uId: user.uid,
      );
    }
    return null;
  }

  Future<String?> getUserName(String uid) async {
    try {
      final DocumentSnapshot snapshot = await usersCollection.doc(uid).get();
      return snapshot['name'] as String?;
    } catch (e) {
      print('Error getting user name: $e');
      return null;
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}
