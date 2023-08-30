/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;

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

  int? id;

  /// Name of the future call. Used to find the correct method to call.
  String name;

  /// Time to execute the call.
  DateTime time;

  /// The serialized object, used as a parameter to the call.
  String? serializedObject;

  /// The id of the server where the call was created.
  String serverId;

  /// An optional identifier which can be used to cancel the call.
  String? identifier;

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
}
