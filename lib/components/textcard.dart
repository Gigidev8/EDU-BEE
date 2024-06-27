import 'package:flutter/material.dart';

class CustomtextCardWidget extends StatelessWidget {
  final String text;
  final String belowtext;
  final IconData icon;
  final VoidCallback onPressed;

  const CustomtextCardWidget({
    Key? key,
    required this.text,
    required this.icon,
    required this.onPressed,
    required this.belowtext,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: 21,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2,),
            Text(
              belowtext,
              style: TextStyle(
                color: Colors.blue,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end, // Align the button to the right
              children: [
                FloatingActionButton(
                  heroTag: 'btn-${UniqueKey()}', // Add unique heroTag
                  onPressed: onPressed,
                  backgroundColor: Colors.blue,
                  child: const Icon(Icons.arrow_forward),
                  mini: true,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)), // Make the button round
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
