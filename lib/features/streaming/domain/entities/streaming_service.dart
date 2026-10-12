import 'package:flutter/material.dart';

/// Cloud / game-streaming client shortcuts.
class StreamingService {
  const StreamingService({
    required this.name,
    required this.packageName,
    required this.description,
    required this.accent,
    required this.icon,
  });

  final String name;
  final String packageName;
  final String description;
  final Color accent;
  final IconData icon;

  static const List<StreamingService> all = <StreamingService>[
    StreamingService(
      name: 'Xbox Cloud Gaming',
      packageName: 'com.microsoft.xcloud',
      description: 'Game Pass Ultimate · xCloud',
      accent: Color(0xFF107C10),
      icon: Icons.cloud_rounded,
    ),
    StreamingService(
      name: 'GeForce NOW',
      packageName: 'com.nvidia.geforcenow',
      description: 'NVIDIA cloud RTX streaming',
      accent: Color(0xFF76B900),
      icon: Icons.videogame_asset_rounded,
    ),
    StreamingService(
      name: 'Moonlight',
      packageName: 'com.moonlight.stream',
      description: 'GameStream / Sunshine client',
      accent: Color(0xFF7B61FF),
      icon: Icons.cast_rounded,
    ),
    StreamingService(
      name: 'Steam Link',
      packageName: 'com.valvesoftware.steamlink',
      description: 'PC in-home streaming',
      accent: Color(0xFF1B2838),
      icon: Icons.desktop_windows_rounded,
    ),
    StreamingService(
      name: 'Xbox',
      packageName: 'com.xbox',
      description: 'Remote Play & console link',
      accent: Color(0xFF107C10),
      icon: Icons.sports_esports_rounded,
    ),
    StreamingService(
      name: 'Amazon Luna',
      packageName: 'com.amazon.luna',
      description: 'Amazon cloud gaming',
      accent: Color(0xFF00A8E1),
      icon: Icons.wb_cloudy_rounded,
    ),
  ];
}
