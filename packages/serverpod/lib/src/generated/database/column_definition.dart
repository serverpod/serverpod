/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;

class _Undefined {}

/// The definition of a (desired) column in the database.
class ColumnDefinition extends _i1.SerializableEntity {
  ColumnDefinition({
    required this.name,
    required this.columnType,
    required this.isNullable,
    this.columnDefault,
    this.dartType,
  });

  factory ColumnDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return ColumnDefinition(
      name: serializationManager.deserialize<String>(jsonSerialization['name']),
      columnType: serializationManager
          .deserialize<_i2.ColumnType>(jsonSerialization['columnType']),
      isNullable: serializationManager
          .deserialize<bool>(jsonSerialization['isNullable']),
      columnDefault: serializationManager
          .deserialize<String?>(jsonSerialization['columnDefault']),
      dartType: serializationManager
          .deserialize<String?>(jsonSerialization['dartType']),
    );
  }

  /// The column name
  final String name;

  /// The actual column type
  final _i2.ColumnType columnType;

  /// Whether this column is nullable.
  final bool isNullable;

  /// The default for the column.
  final String? columnDefault;

  /// The (dart) type specified in the yaml file.
  /// Is nullable, since this is not available when
  /// analyzing the database.
  final String? dartType;

  late Function({
    String? name,
    _i2.ColumnType? columnType,
    bool? isNullable,
    String? columnDefault,
    String? dartType,
  }) copyWith = _copyWith;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'columnType': columnType,
      'isNullable': isNullable,
      'columnDefault': columnDefault,
      'dartType': dartType,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is ColumnDefinition &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            (identical(
                  other.columnType,
                  columnType,
                ) ||
                other.columnType == columnType) &&
            (identical(
                  other.isNullable,
                  isNullable,
                ) ||
                other.isNullable == isNullable) &&
            (identical(
                  other.columnDefault,
                  columnDefault,
                ) ||
                other.columnDefault == columnDefault) &&
            (identical(
                  other.dartType,
                  dartType,
                ) ||
                other.dartType == dartType));
  }

  @override
  int get hashCode => Object.hash(
        name,
        columnType,
        isNullable,
        columnDefault,
        dartType,
      );

  ColumnDefinition _copyWith({
    String? name,
    _i2.ColumnType? columnType,
    bool? isNullable,
    Object? columnDefault = _Undefined,
    Object? dartType = _Undefined,
  }) {
    return ColumnDefinition(
      name: name ?? this.name,
      columnType: columnType ?? this.columnType,
      isNullable: isNullable ?? this.isNullable,
      columnDefault: columnDefault == _Undefined
          ? this.columnDefault
          : (columnDefault as String?),
      dartType: dartType == _Undefined ? this.dartType : (dartType as String?),
    );
  }
}
