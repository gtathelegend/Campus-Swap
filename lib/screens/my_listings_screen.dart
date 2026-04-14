import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/product_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'listing_detail_screen.dart';
import 'edit_listing_screen.dart';

class MyListingsScreen extends StatefulWidget {
  const MyListingsScreen({super.key});

  @override
  State<MyListingsScreen> createState() => _MyListingsScreenState();
}

class _MyListingsScreenState extends State<MyListingsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _productService = ProductService();
  late Future<List<Product>> _listingsFuture;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _listingsFuture = _productService.getMyListings();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _refresh() {
    setState(() => _listingsFuture = _productService.getMyListings());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text('My Listings',
            style: Theme.of(context).textTheme.titleLarge),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.espresso,
          unselectedLabelColor: AppColors.stone,
          indicatorColor: AppColors.gold,
          indicatorWeight: 2,
          labelStyle: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600),
          unselectedLabelStyle: GoogleFonts.inter(fontSize: 13),
          tabs: const [
            Tab(text: 'Active'),
            Tab(text: 'Sold'),
            Tab(text: 'Draft'),
          ],
        ),
      ),
      body: FutureBuilder<List<Product>>(
        future: _listingsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
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
                      onPressed: _refresh, child: const Text('Retry')),
                ],
              ),
            );
          }
          final all = snapshot.data ?? [];
          final active = all.where((p) => !p.isSold && !p.isDraft).toList();
          final sold = all.where((p) => p.isSold).toList();
          final draft = all.where((p) => p.isDraft).toList();

          return TabBarView(
            controller: _tabController,
            children: [
              _buildListingList(active),
              _buildListingList(sold),
              _buildListingList(draft),
            ],
          );
        },
      ),
    );
  }

  Widget _buildListingList(List<Product> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.inventory_2_outlined,
                  size: 48, color: AppColors.stone),
              const SizedBox(height: 16),
              Text('No listings here',
                  style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 8),
              Text('Your listings will appear here.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      );
    }

    return RefreshIndicator(
      color: AppColors.gold,
      onRefresh: () async => _refresh(),
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, i) =>
            _ListingCard(product: items[i], onRefresh: _refresh),
      ),
    );
  }
}

class _ListingCard extends StatelessWidget {
  final Product product;
  final VoidCallback onRefresh;

  const _ListingCard({required this.product, required this.onRefresh});

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'Electronics':
        return '💻';
      case 'Books & Textbooks':
        return '📚';
      case 'Clothing & Accessories':
        return '👕';
      case 'Furniture':
        return '🪑';
      default:
        return '📦';
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => ListingDetailScreen(product: product)),
        );
        if (result != null) onRefresh();
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.base,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            // Thumbnail
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.cream,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.border),
              ),
              child: product.imageUrls.isNotEmpty
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        product.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                            child: Text(_categoryEmoji(product.category),
                                style: const TextStyle(fontSize: 28))),
                      ),
                    )
                  : Center(
                      child: Text(_categoryEmoji(product.category),
                          style: const TextStyle(fontSize: 28))),
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: GoogleFonts.inter(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.espresso),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 2),
                  Text('₹${product.price.toStringAsFixed(0)}',
                      style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.gold)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.visibility_outlined,
                          size: 12, color: AppColors.stone),
                      const SizedBox(width: 3),
                      Text('${product.views}',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.stone)),
                      const SizedBox(width: 8),
                      const Icon(Icons.chat_bubble_outline,
                          size: 12, color: AppColors.stone),
                      const SizedBox(width: 3),
                      Text('${product.messages}',
                          style: GoogleFonts.inter(
                              fontSize: 11, color: AppColors.stone)),
                    ],
                  ),
                ],
              ),
            ),
            // Actions
            if (!product.isSold && !product.isDraft)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                EditListingScreen(product: product)),
                      );
                      if (result == true) onRefresh();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('Edit',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.espresso)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                ListingDetailScreen(product: product)),
                      );
                      if (result != null) onRefresh();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.espresso,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text('View',
                          style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: AppColors.base)),
                    ),
                  ),
                ],
              ),
            if (product.isSold)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF4CAF50).withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Sold',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF4CAF50))),
              ),
            if (product.isDraft)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.stone.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text('Draft',
                    style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.stone)),
              ),
          ],
        ),
      ),
    );
  }
}
