import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/firebase_services/chat_services.dart';
import 'package:chat_app/firebase_services/google_services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../model/chat_model.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());
    return Scaffold(
        appBar: AppBar(
          title: Text('Chat'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: ChatServices.chatServices.getchat(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    var Querydata = snapshot.data!.docs;
                    List chats = Querydata.map(
                      (e) => e.data(),
                    ).toList();
                    List<Chat> chatlist =
                        chats.map((e) => Chat.fromMap(e)).toList();
                    return ListView.builder(
                      itemCount: chatlist.length,
                      itemBuilder: (context, index) {
                      return  Text(
                          chatlist[index].message!,

                        );
                      },
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: controller.txtmessage,
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                    suffixIcon: IconButton(
                      onPressed: () {
                        Map<String, dynamic> chatdata = {
                          'sender': GoogleSignInServices.googleSignInServices
                              .currentUser()!
                              .email,
                          'receiver': controller.receiver.value,
                          'message': controller.txtmessage.text,
                          'timestamp': DateTime.now(),
                        };
                        controller.txtmessage.clear();
                        ChatServices.chatServices.insertchat(chatdata);
                      },
                      icon: Icon(Icons.send),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),);
  }
}
