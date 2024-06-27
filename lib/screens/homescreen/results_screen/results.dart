import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/components/customresult.dart';
import 'package:edu_bee/screens/homescreen/applyscreen/applyscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Resultsscreen extends StatefulWidget {
  final String universityName;
  final String courseName;
  final String courseType;

  const Resultsscreen({
    Key? key,
    required this.universityName,
    required this.courseName,
    required this.courseType,
  }) : super(key: key);

  @override
  _ResultsscreenState createState() => _ResultsscreenState();
}

class _ResultsscreenState extends State<Resultsscreen> {
  late User user;
  late bool isFavorite = false; // Track if the course is a favorite

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    fetchFavoriteStatus();
  }

  Future<void> fetchFavoriteStatus() async {
    final userEmail = user.email!;
    final userDoc =
        FirebaseFirestore.instance.collection('users_data').doc(userEmail);

    final docSnapshot = await userDoc.get();

    if (docSnapshot.exists) {
      final favorites = docSnapshot.data()?['favorites'] ?? [];
      setState(() {
        isFavorite = favorites.any((fav) =>
            fav['university'] == widget.universityName &&
            fav['courseName'] == widget.courseName &&
            fav['courseType'] == widget.courseType);
      });
    }
  }

  Future<void> updateFavoriteStatus(bool newIsFavorite) async {
    setState(() {
      isFavorite = newIsFavorite;
    });

    final userDoc =
        FirebaseFirestore.instance.collection('users_data').doc(user.email);

    if (newIsFavorite) {
      await userDoc.set({
        'favorites': FieldValue.arrayUnion([
          {
            'university': widget.universityName,
            'courseName': widget.courseName,
            'courseType': widget.courseType,
          }
        ])
      }, SetOptions(merge: true));
    } else {
      await userDoc.update({
        'favorites': FieldValue.arrayRemove([
          {
            'university': widget.universityName,
            'courseName': widget.courseName,
            'courseType': widget.courseType,
          }
        ])
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('courses')
              .where('university', isEqualTo: widget.universityName)
              .where('courseName', isEqualTo: widget.courseName)
              .where('courseType', isEqualTo: widget.courseType)
              .get(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
              return Center(child: Text('No course details found.'));
            }

            final courseData =
                snapshot.data!.docs.first.data() as Map<String, dynamic>;
            final detailsText = courseData['courseDetails'];

            return SingleChildScrollView(
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  CustomresultCardWidget(
                    onFavoritePressed: updateFavoriteStatus,
                    funcopy: () {
                      final textToCopy =
                          'University: ${widget.universityName}\nCourse: ${widget.courseName}\nType: ${widget.courseType}\nDetails: $detailsText';
                      Clipboard.setData(ClipboardData(text: textToCopy));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Details copied to clipboard')),
                      );
                    },
                    Header: widget.universityName,
                    header2: widget.courseName,
                    titletext: widget.courseType,
                    detailsText: detailsText,
                    icon: Icons.arrow_circle_right_outlined,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Applyscreen(
                            universityName: widget.universityName,
                            courseName: widget.courseName,
                            courseType: widget.courseType,
                            detailsText: detailsText,
                          ),
                        ),
                      );
                    },
                    isFavorite: isFavorite,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
