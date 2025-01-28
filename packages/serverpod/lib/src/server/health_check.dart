import 'dart:io';
import 'dart:math';

import 'package:serverpod/src/server/features.dart';
import 'package:serverpod/src/service/service_manager.dart';
import 'package:system_resources/system_resources.dart';

import '../../serverpod.dart';
import '../generated/protocol.dart';

/// Performs all health checks on the [Serverpod].
Future<ServerHealthResult> performHealthChecks(
    ServiceLocator serviceLocator) async {
  var now = DateTime.now().toUtc();
  now = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);

  var result = await defaultHealthCheckMetrics(serviceLocator, now);

  HealthCheckHandler? healthCheckHandler =
      serviceLocator.locate<HealthCheckHandler>();
  if (healthCheckHandler != null) {
    result.metrics.addAll(await healthCheckHandler(serviceLocator, now));
  }

  return result;
}

/// Performs all default health checks on the [Serverpod].
Future<ServerHealthResult> defaultHealthCheckMetrics(
  ServiceLocator serviceLocator,
  DateTime timestamp,
) async {
  double? cpuLoad;
  double? memoryUsage;

  try {
    cpuLoad = SystemResources.cpuLoadAvg();
    memoryUsage = SystemResources.memUsage();
  } catch (e) {
    // Health checks are not supported on this platform. A message should have
    // been written to stderr when starting the health check monitor.
  }

  // Check database response time
  var dbResponseTime = 0.0;
  bool? dbHealthy;

  if (Features.enableDatabase) {
    try {
      var startTime = DateTime.now();
      var rnd = Random().nextInt(1000000);

      // Write entry
      ReadWriteTestEntry? entry = ReadWriteTestEntry(
        number: rnd,
      );

      entry = await ReadWriteTestEntry.db
          .insertRow(serviceLocator.locate<Session>()!, entry);

      // Verify random number
      dbHealthy = entry.number == rnd;

      dbResponseTime =
          DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
    }
    // ignore: empty_catches
    catch (e) {}
  }

  var connectionsInfo = serviceLocator.locate<HttpServer>()!.connectionsInfo();
  String serverId = serviceLocator.locate<String>(name: 'serverId')!;

  return ServerHealthResult(
    metrics: [
      if (dbHealthy != null)
        ServerHealthMetric(
          serverId: serverId,
          name: 'serverpod_database',
          timestamp: timestamp,
          value: dbResponseTime,
          isHealthy: dbHealthy,
          granularity: 1,
        ),
      if (cpuLoad != null)
        ServerHealthMetric(
          serverId: serverId,
          name: 'serverpod_cpu',
          timestamp: timestamp,
          value: cpuLoad,
          isHealthy: true,
          granularity: 1,
        ),
      if (memoryUsage != null)
        ServerHealthMetric(
          serverId: serverId,
          name: 'serverpod_memory',
          timestamp: timestamp,
          value: memoryUsage,
          isHealthy: true,
          granularity: 1,
        ),
    ],
    connectionInfos: [
      ServerHealthConnectionInfo(
        serverId: serverId,
        timestamp: timestamp,
        active: connectionsInfo.active,
        closing: connectionsInfo.closing,
        idle: connectionsInfo.idle,
        granularity: 1,
      )
    ],
  );
}
