import 'package:chat_app/firebase_services/auth_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class AuthController extends GetxController {
  TextEditingController txtemail = TextEditingController();
  TextEditingController txtpassword = TextEditingController();

  void Signup(String email, String password) {
    AuthServices.authServices.CreateAccount(email, password);
  }
}
