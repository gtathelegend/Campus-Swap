import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/product_service.dart';
import '../models/models.dart';
import '../data/mock_data.dart' show categories;
import '../theme/app_theme.dart';
import '../widgets/brand_title.dart';
import '../widgets/product_card.dart';
import 'search_screen.dart';
import 'category_screen.dart';
import 'product_detail_screen.dart';
import 'profile_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProducts();
  }

  void _refresh() {
    setState(() {
      _productsFuture = _productService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final userInitial = auth.profile?.name.isNotEmpty == true
        ? auth.profile!.name[0].toUpperCase()
        : '?';

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: RefreshIndicator(
          color: AppColors.gold,
          onRefresh: () async => _refresh(),
          child: CustomScrollView(
            slivers: [
              // Header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const BrandTitle('Campus Swap', logoSize: 30),
                      GestureDetector(
                        onTap: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const ProfileScreen())),
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: auth.profile?.avatarUrl != null
                                ? ClipOval(
                                    child: Image.network(
                                      auth.profile!.avatarUrl!,
                                      width: 40,
                                      height: 40,
                                      fit: BoxFit.cover,
                                      errorBuilder: (_, __, ___) => Text(
                                          userInitial,
                                          style: GoogleFonts.manrope(
                                              fontWeight: FontWeight.w700,
                                              color: AppColors.gold)),
                                    ),
                                  )
                                : Text(userInitial,
                                    style: GoogleFonts.manrope(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.gold)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Search bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: GestureDetector(
                    onTap: () => Navigator.push(context,
                        MaterialPageRoute(builder: (_) => const SearchScreen())),
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.base,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Row(
                        children: [
                          const SizedBox(width: 14),
                          const Icon(Icons.search,
                              color: AppColors.stone, size: 20),
                          const SizedBox(width: 10),
                          Text('Search listings...',
                              style: GoogleFonts.inter(
                                  color: AppColors.stone, fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              // Categories
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 0),
                  child: Text('Categories',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
                sliver: SliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      final cat = categories[i];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) =>
                                    CategoryScreen(category: cat.name))),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 52,
                              height: 52,
                              decoration: BoxDecoration(
                                color: AppColors.base,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Center(
                                  child: Text(cat.emoji,
                                      style: const TextStyle(fontSize: 24))),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              cat.name,
                              style: GoogleFonts.inter(
                                  fontSize: 10, color: AppColors.mocha),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      );
                    },
                    childCount: categories.length,
                  ),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.85,
                  ),
                ),
              ),
              // Products header
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                  child: Text('Recently Listed',
                      style: Theme.of(context).textTheme.titleMedium),
                ),
              ),
              // Products grid
              FutureBuilder<List<Product>>(
                future: _productsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 60),
                        child: Center(
                          child: CircularProgressIndicator(color: AppColors.gold),
                        ),
                      ),
                    );
                  }
                  if (snapshot.hasError) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Column(
                          children: [
                            const Icon(Icons.wifi_off, color: AppColors.stone, size: 48),
                            const SizedBox(height: 12),
                            Text('Failed to load listings',
                                style: Theme.of(context).textTheme.titleMedium),
                            const SizedBox(height: 8),
                            ElevatedButton(
                                onPressed: _refresh,
                                child: const Text('Retry')),
                          ],
                        ),
                      ),
                    );
                  }
                  final products = snapshot.data ?? [];
                  if (products.isEmpty) {
                    return SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.all(40),
                        child: Center(
                          child: Column(
                            children: [
                              const Text('🛍️',
                                  style: TextStyle(fontSize: 48)),
                              const SizedBox(height: 16),
                              Text('No listings yet',
                                  style:
                                      Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 8),
                              Text('Be the first to list an item!',
                                  style:
                                      Theme.of(context).textTheme.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) => ProductCard(
                          product: products[i],
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => ProductDetailScreen(
                                    product: products[i])),
                          ),
                        ),
                        childCount: products.length,
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.75,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
