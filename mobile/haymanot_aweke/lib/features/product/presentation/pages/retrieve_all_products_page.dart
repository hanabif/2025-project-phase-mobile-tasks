import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/product_bloc.dart';
import '../widgets/loading_dialog.dart';
import '../widgets/message.dart';
import '../widgets/product_card.dart';

class RetrieveAllProductsPage extends StatelessWidget {
  const RetrieveAllProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Trigger initial load
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
      context.read<ProductBloc>().add(const LoadAllProductEvent());
    });

    return Scaffold(
      body: Column(
        children: [
          // Custom Header
          Container(
            padding: const EdgeInsets.all(16.0),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hello, Yohannes',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    Text(
                      'August 06, 2025', 
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.notifications),
                  onPressed: () {
                    Navigator.pushNamed(context, '/search');
                  },
                ),
              ],
            ),
          ),
          // Section Title
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Available Products',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Icon(Icons.search, color: Colors.grey),
              ],
            ),
          ),
          // Product List
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                
                if (state is LoadingState) {
                  return const LoadingDialog();
                } else if (state is LoadedAllProductState) {
                  if (state.products.isEmpty) {
                    return const Center(child: Text('No products found.'));
                  }
                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: state.products.length,
                    itemBuilder: (context, index) {
                      final product = state.products[index];
                      
                      return ProductCard(
                        product: product,
                        onTap: () async {
                          final result = await Navigator.pushNamed(
                            context,
                            '/details',
                            arguments: product,
                          );
                          if (result == true) {
                            context.read<ProductBloc>().add(LoadAllProductEvent());
                          }
                        },
                      );
                    },
                  );
                } else if (state is ErrorState) {
                  return Message(message: state.message);
                }
                return const Message(message: 'Start by loading products');
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async{
          final result = await Navigator.pushNamed(context, '/add');
          if (result ==  true){
            context.read<ProductBloc>().add(LoadAllProductEvent());
          }
        },
        child: const Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
      ),
    );
  }
}