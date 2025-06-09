class Product {
  final String name;
  final String image;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    this.quantity = 1,
  });
}

List<Product> productList = [
  Product(
    name: 'Simply Granola',
    price: 1600.0,
    image: 'assets/images/quaker_simplygranola_oatshoneyalmonds_320x400_3.png',
  ),
  Product(
    name: 'Fruit Juice 1L',
    price: 1000.0,
    image: 'assets/images/icon-512-512-true-044ccd0386cefdf25c1b5c549ed2c990.png',
  ),
  Product(
    name: 'Pizza',
    price: 1400.0,
    image: 'assets/images/pizza_PNG44077.png',
  ),
  Product(
    name: 'Cadbury Hot Chocolate',
    price: 1000.0,
    image: 'assets/images/vecteezy_ai-generated-hot-chocolate-drink-in-a-mug_31112850.png',
  ),
Product(
    name: 'Ramen Noodles',
    price: 1500.0,
    image: 'assets/images/png-clipart-instant-noodle-ramen-korean-cuisine-shin-ramyun-nongshim-chinese-noodles-soup-food.png',
  ),
Product(
    name: 'Cadbury dairy milk',
    price: 1200.0,
    image: 'assets/images/cadbury-dairy-milk-chocolate-bar-yd73712s82pgjpg8-yd73712s82pgjpg8.png',
  ),

];
