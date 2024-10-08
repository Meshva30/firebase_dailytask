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
        title: Obx(() => Text(controller.receivername.value)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream: ChatServices.chatServices.getchat(
                    GoogleSignInServices.googleSignInServices
                        .currentUser()!
                        .email!,
                    controller.receiveremail.value),
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
                  List chatid = Querydata.map(
                    (e) => e.id,
                  ).toList();

                  print('-----------$chatid----------------');
                  List chats = Querydata.map(
                    (e) => e.data(),
                  ).toList();

                  List<Chat> chatlist = [];

                  for (var chat in chats) {
                    chatlist.add(Chat.fromMap(chat));
                  }

                  return Column(
                    children: List.generate(
                      chatlist.length,
                      (index) => Align(
                        alignment: (chatlist[index].sender ==
                                GoogleSignInServices.googleSignInServices
                                    .currentUser()!
                                    .email
                            ? Alignment.centerRight
                            : Alignment.centerLeft),
                        child: Container(
                          child: GestureDetector(
                            onLongPress: () {
                              controller.txtedit = TextEditingController(
                                  text: chatlist[index].message);
                              if (chatlist[index].sender ==
                                  GoogleSignInServices.googleSignInServices
                                      .currentUser()!
                                      .email)
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: Text('edit'),
                                      content: TextField(
                                        controller: controller.txtedit,
                                      ),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              ChatServices.chatServices
                                                  .updateChat(
                                                      chatid: chatid[index],
                                                      sender: controller
                                                          .email.value,
                                                      receiver: controller
                                                          .receiveremail.value,
                                                      message: controller
                                                          .txtedit.text);
                                              Get.back();
                                            },
                                            child: Text('Edit')),
                                        TextButton(
                                            onPressed: () {
                                              ChatServices.chatServices
                                                  .deleteChat(
                                                chatid: chatid[index],
                                                sender: controller.email.value,
                                                receiver: controller
                                                    .receiveremail.value,
                                              );
                                              Get.back();
                                            },
                                            child: Text('Detele'))
                                      ],
                                    );
                                  },
                                );
                            },
                            child: Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  chatlist[index].message!,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
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
                        'receiver': controller.receiveremail.value,
                        'message': controller.txtmessage.text,
                        'timestamp': DateTime.now(),
                      };

                      ChatServices.chatServices.insertchat(
                          chatdata,
                          GoogleSignInServices.googleSignInServices
                              .currentUser()!
                              .email!,
                          controller.receiveremail.value);
                      controller.txtmessage.clear();
                    },
                    icon: Icon(Icons.send),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
