import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/models.dart';

class MessageService {
  final _client = Supabase.instance.client;

  String? get _uid => _client.auth.currentUser?.id;

  // ─── Conversations ────────────────────────────────────────────────────────────

  Future<List<Conversation>> getConversations() async {
    if (_uid == null) return [];
    final data = await _client
        .from('conversations')
        .select('''
          *,
          buyer_profile:profiles!buyer_id(*),
          seller_profile:profiles!seller_id(*),
          product:products!product_id(*, seller:profiles!seller_id(*))
        ''')
        .or('buyer_id.eq.$_uid,seller_id.eq.$_uid')
        .order('last_message_at', ascending: false);
    return (data as List<dynamic>)
        .map((row) =>
            Conversation.fromJson(row as Map<String, dynamic>, _uid!))
        .toList();
  }

  /// Get or create a conversation between current user (buyer) and a seller
  /// for a given product. Returns the conversation id.
  Future<String> getOrCreateConversation({
    required String sellerId,
    String? productId,
  }) async {
    if (_uid == null) throw Exception('Not logged in');

    // Try to find existing conversation
    var query = _client
        .from('conversations')
        .select('id')
        .eq('buyer_id', _uid!)
        .eq('seller_id', sellerId);

    if (productId != null) {
      query = query.eq('product_id', productId);
    }

    final existing = await query.maybeSingle();
    if (existing != null) return existing['id'] as String;

    // Create new conversation
    final result = await _client.from('conversations').insert({
      'buyer_id': _uid,
      'seller_id': sellerId,
      if (productId != null) 'product_id': productId,
    }).select('id').single();
    return result['id'] as String;
  }

  // ─── Messages ─────────────────────────────────────────────────────────────────

  Future<List<Message>> getMessages(String conversationId) async {
    if (_uid == null) return [];
    final data = await _client
        .from('messages')
        .select()
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true);
    return (data as List<dynamic>)
        .map((row) =>
            Message.fromJson(row as Map<String, dynamic>, _uid!))
        .toList();
  }

  Future<void> sendMessage({
    required String conversationId,
    required String text,
    required String otherUserId,
    required bool isCurrentUserBuyer,
  }) async {
    if (_uid == null) return;

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': _uid,
      'text': text,
    });

    // Update conversation last message and unread flag
    await _client.from('conversations').update({
      'last_message': text,
      'last_message_at': DateTime.now().toUtc().toIso8601String(),
      // Mark unread for the OTHER participant
      if (isCurrentUserBuyer)
        'seller_has_unread': true
      else
        'buyer_has_unread': true,
    }).eq('id', conversationId);
  }

  /// Mark conversation as read for the current user.
  Future<void> markAsRead(String conversationId, bool isCurrentUserBuyer) async {
    await _client.from('conversations').update({
      if (isCurrentUserBuyer)
        'buyer_has_unread': false
      else
        'seller_has_unread': false,
    }).eq('id', conversationId);
  }

  // ─── Real-time ────────────────────────────────────────────────────────────────

  /// Returns a stream of messages for a conversation.
  Stream<List<Message>> subscribeToMessages(String conversationId) {
    if (_uid == null) return const Stream.empty();
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: true)
        .map((rows) => rows
            .map((row) => Message.fromJson(row, _uid!))
            .toList());
  }
}
