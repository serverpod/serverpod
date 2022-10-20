/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;

class Channel extends _i1.SerializableEntity {
  Channel({
    this.id,
    required this.name,
    required this.channel,
  });

  factory Channel.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Channel(
      id: serializationManager.deserializeJson<int?>(jsonSerialization['id']),
      name: serializationManager
          .deserializeJson<String>(jsonSerialization['name']),
      channel: serializationManager
          .deserializeJson<String>(jsonSerialization['channel']),
    );
  }

  int? id;

  String name;

  String channel;

  @override
  String get className => 'Channel';
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
  }
}
