import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/brand_title.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/product_service.dart';
import 'edit_listing_screen.dart';

class ListingDetailScreen extends StatefulWidget {
  final Product product;

  const ListingDetailScreen({super.key, required this.product});

  @override
  State<ListingDetailScreen> createState() => _ListingDetailScreenState();
}

class _ListingDetailScreenState extends State<ListingDetailScreen> {
  late Product _product;
  final _productService = ProductService();

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'Electronics': return '💻';
      case 'Books & Textbooks': return '📚';
      case 'Clothing & Accessories': return '👕';
      case 'Furniture': return '🪑';
      default: return '📦';
    }
  }

  void _showMarkAsSold() {
    showDialog(
      context: context,
      builder: (_) => _MarkAsSoldDialog(
        product: _product,
        onConfirm: () async {
          Navigator.pop(context);
          try {
            await _productService.markAsSold(_product.id);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing marked as sold!'), backgroundColor: AppColors.espresso),
              );
              Navigator.pop(context, 'sold');
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to update listing'), backgroundColor: AppColors.alert),
              );
            }
          }
        },
      ),
    );
  }

  void _showDeleteConfirm() {
    showDialog(
      context: context,
      builder: (_) => _DeleteListingDialog(
        product: _product,
        onConfirm: () async {
          Navigator.pop(context);
          try {
            await _productService.deleteProduct(_product.id);
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Listing deleted'), backgroundColor: AppColors.alert),
              );
              Navigator.pop(context, 'deleted');
            }
          } catch (e) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Failed to delete listing'), backgroundColor: AppColors.alert),
              );
            }
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: BrandTitle(_product.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) {
              if (v == 'delete') _showDeleteConfirm();
            },
            itemBuilder: (_) => [
              const PopupMenuItem(value: 'delete', child: Text('Delete Listing')),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  color: AppColors.cream,
                  border: Border.all(color: AppColors.border),
                ),
                child: _product.imageUrls.isNotEmpty
                    ? Image.network(
                        _product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                            child: Text(_categoryEmoji(_product.category),
                                style: const TextStyle(fontSize: 60))),
                      )
                    : Center(child: Text(_categoryEmoji(_product.category), style: const TextStyle(fontSize: 60))),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text(_product.name, style: Theme.of(context).textTheme.titleLarge)),
                Text('₹${_product.price.toStringAsFixed(0)}', style: GoogleFonts.manrope(fontSize: 20, fontWeight: FontWeight.w800, color: AppColors.espresso)),
              ],
            ),
            const SizedBox(height: 4),
            Text('Listed ${_product.listedAt}', style: Theme.of(context).textTheme.bodySmall),
            const Divider(height: 28),

            // Stats
            Text('Listing Stats', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Column(
                children: [
                  _statRow(Icons.visibility_outlined, 'Total Views', _product.views.toString()),
                  const Divider(height: 20),
                  _statRow(Icons.chat_bubble_outline, 'Messages', _product.messages.toString()),
                  const Divider(height: 20),
                  _statRow(Icons.favorite_border, 'Favorites', _product.favorites.toString()),
                  const Divider(height: 20),
                  _statRow(Icons.calendar_today_outlined, 'Listed', _product.listedAt),
                ],
              ),
            ),
            const Divider(height: 28),

            Text('Description', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(_product.description, style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 28),

            // Actions
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    label: const Text('Edit Listing'),
                    onPressed: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => EditListingScreen(product: _product)),
                      );
                      if (result == true) setState(() {});
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.check_circle_outline, size: 18),
                    label: const Text('Mark as Sold'),
                    onPressed: _showMarkAsSold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _statRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.stone),
        const SizedBox(width: 10),
        Expanded(child: Text(label, style: GoogleFonts.inter(fontSize: 14, color: AppColors.mocha))),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
      ],
    );
  }
}

// ─── Mark as Sold Dialog ─────────────────────────────────────────────────────

class _MarkAsSoldDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onConfirm;

  const _MarkAsSoldDialog({required this.product, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.base,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
              child: const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 32),
            ),
            const SizedBox(height: 16),
            Text('Mark as Sold?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This will move your listing to sold items and notify interested buyers that it\'s no longer available.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Text('📦', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                        Text('₹${product.price.toStringAsFixed(0)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(onPressed: onConfirm, child: const Text('Yes, Mark as Sold')),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Delete Listing Dialog ────────────────────────────────────────────────────

class _DeleteListingDialog extends StatelessWidget {
  final Product product;
  final VoidCallback onConfirm;

  const _DeleteListingDialog({required this.product, required this.onConfirm});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.base,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(color: AppColors.alert.withOpacity(0.15), shape: BoxShape.circle),
              child: const Icon(Icons.delete_outline, color: AppColors.alert, size: 32),
            ),
            const SizedBox(height: 16),
            Text('Delete Listing?', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'This action cannot be undone. Your listing will be permanently removed and interested buyers will be notified.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
                    child: const Center(child: Text('📦', style: TextStyle(fontSize: 20))),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(product.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                        Text('₹${product.price.toStringAsFixed(0)} · ${product.views} views · ${product.messages} msgs', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onConfirm,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.alert, foregroundColor: Colors.white),
                child: const Text('Delete Listing'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
