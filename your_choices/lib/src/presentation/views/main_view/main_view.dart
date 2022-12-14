import 'package:flutter/material.dart';
import 'package:your_choices/src/presentation/views/favorite_view/favorite_view.dart';
import 'package:your_choices/src/presentation/views/notification_view/notification_view.dart';
import 'package:your_choices/src/presentation/views/profile_view/profile_view.dart';
import 'package:your_choices/src/presentation/views/restaurant_view/restaurant_list_view/restaurant_list_view.dart';
import 'package:your_choices/utilities/text_style.dart';

import '../home_view/transaction_view/transaction_view.dart';

class MainView extends StatefulWidget {
  final String uid;
  const MainView({super.key, required this.uid});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int currentIndex = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int index) {
    pageController.jumpToPage(index);
  }

  void onPageChanged(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: PageView(
          controller: pageController,
          onPageChanged: onPageChanged,
          children: [
            TransactionView(uid: widget.uid),
             RestaurantView(uid: widget.uid),
             FavoriteView(uid: widget.uid),
             NotificationView(uid: widget.uid),
             ProfileView(uid: widget.uid),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.shifting,
          currentIndex: currentIndex,
          selectedItemColor: const Color(0xFFFF9C29),
          selectedIconTheme:
              IconTheme.of(context).copyWith(color: const Color(0xFFFF9C29)),
          selectedLabelStyle:
              AppTextStyle.googleFont(Colors.black, 16, FontWeight.normal),
          unselectedItemColor: Colors.grey,
          unselectedIconTheme:
              IconTheme.of(context).copyWith(color: Colors.grey),
          onTap: navigationTapped,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_sharp),
              label: "Home",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.restaurant_menu_sharp),
              label: "Restaurant",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_sharp),
              label: "Favorite",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications_sharp),
              label: "Notification",
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_sharp),
              label: "Profile",
            ),
          ],
        ),
      ),
    );
  }
  // else {
  //   return Center(
  //     child: ElevatedButton(
  //       onPressed: () {
  //         context.read<AuthCubit>().loggingOut();
  //       },
  //       child: const Text("Sign Out"),
  //     ),
  //   );
  // }
}
