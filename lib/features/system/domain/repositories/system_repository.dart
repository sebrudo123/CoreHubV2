import '../entities/system_stats.dart';

abstract class SystemRepository {
  Future<SystemStats> fetchStats();
}
