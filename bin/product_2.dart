import 'dart:io';

class Product {
  String name;
  String description;
  double price;

  Product(this.name, this.description, this.price);

  @override
  String toString() {
    return 'Name: $name\nDescription: $description\nPrice: \$${price.toStringAsFixed(2)}';
  }
}

class ProductManager {
  final List<Product> _products = [];

  void addProduct() {
    stdout.write('Enter product name: ');
    String name = stdin.readLineSync()!;
    stdout.write('Enter product description: ');
    String description = stdin.readLineSync()!;
    stdout.write('Enter product price: ');
    double price = double.parse(stdin.readLineSync()!);

    _products.add(Product(name, description, price));
    print('\nProduct added successfully.\n');
  }

  void viewAllProducts() {
    if (_products.isEmpty) {
      print('\nNo products available.\n');
      return;
    }
    print('\nProduct List:');
    for (int i = 0; i < _products.length; i++) {
      print('\nProduct ID: $i');
      print(_products[i]);
    }
  }

  void viewProduct() {
    stdout.write('Enter product ID to view: ');
    int id = int.parse(stdin.readLineSync()!);
    if (_isValidId(id)) {
      print('\nProduct Details:');
      print(_products[id]);
    } else {
      print('\nInvalid product ID.\n');
    }
  }

  void editProduct() {
    stdout.write('Enter product ID to edit: ');
    int id = int.parse(stdin.readLineSync()!);
    if (_isValidId(id)) {
      stdout.write('Enter new name: ');
      _products[id].name = stdin.readLineSync()!;
      stdout.write('Enter new description: ');
      _products[id].description = stdin.readLineSync()!;
      stdout.write('Enter new price: ');
      _products[id].price = double.parse(stdin.readLineSync()!);
      print('\nProduct updated successfully.\n');
    } else {
      print('\nInvalid product ID.\n');
    }
  }

  void deleteProduct() {
    stdout.write('Enter product ID to delete: ');
    int id = int.parse(stdin.readLineSync()!);
    if (_isValidId(id)) {
      _products.removeAt(id);
      print('\nProduct deleted successfully.\n');
    } else {
      print('\nInvalid product ID.\n');
    }
  }

  bool _isValidId(int id) {
    return id >= 0 && id < _products.length;
  }
}

void main() {
  ProductManager manager = ProductManager();
  while (true) {
    print('''
Simple eCommerce App
=====================
1. Add Product
2. View All Products
3. View Product by ID
4. Edit Product
5. Delete Product
6. Exit
''');
    stdout.write('Choose an option: ');
    String choice = stdin.readLineSync()!;
    switch (choice) {
      case '1':
        manager.addProduct();
        break;
      case '2':
        manager.viewAllProducts();
        break;
      case '3':
        manager.viewProduct();
        break;
      case '4':
        manager.editProduct();
        break;
      case '5':
        manager.deleteProduct();
        break;
      case '6':
        print('Exiting the app. Goodbye.');
        return;
      default:
        print('Invalid option. Please try again.');
    }
  }
}
