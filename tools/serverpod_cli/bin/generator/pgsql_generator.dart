import 'dart:io';

import 'class_generator.dart';
import 'class_generator_dart.dart';

class PgsqlGenerator {
  final Set<ClassInfo> classInfos;
  final String outPath;

  PgsqlGenerator({
    required this.classInfos,
    required this.outPath,
  });

  void generate() {
    var out = '';

    for (var classInfo in classInfos) {
      if (classInfo.tableName != null) {
        out += _generatePgsql(classInfo);
      }
    }

    var outFile = File(outPath);
    outFile.writeAsStringSync(out);
  }

  String _generatePgsql(ClassInfo classInfo) {
    var out = '';

    // Header
    out += '--\n';
    out += '-- Class ${classInfo.className} as table ${classInfo.tableName}\n';
    out += '--\n';
    out += '\n';

    // Drop Table If Already Exist
    // out += 'CREATE TABLE mycopy AS SELECT * ${classInfo.tableName}; (\n';
    // out += 'DROP TABLE IF EXISTS ${classInfo.tableName}; (\n';

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
      var defaultValue = field.defaultValue == null
          ? ''
          : (!['json', 'String'].contains(field.type.type)
              ? " DEFAULT '${field.defaultValue}'"
              : ' DEFAULT ${field.defaultValue}');
      out +=
          ',\n  "${field.name}" ${field.type.databaseType}$nullable$defaultValue';
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
    // Todo: Copy Data From Old Table and Paste to new table where match in column Name
    // out += 'DROP TABLE IF EXISTS mycopy; (\n';

    out += '\n';
    return out;
  }
}
