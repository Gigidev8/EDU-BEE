import 'package:flutter/material.dart';

class Cardtile extends StatelessWidget {
  final String imagePath;
  final String   cardtext;

  const Cardtile({Key? key, required this.imagePath,required this.cardtext}) : super(key: key);

 @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16.0), // Circular border
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover, // Ensure image fills the container
        ),
      ),
      child: Stack(
        children: [
          // Optional: Add a subtle shadow for a more elevated look
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1), // Adjust opacity for desired effect
                    blurRadius: 4.0, // Adjust blur radius for desired softness
                    spreadRadius: 2.0, // Adjust spread radius for shadow size
                  ),
                ],
              ),
            ),
          ),
          // Text container with rounded corners and black background
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.all(4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0), // Circular background
                color: Colors.black.withOpacity(0.8), // Adjust opacity for readability
              ),
              child: Text(
                cardtext,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}