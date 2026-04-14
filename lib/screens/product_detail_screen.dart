import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../services/product_service.dart';
import '../services/message_service.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../widgets/product_card.dart';
import 'seller_profile_screen.dart';
import 'chat_screen.dart';
import 'report_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;

  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final _productService = ProductService();
  final _messageService = MessageService();

  bool _saved = false;
  bool _savingInProgress = false;
  int _currentImageIndex = 0;

  @override
  void initState() {
    super.initState();
    _saved = widget.product.isSaved;
    _checkSavedStatus();
  }

  Future<void> _checkSavedStatus() async {
    try {
      final savedIds = await _productService.getSavedProductIds();
      if (mounted) {
        setState(() => _saved = savedIds.contains(widget.product.id));
      }
    } catch (_) {}
  }

  Future<void> _toggleSave() async {
    if (_savingInProgress) return;
    setState(() => _savingInProgress = true);
    try {
      final nowSaved = await _productService.toggleSave(widget.product.id);
      if (mounted) setState(() => _saved = nowSaved);
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to save item'),
              backgroundColor: AppColors.alert),
        );
      }
    } finally {
      if (mounted) setState(() => _savingInProgress = false);
    }
  }

  Future<void> _contactSeller() async {
    final auth = context.read<AuthProvider>();
    if (!auth.isLoggedIn) return;

    // Don't allow messaging yourself
    if (auth.currentUserId == widget.product.seller.id) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('This is your own listing'),
            backgroundColor: AppColors.espresso),
      );
      return;
    }

    try {
      final convId = await _messageService.getOrCreateConversation(
        sellerId: widget.product.seller.id,
        productId: widget.product.id,
      );
      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ChatScreen(
              seller: widget.product.seller,
              conversationId: convId,
              product: widget.product,
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Failed to open chat'),
              backgroundColor: AppColors.alert),
        );
      }
    }
  }

  String _categoryEmoji() {
    switch (widget.product.category) {
      case 'Electronics':
        return '💻';
      case 'Books & Textbooks':
        return '📚';
      case 'Clothing & Accessories':
        return '👕';
      case 'Sports & Outdoors':
        return '⚽';
      case 'Kitchen & Dining':
        return '🍴';
      case 'Furniture':
        return '🪑';
      case 'Home Decor':
        return '🏠';
      default:
        return '📦';
    }
  }

  Color _conditionColor() =>
      AppColors.conditionColors[widget.product.condition] ?? AppColors.stone;

  void _showSafetyTips() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const _SafetyTipsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final hasImages = product.imageUrls.isNotEmpty;
    final auth = context.watch<AuthProvider>();
    final isOwner = auth.currentUserId == product.seller.id;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            backgroundColor: AppColors.base,
            leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                margin: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                    color: AppColors.base, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new,
                    size: 18, color: AppColors.espresso),
              ),
            ),
            actions: [
              if (!isOwner)
                GestureDetector(
                  onTap: _toggleSave,
                  child: Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                        color: AppColors.base, shape: BoxShape.circle),
                    child: _savingInProgress
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: AppColors.gold))
                        : Icon(
                            _saved ? Icons.favorite : Icons.favorite_border,
                            color: _saved ? AppColors.alert : AppColors.espresso,
                            size: 20),
                  ),
                ),
              PopupMenuButton<String>(
                icon: Container(
                  margin: const EdgeInsets.only(right: 8, top: 8, bottom: 8),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: AppColors.base, shape: BoxShape.circle),
                  child: const Icon(Icons.more_horiz,
                      color: AppColors.espresso, size: 20),
                ),
                onSelected: (v) {
                  if (v == 'report') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => ReportScreen(
                                type: 'listing',
                                reportedId: widget.product.id)));
                  }
                },
                itemBuilder: (_) => [
                  const PopupMenuItem(
                      value: 'report', child: Text('Report listing')),
                ],
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: hasImages
                  ? Stack(
                      children: [
                        PageView.builder(
                          itemCount: product.imageUrls.length,
                          onPageChanged: (i) =>
                              setState(() => _currentImageIndex = i),
                          itemBuilder: (_, i) => Image.network(
                            product.imageUrls[i],
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              color: AppColors.cream,
                              child: Center(
                                  child: Text(_categoryEmoji(),
                                      style:
                                          const TextStyle(fontSize: 80))),
                            ),
                          ),
                        ),
                        if (product.imageUrls.length > 1)
                          Positioned(
                            bottom: 12,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                product.imageUrls.length,
                                (i) => Container(
                                  width: 6,
                                  height: 6,
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 3),
                                  decoration: BoxDecoration(
                                    color: i == _currentImageIndex
                                        ? AppColors.gold
                                        : Colors.white.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    )
                  : Container(
                      color: AppColors.cream,
                      child: Center(
                          child: Text(_categoryEmoji(),
                              style: const TextStyle(fontSize: 80))),
                    ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          child: Text(product.name,
                              style: Theme.of(context).textTheme.titleLarge)),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: _conditionColor().withOpacity(0.12),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(product.condition,
                            style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: _conditionColor())),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('₹${product.price.toStringAsFixed(0)}',
                      style: GoogleFonts.manrope(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: AppColors.espresso)),
                  if (product.isNegotiable) ...[
                    const SizedBox(height: 4),
                    Text('Price negotiable',
                        style: GoogleFonts.inter(
                            fontSize: 12,
                            color: AppColors.gold,
                            fontWeight: FontWeight.w500)),
                  ],
                  const SizedBox(height: 16),
                  _infoRow(Icons.location_on_outlined, product.location),
                  const SizedBox(height: 8),
                  _infoRow(Icons.category_outlined, product.category),
                  const SizedBox(height: 8),
                  _infoRow(Icons.access_time_outlined, product.listedAt),
                  const Divider(height: 32),
                  Text('Description',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(product.description,
                      style: Theme.of(context).textTheme.bodyLarge),
                  const Divider(height: 32),
                  Text('Seller',
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  GestureDetector(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) =>
                                SellerProfileScreen(seller: product.seller))),
                    child: Row(
                      children: [
                        _sellerAvatar(product.seller),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(product.seller.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium),
                                  if (product.seller.verified) ...[
                                    const SizedBox(width: 6),
                                    const Icon(Icons.verified,
                                        size: 16, color: AppColors.gold),
                                  ],
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 14, color: AppColors.gold),
                                  const SizedBox(width: 4),
                                  Text(
                                      '${product.seller.rating.toStringAsFixed(1)} · ${product.seller.reviews} reviews',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const Icon(Icons.chevron_right, color: AppColors.stone),
                      ],
                    ),
                  ),
                  const Divider(height: 32),
                  GestureDetector(
                    onTap: _showSafetyTips,
                    child: Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.gold.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shield_outlined,
                              color: AppColors.gold, size: 20),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Safety Tips',
                                    style: GoogleFonts.inter(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.espresso)),
                                Text('Stay safe when buying & selling',
                                    style: GoogleFonts.inter(
                                        fontSize: 12,
                                        color: AppColors.stone)),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right,
                              color: AppColors.stone, size: 20),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
      ),
      bottomSheet: isOwner
          ? null
          : Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
              decoration: const BoxDecoration(
                color: AppColors.base,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Contact Seller'),
                  onPressed: _contactSeller,
                ),
              ),
            ),
    );
  }

  Widget _sellerAvatar(Seller seller) {
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
              fontWeight: FontWeight.w700, color: AppColors.gold, fontSize: 18),
        ),
      ),
    );
  }

  Widget _infoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.stone),
        const SizedBox(width: 6),
        Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium)),
      ],
    );
  }
}

class _SafetyTipsSheet extends StatelessWidget {
  const _SafetyTipsSheet();

  @override
  Widget build(BuildContext context) {
    final tips = [
      (Icons.public, 'Meet in Public',
          'Choose a safe, public location like a campus library or student center.'),
      (Icons.search, 'Inspect Before Buying',
          'Always examine items carefully before completing the transaction.'),
      (Icons.payment, 'Use Safe Payment',
          'Prefer in-person cash or verified payment apps. Avoid wire transfers.'),
      (Icons.people, 'Trust Your Instincts',
          'If something feels wrong, it probably is. Don\'t proceed with the deal.'),
      (Icons.phone_android, 'Keep Communication on App',
          'Use in-app messaging to keep a record of all communications.'),
      (Icons.privacy_tip, 'Protect Your Privacy',
          'Never share personal info like your home address or financial details.'),
    ];

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              const Icon(Icons.shield, color: AppColors.gold, size: 24),
              const SizedBox(width: 10),
              Text('Safety Tips',
                  style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          Text('Stay safe when buying & selling',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 20),
          ...tips.map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.gold.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(tip.$1, color: AppColors.gold, size: 18),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(tip.$2,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.espresso)),
                          const SizedBox(height: 2),
                          Text(tip.$3,
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.stone)),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
