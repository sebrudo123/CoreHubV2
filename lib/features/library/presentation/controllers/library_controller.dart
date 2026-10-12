import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../../../core/constants/app_constants.dart';
import '../../domain/entities/game.dart';
import '../../domain/entities/library_filter.dart';
import '../../domain/usecases/enrich_game_metadata.dart';
import '../../domain/usecases/launch_game.dart';
import '../../domain/usecases/scan_library.dart';

/// Presentation state for the game library.
class LibraryController extends ChangeNotifier {
  LibraryController({
    required ScanLibrary scanLibrary,
    required EnrichGameMetadata enrichGameMetadata,
    required LaunchGame launchGame,
    int maxEnrich = AppConstants.maxEnrichPerScan,
  })  : _scanLibrary = scanLibrary,
        _enrich = enrichGameMetadata,
        _launch = launchGame,
        _maxEnrich = maxEnrich;

  final ScanLibrary _scanLibrary;
  final EnrichGameMetadata _enrich;
  final LaunchGame _launch;
  final int _maxEnrich;

  bool _isScanning = false;
  bool _isEnriching = false;
  String _query = '';
  List<Game> _games = <Game>[];

  bool get isScanning => _isScanning;
  bool get isEnriching => _isEnriching;
  String get query => _query;
  int get totalGames => _games.length;
  int get romCount => _games.where((Game g) => !g.isAndroidApp).length;
  int get androidCount => _games.where((Game g) => g.isAndroidApp).length;

  Future<void> initialize() async {
    // Defer the first scan so it never notifies listeners during widget build.
    await Future<void>.delayed(Duration.zero);
    await refresh();
  }

  Future<void> refresh() async {
    if (_isScanning) return;
    _isScanning = true;
    notifyListeners();
    try {
      final List<Game> loaded = await _scanLibrary();
      _games = _sort(loaded);
    } catch (_) {
      _games = <Game>[];
    } finally {
      _isScanning = false;
      notifyListeners();
    }
    unawaited(_enrichMissing());
  }

  Future<void> _enrichMissing() async {
    if (_isEnriching) return;
    _isEnriching = true;
    notifyListeners();
    try {
      final List<Game> targets = _games
          .where((Game g) => !g.isAndroidApp && g.platform.isKnown && g.metadata.isEmpty)
          .take(_maxEnrich)
          .toList(growable: false);

      for (final Game game in targets) {
        final Game enriched = await _enrich(game);
        if (enriched.metadata.isEmpty) continue;
        final int index = _games.indexWhere((Game g) => g.id == game.id);
        if (index == -1) continue;
        final List<Game> updated = List<Game>.of(_games);
        updated[index] = enriched;
        _games = _sort(updated);
        notifyListeners();
      }
    } finally {
      _isEnriching = false;
      notifyListeners();
    }
  }

  void search(String value) {
    _query = value;
    notifyListeners();
  }

  List<Game> gamesFor(LibraryFilter filter) {
    Iterable<Game> source = switch (filter) {
      LibraryFilter.recent => _sortedRecent().where((Game g) => g.lastPlayed != null),
      LibraryFilter.consoles => _games.where((Game g) => !g.isAndroidApp),
      LibraryFilter.android => _games.where((Game g) => g.isAndroidApp),
    };

    final String query = _query.trim().toLowerCase();
    if (query.isNotEmpty) {
      source = source.where((Game g) => g.title.toLowerCase().contains(query));
    }
    return source.toList(growable: false);
  }

  List<Game> get recentlyPlayed =>
      _sortedRecent().where((Game g) => g.lastPlayed != null).take(12).toList(growable: false);

  Future<bool> launch(Game game) async {
    final bool ok = await _launch(game);
    if (!ok) return false;

    final int index = _games.indexWhere((Game g) => g.id == game.id);
    if (index != -1) {
      final List<Game> updated = List<Game>.of(_games);
      updated[index] = updated[index].copyWith(lastPlayed: DateTime.now());
      _games = _sort(updated);
      notifyListeners();
    }
    return true;
  }

  void toggleFavorite(Game game) {
    final int index = _games.indexWhere((Game g) => g.id == game.id);
    if (index == -1) return;
    final List<Game> updated = List<Game>.of(_games);
    updated[index] = updated[index].copyWith(isFavorite: !updated[index].isFavorite);
    _games = _sort(updated);
    notifyListeners();
  }

  List<Game> _sortedRecent() {
    final List<Game> list = List<Game>.of(_games);
    list.sort((Game a, Game b) {
      final DateTime? aPlayed = a.lastPlayed;
      final DateTime? bPlayed = b.lastPlayed;
      if (aPlayed == null && bPlayed == null) return 0;
      if (aPlayed == null) return 1;
      if (bPlayed == null) return -1;
      return bPlayed.compareTo(aPlayed);
    });
    return list;
  }

  List<Game> _sort(List<Game> input) {
    final List<Game> list = List<Game>.of(input);
    list.sort((Game a, Game b) {
      if (a.isFavorite != b.isFavorite) return a.isFavorite ? -1 : 1;

      final DateTime? aPlayed = a.lastPlayed;
      final DateTime? bPlayed = b.lastPlayed;
      if (aPlayed != null && bPlayed != null && aPlayed != bPlayed) {
        return bPlayed.compareTo(aPlayed);
      }
      if (aPlayed != null && bPlayed == null) return -1;
      if (aPlayed == null && bPlayed != null) return 1;

      return a.title.toLowerCase().compareTo(b.title.toLowerCase());
    });
    return list;
  }
}
