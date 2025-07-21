class Product {
  static const defaultSizes = [39, 40, 41, 42, 43];

  final String id;
  final String title;
  final String category;
  final double price;
  final String imageUrl;
  final List<int> sizes;
  final String description;

  Product({
    String? id,
    required this.title,
    required this.category,
    required this.price,
    required this.imageUrl,
    this.sizes = defaultSizes,
    required this.description,
  }) : id = id ?? DateTime.now().millisecondsSinceEpoch.toString();
}
