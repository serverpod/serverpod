import 'dart:io';
import 'dart:math';

import '../generated/protocol.dart';
import '../../serverpod.dart';

Future<ServerHealthResult> performHealthChecks(Serverpod pod) async {
  var metrics = <ServerHealthMetric>[];
  if (pod.healthCheckHandler != null) {
    metrics.addAll(await pod.healthCheckHandler(pod));
  }

  metrics.addAll(await defaultHealthCheckMetrics(pod));

  return ServerHealthResult(
    serverName: pod.server.name,
    metrics: metrics,
  );
}

Future<List<ServerHealthMetric>> defaultHealthCheckMetrics(Serverpod pod) async {
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
  double dbResponseTime = 0.0;
  bool dbHealthy = false;

  try {
    var startTime = DateTime.now();
    int rnd = Random().nextInt(1000000);

    DatabaseConnection databaseConnection = pod.database.createConnection();

    // Write entry
    ReadWriteTestEntry? entry = ReadWriteTestEntry(
      number: rnd,
    );

    await databaseConnection.insert(entry);

    // Read entry
    entry = await databaseConnection.findById(tReadWriteTestEntry, entry.id!) as ReadWriteTestEntry?;

    // Verify random number
    dbHealthy = entry?.number == rnd;

    dbResponseTime = DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
  }
  catch(e) {
  }

  var connectionsInfo = pod.server.httpServer.connectionsInfo();
  var connectionsInfoService = pod.serviceServer.httpServer.connectionsInfo();


  return <ServerHealthMetric>[
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
    ServerHealthMetric(
      name: 'serverpod_database',
      value: dbResponseTime,
      isHealthy: dbHealthy,
    ),
    ServerHealthMetric(
      name: 'serverpod_connections_active',
      value: connectionsInfo.active.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_connections_closing',
      value: connectionsInfo.closing.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_connections_idle',
      value: connectionsInfo.idle.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_connections_total',
      value: connectionsInfo.total.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_service_connections_active',
      value: connectionsInfoService.active.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_service_connections_closing',
      value: connectionsInfoService.closing.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_service_connections_idle',
      value: connectionsInfoService.idle.toDouble(),
      isHealthy: true,
    ),
    ServerHealthMetric(
      name: 'serverpod_service_connections_total',
      value: connectionsInfoService.total.toDouble(),
      isHealthy: true,
    ),
  ];
}