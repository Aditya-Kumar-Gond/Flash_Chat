import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController pwdController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: showSpinner ? const CircularProgressIndicator() :
            Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              SizedBox(
                height: 200.0,
                child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.black
                  ),
                  decoration: textfieldDecoration.copyWith(hintText: 'Enter your email')),
              const SizedBox(
                height: 10.0,
              ),
              TextField(
                  controller: pwdController,
                  keyboardType: TextInputType.visiblePassword,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  decoration: textfieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: const BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      setState(() {
                        showSpinner = true;
                      });
                      String email = emailController.text.toString();
                      String pwd = pwdController.text.toString();
                      loginUser(email,pwd);
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> loginUser(String email, String pwd) async {
    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pwd,
      );
      print("User logged in: ${credential.user?.email}");
      showSpinner = false;
      Navigator.pushNamed(context, ChatScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
      } else if (e.code == 'user-disabled') {
        print('This user has been disabled.');
      } else {
        print('Something went wrong: ${e.message}');
      }
    } catch (e) {
      print('An unknown error occurred: $e');
    }
  }
}
