import 'dart:io';

import 'package:recase/recase.dart';
import 'package:serverpod/serverpod.dart';

Future<Null> performBuildSchema(bool verbose) async {
  var builder = BuildSchema();
  await builder.setup();
  await builder.build();
  await builder.finish();

  print('done.');
}

class BuildSchema {
  ServerConfig config;
  Database database;

  Future<Null> setup() async {
    config = ServerConfig('config/development.yaml', 0);
    print(config);

    // Setup database
    if (config.dbConfigured) {
      database = await Database(null, config.dbHost, config.dbPort, config.dbName, config.dbUser, config.dbPass);
      if (!await database.connect())
        print('Failed to connect to database');
    }
  }

  Future<Null> build() async {
    var names = await database.getTableNames();
    print('database names: $names');

    for (var name in names) {
      var descr = await database.getTableDescription(name);

      if (descr == null) {
        print('WARNING: Skipping table $name');
        continue;
      }

      await generateYaml('bin/protocol/$name.yaml', descr);
    }
  }

  Future<Null> generateYaml(String file, Table descr) async {
    var className = ReCase(descr.tableName).pascalCase;

    String yaml = 'class: $className\n';
    yaml += 'tableName: ${descr.tableName}\n';
    yaml += 'fields:\n';

    for (Column col in descr.columns) {
      if (col.columnName == 'id')
        continue;
      yaml += '  ${col.columnName}: ${col.type}\n';
    }

    await File(file).writeAsString(yaml);
  }

  Future<Null> finish() async {
    await database.disconnect();
  }
}