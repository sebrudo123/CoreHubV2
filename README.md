# DroidDeck GameHub

Launcher / dashboard de juegos industrial para Android, construido con **Flutter**
y **Clean Architecture**. Escanea ROMs, lanza emuladores y apps instaladas, se
integra con gamepads y expone telemetría del sistema (CPU, RAM, batería,
temperatura) con una UI dark estilo *glassmorphism* a 60/120 FPS.

## Características

- **Biblioteca unificada**: ROMs locales (NES, SNES, N64, GB/GBC/GBA, NDS, 3DS,
  PS1/PS2/PSP, GameCube/Wii, Dreamcast, Sega, Arcade) + apps Android de tipo juego.
- **Escaneo nativo** de almacenamiento (`RomScanner`) con detección por extensión
  y carpeta de consola.
- **Metadata** vía ScreenScraper (`jeuInfos.php`), enriquecida en segundo plano.
- **Lanzamiento** de emuladores (RetroArch, PPSSPP, DuckStation, AetherSX2,
  Dolphin, Citra, Yuzu) con `file://` URI, o de apps instaladas.
- **Gamepad**: D-Pad y botones por foco de Flutter; sticks analógicos por
  `EventChannel` nativo (`GamepadNavigationEngine`, dead-zone 0.55, repeat 220 ms).
- **Monitoreo** de CPU/RAM/batería/temperatura/uptime/reloj.
- **Streaming**: accesos a Xbox Cloud, GeForce NOW, Moonlight, Steam Link, Luna.

## Arquitectura

Clean Architecture por feature (`domain` / `data` / `presentation`) + `core` y
`shared` transversales.

```
lib/
├── core/
│   ├── constants/app_constants.dart
│   ├── native/                 # bridges tipados a los MethodChannel/EventChannel
│   └── services/               # sound, settings, gamepad navigation
├── features/
│   ├── library/                # domain + data + presentation (grid, scan, scrape)
│   ├── system/                 # telemetría + ajustes
│   ├── streaming/              # tiles de servicios de streaming
│   └── dashboard/              # shell (nav rail + header + switch de páginas)
└── shared/
    ├── theme/                  # colores, tipografía, ThemeData
    └── widgets/                # GlassCard, GameFocus, AnimatedBackground, ...
```

### Canales nativos (Android/Kotlin)

| Canal | Tipo | Métodos |
| --- | --- | --- |
| `com.gamehub/rom_scanner` | MethodChannel | `discoverRoots`, `scan` |
| `com.gamehub/emulator` | MethodChannel | `listEmulators`, `launch` |
| `com.gamehub/system` | MethodChannel | `getStats` |
| `com.gamehub/apps` | MethodChannel | `getGames`, `launch` |
| `com.gamehub/gamepad` | EventChannel | stream de ejes analógicos |

Código nativo en `android/app/src/main/kotlin/com/gamehub/droiddeck/`.

## Requisitos

- Flutter `stable` (Dart `>=3.3`).
- JDK 17+ (el CI usa 21).
- Android SDK con `compileSdk 36`, `minSdk 26`, NDK `28.2.13676358`.
- Toolchain Gradle del template estable de Flutter: AGP `9.1.0`, Kotlin `2.4.0`,
  Gradle `9.3.1`.

## Compilar en local

```bash
flutter pub get
flutter analyze
flutter build apk --release          # APK: build/app/outputs/flutter-apk/app-release.apk
flutter build appbundle --release    # AAB para Play Store
```

> El `gradle-wrapper.jar` no se versiona: Flutter lo regenera desde
> `bin/cache/artifacts/gradle_wrapper` durante el build.

## CI/CD (GitHub Actions)

- `.github/workflows/build_apk.yml` — en cada push/PR: `pub get` → `analyze` →
  `build apk --release` y publica el artefacto **`gamehub-release-apk`**
  (contiene `gamehub-release.apk`).
- `.github/workflows/release_stores.yml` — manual (`workflow_dispatch`) o tag
  `v*`: genera **AAB + APK** y, opcionalmente, sube a Play; y genera build iOS
  (firmado si hay credenciales, sin firmar si no).

### Firma de release (Play Store)

1. Crea el keystore:

   ```bash
   keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA \
     -keysize 2048 -validity 10000 -alias upload
   ```

2. Crea `android/key.properties` (NO versionar):

   ```properties
   storePassword=...
   keyPassword=...
   keyAlias=upload
   storeFile=/ruta/absoluta/upload-keystore.jks
   ```

   Sin este archivo, el build usa la firma **debug** (APK instalable para
   pruebas, no válido para publicar).

3. Para el CI, sube como *secrets*: `ANDROID_KEYSTORE_BASE64`,
   `ANDROID_KEYSTORE_PASSWORD`, `ANDROID_KEY_ALIAS`, `ANDROID_KEY_PASSWORD`, y
   para Play `PLAY_SERVICE_ACCOUNT_JSON`.

### iOS / App Store

- Flutter (versión actual) requiere **iOS 15+**: **no es posible** compilar para
  iOS 10 (ni 9). Para iOS 10 haría falta una app nativa en Swift/Objective-C
  aparte, compilada con Xcode en macOS.
- El workflow iOS hace `flutter create --platforms=ios .` en un runner macOS.
- Enviar a App Store requiere macOS + Xcode, certificados de distribución,
  App ID y cuenta de Apple Developer (99 USD/año). Sin credenciales solo se
  genera un zip sin firmar (no instalable en dispositivos).
- **Aviso de política**: un launcher de ROMs/emuladores puede ser rechazado por
  App Store (guía 2.5.2) y está sujeto a la política de Play Store.

## Limitaciones conocidas

- La verificación de compilación se hace en CI (este entorno no incluye
  Flutter/Java/Android SDK).
- Los binarios de los emuladores no se incluyen; se asume que el usuario los
  tiene instalados.
