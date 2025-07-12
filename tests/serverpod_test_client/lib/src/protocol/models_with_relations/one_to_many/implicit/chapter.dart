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

abstract class Chapter implements _i1.SerializableModel {
  Chapter._({
    this.id,
    required this.title,
  });

  factory Chapter({
    int? id,
    required String title,
  }) = _ChapterImpl;

  factory Chapter.fromJson(Map<String, dynamic> jsonSerialization) {
    return Chapter(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Chapter copyWith({
    int? id,
    String? title,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ChapterImpl extends Chapter {
  _ChapterImpl({
    int? id,
    required String title,
  }) : super._(
          id: id,
          title: title,
        );

  /// Returns a shallow copy of this [Chapter]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Chapter copyWith({
    Object? id = _Undefined,
    String? title,
  }) {
    return Chapter(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
    );
  }
}
