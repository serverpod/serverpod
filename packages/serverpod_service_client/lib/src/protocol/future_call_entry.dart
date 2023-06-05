/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

/// A serialized future call with bindings to the database.
abstract class FutureCallEntry extends _i1.SerializableEntity {
  const FutureCallEntry._();

  const factory FutureCallEntry({
    int? id,
    required String name,
    required DateTime time,
    String? serializedObject,
    required String serverId,
    String? identifier,
  }) = _FutureCallEntry;

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

  FutureCallEntry copyWith({
    int? id,
    String? name,
    DateTime? time,
    String? serializedObject,
    String? serverId,
    String? identifier,
  });

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? get id;

  /// Name of the future call. Used to find the correct method to call.
  String get name;

  /// Time to execute the call.
  DateTime get time;

  /// The serialized object, used as a parameter to the call.
  String? get serializedObject;

  /// The id of the server where the call was created.
  String get serverId;

  /// An optional identifier which can be used to cancel the call.
  String? get identifier;
}

class _Undefined {}

/// A serialized future call with bindings to the database.
class _FutureCallEntry extends FutureCallEntry {
  const _FutureCallEntry({
    this.id,
    required this.name,
    required this.time,
    this.serializedObject,
    required this.serverId,
    this.identifier,
  }) : super._();

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  @override
  final int? id;

  /// Name of the future call. Used to find the correct method to call.
  @override
  final String name;

  /// Time to execute the call.
  @override
  final DateTime time;

  /// The serialized object, used as a parameter to the call.
  @override
  final String? serializedObject;

  /// The id of the server where the call was created.
  @override
  final String serverId;

  /// An optional identifier which can be used to cancel the call.
  @override
  final String? identifier;

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

  @override
  FutureCallEntry copyWith({
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
