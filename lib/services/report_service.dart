import 'package:supabase_flutter/supabase_flutter.dart';

/// Submits user/listing reports to Supabase.
class ReportService {
  final _client = Supabase.instance.client;
  String? get _uid => _client.auth.currentUser?.id;

  Future<void> submitReport({
    required String type, // 'user' or 'listing'
    String? reportedUserId,
    String? reportedProductId,
    required String reason,
    String? details,
  }) async {
    if (_uid == null) throw Exception('Not logged in');
    await _client.from('reports').insert({
      'reporter_id': _uid,
      'reported_user_id': reportedUserId,
      'reported_product_id': reportedProductId,
      'type': type,
      'reason': reason,
      'details': (details != null && details.isNotEmpty) ? details : null,
    });
  }
}
