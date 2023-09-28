/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Posts extends _i1.SerializableEntity {
  Posts._({
    this.id,
    required this.text,
    required this.authorId,
    this.author,
  });

  factory Posts({
    int? id,
    required String text,
    required int authorId,
    _i2.Author? author,
  }) = _PostsImpl;

  factory Posts.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Posts(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      text: serializationManager.deserialize<String>(jsonSerialization['text']),
      authorId:
          serializationManager.deserialize<int>(jsonSerialization['authorId']),
      author: serializationManager
          .deserialize<_i2.Author?>(jsonSerialization['author']),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  String text;

  int authorId;

  _i2.Author? author;

  Posts copyWith({
    int? id,
    String? text,
    int? authorId,
    _i2.Author? author,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'authorId': authorId,
      'author': author,
    };
  }
}

class _Undefined {}

class _PostsImpl extends Posts {
  _PostsImpl({
    int? id,
    required String text,
    required int authorId,
    _i2.Author? author,
  }) : super._(
          id: id,
          text: text,
          authorId: authorId,
          author: author,
        );

  @override
  Posts copyWith({
    Object? id = _Undefined,
    String? text,
    int? authorId,
    Object? author = _Undefined,
  }) {
    return Posts(
      id: id is int? ? id : this.id,
      text: text ?? this.text,
      authorId: authorId ?? this.authorId,
      author: author is _i2.Author? ? author : this.author?.copyWith(),
    );
  }
}
