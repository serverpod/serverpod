/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// Represents a chat channel.
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
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      channel: serializationManager
          .deserialize<String>(jsonSerialization['channel']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// The name of the channel.
  final String name;

  /// The id of the channel.
  final String channel;

  late Function({
    int? id,
    String? name,
    String? channel,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'channel': channel,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is Channel &&
            (identical(
                  other.id,
                  id,
                ) ||
                other.id == id) &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.channel,
                  channel,
                ) ||
                other.channel == channel));
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        channel,
      );

  Channel _copyWith({
    Object? id = _Undefined,
    String? name,
    String? channel,
  }) {
    return Channel(
      id: id == _Undefined ? this.id : (id as int?),
      name: name ?? this.name,
      channel: channel ?? this.channel,
    );
  }
}
