import '../entities/game.dart';
import '../repositories/game_repository.dart';

class ScanLibrary {
  const ScanLibrary(this._repository);

  final GameRepository _repository;

  Future<List<Game>> call() => _repository.scanLibrary();
}
