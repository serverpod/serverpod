import 'package:path/path.dart' as p;
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';

/// A [CodeGenerator], that generates pgsql code.
class LegacyPgsqlCodeGenerator extends CodeGenerator {
  /// Create a new [LegacyPgsqlCodeGenerator]
  const LegacyPgsqlCodeGenerator();

  @override
  Map<String, String> generateSerializableEntitiesCode(
      {required List<SerializableEntityDefinition> entities,
      required GeneratorConfig config}) {
    return {
      p.joinAll([
        ...config.serverPackageDirectoryPathParts,
        'generated',
        'tables.pgsql'
      ]): _generate(entities),
    };
  }

  String _generate(List<SerializableEntityDefinition> entities) {
    var tableInfoList = entities
        .whereType<ClassDefinition>()
        .where((element) => element.tableName != null)
        .toList();

    var viewInfoList = entities
        .whereType<ClassDefinition>()
        .where((element) => element.viewName != null)
        .toList();

    _sortClassInfos(tableInfoList.cast());

    var tableCreation = '';
    var foreignRelations = '';
    var viewCreation = '';
    for (var tableInfo in tableInfoList) {
      tableCreation += _generateTables(tableInfo);
      foreignRelations += _generateForeignKeys(tableInfo);
    }

    for (var viewInfo in viewInfoList) {
      viewCreation += _generateView(viewInfo);
    }

    return tableCreation + foreignRelations + viewCreation;
  }

  void _sortClassInfos(List<ClassDefinition> tableInfos) {
    // Sort by name to make sure that we get consistent output
    tableInfos.sort((a, b) => a.tableName!.compareTo(b.tableName!));
  }

  String _generateTables(ClassDefinition classInfo) {
    var out = '';

    // Header
    out += '--\n';
    out += '-- Class ${classInfo.className} as table ${classInfo.tableName}\n';
    out += '--\n';
    out += '\n';

    // Table definition
    out += 'CREATE TABLE "${classInfo.tableName}" (\n';
    // Id is a special case that is nullable in code but not in the database
    out += '  "id" serial';
    for (var field in classInfo.fields) {
      // Skip id field as it is already added
      if (field.name == 'id') continue;

      // Skip fields that should not be persisted
      if (!field.shouldPersist) continue;

      var nullable = field.type.nullable ? '' : ' NOT NULL';
      out += ',\n  "${field.name}" ${field.type.databaseType}$nullable';
    }
    out += '\n);\n';
    out += '\n';

    // Main index
    out += 'ALTER TABLE ONLY "${classInfo.tableName}"\n';
    out += '  ADD CONSTRAINT ${classInfo.tableName}_pkey PRIMARY KEY (id);\n';
    out += '\n';

    // Additional indexes
    if (classInfo.indexes != null) {
      for (var index in classInfo.indexes!) {
        var uniqueStr = index.unique ? ' UNIQUE' : '';
        out +=
            'CREATE$uniqueStr INDEX ${index.name} ON "${classInfo.tableName}" '
            'USING ${index.type} (';
        out += index.fields.map((String str) => '"$str"').join(', ');
        out += ');\n';
      }
      out += '\n';
    }

    return out;
  }

  String _generateForeignKeys(ClassDefinition classInfo) {
    var out = '';

    var relationFields = classInfo.fields.where((field) {
      return field.relation != null &&
          field.relation is ForeignRelationDefinition;
    });

    if (relationFields.isEmpty) return out;

    // Header
    out += '--\n';
    out += '-- Foreign relations for "${classInfo.tableName}" table\n';
    out += '--\n';
    out += '\n';

    // Foreign keys
    var fkIdx = 0;
    for (var field in relationFields) {
      var relation = field.relation as ForeignRelationDefinition;
      out += 'ALTER TABLE ONLY "${classInfo.tableName}"\n';
      out += '  ADD CONSTRAINT ${classInfo.tableName}_fk_$fkIdx\n';
      out += '    FOREIGN KEY("${field.name}")\n';
      out += '      REFERENCES ${relation.parentTable}(id)\n';
      out += '        ON DELETE CASCADE;\n';

      fkIdx += 1;
    }

    out += '\n';
    return out;
  }

  String _generateView(ClassDefinition classInfo) {
    var out = '';

    // Header
    out += '--\n';
    out += '-- Class ${classInfo.className} as table ${classInfo.viewName}\n';
    out += '--\n';
    out += '\n';

    // Create View Definition
    out += 'CREATE VIEW "${classInfo.viewName}" \n';
    out += ' AS ${classInfo.query} ';
    out += '\n';

    return out;
  }

  @override
  Map<String, String> generateProtocolCode(
      {required ProtocolDefinition protocolDefinition,
      required GeneratorConfig config}) {
    return {};
  }
}
