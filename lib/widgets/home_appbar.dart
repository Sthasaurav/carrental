import 'package:firebase_2/constant.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            RichText(
              text: TextSpan(
                text: ' Welcome , ',
                style: TextStyle(
                  fontSize: 26,
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text: "",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: kprimaryColor,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Icon(
                  Icons.waving_hand_outlined,
                  color: Colors.orange[400],
                  size: 20,
                ),
                SizedBox(
                    // width: width(0.02, context),
                    ),
                // Text("${user?.displayName ?? 'User'}", //welcome

                // style: TextStyle(fontSize: 15, color: Colors.white))
              ],
            )
          ],
        ),

        // IconButton(
        //   onPressed: () {},
        //   style: IconButton.styleFrom(
        //     backgroundColor: kcontentColor,
        //     padding: const EdgeInsets.all(15),
        //   ),
        //   iconSize: 30,
        //   icon: const Icon(Ionicons.home_sharp),
        // ),

        IconButton(
          onPressed: () {},
          style: IconButton.styleFrom(
            backgroundColor: kcontentColor,
            padding: const EdgeInsets.all(15),
          ),
          iconSize: 30,
          icon: const Icon(Ionicons.notifications_outline),
        ),
      ],
    );
  }
}
