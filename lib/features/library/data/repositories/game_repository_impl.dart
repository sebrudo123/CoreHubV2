import '../../../../core/native/native_emulator_launcher.dart';
import '../../domain/entities/game.dart';
import '../../domain/repositories/game_repository.dart';
import '../datasources/installed_games_data_source.dart';
import '../datasources/rom_local_data_source.dart';
import '../datasources/scraper_remote_data_source.dart';

class GameRepositoryImpl implements GameRepository {
  GameRepositoryImpl({
    required RomLocalDataSource romLocal,
    required InstalledGamesDataSource installedApps,
    required ScraperRemoteDataSource scraper,
    required NativeEmulatorLauncher emulator,
  })  : _romLocal = romLocal,
        _installedApps = installedApps,
        _scraper = scraper,
        _emulator = emulator;

  final RomLocalDataSource _romLocal;
  final InstalledGamesDataSource _installedApps;
  final ScraperRemoteDataSource _scraper;
  final NativeEmulatorLauncher _emulator;

  @override
  Future<List<Game>> scanLibrary() async {
    final List<List<Game>> results = await Future.wait(<Future<List<Game>>>[
      _romLocal.loadRoms(),
      _installedApps.loadGames(),
    ]);
    final List<Game> games = <Game>[...results[0], ...results[1]];
    games.sort((Game a, Game b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()));
    return games;
  }

  @override
  Future<Game> enrichMetadata(Game game) async {
    if (game.isAndroidApp || game.platform.screenScraperId == 0) return game;
    final String query = game.romPath ?? game.title;
    final metadata = await _scraper.fetch(game.platform, query);
    if (metadata == null || metadata.isEmpty) return game;
    return game.copyWith(metadata: metadata);
  }

  @override
  Future<bool> launch(Game game) async {
    if (game.isAndroidApp) {
      final String? packageName = game.packageName;
      if (packageName == null || packageName.isEmpty) return false;
      return _installedApps.launch(packageName);
    }
    final String? romPath = game.romPath;
    if (romPath == null || romPath.isEmpty) return false;
    final String? handler = await _emulator.launch(
      romPath: romPath,
      platform: game.platform.name,
    );
    return handler != null;
  }
}
