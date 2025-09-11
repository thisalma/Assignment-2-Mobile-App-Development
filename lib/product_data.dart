class Product {
  final String name;
  final String image;
  final double price;
  final String description; // new
  int quantity;

  Product({
    required this.name,
    required this.image,
    required this.price,
    required this.description,
    this.quantity = 1,
  });
}

List<Product> productList = [
  Product(
    name: 'Simply Granola',
    price: 1600.0,
    image: 'assets/images/quaker_simplygranola_oatshoneyalmonds_320x400_3.png',
    description: 'Healthy granola with oats, honey, and almonds.',
  ),
  Product(
    name: 'Fruit Juice 1L',
    price: 1000.0,
    image: 'assets/images/icon-512-512-true-044ccd0386cefdf25c1b5c549ed2c990.png',
    description: 'Refreshing 1L fruit juice to energize your day.',
  ),
  Product(
    name: 'Pizza',
    price: 1400.0,
    image: 'assets/images/pizza_PNG44077.png',
    description: 'Delicious cheesy pizza with fresh toppings.',
  ),
  Product(
    name: 'Cadbury Hot Chocolate',
    price: 1000.0,
    image: 'assets/images/vecteezy_ai-generated-hot-chocolate-drink-in-a-mug_31112850.png',
    description: 'Warm and cozy Cadbury hot chocolate.',
  ),
  Product(
    name: 'Ramen Noodles',
    price: 1500.0,
    image: 'assets/images/png-clipart-instant-noodle-ramen-korean-cuisine-shin-ramyun-nongshim-chinese-noodles-soup-food.png',
    description: 'Quick and tasty ramen noodles.',
  ),
  Product(
    name: 'Cadbury Dairy Milk',
    price: 1200.0,
    image: 'assets/images/cadbury-dairy-milk-chocolate-bar-yd73712s82pgjpg8-yd73712s82pgjpg8.png',
    description: 'Smooth and creamy chocolate bar.',
  ),
];
