import '../../../../core/native/native_rom_scanner.dart';
import '../../domain/entities/console_platform.dart';
import '../../domain/entities/game.dart';

/// Maps raw native scan descriptors into [Game] entities.
class RomLocalDataSource {
  const RomLocalDataSource(this._scanner);

  final NativeRomScanner _scanner;

  Future<List<Game>> loadRoms() async {
    final List<String> roots = await _scanner.discoverRoots();
    final List<Map<String, dynamic>> entries = await _scanner.scan(roots);
    return entries.map(_toGame).whereType<Game>().toList(growable: false);
  }

  Game? _toGame(Map<String, dynamic> entry) {
    final String path = entry['path']?.toString() ?? '';
    if (path.isEmpty) return null;
    final String name = entry['name']?.toString() ?? '';
    final String extension = entry['extension']?.toString() ?? '';
    final ConsolePlatform platform = ConsolePlatform.fromPath(path, extension);

    return Game(
      id: 'rom:$path',
      title: _prettify(name.isEmpty ? path : name),
      romPath: path,
      platform: platform,
    );
  }

  /// Turns `Super_Mario_World (USA) [!]` into `Super Mario World`.
  String _prettify(String raw) {
    String name = raw.replaceAll(RegExp(r'[_]+'), ' ').trim();
    name = name.replaceAll(RegExp(r'\s*[\(\[].*?[\)\]]'), '').trim();
    name = name.replaceAll(RegExp(r'\s{2,}'), ' ').trim();
    if (name.isEmpty) return raw;
    return name
        .split(' ')
        .map((String word) => word.isEmpty
            ? word
            : '${word[0].toUpperCase()}${word.substring(1)}')
        .join(' ');
  }
}
