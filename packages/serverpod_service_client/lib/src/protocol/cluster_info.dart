/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'protocol.dart' as _i2;

class ClusterInfo extends _i1.SerializableEntity {
  ClusterInfo({required this.servers});

  factory ClusterInfo.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ClusterInfo(
        servers:
            serializationManager.deserializeJson<List<_i2.ClusterServerInfo>>(
                jsonSerialization['servers']));
  }

  List<_i2.ClusterServerInfo> servers;

  @override
  String get className => 'ClusterInfo';
  @override
  Map<String, dynamic> toJson() {
    return {'servers': servers};
  }
}
