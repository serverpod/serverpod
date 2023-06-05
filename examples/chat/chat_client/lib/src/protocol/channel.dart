/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a chat channel.
abstract class Channel extends _i1.SerializableEntity {
  const Channel._();

  const factory Channel({
    int? id,
    required String name,
    required String channel,
  }) = _Channel;

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

  Channel copyWith({
    int? id,
    String? name,
    String? channel,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// The name of the channel.
  String get name;

  /// The id of the channel.
  String get channel;
}

class _Undefined {}

/// Represents a chat channel.
class _Channel extends Channel {
  const _Channel({
    this.id,
    required this.name,
    required this.channel,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// The name of the channel.
  @override
  final String name;

  /// The id of the channel.
  @override
  final String channel;

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

  @override
  Channel copyWith({
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
