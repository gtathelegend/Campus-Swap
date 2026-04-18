import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/brand_title.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';

class FiltersScreen extends StatefulWidget {
  final String? activeCategory;
  final String? activeCondition;
  final double maxPrice;

  const FiltersScreen({super.key, this.activeCategory, this.activeCondition, this.maxPrice = 5000});

  @override
  State<FiltersScreen> createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  String? _category;
  String? _condition;
  late double _maxPrice;

  final _conditions = ['New', 'Like New', 'Excellent', 'Good', 'Fair'];

  @override
  void initState() {
    super.initState();
    _category = widget.activeCategory;
    _condition = widget.activeCondition;
    _maxPrice = widget.maxPrice;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: const BrandTitle('Filters'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () => setState(() { _category = null; _condition = null; _maxPrice = 5000; }),
            child: Text('Reset', style: GoogleFonts.inter(color: AppColors.mocha, fontSize: 14)),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text('Category', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: categories.map((cat) {
                      final selected = _category == cat.name;
                      return GestureDetector(
                        onTap: () => setState(() => _category = selected ? null : cat.name),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.gold : AppColors.base,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: selected ? AppColors.gold : AppColors.border),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(cat.emoji, style: const TextStyle(fontSize: 16)),
                              const SizedBox(width: 6),
                              Text(cat.name, style: GoogleFonts.inter(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: selected ? AppColors.espresso : AppColors.mocha,
                              )),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 28),
                  Text('Max Price: ₹${_maxPrice.toInt()}', style: Theme.of(context).textTheme.titleMedium),
                  SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: AppColors.gold,
                      thumbColor: AppColors.gold,
                      inactiveTrackColor: AppColors.border,
                      overlayColor: AppColors.gold.withOpacity(0.2),
                    ),
                    child: Slider(
                      value: _maxPrice,
                      min: 100,
                      max: 5000,
                      divisions: 49,
                      onChanged: (v) => setState(() => _maxPrice = v),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('₹100', style: GoogleFonts.inter(color: AppColors.stone, fontSize: 12)),
                      Text('₹5000', style: GoogleFonts.inter(color: AppColors.stone, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 28),
                  Text('Condition', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: _conditions.map((cond) {
                      final selected = _condition == cond;
                      return GestureDetector(
                        onTap: () => setState(() => _condition = selected ? null : cond),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                          decoration: BoxDecoration(
                            color: selected ? AppColors.gold : AppColors.base,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: selected ? AppColors.gold : AppColors.border),
                          ),
                          child: Text(cond, style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: selected ? AppColors.espresso : AppColors.mocha,
                          )),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context, {
                    'category': _category,
                    'condition': _condition,
                    'maxPrice': _maxPrice,
                  }),
                  child: const Text('Apply Filters'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
