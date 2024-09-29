import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flash_chat/customButtons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      duration: const Duration(seconds: 1, milliseconds: 5),
      // Use milliseconds instead of microseconds
      vsync: this,
    );
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(
        controller);
    FirebaseAuth auth = FirebaseAuth.instance;
    if (auth.currentUser != null) {
      isLoggedIn = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ifLoggedIn(); // Navigate after the widget is built
      });
    }else {
      controller.forward();
      controller.addListener(() {
        setState(() {});
      });
    }
  }

  void ifLoggedIn(){
    Navigator.pushNamed(context, ChatScreen.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  child: Hero(tag: 'logo', child: Image.asset('images/logo.png')),
                  height: 60,
                ),
                AnimatedTextKit(
                  animatedTexts: [TypewriterAnimatedText(
                    'Flash Chat',
                    textStyle: TextStyle(
                      fontSize: 47.0,
                      color: Colors.black,
                      fontWeight: FontWeight.w900,
                    ),
                    speed: const Duration(milliseconds: 200),
                  ),],
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            CustomButtons(
                colour: Colors.lightBlueAccent,
                label: 'Log In',
                onTap: (){
                  Navigator.pushNamed(context, LoginScreen.id);
                }),
            CustomButtons(
                colour: Colors.blueAccent,
                label: 'Register',
                onTap: (){
                  Navigator.pushNamed(context, RegistrationScreen.id);
                }),
          ],
        ),
      ),
    );
  }
}
