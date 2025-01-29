/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../../models_with_relations/one_to_many/order.dart' as _i2;

abstract class Customer implements _i1.TableRow, _i1.ProtocolSerialization {
  Customer._({
    this.id,
    required this.name,
    this.orders,
  });

  factory Customer({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) = _CustomerImpl;

  factory Customer.fromJson(Map<String, dynamic> jsonSerialization) {
    return Customer(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      orders: (jsonSerialization['orders'] as List?)
          ?.map((e) => _i2.Order.fromJson((e as Map<String, dynamic>)))
          .toList(),
    );
  }

  static final t = CustomerTable();

  static const db = CustomerRepository._();

  @override
  int? id;

  String name;

  List<_i2.Order>? orders;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  Customer copyWith({
    int? id,
    String? name,
    List<_i2.Order>? orders,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (orders != null)
        'orders': orders?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  static CustomerInclude include({_i2.OrderIncludeList? orders}) {
    return CustomerInclude._(orders: orders);
  }

  static CustomerIncludeList includeList({
    _i1.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerTable>? orderByList,
    CustomerInclude? include,
  }) {
    return CustomerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(Customer.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(Customer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _CustomerImpl extends Customer {
  _CustomerImpl({
    int? id,
    required String name,
    List<_i2.Order>? orders,
  }) : super._(
          id: id,
          name: name,
          orders: orders,
        );

  /// Returns a shallow copy of this [Customer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  Customer copyWith({
    Object? id = _Undefined,
    String? name,
    Object? orders = _Undefined,
  }) {
    return Customer(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      orders: orders is List<_i2.Order>?
          ? orders
          : this.orders?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class CustomerTable extends _i1.Table {
  CustomerTable({super.tableRelation}) : super(tableName: 'customer') {
    name = _i1.ColumnString(
      'name',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.OrderTable? ___orders;

  _i1.ManyRelation<_i2.OrderTable>? _orders;

  _i2.OrderTable get __orders {
    if (___orders != null) return ___orders!;
    ___orders = _i1.createRelationTable(
      relationFieldName: '__orders',
      field: Customer.t.id,
      foreignField: _i2.Order.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderTable(tableRelation: foreignTableRelation),
    );
    return ___orders!;
  }

  _i1.ManyRelation<_i2.OrderTable> get orders {
    if (_orders != null) return _orders!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'orders',
      field: Customer.t.id,
      foreignField: _i2.Order.t.customerId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.OrderTable(tableRelation: foreignTableRelation),
    );
    _orders = _i1.ManyRelation<_i2.OrderTable>(
      tableWithRelations: relationTable,
      table: _i2.OrderTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _orders!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'orders') {
      return __orders;
    }
    return null;
  }
}

class CustomerInclude extends _i1.IncludeObject {
  CustomerInclude._({_i2.OrderIncludeList? orders}) {
    _orders = orders;
  }

  _i2.OrderIncludeList? _orders;

  @override
  Map<String, _i1.Include?> get includes => {'orders': _orders};

  @override
  _i1.Table get table => Customer.t;
}

class CustomerIncludeList extends _i1.IncludeList {
  CustomerIncludeList._({
    _i1.WhereExpressionBuilder<CustomerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(Customer.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => Customer.t;
}

class CustomerRepository {
  const CustomerRepository._();

  final attach = const CustomerAttachRepository._();

  final attachRow = const CustomerAttachRowRepository._();

  final detach = const CustomerDetachRepository._();

  final detachRow = const CustomerDetachRowRepository._();

  /// Returns a list of [Customer]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<Customer>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<CustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerTable>? orderByList,
    _i1.Transaction? transaction,
    CustomerInclude? include,
  }) async {
    return session.db.find<Customer>(
      where: where?.call(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [Customer] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<Customer?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerTable>? where,
    int? offset,
    _i1.OrderByBuilder<CustomerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<CustomerTable>? orderByList,
    _i1.Transaction? transaction,
    CustomerInclude? include,
  }) async {
    return session.db.findFirstRow<Customer>(
      where: where?.call(Customer.t),
      orderBy: orderBy?.call(Customer.t),
      orderByList: orderByList?.call(Customer.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [Customer] by its [id] or null if no such row exists.
  Future<Customer?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    CustomerInclude? include,
  }) async {
    return session.db.findById<Customer>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [Customer]s in the list and returns the inserted rows.
  ///
  /// The returned [Customer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<Customer>> insert(
    _i1.Session session,
    List<Customer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<Customer>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [Customer] and returns the inserted row.
  ///
  /// The returned [Customer] will have its `id` field set.
  Future<Customer> insertRow(
    _i1.Session session,
    Customer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [Customer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<Customer>> update(
    _i1.Session session,
    List<Customer> rows, {
    _i1.ColumnSelections<CustomerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<Customer>(
      rows,
      columns: columns?.call(Customer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [Customer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<Customer> updateRow(
    _i1.Session session,
    Customer row, {
    _i1.ColumnSelections<CustomerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<Customer>(
      row,
      columns: columns?.call(Customer.t),
      transaction: transaction,
    );
  }

  /// Deletes all [Customer]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<Customer>> delete(
    _i1.Session session,
    List<Customer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<Customer>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [Customer].
  Future<Customer> deleteRow(
    _i1.Session session,
    Customer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<Customer>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<Customer>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<CustomerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<Customer>(
      where: where(Customer.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<CustomerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<Customer>(
      where: where?.call(Customer.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class CustomerAttachRepository {
  const CustomerAttachRepository._();

  /// Creates a relation between this [Customer] and the given [Order]s
  /// by setting each [Order]'s foreign key `customerId` to refer to this [Customer].
  Future<void> orders(
    _i1.Session session,
    Customer customer,
    List<_i2.Order> order, {
    _i1.Transaction? transaction,
  }) async {
    if (order.any((e) => e.id == null)) {
      throw ArgumentError.notNull('order.id');
    }
    if (customer.id == null) {
      throw ArgumentError.notNull('customer.id');
    }

    var $order = order.map((e) => e.copyWith(customerId: customer.id)).toList();
    await session.db.update<_i2.Order>(
      $order,
      columns: [_i2.Order.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerAttachRowRepository {
  const CustomerAttachRowRepository._();

  /// Creates a relation between this [Customer] and the given [Order]
  /// by setting the [Order]'s foreign key `customerId` to refer to this [Customer].
  Future<void> orders(
    _i1.Session session,
    Customer customer,
    _i2.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }
    if (customer.id == null) {
      throw ArgumentError.notNull('customer.id');
    }

    var $order = order.copyWith(customerId: customer.id);
    await session.db.updateRow<_i2.Order>(
      $order,
      columns: [_i2.Order.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerDetachRepository {
  const CustomerDetachRepository._();

  /// Detaches the relation between this [Customer] and the given [Order]
  /// by setting the [Order]'s foreign key `customerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.Session session,
    List<_i2.Order> order, {
    _i1.Transaction? transaction,
  }) async {
    if (order.any((e) => e.id == null)) {
      throw ArgumentError.notNull('order.id');
    }

    var $order = order.map((e) => e.copyWith(customerId: null)).toList();
    await session.db.update<_i2.Order>(
      $order,
      columns: [_i2.Order.t.customerId],
      transaction: transaction,
    );
  }
}

class CustomerDetachRowRepository {
  const CustomerDetachRowRepository._();

  /// Detaches the relation between this [Customer] and the given [Order]
  /// by setting the [Order]'s foreign key `customerId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> orders(
    _i1.Session session,
    _i2.Order order, {
    _i1.Transaction? transaction,
  }) async {
    if (order.id == null) {
      throw ArgumentError.notNull('order.id');
    }

    var $order = order.copyWith(customerId: null);
    await session.db.updateRow<_i2.Order>(
      $order,
      columns: [_i2.Order.t.customerId],
      transaction: transaction,
    );
  }
}
