/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../protocol.dart' as _i2;

abstract class Comment extends _i1.TableRow {
  Comment._({
    int? id,
    required this.description,
    required this.orderId,
    this.order,
  }) : super(id);

  factory Comment({
    int? id,
    required String description,
    required int orderId,
    _i2.Order? order,
  }) = _CommentImpl;

  factory Comment.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return Comment(
      id: serializationManager.deserialize<int?>(jsonSerialization['id']),
      description: serializationManager
          .deserialize<String>(jsonSerialization['description']),
      orderId:
          serializationManager.deserialize<int>(jsonSerialization['orderId']),
      order: serializationManager
          .deserialize<_i2.Order?>(jsonSerialization['order']),
    );
  }

  static final t = CommentTable();

  static final db = CommentRepository._();

  String description;

  int orderId;

  _i2.Order? order;

  @override
  _i1.Table get table => t;
  Comment copyWith({
    int? id,
    String? description,
    int? orderId,
    _i2.Order? order,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'orderId': orderId,
      'order': order,
    };
  }

  @override
  @Deprecated('Will be removed in 2.0.0')
  Map<String, dynamic> toJsonForDatabase() {
    return {
      'id': id,
      'description': description,
      'orderId': orderId,
    };
  }

  @override
  Map<String, dynamic> allToJson() {
    return {
      'id': id,
      'description': description,
      'orderId': orderId,
      'order': order,
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
      case 'description':
        description = value;
        return;
      case 'orderId':
        orderId = value;
        return;
      default:
        throw UnimplementedError();
    }
  }

  static Future<List<Comment>> find(
    _i1.Session session, {
    CommentExpressionBuilder? where,
    int? limit,
    int? offset,
    _i1.Column? orderBy,
    List<_i1.Order>? orderByList,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CommentInclude? include,
  }) async {
    return session.db.find<Comment>(
      where: where != null ? where(Comment.t) : null,
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

  static Future<Comment?> findSingleRow(
    _i1.Session session, {
    CommentExpressionBuilder? where,
    int? offset,
    _i1.Column? orderBy,
    bool orderDescending = false,
    bool useCache = true,
    _i1.Transaction? transaction,
    CommentInclude? include,
  }) async {
    return session.db.findSingleRow<Comment>(
      where: where != null ? where(Comment.t) : null,
      offset: offset,
      orderBy: orderBy,
      orderDescending: orderDescending,
      useCache: useCache,
      transaction: transaction,
      include: include,
    );
  }

  static Future<Comment?> findById(
    _i1.Session session,
    int id, {
    CommentInclude? include,
  }) async {
    return session.db.findById<Comment>(
      id,
      include: include,
    );
  }

  static Future<int> delete(
    _i1.Session session, {
    required CommentWithoutManyRelationsExpressionBuilder where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Comment>(
      where: where(Comment.t),
      transaction: transaction,
    );
  }

  static Future<bool> deleteRow(
    _i1.Session session,
    Comment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow(
      row,
      transaction: transaction,
    );
  }

  static Future<bool> update(
    _i1.Session session,
    Comment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.update(
      row,
      transaction: transaction,
    );
  }

  static Future<void> insert(
    _i1.Session session,
    Comment row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert(
      row,
      transaction: transaction,
    );
  }

  static Future<int> count(
    _i1.Session session, {
    CommentExpressionBuilder? where,
    int? limit,
    bool useCache = true,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Comment>(
      where: where != null ? where(Comment.t) : null,
      limit: limit,
      useCache: useCache,
      transaction: transaction,
    );
  }

  static CommentInclude include({_i2.OrderInclude? order}) {
    return CommentInclude._(order: order);
  }
}

class _Undefined {}

class _CommentImpl extends Comment {
  _CommentImpl({
    int? id,
    required String description,
    required int orderId,
    _i2.Order? order,
  }) : super._(
          id: id,
          description: description,
          orderId: orderId,
          order: order,
        );

  @override
  Comment copyWith({
    Object? id = _Undefined,
    String? description,
    int? orderId,
    Object? order = _Undefined,
  }) {
    return Comment(
      id: id is int? ? id : this.id,
      description: description ?? this.description,
      orderId: orderId ?? this.orderId,
      order: order is _i2.Order? ? order : this.order?.copyWith(),
    );
  }
}

typedef CommentExpressionBuilder = _i1.Expression Function(CommentTable);
typedef CommentWithoutManyRelationsExpressionBuilder = _i1.Expression Function(
    CommentWithoutManyRelationsTable);

class CommentTable extends CommentWithoutManyRelationsTable {
  CommentTable({
    super.queryPrefix,
    super.tableRelations,
  });
}

class CommentWithoutManyRelationsTable extends _i1.Table {
  CommentWithoutManyRelationsTable({
    super.queryPrefix,
    super.tableRelations,
  }) : super(tableName: 'comment') {
    description = _i1.ColumnString(
      'description',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
    orderId = _i1.ColumnInt(
      'orderId',
      queryPrefix: super.queryPrefix,
      tableRelations: super.tableRelations,
    );
  }

  late final _i1.ColumnString description;

  late final _i1.ColumnInt orderId;

  _i2.OrderTable? _order;

  _i2.OrderTable get order {
    if (_order != null) return _order!;
    _order = _i1.createRelationTable(
      queryPrefix: queryPrefix,
      fieldName: 'order',
      foreignTableName: _i2.Order.t.tableName,
      column: orderId,
      foreignColumnName: _i2.Order.t.id.columnName,
      createTable: (
        relationQueryPrefix,
        foreignTableRelation,
      ) =>
          _i2.OrderTable(
        queryPrefix: relationQueryPrefix,
        tableRelations: [
          ...?tableRelations,
          foreignTableRelation,
        ],
      ),
    );
    return _order!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        description,
        orderId,
      ];
  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'order') {
      return order;
    }
    return null;
  }
}

@Deprecated('Use CommentTable.t instead.')
CommentTable tComment = CommentTable();

class CommentInclude extends _i1.Include {
  CommentInclude._({_i2.OrderInclude? order}) {
    _order = order;
  }

  _i2.OrderInclude? _order;

  @override
  Map<String, _i1.Include?> get includes => {'order': _order};
  @override
  _i1.Table get table => Comment.t;
}

class CommentRepository {
  const CommentRepository._();

  final attach = const CommentAttachRepository._();
}

class CommentAttachRepository {
  const CommentAttachRepository._();

  Future<void> order(
    _i1.Session session,
    Comment comment,
    _i2.Order order,
  ) async {
    if (comment.id == null) {
      throw ArgumentError.notNull('comment.id');
    }
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $comment = comment.copyWith(orderId: order.id);
    await session.db.update(
      $comment,
      columns: [Comment.t.orderId],
    );
  }
}
