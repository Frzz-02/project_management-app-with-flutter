import 'package:amicons/amicons.dart';
import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:project_management/features/dashboard/presentation/pages/dashboard_page.dart';
import 'package:project_management/features/profile/presentation/pages/profile_page.dart';
import 'package:project_management/features/task/presentation/pages/task_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  static String routeName = '/main';

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final pageController = PageController();
  int index = 0;

  TextStyle btmNavBar = const TextStyle(fontSize: 12, height: 1.7);

  // Helper method to build popup menu items with modern styling

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true, //set ke true untuk menjaga performa

        body: PageView(
          controller: pageController,
          children: [
            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: DashboardPage()
                )
              ),

            Center(
                child: Container(
                  margin: const EdgeInsets.only(bottom: 50),
                  child: TaskPage()
              )
            ),



            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: Text('data'),
              ),
            ),


            Center(
              child: Container(
                margin: const EdgeInsets.only(bottom: 50),
                child: ProfilePage(),
              )
            ),
          ],
        ),

        bottomNavigationBar: CustomNavigationBar(
          iconSize: 20,
          elevation: 10,
          borderRadius: const Radius.circular(10),
          isFloating: true,
          strokeColor: Colors.purple, //efek ketika di klik
          currentIndex: index,
          unSelectedColor: const Color.fromARGB(255, 157, 179, 249),
          selectedColor: Colors.blue,
          onTap: (value) {
            setState(() {
              index = value;
              pageController.animateToPage(
                value,
                duration: const Duration(milliseconds: 300),
                curve: Curves.linear,
              );
            });
          },

          items: [
            CustomNavigationBarItem(
              // icon: Icon(Icons.home),
              icon: Icon(Amicons.iconly_home),
              title: Text(
                'Dashboard',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF415E72),
                  height: 1.7,
                ),
              ),
            ),

            CustomNavigationBarItem(
              // icon: Icon(Icons.home),
              icon: Icon(Amicons.iconly_work),
              badgeCount: 3,
              showBadge: true,
              title: Text(
                'My Task',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF415E72),
                  height: 1.7,
                ),
              ),
            ),

            CustomNavigationBarItem(
              // icon: Icon(Icons.home),
              icon: Icon(Amicons.iconly_time_circle_broken),
              title: Text(
                'History',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF415E72),
                  height: 1.7,
                ),
              ),
            ),

            CustomNavigationBarItem(
              // icon: Icon(Icons.home),
              icon: Icon(Amicons.iconly_profile_broken),
              title: Text(
                'Profile',
                style: TextStyle(
                  fontSize: 12,
                  color: const Color(0xFF415E72),
                  height: 1.7,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
