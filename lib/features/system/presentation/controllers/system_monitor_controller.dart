import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../domain/entities/system_stats.dart';
import '../../domain/repositories/system_repository.dart';

/// Periodically polls the native monitor and exposes the latest snapshot.
class SystemMonitorController extends ChangeNotifier {
  SystemMonitorController({
    required SystemRepository repository,
    this.interval = const Duration(seconds: 2),
  }) : _repository = repository;

  final SystemRepository _repository;
  final Duration interval;

  Timer? _timer;
  SystemStats _stats = SystemStats.empty;
  bool _polling = false;

  SystemStats get stats => _stats;

  void start() {
    _timer ??= Timer.periodic(interval, (_) => _refresh());
    unawaited(_refresh());
  }

  Future<void> _refresh() async {
    if (_polling) return;
    _polling = true;
    try {
      _stats = await _repository.fetchStats();
      notifyListeners();
    } finally {
      _polling = false;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
