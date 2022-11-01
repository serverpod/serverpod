import 'dart:io';

import 'class_generator_dart.dart';
import 'protocol_definition.dart';

class PgsqlGenerator {
  final List<ProtocolFileDefinition> classInfos;
  final String outPath;

  PgsqlGenerator({
    required this.classInfos,
    required this.outPath,
  });

  void generate() {
    var out = '';

    var tableInfoList = classInfos.toList();
    tableInfoList.removeWhere(
      (element) => (element is! ClassDefinition) || element.tableName == null,
    );
    _sortClassInfos(tableInfoList.cast());

    for (var tableInfo in tableInfoList) {
      if (tableInfo is ClassDefinition && tableInfo.tableName != null) {
        out += _generatePgsql(tableInfo);
      }
    }

    var outFile = File(outPath);
    outFile.writeAsStringSync(out);
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
          // Check if a parent is not above the current table
          if (field.parentTable != null &&
              !visitedTableNames.contains(field.parentTable!)) {
            var tableToMove = tableInfo;
            for (int j = i; j < tableInfos.length; j++) {
              if (tableInfos[j].tableName! == field.parentTable!) {
                // Move a table down the list, below its dependency
                tableInfos.removeAt(i);
                tableInfos.insert(j, tableToMove);
                movedEntry = true;
                break;
              }
            }

            if (!movedEntry) {
              // We failed to move a table because the dependency is missing
              throw FormatException(
                  'The table "${tableInfo.tableName}" (class "${tableInfo.className}" is referencing a table that doesn\'t exist (${field.parentTable}).)');
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
    out += 'CREATE TABLE ${classInfo.tableName} (\n';
    // Id is a special case that is nullable in code but not in the database
    out += '  "id" serial';
    for (var field in classInfo.fields) {
      // Skip id field as it is already added
      if (field.name == 'id') continue;

      // Skip fields that are API only
      if (field.scope == FieldScope.api) continue;

      var nullable = field.type.nullable ? '' : ' NOT NULL';
      out += ',\n  "${field.name}" ${field.type.databaseType}$nullable';
    }
    out += '\n);\n';
    out += '\n';

    // Main index
    out += 'ALTER TABLE ONLY ${classInfo.tableName}\n';
    out += '  ADD CONSTRAINT ${classInfo.tableName}_pkey PRIMARY KEY (id);\n';
    out += '\n';

    // Additional indexes
    if (classInfo.indexes != null) {
      for (var index in classInfo.indexes!) {
        var uniqueStr = index.unique ? ' UNIQUE' : '';
        out +=
            'CREATE$uniqueStr INDEX ${index.name} ON ${classInfo.tableName} USING ${index.type} (';
        out += index.fields.map((String str) => '"$str"').join(', ');
        out += ');\n';
      }
      out += '\n';
    }

    // Foreign keys
    var fkIdx = 0;
    for (var field in classInfo.fields) {
      if (field.parentTable != null) {
        fkIdx++;
        out += 'ALTER TABLE ONLY ${classInfo.tableName}\n';
        out += '  ADD CONSTRAINT ${classInfo.tableName}_fk$fkIdx\n';
        out += '    FOREIGN KEY("${field.name}")\n';
        out += '      REFERENCES ${field.parentTable}(id)\n';
        out += '        ON DELETE CASCADE;\n';
      }
    }

    out += '\n';
    return out;
  }
}
