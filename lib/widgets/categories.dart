import 'package:flutter/material.dart';
import 'package:shop_example/models/category.dart';
import 'package:shop_example/models/product.dart';
import 'package:shop_example/screens/categories_screen.dart';

class Categories extends StatelessWidget {
  final List<Product> products;

  const Categories({Key? key, required this.products}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CategoriesScreen(
                products: products), // Navigate to CategoriesScreen
          ),
        );
      },
      child: SizedBox(
        height: 90,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
            return Column(
              children: [
                Container(
                  height: 60,
                  width: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(
                        categories[index].image,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  categories[index].title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
          separatorBuilder: (context, index) => const SizedBox(width: 20),
          itemCount: categories.length,
        ),
      ),
    );
  }
}
