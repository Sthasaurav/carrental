class Category {
  final String title;
  final String image;

  Category({
    required this.title,
    required this.image,
  });
}

final List<Category> categories = [
  Category(title: "Hyundai", image: "assets/hyundai.png"),
  Category(title: "Honda", image: "assets/honda.png"),
  Category(title: "Toyota", image: "assets/toyota.png"),
  Category(title: "Nissan", image: "assets/nissan.png"),
  Category(title: "volkswagen", image: "assets/volkswagen.png"),
  Category(title: "BMW", image: "assets/bmw.png"),
  Category(title: "Ford", image: "assets/ford.png"),
  Category(title: "Renault", image: "assets/renault.png"),
];
