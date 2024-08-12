import 'package:chat_app/controller/auth_controller.dart';
import 'package:chat_app/firebase_services/google_services.dart';
import 'package:chat_app/screen/signin.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'homescreen.dart';

class Signup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var controller = AuthController();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Sign up",
            style: TextStyle(
                fontSize: 30, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          Text(
            "see your growth and get consulting suppor!",
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: GestureDetector(
              onTap: () async {
                String status = await GoogleSignInServices.googleSignInServices
                    .signWithGoogle();
                Fluttertoast.showToast(msg: status);
                if (status == 'Success') {
                  Get.to(const HomeScreen());
                  controller.UserDetails();
                }
              },
              child: Container(
                height: 50,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(color: Colors.grey, width: 2)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("assets/google.png"),
                    Text(
                      "Sign up with Google",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          TextField(
            controller: controller.txtemail,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Name',
              hintText: 'Name',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey)),
              labelStyle: TextStyle(color: Colors.white),
              helperStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.txtemail,
            style: TextStyle(color: Colors.white),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              labelText: 'Email',
              hintText: 'abc@email.com',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey)),
              labelStyle: TextStyle(color: Colors.white),
              helperStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 20),
          TextField(
            controller: controller.txtpassword,
            style: TextStyle(color: Colors.white),
            obscureText: true,
            keyboardType: TextInputType.number,
            obscuringCharacter: '*',
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              hintText: 'min.8 character',
              hintStyle: TextStyle(color: Colors.white),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(color: Colors.grey)),
              suffixIcon: Icon(
                Icons.remove_red_eye,
                color: Colors.grey,
              ),
              labelText: 'Password',
              labelStyle: TextStyle(color: Colors.white),
            ),
          ),
          SizedBox(height: 50),
          InkWell(
            onTap: () {
              controller.Signup(
                  controller.txtemail.text, controller.txtpassword.text);
            },
            child: Container(
              margin: EdgeInsets.all(10),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                  child: Text("Signup",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.w500))),
            ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account?",
                style: TextStyle(color: Colors.grey),
              ),
              TextButton(
                onPressed: () {
                  Get.to(() => Authscreen());
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Color(0xFF40744D)),
                ),
              ),
            ],
          ),
        ]),
      ),
    );
  }
}
