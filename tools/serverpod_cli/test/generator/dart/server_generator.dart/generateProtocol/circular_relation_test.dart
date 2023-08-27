import 'package:path/path.dart' as path;
import 'package:recase/recase.dart';
import 'package:serverpod_cli/src/analyzer/protocol_definition.dart';
import 'package:serverpod_cli/src/generator/dart/server_code_generator.dart';
import 'package:serverpod_cli/src/test_util/builders/class_definition_builder.dart';
import 'package:serverpod_cli/src/test_util/builders/generator_config_builder.dart';
import 'package:test/test.dart';

const projectName = 'example_project';
final config = GeneratorConfigBuilder().withName(projectName).build();
const generator = DartServerCodeGenerator();

void main() {
  var expectedFileName = path.join(
    'lib',
    'src',
    'generated',
    'protocol.dart',
  );
  group('Given classes with a circular relation when generating protocol files',
      () {
    /**
     * Citizen -> Company -> Town -> Citizen
     */
    var citizen = 'citizen';
    var company = 'company';
    var town = 'town';
    var entities = [
      ClassDefinitionBuilder()
          .withClassName(citizen.sentenceCase)
          .withFileName(citizen)
          .withTableName(citizen)
          .withSimpleField('name', 'String')
          .withObjectRelationField(company, company.sentenceCase, company)
          .build(),
      ClassDefinitionBuilder()
          .withClassName(company.sentenceCase)
          .withFileName(company)
          .withTableName(company)
          .withSimpleField('name', 'String')
          .withObjectRelationField(town, town.sentenceCase, town)
          .build(),
      ClassDefinitionBuilder()
          .withClassName(town.sentenceCase)
          .withFileName(town)
          .withTableName(town)
          .withSimpleField('name', 'String')
          .withObjectRelationField('mayor', citizen.sentenceCase, citizen)
          .build()
    ];

    var protocolDefinition =
        ProtocolDefinition(endpoints: [], entities: entities);

    var codeMap = generator.generateProtocolCode(
      protocolDefinition: protocolDefinition,
      config: config,
    );

    test(
      'then expected files is created.',
      () {
        expect(codeMap[expectedFileName], isNotNull);
      },
    );

    test('then file content matches regression data.', () {
      expect(codeMap[expectedFileName], equals(regressionData));
    });
  });
}

var regressionData = '''
/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'citizen.dart' as _i3;
import 'company.dart' as _i4;
import 'town.dart' as _i5;
export 'citizen.dart';
export 'company.dart';
export 'town.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final targetDatabaseDefinition = _i2.DatabaseDefinition(tables: [
    _i2.TableDefinition(
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'example_project',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\\'citizen_id_seq\\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'companyId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_fk_0',
          columns: ['companyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'citizen_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'company',
      dartName: 'Company',
      schema: 'public',
      module: 'example_project',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\\'company_id_seq\\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'townId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'company_fk_0',
          columns: ['townId'],
          referenceTable: 'town',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'company_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'town',
      dartName: 'Town',
      schema: 'public',
      module: 'example_project',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\\'town_id_seq\\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mayorId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'town_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'town_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i2.Protocol.targetDatabaseDefinition.tables,
  ]);

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i3.Citizen) {
      return _i3.Citizen.fromJson(data, this) as T;
    }
    if (t == _i4.Company) {
      return _i4.Company.fromJson(data, this) as T;
    }
    if (t == _i5.Town) {
      return _i5.Town.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i3.Citizen?>()) {
      return (data != null ? _i3.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.Company?>()) {
      return (data != null ? _i4.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.Town?>()) {
      return (data != null ? _i5.Town.fromJson(data, this) : null) as T;
    }
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i3.Citizen) {
      return 'Citizen';
    }
    if (data is _i4.Company) {
      return 'Company';
    }
    if (data is _i5.Town) {
      return 'Town';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'Citizen') {
      return deserialize<_i3.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i4.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i5.Town>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.Citizen:
        return _i3.Citizen.t;
      case _i4.Company:
        return _i4.Company.t;
      case _i5.Town:
        return _i5.Town.t;
    }
    return null;
  }

  @override
  _i2.DatabaseDefinition getTargetDatabaseDefinition() =>
      targetDatabaseDefinition;
}
''';
