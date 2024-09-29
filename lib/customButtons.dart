import 'package:flutter/material.dart';

class CustomButtons extends StatelessWidget{

  CustomButtons({super.key, required this.colour,required this.label,required this.onTap});
  final Color colour;
  final String label;
  late VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: colour,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          minWidth: 200.0,
          height: 42.0,
          child: Text(
            label,
          ),
          onPressed: onTap,
        ),
      ),
    );
  }

}