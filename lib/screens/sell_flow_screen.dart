import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class SellFlowScreen extends StatefulWidget {
  const SellFlowScreen({super.key});

  @override
  State<SellFlowScreen> createState() => _SellFlowScreenState();
}

class _SellFlowScreenState extends State<SellFlowScreen> {
  int _step = 0;
  static const int _totalSteps = 9;

  // Step data
  int _photoCount = 0;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String? _category;
  String? _condition;
  final _priceController = TextEditingController();
  bool _isNegotiable = true;
  final _minOfferController = TextEditingController();
  String? _location;
  bool _published = false;

  static const _conditions = [
    ('New', 'Never used, in original packaging'),
    ('Like New', 'Minimal use, no visible wear'),
    ('Excellent', 'Light use, very minor wear'),
    ('Good', 'Normal use, some visible wear'),
    ('Fair', 'Heavily used, significant wear'),
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _minOfferController.dispose();
    super.dispose();
  }

  void _next() {
    if (_step < _totalSteps - 1) {
      setState(() => _step++);
    } else {
      setState(() => _published = true);
    }
  }

  void _back() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.pop(context);
    }
  }

  String get _stepTitle {
    switch (_step) {
      case 0: return 'Add Photos';
      case 1: return 'Item Details';
      case 2: return 'Category';
      case 3: return 'Condition';
      case 4: return 'Set Price';
      case 5: return 'Price Options';
      case 6: return 'Pickup Location';
      case 7: return 'Confirm Location';
      case 8: return 'Preview';
      default: return '';
    }
  }

  bool get _canContinue {
    switch (_step) {
      case 0: return _photoCount > 0;
      case 1: return _titleController.text.trim().isNotEmpty;
      case 2: return _category != null;
      case 3: return _condition != null;
      case 4: return _priceController.text.isNotEmpty && double.tryParse(_priceController.text) != null && double.parse(_priceController.text) > 0;
      case 5: return true;
      case 6: return _location != null;
      case 7: return true;
      case 8: return true;
      default: return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_published) return _buildPublishedScreen();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: _back,
        ),
        title: Text(_stepTitle, style: Theme.of(context).textTheme.titleLarge),
        actions: _step == 1
            ? [
                TextButton(
                  onPressed: _next,
                  child: Text('Skip', style: GoogleFonts.inter(color: AppColors.stone, fontSize: 14)),
                )
              ]
            : _step == 8
                ? [
                    TextButton(
                      onPressed: () {},
                      child: Text('Edit', style: GoogleFonts.inter(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w600)),
                    )
                  ]
                : null,
      ),
      body: Column(
        children: [
          // Progress bar
          LinearProgressIndicator(
            value: (_step + 1) / _totalSteps,
            backgroundColor: AppColors.border,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
            minHeight: 3,
          ),
          Expanded(child: _buildStep()),
          _buildContinueButton(),
        ],
      ),
    );
  }

  Widget _buildStep() {
    switch (_step) {
      case 0: return _buildAddPhotos();
      case 1: return _buildItemDetails();
      case 2: return _buildCategory();
      case 3: return _buildCondition();
      case 4: return _buildSetPrice();
      case 5: return _buildPriceOptions();
      case 6: return _buildPickupLocation();
      case 7: return _buildConfirmLocation();
      case 8: return _buildPreview();
      default: return const SizedBox();
    }
  }

  // ─── Step 0: Add Photos ───────────────────────────────────────────────────
  Widget _buildAddPhotos() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Add up to 8 photos', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: 8,
            itemBuilder: (context, i) {
              if (i < _photoCount) {
                return _photoSlotFilled(i);
              } else if (i == _photoCount) {
                return _photoSlotAdd();
              } else {
                return _photoSlotEmpty();
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _photoSlotFilled(int i) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: AppColors.gold.withOpacity(0.15),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppColors.gold.withOpacity(0.4)),
          ),
          child: const Center(child: Text('🖼️', style: TextStyle(fontSize: 32))),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: GestureDetector(
            onTap: () => setState(() => _photoCount--),
            child: Container(
              width: 22,
              height: 22,
              decoration: const BoxDecoration(color: AppColors.alert, shape: BoxShape.circle),
              child: const Icon(Icons.close, size: 14, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget _photoSlotAdd() {
    return GestureDetector(
      onTap: () => setState(() => _photoCount++),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.base,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add, color: AppColors.stone, size: 28),
            const SizedBox(height: 4),
            Text('Add Photo', style: GoogleFonts.inter(fontSize: 11, color: AppColors.stone)),
          ],
        ),
      ),
    );
  }

  Widget _photoSlotEmpty() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.base,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
    );
  }

  // ─── Step 1: Item Details ─────────────────────────────────────────────────
  Widget _buildItemDetails() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.gold.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt_outlined, color: AppColors.gold, size: 28),
            ),
          ),
          const SizedBox(height: 24),
          _label('Title *'),
          const SizedBox(height: 8),
          TextField(
            controller: _titleController,
            maxLength: 90,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'e.g. iPhone 13 Pro - Like New',
              counterText: '',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${_titleController.text.length}/90', style: GoogleFonts.inter(fontSize: 11, color: AppColors.stone)),
          ),
          const SizedBox(height: 20),
          _label('Description *'),
          const SizedBox(height: 8),
          TextField(
            controller: _descController,
            maxLines: 5,
            maxLength: 500,
            onChanged: (_) => setState(() {}),
            decoration: const InputDecoration(
              hintText: 'Describe your item, its condition, and any relevant details...',
              counterText: '',
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Text('${_descController.text.length}/500', style: GoogleFonts.inter(fontSize: 11, color: AppColors.stone)),
          ),
        ],
      ),
    );
  }

  // ─── Step 2: Category ─────────────────────────────────────────────────────
  Widget _buildCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text('Select a category for your item', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: sellCategories.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final cat = sellCategories[i];
              final selected = _category == cat.name;
              return GestureDetector(
                onTap: () => setState(() => _category = cat.name),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.espresso : AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.espresso : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Text(cat.emoji, style: const TextStyle(fontSize: 22)),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Text(
                          cat.name,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: selected ? AppColors.base : AppColors.espresso,
                          ),
                        ),
                      ),
                      if (selected) const Icon(Icons.check, color: AppColors.base, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Step 3: Condition ────────────────────────────────────────────────────
  Widget _buildCondition() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text('What condition is your item in?', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: _conditions.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final (name, desc) = _conditions[i];
              final selected = _condition == name;
              return GestureDetector(
                onTap: () => setState(() => _condition = name),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.espresso : AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.espresso : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: GoogleFonts.inter(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: selected ? AppColors.base : AppColors.espresso,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              desc,
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: selected ? AppColors.base.withOpacity(0.7) : AppColors.stone,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: selected ? AppColors.gold : AppColors.border,
                            width: 2,
                          ),
                          color: selected ? AppColors.gold : Colors.transparent,
                        ),
                        child: selected ? const Icon(Icons.check, size: 12, color: AppColors.espresso) : null,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Step 4: Set Price ────────────────────────────────────────────────────
  Widget _buildSetPrice() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How much would you like to sell for?', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                Text('Price', style: GoogleFonts.inter(fontSize: 13, color: AppColors.stone)),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Text('\$', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w700, color: AppColors.espresso)),
                    IntrinsicWidth(
                      child: TextField(
                        controller: _priceController,
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        onChanged: (_) => setState(() {}),
                        textAlign: TextAlign.center,
                        style: GoogleFonts.manrope(fontSize: 40, fontWeight: FontWeight.w800, color: AppColors.espresso),
                        decoration: const InputDecoration(
                          hintText: '0',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          filled: false,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Suggested Price Range', style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                      const SizedBox(height: 4),
                      Text('Similar Items', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                      const SizedBox(height: 4),
                      Text('\$750 – \$900', style: GoogleFonts.manrope(fontSize: 14, fontWeight: FontWeight.w700, color: AppColors.gold)),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _priceController.text = '825';
                    setState(() {});
                  },
                  child: Text('Use Average', style: GoogleFonts.inter(fontSize: 13, color: AppColors.gold, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 5: Price Options ────────────────────────────────────────────────
  Widget _buildPriceOptions() {
    final price = _priceController.text.isNotEmpty ? _priceController.text : '0';
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set your pricing preferences', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Your Price', style: GoogleFonts.inter(fontSize: 13, color: AppColors.stone)),
                const SizedBox(height: 4),
                Text('\$$price', style: GoogleFonts.manrope(fontSize: 28, fontWeight: FontWeight.w800, color: AppColors.gold)),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: AppColors.base,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price Negotiable', style: GoogleFonts.inter(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                      Text('Allow buyers to make offers', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                    ],
                  ),
                ),
                Switch(
                  value: _isNegotiable,
                  onChanged: (v) => setState(() => _isNegotiable = v),
                  activeColor: AppColors.gold,
                ),
              ],
            ),
          ),
          if (_isNegotiable) ...[
            const SizedBox(height: 16),
            Text('Minimum Offer (Optional)', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso)),
            const SizedBox(height: 8),
            TextField(
              controller: _minOfferController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                hintText: '700',
                prefixText: '\$ ',
              ),
            ),
            const SizedBox(height: 8),
            Text('Offers below this will be automatically declined', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
          ],
        ],
      ),
    );
  }

  // ─── Step 6: Pickup Location ──────────────────────────────────────────────
  Widget _buildPickupLocation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Text('Where can buyers pick up the item?', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: campusLocations.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (context, i) {
              final loc = campusLocations[i];
              final selected = _location == loc;
              final isCustom = loc == 'Custom Location';
              return GestureDetector(
                onTap: () => setState(() => _location = loc),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.espresso : AppColors.base,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: selected ? AppColors.espresso : AppColors.border),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isCustom ? Icons.edit_location_alt_outlined : Icons.location_on_outlined,
                        color: selected ? AppColors.base : AppColors.stone,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          loc,
                          style: GoogleFonts.inter(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: selected ? AppColors.base : AppColors.espresso,
                          ),
                        ),
                      ),
                      if (selected) const Icon(Icons.check, color: AppColors.base, size: 20),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ─── Step 7: Confirm Location ─────────────────────────────────────────────
  Widget _buildConfirmLocation() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
            child: Text('Verify your pickup location', style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone)),
          ),
          const SizedBox(height: 16),
          // Map placeholder
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAD8),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              children: [
                // Map grid lines
                CustomPaint(painter: _MapGridPainter(), size: const Size(double.infinity, 220)),
                // Pin
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(color: AppColors.gold, shape: BoxShape.circle),
                        child: const Icon(Icons.location_on, color: AppColors.espresso, size: 22),
                      ),
                      CustomPaint(
                        painter: _PinTailPainter(),
                        size: const Size(10, 8),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.gold.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.location_on, color: AppColors.gold, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(_location ?? 'No location selected', style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                      Text('123 Campus Drive, Building A', style: GoogleFonts.inter(fontSize: 12, color: AppColors.stone)),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Step 8: Preview ──────────────────────────────────────────────────────
  Widget _buildPreview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Item image
          Container(
            width: double.infinity,
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.cream,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: const Center(child: Text('🖼️', style: TextStyle(fontSize: 60))),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _titleController.text.isNotEmpty ? _titleController.text : 'Item Title',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_priceController.text.isNotEmpty ? _priceController.text : '0'}',
                      style: GoogleFonts.manrope(fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.espresso),
                    ),
                  ],
                ),
              ),
              if (_condition != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(_condition!, style: GoogleFonts.inter(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.gold)),
                ),
            ],
          ),
          const Divider(height: 28),
          Text('Description', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            _descController.text.isNotEmpty ? _descController.text : 'No description provided.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const Divider(height: 28),
          _previewRow('Category', _category ?? 'Not selected'),
          const SizedBox(height: 8),
          _previewRow('Condition', _condition ?? 'Not selected'),
          const SizedBox(height: 8),
          _previewRow('Location', _location ?? 'Not selected'),
          const SizedBox(height: 8),
          _previewRow('Negotiable', _isNegotiable ? 'Yes' : 'No'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _previewRow(String key, String value) {
    return Row(
      children: [
        Expanded(child: Text(key, style: GoogleFonts.inter(fontSize: 14, color: AppColors.stone))),
        Text(value, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.espresso)),
      ],
    );
  }

  // ─── Continue Button ──────────────────────────────────────────────────────
  Widget _buildContinueButton() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      decoration: const BoxDecoration(
        color: AppColors.base,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
          icon: _step == 8 ? const Icon(Icons.public, size: 18) : const SizedBox.shrink(),
          label: Text(_step == 8 ? 'Publish Listing' : 'Continue'),
          onPressed: _canContinue ? _next : null,
          style: ElevatedButton.styleFrom(
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.stone,
          ),
        ),
      ),
    );
  }

  // ─── Published Screen ─────────────────────────────────────────────────────
  Widget _buildPublishedScreen() {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.gold.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle_outline, color: AppColors.gold, size: 52),
                ),
                const SizedBox(height: 28),
                Text('Listing Published!', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('Your item is now live and visible to buyers.', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back to Home'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        _step = 0;
                        _photoCount = 0;
                        _titleController.clear();
                        _descController.clear();
                        _category = null;
                        _condition = null;
                        _priceController.clear();
                        _minOfferController.clear();
                        _location = null;
                        _isNegotiable = true;
                        _published = false;
                      });
                    },
                    child: const Text('List Another Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso));
}

// Simple map grid painter
class _MapGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFD8DACE)
      ..strokeWidth = 1;
    for (double x = 0; x < size.width; x += 40) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += 40) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // Draw a "road"
    final roadPaint = Paint()..color = Colors.white..strokeWidth = 18;
    canvas.drawLine(Offset(0, size.height * 0.55), Offset(size.width, size.height * 0.55), roadPaint);
    canvas.drawLine(Offset(size.width * 0.45, 0), Offset(size.width * 0.45, size.height), roadPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinTailPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.gold;
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width / 2, size.height)
      ..close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
