import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/product_service.dart';
import '../services/review_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import 'report_screen.dart';
import 'leave_review_screen.dart';

class SellerProfileScreen extends StatefulWidget {
  final Seller seller;

  const SellerProfileScreen({super.key, required this.seller});

  @override
  State<SellerProfileScreen> createState() => _SellerProfileScreenState();
}

class _SellerProfileScreenState extends State<SellerProfileScreen> {
  final _productService = ProductService();
  final _reviewService = ReviewService();
  late Future<List<Product>> _productsFuture;
  late Future<List<Review>> _reviewsFuture;
  Review? _myReview;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _productsFuture = _productService.getProductsBySeller(widget.seller.id);
    _reviewsFuture = _reviewService.getReviewsForUser(widget.seller.id);
    _reviewService.getMyReview(widget.seller.id).then((r) {
      if (mounted) setState(() => _myReview = r);
    });
  }

  void _openReviewScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => LeaveReviewScreen(
          seller: widget.seller,
          existingReview: _myReview,
        ),
      ),
    );
    if (result == true && mounted) {
      setState(() {
        _reviewsFuture = _reviewService.getReviewsForUser(widget.seller.id);
        _myReview = null;
      });
      _reviewService.getMyReview(widget.seller.id).then((r) {
        if (mounted) setState(() => _myReview = r);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final seller = widget.seller;
    final currentUserId = context.read<AuthProvider>().currentUserId;
    final isOwnProfile = currentUserId == seller.id;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (!isOwnProfile)
            PopupMenuButton<String>(
              onSelected: (v) {
                if (v == 'report') {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ReportScreen(
                              type: 'user', reportedId: seller.id)));
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
          // Profile header
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
                      const Icon(Icons.verified, size: 18, color: AppColors.gold),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                if (seller.rating > 0)
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

          // Stats
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

          // Listings
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
          const SizedBox(height: 28),

          // Reviews section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Reviews', style: Theme.of(context).textTheme.titleMedium),
              if (!isOwnProfile)
                TextButton.icon(
                  onPressed: _openReviewScreen,
                  icon: Icon(
                    _myReview != null ? Icons.edit_outlined : Icons.star_outline,
                    size: 16,
                    color: AppColors.gold,
                  ),
                  label: Text(
                    _myReview != null ? 'Edit Review' : 'Leave Review',
                    style: GoogleFonts.inter(
                        fontSize: 13,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          FutureBuilder<List<Review>>(
            future: _reviewsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 24),
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                );
              }
              final reviews = snapshot.data ?? [];
              if (reviews.isEmpty) {
                return Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.star_border,
                          size: 32, color: AppColors.stone),
                      const SizedBox(height: 8),
                      Text('No reviews yet',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 4),
                      Text('Be the first to leave a review',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ],
                  ),
                );
              }
              return Column(
                children: reviews.map((review) => _reviewCard(review)).toList(),
              );
            },
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _reviewCard(Review review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _smallAvatar(review.reviewerAvatarUrl, review.reviewerName),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(review.reviewerName,
                        style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.espresso)),
                    Text(review.createdAt,
                        style: GoogleFonts.inter(
                            fontSize: 11, color: AppColors.stone)),
                  ],
                ),
              ),
              // Stars
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < review.rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 14,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          if (review.comment != null && review.comment!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(review.comment!,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.mocha, height: 1.5)),
          ],
        ],
      ),
    );
  }

  Widget _smallAvatar(String? avatarUrl, String name) {
    if (avatarUrl != null) {
      return ClipOval(
        child: Image.network(avatarUrl,
            width: 36,
            height: 36,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _defaultSmallAvatar(name)),
      );
    }
    return _defaultSmallAvatar(name);
  }

  Widget _defaultSmallAvatar(String name) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.15),
          shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700, color: AppColors.gold, fontSize: 14),
        ),
      ),
    );
  }

  Widget _avatarWidget(String? avatarUrl, String name, {double size = 80}) {
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
          color: AppColors.gold.withValues(alpha: 0.15), shape: BoxShape.circle),
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
            style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
      ],
    );
  }

  Widget _divider() =>
      Container(width: 1, height: 40, color: AppColors.border);
}
