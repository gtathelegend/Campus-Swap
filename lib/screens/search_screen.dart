import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import '../models/models.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'filters_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String _query = '';
  String? _activeCategory;
  String? _activeCondition;
  double _maxPrice = 5000;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Product> get _filtered {
    return products.where((p) {
      final matchQuery = _query.isEmpty || p.name.toLowerCase().contains(_query.toLowerCase()) || p.category.toLowerCase().contains(_query.toLowerCase());
      final matchCategory = _activeCategory == null || p.category == _activeCategory;
      final matchCondition = _activeCondition == null || p.condition == _activeCondition;
      final matchPrice = p.price <= _maxPrice;
      return matchQuery && matchCategory && matchCondition && matchPrice;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final results = _filtered;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      autofocus: false,
                      decoration: const InputDecoration(
                        hintText: 'Search listings...',
                        prefixIcon: Icon(Icons.search, color: AppColors.stone, size: 20),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: (v) => setState(() => _query = v),
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(builder: (_) => FiltersScreen(
                          activeCategory: _activeCategory,
                          activeCondition: _activeCondition,
                          maxPrice: _maxPrice,
                        )),
                      );
                      if (result != null) {
                        setState(() {
                          _activeCategory = result['category'];
                          _activeCondition = result['condition'];
                          _maxPrice = result['maxPrice'] ?? 5000;
                        });
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (_activeCategory != null || _activeCondition != null) ? AppColors.gold : AppColors.base,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.tune, color: (_activeCategory != null || _activeCondition != null) ? AppColors.espresso : AppColors.stone, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('${results.length} result${results.length == 1 ? '' : 's'}', style: Theme.of(context).textTheme.bodySmall),
              ),
            ),
            Expanded(
              child: results.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('🔍', style: TextStyle(fontSize: 48)),
                          const SizedBox(height: 16),
                          Text('No results found', style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          Text('Try different keywords', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: results.length,
                      itemBuilder: (context, i) => ProductCard(
                        product: results[i],
                        onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: results[i]))),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
