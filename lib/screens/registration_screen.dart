import 'package:flutter/material.dart';
import 'package:flash_chat/customTextfield.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late TextEditingController emailController = TextEditingController();
  late TextEditingController pwdController = TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;


  String? email;
  String? pwd;
  bool validateEmail = false;
  bool validatePwd = false;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: isLoading ? const CircularProgressIndicator() :
          Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(
                      color: Colors.black
                  ),
                  textAlign: TextAlign.center,
                  decoration: textfieldDecoration.copyWith(hintText: 'Enter your email',errorText: validateEmail ? 'email can\'t be empty' : null)),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  controller: pwdController,
                  keyboardType: TextInputType.visiblePassword,
                  style: TextStyle(
                    color: Colors.black
                  ),
                  decoration: textfieldDecoration.copyWith(hintText: 'Enter your password',errorText: validatePwd ? 'password can\'t be empty' : null),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () {
                      email = emailController.text;
                      pwd = pwdController.text;
                      print('email : $email \n password : $pwd');
                      setState(() {
                          emailController.text.isEmpty ? validateEmail = true : validateEmail = false;
                          pwdController.text.isEmpty ? validatePwd = true : validatePwd = false;
                          isLoading = true;
                      });
                      if(email != null && pwd != null) {
                        registerUser(email!, pwd!);
                        print('registered user called');

                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
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


  Future<void> registerUser(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      print("User registered: ${userCredential.user?.email}");
      Navigator.pushNamed(context, ChatScreen.id);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
      } else if (e.code == 'invalid-email') {
        print('The email address is badly formatted.');
      } else {
        print(e.message);
      }
    } catch (e) {
      print(e.toString());
    }
  }


}



