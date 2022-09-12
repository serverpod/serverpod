/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: unused_import
// ignore_for_file: unnecessary_import
// ignore_for_file: overridden_fields
// ignore_for_file: no_leading_underscores_for_local_identifiers
// ignore_for_file: depend_on_referenced_packages

import 'package:serverpod_serialization/serverpod_serialization.dart';
import 'dart:typed_data';
import 'protocol.dart';

class ServerHealthResult extends SerializableEntity {
  @override
  String get className => 'ServerHealthResult';

  late List<ServerHealthMetric> metrics;
  late List<ServerHealthConnectionInfo> connectionInfos;

  ServerHealthResult({
    required this.metrics,
    required this.connectionInfos,
  });

  ServerHealthResult.fromSerialization(Map<String, dynamic> serialization) {
    var _data = unwrapSerializationData(serialization);
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
      'metrics': metrics.map((ServerHealthMetric a) => a.serialize()).toList(),
      'connectionInfos': connectionInfos
          .map((ServerHealthConnectionInfo a) => a.serialize())
          .toList(),
    });
  }

  @override
  Map<String, dynamic> serializeAll() {
    return wrapSerializationData({
      'metrics': metrics.map((ServerHealthMetric a) => a.serialize()).toList(),
      'connectionInfos': connectionInfos
          .map((ServerHealthConnectionInfo a) => a.serialize())
          .toList(),
    });
  }
}
