import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import 'seller_profile_screen.dart';
import 'chat_screen.dart';
import 'report_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  bool _saved = false;

  String _categoryEmoji() {
    switch (widget.product.category) {
      case 'Books': return '📚';
      case 'Tech': return '💻';
      case 'Fashion': return '👕';
      case 'Bikes': return '🚲';
      case 'Furniture': return '🪑';
      default: return '📦';
    }
  }

  Color _conditionColor() => AppColors.conditionColors[widget.product.condition] ?? AppColors.stone;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.base,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.espresso),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _saved = !_saved),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
                  child: Icon(_saved ? Icons.favorite : Icons.favorite_border, color: _saved ? AppColors.alert : AppColors.espresso, size: 20),
                ),
              ),
              PopupMenuButton<String>(
                icon: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
                  child: const Icon(Icons.more_horiz, color: AppColors.espresso, size: 20),
                ),
                onSelected: (v) {
                  if (v == 'report') {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen(type: 'listing')));
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(value: 'report', child: Text('Report listing')),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: AppColors.cream,
                child: Center(child: Text(_categoryEmoji(), style: const TextStyle(fontSize: 80))),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(product.name, style: Theme.of(context).textTheme.titleLarge),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _conditionColor().withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(product.condition, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: _conditionColor())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toStringAsFixed(0)}', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.espresso)),
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on_outlined, product.location),
                  const SizedBox(height: 8),
                  _infoRow(Icons.category_outlined, product.category),
                  const Divider(height: 32),
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                  const Divider(height: 32),
                  Text('Seller', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerProfileScreen(seller: product.seller))),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withOpacity(0.15),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(child: Text('👤', style: TextStyle(fontSize: 22))),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(product.seller.name, style: Theme.of(context).textTheme.titleMedium),
                                  if (product.seller.verified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified, size: 16, color: AppColors.gold),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star, size: 14, color: AppColors.gold),
                                  const SizedBox(width: 4),
                                  Text('${product.seller.rating} · ${product.seller.reviews} reviews', style: Theme.of(context).textTheme.bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.stone),
                      ],
                    ),
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: AppColors.base,
          border: Border(top: BorderSide(color: AppColors.border)),
        ),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            icon: const Icon(Icons.chat_bubble_outline, size: 18),
            label: const Text('Contact Seller'),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => ChatScreen(seller: product.seller)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.stone),
        const SizedBox(width: 6),
        Text(text, style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
