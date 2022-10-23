import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:your_choices/view_model/bottom_nav_view_model/bottom_nav_bar_view_model.dart';

class BottomNavBarView extends StatefulWidget {
  const BottomNavBarView({super.key});

  @override
  State<BottomNavBarView> createState() => _BottomNavBarViewState();
}

class _BottomNavBarViewState extends State<BottomNavBarView> {
  @override
  Widget build(BuildContext context) {
    var provider = Provider.of<BottomNavBarViewModel>(context);
    return Scaffold(
      body: SafeArea(
        child: Consumer<BottomNavBarViewModel>(
          builder: (context, value, child) {
            return value.views[value.currentIndex];
          },
        ),
      ),
      bottomNavigationBar: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30.0),
          topRight: Radius.circular(30.0),
        ),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: provider.currentIndex,
          selectedItemColor: const Color(0xFFFF9C29),
          unselectedItemColor: Colors.grey,
          onTap: (index) {
            setState(() {
              provider.currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant),
              label: "Restaurant",
            ),
          ],
        ),
      ),
    );
  }
}
