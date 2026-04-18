import 'package:flutter/material.dart';
import '../services/product_service.dart';
import '../models/models.dart';
import '../data/mock_data.dart' show categories;
import '../theme/app_theme.dart';
import '../widgets/brand_title.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatefulWidget {
  final String category;

  const CategoryScreen({super.key, required this.category});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture =
        _productService.getProductsByCategory(widget.category);
  }

  @override
  Widget build(BuildContext context) {
    final emoji = categories
        .firstWhere((c) => c.name == widget.category,
            orElse: () => categories.first)
        .emoji;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: BrandTitle('$emoji  ${widget.category}'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      color: AppColors.stone, size: 48),
                  const SizedBox(height: 16),
                  Text('Failed to load listings',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _productsFuture = _productService
                          .getProductsByCategory(widget.category);
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(emoji, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 16),
                  Text('No listings in this category',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text('Check back soon!',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(20),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.75,
            ),
            itemCount: items.length,
            itemBuilder: (context, i) => ProductCard(
              product: items[i],
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          ProductDetailScreen(product: items[i]))),
            ),
          );
        },
      ),
    );
  }
}
