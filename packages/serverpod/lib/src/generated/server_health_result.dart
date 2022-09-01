/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ServerHealthResult extends SerializableEntity {
  @override
  String get className => 'ServerHealthResult';

  int? id;
  late List<ServerHealthMetric> metrics;
  late List<ServerHealthConnectionInfo> connectionInfos;

  ServerHealthResult({
    this.id,
    required this.metrics,
    required this.connectionInfos,
  });

  ServerHealthResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
    id = _data['id'];
    metrics = _data['metrics']!
        .map<ServerHealthMetric>((a) => ServerHealthMetric.fromSerialization(a))
        ?.toList();
    connectionInfos = _data['connectionInfos']!
        .map<ServerHealthConnectionInfo>(
            (a) => ServerHealthConnectionInfo.fromSerialization(a))
        ?.toList();
  }

  @override
  Map<String, dynamic> serialize() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics.map((ServerHealthMetric a) => a.serialize()).toList(),
      'connectionInfos': connectionInfos
          .map((ServerHealthConnectionInfo a) => a.serialize())
          .toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'id': id,
      'metrics': metrics.map((ServerHealthMetric a) => a.serialize()).toList(),
      'connectionInfos': connectionInfos
          .map((ServerHealthConnectionInfo a) => a.serialize())
          .toList(),
    });
  }
}
