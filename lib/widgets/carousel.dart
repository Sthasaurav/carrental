import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  Carousel({super.key});
  final List<String> imageUrl = [
    "asset/images/15%discount.jpg",
    "asset/images/carpenter.jpg",
    "asset/images/water.jpg",
    "asset/images/clean.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [],
      ),
    );
  }

  Widget carousel(context) {
    return CarouselSlider(
      options: CarouselOptions(
        autoPlay: true,
        height: MediaQuery.of(context).size.height * 0.2,
        scrollDirection: Axis.horizontal,
        enlargeCenterPage: true,
        autoPlayCurve: Curves.fastLinearToSlowEaseIn,
        enableInfiniteScroll: true,
      ),
      items: imageUrl.map(
        (imageurls) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                width: MediaQuery.of(context).size.width,
                //  margin: EdgeInsets.symmetric(horizontal: 5.0),

                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    imageurls,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ).toList(),
    );
  }
}
