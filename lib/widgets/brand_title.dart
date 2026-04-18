import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class BrandTitle extends StatelessWidget {
  final String title;
  final double logoSize;

  const BrandTitle(
    this.title, {
    super.key,
    this.logoSize = 22,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.asset(
            'assets/images/logo.png',
            width: logoSize,
            height: logoSize,
            fit: BoxFit.cover,
          ),
        ),
        const SizedBox(width: 8),
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: AppColors.espresso,
                  fontWeight: FontWeight.w800,
                ),
          ),
        ),
      ],
    );
  }
}