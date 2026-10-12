import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Section title with an accent bar, used across dashboard sections.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.accent = AppColors.neonBlue,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 4,
          height: 26,
          decoration: BoxDecoration(
            color: accent,
            borderRadius: BorderRadius.circular(4),
            boxShadow: <BoxShadow>[
              BoxShadow(color: accent.withAlpha(120), blurRadius: 12),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              title.toUpperCase(),
              style: Theme.of(context).textTheme.titleLarge,
            ),
            if (subtitle != null)
              Text(subtitle!, style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
        const Spacer(),
        if (trailing != null) trailing!,
      ],
    );
  }
}
