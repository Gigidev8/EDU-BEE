import 'package:flutter/material.dart';

class Borderbutton extends StatelessWidget {
  final String inputtext;
  final Color bcolor; // Background color of the button
  final Color tcolor; // Text color of the button
  final VoidCallback function; // Function to be executed on tap

  const Borderbutton({
    Key? key,
    required this.inputtext,
    required this.bcolor,
    required this.tcolor,
    required this.function,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: function,
      child: Container(
        width: 320.0,
        height: 60.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bcolor,
          borderRadius: BorderRadius.all(Radius.circular(30.0)),
        ),
        child: Text(
          inputtext,
          style: TextStyle(
            color: tcolor,
            fontSize: 20.0,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
