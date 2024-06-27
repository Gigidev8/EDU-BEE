import 'package:edu_bee/auth_user/user_model.dart';
import 'package:edu_bee/components/cardtile.dart';
import 'package:edu_bee/components/coursolwiget.dart';
import 'package:edu_bee/components/customshimmer.dart';
import 'package:edu_bee/screens/homescreen/dreawer/drawer.dart';
import 'package:edu_bee/screens/homescreen/homewigets/countries/countrieslist.dart';
import 'package:edu_bee/screens/homescreen/homewigets/study_programs/Sprograms.dart';
import 'package:edu_bee/screens/homescreen/homewigets/universities/uni_list.dart';
import 'package:edu_bee/screens/search_bar/search_bar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class Homescreen extends StatefulWidget {
   const Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool _isSearchActive = false;
  String _searchText = "";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate loading delay
    Future.delayed(Duration(seconds: 2), () {
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final userModel = Provider.of<UserModel>(context);

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        drawer: CustomDrawer(userModel: userModel), // Use the custom drawer here
        body: _isLoading ? buildShimmer() : _buildContent(userModel),
      ),
    );
  }

  Widget _buildDrawer(UserModel userModel) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          CustomDrawer(userModel: userModel)
        ],
      ),
    );
  }

 Widget _buildContent(UserModel userModel) {
  return SingleChildScrollView(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 18, vertical: 10),
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  return GestureDetector(
                    onTap: () {
                      Scaffold.of(context).openDrawer();
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                        child: Icon(
                          Icons.list_rounded,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              ),
              Expanded(child: customSearchBar()),
            ],
          ),
        ),
        const SizedBox(height: 1),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Trending Courses",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ),
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: CarouselContainer(),
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CountriesList()),
                    );
                  },
                  child: const Cardtile(
                    imagePath: "assets/images/countries.png",
                    cardtext: "Countries",
                  ),
                ),
              ),
              const SizedBox(width: 10), // Adjust spacing as needed
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => UniListScreen()),
                    );
                  },
                  child: const Cardtile(
                    imagePath: "assets/images/university.png",
                    cardtext: "Universities",
                  ),
                ),
              ),
            ],
          ),
          
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Study Programs",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),  // Ensure color is set to white here
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Studyprogramslistscreen()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Container(
              height: 180,
              width: 360,
              decoration: BoxDecoration(
                color: Colors.amberAccent,
                borderRadius: BorderRadius.circular(20),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  'assets/images/courses.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}

 
  CustomSearchBar customSearchBar() {
    return CustomSearchBar(
      onSearchActiveChanged: (isActive) {
        setState(() {
          _isSearchActive = isActive;
        });
      },
      onSearchTextChanged: (text) {
        setState(() {
          _searchText = text;
        });
      },
    );
  }

  Widget buildShimmer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Row(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.grey[300],
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 120,
                    height: 20,
                    color: Colors.grey[300],
                  ),
                ),
                Spacer(), // Spacer added here to push the IconButton to the right
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    width: 40,
                    height: 40,
                    color: Colors.grey[300],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          CustomSearchBarShimmer(),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Trending Courses",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 180,
                width: 360,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () {},
                    child: Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Study Programs",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
            child: Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.grey[100]!,
              child: Container(
                height: 180,
                width: 360,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}