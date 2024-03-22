import 'package:firebase_2/screen/allproduct.dart';
import 'package:firebase_2/view/profile1.dart';
import 'package:flutter/material.dart';
import 'package:firebase_2/constant.dart';
import 'package:firebase_2/screen/home_screen.dart';
import 'package:iconsax/iconsax.dart';
import 'package:ionicons/ionicons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentTab = 2; // Set the default tab index

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            currentTab = 2;
          });
        },
        shape: const CircleBorder(),
        backgroundColor: kprimaryColor,
        child: const Icon(
          Iconsax.home,
          color: Colors.white,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        elevation: 0,
        height: 70,
        color: Colors.white,
        shape: const CircularNotchedRectangle(),
        notchMargin: 5,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: () => setState(() {
                currentTab = 0;
              }),
              icon: Icon(
                Ionicons.grid_outline,
                color: currentTab == 0 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
            SizedBox(width: 48), // Empty SizedBox as a placeholder
            SizedBox(width: 48), // Empty SizedBox as a placeholder
            IconButton(
              onPressed: () => setState(() {
                currentTab = 4;
              }),
              icon: Icon(
                Ionicons.person_outline,
                color: currentTab == 4 ? kprimaryColor : Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      body: IndexedStack(
        index: currentTab, // Set the index of the displayed screen
        children: [
          AllProductPage(), // Placeholder for tab 0
          Scaffold(), // Placeholder for tab 1
          HomeScreen(), // HomeScreen for tab 2
          Scaffold(), // Placeholder for tab 3
          ProfileUd(), // ProfileUd for tab 4
        ],
      ),
    );
  }
}
