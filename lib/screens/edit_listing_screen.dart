import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';
import '../services/product_service.dart';

class EditListingScreen extends StatefulWidget {
  final Product product;

  const EditListingScreen({super.key, required this.product});

  @override
  State<EditListingScreen> createState() => _EditListingScreenState();
}

class _EditListingScreenState extends State<EditListingScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _descController;
  late final TextEditingController _priceController;
  late String _condition;
  late bool _isNegotiable;
  bool _saving = false;
  final _productService = ProductService();

  static const _conditions = ['New', 'Like New', 'Excellent', 'Good', 'Fair'];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.product.name);
    _descController = TextEditingController(text: widget.product.description);
    _priceController = TextEditingController(text: widget.product.price.toStringAsFixed(0));
    _condition = widget.product.condition;
    _isNegotiable = widget.product.isNegotiable;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final price = double.tryParse(_priceController.text.trim());
    if (price == null || _titleController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in title and price'), backgroundColor: AppColors.alert),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await _productService.updateProduct(
        widget.product.id,
        name: _titleController.text.trim(),
        description: _descController.text.trim(),
        price: price,
        condition: _condition,
        isNegotiable: _isNegotiable,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Listing updated successfully'), backgroundColor: AppColors.espresso),
        );
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to update listing'), backgroundColor: AppColors.alert),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Edit Listing', style: Theme.of(context).textTheme.titleLarge),
        actions: [
          TextButton(
            onPressed: _saving ? null : _save,
            child: _saving
                ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.gold))
                : Text('Save', style: GoogleFonts.inter(color: AppColors.gold, fontSize: 14, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _label('Title'),
          const SizedBox(height: 8),
          TextField(controller: _titleController, onChanged: (_) => setState(() {})),
          const SizedBox(height: 20),

          _label('Description'),
          const SizedBox(height: 8),
          TextField(controller: _descController, maxLines: 4),
          const SizedBox(height: 20),

          _label('Price'),
          const SizedBox(height: 8),
          TextField(
            controller: _priceController,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(prefixText: '₹ '),
          ),
          const SizedBox(height: 20),

          _label('Condition'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: _conditions.map((c) {
              final selected = _condition == c;
              return GestureDetector(
                onTap: () => setState(() => _condition = c),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.espresso : AppColors.base,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: selected ? AppColors.espresso : AppColors.border),
                  ),
                  child: Text(c, style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w500, color: selected ? AppColors.base : AppColors.mocha)),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 20),

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
          const SizedBox(height: 32),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                  : const Text('Save Changes'),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _label(String text) => Text(text, style: GoogleFonts.inter(fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.espresso));
}
