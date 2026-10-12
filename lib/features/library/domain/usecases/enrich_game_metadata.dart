import '../entities/game.dart';
import '../repositories/game_repository.dart';

class EnrichGameMetadata {
  const EnrichGameMetadata(this._repository);

  final GameRepository _repository;

  Future<Game> call(Game game) => _repository.enrichMetadata(game);
}
