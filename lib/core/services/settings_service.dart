import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'sound_service.dart';

/// Persisted user preferences (UI sounds, scraping and scraper credentials).
class SettingsService extends ChangeNotifier {
  static const String _kSounds = 'ui_sounds';
  static const String _kScraping = 'scrape_enabled';
  static const String _kDevId = 'ss_dev_id';
  static const String _kDevPassword = 'ss_dev_password';
  static const String _kUser = 'ss_user';
  static const String _kPassword = 'ss_password';

  SharedPreferences? _prefs;

  bool uiSounds = true;
  bool metadataScraping = true;
  String scraperDevId = '';
  String scraperDevPassword = '';
  String scraperUser = '';
  String scraperPassword = '';

  bool get credentialsConfigured =>
      scraperDevId.isNotEmpty && scraperDevPassword.isNotEmpty;

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    uiSounds = _prefs!.getBool(_kSounds) ?? true;
    metadataScraping = _prefs!.getBool(_kScraping) ?? true;
    scraperDevId = _prefs!.getString(_kDevId) ?? '';
    scraperDevPassword = _prefs!.getString(_kDevPassword) ?? '';
    scraperUser = _prefs!.getString(_kUser) ?? '';
    scraperPassword = _prefs!.getString(_kPassword) ?? '';
    SoundService.instance.enabled = uiSounds;
    notifyListeners();
  }

  Future<void> setUiSounds(bool value) async {
    uiSounds = value;
    SoundService.instance.enabled = value;
    notifyListeners();
    await _prefs?.setBool(_kSounds, value);
  }

  Future<void> setMetadataScraping(bool value) async {
    metadataScraping = value;
    notifyListeners();
    await _prefs?.setBool(_kScraping, value);
  }

  Future<void> setScraperCredentials({
    required String devId,
    required String devPassword,
    required String user,
    required String password,
  }) async {
    scraperDevId = devId.trim();
    scraperDevPassword = devPassword.trim();
    scraperUser = user.trim();
    scraperPassword = password.trim();
    notifyListeners();
    await _prefs?.setString(_kDevId, scraperDevId);
    await _prefs?.setString(_kDevPassword, scraperDevPassword);
    await _prefs?.setString(_kUser, scraperUser);
    await _prefs?.setString(_kPassword, scraperPassword);
  }
}
