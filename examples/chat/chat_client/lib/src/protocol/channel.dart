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
abstract class Channel implements _i1.SerializableModel {
  Channel._({
    this.id,
    required this.name,
    required this.channel,
    required this.point,
  });

  factory Channel({
    int? id,
    required String name,
    required String channel,
    required geographyPoint point,
  }) = _ChannelImpl;

  factory Channel.fromJson(Map<String, dynamic> jsonSerialization) {
    return Channel(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      channel: jsonSerialization['channel'] as String,
      point: geographyPoint
          .fromJson((jsonSerialization['point'] as Map<String, dynamic>)),
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

  geographyPoint point;

  Channel copyWith({
    int? id,
    String? name,
    String? channel,
    geographyPoint? point,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      'channel': channel,
      'point': point.toJson(),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChannelImpl extends Channel {
  _ChannelImpl({
    int? id,
    required String name,
    required String channel,
    required geographyPoint point,
  }) : super._(
          id: id,
          name: name,
          channel: channel,
          point: point,
        );

  @override
  Channel copyWith({
    Object? id = _Undefined,
    String? name,
    String? channel,
    geographyPoint? point,
  }) {
    return Channel(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      channel: channel ?? this.channel,
      point: point ?? this.point.copyWith(),
    );
  }
}
