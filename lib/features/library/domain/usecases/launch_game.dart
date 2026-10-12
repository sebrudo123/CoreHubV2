import '../entities/game.dart';
import '../repositories/game_repository.dart';

class LaunchGame {
  const LaunchGame(this._repository);

  final GameRepository _repository;

  Future<bool> call(Game game) => _repository.launch(game);
}
