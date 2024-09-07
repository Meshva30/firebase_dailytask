import 'package:chat_app/firebase_services/google_services.dart';
import 'package:chat_app/firebase_services/notification_services.dart';
import 'package:chat_app/firebase_services/user_services.dart';
import 'package:chat_app/screen/chat_screen.dart';
import 'package:chat_app/screen/signin.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../controller/auth_controller.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    AuthController controller = Get.put(AuthController());

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // NotificationServices.notificationServices.showNotification();
          NotificationServices.notificationServices.showScheduleNotification();
        },

      ),
      drawer: Drawer(
        child: FutureBuilder(
          future: UserServices.userServices.getcurrentuser(
            GoogleSignInServices.googleSignInServices.currentUser()!,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text('Loading');
            }

            Map<String, dynamic> currentuser =
                snapshot.data?.data() as Map<String, dynamic>;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage: NetworkImage(currentuser['photourl']),
                  ),
                ),
                Text(currentuser['name']),
                Text(currentuser['email']),
                Text(currentuser['phone'] ?? "No Phone"),
              ],
            );
          },
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Home Screen'),
        actions: [
          IconButton(
            onPressed: () {
              controller.emailLogOut();
              Fluttertoast.showToast(
                msg: "Logged out successfully",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0,
              );
              Get.off(() => Authscreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder(
                stream:
                    UserServices.userServices.getUser(controller.email.value),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  if (snapshot.hasData) {
                    List userlist =
                        snapshot.data!.docs.map((e) => e.data()).toList();

                    return ListView.builder(
                      itemCount: userlist.length,
                      itemBuilder: (context, index) {
                        var user = userlist[index];

                        return GestureDetector(
                          onTap: () {
                            controller.getreceiver(userlist[index]['email'],
                                (userlist[index]['name']));
                            Get.to(ChatScreen());
                          },
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(user['photourl']),
                            ),
                            title: Text(user['name'] ?? 'No Name'),
                            subtitle: Text(
                              '${user['email'] ?? 'No Email'} \n ${user['phone'] ?? 'No Phone'}',
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: Text('No users found.'),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
