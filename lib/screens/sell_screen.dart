import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class SellScreen extends StatefulWidget {
  const SellScreen({super.key});

  @override
  State<SellScreen> createState() => _SellScreenState();
}

class _SellScreenState extends State<SellScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _priceController = TextEditingController();
  String? _condition;
  String? _category;
  bool _success = false;
  int _photoCount = 0;

  final _conditions = ['New', 'Like New', 'Good', 'Fair'];

  bool get _canPost => _titleController.text.isNotEmpty && _priceController.text.isNotEmpty;

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_success) return _buildSuccess();
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('List an Item', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            // Photo picker
            Text('Photos', style: _label()),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  ...List.generate(_photoCount, (i) => _photoThumbnail(i)),
                  if (_photoCount < 5) _addPhotoButton(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text('Item Name *', style: _label()),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: 'e.g. Calculus Textbook'),
            ),
            const SizedBox(height: 20),
            Text('Description', style: _label()),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 4,
              decoration: const InputDecoration(hintText: 'Describe your item...'),
            ),
            const SizedBox(height: 20),
            Text('Price (₹) *', style: _label()),
            const SizedBox(height: 8),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              onChanged: (_) => setState(() {}),
              decoration: const InputDecoration(hintText: '0', prefixText: '₹ '),
            ),
            const SizedBox(height: 20),
            Text('Condition', style: _label()),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: _conditions.map((c) {
                final selected = _condition == c;
                return GestureDetector(
                  onTap: () => setState(() => _condition = c),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: selected ? AppColors.gold : AppColors.base,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: selected ? AppColors.gold : AppColors.border),
                    ),
                    child: Text(c, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? AppColors.espresso : AppColors.mocha)),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),
            Text('Category', style: _label()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: AppColors.base,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.border),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _category,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text('Select category', style: GoogleFonts.inter(color: AppColors.stone, fontSize: 14)),
                  ),
                  isExpanded: true,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  items: categories.map((cat) => DropdownMenuItem(
                    value: cat.name,
                    child: Text('${cat.emoji}  ${cat.name}'),
                  )).toList(),
                  onChanged: (v) => setState(() => _category = v),
                ),
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canPost ? () => setState(() => _success = true) : null,
                style: ElevatedButton.styleFrom(
                  disabledBackgroundColor: AppColors.border,
                  disabledForegroundColor: AppColors.stone,
                ),
                child: const Text('Post Item'),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess() {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(32),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('✅', style: TextStyle(fontSize: 64)),
                const SizedBox(height: 24),
                Text('Item Posted!', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                const SizedBox(height: 12),
                Text('Your listing is now live', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => setState(() { _success = false; _titleController.clear(); _priceController.clear(); _descController.clear(); _condition = null; _category = null; _photoCount = 0; }),
                    child: const Text('Post Another Item'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _photoThumbnail(int i) {
    return Container(
      width: 80,
      height: 80,
      margin: const EdgeInsets.only(right: 10),
      decoration: BoxDecoration(
        color: AppColors.gold.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.gold.withOpacity(0.4)),
      ),
      child: Stack(
        children: [
          const Center(child: Text('🖼️', style: TextStyle(fontSize: 28))),
          Positioned(
            top: 2,
            right: 2,
            child: GestureDetector(
              onTap: () => setState(() => _photoCount--),
              child: Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(color: AppColors.alert, shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addPhotoButton() {
    return GestureDetector(
      onTap: () => setState(() => _photoCount++),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: AppColors.base,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.border, style: BorderStyle.solid),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.add_a_photo_outlined, color: AppColors.stone, size: 24),
            const SizedBox(height: 4),
            Text('${_photoCount}/5', style: GoogleFonts.inter(fontSize: 10, color: AppColors.stone)),
          ],
        ),
      ),
    );
  }

  TextStyle _label() => GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso);
}
