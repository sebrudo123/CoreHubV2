import 'package:flutter/material.dart';

import '../../../../core/native/native_installed_apps.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../domain/entities/streaming_service.dart';

class StreamingCard extends StatelessWidget {
  const StreamingCard({super.key, required this.service, this.autofocus = false});

  final StreamingService service;
  final bool autofocus;

  Future<void> _launch(BuildContext context) async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    final bool ok =
        await const NativeInstalledApps().launchPackage(service.packageName);
    if (ok) return;
    messenger.showSnackBar(
      SnackBar(content: Text('${service.name} no está instalado')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GameFocus(
      autofocus: autofocus,
      onSelect: () => _launch(context),
      builder: (BuildContext context, bool focused) {
        return AnimatedScale(
          scale: focused ? 1.04 : 1.0,
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          child: GlassCard(
            borderColor: focused ? service.accent : AppColors.glassBorder,
            borderWidth: focused ? 1.6 : 1.2,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: service.accent.withAlpha(40),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: service.accent.withAlpha(120)),
                  ),
                  child: Icon(service.icon, color: service.accent, size: 26),
                ),
                const SizedBox(height: 14),
                Text(service.name, style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 4),
                Text(
                  service.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
