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

abstract class UserNoteCollectionWithALongName extends _i1.SerializableEntity {
  UserNoteCollectionWithALongName._({
    this.id,
    required this.name,
    this.notes,
  });

  factory UserNoteCollectionWithALongName({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) = _UserNoteCollectionWithALongNameImpl;

  factory UserNoteCollectionWithALongName.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return UserNoteCollectionWithALongName(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      notes: serializationManager.deserialize<List<_i2.UserNoteWithALongName>?>(
          jsonSerialization['notes']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String name;

  List<_i2.UserNoteWithALongName>? notes;

  UserNoteCollectionWithALongName copyWith({
    int? id,
    String? name,
    List<_i2.UserNoteWithALongName>? notes,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (notes != null) 'notes': notes,
    };
  }
}

class _Undefined {}

class _UserNoteCollectionWithALongNameImpl
    extends UserNoteCollectionWithALongName {
  _UserNoteCollectionWithALongNameImpl({
    int? id,
    required String name,
    List<_i2.UserNoteWithALongName>? notes,
  }) : super._(
          id: id,
          name: name,
          notes: notes,
        );

  @override
  UserNoteCollectionWithALongName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? notes = _Undefined,
  }) {
    return UserNoteCollectionWithALongName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      notes: notes is List<_i2.UserNoteWithALongName>?
          ? notes
          : this.notes?.clone(),
    );
  }
}
