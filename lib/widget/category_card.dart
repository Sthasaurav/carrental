import 'package:flutter/material.dart';

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final IconData iconData;

  const CategoryCard({
    Key? key,
    required this.categoryName,
    required this.iconData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 120,
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(iconData, size: 40),
          SizedBox(height: 8),
          Text(categoryName),
        ],
      ),
    );
  }
}
