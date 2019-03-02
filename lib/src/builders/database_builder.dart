import 'package:build/build.dart';
import 'package:yaml/yaml.dart';

Builder databaseBuilder(_) => DatabaseBuilder();

class DatabaseBuilder implements Builder {
  const DatabaseBuilder();

  @override
  final buildExtensions = const {
    '.yaml': ['.dart']
  };

  @override
  Future build(BuildStep buildStep) async {
    String yamlStr = await buildStep.readAsString(buildStep.inputId);
    var doc = loadYaml(yamlStr);

    String output = '';

    try {
      String name = _expectString(doc, 'tableName');
      String cls = _expectString(doc, 'class');
      Map docFields = _expectMap(doc, 'fields');
      var fields = <_FieldDefinition>[];

      for (var docFieldName in docFields.keys) {
        fields.add(_FieldDefinition(docFieldName, docFields[docFieldName]));
      }

      // Header
      output += '/*** AUTOMATICALLY GENERATED CODE DO NOT MODIFY ***/\n';
      output += '/* To generate run: "pub run build_runner build"  */\n';
      output += '\n';

      output += 'import \'package:serverpod/database.dart\';\n';
      output += '\n';

      // Row class definition
      output += 'class $cls extends TableRow {\n';
      output += '  static const String tableName = \'$name\';\n';
      output += '\n';

      // Fields
      for (var field in fields) {
        output += '  ${field.type} ${field.name};\n';
      }

      // End class
      output += '}\n';
      output += '\n';

      // Table class definition
      output += 'class ${cls}Table extends Table {\n';
      output += '\n';

      output += '  static const String tableName = \'$name\';\n';

      // Column descriptions
      for (var column in fields) {
        output += '  static const ${column.name} = Column(\'${column.name}\', ${column.type});\n';
      }


      // End class
      output += '}\n';
    }
    catch (_) {
      return;
    }
    
    buildStep.writeAsString(buildStep.inputId.changeExtension('.dart'), output);

  }

  String _expectString(dynamic doc, String field) {
    String value = doc[field];
    if (value != null) {
      return value;
    }
    else {
      print('Missing field (String) "$field"');
      throw FormatException();
    }
  }

  Map _expectMap(dynamic doc, String field) {
    Map map = doc[field];
    if (map != null) {
      return map;
    }
    else {
      print('Missing field (Map) "$field"');
      throw FormatException();
    }
  }
}

class _FieldDefinition {
  String name;
  String type;

  _FieldDefinition(String name, String description) {
    this.name = name;
    type = description;
  }
}