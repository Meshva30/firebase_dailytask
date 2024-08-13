import 'package:chat_app/firebase_services/google_services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserServices {
  static UserServices userServices = UserServices._();

  UserServices._();

  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  void addUser(String email) {
    CollectionReference userCollection = firestore.collection("User");

    userCollection.add({
      'Name': 'Meshva',
      'Email': email,
      'Phone': '9313220217',
    });

    User? user = GoogleSignInServices.googleSignInServices.currentUser();
    // Use the `user` object if needed, such as storing user details in Firestore.
  }

  Stream<QuerySnapshot> getUser() {
    CollectionReference userCollection = firestore.collection("User");
    return userCollection.snapshots();
  }
}
