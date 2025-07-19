import 'dart:io';

class Product {
  String _name;
  String _description;
  double _price;
  bool _available;

  Product(this._name, this._description, this._price, {bool available = true})
    : _available = available;

  String get name => _name;
  String get description => _description;
  double get price => _price;
  bool get available => _available;

  set name(String name) => _name = name;
  set description(String description) => _description = description;
  set price(double price) => _price = price;
  set available(bool value) => _available = value;

  @override
  String toString() {
    return 'Name: $_name\nDescription: $_description\nPrice: \$${_price.toStringAsFixed(2)}\nAvailable: ${_available ? "Yes" : "No"}';
  }
}

class ProductManager {
  final List<Product> _products = [];

  void addProduct() {
    try {
      stdout.write('Enter product name: ');
      String name = stdin.readLineSync()!;
      stdout.write('Enter product description: ');
      String description = stdin.readLineSync()!;
      stdout.write('Enter product price: ');
      double price = double.parse(stdin.readLineSync()!);
      _products.add(Product(name, description, price));
      print('\nProduct added successfully.\n');
    } catch (e) {
      print('Invalid input. Please try again.\n');
    }
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

  void viewCompletedProducts() {
    var availableProducts = _products
        .where((p) => p.available)
        .toList(growable: false);
    if (availableProducts.isEmpty) {
      print('\nNo available (completed) products.\n');
      return;
    }
    for (var p in availableProducts) {
      print('\n$p');
    }
  }

  void viewPendingProducts() {
    var pendingProducts = _products
        .where((p) => !p.available)
        .toList(growable: false);
    if (pendingProducts.isEmpty) {
      print('\nNo pending products.\n');
      return;
    }
    for (var p in pendingProducts) {
      print('\n$p');
    }
  }

  void viewProduct() {
    stdout.write('Enter product ID to view: ');
    int id = int.tryParse(stdin.readLineSync()!) ?? -1;
    if (_isValidId(id)) {
      print('\nProduct Details:');
      print(_products[id]);
    } else {
      print('\nInvalid product ID.\n');
    }
  }

  void editProduct() {
    stdout.write('Enter product ID to edit: ');
    int id = int.tryParse(stdin.readLineSync()!) ?? -1;
    if (_isValidId(id)) {
      stdout.write('Enter new name: ');
      _products[id].name = stdin.readLineSync()!;
      stdout.write('Enter new description: ');
      _products[id].description = stdin.readLineSync()!;
      stdout.write('Enter new price: ');
      _products[id].price = double.parse(stdin.readLineSync()!);
      stdout.write('Is the product available? (yes/no): ');
      String status = stdin.readLineSync()!.toLowerCase();
      _products[id].available = status == 'yes';
      print('\nProduct updated successfully.\n');
    } else {
      print('\nInvalid product ID.\n');
    }
  }

  void deleteProduct() {
    stdout.write('Enter product ID to delete: ');
    int id = int.tryParse(stdin.readLineSync()!) ?? -1;
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
4. View Available Products (Completed)
5. View Unavailable Products (Pending)
6. Edit Product
7. Delete Product
8. Exit
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
        manager.viewCompletedProducts();
        break;
      case '5':
        manager.viewPendingProducts();
        break;
      case '6':
        manager.editProduct();
        break;
      case '7':
        manager.deleteProduct();
        break;
      case '8':
        print('Exiting the app.');
        return;
      default:
        print('Invalid option. Please try again.\n');
    }
  }
}
