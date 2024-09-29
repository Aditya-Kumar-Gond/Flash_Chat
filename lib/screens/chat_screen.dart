import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flash_chat/screens/login_screen.dart';
import 'package:flash_chat/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  User? loggedInUser;
  String? userEmail;
  TextEditingController msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      User? user = auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        userEmail = user.email;
        print('Logged in user: ${loggedInUser!.email}');
        print('Logged in userID: ${loggedInUser!.uid}');
      } else {
        print('No user is logged in.');
      }
    } catch (e) {
      print(e);
    }
  }

  void getMessage() async {
    var messages = await firestore.collection("Data").get();
    for (var msg in messages.docs) {
      print(msg.data());
    }
  }

  void streamMessage() async {
    await for (var snapshot in firestore.collection("Data").snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                auth.signOut();
                Navigator.pushNamed(context, WelcomeScreen.id);
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      backgroundColor: Color(0xffF1F3F7),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: StreamBuilder(
                    stream: firestore.collection("Data").orderBy('Timestamp').snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: Colors.blue,
                          ),
                        );
                      }
                      List<TextBubble> messageWidgets = [];
                      var messages = snapshot.data!.docs.reversed;
                      for (var msg in messages) {
                        String senderName = msg.get('Sender');
                        String senderMsg = msg.get('Message');
                        bool isMe = loggedInUser!.email == senderName;
                        var textData = TextBubble(
                          textMsg: senderMsg,
                          sender: senderName,
                          isByMe: isMe,
                        );
                        messageWidgets.add(textData);
                      }
                      return ListView(
                        reverse: true,
                        children: messageWidgets,
                      );
                    }),
              ),
            ),
            Container(
              padding: const EdgeInsets.only(top: 8,left: 8,right: 8,bottom: 0),
              decoration: kMessageContainerDecoration,
              child: Material(
                
                borderRadius: BorderRadius.circular(30),
                color: Color(0xffF1F3F7),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: TextField(
                        controller: msgController,
                        style: const TextStyle(
                          color: Colors.black,
                        ),
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        String textMsg = msgController.text;
                        if (textMsg.isNotEmpty) {
                          sendMsg(textMsg);
                          msgController.clear();
                        }
                      },
                      child: Text(
                        'Send',
                        style: kSendButtonTextStyle,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void sendMsg(String msg) async {
    try {
      var collection = firestore.collection("Data");

      // Get current user's UID or email
      var currentUser = auth.currentUser;
      if (currentUser != null) {
        await collection.add({
          "Message": msg,
          "Sender": currentUser.email,
          "Timestamp": FieldValue.serverTimestamp(),
        });
      } else {
        print("No user is logged in");
      }
    } catch (e) {
      print(e);
    }
  }
}

class TextBubble extends StatelessWidget {
  final String textMsg;
  final String sender;
  final bool isByMe;
  TextBubble({required this.textMsg, required this.sender, required this.isByMe});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      child: Column(
        crossAxisAlignment: isByMe ? CrossAxisAlignment.end :CrossAxisAlignment.start,
        children: [
          Text(
            isByMe ? "Me" : sender,
            style: TextStyle(color: Colors.black, fontSize: 12),
          ),
          Material(
            color: isByMe ? Colors.lightBlue : Colors.white,
            borderRadius: BorderRadius.only(topLeft: isByMe ? Radius.circular(30) : Radius.circular(0), bottomLeft:  Radius.circular(30),bottomRight:  Radius.circular(30),topRight: isByMe ? Radius.circular(0) : Radius.circular(30)),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                textMsg,
                style: TextStyle(color: isByMe ? Colors.white : Colors.black, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
