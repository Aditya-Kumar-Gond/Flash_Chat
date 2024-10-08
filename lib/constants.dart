import 'package:flutter/material.dart';

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintStyle: TextStyle(
    color: Colors.black54
  ),
  hintText: 'Type your message here...',
  enabledBorder: UnderlineInputBorder(
    borderSide: BorderSide(width: 1),
  ),
);

const textfieldDecoration = InputDecoration(
hintText: 'text',
errorText: null,
hintStyle: TextStyle(color: Colors.grey),
contentPadding:
EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
border: OutlineInputBorder(
borderRadius: BorderRadius.all(Radius.circular(32.0)),
),
enabledBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
borderRadius: BorderRadius.all(Radius.circular(32.0)),
),
focusedBorder: OutlineInputBorder(
borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
borderRadius: BorderRadius.all(Radius.circular(32.0)),
)
);


const kMessageContainerDecoration = BoxDecoration(
  color: Colors.white,
  border: Border(
    top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  ),
);
