/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_test_module_server/module.dart' as _i3;
import 'package:serverpod_auth_server/module.dart' as _i4;
import 'entities_with_relations/address.dart' as _i5;
import 'entities_with_relations/citizen.dart' as _i6;
import 'entities_with_relations/company.dart' as _i7;
import 'entities_with_relations/post.dart' as _i8;
import 'entities_with_relations/town.dart' as _i9;
import 'exception_with_data.dart' as _i10;
import 'module_datatype.dart' as _i11;
import 'nullability.dart' as _i12;
import 'object_field_scopes.dart' as _i13;
import 'object_with_bytedata.dart' as _i14;
import 'object_with_duration.dart' as _i15;
import 'object_with_enum.dart' as _i16;
import 'object_with_index.dart' as _i17;
import 'object_with_maps.dart' as _i18;
import 'object_with_object.dart' as _i19;
import 'object_with_parent.dart' as _i20;
import 'object_with_self_parent.dart' as _i21;
import 'object_with_uuid.dart' as _i22;
import 'serverOnly/default_server_only_class.dart' as _i23;
import 'serverOnly/default_server_only_enum.dart' as _i24;
import 'serverOnly/not_server_only_class.dart' as _i25;
import 'serverOnly/not_server_only_enum.dart' as _i26;
import 'serverOnly/server_only_class.dart' as _i27;
import 'serverOnly/server_only_enum.dart' as _i28;
import 'simple_data.dart' as _i29;
import 'simple_data_list.dart' as _i30;
import 'simple_data_map.dart' as _i31;
import 'simple_date_time.dart' as _i32;
import 'test_enum.dart' as _i33;
import 'types.dart' as _i34;
import 'protocol.dart' as _i35;
import 'dart:typed_data' as _i36;
import 'package:serverpod_test_server/src/generated/simple_date_time.dart'
    as _i37;
import 'package:serverpod_test_server/src/generated/entities_with_relations/citizen.dart'
    as _i38;
import 'package:serverpod_test_server/src/generated/entities_with_relations/address.dart'
    as _i39;
import 'package:serverpod_test_server/src/generated/entities_with_relations/post.dart'
    as _i40;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i41;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i42;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i43;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i44;
export 'entities_with_relations/address.dart';
export 'entities_with_relations/citizen.dart';
export 'entities_with_relations/company.dart';
export 'entities_with_relations/post.dart';
export 'entities_with_relations/town.dart';
export 'exception_with_data.dart';
export 'module_datatype.dart';
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_index.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_self_parent.dart';
export 'object_with_uuid.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'serverOnly/server_only_class.dart';
export 'serverOnly/server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'simple_data_map.dart';
export 'simple_date_time.dart';
export 'test_enum.dart';
export 'types.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  static final targetDatabaseDefinition = _i2.DatabaseDefinition(tables: [
    _i2.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'address_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'street',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'address_fk_0',
          columns: ['inhabitantId'],
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
          indexName: 'address_pkey',
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
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'citizen_id_seq\'::regclass)',
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
        _i2.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'int?',
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
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
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
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'company_id_seq\'::regclass)',
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
      name: 'object_field_scopes',
      dartName: 'ObjectFieldScopes',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_field_scopes_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'normal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'database',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_field_scopes_pkey',
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
      name: 'object_with_bytedata',
      dartName: 'ObjectWithByteData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_bytedata_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'byteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_bytedata_pkey',
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
      name: 'object_with_duration',
      dartName: 'ObjectWithDuration',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_duration_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_duration_pkey',
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
      name: 'object_with_enum',
      dartName: 'ObjectWithEnum',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_enum_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'testEnum',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'protocol:TestEnum',
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnum',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _i2.ColumnDefinition(
          name: 'enumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum?>',
        ),
        _i2.ColumnDefinition(
          name: 'enumListList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<List<protocol:TestEnum>>',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_enum_pkey',
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
      name: 'object_with_index',
      dartName: 'ObjectWithIndex',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_index_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'indexed',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'indexed2',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_index_pkey',
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
        ),
        _i2.IndexDefinition(
          indexName: 'object_with_index_test_index',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'indexed',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'indexed2',
            ),
          ],
          type: 'brin',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_object',
      dartName: 'ObjectWithObject',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_object_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'data',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:SimpleData',
        ),
        _i2.ColumnDefinition(
          name: 'nullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SimpleData?',
        ),
        _i2.ColumnDefinition(
          name: 'dataList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableDataList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData>?',
        ),
        _i2.ColumnDefinition(
          name: 'listWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData?>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableListWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData?>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_object_pkey',
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
      name: 'object_with_parent',
      dartName: 'ObjectWithParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_parent_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'object_with_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_field_scopes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_parent_pkey',
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
      name: 'object_with_self_parent',
      dartName: 'ObjectWithSelfParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'object_with_self_parent_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'object_with_self_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_with_self_parent',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_self_parent_pkey',
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
      name: 'object_with_uuid',
      dartName: 'ObjectWithUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_uuid_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'uuidNullable',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_uuid_pkey',
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
      name: 'post',
      dartName: 'Post',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'post_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nextId',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['nextId'],
          referenceTable: 'post',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'post_pkey',
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
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'simple_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'num',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'simple_data_pkey',
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
      name: 'simple_date_time',
      dartName: 'SimpleDateTime',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'simple_date_time_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'simple_date_time_pkey',
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
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'town_id_seq\'::regclass)',
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
          isNullable: true,
          dartType: 'int?',
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
    _i2.TableDefinition(
      name: 'types',
      dartName: 'Types',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'types_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'anInt',
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'aBool',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'aDouble',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'aDateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'aString',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'aByteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: true,
          dartType: 'dart:typed_data:ByteData?',
        ),
        _i2.ColumnDefinition(
          name: 'aDuration',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _i2.ColumnDefinition(
          name: 'aUuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'types_pkey',
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
    ..._i3.Protocol.targetDatabaseDefinition.tables,
    ..._i4.Protocol.targetDatabaseDefinition.tables,
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
    if (t == _i5.Address) {
      return _i5.Address.fromJson(data, this) as T;
    }
    if (t == _i6.Citizen) {
      return _i6.Citizen.fromJson(data, this) as T;
    }
    if (t == _i7.Company) {
      return _i7.Company.fromJson(data, this) as T;
    }
    if (t == _i8.Post) {
      return _i8.Post.fromJson(data, this) as T;
    }
    if (t == _i9.Town) {
      return _i9.Town.fromJson(data, this) as T;
    }
    if (t == _i10.ExceptionWithData) {
      return _i10.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i11.ModuleDatatype) {
      return _i11.ModuleDatatype.fromJson(data, this) as T;
    }
    if (t == _i12.Nullability) {
      return _i12.Nullability.fromJson(data, this) as T;
    }
    if (t == _i13.ObjectFieldScopes) {
      return _i13.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i14.ObjectWithByteData) {
      return _i14.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i15.ObjectWithDuration) {
      return _i15.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i16.ObjectWithEnum) {
      return _i16.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i17.ObjectWithIndex) {
      return _i17.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i18.ObjectWithMaps) {
      return _i18.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i19.ObjectWithObject) {
      return _i19.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i20.ObjectWithParent) {
      return _i20.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i21.ObjectWithSelfParent) {
      return _i21.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i22.ObjectWithUuid) {
      return _i22.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i23.DefaultServerOnlyClass) {
      return _i23.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i24.DefaultServerOnlyEnum) {
      return _i24.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i25.NotServerOnlyClass) {
      return _i25.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i26.NotServerOnlyEnum) {
      return _i26.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i27.ServerOnlyClass) {
      return _i27.ServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i28.ServerOnlyEnum) {
      return _i28.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i29.SimpleData) {
      return _i29.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i30.SimpleDataList) {
      return _i30.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i31.SimpleDataMap) {
      return _i31.SimpleDataMap.fromJson(data, this) as T;
    }
    if (t == _i32.SimpleDateTime) {
      return _i32.SimpleDateTime.fromJson(data, this) as T;
    }
    if (t == _i33.TestEnum) {
      return _i33.TestEnum.fromJson(data) as T;
    }
    if (t == _i34.Types) {
      return _i34.Types.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i5.Address?>()) {
      return (data != null ? _i5.Address.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.Citizen?>()) {
      return (data != null ? _i6.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.Company?>()) {
      return (data != null ? _i7.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.Post?>()) {
      return (data != null ? _i8.Post.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i9.Town?>()) {
      return (data != null ? _i9.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i10.ExceptionWithData?>()) {
      return (data != null ? _i10.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i11.ModuleDatatype?>()) {
      return (data != null ? _i11.ModuleDatatype.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Nullability?>()) {
      return (data != null ? _i12.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i13.ObjectFieldScopes?>()) {
      return (data != null ? _i13.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.ObjectWithByteData?>()) {
      return (data != null
          ? _i14.ObjectWithByteData.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i15.ObjectWithDuration?>()) {
      return (data != null
          ? _i15.ObjectWithDuration.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i16.ObjectWithEnum?>()) {
      return (data != null ? _i16.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i17.ObjectWithIndex?>()) {
      return (data != null ? _i17.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i18.ObjectWithMaps?>()) {
      return (data != null ? _i18.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i19.ObjectWithObject?>()) {
      return (data != null ? _i19.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i20.ObjectWithParent?>()) {
      return (data != null ? _i20.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i21.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i21.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i22.ObjectWithUuid?>()) {
      return (data != null ? _i22.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i23.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i23.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i24.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i24.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.NotServerOnlyClass?>()) {
      return (data != null
          ? _i25.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i26.NotServerOnlyEnum?>()) {
      return (data != null ? _i26.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ServerOnlyClass?>()) {
      return (data != null ? _i27.ServerOnlyClass.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i28.ServerOnlyEnum?>()) {
      return (data != null ? _i28.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.SimpleData?>()) {
      return (data != null ? _i29.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i30.SimpleDataList?>()) {
      return (data != null ? _i30.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i31.SimpleDataMap?>()) {
      return (data != null ? _i31.SimpleDataMap.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i32.SimpleDateTime?>()) {
      return (data != null ? _i32.SimpleDateTime.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i33.TestEnum?>()) {
      return (data != null ? _i33.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Types?>()) {
      return (data != null ? _i34.Types.fromJson(data, this) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i3.ModuleClass>) {
      return (data as List).map((e) => deserialize<_i3.ModuleClass>(e)).toList()
          as dynamic;
    }
    if (t == Map<String, _i3.ModuleClass>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i3.ModuleClass>(v)))
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i35.SimpleData>) {
      return (data as List).map((e) => deserialize<_i35.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i35.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i35.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i35.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i35.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i35.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i35.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i36.ByteData>) {
      return (data as List).map((e) => deserialize<_i36.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i36.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i36.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i36.ByteData?>) {
      return (data as List).map((e) => deserialize<_i36.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i36.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i36.ByteData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue?>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == List<_i35.TestEnum>) {
      return (data as List).map((e) => deserialize<_i35.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i35.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i35.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i35.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i35.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i35.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i35.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
    if (t == Map<String, _i36.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i36.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)))
          as dynamic;
    }
    if (t == Map<String, _i35.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i35.SimpleData?>(v))) as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i36.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i36.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue?>(v)))
          as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<List<_i35.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i35.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i35.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i35.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i37.SimpleDateTime>) {
      return (data as List)
          .map((e) => deserialize<_i37.SimpleDateTime>(e))
          .toList() as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<_i38.Citizen>) {
      return (data as List).map((e) => deserialize<_i38.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i39.Address>) {
      return (data as List).map((e) => deserialize<_i39.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i40.Post>) {
      return (data as List).map((e) => deserialize<_i40.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i36.ByteData>) {
      return (data as List).map((e) => deserialize<_i36.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i36.ByteData?>) {
      return (data as List).map((e) => deserialize<_i36.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i41.SimpleData>) {
      return (data as List).map((e) => deserialize<_i41.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i41.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i41.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i41.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i41.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i41.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i41.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i41.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i41.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i41.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i41.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<Map<String, int>>(v))) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<_i42.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i42.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i42.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i42.TestEnum>(v)))
          as dynamic;
    }
    if (t == Map<String, double>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double>(v))) as dynamic;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double?>(v))) as dynamic;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          as dynamic;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool?>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i36.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i36.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i36.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i36.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i41.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i41.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i41.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i41.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i41.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i41.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i41.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i41.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i41.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i41.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i41.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i41.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == _i43.CustomClass) {
      return _i43.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i44.ExternalCustomClass) {
      return _i44.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i44.FreezedCustomClass) {
      return _i44.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i43.CustomClass?>()) {
      return (data != null ? _i43.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i44.ExternalCustomClass?>()) {
      return (data != null
          ? _i44.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i44.FreezedCustomClass?>()) {
      return (data != null
          ? _i44.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i43.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i44.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i44.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i5.Address) {
      return 'Address';
    }
    if (data is _i6.Citizen) {
      return 'Citizen';
    }
    if (data is _i7.Company) {
      return 'Company';
    }
    if (data is _i8.Post) {
      return 'Post';
    }
    if (data is _i9.Town) {
      return 'Town';
    }
    if (data is _i10.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i11.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i12.Nullability) {
      return 'Nullability';
    }
    if (data is _i13.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i14.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i15.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i16.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i17.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i18.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i19.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i20.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i21.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i22.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i23.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i24.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i25.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i26.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i27.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i28.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i29.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i30.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i31.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i32.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i33.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i34.Types) {
      return 'Types';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i43.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i44.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i44.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i5.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i6.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i7.Company>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i8.Post>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i9.Town>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i10.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i11.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i12.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i13.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i14.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i15.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i16.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i17.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i18.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i19.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i20.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i21.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i22.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i23.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i24.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i25.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i26.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClass') {
      return deserialize<_i27.ServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'ServerOnlyEnum') {
      return deserialize<_i28.ServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i29.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i30.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i31.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i32.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i33.TestEnum>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i34.Types>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i5.Address:
        return _i5.Address.t;
      case _i6.Citizen:
        return _i6.Citizen.t;
      case _i7.Company:
        return _i7.Company.t;
      case _i8.Post:
        return _i8.Post.t;
      case _i9.Town:
        return _i9.Town.t;
      case _i13.ObjectFieldScopes:
        return _i13.ObjectFieldScopes.t;
      case _i14.ObjectWithByteData:
        return _i14.ObjectWithByteData.t;
      case _i15.ObjectWithDuration:
        return _i15.ObjectWithDuration.t;
      case _i16.ObjectWithEnum:
        return _i16.ObjectWithEnum.t;
      case _i17.ObjectWithIndex:
        return _i17.ObjectWithIndex.t;
      case _i19.ObjectWithObject:
        return _i19.ObjectWithObject.t;
      case _i20.ObjectWithParent:
        return _i20.ObjectWithParent.t;
      case _i21.ObjectWithSelfParent:
        return _i21.ObjectWithSelfParent.t;
      case _i22.ObjectWithUuid:
        return _i22.ObjectWithUuid.t;
      case _i29.SimpleData:
        return _i29.SimpleData.t;
      case _i32.SimpleDateTime:
        return _i32.SimpleDateTime.t;
      case _i34.Types:
        return _i34.Types.t;
    }
    return null;
  }

  @override
  _i2.DatabaseDefinition getTargetDatabaseDefinition() =>
      targetDatabaseDefinition;
}
