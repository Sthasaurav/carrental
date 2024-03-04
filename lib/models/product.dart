import 'package:flutter/material.dart';

class Product {
  final String title;
  final String description;
  final String image;
  final dynamic price;
  final List<Color> colors;
  final String category;
  final double rate;
  final String vehicletype;
  final dynamic numberOfPeople;

  Product({
    required this.title,
    required this.description,
    required this.image,
    required this.price,
    required this.colors,
    required this.category,
    required this.rate,
    required this.vehicletype,
    required this.numberOfPeople,
  });
}

final List<Product> products = [
  Product(
    title: "Volkswagen",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/golf.png",
    price: "5000/Day",
    colors: [],
    category: "Golf",
    vehicletype: "automatic",
    numberOfPeople: '5 Seats',
    rate: 4.8,
  ),
  Product(
    title: "Ford",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/v-2.png",
    price: "3500/Day",
    colors: [
      // Colors.brown,
      // Colors.red,
      // Colors.pink,
    ],
    vehicletype: "manual",
    numberOfPeople: '4 Seats',
    category: " Sedan ",
    rate: 4.8,
  ),
  Product(
    title: " Hyundai",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/i30n.png",
    price: "4500/Day",
    colors: [
      // Colors.black,
    ],
    vehicletype: "automatic",
    numberOfPeople: '4 Seats',
    category: "HatchBack-Automatic",
    rate: 3.8,
  ),
  Product(
    title: " Toyota",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/yaris.png",
    price: "4200/Day",
    colors: [
      // Colors.black,
    ],
    vehicletype: "manual",
    numberOfPeople: '5 Seats',
    category: "Hatch Back",
    rate: 4.5,
  ),
  Product(
    title: " Renault",
    description:
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Donec massa sapien faucibus et molestie ac feugiat. In massa tempor nec feugiat nisl. Libero id faucibus nisl tincidunt.",
    image: "assets/v-3.png",
    price: "5000/Day",
    colors: [
      // Colors.black,
    ],
    vehicletype: "manual",
    numberOfPeople: '5 Seats',
    category: "CUV",
    rate: 4.3,
  ),
];
