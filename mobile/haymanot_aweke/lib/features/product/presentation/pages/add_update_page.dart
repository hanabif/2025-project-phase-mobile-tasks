import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product; // Optional product for update
  const AddUpdatePage({super.key, this.product});

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  late TextEditingController nameController;
  late TextEditingController categoryController;
  late TextEditingController priceController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();

    nameController = TextEditingController();
    categoryController = TextEditingController();
    priceController = TextEditingController();
    descriptionController = TextEditingController();

    // Pre-fill if editing a product
    final product = widget.product;
    if (product != null) {
      nameController.text = product.name;
      categoryController.text = 'Luxury Heels';
      priceController.text = product.price.toString();
      descriptionController.text = product.description;
    }
  }

  void addOrUpdateProduct() {
    final name = nameController.text.trim();
    final category = categoryController.text.trim();
    final priceText = priceController.text.trim();
    final description = descriptionController.text.trim();

    if (name.isEmpty ||
        category.isEmpty ||
        priceText.isEmpty ||
        description.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please fill all fields')));
      return;
    }

    final price = double.tryParse(priceText);
    if (price == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid price')),
      );
      return;
    }

    // Create or update product
    final newProduct = Product(
      id:
          widget.product?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,

      price: price,
      description: description,
      imageUrl: widget.product?.imageUrl ?? 'assets/images/default.jpeg',
    );

    Navigator.pop(context, newProduct); // Return to previous screen
  }

  void clearFields() {
    nameController.clear();
    categoryController.clear();
    priceController.clear();
    descriptionController.clear();
  }

  @override
  void dispose() {
    nameController.dispose();
    categoryController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  Widget buildLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
  );

  Widget buildTextField({
    required TextEditingController controller,
    int maxLines = 1,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(6),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      width: double.infinity,
      height: maxLines > 1 ? 140 : null,
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF3F3F3),
          suffix: suffix,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF3F51F3)),
        ),
        title: const Text("Add Product", textAlign: TextAlign.center),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 23, horizontal: 32),
        child: Column(
          children: [
            // Image upload box (static for now)
            Container(
              height: 190,
              width: 366,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: const Color(0xFFF3F3F3),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/images/carbon_image.png",
                    height: 36,
                    width: 36,
                  ),
                  const SizedBox(height: 26),
                  const Text(
                    "Upload image",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),

            // Name field
            buildLabel("name"),
            const SizedBox(height: 8),
            buildTextField(controller: nameController),
            const SizedBox(height: 16),

            // Category field
            buildLabel("category"),
            const SizedBox(height: 8),
            buildTextField(controller: categoryController),
            const SizedBox(height: 16),

            // Price field
            buildLabel("price"),
            const SizedBox(height: 8),
            buildTextField(
              controller: priceController,
              suffix: const Text(
                "\$",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            const SizedBox(height: 16),

            // Description field
            buildLabel("description"),
            const SizedBox(height: 8),
            buildTextField(controller: descriptionController, maxLines: 10),
            const SizedBox(height: 15),

            // Add button
            SizedBox(
              width: 360,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3F51F3),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 120,
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                onPressed: addOrUpdateProduct,
                child: const Text(
                  "ADD",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Delete button (clears fields)
            SizedBox(
              width: 360,
              child: OutlinedButton(
                onPressed: clearFields,
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.red, width: 1),
                  foregroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "DELETE",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
