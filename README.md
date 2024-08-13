
# Sign In & Sign Up with Email & Password with Google Authentication

Certainly! Here's a concise breakdown of how to implement the login and sign-up app using GetX state management and Google email ID sign-in, without including the full screen code:

### **1. Project Setup**
- **Add Dependencies**:
  In your `pubspec.yaml`, include the necessary dependencies:
  ```yaml
  cupertino_icons: ^1.0.6
  firebase_core: ^3.3.0
  get: any
  firebase_auth: any
  google_sign_in: any
  fluttertoast: ^8.2.6
  sign_in_button: ^3.2.0
  ```

- **Initialize Firebase**:
  In your `main.dart`, initialize Firebase before running the app:
  ```dart
  void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp();
    runApp(MyApp());
  }
  ```

### **2. Authentication Logic with GetX**

- **Create an Authentication Controller**:
  Manage authentication logic and state using GetX by creating a `auth_controller.dart`:
  ```dart
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

  RxString email = ''.obs;
  RxString name = ''.obs;
  RxString url = ''.obs;

  @override
  void onInit() {
    super.onInit();
    try {
      UserDetails();
    } catch (e) {
      print('Error initializing user details: $e');
    }
  }



  void UserDetails(){
    User? user = GoogleSignInServices.googleSignInServices.currentUser();
    if (user != null) {
      email.value = user.email!;
      url.value = user.photoURL!;
      name.value = user.displayName!;
    }
  }

  Future<void> Signup(String email, String password) async {
    try {
      bool emails = await AuthServices.authServices.CheckEmail(email);
      if (emails) {
        Get.snackbar('Sign Up Failed',
          'Email already in use. Please use a different email.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );

      }
      else{
        await AuthServices.authServices.CreateAccount(email, password);
        Get.snackbar('Sign Up', 'Sign Up Successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }

    }catch(e)
    {
      Get.snackbar('Sign Up Failed',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  Future<void>signIn(String email,String password)
  async {
    try{
      User? user = await AuthServices.authServices.Signin(email, password);
      if(user!=null)
        {
          Get.to(HomeScreen());
        }
      else{
        Get.snackbar('Login Failed', 'Incorrect email or password.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    }catch(e){
      Get.snackbar('Login Failed', e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  void emailLogOut(){
    AuthServices.authServices.signout();
    GoogleSignInServices.googleSignInServices.emailLogOut();
  }
  }

 
  ```



### **4. Firebase Authentication Integration**

- **Email/Password Sign-Up**:
  Use Firebase's `createUserWithEmailAndPassword` method in the `register` function of the `AuthController`.

- **Email/Password Login**:
  Implement the login functionality using `signInWithEmailAndPassword` in the `login` function.

- **Google Sign-In**:
  Integrate Google Sign-In by using the `google_sign_in` package and handle the sign-in process in the `googleSignIn` function.

### **5. UI Flow (Summary)**
- **Login Screen**:
  - Users can enter their email and password to log in.
  - Option to sign in with Google.

- **Sign-Up Screen**:
  - Users can create an account with email and password.

- **Home Screen**:
  - Displays after a successful login/sign-up.

### **6. Running the App**
- With everything set up, use `flutter run` to start the app, allowing users to register, log in, and authenticate via Google.

This structure outlines the core components and flow without delving into specific UI implementations, focusing instead on the underlying logic and setup. If you need more details on any specific part, let me know!

### ScreenShorts
<p align='center'>
  <img src='https://github.com/user-attachments/assets/3597aa2e-944a-42ff-8711-90bdd5327523' width=240>
  <img src='https://github.com/user-attachments/assets/537f8a4e-1730-4548-94d0-74fc99417535' width=240>
  <img src='https://github.com/user-attachments/assets/11908310-99ef-476c-99b3-16ed060139fc' width=240>
  <img src='https://github.com/user-attachments/assets/4240b257-1e94-456d-b208-8f37df816c70' width=240>
</p>

### Video
https://github.com/user-attachments/assets/947f40ce-537c-4a56-a252-3a3032af1ba6

![Screenshot 2024-08-12 131055](https://github.com/user-attachments/assets/1b8260e9-8f1c-4712-b222-f9d55449a67c)


