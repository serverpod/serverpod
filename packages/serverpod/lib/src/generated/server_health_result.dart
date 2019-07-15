/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names

import 'package:serverpod_serialization/serverpod_serialization.dart';
// ignore: unused_import
import 'protocol.dart';

class ServerHealthResult extends SerializableEntity {
  String get className => 'ServerHealthResult';

  int id;
  List<ServerHealthMetric> metrics;
  String serverName;

  ServerHealthResult({
    this.id,
    this.metrics,
    this.serverName,
});

  ServerHealthResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    metrics = _data['metrics']?.map<ServerHealthMetric>((a) => ServerHealthMetric.fromSerialization(a))?.toList();
    serverName = _data['serverName'];
  }

  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics?.map((ServerHealthMetric a) => a.serialize())?.toList(),
      'serverName': serverName,
    });
  }
  Map<String, dynamic> serializeForDatabase() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics?.map((ServerHealthMetric a) => a.serialize())?.toList(),
      'serverName': serverName,
    });
  }

  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics?.map((ServerHealthMetric a) => a.serialize())?.toList(),
      'serverName': serverName,
    });
  }
}

