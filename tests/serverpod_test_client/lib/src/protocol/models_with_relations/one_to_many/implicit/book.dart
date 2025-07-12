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
import '../../../models_with_relations/one_to_many/implicit/chapter.dart'
    as _i2;

abstract class Book implements _i1.SerializableModel {
  Book._({
    this.id,
    required this.title,
    this.chapters,
  });

  factory Book({
    int? id,
    required String title,
    List<_i2.Chapter>? chapters,
  }) = _BookImpl;

  factory Book.fromJson(Map<String, dynamic> jsonSerialization) {
    return Book(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      chapters: (jsonSerialization['chapters'] as List?)
          ?.map((e) => _i2.Chapter.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  List<_i2.Chapter>? chapters;

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Book copyWith({
    int? id,
    String? title,
    List<_i2.Chapter>? chapters,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      if (chapters != null)
        'chapters': chapters?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _BookImpl extends Book {
  _BookImpl({
    int? id,
    required String title,
    List<_i2.Chapter>? chapters,
  }) : super._(
          id: id,
          title: title,
          chapters: chapters,
        );

  /// Returns a shallow copy of this [Book]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Book copyWith({
    Object? id = _Undefined,
    String? title,
    Object? chapters = _Undefined,
  }) {
    return Book(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      chapters: chapters is List<_i2.Chapter>?
          ? chapters
          : this.chapters?.map((e0) => e0.copyWith()).toList(),
    );
  }
}
