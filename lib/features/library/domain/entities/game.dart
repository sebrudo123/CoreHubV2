import 'console_platform.dart';
import 'game_metadata.dart';

/// Unified library entry: either a ROM file or an installed Android app.
class Game {
  const Game({
    required this.id,
    required this.title,
    required this.platform,
    this.romPath,
    this.packageName,
    this.isAndroidApp = false,
    this.metadata = GameMetadata.empty,
    this.lastPlayed,
    this.isFavorite = false,
  });

  final String id;
  final String title;
  final ConsolePlatform platform;
  final String? romPath;
  final String? packageName;
  final bool isAndroidApp;
  final GameMetadata metadata;
  final DateTime? lastPlayed;
  final bool isFavorite;

  bool get hasArtwork => metadata.boxArtUrl != null;

  Game copyWith({
    String? title,
    ConsolePlatform? platform,
    String? romPath,
    String? packageName,
    bool? isAndroidApp,
    GameMetadata? metadata,
    DateTime? lastPlayed,
    bool? isFavorite,
  }) {
    return Game(
      id: id,
      title: title ?? this.title,
      platform: platform ?? this.platform,
      romPath: romPath ?? this.romPath,
      packageName: packageName ?? this.packageName,
      isAndroidApp: isAndroidApp ?? this.isAndroidApp,
      metadata: metadata ?? this.metadata,
      lastPlayed: lastPlayed ?? this.lastPlayed,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}
