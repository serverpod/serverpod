/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import '../protocol.dart' as _i2;
import 'package:collection/collection.dart' as _i3;

/// Defines the structure of the database used by Serverpod.
abstract class DatabaseDefinition extends _i1.SerializableEntity {
  const DatabaseDefinition._();

  const factory DatabaseDefinition({
    String? name,
    required List<_i2.TableDefinition> tables,
    int? priority,
    Map<String, String>? installedModules,
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
      priority:
          serializationManager.deserialize<int?>(jsonSerialization['priority']),
      installedModules: serializationManager.deserialize<Map<String, String>?>(
          jsonSerialization['installedModules']),
    );
  }

  DatabaseDefinition copyWith({
    String? name,
    List<_i2.TableDefinition>? tables,
    int? priority,
    Map<String, String>? installedModules,
  });

  /// The name of the database.
  /// Null if the name is not available.
  String? get name;

  /// The tables of the database.
  List<_i2.TableDefinition> get tables;

  /// The priority of this database definition. Determines the order in which
  /// the database definitions are applied. Only valid if the definition
  /// defines a single module.
  int? get priority;

  /// Modules installed in the database, together with their version. Only
  /// set if known.
  Map<String, String>? get installedModules;
}

class _Undefined {}

/// Defines the structure of the database used by Serverpod.
class _DatabaseDefinition extends DatabaseDefinition {
  const _DatabaseDefinition({
    this.name,
    required this.tables,
    this.priority,
    this.installedModules,
  }) : super._();

  /// The name of the database.
  /// Null if the name is not available.
  @override
  final String? name;

  /// The tables of the database.
  @override
  final List<_i2.TableDefinition> tables;

  /// The priority of this database definition. Determines the order in which
  /// the database definitions are applied. Only valid if the definition
  /// defines a single module.
  @override
  final int? priority;

  /// Modules installed in the database, together with their version. Only
  /// set if known.
  @override
  final Map<String, String>? installedModules;

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'tables': tables,
      'priority': priority,
      'installedModules': installedModules,
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
            (identical(
                  other.priority,
                  priority,
                ) ||
                other.priority == priority) &&
            const _i3.DeepCollectionEquality().equals(
              tables,
              other.tables,
            ) &&
            const _i3.DeepCollectionEquality().equals(
              installedModules,
              other.installedModules,
            ));
  }

  @override
  int get hashCode => Object.hash(
        name,
        priority,
        const _i3.DeepCollectionEquality().hash(tables),
        const _i3.DeepCollectionEquality().hash(installedModules),
      );

  @override
  DatabaseDefinition copyWith({
    Object? name = _Undefined,
    List<_i2.TableDefinition>? tables,
    Object? priority = _Undefined,
    Object? installedModules = _Undefined,
  }) {
    return DatabaseDefinition(
      name: name == _Undefined ? this.name : (name as String?),
      tables: tables ?? this.tables,
      priority: priority == _Undefined ? this.priority : (priority as int?),
      installedModules: installedModules == _Undefined
          ? this.installedModules
          : (installedModules as Map<String, String>?),
    );
  }
}
