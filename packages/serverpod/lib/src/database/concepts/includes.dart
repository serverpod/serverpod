import 'package:serverpod/src/database/concepts/columns.dart';
import 'package:serverpod/src/database/concepts/expressions.dart';
import 'package:serverpod/src/database/concepts/order.dart';
import 'package:serverpod/src/database/concepts/table.dart';

/// The base include class, should not be used directly.
abstract class Include {
  /// Map containing the relation field name as key and the [Include] object
  /// for the foreign table as value.
  Map<String, Include?> get includes;

  /// Accessor for the [Table] this include is for.
  Table get table;
}

/// Defines what tables to join when querying a table.
abstract class IncludeObject extends Include {}

/// Defines what tables to join when querying a table.
abstract class IncludeList extends Include {
  /// Constructs a new [IncludeList] object.
  IncludeList({
    this.where,
    this.limit,
    this.offset,
    this.orderBy,
    this.orderDescending = false,
    this.orderByList,
    this.include,
  });

  /// Where expression to filter the included list.
  Expression? where;

  /// The maximum number of rows to return.
  int? limit;

  /// The number of rows to skip.
  int? offset;

  /// The column to order by.
  Column? orderBy;

  /// Whether the column should be ordered descending or ascending.
  bool orderDescending = false;

  /// The columns to order by.
  List<Order>? orderByList;

  /// The nested includes
  IncludeObject? include;
}
