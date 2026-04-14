import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class ProfileService {
  final _client = Supabase.instance.client;

  String? get _uid => _client.auth.currentUser?.id;

  Future<UserProfile?> getCurrentProfile() async {
    if (_uid == null) return null;
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', _uid!)
        .maybeSingle();
    if (data == null) return null;
    return UserProfile.fromJson(data);
  }

  Future<Seller?> getSellerById(String userId) async {
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    if (data == null) return null;
    return Seller.fromJson(data);
  }

  Future<void> updateProfile({
    required String name,
    String? phone,
    String? bio,
    String? campusLocation,
    String? avatarUrl,
  }) async {
    if (_uid == null) return;
    await _client.from('profiles').update({
      'name': name,
      if (phone != null) 'phone': phone,
      if (bio != null) 'bio': bio,
      if (campusLocation != null) 'campus_location': campusLocation,
      if (avatarUrl != null) 'avatar_url': avatarUrl,
    }).eq('id', _uid!);
  }

  Future<List<BlockedUser>> getBlockedUsers() async {
    if (_uid == null) return [];
    final data = await _client
        .from('blocked_users')
        .select('*, blocked_profile:profiles!blocked_id(*)')
        .eq('blocker_id', _uid!)
        .order('created_at', ascending: false);
    return (data as List<dynamic>)
        .map((row) => BlockedUser.fromJson(row as Map<String, dynamic>))
        .toList();
  }

  Future<void> blockUser(String targetUserId) async {
    if (_uid == null) return;
    await _client.from('blocked_users').upsert({
      'blocker_id': _uid,
      'blocked_id': targetUserId,
    });
  }

  Future<void> unblockUser(String targetUserId) async {
    if (_uid == null) return;
    await _client
        .from('blocked_users')
        .delete()
        .eq('blocker_id', _uid!)
        .eq('blocked_id', targetUserId);
  }
}
