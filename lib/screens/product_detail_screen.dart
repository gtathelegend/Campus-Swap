import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import '../widgets/product_card.dart';
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
      case 'Electronics': return '💻';
      case 'Books & Textbooks': return '📚';
      case 'Clothing & Accessories': return '👕';
      case 'Sports & Outdoors': return '⚽';
      case 'Kitchen & Dining': return '🍴';
      case 'Furniture': return '🪑';
      case 'Home Decor': return '🏠';
      default: return '📦';
    }
  }

  Color _conditionColor() => AppColors.conditionColors[widget.product.condition] ?? AppColors.stone;

  List<Product> get _similarItems => products
      .where((p) => p.id != widget.product.id && p.category == widget.product.category)
      .take(6)
      .toList();

  void _showSafetyTips() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => _SafetyTipsSheet(),
    );
  }

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
                decoration: const BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new, size: 18, color: AppColors.espresso),
              ),
            ),
            actions: [
              GestureDetector(
                onTap: () => setState(() => _saved = !_saved),
                child: Container(
                  margin: const EdgeInsets.all(8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
                  child: Icon(_saved ? Icons.favorite : Icons.favorite_border, color: _saved ? AppColors.alert : AppColors.espresso, size: 20),
                ),
              ),
              PopupMenuButton<String>(
                icon: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(color: AppColors.base, shape: BoxShape.circle),
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
                  Text('\$${product.price.toStringAsFixed(0)}', style: GoogleFonts.manrope(fontSize: 24, fontWeight: FontWeight.w800, color: AppColors.espresso)),
                  if (product.isNegotiable) ...[
                    const SizedBox(height: 4),
                    Text('Price negotiable', style: GoogleFonts.inter(fontSize: 12, color: AppColors.gold, fontWeight: FontWeight.w500)),
                  ],
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on_outlined, product.location),
                  const SizedBox(height: 8),
                  _infoRow(Icons.category_outlined, product.category),
                  const Divider(height: 32),
                  Text('Description', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description, style: Theme.of(context).textTheme.bodyLarge),
                  const Divider(height: 32),

                  // Seller Section
                  Text('Seller', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerProfileScreen(seller: product.seller))),
                    child: Row(
                      children: [
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
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
                  const Divider(height: 32),

                  // Safety Tips
                  GestureDetector(
                    onTap: _showSafetyTips,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined, color: AppColors.gold, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Safety Tips', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                                Text('Stay safe when buying & selling', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right, color: AppColors.stone, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Similar Items Section
          if (_similarItems.isNotEmpty) ...[
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.cream,
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
                child: Text('Similar Items', style: Theme.of(context).textTheme.titleMedium),
              ),
            ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                  itemCount: _similarItems.length,
                  itemBuilder: (context, i) {
                    final item = _similarItems[i];
                    return Container(
                      width: 140,
                      margin: const EdgeInsets.only(right: 12),
                      child: ProductCard(
                        product: item,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: item)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
              MaterialPageRoute(builder: (_) => ChatScreen(seller: product.seller, product: product)),
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

class _SafetyTipsSheet extends StatelessWidget {
  const _SafetyTipsSheet();

  @override
  Widget build(BuildContext context) {
    final tips = [
      (Icons.public, 'Meet in Public', 'Choose a safe, public location like a campus library or student center.'),
      (Icons.search, 'Inspect Before Buying', 'Always examine items carefully before completing the transaction.'),
      (Icons.payment, 'Use Safe Payment', 'Prefer in-person cash or verified payment apps. Avoid wire transfers.'),
      (Icons.people, 'Trust Your Instincts', 'If something feels wrong, it probably is. Don\'t proceed with the deal.'),
      (Icons.phone_android, 'Keep Communication on App', 'Use in-app messaging to keep a record of all communications.'),
      (Icons.privacy_tip, 'Protect Your Privacy', 'Never share personal info like your home address or financial details.'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.shield, color: AppColors.gold, size: 24),
              const SizedBox(width: 10),
              Text('Safety Tips', style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Text('Stay safe when buying & selling', style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ...tips.map((tip) => Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(tip.$1, color: AppColors.gold, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(tip.$2, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                      const SizedBox(height: 2),
                      Text(tip.$3, style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                    ],
                  ),
                ),
              ],
            ),
          )),
        ],
      ),
    );
  }
}
