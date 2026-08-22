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
import 'projected_author.dart' as _iq5hz6n4;

abstract class ProjectedArticle
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ProjectedArticle._({
    this.id,
    required this.title,
    required this.authorId,
    this.author,
    required this.summary,
    required this.content,
  });

  factory ProjectedArticle({
    int? id,
    required String title,
    required int authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    required String summary,
    required String content,
  }) = _ProjectedArticleImpl;

  factory ProjectedArticle.fromJson(Map<String, dynamic> jsonSerialization) {
    return ProjectedArticle(
      id: jsonSerialization['id'] as int?,
      title: jsonSerialization['title'] as String,
      authorId: jsonSerialization['authorId'] as int,
      author: jsonSerialization['author'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iq5hz6n4.ProjectedAuthor>(
              jsonSerialization['author'],
            ),
      summary: jsonSerialization['summary'] as String,
      content: jsonSerialization['content'] as String,
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String title;

  int authorId;

  _iq5hz6n4.ProjectedAuthor? author;

  String summary;

  String content;

  /// Returns a shallow copy of this [ProjectedArticle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ProjectedArticle copyWith({
    int? id,
    String? title,
    int? authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    String? summary,
    String? content,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ProjectedArticle',
      if (id != null) 'id': id,
      'title': title,
      'authorId': authorId,
      if (author != null) 'author': author?.toJson(),
      'summary': summary,
      'content': content,
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ProjectedArticle',
      if (id != null) 'id': id,
      'title': title,
      'authorId': authorId,
      if (author != null) 'author': author?.toJsonForProtocol(),
      'summary': summary,
      'content': content,
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _ProjectedArticleImpl extends ProjectedArticle {
  _ProjectedArticleImpl({
    int? id,
    required String title,
    required int authorId,
    _iq5hz6n4.ProjectedAuthor? author,
    required String summary,
    required String content,
  }) : super._(
         id: id,
         title: title,
         authorId: authorId,
         author: author,
         summary: summary,
         content: content,
       );

  /// Returns a shallow copy of this [ProjectedArticle]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ProjectedArticle copyWith({
    Object? id = _Undefined,
    String? title,
    int? authorId,
    Object? author = _Undefined,
    String? summary,
    String? content,
  }) {
    return ProjectedArticle(
      id: id is int? ? id : this.id,
      title: title ?? this.title,
      authorId: authorId ?? this.authorId,
      author: author is _iq5hz6n4.ProjectedAuthor?
          ? author
          : this.author?.copyWith(),
      summary: summary ?? this.summary,
      content: content ?? this.content,
    );
  }
}
