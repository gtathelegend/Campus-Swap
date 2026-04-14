import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../providers/auth_provider.dart';
import '../services/message_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final _messageService = MessageService();
  late Future<List<Conversation>> _convFuture;
  RealtimeChannel? _channel;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _convFuture = _messageService.getConversations();
    // Auto-refresh when any conversation changes (new message, unread flag, etc.)
    _channel = _messageService.subscribeToConversationChanges(_refresh);
  }

  @override
  void dispose() {
    if (_channel != null) {
      Supabase.instance.client.removeChannel(_channel!);
    }
    super.dispose();
  }

  void _refresh() {
    if (!mounted) return;
    setState(() {
      _convFuture = _messageService.getConversations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        title: Text('Messages', style: Theme.of(context).textTheme.titleLarge),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: AppColors.espresso),
            onPressed: _refresh,
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder<List<Conversation>>(
          future: _convFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                  child: CircularProgressIndicator(color: AppColors.gold));
            }
            final conversations = snapshot.data ?? [];
            if (conversations.isEmpty) return _buildEmptyState();

            final filtered = _query.isEmpty
                ? conversations
                : conversations
                    .where((c) => c.seller.name
                        .toLowerCase()
                        .contains(_query.toLowerCase()))
                    .toList();

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
                  child: TextField(
                    onChanged: (v) => setState(() => _query = v),
                    decoration: const InputDecoration(
                      hintText: 'Search messages...',
                      prefixIcon:
                          Icon(Icons.search, color: AppColors.stone, size: 20),
                      contentPadding: EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text('No results for "$_query"',
                              style: Theme.of(context).textTheme.bodyMedium))
                      : RefreshIndicator(
                          color: AppColors.gold,
                          onRefresh: () async => _refresh(),
                          child: ListView.separated(
                            padding: const EdgeInsets.only(bottom: 80),
                            itemCount: filtered.length,
                            separatorBuilder: (_, __) =>
                                const Divider(indent: 76, height: 1),
                            itemBuilder: (context, i) {
                              final conv = filtered[i];
                              return ListTile(
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 8),
                                leading: Stack(
                                  children: [
                                    _avatarWidget(conv.seller),
                                    if (conv.hasUnread)
                                      Positioned(
                                        right: 0,
                                        bottom: 0,
                                        child: Container(
                                          width: 14,
                                          height: 14,
                                          decoration: const BoxDecoration(
                                              color: AppColors.gold,
                                              shape: BoxShape.circle),
                                        ),
                                      ),
                                  ],
                                ),
                                title: Text(
                                  conv.seller.name,
                                  style: GoogleFonts.manrope(
                                    fontSize: 15,
                                    fontWeight: conv.hasUnread
                                        ? FontWeight.w700
                                        : FontWeight.w600,
                                    color: AppColors.espresso,
                                  ),
                                ),
                                subtitle: Text(
                                  conv.lastMessage,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    color: conv.hasUnread
                                        ? AppColors.espresso
                                        : AppColors.stone,
                                    fontWeight: conv.hasUnread
                                        ? FontWeight.w500
                                        : FontWeight.w400,
                                  ),
                                ),
                                trailing: Text(conv.time,
                                    style: GoogleFonts.inter(
                                        fontSize: 12, color: AppColors.stone)),
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (_) => ChatScreen(
                                              seller: conv.seller,
                                              conversationId: conv.id,
                                              product: conv.product,
                                              isCurrentUserBuyer:
                                                  _isCurrentUserBuyer(
                                                      conv, context),
                                            )),
                                  );
                                  _refresh();
                                },
                              );
                            },
                          ),
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _isCurrentUserBuyer(Conversation conv, BuildContext context) {
    final uid = context.read<AuthProvider>().currentUserId;
    return uid != conv.otherUserId;
  }

  Widget _avatarWidget(Seller seller) {
    if (seller.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          seller.avatarUrl!,
          width: 48,
          height: 48,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(seller.name),
        ),
      );
    }
    return _defaultAvatar(seller.name);
  }

  Widget _defaultAvatar(String name) {
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
      child: Center(
        child: Text(
          name.isNotEmpty ? name[0].toUpperCase() : '?',
          style: GoogleFonts.manrope(
              fontWeight: FontWeight.w700,
              color: AppColors.gold,
              fontSize: 18),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                  color: AppColors.border, shape: BoxShape.circle),
              child: const Icon(Icons.chat_bubble_outline,
                  color: AppColors.stone, size: 36),
            ),
            const SizedBox(height: 24),
            Text('No messages yet',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(
              'When you contact sellers or buyers,\nyour conversations will appear here.',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
              child: const Text('Browse Items'),
            ),
          ],
        ),
      ),
    );
  }
}
