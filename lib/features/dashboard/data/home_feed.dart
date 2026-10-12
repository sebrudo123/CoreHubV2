import 'package:flutter/material.dart';

import '../../../shared/theme/app_colors.dart';

/// Accent tones used by the curated in-app feed. Const so the whole feed can
/// be a compile-time list.
const Color _accentPink = Color(0xFFFF0055);
const Color _accentViolet = Color(0xFF8B5CF6);
const Color _accentAmber = Color(0xFFFFD166);
const Color _accentOrange = Color(0xFFFF7A00);
const Color _accentTeal = AppColors.success;
const Color _accentRed = AppColors.danger;

/// A promoted/featured title shown as a big banner or store card.
class FeaturedTitle {
  const FeaturedTitle({
    required this.title,
    required this.tagline,
    required this.description,
    required this.badge,
    required this.palette,
    this.genres = const <String>[],
    this.playLabel = 'Jugar ahora',
  });

  final String title;
  final String tagline;
  final String description;
  final String badge;
  final List<Color> palette;
  final List<String> genres;
  final String playLabel;
}

/// A library-style row: title, tag, play time and completion progress.
class GameEntry {
  const GameEntry(this.title, this.tag, this.hours, this.progress, this.accent);

  final String title;
  final String tag;
  final double hours;
  final double progress;
  final Color accent;
}

class FriendBrief {
  const FriendBrief({
    required this.name,
    required this.accent,
    this.game,
    this.isOnline = true,
  });

  final String name;
  final String? game;
  final bool isOnline;
  final Color accent;
}

class AppAlert {
  const AppAlert({
    required this.icon,
    required this.title,
    required this.body,
    required this.time,
    this.accent = AppColors.neonBlue,
    this.unread = false,
  });

  final IconData icon;
  final String title;
  final String body;
  final String time;
  final Color accent;
  final bool unread;
}

class DownloadTask {
  const DownloadTask({
    required this.name,
    required this.size,
    required this.percent,
    this.state = 'Descargando',
  });

  final String name;
  final String size;
  final double percent;
  final String state;
}

class CloudBackup {
  const CloudBackup({required this.game, required this.modified, required this.size});

  final String game;
  final String modified;
  final String size;
}

/// Curated content driving the dashboard shell before any real back end exists.
class HomeFeed {
  HomeFeed._();

  static const FeaturedTitle hero = FeaturedTitle(
    title: 'Eclipse Protocol',
    tagline: 'Temporada 7 · Operativo cooperativo',
    description:
        'Cuatro operativos contra una colonia en rebeldía. Coordina gadgets, '
        'hackea la red y ejecuta la extracción antes de que el protocolo escale.',
    badge: 'DESTACADO',
    palette: <Color>[AppColors.neonBlue, _accentViolet],
    genres: <String>['Shooter táctico', 'Online 4P', 'Ciencia ficción'],
  );

  static const List<GameEntry> recentlyPlayed = <GameEntry>[
    GameEntry('Cyberpunk 2077', 'RPG · Night City', 128.4, 0.62, _accentPink),
    GameEntry('Elden Ring', 'Acción · RPG', 87.0, 0.45, _accentAmber),
    GameEntry('Starfield', 'Exploración espacial', 41.5, 0.28, AppColors.neonBlue),
    GameEntry('Apex Legends', 'Battle royale', 203.9, 0.71, _accentRed),
  ];

  static const List<GameEntry> highlights = <GameEntry>[
    GameEntry('Hades', 'Roguelike', 64.2, 0.9, _accentViolet),
    GameEntry('Valorant', 'FPS táctico', 300.1, 1.0, AppColors.neonCyan),
    GameEntry('The Witcher 3', 'RPG · Mundo abierto', 152.7, 0.55, _accentTeal),
    GameEntry('DOOM Eternal', 'Shooter', 48.9, 0.33, _accentOrange),
  ];

  static const List<FriendBrief> friends = <FriendBrief>[
    FriendBrief(name: 'AlexM', game: 'Cyberpunk 2077', accent: _accentPink),
    FriendBrief(name: 'LunaK', accent: AppColors.neonCyan),
    FriendBrief(name: 'SaraV', game: 'Valorant', accent: _accentTeal),
    FriendBrief(name: 'TomWie', game: 'Elden Ring', accent: _accentAmber),
    FriendBrief(name: 'Diego_P', isOnline: false, accent: _accentViolet),
  ];

  static const List<AppAlert> notifications = <AppAlert>[
    AppAlert(
      icon: Icons.system_update_rounded,
      title: 'Cyberpunk 2077 actualizado',
      body: '2,1 GB · Parche 2.12 disponible',
      time: 'hace 5 m',
      accent: AppColors.neonBlue,
      unread: true,
    ),
    AppAlert(
      icon: Icons.groups_rounded,
      title: 'AlexM te invita a jugar',
      body: 'Sala abierta · Eclipse Protocol',
      time: 'hace 12 m',
      accent: _accentPink,
      unread: true,
    ),
    AppAlert(
      icon: Icons.sports_esports_rounded,
      title: 'Nuevo juego en tu biblioteca',
      body: 'DOOM Eternal añadido',
      time: 'hace 1 h',
      accent: _accentTeal,
    ),
    AppAlert(
      icon: Icons.workspace_premium_rounded,
      title: 'Suscripción Pro activada',
      body: 'Facturado el 12 oct',
      time: 'hace 2 d',
      accent: _accentAmber,
    ),
  ];

  static const List<DownloadTask> downloads = <DownloadTask>[
    DownloadTask(
      name: 'Eclipse Protocol · Actualización v7.3',
      size: '12,4 GB / 14,6 GB',
      percent: 85,
    ),
    DownloadTask(
      name: 'Hades II · Beta',
      size: '3,1 GB / 3,1 GB',
      percent: 100,
      state: 'Instalación en curso',
    ),
    DownloadTask(
      name: 'The Witcher 3 · HD Pack',
      size: '460 MB / 460 MB',
      percent: 100,
      state: 'En cola',
    ),
  ];

  static const List<FeaturedTitle> storePromos = <FeaturedTitle>[
    FeaturedTitle(
      title: 'Neon Odyssey',
      tagline: 'Acción arcade futurista',
      description: 'Carreras de luces a través de una metrópoli sintética.',
      badge: 'NUEVO',
      palette: <Color>[AppColors.neonCyan, AppColors.neonBlue],
    ),
    FeaturedTitle(
      title: 'Riftbreaker',
      tagline: 'Estrategia · Defensa',
      description: 'Construye, defiende y sobrevive a las hordas alienígenas.',
      badge: '-40%',
      palette: <Color>[_accentViolet, _accentPink],
    ),
    FeaturedTitle(
      title: 'Starport 9',
      tagline: 'Simulador espacial',
      description: 'Dirige el puerto orbital y negocia rutas estelares.',
      badge: 'PRE-VENTA',
      palette: <Color>[AppColors.neonBlue, _accentTeal],
    ),
    FeaturedTitle(
      title: 'Iron Harvest X',
      tagline: 'RTS · Dieselpunk',
      description: 'Mechs y trincheras en una Europa alternativa.',
      badge: 'OFERTA',
      palette: <Color>[_accentOrange, _accentRed],
    ),
    FeaturedTitle(
      title: 'Crown of Embers',
      tagline: 'Mundo abierto',
      description: 'Forja tu reino entre cenizas y dragones.',
      badge: 'NUEVO',
      palette: <Color>[_accentAmber, _accentViolet],
    ),
    FeaturedTitle(
      title: 'Velocity Rush',
      tagline: 'Carreras anti-gravedad',
      description: 'Velocidad total en pistas que desafían la física.',
      badge: 'BETA',
      palette: <Color>[_accentPink, AppColors.neonCyan],
    ),
  ];

  static const List<CloudBackup> cloudSaves = <CloudBackup>[
    CloudBackup(game: 'Cyberpunk 2077', modified: '12 oct · 21:40', size: '48 MB'),
    CloudBackup(game: 'Elden Ring', modified: '11 oct · 01:15', size: '29 MB'),
    CloudBackup(game: 'The Witcher 3', modified: '09 oct · 18:02', size: '112 MB'),
  ];
}