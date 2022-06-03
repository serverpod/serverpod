import 'dart:math';

import '../../serverpod.dart';
import '../generated/protocol.dart';

/// Performs all health checks on the [Serverpod].
Future<ServerHealthResult> performHealthChecks(Serverpod pod) async {
  var now = DateTime.now().toUtc();
  now = DateTime.utc(now.year, now.month, now.day, now.hour, now.minute);

  var result = await defaultHealthCheckMetrics(pod, now);

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
  /*
  // Check cpu
  double psUsage = 0.0;
  bool psUsageHealthy = false;

  ProcessResult psResult;
  try {
    // ps -A -o %cpu | awk '{s+=$1} END {print s}'
    psResult = await Process.run('ps', ['-A', '-o', '%cpu']);
    List<String> psStrs = psResult.stdout.toString().split('\n');
    psStrs.removeAt(0);

    for (var psStr in psStrs) {
      psUsage += double.tryParse(psStr) ?? 0.0;
    }
    psUsageHealthy = true;
  }
  catch(e, stackTrace) {
    print('CPU Health check failed: $e');
    print('memResult: $psResult');
    print('stdout: ${psResult?.stdout}');
    print('stderr: ${psResult?.stderr}');
    print('$stackTrace');
    print('Local stack trace');
    print('${StackTrace.current}');
  }

  // Check memory usage
  double memUsage = 0.0;
  bool memUsageHealthy = false;

  ProcessResult memResult;
  try {
    // ps -A -o %cpu | awk '{s+=$1} END {print s}'
    memResult = await Process.run('ps', ['-A', '-o', '%mem']);
    List<String> memStrs = memResult.stdout.toString().split('\n');
    memStrs.removeAt(0);

    for (var memStr in memStrs) {
      memUsage += double.tryParse(memStr) ?? 0.0;
    }
    memUsageHealthy = true;
  }
  catch(e, stackTrace) {
    print('CPU Health check failed: $e');
    print('memResult: $memResult');
    print('stdout: ${memResult?.stdout}');
    print('stderr: ${memResult?.stderr}');
    print('$stackTrace');
    print('Local stack trace');
    print('${StackTrace.current}');
  }
  */

  // Check database response time
  var dbResponseTime = 0.0;
  var dbHealthy = false;

  try {
    var startTime = DateTime.now();
    var rnd = Random().nextInt(1000000);

    var databaseConnection = pod.databaseConfig.createConnection();

    // Write entry
    ReadWriteTestEntry? entry = ReadWriteTestEntry(
      number: rnd,
    );

    var session = await pod.createSession();
    await databaseConnection.insert(entry, session: session);

    // Read entry
    entry = await databaseConnection.findById<ReadWriteTestEntry>(entry.id!,
        session: session);
    await session.close();

    // Verify random number
    dbHealthy = entry?.number == rnd;

    dbResponseTime =
        DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
  }
  // ignore: empty_catches
  catch (e) {}

  var connectionsInfo = pod.server.httpServer.connectionsInfo();

  return ServerHealthResult(
    metrics: [
      ServerHealthMetric(
        serverId: pod.serverId,
        name: 'serverpod_database',
        timestamp: timestamp,
        value: dbResponseTime,
        isHealthy: dbHealthy,
      ),
    ],
    connectionInfos: [
      ServerHealthConnectionInfo(
        serverId: pod.serverId,
        type: 0,
        timestamp: timestamp,
        active: connectionsInfo.active,
        closing: connectionsInfo.closing,
        idle: connectionsInfo.idle,
      )
    ],
  );

//    ServerHealthMetric(
//      name: 'serverpod_cpu',
//      value: psUsage,
//      isHealthy: psUsageHealthy,
//    ),
//    ServerHealthMetric(
//      name: 'serverpod_memory',
//      value: memUsage,
//      isHealthy: memUsageHealthy,
//    ),
}
