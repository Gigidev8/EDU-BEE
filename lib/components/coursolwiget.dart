import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/screens/homescreen/results_screen/results.dart';
import 'package:flutter/material.dart';

class CarouselContainer extends StatefulWidget {
  @override
  _CarouselContainerState createState() => _CarouselContainerState();
}

class _CarouselContainerState extends State<CarouselContainer> {
  List<Map<String, String>> _courses = [];
  int _currentPage = 0;
  late PageController _pageController;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _fetchCourses();
    _pageController = PageController(initialPage: _currentPage);
    _startTimer(); // Start the timer when the widget is initialized
  }

  @override
  void dispose() {
    _pageController.dispose();
    _timer.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  Future<void> _fetchCourses() async {
    final QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('trending_courses').get();
    final List<Map<String, String>> courses = querySnapshot.docs.map((doc) {
      return {
        'imageUrl': doc['imageUrl'] as String,
        'courseName': doc['course'] as String,
        'courseType': doc['courseType'] as String,
        'university': doc['university'] as String,
      };
    }).toList();
    setState(() {
      _courses = courses;
    });
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      setState(() {
        _currentPage = (_currentPage + 1) % _courses.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          setState(() {
            _currentPage = (_currentPage + 1) % _courses.length;
            _pageController.nextPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        } else if (details.primaryVelocity! > 0) {
          setState(() {
            _currentPage = (_currentPage - 1 + _courses.length) % _courses.length;
            _pageController.previousPage(
                duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
          });
        }
      },
      child: Column(
        children: [
          Container(
            height: 180,
            width: 360,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: PageView.builder(
                controller: _pageController,
                itemCount: _courses.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                itemBuilder: (context, index) {
                  final course = _courses[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Resultsscreen(
                            courseType: course['courseType']!,
                            courseName: course['courseName']!,
                            universityName: course['university']!,
                          ),
                        ),
                      );
                    },
                    child: Image.network(
                      course['imageUrl']!,
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _courses.length,
              (index) => Container(
                margin: EdgeInsets.symmetric(horizontal: 5),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _currentPage == index ? Colors.blue : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
