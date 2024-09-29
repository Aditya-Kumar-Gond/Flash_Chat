import 'package:flutter/material.dart';
import 'constants.dart';

class CustomTextfield extends StatelessWidget{
  CustomTextfield({super.key, required this.controller,required this.hint,required this.onChanged,required this.inputType});
  late Function(String)? onChanged;
  final TextEditingController controller;
  final String hint;
  TextInputType inputType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      style: TextStyle(
          color: Colors.black
      ),
      onChanged: onChanged,
      decoration: textfieldDecoration);
  }

}