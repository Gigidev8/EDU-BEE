import 'package:flutter/material.dart';

class CustomresultCardWidget extends StatefulWidget {
  final String Header;
  final String header2;
  final String titletext;
  final String detailsText;
  final IconData icon;
  final VoidCallback onPressed;
  final VoidCallback funcopy;
  final ValueChanged<bool> onFavoritePressed;
  final bool isFavorite; // Add isFavorite parameter

  const CustomresultCardWidget({
    Key? key,
    required this.Header,
    required this.header2,
    required this.titletext,
    required this.detailsText,
    required this.icon,
    required this.onPressed,
    required this.funcopy,
    required this.onFavoritePressed,
    required this.isFavorite, // Initialize isFavorite parameter
  }) : super(key: key);

  @override
  _CustomresultCardWidgetState createState() => _CustomresultCardWidgetState();
}

class _CustomresultCardWidgetState extends State<CustomresultCardWidget> {
  late bool isCurrentlyFavorite; // Track local state of isFavorite

  @override
  void initState() {
    super.initState();
    isCurrentlyFavorite = widget.isFavorite; // Initialize local state from widget parameter
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.black,
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        widget.Header,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: widget.funcopy,
                      icon: Icon(Icons.copy, color: Colors.blue),
                    ),
                  ],
                ),
                SizedBox(height: 2),
                Text(
                  widget.header2,
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  widget.titletext,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Divider(),
                SizedBox(height: 5),
                Text(
                  widget.detailsText,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: 100), // Add more space to avoid overlap with the button
              ],
            ),
            Positioned(
              bottom: 16,
              left: 16,
              child: IconButton(
                onPressed: () {
                  setState(() {
                    isCurrentlyFavorite = !isCurrentlyFavorite;
                  });
                  widget.onFavoritePressed(isCurrentlyFavorite);
                },
                icon: Icon(
                  isCurrentlyFavorite ? Icons.favorite : Icons.favorite_border,
                  color: isCurrentlyFavorite ? Colors.red : Colors.white,
                ),
              ),
            ),
            Positioned(
              bottom: 16,
              right: 16,
              child: TextButton.icon(
                onPressed: widget.onPressed,
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                icon: Icon(widget.icon, color: Colors.white),
                label: Text('Apply Now', style: TextStyle(color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
