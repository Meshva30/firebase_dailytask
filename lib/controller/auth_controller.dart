import 'package:chat_app/firebase_services/auth_services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../firebase_services/google_services.dart';
import '../screen/homescreen.dart';

class AuthController extends GetxController {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();
  TextEditingController txtname = TextEditingController();
  TextEditingController txtphone = TextEditingController();
  TextEditingController txtmessage = TextEditingController();
  TextEditingController txtedit = TextEditingController();

  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString url = ''.obs;
  RxString receiveremail = ''.obs;
  RxString receivername = ''.obs;


  @override
  void onInit() {

    super.onInit();
    UserDetails();
  }
  void getreceiver(String email,String name) {
    receiveremail.value = email;
    receivername.value = name;
  }

  void UserDetails() {
    User? user = GoogleSignInServices.googleSignInServices.currentUser();
    if (user != null) {
      email.value = user.email!;
      name.value = user.displayName ?? 'No Name';
      url.value = user.photoURL ?? '';

    }
  }

  Future<void> Signup(String email, String password) async {
    try {
      bool emails = await AuthServices.authServices.CheckEmail(email);
      if (emails) {
        Get.snackbar(
          'Sign Up Failed',
          'Email already in use. Please use a different email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        await AuthServices.authServices.CreateAccount(email, password);
        Get.snackbar(
          'Sign Up',
          'Sign Up Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Sign Up Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signIn(String email, String password) async {
    try {
      User? user = await AuthServices.authServices.Signin(email, password);
      if (user != null) {
        Get.to(HomeScreen());
        UserDetails();
      } else {
        Get.snackbar(
          'Login Failed',
          'Incorrect email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Login Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void emailLogOut() {
    AuthServices.authServices.signout();
    GoogleSignInServices.googleSignInServices.emailLogOut();
  }
}
