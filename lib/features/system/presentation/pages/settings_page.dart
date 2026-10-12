import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/settings_service.dart';
import '../../../../shared/theme/app_colors.dart';
import '../../../../shared/theme/app_theme.dart';
import '../../../../shared/widgets/game_focus.dart';
import '../../../../shared/widgets/glass_card.dart';
import '../../../../shared/widgets/section_header.dart';
import '../../../library/presentation/controllers/library_controller.dart';
import '../widgets/system_monitor_panel.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final TextEditingController _devId = TextEditingController();
  final TextEditingController _devPassword = TextEditingController();
  final TextEditingController _user = TextEditingController();
  final TextEditingController _password = TextEditingController();
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    final SettingsService settings = context.read<SettingsService>();
    _devId.text = settings.scraperDevId;
    _devPassword.text = settings.scraperDevPassword;
    _user.text = settings.scraperUser;
    _password.text = settings.scraperPassword;
    _initialized = true;
  }

  @override
  void dispose() {
    _devId.dispose();
    _devPassword.dispose();
    _user.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _saveCredentials() async {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
    await context.read<SettingsService>().setScraperCredentials(
          devId: _devId.text,
          devPassword: _devPassword.text,
          user: _user.text,
          password: _password.text,
        );
    messenger.showSnackBar(
      const SnackBar(content: Text('Credenciales de ScreenScraper guardadas')),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SettingsService settings = context.watch<SettingsService>();
    final LibraryController library = context.watch<LibraryController>();

    return ListView(
      padding: const EdgeInsets.fromLTRB(28, 16, 28, 64),
      children: <Widget>[
        SectionHeader(
          title: 'Ajustes',
          subtitle: 'Sistema, scraping y biblioteca',
          accent: AppColors.neonCyan,
          trailing: const SystemMonitorPanel(compact: true),
        ),
        const SizedBox(height: 20),
        _SettingsCard(
          title: 'Interfaz',
          children: <Widget>[
            _SwitchRow(
              title: 'Sonidos de navegación',
              subtitle: 'Feedback de sistema al mover el foco y seleccionar',
              value: settings.uiSounds,
              onChanged: settings.setUiSounds,
            ),
            _SwitchRow(
              title: 'Descarga de metadatos',
              subtitle: 'Portadas y sinopsis vía ScreenScraper',
              value: settings.metadataScraping,
              onChanged: settings.setMetadataScraping,
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SettingsCard(
          title: 'Biblioteca',
          children: <Widget>[
            _InfoRow(
              label: 'Títulos indexados',
              value: '${library.totalGames}',
            ),
            _InfoRow(label: 'ROMs / emuladores', value: '${library.romCount}'),
            _InfoRow(label: 'Juegos Android', value: '${library.androidCount}'),
            const SizedBox(height: 8),
            GameFocus(
              onSelect: library.refresh,
              builder: (BuildContext context, bool focused) {
                return _ActionButton(
                  label: library.isScanning
                      ? 'Escaneando…'
                      : 'Re-escanear almacenamiento',
                  icon: Icons.refresh_rounded,
                  focused: focused,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        _SettingsCard(
          title: 'ScreenScraper (metadatos)',
          children: <Widget>[
            _TextField(controller: _devId, label: 'Dev ID'),
            _TextField(controller: _devPassword, label: 'Dev Password'),
            _TextField(controller: _user, label: 'Usuario (ssid)'),
            _TextField(
              controller: _password,
              label: 'Contraseña (sspassword)',
              obscure: true,
            ),
            const SizedBox(height: 14),
            GameFocus(
              onSelect: _saveCredentials,
              builder: (BuildContext context, bool focused) {
                return _ActionButton(
                  label: 'Guardar credenciales',
                  icon: Icons.save_rounded,
                  focused: focused,
                );
              },
            ),
          ],
        ),
        const SizedBox(height: 18),
        const _AboutCard(),
      ],
    );
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.6,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          ...children,
        ],
      ),
    );
  }
}

class _SwitchRow extends StatelessWidget {
  const _SwitchRow({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return SwitchListTile.adaptive(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: Theme.of(context).textTheme.titleMedium),
      subtitle: Text(subtitle, style: Theme.of(context).textTheme.bodyMedium),
      value: value,
      onChanged: onChanged,
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: <Widget>[
          Text(label, style: Theme.of(context).textTheme.bodyMedium),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.label,
    this.obscure = false,
  });

  final TextEditingController controller;
  final String label;
  final bool obscure;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: AppColors.textPrimary),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.glass,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppTheme.radius),
            borderSide: const BorderSide(color: AppColors.neonBlue, width: 1.4),
          ),
        ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.focused,
  });

  final String label;
  final IconData icon;
  final bool focused;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        gradient: focused ? AppColors.primaryGradient : null,
        color: focused ? null : AppColors.glass,
        borderRadius: BorderRadius.circular(AppTheme.radius),
        border: Border.all(
          color: focused ? AppColors.neonBlue : AppColors.glassBorder,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 18),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _AboutCard extends StatelessWidget {
  const _AboutCard();

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppConstants.appName.toUpperCase(),
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 6),
          Text(
            'v${AppConstants.appVersion} · Flutter · Clean Architecture',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 10),
          Text(
            'Launcher industrial con integración nativa Android para emuladores, '
            'gamepads y monitoreo de hardware.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
    );
  }
}
