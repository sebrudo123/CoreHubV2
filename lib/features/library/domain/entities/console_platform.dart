/// Console / system families supported by the scanner and scraper.
///
/// [screenScraperId] maps to the ScreenScraper `systemeid` used for metadata.
enum ConsolePlatform {
  nes('NES', 'Nintendo Entertainment System', 3, <String>['nes', 'unf', 'unif', 'fds']),
  snes('SNES', 'Super Nintendo', 4, <String>['smc', 'sfc', 'swc', 'fig']),
  n64('N64', 'Nintendo 64', 14, <String>['n64', 'z64', 'v64']),
  gb('GB', 'Game Boy', 9, <String>['gb']),
  gbc('GBC', 'Game Boy Color', 10, <String>['gbc']),
  gba('GBA', 'Game Boy Advance', 12, <String>['gba']),
  nds('NDS', 'Nintendo DS', 15, <String>['nds', 'dsi']),
  n3ds('3DS', 'Nintendo 3DS', 17, <String>['3ds', 'cia', 'cci', 'cxi']),
  gamecube('GC', 'Nintendo GameCube', 13, <String>['gcm', 'rvz', 'dol']),
  wii('Wii', 'Nintendo Wii', 16, <String>['wbfs', 'wad']),
  switch('SWI', 'Nintendo Switch', 225, <String>['nsp', 'xci']),
  genesis('GEN', 'Sega Mega Drive / Genesis', 1, <String>['md', 'gen', 'smd', '32x']),
  saturn('SAT', 'Sega Saturn', 22, <String>['bin', 'cue', 'chd']),
  dreamcast('DC', 'Sega Dreamcast', 23, <String>['gdi', 'cdi', 'cue']),
  ps1('PS1', 'Sony PlayStation', 57, <String>['pbp', 'chd', 'cue', 'bin']),
  ps2('PS2', 'Sony PlayStation 2', 58, <String>['iso', 'chd']),
  psp('PSP', 'Sony PSP', 61, <String>['cso', 'pbp', 'iso', 'chd']),
  arcade('ARC', 'Arcade', 75, <String>['zip', '7z']),
  unknown('UNK', 'Unknown', 0, <String>[]);

  const ConsolePlatform(
    this.shortLabel,
    this.title,
    this.screenScraperId,
    this.extensions,
  );

  final String shortLabel;
  final String title;
  final int screenScraperId;
  final List<String> extensions;

  bool get isKnown => this != ConsolePlatform.unknown;

  static const Map<String, ConsolePlatform> _keywords = <String, ConsolePlatform>{
    'famicom': ConsolePlatform.nes,
    'nes': ConsolePlatform.nes,
    'supernintendo': ConsolePlatform.snes,
    'snes': ConsolePlatform.snes,
    'nintendo64': ConsolePlatform.n64,
    'n64': ConsolePlatform.n64,
    'gameboyadvance': ConsolePlatform.gba,
    'gba': ConsolePlatform.gba,
    'gameboycolor': ConsolePlatform.gbc,
    'gameboy': ConsolePlatform.gb,
    'nintendods': ConsolePlatform.nds,
    'nds': ConsolePlatform.nds,
    'citra': ConsolePlatform.n3ds,
    '3ds': ConsolePlatform.n3ds,
    'dolphin': ConsolePlatform.gamecube,
    'gamecube': ConsolePlatform.gamecube,
    'wii': ConsolePlatform.wii,
    'yuzu': ConsolePlatform.switch,
    'switch': ConsolePlatform.switch,
    'megadrive': ConsolePlatform.genesis,
    'genesis': ConsolePlatform.genesis,
    'sega': ConsolePlatform.genesis,
    'saturn': ConsolePlatform.saturn,
    'dreamcast': ConsolePlatform.dreamcast,
    'duckstation': ConsolePlatform.ps1,
    'playstation1': ConsolePlatform.ps1,
    'ps1': ConsolePlatform.ps1,
    'psx': ConsolePlatform.ps1,
    'nethersx2': ConsolePlatform.ps2,
    'aether': ConsolePlatform.ps2,
    'playstation2': ConsolePlatform.ps2,
    'ps2': ConsolePlatform.ps2,
    'ppsspp': ConsolePlatform.psp,
    'psp': ConsolePlatform.psp,
    'mame': ConsolePlatform.arcade,
    'fbneo': ConsolePlatform.arcade,
    'arcade': ConsolePlatform.arcade,
  };

  static ConsolePlatform fromExtension(String extension) {
    final String ext = extension.toLowerCase();
    for (final ConsolePlatform platform in ConsolePlatform.values) {
      if (platform.extensions.contains(ext)) return platform;
    }
    return ConsolePlatform.unknown;
  }

  /// Best-effort resolution using the ROM path (folder hints) then extension.
  static ConsolePlatform fromPath(String path, String extension) {
    final String lower = path.toLowerCase();
    for (final MapEntry<String, ConsolePlatform> entry in _keywords.entries) {
      if (lower.contains(entry.key)) return entry.value;
    }
    return fromExtension(extension);
  }

  static ConsolePlatform fromName(String name) {
    for (final ConsolePlatform platform in ConsolePlatform.values) {
      if (platform.name == name) return platform;
    }
    return ConsolePlatform.unknown;
  }
}
