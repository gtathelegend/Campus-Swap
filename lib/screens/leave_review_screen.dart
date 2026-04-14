import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/models.dart';
import '../services/review_service.dart';
import '../theme/app_theme.dart';

class LeaveReviewScreen extends StatefulWidget {
  final Seller seller;
  final String? productId;
  final Review? existingReview; // non-null if editing

  const LeaveReviewScreen({
    super.key,
    required this.seller,
    this.productId,
    this.existingReview,
  });

  @override
  State<LeaveReviewScreen> createState() => _LeaveReviewScreenState();
}

class _LeaveReviewScreenState extends State<LeaveReviewScreen> {
  final _commentController = TextEditingController();
  final _reviewService = ReviewService();
  int _rating = 0;
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.existingReview != null) {
      _rating = widget.existingReview!.rating;
      _commentController.text = widget.existingReview!.comment ?? '';
    }
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_rating == 0) {
      setState(() => _error = 'Please select a star rating.');
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await _reviewService.submitReview(
        revieweeId: widget.seller.id,
        productId: widget.productId,
        rating: _rating,
        comment: _commentController.text.trim(),
      );
      if (mounted) {
        Navigator.pop(context, true); // true = refresh parent
      }
    } catch (e) {
      if (mounted) {
        setState(() => _error = 'Failed to submit review. Please try again.');
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingReview != null;

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: Text(isEditing ? 'Edit Review' : 'Leave a Review',
            style: Theme.of(context).textTheme.titleLarge),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Seller info
          Row(
            children: [
              _avatar(widget.seller),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.seller.name,
                        style: GoogleFonts.manrope(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.espresso)),
                    if (widget.seller.rating > 0)
                      Row(
                        children: [
                          const Icon(Icons.star,
                              size: 13, color: AppColors.gold),
                          const SizedBox(width: 3),
                          Text(
                              '${widget.seller.rating.toStringAsFixed(1)} · ${widget.seller.reviews} reviews',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.stone)),
                        ],
                      ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Star selector
          Text('Your Rating',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              5,
              (i) => GestureDetector(
                onTap: () => setState(() => _rating = i + 1),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Icon(
                    i < _rating ? Icons.star_rounded : Icons.star_outline_rounded,
                    size: 44,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              _ratingLabel(),
              style: GoogleFonts.inter(
                  fontSize: 13,
                  color: AppColors.stone,
                  fontWeight: FontWeight.w500),
            ),
          ),
          const SizedBox(height: 28),

          // Comment
          Text('Comment (optional)',
              style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso)),
          const SizedBox(height: 8),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 500,
            decoration: const InputDecoration(
              hintText:
                  'Share your experience with this seller...',
            ),
          ),

          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!,
                style: GoogleFonts.inter(
                    fontSize: 13, color: AppColors.alert)),
          ],
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _submit,
              child: _saving
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Colors.white))
                  : Text(isEditing ? 'Update Review' : 'Submit Review'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  String _ratingLabel() {
    switch (_rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Great';
      case 5:
        return 'Excellent!';
      default:
        return 'Tap to rate';
    }
  }

  Widget _avatar(Seller seller) {
    if (seller.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          seller.avatarUrl!,
          width: 52,
          height: 52,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(seller.name),
        ),
      );
    }
    return _defaultAvatar(seller.name);
  }

  Widget _defaultAvatar(String name) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.15),
          shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              fontSize: 22),
        ),
      ),
    );
  }
}
