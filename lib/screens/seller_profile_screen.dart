import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/product_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'report_screen.dart';

class SellerProfileScreen extends StatefulWidget {
  final Seller seller;

  const SellerProfileScreen({super.key, required this.seller});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final _productService = ProductService();
  late Future<List<Product>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _productsFuture = _productService.getProductsBySeller(widget.seller.id);
  }

  @override
  Widget build(BuildContext context) {
    final seller = widget.seller;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'report') {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const ReportScreen(type: 'user')));
              }
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'report', child: Text('Report user'))
            ],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                _avatarWidget(seller.avatarUrl, seller.name, size: 80),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(seller.name,
                        style: Theme.of(context).textTheme.titleLarge),
                    if (seller.verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified,
                          size: 18, color: AppColors.gold),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (seller.rating > 0) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star, size: 14, color: AppColors.gold),
                      const SizedBox(width: 4),
                      Text(
                          '${seller.rating.toStringAsFixed(1)} · ${seller.reviews} reviews',
                          style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                ],
                if (seller.bio != null && seller.bio!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      seller.bio!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _stat(context, seller.listings.toString(), 'Listings'),
                _divider(),
                _stat(context, seller.sold.toString(), 'Sold'),
                _divider(),
                _stat(context, seller.reviews.toString(), 'Reviews'),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Listings', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          FutureBuilder<List<Product>>(
            future: _productsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 40),
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                );
              }
              final products = snapshot.data ?? [];
              if (products.isEmpty) {
                return Text('No listings yet',
                    style: Theme.of(context).textTheme.bodyMedium);
              }
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.75,
                ),
                itemCount: products.length,
                itemBuilder: (context, i) => ProductCard(
                  product: products[i],
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              ProductDetailScreen(product: products[i]))),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _avatarWidget(String? avatarUrl, String name,
      {double size = 80}) {
    if (avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          avatarUrl,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(name, size),
        ),
      );
    }
    return _defaultAvatar(name, size);
  }

  Widget _defaultAvatar(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              fontSize: size * 0.4),
        ),
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value,
            style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.espresso)),
        const SizedBox(height: 2),
        Text(label,
            style:
                GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: AppColors.border);
}
