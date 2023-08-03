import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/analyzer/entities/definitions.dart';
import 'package:serverpod_cli/src/generator/code_generator.dart';
import 'package:serverpod_cli/src/config/config.dart';
import 'package:path/path.dart' as p;

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
    var out = '';

    var tableInfoList = entities.toList();
    tableInfoList.removeWhere(
      (element) => (element is! ClassDefinition) || element.tableName == null,
    );
    _sortClassInfos(tableInfoList.cast());

    for (var tableInfo in tableInfoList) {
      if (tableInfo is ClassDefinition && tableInfo.tableName != null) {
        out += _generatePgsql(tableInfo);
      }
    }

    return out;
  }

  void _sortClassInfos(List<ClassDefinition> tableInfos) {
    // First sort by name to make sure that we get consistant output
    tableInfos.sort((a, b) => a.tableName!.compareTo(b.tableName!));

    // Force to run at least one time
    var movedEntry = true;

    // Move tables with dependencies down the list until all dependencies are
    // resolved
    while (movedEntry) {
      movedEntry = false;
      var visitedTableNames = <String>{};

      // Iterate from the top of the list
      classInfoLoop:
      for (int i = 0; i < tableInfos.length; i++) {
        var tableInfo = tableInfos[i];

        for (var field in tableInfo.fields) {
          // Check if a parent is not above the current table and not self-referencing
          var relation = field.relation;
          if (relation is IdRelationDefinition &&
              relation.parentTable != tableInfo.tableName &&
              !visitedTableNames.contains(relation.parentTable)) {
            var tableToMove = tableInfo;
            for (int j = i; j < tableInfos.length; j++) {
              if (tableInfos[j].tableName! == relation.parentTable) {
                // Move a table down the list, below its dependency
                tableInfos.removeAt(i);
                tableInfos.insert(j, tableToMove);
                movedEntry = true;
                break;
              }
            }

            if (!movedEntry) {
              // We failed to move a table because the dependency is missing
              throw FormatException('The table "${tableInfo.tableName}" '
                  '(class "${tableInfo.className}" is referencing a table '
                  'that doesn\'t exist (${relation.parentTable}).)');
            }

            break classInfoLoop;
          }
        }
        visitedTableNames.add(tableInfo.tableName!);
      }
    }
  }

  String _generatePgsql(ClassDefinition classInfo) {
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

      // Skip fields that are API only
      if (field.scope == SerializableEntityFieldScope.api) continue;

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

    // Foreign keys
    var fkIdx = 0;
    for (var field in classInfo.fields) {
      var relation = field.relation;
      if (relation is IdRelationDefinition) {
        out += 'ALTER TABLE ONLY "${classInfo.tableName}"\n';
        out += '  ADD CONSTRAINT ${classInfo.tableName}_fk_$fkIdx\n';
        out += '    FOREIGN KEY("${field.name}")\n';
        out += '      REFERENCES ${relation.parentTable}(id)\n';
        out += '        ON DELETE CASCADE;\n';

        fkIdx += 1;
      }
    }

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
