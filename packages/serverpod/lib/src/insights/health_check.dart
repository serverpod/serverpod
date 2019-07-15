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
    print('Usage: $psUsage');
    psUsageHealthy = true;
  }
  catch(e) {
  }

  return <ServerHealthMetric>[
    ServerHealthMetric(
      name: 'serverpod_cpu',
      value: psUsage,
      isHealthy: psUsageHealthy,
    ),
  ];
}