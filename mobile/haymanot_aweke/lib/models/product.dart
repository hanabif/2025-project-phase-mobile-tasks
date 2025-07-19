class Product {
  static const defaultSizes = [39, 40, 41, 42, 43];

  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final List<int> sizes;
  final String description;

  Product({
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.sizes = defaultSizes,
    required this.description,
  });
}
