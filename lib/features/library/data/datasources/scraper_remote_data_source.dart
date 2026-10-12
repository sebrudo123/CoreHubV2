import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_constants.dart';
import '../../../../core/services/settings_service.dart';
import '../../domain/entities/console_platform.dart';
import '../../domain/entities/game_metadata.dart';

/// ScreenScraper metadata provider.
///
/// The scraper is credential-gated; when no developer credentials are set the
/// call is skipped and the local library keeps its generated metadata.
///
/// ## IGDB extension point
/// Implement a sibling data source following the same signature and compose the
/// two inside [GameRepositoryImpl]; the domain layer only depends on
/// [GameMetadata].
class ScraperRemoteDataSource {
  ScraperRemoteDataSource({
    required SettingsService settings,
    http.Client? client,
  })  : _settings = settings,
        _client = client ?? http.Client();

  final SettingsService _settings;
  final http.Client _client;

  static const Duration _timeout = Duration(seconds: 12);
  static const List<String> _preferredLanguages = <String>['en', 'es', 'us'];
  static const List<String> _preferredRegions = <String>['wor', 'us', 'eu', 'jp'];

  Future<GameMetadata?> fetch(ConsolePlatform platform, String romName) async {
    if (!_settings.metadataScraping || !_settings.credentialsConfigured) {
      return null;
    }
    if (platform.screenScraperId == 0) return null;

    try {
      final Uri uri = Uri.https('www.screenscraper.fr', '/api2/jeuInfos.php', <String, String>{
        'devid': _settings.scraperDevId,
        'devpassword': _settings.scraperDevPassword,
        'softname': AppConstants.scraperSoftName,
        'output': 'json',
        'ssid': _settings.scraperUser,
        'sspassword': _settings.scraperPassword,
        'systemeid': platform.screenScraperId.toString(),
        'romnom': romName,
      });

      final http.Response response = await _client.get(uri).timeout(_timeout);
      if (response.statusCode != 200) return null;

      final dynamic decoded = jsonDecode(response.body);
      if (decoded is! Map<String, dynamic>) return null;
      final dynamic body = decoded['response'];
      if (body is! Map) return null;
      final dynamic jeu = body['jeu'];
      if (jeu is! Map) return null;

      final GameMetadata metadata = _parse(jeu);
      return metadata.isEmpty ? null : metadata;
    } on TimeoutException {
      return null;
    } catch (_) {
      return null;
    }
  }

  GameMetadata _parse(Map<dynamic, dynamic> jeu) {
    String? boxArt;
    String? logo;
    String? screenshot;

    final dynamic medias = jeu['medias'];
    if (medias is List) {
      for (final dynamic media in medias) {
        if (media is! Map) continue;
        final String? type = media['type']?.toString();
        final String? url = media['url']?.toString();
        if (url == null) continue;
        switch (type) {
          case 'box-2D':
            boxArt ??= url;
            break;
          case 'wheel':
          case 'marquee':
            logo ??= url;
            break;
          case 'ss':
          case 'sstitle':
            screenshot ??= url;
            break;
        }
      }
    }

    return GameMetadata(
      boxArtUrl: boxArt,
      logoUrl: logo,
      screenshotUrl: screenshot,
      description: _localizedText(jeu['synopsis']),
      developer: _flatText(jeu['developpeur']),
      publisher: _flatText(jeu['editeur']),
      genre: _genre(jeu),
      releaseDate: _localizedText(jeu['dates'], key: 'region'),
    );
  }

  String? _genre(Map<dynamic, dynamic> jeu) {
    final dynamic direct = _flatText(jeu['genre']);
    if (direct != null) return direct;
    final dynamic genres = jeu['genres'];
    if (genres is List && genres.isNotEmpty) {
      final dynamic first = genres.first;
      if (first is Map) return _localizedText(first['noms']);
    }
    return null;
  }

  /// ScreenScraper returns arrays of `{langue|region, text}` objects.
  String? _localizedText(dynamic raw, {String key = 'langue'}) {
    final List<String> preferred =
        key == 'region' ? _preferredRegions : _preferredLanguages;

    if (raw is List) {
      for (final String wanted in preferred) {
        for (final dynamic item in raw) {
          if (item is Map && item[key]?.toString() == wanted) {
            final String? text = item['text']?.toString();
            if (text != null && text.isNotEmpty) return text;
          }
        }
      }
      for (final dynamic item in raw) {
        if (item is Map) {
          final String? text = item['text']?.toString();
          if (text != null && text.isNotEmpty) return text;
        }
      }
    } else if (raw is Map) {
      return raw['text']?.toString();
    }
    return null;
  }

  String? _flatText(dynamic raw) {
    if (raw is Map) {
      final String? text = raw['text']?.toString();
      return (text != null && text.isNotEmpty) ? text : null;
    }
    if (raw is String && raw.isNotEmpty) return raw;
    return null;
  }
}
