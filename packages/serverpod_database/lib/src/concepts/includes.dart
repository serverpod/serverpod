import '../../serverpod_database.dart';

/// Marker interface for includes compatible with JSON queries (`findAsJson`).
abstract interface class JsonCompatibleInclude implements Include {}

/// Marker interface for includes producing complete models compatible with typed queries (`find`).
abstract interface class FullModelInclude implements JsonCompatibleInclude {}

/// The base include class, should not be used directly.
abstract class Include {
  /// Map containing the relation field name as key and the [Include] object
  /// for the foreign table as value.
  Map<String, Include?> get includes;

  /// Accessor for the [Table] this include is for.
  Table get table;

  /// Optional list of columns to select from the included table.
  List<Column>? get selectedColumns => null;
}

/// Defines what tables to join when querying a table.
abstract class IncludeObject extends Include implements JsonCompatibleInclude {}

/// Defines what tables to join when querying a table.
abstract class IncludeList extends Include implements JsonCompatibleInclude {
  /// Constructs a new [IncludeList] object.
  IncludeList({
    this.where,
    this.limit,
    this.offset,
    this.orderBy,
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

  /// The columns to order by.
  List<Column>? orderByList;

  /// The nested includes
  JsonCompatibleInclude? include;
}
