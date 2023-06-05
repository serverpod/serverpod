/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

class _Undefined {}

/// Defines the structure of the database used by Serverpod.
class DatabaseDefinition extends _i1.SerializableEntity {
  DatabaseDefinition({
    this.name,
    required this.tables,
  });

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

  /// The name of the database.
  /// Null if the name is not available.
  final String? name;

  /// The tables of the database.
  final List<_i2.TableDefinition> tables;

  late Function({
    String? name,
    List<_i2.TableDefinition>? tables,
  }) copyWith = _copyWith;

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

  DatabaseDefinition _copyWith({
    Object? name = _Undefined,
    List<_i2.TableDefinition>? tables,
  }) {
    return DatabaseDefinition(
      name: name == _Undefined ? this.name : (name as String?),
      tables: tables ?? this.tables,
    );
  }
}
