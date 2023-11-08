import 'package:flutter/material.dart';
import 'package:flutter_demo/pages/dashboard/widgets/favorites_fragment.dart';
import 'package:flutter_demo/pages/dashboard/widgets/home_fragment.dart';
import 'package:flutter_demo/pages/dashboard/widgets/profile_fragment.dart';

///
/// Created by Auro on 08/11/23 at 9:43 PM
///

class DashboardPage extends StatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  int currentIndex = 0;
  PageController pageController = PageController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        physics: NeverScrollableScrollPhysics(),
        children: const [
          HomeFragment(),
          FavoritesFragment(),
          ProfileFragment(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white.withOpacity(0.4),
        elevation: 10,
        currentIndex: currentIndex,
        onTap: (v) {
          setState(() {
            currentIndex = v;
          });
          pageController.animateToPage(
            v,
            curve: Curves.bounceIn,
            duration: const Duration(milliseconds: 300),
          );
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Home",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: "Favorites",
            backgroundColor: Colors.blue,
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
            backgroundColor: Colors.blue,
          ),
        ],
      ),
    );
  }
}
