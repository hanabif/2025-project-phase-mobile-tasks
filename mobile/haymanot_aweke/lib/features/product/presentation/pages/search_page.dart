import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  final List<Product> searchResults;
  const SearchPage({super.key, required this.searchResults});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();
  double _priceValue = 100; // default max price

  late List<Product> filteredResults;

  @override
  void initState() {
    super.initState();
    filteredResults = widget.searchResults;
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();

    setState(() {
      filteredResults = widget.searchResults.where((product) {
        final matchesQuery =
            query.isEmpty || product.name.toLowerCase().contains(query);
        final matchesPrice = product.price <= _priceValue;
        return matchesQuery && matchesPrice;
      }).toList();
    });
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
      );

  Widget _buildSearchField() {
    return TextField(
      controller: searchController,
      onChanged: (_) => applyFilters(),
      decoration: InputDecoration(
        hintText: "Leather",
        contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        suffixIcon: IconButton(
          onPressed: applyFilters,
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF3D4CE0)),
        ),
      ),
    );
  }

  Widget _buildProductList() {
    return Expanded(
      child: ListView.builder(
        itemCount: filteredResults.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ProductCard(product: filteredResults[index]),
          );
        },
      ),
    );
  }

  Widget _buildBottomFilterPanel() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 21),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 4)),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 38),
            _buildLabel("Price"),
            const SizedBox(height: 12),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                activeTrackColor: const Color(0xFF3D4CE0),
                inactiveTrackColor: const Color(0xFFD9D9D9),
                thumbColor: const Color(0xFF3D4CE0),
              ),
              child: Slider(
                value: _priceValue,
                min: 0,
                max: 1000, // adjust max price as needed
                onChanged: (value) {
                  setState(() => _priceValue = value);
                  applyFilters();
                },
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D4CE0),
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  "APPLY",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios),
                      ),
                      const Text(
                        "Search Product",
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(child: _buildSearchField()),
                      const SizedBox(width: 7),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D4CE0),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  _buildProductList(),
                ],
              ),
            ),
            _buildBottomFilterPanel(),
          ],
        ),
      ),
    );
  }
}
