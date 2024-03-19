import 'package:firebase_2/constant.dart';
import 'package:firebase_2/screen/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class SearchField extends StatelessWidget {
  const SearchField({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kcontentColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: GestureDetector(
        onTap: () {
          // Navigate to the SearchPage when the text field is clicked
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Search_Page()),
          );
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Row(
            children: [
              const Icon(
                Ionicons.search,
                color: Colors.grey,
              ),
              const SizedBox(width: 10),
              Flexible(
                flex: 4,
                child: TextField(
                  onTap: () {
                    // Navigate to the SearchPage when the text field is clicked
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => Search_Page()),
                    );
                  },
                  decoration: InputDecoration(
                    hintText: "Search...",
                    border: InputBorder.none,
                  ),
                ),
              ),
              Container(
                height: 25,
                width: 1.5,
                color: Colors.grey,
              ),
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Search_Page()),
                  );
                },
                icon: const Icon(
                  Ionicons.options_outline,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
