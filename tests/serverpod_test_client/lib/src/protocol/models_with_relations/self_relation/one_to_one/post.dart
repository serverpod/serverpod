/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../../protocol.dart' as _i2;

abstract class Post extends _i1.SerializableEntity {
  Post._({
    this.id,
    required this.content,
    this.previous,
    this.nextId,
    this.next,
  });

  factory Post({
    int? id,
    required String content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  }) = _PostImpl;

  factory Post.fromJson(Map<String, dynamic> jsonSerialization) {
    return Post(
      id: jsonSerialization['id'] as int?,
      content: jsonSerialization['content'] as String,
      previous: jsonSerialization.containsKey('previous')
          ? _i2.Post.fromJson(
              jsonSerialization['previous'] as Map<String, dynamic>)
          : null,
      nextId: jsonSerialization['nextId'] as int?,
      next: jsonSerialization.containsKey('next')
          ? _i2.Post.fromJson(jsonSerialization['next'] as Map<String, dynamic>)
          : null,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String content;

  _i2.Post? previous;

  int? nextId;

  _i2.Post? next;

  Post copyWith({
    int? id,
    String? content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'content': content,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId,
      if (next != null) 'next': next?.toJson(),
    };
  }
}

class _Undefined {}

class _PostImpl extends Post {
  _PostImpl({
    int? id,
    required String content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  }) : super._(
          id: id,
          content: content,
          previous: previous,
          nextId: nextId,
          next: next,
        );

  @override
  Post copyWith({
    Object? id = _Undefined,
    String? content,
    Object? previous = _Undefined,
    Object? nextId = _Undefined,
    Object? next = _Undefined,
  }) {
    return Post(
      id: id is int? ? id : this.id,
      content: content ?? this.content,
      previous: previous is _i2.Post? ? previous : this.previous?.copyWith(),
      nextId: nextId is int? ? nextId : this.nextId,
      next: next is _i2.Post? ? next : this.next?.copyWith(),
    );
  }
}
