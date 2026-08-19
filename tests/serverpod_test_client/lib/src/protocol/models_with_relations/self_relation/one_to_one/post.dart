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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import '../../../models_with_relations/self_relation/one_to_one/post.dart'
    as _ittc76ec;

abstract class Post
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
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
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  }) = _PostImpl;

  factory Post.fromJson(Map<String, dynamic> jsonSerialization) {
    return Post(
      id: jsonSerialization['id'] as int?,
      content: jsonSerialization['content'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ittc76ec.Post>(
              jsonSerialization['previous'],
            ),
      nextId: jsonSerialization['nextId'] as int?,
      next: jsonSerialization['next'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ittc76ec.Post>(
              jsonSerialization['next'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String content;

  _ittc76ec.Post? previous;

  int? nextId;

  _ittc76ec.Post? next;

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  Post copyWith({
    int? id,
    String? content,
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'content': content,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId,
      if (next != null) 'next': next?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'Post',
      if (id != null) 'id': id,
      'content': content,
      if (previous != null) 'previous': previous?.toJsonForProtocol(),
      if (nextId != null) 'nextId': nextId,
      if (next != null) 'next': next?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PostImpl extends Post {
  _PostImpl({
    int? id,
    required String content,
    _ittc76ec.Post? previous,
    int? nextId,
    _ittc76ec.Post? next,
  }) : super._(
         id: id,
         content: content,
         previous: previous,
         nextId: nextId,
         next: next,
       );

  /// Returns a shallow copy of this [Post]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
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
      previous: previous is _ittc76ec.Post?
          ? previous
          : this.previous?.copyWith(),
      nextId: nextId is int? ? nextId : this.nextId,
      next: next is _ittc76ec.Post? ? next : this.next?.copyWith(),
    );
  }
}
