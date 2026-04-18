import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/brand_title.dart';
import '../services/profile_service.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class BlockedUsersScreen extends StatefulWidget {
  const BlockedUsersScreen({super.key});

  @override
  State<BlockedUsersScreen> createState() => _BlockedUsersScreenState();
}

class _BlockedUsersScreenState extends State<BlockedUsersScreen> {
  final _profileService = ProfileService();
  late Future<List<BlockedUser>> _blockedFuture;

  @override
  void initState() {
    super.initState();
    _blockedFuture = _profileService.getBlockedUsers();
  }

  void _refresh() {
    setState(() => _blockedFuture = _profileService.getBlockedUsers());
  }

  void _unblock(BlockedUser user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.base,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Unblock ${user.name}?',
            style: Theme.of(context).textTheme.titleMedium),
        content: Text(
            'They will be able to see your listings and message you again.',
            style: Theme.of(context).textTheme.bodyMedium),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await _profileService.unblockUser(user.id);
                if (mounted) {
                  _refresh();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('${user.name} unblocked'),
                        backgroundColor: AppColors.espresso),
                  );
                }
              } catch (_) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Failed to unblock user'),
                        backgroundColor: AppColors.alert),
                  );
                }
              }
            },
            child: Text('Unblock',
                style: GoogleFonts.inter(
                    color: AppColors.gold, fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.base,
        leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, size: 20),
            onPressed: () => Navigator.pop(context)),
        title: const BrandTitle('Blocked Users'),
      ),
      body: FutureBuilder<List<BlockedUser>>(
        future: _blockedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: AppColors.gold));
          }
          final blocked = snapshot.data ?? [];
          if (blocked.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.block,
                        size: 48, color: AppColors.stone),
                    const SizedBox(height: 16),
                    Text('No blocked users',
                        style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    Text('Users you block will appear here.',
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center),
                  ],
                ),
              ),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.espresso.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  'Blocked users can no longer see your listings or message you.',
                  style: GoogleFonts.inter(
                      fontSize: 13, color: AppColors.mocha),
                ),
              ),
              Text('Managed Accounts',
                  style: GoogleFonts.inter(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.stone)),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.base,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.border),
                ),
                child: Column(
                  children: blocked.asMap().entries.map((entry) {
                    final i = entry.key;
                    final user = entry.value;
                    final initial = user.name.isNotEmpty
                        ? user.name[0].toUpperCase()
                        : '?';
                    return Column(
                      children: [
                        ListTile(
                          leading: Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                                color: AppColors.gold.withOpacity(0.15),
                                shape: BoxShape.circle),
                            child: Center(
                              child: Text(initial,
                                  style: GoogleFonts.manrope(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.gold,
                                      fontSize: 18)),
                            ),
                          ),
                          title: Text(user.name,
                              style: GoogleFonts.inter(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.espresso)),
                          subtitle: Text('Blocked ${user.blockedAt}',
                              style: GoogleFonts.inter(
                                  fontSize: 12, color: AppColors.stone)),
                          trailing: OutlinedButton(
                            onPressed: () => _unblock(user),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              side: const BorderSide(
                                  color: AppColors.border),
                              minimumSize: Size.zero,
                              tapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text('Unblock',
                                style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.espresso)),
                          ),
                        ),
                        if (i < blocked.length - 1)
                          const Divider(height: 1, indent: 72),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
