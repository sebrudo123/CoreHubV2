import '../../../../core/native/native_system_monitor.dart';
import '../../domain/entities/system_stats.dart';
import '../../domain/repositories/system_repository.dart';

class SystemRepositoryImpl implements SystemRepository {
  const SystemRepositoryImpl(this._native);

  final NativeSystemMonitor _native;

  @override
  Future<SystemStats> fetchStats() async {
    final Map<String, dynamic>? raw = await _native.fetchStats();
    if (raw == null) return SystemStats.empty;
    return SystemStats.fromMap(raw);
  }
}
