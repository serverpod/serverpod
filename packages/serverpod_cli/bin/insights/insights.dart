import 'package:colorize/colorize.dart';
import 'package:intl/intl.dart';

import 'package:serverpod/serverpod.dart';
import 'package:serverpod_service_client/serverpod_service_client.dart';

class Insights {
  Map<int, Client> _clients = <int, Client>{};

  Insights(String configFile, {int serverId=0}) {
    var config = ServerConfig('config/$configFile.yaml', serverId);
    for (int k in config.cluster.keys) {
      _clients[k] = Client('http://${config.cluster[k].address}:${config.cluster[k].servicePort}/');
    }
  }

  Future<Null> shutdown() async {
    for (var client in _clients.values) {
      try {
        await client.insights.shutdown();
      }
      catch(e) {
        print('Failed to shutdown server at ${client.host}');
      }
    }
  }

  Future<Null> printLogs(int n) async {
    var dateFormat = DateFormat('yyyy-MM-dd hh:mm:ss');

    var client = _clients[0] ?? _clients.values.first;

    try {
      var log = await client.insights.getLog(n);
      for (var entry in log.entries.reversed) {
        var logLevel = LogLevel.values[entry.logLevel];
        String levelName = logLevel.name.toUpperCase();
        if (logLevel == LogLevel.error || logLevel == LogLevel.fatal)
          levelName = (Colorize(levelName)..red()).toString();
        if (logLevel == LogLevel.warning)
          levelName = (Colorize(levelName)..yellow()).toString();
        if (logLevel == LogLevel.info)
          levelName = (Colorize(levelName)..green()).toString();
        if (logLevel == LogLevel.debug)
          levelName = (Colorize(levelName)..darkGray()).toString();

        print('[${entry.serverId} ${dateFormat.format(entry.time)} $levelName] ${entry.message}');

        if (entry.stackTrace != null && entry.stackTrace != 'null')
          print(Colorize(entry.stackTrace)..red());
      }
    }
    catch(e) {
      print('Failed to get logs from server at ${client.host}');
    }
  }

  void close() {
    for (var client in _clients.values) {
      client.close();
    }
  }
}
