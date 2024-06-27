import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:edu_bee/screens/search_bar/search_result.dart';
import 'package:flutter/material.dart';

class CustomSearchBar extends StatefulWidget {
  final ValueChanged<bool> onSearchActiveChanged;
  final ValueChanged<String> onSearchTextChanged;

  const CustomSearchBar({
    Key? key,
    required this.onSearchActiveChanged,
    required this.onSearchTextChanged,
  }) : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<CustomSearchBar> {
  TextEditingController _searchController = TextEditingController();
  bool _isSearchActive = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      widget.onSearchTextChanged(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearchActive = false;
      widget.onSearchTextChanged("");
      widget.onSearchActiveChanged(false);
    });
  }

  void _onTap() {
    setState(() {
      _isSearchActive = true;
      widget.onSearchActiveChanged(true);
    });
  }

  void _onSubmit(String searchText) {
    if (searchText.isNotEmpty) {
      final processedSearchText = searchText.toLowerCase();
      final firstKeyword = _getFirstKeyword(processedSearchText);
      if (firstKeyword.isNotEmpty) {
        _searchCourses(firstKeyword);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid search query')),
        );
      }
    }
  }

  String _getFirstKeyword(String searchText) {
    return searchText.split(' ').first;
  }

  void _searchCourses(String keyword) {
    FirebaseFirestore.instance
        .collection('courses')
        .snapshots()
        .listen((QuerySnapshot snapshot) {
      final List<DocumentSnapshot> results = [];
      for (final doc in snapshot.docs) {
        final courseKeywords = List<String>.from(doc['searchKeywords']);
        bool found = courseKeywords.any((courseKeyword) => courseKeyword.contains(keyword));
        if (found) {
          results.add(doc);
        }
      }
      if (results.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No results found')),
        );
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => SearchResultsScreen(searchText: keyword),  // Pass the first keyword
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          GestureDetector(
            onTap: _onTap,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF6e5ce0),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                   // Add some space between icon and text
                  Expanded(
                    child: TextField(
                      style: const TextStyle(color: Colors.white),
                      controller: _searchController,
                      decoration: const InputDecoration(
                        hintText: "Countries,Courses,Universities", // Search icon
                  
                        hintStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.w300, fontStyle: FontStyle.italic),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                      ),
                      onSubmitted: _onSubmit,
                    ),
                  ),
                  if (_searchController.text.isNotEmpty)
                    GestureDetector(
                      onTap: () => _onSubmit(_searchController.text),
                      child: const Icon(Icons.search, color: Colors.white),
                    ),
                   
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
