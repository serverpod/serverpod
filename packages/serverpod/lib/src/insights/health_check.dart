import 'dart:io';

import '../generated/protocol.dart';
import '../../serverpod.dart';

Future<List<ServerHealthMetric>> healthCheck(Serverpod pod) async {
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

  return <ServerHealthMetric>[
    ServerHealthMetric(
      name: 'serverpod_cpu',
      value: psUsage,
      isHealthy: psUsageHealthy,
    ),
    ServerHealthMetric(
      name: 'serverpod_mem',
      value: memUsage,
      isHealthy: memUsageHealthy,
    ),
  ];
}