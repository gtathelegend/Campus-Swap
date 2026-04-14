import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class ReviewService {
  final _client = Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<List<Review>> getReviewsForUser(String userId) async {
    final data = await _client
        .from('reviews')
        .select('*, reviewer:profiles!reviewer_id(*)')
        .eq('reviewee_id', userId)
        .order('created_at', ascending: false);
    return (data as List<dynamic>)
        .map((row) => Review.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  /// Returns the existing review the current user left for [revieweeId],
  /// or null if they haven't reviewed yet.
  Future<Review?> getMyReview(String revieweeId) async {
    if (_uid == null) return null;
    final data = await _client
        .from('reviews')
        .select('*, reviewer:profiles!reviewer_id(*)')
        .eq('reviewer_id', _uid!)
        .eq('reviewee_id', revieweeId)
        .maybeSingle();
    if (data == null) return null;
    return Review.fromJson(data as Map<String, dynamic>);
  }

  /// Upsert a review. Uses unique(reviewer_id, reviewee_id) constraint.
  Future<void> submitReview({
    required String revieweeId,
    String? productId,
    required int rating,
    String? comment,
  }) async {
    if (_uid == null) throw Exception('Not logged in');
    await _client.from('reviews').upsert({
      'reviewer_id': _uid,
      'reviewee_id': revieweeId,
      if (productId != null) 'product_id': productId,
      'rating': rating,
      'comment': (comment != null && comment.isNotEmpty) ? comment : null,
    });
  }

  Future<void> deleteReview(String reviewId) async {
    await _client.from('reviews').delete().eq('id', reviewId);
  }
}
