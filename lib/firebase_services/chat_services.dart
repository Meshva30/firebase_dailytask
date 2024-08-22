import 'package:cloud_firestore/cloud_firestore.dart';

class ChatServices {
  static ChatServices chatServices = ChatServices._();

  ChatServices._();

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> insertchat(Map<String, dynamic> chat) async {
   await firestore.collection("Chatroom").add(chat);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> getchat() {
    return firestore.collection("Chatroom").snapshots();
  }
}
