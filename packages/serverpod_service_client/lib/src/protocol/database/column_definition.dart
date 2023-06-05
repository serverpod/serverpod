/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;

/// The definition of a (desired) column in the database.
abstract class ColumnDefinition extends _i1.SerializableEntity {
  const ColumnDefinition._();

  const factory ColumnDefinition({
    required String name,
    required _i2.ColumnType columnType,
    required bool isNullable,
    String? columnDefault,
    String? dartType,
  }) = _ColumnDefinition;

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

  ColumnDefinition copyWith({
    String? name,
    _i2.ColumnType? columnType,
    bool? isNullable,
    String? columnDefault,
    String? dartType,
  });

  /// The column name
  String get name;

  /// The actual column type
  _i2.ColumnType get columnType;

  /// Whether this column is nullable.
  bool get isNullable;

  /// The default for the column.
  String? get columnDefault;

  /// The (dart) type specified in the yaml file.
  /// Is nullable, since this is not available when
  /// analyzing the database.
  String? get dartType;
}

class _Undefined {}

/// The definition of a (desired) column in the database.
class _ColumnDefinition extends ColumnDefinition {
  const _ColumnDefinition({
    required this.name,
    required this.columnType,
    required this.isNullable,
    this.columnDefault,
    this.dartType,
  }) : super._();

  /// The column name
  @override
  final String name;

  /// The actual column type
  @override
  final _i2.ColumnType columnType;

  /// Whether this column is nullable.
  @override
  final bool isNullable;

  /// The default for the column.
  @override
  final String? columnDefault;

  /// The (dart) type specified in the yaml file.
  /// Is nullable, since this is not available when
  /// analyzing the database.
  @override
  final String? dartType;

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

  @override
  ColumnDefinition copyWith({
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
