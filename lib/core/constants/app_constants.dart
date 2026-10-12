/// Global, non-localized application constants.
class AppConstants {
  AppConstants._();

  static const String appName = 'DroidDeck GameHub';
  static const String appVersion = '1.0.0';

  /// Maximum number of ROMs enriched with metadata per scan (rate limiting).
  static const int maxEnrichPerScan = 60;

  /// Polling cadence for the system performance monitor.
  static const Duration systemPollInterval = Duration(seconds: 2);

  /// Scraper identity advertised to ScreenScraper.
  static const String scraperSoftName = 'gamehub-droiddeck';
}
