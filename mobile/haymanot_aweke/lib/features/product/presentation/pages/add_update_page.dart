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
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late TextEditingController _priceController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product?.name ?? '');
    _descriptionController = TextEditingController(
      text: widget.product?.description ?? '',
    );
    _priceController = TextEditingController(
      text: widget.product?.price.toString() ?? '',
    );
    _imageUrlController = TextEditingController(
      text: widget.product?.imageUrl ?? '',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final product = Product(
        id: widget.product?.id ?? '',
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0,
        imageUrl: _imageUrlController.text.trim(),
      );

      final bloc = context.read<ProductBloc>();

      if (widget.isEditing) {
        bloc.add(UpdateProductEvent(product));
      } else {
        bloc.add(CreateProductEvent(product));
      }
    }
  }

  void _deleteProduct(BuildContext context, String productId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Delete Product'),
            content: const Text(
              'Are you sure you want to delete this product?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<ProductBloc>().add(DeleteProductEvent(productId));
      context.read<ProductBloc>().add(LoadAllProductEvent());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductBloc, ProductState>(
      listener: (context, state) {
        if (state is ErrorState) {
          Navigator.of(context).pop(); // close loading
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.message)));
        }

        if (state is LoadedAllProductState) {
          Navigator.of(context).pushNamedAndRemoveUntil(
            '/', 
            (route) => false,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.isEditing ? 'Edit Product' : 'Add Product'),
          actions: [
            if (widget.isEditing)
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _deleteProduct(context, widget.product!.id),
              ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Product Name'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Enter name' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter description'
                              : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: const InputDecoration(labelText: 'Price'),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value == null || double.tryParse(value) == null
                              ? 'Enter valid price'
                              : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageUrlController,
                  decoration: const InputDecoration(labelText: 'Image URL'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty
                              ? 'Enter image URL'
                              : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: Text(
                    widget.isEditing ? 'Update Product' : 'Add Product',
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
