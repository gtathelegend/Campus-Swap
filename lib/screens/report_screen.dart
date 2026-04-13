import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';

class ReportScreen extends StatefulWidget {
  final String type; // 'listing' or 'user'

  const ReportScreen({super.key, required this.type});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  String? _selected;
  final _detailsController = TextEditingController();
  bool _submitted = false;

  final _options = [
    'Inappropriate content',
    'Spam or misleading',
    'Prohibited item',
    'Fake listing',
    'Price manipulation',
    'Other',
  ];

  @override
  void dispose() {
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_submitted) {
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
                  Text('Report submitted', style: Theme.of(context).textTheme.displayMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 12),
                  Text('We will review it within 24 hours', style: Theme.of(context).textTheme.bodyMedium, textAlign: TextAlign.center),
                  const SizedBox(height: 40),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Go Back'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Report ${widget.type == 'listing' ? 'Listing' : 'User'}', style: Theme.of(context).textTheme.titleLarge),
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios_new, size: 20), onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.alert.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: AppColors.alert.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_outlined, color: AppColors.alert, size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'False reports may result in account suspension.',
                            style: GoogleFonts.inter(fontSize: 13, color: AppColors.alert),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text('Reason', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 12),
                  ..._options.map((opt) => RadioListTile<String>(
                    value: opt,
                    groupValue: _selected,
                    activeColor: AppColors.gold,
                    contentPadding: EdgeInsets.zero,
                    title: Text(opt, style: GoogleFonts.inter(fontSize: 14, color: AppColors.espresso)),
                    onChanged: (v) => setState(() => _selected = v),
                  )),
                  const SizedBox(height: 20),
                  Text('Additional details (optional)', style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  TextField(
                    controller: _detailsController,
                    maxLines: 4,
                    decoration: const InputDecoration(hintText: 'Describe the issue...'),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _selected != null ? () => setState(() => _submitted = true) : null,
                  style: ElevatedButton.styleFrom(
                    disabledBackgroundColor: AppColors.border,
                    disabledForegroundColor: AppColors.stone,
                  ),
                  child: const Text('Submit Report'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
