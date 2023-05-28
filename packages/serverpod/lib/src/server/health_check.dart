import 'dart:math';

import 'package:system_resources/system_resources.dart';

import '../../serverpod.dart';
import '../generated/protocol.dart';

/// Performs all health checks on the [Serverpod].
Future<ServerHealthResult> performHealthChecks(Serverpod pod) async {
  var now = DateTime.now().toUtc();
  now = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);

  final result = await defaultHealthCheckMetrics(pod, now);

  if (pod.healthCheckHandler != null) {
    result.metrics.addAll(await pod.healthCheckHandler!(pod, now));
  }

  return result;
}

/// Performs all default health checks on the [Serverpod].
Future<ServerHealthResult> defaultHealthCheckMetrics(
  Serverpod pod,
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
  var dbHealthy = false;

  try {
    final startTime = DateTime.now();
    final rnd = Random().nextInt(1000000);

    final databaseConnection = pod.databaseConfig.newConnection;

    // Write entry
    ReadWriteTestEntry? entry = ReadWriteTestEntry(
      number: rnd,
    );

    final session = await pod.createSession(enableLogging: false);
    await databaseConnection.insert(entry, session: session);

    // Read entry
    entry = await databaseConnection.findById<ReadWriteTestEntry>(
      entry.id!,
      session: session,
    );
    await session.close();

    // Verify random number
    dbHealthy = entry?.number == rnd;

    dbResponseTime =
        DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
  }
  // ignore: empty_catches
  catch (e) {}

  final connectionsInfo = pod.server.httpServer.connectionsInfo();

  return ServerHealthResult(
    metrics: [
      ServerHealthMetric(
        serverId: pod.serverId,
        name: 'serverpod_database',
        timestamp: timestamp,
        value: dbResponseTime,
        isHealthy: dbHealthy,
        granularity: 1,
      ),
      if (cpuLoad != null)
        ServerHealthMetric(
          serverId: pod.serverId,
          name: 'serverpod_cpu',
          timestamp: timestamp,
          value: cpuLoad,
          isHealthy: true,
          granularity: 1,
        ),
      if (memoryUsage != null)
        ServerHealthMetric(
          serverId: pod.serverId,
          name: 'serverpod_memory',
          timestamp: timestamp,
          value: memoryUsage,
          isHealthy: true,
          granularity: 1,
        ),
    ],
    connectionInfos: [
      ServerHealthConnectionInfo(
        serverId: pod.serverId,
        timestamp: timestamp,
        active: connectionsInfo.active,
        closing: connectionsInfo.closing,
        idle: connectionsInfo.idle,
        granularity: 1,
      )
    ],
  );
}
