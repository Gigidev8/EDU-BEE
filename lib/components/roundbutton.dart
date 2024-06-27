import 'package:flutter/material.dart';

class Roundbutton extends StatelessWidget {
  final GestureTapCallback tap;
  final IconData icon;
  final Color color;
  final Color? iconColor;
  final Color backgroundcolor;
  final double size; // Add size property

  const Roundbutton({
    Key? key,
    required this.tap,
    required this.icon,
    required this.color,
    required this.backgroundcolor,
    required this.size, // Include size in the constructor
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: tap,
      icon: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundcolor,
        ),
        padding: EdgeInsets.all(size * 0.1), // Adjust padding based on size
        child: Icon(
          icon,
          color: iconColor ?? Colors.white,
          size: size * 0.5, // Adjust icon size based on size
        ),
      ),
      color: color,
      iconSize: size * 0.5, // Adjust IconButton size based on size
      alignment: Alignment.center,
    );
  }
}
