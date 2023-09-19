/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

abstract class Post extends _i1.TableRow {
  Post._({
    int? id,
    required this.content,
    this.previous,
    this.nextId,
    this.next,
  }) : super(id);

  factory Post({
    int? id,
    required String content,
    _i2.Post? previous,
    int? nextId,
    _i2.Post? next,
  }) = _PostImpl;

  factory Post.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Post(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      content: serializationManager
          .deserialize<String>(jsonSerialization['content']),
      previous: serializationManager
          .deserialize<_i2.Post?>(jsonSerialization['previous']),
      nextId:
          serializationManager.deserialize<int?>(jsonSerialization['nextId']),
      next: serializationManager
          .deserialize<_i2.Post?>(jsonSerialization['next']),
    );
  }

  static final t = PostTable();

  static final db = PostRepository._();

  String content;

  _i2.Post? previous;

  int? nextId;

  _i2.Post? next;

  @override
  _i1.Table get table => t;
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
      'id': id,
      'content': content,
      'previous': previous,
      'nextId': nextId,
      'next': next,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'content': content,
      'nextId': nextId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'content': content,
      'previous': previous,
      'nextId': nextId,
      'next': next,
    };
  }

  @override
  void setColumn(
    String columnName,
    value,
  ) {
    switch (columnName) {
      case 'id':
        id = value;
        return;
      case 'content':
        content = value;
        return;
      case 'nextId':
        nextId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Post>> find(
    _i1.Session session, {
    PostExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.db.find<Post>(
      where: where != null ? where(Post.t) : null,
      limit: limit,
      offset: offset,
      orderBy: orderBy,
      orderByList: orderByList,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Post?> findSingleRow(
    _i1.Session session, {
    PostExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostInclude? include,
  }) async {
    return session.db.findSingleRow<Post>(
      where: where != null ? where(Post.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Post?> findById(
    _i1.Session session,
    int id, {
    PostInclude? include,
  }) async {
    return session.db.findById<Post>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required PostExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Post>(
      where: where(Post.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Post row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    PostExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Post>(
      where: where != null ? where(Post.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static PostInclude include({
    _i2.PostInclude? previous,
    _i2.PostInclude? next,
  }) {
    return PostInclude._(
      previous: previous,
      next: next,
    );
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

typedef PostExpressionBuilder = _i1.Expression Function(PostTable);

class PostTable extends _i1.Table {
  PostTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'post') {
    content = _i1.ColumnString(
      'content',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    nextId = _i1.ColumnInt(
      'nextId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString content;

  _i2.PostTable? _previous;

  late final _i1.ColumnInt nextId;

  _i2.PostTable? _next;

  _i2.PostTable get previous {
    if (_previous != null) return _previous!;
    _previous = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'previous',
      foreignTableName: _i2.Post.t.tableName,
      column: id,
      foreignColumnName: _i2.Post.t.nextId.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.PostTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _previous!;
  }

  _i2.PostTable get next {
    if (_next != null) return _next!;
    _next = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'next',
      foreignTableName: _i2.Post.t.tableName,
      column: nextId,
      foreignColumnName: _i2.Post.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.PostTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _next!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        content,
        nextId,
      ];
  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'previous') {
      return previous;
    }
    if (relationField == 'next') {
      return next;
    }
    return null;
  }
}

@Deprecated('Use PostTable.t instead.')
PostTable tPost = PostTable();

class PostInclude extends _i1.Include {
  PostInclude._({
    _i2.PostInclude? previous,
    _i2.PostInclude? next,
  }) {
    _previous = previous;
    _next = next;
  }

  _i2.PostInclude? _previous;

  _i2.PostInclude? _next;

  @override
  Map<String, _i1.Include?> get includes => {
        'previous': _previous,
        'next': _next,
      };
  @override
  _i1.Table get table => Post.t;
}

class PostRepository {
  const PostRepository._();

  final attach = const PostAttachRepository._();

  final detach = const PostDetachRepository._();
}

class PostAttachRepository {
  const PostAttachRepository._();

  Future<void> previous(
    _i1.Session session,
    Post post,
    _i2.Post previous,
  ) async {
    if (previous.id == null) {
      throw ArgumentError.notNull('previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $previous = previous.copyWith(nextId: post.id);
    await session.db.update(
      $previous,
      columns: [_i2.Post.t.nextId],
    );
  }

  Future<void> next(
    _i1.Session session,
    Post post,
    _i2.Post next,
  ) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }
    if (next.id == null) {
      throw ArgumentError.notNull('next.id');
    }

    var $post = post.copyWith(nextId: next.id);
    await session.db.update(
      $post,
      columns: [Post.t.nextId],
    );
  }
}

class PostDetachRepository {
  const PostDetachRepository._();

  Future<void> previous(
    _i1.Session session,
    Post post,
  ) async {
    var $previous = post.previous;

    if ($previous == null) {
      throw ArgumentError.notNull('post.previous');
    }
    if ($previous.id == null) {
      throw ArgumentError.notNull('post.previous.id');
    }
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $$previous = $previous.copyWith(nextId: null);
    await session.db.update(
      $$previous,
      columns: [_i2.Post.t.nextId],
    );
  }

  Future<void> next(
    _i1.Session session,
    Post post,
  ) async {
    if (post.id == null) {
      throw ArgumentError.notNull('post.id');
    }

    var $post = post.copyWith(nextId: null);
    await session.db.update(
      $post,
      columns: [Post.t.nextId],
    );
  }
}
