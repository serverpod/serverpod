import 'dart:io';

import 'package:colorize/colorize.dart';
import 'package:intl/intl.dart';

import 'package:serverpod_shared/config.dart';
// import 'package:serverpod_service_client/protocol/protocol.dart';

final _dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

// class Insights {
//   Map<int, Client> _clients = <int, Client>{};
//   ServiceKeyManager? _keyManager;
//
//   Insights(String configFile, {int serverId=0}) {
//     var config = ServerConfig(configFile, serverId);
//     _keyManager = ServiceKeyManager('Console', config);
//
//     for (int k in config.cluster.keys) {
//       var context = SecurityContext();
//       context.setTrustedCertificates(sslCertificatePath(configFile, k));
//       _clients[k] = Client('https://${config.cluster[k]!.address}:${config.cluster[k]!.servicePort}/', authenticationKeyManager: _keyManager, context: context);
//     }
//   }
//
//   Future<Null> shutdown() async {
//     for (var client in _clients.values) {
//       try {
//         await client.insights.shutdown();
//       }
//       catch(e) {
//         print('Failed to shutdown server at ${client.host}');
//       }
//     }
//   }
//
//   Future<Null> healthCheck() async {
//     for (var serverId in _clients.keys) {
//       var client = _clients[serverId]!;
//       print(Colorize('Server id $serverId')..bold());
//       print('host: ${client.host}');
//
//       try {
//         var result = await client.insights.checkHealth() as ServerHealthResult;
//         print('name: ${result.serverName}');
//
//         for (var metric in result.metrics!) {
//           String metricStr = '${metric.name}: ${metric.isHealthy! ? 'Healthy' : 'Broken'}${metric.value != null ? ' : ${metric.value}': ''}';
//           if (metric.isHealthy!)
//             metricStr = '${Colorize(metricStr)..green()}';
//           else
//             metricStr = '${Colorize(metricStr)..red()}';
//
//           print(metricStr);
//         }
//       }
//       catch(e) {
//         print(Colorize('Failed to health check server at ${client.host}')..red());
//       }
//
//       print('');
//     }
//   }
//
//   Future<Null> printLogs(int n) async {
//     var client = _clients[0] ?? _clients.values.first;
//
//     try {
//       var log = await client.insights.getLog(n) as LogResult;
//       for (var entry in log.entries!.reversed) {
//         _printLogEntry(entry);
//       }
//     }
//     catch(e) {
//       print('Failed to get logs from server at ${client.host}');
//     }
//   }
//
//   void _printLogEntry(LogEntry entry) {
//     var logLevel = LogLevel.values[entry.logLevel!];
//     String levelName = logLevel.name.toUpperCase();
//     if (logLevel == LogLevel.error || logLevel == LogLevel.fatal)
//       levelName = (Colorize(levelName)..red()).toString();
//     if (logLevel == LogLevel.warning)
//       levelName = (Colorize(levelName)..yellow()).toString();
//     if (logLevel == LogLevel.info)
//       levelName = (Colorize(levelName)..green()).toString();
//     if (logLevel == LogLevel.debug)
//       levelName = (Colorize(levelName)..darkGray()).toString();
//
//     print('[${entry.serverId} ${_dateFormat.format(entry.time!)} $levelName] ${entry.message}');
//
//     if (entry.stackTrace != null && entry.stackTrace != 'null')
//       print(Colorize(entry.stackTrace!)..red());
//   }
//
//   Future<Null> printSessionLogs(int n) async {
//     var client = _clients[0] ?? _clients.values.first;
//
//     try {
//       var sessionLog = await client.insights.getSessionLog(n) as SessionLogResult;
//       for (var entry in sessionLog.sessionLog!.reversed) {
//         String methodName = '${Colorize('${entry.sessionLogEntry!.endpoint}.${entry.sessionLogEntry!.method}')..bold()}';
//         String message = '[${entry.sessionLogEntry!.serverId} ${_dateFormat.format(entry.sessionLogEntry!.time!)}] ' + methodName + ' time: ${entry.sessionLogEntry!.duration!.toStringAsFixed(3)}s';
//         if (entry.sessionLogEntry!.error != null) {
//           print(Colorize(message)..red());
//           print(Colorize(entry.sessionLogEntry!.error!)..red());
//           print(entry.sessionLogEntry!.stackTrace);
//         }
//         else if (entry.sessionLogEntry!.slow!) {
//           print(Colorize(message)..yellow());
//         }
//         else {
//           print(message);
//         }
//
//         for (var query in entry.queries!) {
//           print('${query.query} time: ${query.duration!.toStringAsFixed(3)}s rows: ${query.numRows}');
//         }
//
//         for (var messageLogEntry in entry.messageLog!) {
//           _printLogEntry(messageLogEntry);
//         }
//
//         print('');
//       }
//     }
//     catch(e, t) {
//       print('Failed to get session logs from server at ${client.host}');
//       print(e);
//       print(t);
//     }
//   }
//
//   Future<Null> printCachesInfo(bool? printKeys) async {
//
//     for (int serverId in _clients.keys) {
//       var client = _clients[serverId]!;
//
//       try {
//         var cachesInfo = await client.insights.getCachesInfo(printKeys) as CachesInfo;
//
//         _printCacheInfo(cachesInfo.local!, 'local', serverId);
//         _printCacheInfo(cachesInfo.localPrio!, 'localPrio', serverId);
//         _printCacheInfo(cachesInfo.distributed!, 'distributed', serverId);
//         _printCacheInfo(cachesInfo.distributedPrio!, 'distributedPrio', serverId);
//       }
//       catch (e, t) {
//         print('Failed to get caches info from server $e $t');
//       }
//     }
//   }
//
//   void _printCacheInfo(CacheInfo info, String name, int serverId) {
//     print('Server: $serverId Cache: $name size: ${info.numEntries} / ${info.maxEntries}');
//     if (info.keys != null) {
//       for (var key in info.keys!)
//         print('  $key');
//       print('');
//     }
//   }
//
//   void close() {
//     for (var client in _clients.values) {
//       client.close();
//     }
//   }
// }
