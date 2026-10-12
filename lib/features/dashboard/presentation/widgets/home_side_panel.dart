import 'package:flutter/material.dart';

import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../data/home_feed.dart';

/// Right-side column shown on the Home tab: friends, notifications and
/// the download queue.
class HomeSidePanel extends StatelessWidget {
  const HomeSidePanel({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(0, 10, 20, 24),
      children: <Widget>[
        _PanelCard(
          title: 'Friends Online',
          icon: Icons.groups_rounded,
          accent: AppColors.success,
          child: Column(
            children: <Widget>[
              for (final FriendBrief friend in HomeFeed.friends)
                _FriendRow(friend: friend),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _PanelCard(
          title: 'Notifications',
          icon: Icons.notifications_rounded,
          accent: AppColors.neonBlue,
          child: Column(
            children: <Widget>[
              for (final AppAlert alert in HomeFeed.notifications)
                _AlertRow(alert: alert),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _PanelCard(
          title: 'Downloads Queue',
          icon: Icons.download_rounded,
          accent: AppColors.neonPink,
          child: Column(
            children: <Widget>[
              for (final DownloadTask task in HomeFeed.downloads)
                _DownloadRow(task: task),
            ],
          ),
        ),
      ],
    );
  }
}

class _PanelCard extends StatelessWidget {
  const _PanelCard({
    required this.title,
    required this.icon,
    required this.accent,
    required this.child,
  });

  final String title;
  final IconData icon;
  final Color accent;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(icon, size: 18, color: accent),
              const SizedBox(width: 8),
              Text(
                title,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: accent,
                      letterSpacing: 1.4,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});

  final FriendBrief friend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: <Color>[
                      friend.accent.withAlpha(200),
                      friend.accent.withAlpha(90),
                    ],
                  ),
                  shape: BoxShape.circle,
                ),
                child: Text(
                  friend.name.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (friend.isOnline)
                Positioned(
                  right: -1,
                  bottom: -1,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.success,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.background, width: 2),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  friend.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontSize: 13,
                      ),
                ),
                const SizedBox(height: 1),
                Text(
                  friend.isOnline
                      ? (friend.game != null
                          ? 'Jugando ${friend.game}'
                          : 'En línea')
                      : 'Desconectado',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                        color: friend.isOnline
                            ? AppColors.textSecondary
                            : AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.alert});

  final AppAlert alert;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: alert.accent.withAlpha(28),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: alert.accent.withAlpha(80)),
            ),
            child: Icon(alert.icon, size: 16, color: alert.accent),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        alert.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(fontSize: 12.5),
                      ),
                    ),
                    Text(
                      alert.time,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  alert.body,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontSize: 11,
                      ),
                ),
              ],
            ),
          ),
          if (alert.unread)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 8),
              child: Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: alert.accent,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DownloadRow extends StatelessWidget {
  const _DownloadRow({required this.task});

  final DownloadTask task;

  @override
  Widget build(BuildContext context) {
    final double done = (task.percent / 100).clamp(0, 1);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            task.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context)
                .textTheme
                .bodyLarge
                ?.copyWith(fontSize: 12.5),
          ),
          const SizedBox(height: 2),
          Text(task.size, style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 7),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: done,
              minHeight: 4,
              backgroundColor: AppColors.glassBorder,
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.neonPink),
            ),
          ),
          const SizedBox(height: 5),
          Text(
            '${task.percent.toInt()}% · ${task.state}',
            style: Theme.of(context).textTheme.labelSmall,
          ),
        ],
      ),
    );
  }
}