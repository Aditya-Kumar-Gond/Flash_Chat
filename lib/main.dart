import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().whenComplete(() {
    print("completed");
  });
  runApp(FlashChat());
  }



class FlashChat extends StatefulWidget {


  @override
  State<FlashChat> createState() => _FlashChatState();
}

class _FlashChatState extends State<FlashChat> {
  bool isLoggedIn = false;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

  }

  void ifLoggedIn() {
    User? user = auth.currentUser;

    if (user != null) {


      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushNamed(context, ChatScreen.id);
        setState(() {
          isLoggedIn = true;
        });
      });

    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme(
        ),
      ),
      initialRoute: isLoggedIn ? ChatScreen.id : WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => WelcomeScreen(),
        LoginScreen.id: (context) => LoginScreen(),
        RegistrationScreen.id: (context) => RegistrationScreen(),
        ChatScreen.id: (context) => ChatScreen(),
      },
    );
  }
}
