import '../../../../core/native/native_installed_apps.dart';
import '../../domain/entities/console_platform.dart';
import '../../domain/entities/game.dart';

/// Loads installed Android games and launches them by package name.
class InstalledGamesDataSource {
  const InstalledGamesDataSource(this._native);

  final NativeInstalledApps _native;

  Future<List<Game>> loadGames() async {
    final List<Map<String, dynamic>> raw = await _native.getInstalledGames();
    return raw.map(_toGame).whereType<Game>().toList(growable: false);
  }

  Future<bool> launch(String packageName) => _native.launchPackage(packageName);

  Game? _toGame(Map<String, dynamic> entry) {
    final String packageName = entry['package']?.toString() ?? '';
    if (packageName.isEmpty) return null;
    final String name = entry['name']?.toString() ?? packageName;
    return Game(
      id: 'app:$packageName',
      title: name,
      packageName: packageName,
      platform: ConsolePlatform.unknown,
      isAndroidApp: true,
    );
  }
}
