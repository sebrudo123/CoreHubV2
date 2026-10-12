import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/native/native_emulator_launcher.dart';
import 'core/native/native_installed_apps.dart';
import 'core/native/native_rom_scanner.dart';
import 'core/native/native_system_monitor.dart';
import 'core/services/gamepad_navigation_engine.dart';
import 'core/services/settings_service.dart';
import 'features/library/data/datasources/installed_games_data_source.dart';
import 'features/library/data/datasources/rom_local_data_source.dart';
import 'features/library/data/datasources/scraper_remote_data_source.dart';
import 'features/library/data/repositories/game_repository_impl.dart';
import 'features/library/domain/repositories/game_repository.dart';
import 'features/library/domain/usecases/enrich_game_metadata.dart';
import 'features/library/domain/usecases/launch_game.dart';
import 'features/library/domain/usecases/scan_library.dart';
import 'features/library/presentation/controllers/library_controller.dart';
import 'features/system/data/repositories/system_repository_impl.dart';
import 'features/system/domain/repositories/system_repository.dart';
import 'features/system/presentation/controllers/system_monitor_controller.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations(const <DeviceOrientation>[
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  final SettingsService settings = SettingsService();
  await settings.load();

  final GameRepository gameRepository = GameRepositoryImpl(
    romLocal: const RomLocalDataSource(NativeRomScanner()),
    installedApps: const InstalledGamesDataSource(NativeInstalledApps()),
    scraper: ScraperRemoteDataSource(settings: settings),
    emulator: const NativeEmulatorLauncher(),
  );

  const SystemRepository systemRepository =
      SystemRepositoryImpl(NativeSystemMonitor());

  GamepadNavigationEngine.instance.start();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<SettingsService>.value(value: settings),
        Provider<GameRepository>.value(value: gameRepository),
        Provider<SystemRepository>.value(value: systemRepository),
        ChangeNotifierProvider<LibraryController>(
          create: (_) => LibraryController(
            scanLibrary: ScanLibrary(gameRepository),
            enrichGameMetadata: EnrichGameMetadata(gameRepository),
            launchGame: LaunchGame(gameRepository),
          )..initialize(),
        ),
        ChangeNotifierProvider<SystemMonitorController>(
          create: (_) =>
              SystemMonitorController(repository: systemRepository)..start(),
        ),
      ],
      child: const CoreHubApp(),
    ),
  );
}
