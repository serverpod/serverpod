/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// Represents a chat channel.
abstract class Channel extends _i1.SerializableEntity {
  Channel._({
    this.id,
    required this.name,
    required this.channel,
  });

  factory Channel({
    int? id,
    required String name,
    required String channel,
  }) = _ChannelImpl;

  factory Channel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Channel(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      channel: jsonSerialization['channel'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  /// The name of the channel.
  String name;

  /// The id of the channel.
  String channel;

  Channel copyWith({
    int? id,
    String? name,
    String? channel,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'channel': channel,
    };
  }
}

class _Undefined {}

class _ChannelImpl extends Channel {
  _ChannelImpl({
    int? id,
    required String name,
    required String channel,
  }) : super._(
          id: id,
          name: name,
          channel: channel,
        );

  @override
  Channel copyWith({
    Object? id = _Undefined,
    String? name,
    String? channel,
  }) {
    return Channel(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      channel: channel ?? this.channel,
    );
  }
}
