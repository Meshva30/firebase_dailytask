import 'package:chat_app/screen/signin.dart';
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
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Obx(
                () => CircleAvatar(
                  radius: 70,
                  backgroundImage: controller.url.value.isNotEmpty
                      ? NetworkImage(controller.url.value)
                      : const AssetImage('')

                ),
              ),
            ),
            Obx(() => Text(controller.email.value.isNotEmpty
                ? controller.email.value
                : 'No email')),
            Obx(() => Text(controller.name.value.isNotEmpty
                ? controller.name.value
                : 'No name')),
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
              Get.off(
                  () => Authscreen());
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: const Center(
        child: Text('Welcome! You are logged in.'),
      ),
    );
  }
}
