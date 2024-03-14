/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class UserNoteCollection extends _i1.SerializableEntity {
  UserNoteCollection._({
    this.id,
    required this.name,
    this.userNotesPropertyName,
  });

  factory UserNoteCollection({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) = _UserNoteCollectionImpl;

  factory UserNoteCollection.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteCollection(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      userNotesPropertyName:
          serializationManager.deserialize<List<_i2.UserNote>?>(
              jsonSerialization['userNotesPropertyName']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.UserNote>? userNotesPropertyName;

  UserNoteCollection copyWith({
    int? id,
    String? name,
    List<_i2.UserNote>? userNotesPropertyName,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (userNotesPropertyName != null)
        'userNotesPropertyName':
            userNotesPropertyName?.toJson(valueToJson: (v) => v.toJson()),
    };
  }
}

class _Undefined {}

class _UserNoteCollectionImpl extends UserNoteCollection {
  _UserNoteCollectionImpl({
    int? id,
    required String name,
    List<_i2.UserNote>? userNotesPropertyName,
  }) : super._(
          id: id,
          name: name,
          userNotesPropertyName: userNotesPropertyName,
        );

  @override
  UserNoteCollection copyWith({
    Object? id = _Undefined,
    String? name,
    Object? userNotesPropertyName = _Undefined,
  }) {
    return UserNoteCollection(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      userNotesPropertyName: userNotesPropertyName is List<_i2.UserNote>?
          ? userNotesPropertyName
          : this.userNotesPropertyName?.clone(),
    );
  }
}
