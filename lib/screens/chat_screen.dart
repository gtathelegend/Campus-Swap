import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/message_service.dart';
import '../services/profile_service.dart';
import '../theme/app_theme.dart';
import '../widgets/brand_title.dart';
import '../models/models.dart';
import 'seller_profile_screen.dart';
import 'product_detail_screen.dart';
import 'report_screen.dart';

class ChatScreen extends StatefulWidget {
  final Seller seller;
  final String? conversationId;
  final Product? product;
  final bool isCurrentUserBuyer;

  const ChatScreen({
    super.key,
    required this.seller,
    this.conversationId,
    this.product,
    this.isCurrentUserBuyer = true,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  final _messageService = MessageService();
  final _profileService = ProfileService();

  late String _conversationId;
  bool _convReady = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _initConversation();
  }

  Future<void> _initConversation() async {
    if (widget.conversationId != null) {
      _conversationId = widget.conversationId!;
      await _messageService.markAsRead(
          _conversationId, widget.isCurrentUserBuyer);
      if (mounted) setState(() => _convReady = true);
    } else {
      try {
        _conversationId = await _messageService.getOrCreateConversation(
          sellerId: widget.seller.id,
          productId: widget.product?.id,
        );
        if (mounted) setState(() => _convReady = true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Failed to open conversation'),
                backgroundColor: AppColors.alert),
          );
          Navigator.pop(context);
        }
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    final text = _controller.text.trim();
    if (text.isEmpty || _isSending || !_convReady) return;

    setState(() => _isSending = true);
    _controller.clear();

    try {
      await _messageService.sendMessage(
        conversationId: _conversationId,
        text: text,
        otherUserId: widget.seller.id,
        isCurrentUserBuyer: widget.isCurrentUserBuyer,
      );
      _scrollToBottom();
    } catch (_) {
      _controller.text = text; // restore
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _showOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _ChatOptionsSheet(
        seller: widget.seller,
        product: widget.product,
        onViewProfile: () {
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      SellerProfileScreen(seller: widget.seller)));
        },
        onViewItem: widget.product != null
            ? () {
                Navigator.pop(context);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) =>
                            ProductDetailScreen(product: widget.product!)));
              }
            : null,
        onBlock: () async {
          Navigator.pop(context);
          await _profileService.blockUser(widget.seller.id);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content: Text('${widget.seller.name} has been blocked'),
                  backgroundColor: AppColors.espresso),
            );
            Navigator.pop(context);
          }
        },
        onReport: () {
          Navigator.pop(context);
          Navigator.push(context,
              MaterialPageRoute(builder: (_) => ReportScreen(
                  type: 'user', reportedId: widget.seller.id)));
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUserId =
        context.read<AuthProvider>().currentUserId ?? '';

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      SellerProfileScreen(seller: widget.seller))),
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 22,
                height: 22,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 8),
              _avatarWidget(widget.seller, size: 36),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.seller.name,
                      style: GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.espresso)),
                  Text('Tap to view profile',
                      style: GoogleFonts.inter(
                          fontSize: 11, color: AppColors.stone)),
                ],
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.espresso),
            onPressed: _showOptions,
          ),
        ],
      ),
      body: Column(
        children: [
          if (widget.product != null) _buildItemCard(),
          Expanded(
            child: !_convReady
                ? const Center(
                    child:
                        CircularProgressIndicator(color: AppColors.gold))
                : StreamBuilder<List<Message>>(
                    stream: _messageService
                        .subscribeToMessages(_conversationId),
                    builder: (context, snapshot) {
                      final messages = snapshot.data ?? [];
                      if (messages.isEmpty) {
                        return Center(
                          child: Text(
                            'Say hello! Start the conversation.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      }
                      WidgetsBinding.instance.addPostFrameCallback(
                          (_) => _scrollToBottom());
                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, i) =>
                            _bubble(messages[i], currentUserId),
                      );
                    },
                  ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildItemCard() {
    final p = widget.product!;
    final emoji = _categoryEmoji(p.category);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: AppColors.base,
        border: Border(bottom: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.border),
            ),
            child: p.imageUrls.isNotEmpty
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(p.imageUrls.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Center(
                            child: Text(emoji,
                                style:
                                    const TextStyle(fontSize: 24)))),
                  )
                : Center(
                    child: Text(emoji,
                        style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name,
                    style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.espresso)),
                Text('₹${p.price.toStringAsFixed(0)}',
                    style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.gold)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => ProductDetailScreen(product: p))),
            child: Text('View',
                style: GoogleFonts.inter(
                    fontSize: 13,
                    color: AppColors.gold,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 24),
      decoration: const BoxDecoration(
        color: AppColors.base,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: Row(
        children: [
          const SizedBox(width: 4),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _isSending ? null : _send,
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _isSending
                    ? AppColors.border
                    : AppColors.gold,
                shape: BoxShape.circle,
              ),
              child: _isSending
                  ? const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: AppColors.espresso),
                    )
                  : const Icon(Icons.send_rounded,
                      color: AppColors.espresso, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(Message msg, String currentUserId) {
    final isMe = msg.senderId == currentUserId;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            _avatarWidget(widget.seller, size: 28),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.gold : AppColors.base,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border:
                    isMe ? null : Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: isMe
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  Text(msg.text,
                      style: GoogleFonts.inter(
                          fontSize: 14, color: AppColors.espresso)),
                  const SizedBox(height: 4),
                  Text(msg.time,
                      style: GoogleFonts.inter(
                          fontSize: 10,
                          color: isMe
                              ? AppColors.espresso.withOpacity(0.6)
                              : AppColors.stone)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatarWidget(Seller seller, {double size = 48}) {
    if (seller.avatarUrl != null) {
      return ClipOval(
        child: Image.network(
          seller.avatarUrl!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _defaultAvatar(seller.name, size),
        ),
      );
    }
    return _defaultAvatar(seller.name, size);
  }

  Widget _defaultAvatar(String name, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
          color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
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
}

// ─── Chat Options Bottom Sheet ────────────────────────────────────────────────

class _ChatOptionsSheet extends StatelessWidget {
  final Seller seller;
  final Product? product;
  final VoidCallback onViewProfile;
  final VoidCallback? onViewItem;
  final VoidCallback onBlock;
  final VoidCallback onReport;

  const _ChatOptionsSheet({
    required this.seller,
    this.product,
    required this.onViewProfile,
    this.onViewItem,
    required this.onBlock,
    required this.onReport,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(0, 12, 0, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2)),
          ),
          _optionTile(context, Icons.person_outline, 'View Profile',
              onViewProfile),
          if (onViewItem != null)
            _optionTile(context, Icons.inventory_2_outlined, 'View Item',
                onViewItem!),
          _optionTile(context, Icons.notifications_off_outlined,
              'Mute Conversation', () => Navigator.pop(context)),
          const Divider(height: 1),
          _optionTile(context, Icons.block, 'Block User', onBlock,
              color: AppColors.alert),
          _optionTile(context, Icons.flag_outlined, 'Report User', onReport,
              color: const Color(0xFFE07B00)),
        ],
      ),
    );
  }

  Widget _optionTile(
      BuildContext context, IconData icon, String label, VoidCallback onTap,
      {Color? color}) {
    final c = color ?? AppColors.espresso;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label,
          style: GoogleFonts.inter(
              fontSize: 15, fontWeight: FontWeight.w500, color: c)),
      onTap: onTap,
    );
  }
}
