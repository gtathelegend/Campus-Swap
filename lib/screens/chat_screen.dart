import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../data/mock_data.dart';
import 'seller_profile_screen.dart';
import 'product_detail_screen.dart';
import 'report_screen.dart';

class ChatScreen extends StatefulWidget {
  final Seller seller;
  final String? conversationId;
  final Product? product;

  const ChatScreen({super.key, required this.seller, this.conversationId, this.product});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _controller = TextEditingController();
  final _scrollController = ScrollController();
  late List<Message> _messages;
  Product? _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
    final conv = conversations.firstWhere(
      (c) => c.id == widget.conversationId || c.seller.id == widget.seller.id,
      orElse: () => conversations.first,
    );
    _messages = List.from(conv.messages);
    if (_product == null) _product = conv.product;
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _send() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add(Message(id: DateTime.now().toString(), from: 'me', text: text, time: 'Now'));
      _controller.clear();
    });
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
        product: _product,
        onViewProfile: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => SellerProfileScreen(seller: widget.seller)));
        },
        onViewItem: _product != null
            ? () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: _product!)));
              }
            : null,
        onBlock: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('${widget.seller.name} has been blocked'), backgroundColor: AppColors.espresso),
          );
        },
        onReport: () {
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ReportScreen(type: 'user')));
        },
      ),
    );
  }

  void _showMediaUpload() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => _MediaUploadSheet(
        onSelect: (type) {
          Navigator.pop(context);
          setState(() {
            _messages.add(Message(id: DateTime.now().toString(), from: 'me', text: '📎 Photo shared', time: 'Now'));
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: GestureDetector(
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SellerProfileScreen(seller: widget.seller))),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
                child: const Center(child: Text('👤', style: TextStyle(fontSize: 18))),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.seller.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.espresso)),
                  Text('Active now', style: GoogleFonts.inter(fontSize: 11, color: const Color(0xFF4CAF50))),
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
          // Item card at top
          if (_product != null) _buildItemCard(),
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, i) => _bubble(_messages[i]),
            ),
          ),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildItemCard() {
    final p = _product!;
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
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p.name, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                Text('\$${p.price.toStringAsFixed(0)}', style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.gold)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductDetailScreen(product: p))),
            child: Text('View', style: GoogleFonts.inter(fontSize: 13, color: AppColors.gold, fontWeight: FontWeight.w600)),
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
          GestureDetector(
            onTap: _showMediaUpload,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.cream,
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.border),
              ),
              child: const Icon(Icons.image_outlined, color: AppColors.stone, size: 20),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => _send(),
              decoration: const InputDecoration(
                hintText: 'Type a message...',
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: _send,
            child: Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
              child: const Icon(Icons.send_rounded, color: AppColors.espresso, size: 20),
            ),
          ),
        ],
      ),
    );
  }

  Widget _bubble(Message msg) {
    final isMe = msg.from == 'me';
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isMe) ...[
            Container(width: 28, height: 28, decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle), child: const Center(child: Text('👤', style: TextStyle(fontSize: 14)))),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: isMe ? AppColors.gold : AppColors.base,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(16),
                  topRight: const Radius.circular(16),
                  bottomLeft: Radius.circular(isMe ? 16 : 4),
                  bottomRight: Radius.circular(isMe ? 4 : 16),
                ),
                border: isMe ? null : Border.all(color: AppColors.border),
              ),
              child: Column(
                crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(msg.text, style: GoogleFonts.inter(fontSize: 14, color: AppColors.espresso)),
                  const SizedBox(height: 4),
                  Text(msg.time, style: GoogleFonts.inter(fontSize: 10, color: isMe ? AppColors.espresso.withOpacity(0.6) : AppColors.stone)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _categoryEmoji(String cat) {
    switch (cat) {
      case 'Electronics': return '💻';
      case 'Books & Textbooks': return '📚';
      case 'Clothing & Accessories': return '👕';
      case 'Furniture': return '🪑';
      default: return '📦';
    }
  }
}

// ─── Chat Options Bottom Sheet ──────────────────────────────────────────────

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
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
          ),
          _optionTile(context, Icons.person_outline, 'View Profile', onViewProfile),
          if (onViewItem != null)
            _optionTile(context, Icons.inventory_2_outlined, 'View Item', onViewItem!),
          _optionTile(context, Icons.notifications_off_outlined, 'Mute Conversation', () => Navigator.pop(context)),
          const Divider(height: 1),
          _optionTile(context, Icons.block, 'Block User', onBlock, color: AppColors.alert),
          _optionTile(context, Icons.flag_outlined, 'Report User', onReport, color: const Color(0xFFE07B00)),
        ],
      ),
    );
  }

  Widget _optionTile(BuildContext context, IconData icon, String label, VoidCallback onTap, {Color? color}) {
    final c = color ?? AppColors.espresso;
    return ListTile(
      leading: Icon(icon, color: c, size: 22),
      title: Text(label, style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w500, color: c)),
      onTap: onTap,
    );
  }
}

// ─── Media Upload Bottom Sheet ───────────────────────────────────────────────

class _MediaUploadSheet extends StatelessWidget {
  final void Function(String type) onSelect;

  const _MediaUploadSheet({required this.onSelect});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 40),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2)),
          ),
          Text('Share Media', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _mediaOption(context, Icons.camera_alt_outlined, 'Camera', 'camera'),
              _mediaOption(context, Icons.image_outlined, 'Gallery', 'gallery'),
              _mediaOption(context, Icons.insert_drive_file_outlined, 'Files', 'files'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _mediaOption(BuildContext context, IconData icon, String label, String type) {
    return GestureDetector(
      onTap: () => onSelect(type),
      child: Column(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, color: AppColors.espresso, size: 28),
          ),
          const SizedBox(height: 8),
          Text(label, style: GoogleFonts.inter(fontSize: 13, color: AppColors.espresso)),
        ],
      ),
    );
  }
}
