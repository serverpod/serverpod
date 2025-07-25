/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../long_identifiers/models_with_relations/user_note.dart' as _i2;

abstract class UserNoteCollection implements _i1.SerializableModel {
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

  factory UserNoteCollection.fromJson(Map<String, dynamic> jsonSerialization) {
    return UserNoteCollection(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      userNotesPropertyName:
          (jsonSerialization['userNotesPropertyName'] as List?)
              ?.map((e) => _i2.UserNote.fromJson((e as Map<String, dynamic>)))
              .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.UserNote>? userNotesPropertyName;

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
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

  /// Returns a shallow copy of this [UserNoteCollection]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
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
          : this.userNotesPropertyName?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
