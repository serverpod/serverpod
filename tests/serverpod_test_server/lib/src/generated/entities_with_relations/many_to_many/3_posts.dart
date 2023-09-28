/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Posts extends _i1.TableRow {
  Posts._({
    int? id,
    required this.text,
    required this.authorId,
    this.author,
  }) : super(id);

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

  static final t = PostsTable();

  static final db = PostsRepository._();

  String text;

  int authorId;

  _i2.Author? author;

  @override
  _i1.Table get table => t;

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

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'text': text,
      'authorId': authorId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'text': text,
      'authorId': authorId,
      'author': author,
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
      case 'text':
        text = value;
        return;
      case 'authorId':
        authorId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Posts>> find(
    _i1.Session session, {
    PostsExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostsInclude? include,
  }) async {
    return session.db.find<Posts>(
      where: where != null ? where(Posts.t) : null,
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

  static Future<Posts?> findSingleRow(
    _i1.Session session, {
    PostsExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    PostsInclude? include,
  }) async {
    return session.db.findSingleRow<Posts>(
      where: where != null ? where(Posts.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Posts?> findById(
    _i1.Session session,
    int id, {
    PostsInclude? include,
  }) async {
    return session.db.findById<Posts>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required PostsWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Posts>(
      where: where(Posts.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Posts row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Posts row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Posts row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    PostsExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Posts>(
      where: where != null ? where(Posts.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static PostsInclude include({_i2.AuthorInclude? author}) {
    return PostsInclude._(author: author);
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

typedef PostsExpressionBuilder = _i1.Expression Function(PostsTable);
typedef PostsWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    PostsWithoutManyRelationsTable);

class PostsTable extends PostsWithoutManyRelationsTable {
  PostsTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class PostsWithoutManyRelationsTable extends _i1.Table {
  PostsWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'posts') {
    text = _i1.ColumnString(
      'text',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    authorId = _i1.ColumnInt(
      'authorId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString text;

  late final _i1.ColumnInt authorId;

  _i2.AuthorTable? _author;

  _i2.AuthorTable get author {
    if (_author != null) return _author!;
    _author = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'author',
      foreignTableName: _i2.Author.t.tableName,
      column: authorId,
      foreignColumnName: _i2.Author.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.AuthorTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _author!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        text,
        authorId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'author') {
      return author;
    }
    return null;
  }
}

@Deprecated('Use PostsTable.t instead.')
PostsTable tPosts = PostsTable();

class PostsInclude extends _i1.Include {
  PostsInclude._({_i2.AuthorInclude? author}) {
    _author = author;
  }

  _i2.AuthorInclude? _author;

  @override
  Map<String, _i1.Include?> get includes => {'author': _author};

  @override
  _i1.Table get table => Posts.t;
}

class PostsRepository {
  const PostsRepository._();

  final attach = const PostsAttachRepository._();
}

class PostsAttachRepository {
  const PostsAttachRepository._();

  Future<void> author(
    _i1.Session session,
    Posts posts,
    _i2.Author author,
  ) async {
    if (posts.id == null) {
      throw ArgumentError.notNull('posts.id');
    }
    if (author.id == null) {
      throw ArgumentError.notNull('author.id');
    }

    var $posts = posts.copyWith(authorId: author.id);
    await session.db.update(
      $posts,
      columns: [Posts.t.authorId],
    );
  }
}
