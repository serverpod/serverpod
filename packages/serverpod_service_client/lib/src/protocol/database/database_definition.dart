/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// Defines the structure of the database used by Serverpod.
abstract class DatabaseDefinition extends _i1.SerializableEntity {
  const DatabaseDefinition._();

  const factory DatabaseDefinition({
    String? name,
    required List<_i2.TableDefinition> tables,
  }) = _DatabaseDefinition;

  factory DatabaseDefinition.fromJson(
    Map<String, dynamic> jsonSerialization,
    _i1.SerializationManager serializationManager,
  ) {
    return DatabaseDefinition(
      name:
          serializationManager.deserialize<String?>(jsonSerialization['name']),
      tables: serializationManager
          .deserialize<List<_i2.TableDefinition>>(jsonSerialization['tables']),
    );
  }

  DatabaseDefinition copyWith({
    String? name,
    List<_i2.TableDefinition>? tables,
  });

  /// The name of the database.
  /// Null if the name is not available.
  String? get name;

  /// The tables of the database.
  List<_i2.TableDefinition> get tables;
}

class _Undefined {}

/// Defines the structure of the database used by Serverpod.
class _DatabaseDefinition extends DatabaseDefinition {
  const _DatabaseDefinition({
    this.name,
    required this.tables,
  }) : super._();

  /// The name of the database.
  /// Null if the name is not available.
  @override
  final String? name;

  /// The tables of the database.
  @override
  final List<_i2.TableDefinition> tables;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tables': tables,
    };
  }

  @override
  bool operator ==(dynamic other) {
    return identical(
          this,
          other,
        ) ||
        (other is DatabaseDefinition &&
            (identical(
                  other.name,
                  name,
                ) ||
                other.name == name) &&
            const _i3.DeepCollectionEquality().equals(
              tables,
              other.tables,
            ));
  }

  @override
  int get hashCode => Object.hash(
        name,
        const _i3.DeepCollectionEquality().hash(tables),
      );

  @override
  DatabaseDefinition copyWith({
    Object? name = _Undefined,
    List<_i2.TableDefinition>? tables,
  }) {
    return DatabaseDefinition(
      name: name == _Undefined ? this.name : (name as String?),
      tables: tables ?? this.tables,
    );
  }
}
