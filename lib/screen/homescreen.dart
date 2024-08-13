import 'package:chat_app/firebase_services/user_services.dart';
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
          UserServices.userServices.addUser(controller.txtemail.text);
        },
        child: Icon(Icons.add),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Obx(
                () => CircleAvatar(
                  radius: 70,
                  backgroundImage: NetworkImage(controller.url.value),
                ),
              ),
            ),
            Obx(() => Text(controller.email.value)),
            Obx(() => Text(controller.name.value)),
          ],
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
                stream: UserServices.userServices.getUser(),
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

                        return ListTile(
                          title: Text(user['Name'] ?? 'No Name'),
                          subtitle: Text(user['Email'] ?? 'No Email'),
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
