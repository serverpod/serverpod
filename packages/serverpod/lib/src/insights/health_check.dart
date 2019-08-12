import 'dart:io';
import 'dart:math';

import '../generated/protocol.dart';
import '../../serverpod.dart';

Future<List<ServerHealthMetric>> healthCheck(Serverpod pod, Session session) async {
  // Check cpu
  double psUsage = 0.0;
  bool psUsageHealthy = false;

  try {
    // ps -A -o %cpu | awk '{s+=$1} END {print s}'
    var psResult = await Process.run('ps', ['-A', '-o', '%cpu']);
    List<String> psStrs = psResult.stdout.toString().split('\n');
    psStrs.removeAt(0);

    for (var psStr in psStrs) {
      psUsage += double.tryParse(psStr) ?? 0.0;
    }
    psUsageHealthy = true;
  }
  catch(e) {
  }

  // Check memory usage
  double memUsage = 0.0;
  bool memUsageHealthy = false;

  try {
    // ps -A -o %cpu | awk '{s+=$1} END {print s}'
    var memResult = await Process.run('ps', ['-A', '-o', '%mem']);
    List<String> memStrs = memResult.stdout.toString().split('\n');
    memStrs.removeAt(0);

    for (var memStr in memStrs) {
      memUsage += double.tryParse(memStr) ?? 0.0;
    }
    memUsageHealthy = true;
  }
  catch(e) {
  }

  // Check database response time
  double dbResponseTime = 0.0;
  bool dbHealthy = false;

  try {
    var startTime = DateTime.now();
    int rnd = Random().nextInt(1000000);

    // Write entry
    ReadWriteTestEntry entry = ReadWriteTestEntry(
      number: rnd,
    );

    await session.insert(entry);

    // Read entry
    entry = await session.findById(tReadWriteTestEntry, entry.id);

    // Verify random number
    dbHealthy = entry.number == rnd;

    dbResponseTime = DateTime.now().difference(startTime).inMicroseconds / 1000000.0;
  }
  catch(e) {
  }


  return <ServerHealthMetric>[
    ServerHealthMetric(
      name: 'serverpod_cpu',
      value: psUsage,
      isHealthy: psUsageHealthy,
    ),
    ServerHealthMetric(
      name: 'serverpod_memory',
      value: memUsage,
      isHealthy: memUsageHealthy,
    ),
    ServerHealthMetric(
      name: 'serverpod_database',
      value: dbResponseTime,
      isHealthy: dbHealthy,
    ),
  ];
}