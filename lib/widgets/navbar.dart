// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
// import 'package:firebase/util/string_const.dart';
// import 'package:firebase_2/util/string_const.dart';
// //import 'package:firebase/view/editprofile1.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase/view/dashboard.dart';
// import 'package:firebase/view/mainUI.dart';
// import 'package:firebase/view/profile.dart';

// class Navbar extends StatefulWidget {
//   Navbar({Key? key}) : super(key: key);

//   @override
//   _NavbarState createState() => _NavbarState();
// }

// class _NavbarState extends State<Navbar> {
//   GlobalKey<CurvedNavigationBarState> _bottomNavigationKey = GlobalKey();

//   int _selectedPage = 0;
//   final List<Widget> _pageOptions = [
//     MainScreen(),
//     ProfilePage(),
//     MainUi(),
//    // EditProfilePage1(user: user),
//   ];
  
//   static get user => null;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pageOptions[_selectedPage],
      
//       bottomNavigationBar: CurvedNavigationBar(
//         key: _bottomNavigationKey,
//         index: _selectedPage,
//         animationCurve: Curves.easeInOutBack,
//         backgroundColor: colorstr,
//        // color: Colors.black,
                                             
//         buttonBackgroundColor:  Colors.lightGreen[200],
//         items: [
//         //  BottomNavigationBarItem(icon: Icons.abc),
//           Icon(Icons.home,size: 30, color: colorstr,),
//           Icon(Icons.person, size: 30,color: colorstr),
//           Icon(Icons.list, size: 30,color: colorstr),
//         ],
//         onTap: (index) {
//           setState(() {
//             _selectedPage = index;
//           });
//         },
//       ),
//     );
//   }

// }
