import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';

/// Sections reachable from the launcher sidebar.
enum DashboardSection {
  home('Home', Icons.home_rounded),
  library('Library', Icons.library_books_rounded),
  store('Store', Icons.storefront_rounded),
  community('Community', Icons.groups_rounded),
  downloads('Downloads', Icons.download_rounded),
  stats('Stats', Icons.query_stats_rounded),
  cloudSaves('Cloud Saves', Icons.cloud_upload_rounded),
  settings('Settings', Icons.settings_rounded);

  const DashboardSection(this.label, this.icon);

  final String label;
  final IconData icon;
}

class AppSidebar extends StatelessWidget {
  const AppSidebar({
    super.key,
    required this.sections,
    required this.selected,
    required this.onSelect,
  });

  final List<DashboardSection> sections;
  final DashboardSection selected;
  final ValueChanged<DashboardSection> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 158,
      margin: const EdgeInsets.fromLTRB(12, 8, 0, 12),
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.glass,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.glassBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: <Widget>[
                  for (final DashboardSection section in sections)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _NavButton(
                        section: section,
                        selected: section == selected,
                        onSelect: () => onSelect(section),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              'CoreHub v1.0.0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                letterSpacing: 1.1,
                color: AppColors.textMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.section,
    required this.selected,
    required this.onSelect,
  });

  final DashboardSection section;
  final bool selected;
  final VoidCallback onSelect;

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      onSelect: onSelect,
      builder: (BuildContext context, bool focused) {
        final bool active = selected || focused;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
          decoration: BoxDecoration(
            gradient: active ? AppColors.primaryGradient : null,
            color: active ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: active
                  ? Colors.transparent
                  : focused
                      ? AppColors.glassBorder
                      : Colors.transparent,
            ),
          ),
          child: Row(
            children: <Widget>[
              Icon(
                section.icon,
                size: 19,
                color: active ? Colors.white : AppColors.textSecondary,
              ),
              const SizedBox(width: 10),
              Text(
                section.label.toUpperCase(),
                style: TextStyle(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.1,
                  color: active ? Colors.white : AppColors.textSecondary,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}