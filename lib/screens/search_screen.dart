import 'dart:async';
import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
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
  final _productService = ProductService();
  String _query = '';
  String? _activeCategory;
  String? _activeCondition;
  double _maxPrice = 5000;

  List<Product> _results = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _search();
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String v) {
    setState(() => _query = v);
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), _search);
  }

  Future<void> _search() async {
    setState(() => _isLoading = true);
    try {
      final results = await _productService.searchProducts(
        query: _query,
        category: _activeCategory,
        condition: _activeCondition,
        maxPrice: _maxPrice < 5000 ? _maxPrice : null,
      );
      if (mounted) setState(() => _results = results);
    } catch (_) {
      if (mounted) setState(() => _results = []);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasFilters = _activeCategory != null || _activeCondition != null;
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
                      autofocus: true,
                      decoration: const InputDecoration(
                        hintText: 'Search listings...',
                        prefixIcon:
                            Icon(Icons.search, color: AppColors.stone, size: 20),
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                      onChanged: _onQueryChanged,
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () async {
                      final result =
                          await Navigator.push<Map<String, dynamic>>(
                        context,
                        MaterialPageRoute(
                            builder: (_) => FiltersScreen(
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
                        _search();
                      }
                    },
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color:
                            hasFilters ? AppColors.gold : AppColors.base,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Icon(Icons.tune,
                          color: hasFilters
                              ? AppColors.espresso
                              : AppColors.stone,
                          size: 20),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _isLoading
                    ? null
                    : Text(
                        '${_results.length} result${_results.length == 1 ? '' : 's'}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
              ),
            ),
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: AppColors.gold))
                  : _results.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('🔍',
                                  style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 16),
                              Text('No results found',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text(
                                  _query.isEmpty
                                      ? 'Start typing to search'
                                      : 'Try different keywords',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        )
                      : GridView.builder(
                          padding:
                              const EdgeInsets.fromLTRB(20, 0, 20, 100),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: _results.length,
                          itemBuilder: (context, i) => ProductCard(
                            product: _results[i],
                            onTap: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (_) =>
                                        ProductDetailScreen(product: _results[i]))),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
