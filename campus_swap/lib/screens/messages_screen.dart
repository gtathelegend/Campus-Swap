import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_theme.dart';
import '../data/mock_data.dart';
import 'chat_screen.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final filtered = conversations.where((c) =>
      _query.isEmpty || c.seller.name.toLowerCase().contains(_query.toLowerCase())).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        title: Text('Messages', style: Theme.of(context).textTheme.titleLarge),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
              child: TextField(
                onChanged: (v) => setState(() => _query = v),
                decoration: const InputDecoration(
                  hintText: 'Search messages...',
                  prefixIcon: Icon(Icons.search, color: AppColors.stone, size: 20),
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.only(bottom: 80),
                itemCount: filtered.length,
                separatorBuilder: (_, __) => const Divider(indent: 76, height: 1),
                itemBuilder: (context, i) {
                  final conv = filtered[i];
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), shape: BoxShape.circle),
                      child: const Center(child: Text('👤', style: TextStyle(fontSize: 22))),
                    ),
                    title: Text(conv.seller.name, style: GoogleFonts.manrope(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.espresso)),
                    subtitle: Text(conv.lastMessage, maxLines: 1, overflow: TextOverflow.ellipsis, style: GoogleFonts.inter(fontSize: 13, color: AppColors.stone)),
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ChatScreen(seller: conv.seller, conversationId: conv.id))),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
