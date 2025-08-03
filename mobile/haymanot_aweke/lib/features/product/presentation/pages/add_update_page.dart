import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import '../bloc/product_bloc.dart';
import '../widgets/loading_dialog.dart';

class AddUpdatePage extends StatefulWidget {
  final Product? product;
  final bool isEditing;

  const AddUpdatePage({Key? key, this.product, required this.isEditing})
    : super(key: key);

  @override
  State<AddUpdatePage> createState() => _AddUpdatePageState();
}

class _AddUpdatePageState extends State<AddUpdatePage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _nameController.text = widget.product!.name;
      _priceController.text = widget.product!.price.toString();
      _descriptionController.text = widget.product!.description;
    }
  }

  void _addOrUpdateProduct() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final price = double.tryParse(_priceController.text.trim()) ?? 0;
      final description = _descriptionController.text.trim();

      final newProduct = Product(
        id:
            widget.product?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        price: price,
        description: description,
        imageUrl: widget.product?.imageUrl ?? 'https://example.com/default.jpg',
      );

      if (widget.product == null) {
        context.read<ProductBloc>().add(CreateProductEvent(newProduct));
      } else {
        context.read<ProductBloc>().add(UpdateProductEvent(newProduct));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is LoadingState) {
          LoadingDialog.show(context);
        } else if (state is ErrorState) {
          LoadingDialog.hide(context); // Dismiss loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        } else if (state is LoadedAllProductState) {
          Navigator.popUntil(context, ModalRoute.withName('/'));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.product == null ? 'Add Product' : 'Update Product',
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter product name'
                              : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Enter price' : null,
                ),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 3,
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter description'
                              : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addOrUpdateProduct,
                  child: Text(
                    widget.product == null ? 'Add Product' : 'Update Product',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
