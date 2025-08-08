import 'package:flutter/material.dart';
import '../../domain/entities/product.dart';
import '../widgets/product_card.dart';

class SearchPage extends StatefulWidget {
  final List<Product> searchResults;
  const SearchPage({super.key, required this.searchResults});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController searchController = TextEditingController();
  double _priceValue = 1000; // default max price

  late List<Product> filteredResults;

  bool _showFilterPanel = false;
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    filteredResults = widget.searchResults;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    searchController.addListener(() {
      applyFilters();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    searchController.dispose();
    super.dispose();
  }

  void toggleFilterPanel() {
    setState(() {
      _showFilterPanel = !_showFilterPanel;
      if (_showFilterPanel) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void applyFilters() {
    final query = searchController.text.toLowerCase();
    print('searching...');
    setState(() {
      filteredResults =
          widget.searchResults.where((product) {
            final matchesQuery =
                query.isEmpty || product.name.toLowerCase().contains(query);
            final matchesPrice = product.price <= _priceValue;
            return matchesQuery && matchesPrice;
          }).toList();
      print('Filtered products count: ${filteredResults.length}');
    });
  }

  Widget _buildFilterButton() {
    return GestureDetector(
      onTap: toggleFilterPanel,
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: const Color(0xFF3D4CE0),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.filter_alt_outlined, color: Colors.white),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
    text,
    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
  );

  Widget _buildSearchField() {
    return TextField(
      onSubmitted: (_) {
        applyFilters();
      },
      controller: searchController,
      onChanged: (_) => applyFilters(),
      decoration: InputDecoration(
        hintText: "Leather",
        contentPadding: const EdgeInsets.symmetric(vertical: 9, horizontal: 16),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        suffixIcon: IconButton(
          onPressed: applyFilters,
          icon: const Icon(Icons.arrow_forward, color: Color(0xFF3D4CE0)),
        ),
      ),
    );
  }

  Widget _buildBottomFilterPanel() {
    return SlideTransition(
      position: _slideAnimation,
      child: Container(
        height: 190,
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 21),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40),
            topRight: Radius.circular(40),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
                onPressed: () {
                  toggleFilterPanel();
                  applyFilters();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D4CE0),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 12,
                  ),
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
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Row(
                    children: [
                      Expanded(child: _buildSearchField()),
                      const SizedBox(width: 7),
                      _buildFilterButton(),
                    ],
                  ),
                  const SizedBox(height: 36),
                  Expanded(
                    child: ListView.builder(
                      itemCount: filteredResults.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ProductCard(product: filteredResults[index]),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            if (_showFilterPanel)
              Positioned(
                right: 0,
                left: 0,
                bottom: 0,
                child: _buildBottomFilterPanel(),
              ),
          ],
        ),
      ),
    );
  }
}
