import '../entities/game.dart';

abstract class GameRepository {
  /// Scans ROM storage and installed Android games.
  Future<List<Game>> scanLibrary();

  /// Enriches a single game with scraped metadata (no-op when unavailable).
  Future<Game> enrichMetadata(Game game);

  /// Launches a game. Returns `true` when the handoff succeeded.
  Future<bool> launch(Game game);
}
