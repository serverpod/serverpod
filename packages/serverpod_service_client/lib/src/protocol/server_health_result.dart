/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_client/serverpod_client.dart';
// ignore: unused_import
import 'protocol.dart';

class ServerHealthResult extends SerializableEntity {
  @override
  String get className => 'ServerHealthResult';

  int? id;
  late List<ServerHealthMetric> metrics;
  late String serverName;

  ServerHealthResult({
    this.id,
    required this.metrics,
    required this.serverName,
});

  ServerHealthResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    metrics = _data['metrics']!.map<ServerHealthMetric>((a) => ServerHealthMetric.fromSerialization(a))?.toList();
    serverName = _data['serverName']!;
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics.map((ServerHealthMetric a) => a.serialize()).toList(),
      'serverName': serverName,
    });
  }
}

