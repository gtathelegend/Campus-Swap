import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'report_screen.dart';

class SellerProfileScreen extends StatelessWidget {
  final Seller seller;

  const SellerProfileScreen({super.key, required this.seller});

  @override
  Widget build(BuildContext context) {
    final sellerProducts = products.where((p) => p.seller.id == seller.id).take(4).toList();

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
                Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen(type: 'user')));
              }
            },
            itemBuilder: (_) => [const PopupMenuItem(value: 'report', child: Text('Report user'))],
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Center(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
                  child: const Center(child: Text('👤', style: TextStyle(fontSize: 36))),
                ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(seller.name, style: Theme.of(context).textTheme.titleLarge),
                    if (seller.verified) ...[
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, size: 18, color: AppColors.gold),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, size: 14, color: AppColors.gold),
                    const SizedBox(width: 4),
                    Text('${seller.rating} · ${seller.reviews} reviews', style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
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
          if (sellerProducts.isEmpty)
            Text('No listings yet', style: Theme.of(context).textTheme.bodyMedium)
          else
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: sellerProducts.length,
              itemBuilder: (context, i) => ProductCard(
                product: sellerProducts[i],
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: sellerProducts[i]))),
              ),
            ),
        ],
      ),
    );
  }

  Widget _stat(BuildContext context, String value, String label) {
    return Column(
      children: [
        Text(value, style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.espresso)),
        const SizedBox(height: 2),
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      ],
    );
  }

  Widget _divider() => Container(width: 1, height: 40, color: AppColors.border);
}
