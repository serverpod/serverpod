/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

class _Undefined {}

/// A serialized future call with bindings to the database.
class FutureCallEntry extends _i1.SerializableEntity {
  FutureCallEntry({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  });

  factory FutureCallEntry.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return FutureCallEntry(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      time:
          serializationManager.deserialize<DateTime>(jsonSerialization['time']),
      serializedObject: serializationManager
          .deserialize<String?>(jsonSerialization['serializedObject']),
      serverId: serializationManager
          .deserialize<String>(jsonSerialization['serverId']),
      identifier: serializationManager
          .deserialize<String?>(jsonSerialization['identifier']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  final int? id;

  /// Name of the future call. Used to find the correct method to call.
  final String name;

  /// Time to execute the call.
  final DateTime time;

  /// The serialized object, used as a parameter to the call.
  final String? serializedObject;

  /// The id of the server where the call was created.
  final String serverId;

  /// An optional identifier which can be used to cancel the call.
  final String? identifier;

  late Function({
    int? id,
    String? name,
    DateTime? time,
    String? serializedObject,
    String? serverId,
    String? identifier,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'time': time,
      'serializedObject': serializedObject,
      'serverId': serverId,
      'identifier': identifier,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is FutureCallEntry &&
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
                  other.time,
                  time,
                ) ||
                other.time == time) &&
            (identical(
                  other.serializedObject,
                  serializedObject,
                ) ||
                other.serializedObject == serializedObject) &&
            (identical(
                  other.serverId,
                  serverId,
                ) ||
                other.serverId == serverId) &&
            (identical(
                  other.identifier,
                  identifier,
                ) ||
                other.identifier == identifier));
  }

  @override
  int get hashCode => Object.hash(
        id,
        name,
        time,
        serializedObject,
        serverId,
        identifier,
      );

  FutureCallEntry _copyWith({
    Object? id = _Undefined,
    String? name,
    DateTime? time,
    Object? serializedObject = _Undefined,
    String? serverId,
    Object? identifier = _Undefined,
  }) {
    return FutureCallEntry(
      id: id == _Undefined ? this.id : (id as int?),
      name: name ?? this.name,
      time: time ?? this.time,
      serializedObject: serializedObject == _Undefined
          ? this.serializedObject
          : (serializedObject as String?),
      serverId: serverId ?? this.serverId,
      identifier:
          identifier == _Undefined ? this.identifier : (identifier as String?),
    );
  }
}
