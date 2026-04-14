import 'dart:async';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NotificationService {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  final _client = Supabase.instance.client;
  final _plugin = FlutterLocalNotificationsPlugin();

  RealtimeChannel? _messagesChannel;
  RealtimeChannel? _productsChannel;
  RealtimeChannel? _reviewsChannel;

  bool _initialized = false;
  String? _activeUserId;

  static const _messagesChannelId = 'messages_channel';
  static const _updatesChannelId = 'updates_channel';
  static const _reviewsChannelId = 'reviews_channel';

  Future<void> startForCurrentUser() async {
    final uid = _client.auth.currentUser?.id;
    if (uid == null) return;

    await _initializeLocalNotifications();

    if (_activeUserId == uid && _messagesChannel != null) {
      return;
    }

    await stop();
    _activeUserId = uid;

    _messagesChannel = _client
        .channel('notify-messages-$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          callback: (payload) async {
            await _handleIncomingMessage(uid, payload);
          },
        )
        .subscribe();

    _productsChannel = _client
        .channel('notify-products-$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.update,
          schema: 'public',
          table: 'products',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'seller_id',
            value: uid,
          ),
          callback: (payload) async {
            await _handleListingUpdate(payload);
          },
        )
        .subscribe();

    // Notify when someone leaves a review on our profile
    _reviewsChannel = _client
        .channel('notify-reviews-$uid')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'reviews',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'reviewee_id',
            value: uid,
          ),
          callback: (payload) async {
            final row = payload.newRecord;
            final rating = row['rating'] as int? ?? 5;
            final stars = '⭐' * rating;
            await _show(
              id: _stableInt('review-${row['id']}'),
              title: 'New review!',
              body: '$stars Someone left you a ${rating}-star review.',
              channelId: _reviewsChannelId,
              channelName: 'Reviews',
            );
          },
        )
        .subscribe();
  }

  Future<void> stop() async {
    if (_messagesChannel != null) {
      await _client.removeChannel(_messagesChannel!);
      _messagesChannel = null;
    }
    if (_productsChannel != null) {
      await _client.removeChannel(_productsChannel!);
      _productsChannel = null;
    }
    if (_reviewsChannel != null) {
      await _client.removeChannel(_reviewsChannel!);
      _reviewsChannel = null;
    }
    _activeUserId = null;
  }

  Future<void> _initializeLocalNotifications() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings =
        InitializationSettings(android: androidInit, iOS: iosInit);
    await _plugin.initialize(settings);

    // Request Android 13+ notification permission
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();

    _initialized = true;
  }

  Future<void> _handleIncomingMessage(
    String uid,
    PostgresChangePayload payload,
  ) async {
    final newRow = payload.newRecord;
    final senderId = newRow['sender_id'] as String?;
    final conversationId = newRow['conversation_id'] as String?;
    final text = (newRow['text'] as String? ?? '').trim();

    if (senderId == null || conversationId == null || senderId == uid) {
      return;
    }

    try {
      final conv = await _client
          .from('conversations')
          .select('buyer_id,seller_id')
          .eq('id', conversationId)
          .maybeSingle();
      if (conv == null) return;

      final buyerId = conv['buyer_id'] as String?;
      final sellerId = conv['seller_id'] as String?;
      if (buyerId != uid && sellerId != uid) return;

      final profile = await _client
          .from('profiles')
          .select('name')
          .eq('id', senderId)
          .maybeSingle();
      final senderName =
          (profile?['name'] as String?)?.trim().isNotEmpty == true
              ? (profile!['name'] as String)
              : 'New message';

      await _show(
        id: _stableInt(conversationId),
        title: senderName,
        body: text.isEmpty ? 'You received a new message' : text,
        channelId: _messagesChannelId,
        channelName: 'Messages',
      );
    } catch (_) {
      // Ignore notification failures; do not break real-time stream.
    }
  }

  Future<void> _handleListingUpdate(PostgresChangePayload payload) async {
    try {
      final row = payload.newRecord;
      final productId = row['id']?.toString() ?? DateTime.now().toString();
      final productName = (row['name'] as String?)?.trim();

      await _show(
        id: _stableInt(productId),
        title: 'Listing update',
        body: productName == null || productName.isEmpty
            ? 'There is new activity on one of your listings.'
            : '$productName has new activity.',
        channelId: _updatesChannelId,
        channelName: 'Listing updates',
      );
    } catch (_) {
      // Ignore notification failures; do not break real-time stream.
    }
  }

  Future<void> _show({
    required int id,
    required String title,
    required String body,
    required String channelId,
    required String channelName,
  }) async {
    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        importance: Importance.max,
        priority: Priority.high,
      ),
    );

    await _plugin.show(id, title, body, details);
  }

  int _stableInt(String input) {
    final hash = input.hashCode & 0x7fffffff;
    return hash == 0 ? 1 : hash;
  }
}
