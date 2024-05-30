/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'cache_info.dart' as _i3;
import 'caches_info.dart' as _i4;
import 'cloud_storage.dart' as _i5;
import 'cloud_storage_direct_upload.dart' as _i6;
import 'cluster_info.dart' as _i7;
import 'cluster_server_info.dart' as _i8;
import 'database/bulk_data.dart' as _i9;
import 'database/bulk_data_exception.dart' as _i10;
import 'database/bulk_query_column_description.dart' as _i11;
import 'database/bulk_query_result.dart' as _i12;
import 'database/column_definition.dart' as _i13;
import 'database/column_migration.dart' as _i14;
import 'database/column_type.dart' as _i15;
import 'database/database_definition.dart' as _i16;
import 'database/database_definitions.dart' as _i17;
import 'database/database_migration.dart' as _i18;
import 'database/database_migration_action.dart' as _i19;
import 'database/database_migration_action_type.dart' as _i20;
import 'database/database_migration_version.dart' as _i21;
import 'database/database_migration_warning.dart' as _i22;
import 'database/database_migration_warning_type.dart' as _i23;
import 'database/enum_serialization.dart' as _i24;
import 'database/filter/filter.dart' as _i25;
import 'database/filter/filter_constraint.dart' as _i26;
import 'database/filter/filter_constraint_type.dart' as _i27;
import 'database/foreign_key_action.dart' as _i28;
import 'database/foreign_key_definition.dart' as _i29;
import 'database/foreign_key_match_type.dart' as _i30;
import 'database/index_definition.dart' as _i31;
import 'database/index_element_definition.dart' as _i32;
import 'database/index_element_definition_type.dart' as _i33;
import 'database/table_definition.dart' as _i34;
import 'database/table_migration.dart' as _i35;
import 'distributed_cache_entry.dart' as _i36;
import 'exceptions/access_denied.dart' as _i37;
import 'exceptions/file_not_found.dart' as _i38;
import 'future_call_entry.dart' as _i39;
import 'log_entry.dart' as _i40;
import 'log_level.dart' as _i41;
import 'log_result.dart' as _i42;
import 'log_settings.dart' as _i43;
import 'log_settings_override.dart' as _i44;
import 'message_log_entry.dart' as _i45;
import 'method_info.dart' as _i46;
import 'query_log_entry.dart' as _i47;
import 'readwrite_test.dart' as _i48;
import 'runtime_settings.dart' as _i49;
import 'server_health_connection_info.dart' as _i50;
import 'server_health_metric.dart' as _i51;
import 'server_health_result.dart' as _i52;
import 'serverpod_sql_exception.dart' as _i53;
import 'session_log_entry.dart' as _i54;
import 'session_log_filter.dart' as _i55;
import 'session_log_info.dart' as _i56;
import 'session_log_result.dart' as _i57;
import 'protocol.dart' as _i58;
import 'package:serverpod/src/generated/database/table_definition.dart' as _i59;
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
export 'database/bulk_data.dart';
export 'database/bulk_data_exception.dart';
export 'database/bulk_query_column_description.dart';
export 'database/bulk_query_result.dart';
export 'database/column_definition.dart';
export 'database/column_migration.dart';
export 'database/column_type.dart';
export 'database/database_definition.dart';
export 'database/database_definitions.dart';
export 'database/database_migration.dart';
export 'database/database_migration_action.dart';
export 'database/database_migration_action_type.dart';
export 'database/database_migration_version.dart';
export 'database/database_migration_warning.dart';
export 'database/database_migration_warning_type.dart';
export 'database/enum_serialization.dart';
export 'database/filter/filter.dart';
export 'database/filter/filter_constraint.dart';
export 'database/filter/filter_constraint_type.dart';
export 'database/foreign_key_action.dart';
export 'database/foreign_key_definition.dart';
export 'database/foreign_key_match_type.dart';
export 'database/index_definition.dart';
export 'database/index_element_definition.dart';
export 'database/index_element_definition_type.dart';
export 'database/table_definition.dart';
export 'database/table_migration.dart';
export 'distributed_cache_entry.dart';
export 'exceptions/access_denied.dart';
export 'exceptions/file_not_found.dart';
export 'future_call_entry.dart';
export 'log_entry.dart';
export 'log_level.dart';
export 'log_result.dart';
export 'log_settings.dart';
export 'log_settings_override.dart';
export 'message_log_entry.dart';
export 'method_info.dart';
export 'query_log_entry.dart';
export 'readwrite_test.dart';
export 'runtime_settings.dart';
export 'server_health_connection_info.dart';
export 'server_health_metric.dart';
export 'server_health_result.dart';
export 'serverpod_sql_exception.dart';
export 'session_log_entry.dart';
export 'session_log_filter.dart';
export 'session_log_info.dart';
export 'session_log_result.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_cloud_storage',
      dartName: 'CloudStorageEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_cloud_storage_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'storageId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'path',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'addedTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'expiration',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'byteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'verified',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_cloud_storage_pkey',
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
          indexName: 'serverpod_cloud_storage_path_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'storageId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'path',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_cloud_storage_expiration',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'expiration',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_cloud_storage_direct_upload',
      dartName: 'CloudStorageDirectUploadEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_cloud_storage_direct_upload_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'storageId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'path',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'expiration',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'authKey',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_cloud_storage_direct_upload_pkey',
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
          indexName: 'serverpod_cloud_storage_direct_upload_storage_path',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'storageId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'path',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_future_call',
      dartName: 'FutureCallEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_future_call_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'time',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'serializedObject',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'identifier',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_future_call_pkey',
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
          indexName: 'serverpod_future_call_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'time',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_future_call_serverId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'serverId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_future_call_identifier_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'identifier',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_health_connection_info',
      dartName: 'ServerHealthConnectionInfo',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_health_connection_info_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'active',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'closing',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'idle',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'granularity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_health_connection_info_pkey',
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
          indexName: 'serverpod_health_connection_info_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'serverId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'granularity',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_health_metric',
      dartName: 'ServerHealthMetric',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_health_metric_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'isHealthy',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'value',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'granularity',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_health_metric_pkey',
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
          indexName: 'serverpod_health_metric_timestamp_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'timestamp',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'serverId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'name',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'granularity',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_log',
      dartName: 'LogEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'sessionLogId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'messageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'reference',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'time',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'logLevel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:LogLevel',
        ),
        _i2.ColumnDefinition(
          name: 'message',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'error',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stackTrace',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'order',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_log_fk_0',
          columns: ['sessionLogId'],
          referenceTable: 'serverpod_session_log',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_log_pkey',
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
          indexName: 'serverpod_log_sessionLogId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionLogId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_message_log',
      dartName: 'MessageLogEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_message_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'sessionLogId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'messageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'endpoint',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'messageName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'error',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stackTrace',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'slow',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'order',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_message_log_fk_0',
          columns: ['sessionLogId'],
          referenceTable: 'serverpod_session_log',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_message_log_pkey',
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
      name: 'serverpod_method',
      dartName: 'MethodInfo',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_method_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'endpoint',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_method_pkey',
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
          indexName: 'serverpod_method_endpoint_method_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'endpoint',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'method',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_migrations',
      dartName: 'DatabaseMigrationVersion',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_migrations_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'module',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'version',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'timestamp',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_migrations_pkey',
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
          indexName: 'serverpod_migrations_ids',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'module',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_query_log',
      dartName: 'QueryLogEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_query_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'sessionLogId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'messageId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'query',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'numRows',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'error',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stackTrace',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'slow',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'order',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_query_log_fk_0',
          columns: ['sessionLogId'],
          referenceTable: 'serverpod_session_log',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_query_log_pkey',
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
          indexName: 'serverpod_query_log_sessionLogId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionLogId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_readwrite_test',
      dartName: 'ReadWriteTestEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_readwrite_test_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_readwrite_test_pkey',
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
      name: 'serverpod_runtime_settings',
      dartName: 'RuntimeSettings',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_runtime_settings_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'logSettings',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:LogSettings',
        ),
        _i2.ColumnDefinition(
          name: 'logSettingsOverrides',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:LogSettingsOverride>',
        ),
        _i2.ColumnDefinition(
          name: 'logServiceCalls',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'logMalformedCalls',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_runtime_settings_pkey',
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
      name: 'serverpod_session_log',
      dartName: 'SessionLogEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'serverpod_session_log_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'serverId',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'time',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'module',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'endpoint',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'method',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'numQueries',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'slow',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'error',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'stackTrace',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'authenticatedUserId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'isOpen',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'touched',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_session_log_pkey',
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
          indexName: 'serverpod_session_log_serverid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'serverId',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_session_log_touched_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'touched',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_session_log_isopen_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'isOpen',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i3.CacheInfo) {
      return _i3.CacheInfo.fromJson(data) as T;
    }
    if (t == _i4.CachesInfo) {
      return _i4.CachesInfo.fromJson(data) as T;
    }
    if (t == _i5.CloudStorageEntry) {
      return _i5.CloudStorageEntry.fromJson(data) as T;
    }
    if (t == _i6.CloudStorageDirectUploadEntry) {
      return _i6.CloudStorageDirectUploadEntry.fromJson(data) as T;
    }
    if (t == _i7.ClusterInfo) {
      return _i7.ClusterInfo.fromJson(data) as T;
    }
    if (t == _i8.ClusterServerInfo) {
      return _i8.ClusterServerInfo.fromJson(data) as T;
    }
    if (t == _i9.BulkData) {
      return _i9.BulkData.fromJson(data) as T;
    }
    if (t == _i10.BulkDataException) {
      return _i10.BulkDataException.fromJson(data) as T;
    }
    if (t == _i11.BulkQueryColumnDescription) {
      return _i11.BulkQueryColumnDescription.fromJson(data) as T;
    }
    if (t == _i12.BulkQueryResult) {
      return _i12.BulkQueryResult.fromJson(data) as T;
    }
    if (t == _i13.ColumnDefinition) {
      return _i13.ColumnDefinition.fromJson(data) as T;
    }
    if (t == _i14.ColumnMigration) {
      return _i14.ColumnMigration.fromJson(data) as T;
    }
    if (t == _i15.ColumnType) {
      return _i15.ColumnType.fromJson(data) as T;
    }
    if (t == _i16.DatabaseDefinition) {
      return _i16.DatabaseDefinition.fromJson(data) as T;
    }
    if (t == _i17.DatabaseDefinitions) {
      return _i17.DatabaseDefinitions.fromJson(data) as T;
    }
    if (t == _i18.DatabaseMigration) {
      return _i18.DatabaseMigration.fromJson(data) as T;
    }
    if (t == _i19.DatabaseMigrationAction) {
      return _i19.DatabaseMigrationAction.fromJson(data) as T;
    }
    if (t == _i20.DatabaseMigrationActionType) {
      return _i20.DatabaseMigrationActionType.fromJson(data) as T;
    }
    if (t == _i21.DatabaseMigrationVersion) {
      return _i21.DatabaseMigrationVersion.fromJson(data) as T;
    }
    if (t == _i22.DatabaseMigrationWarning) {
      return _i22.DatabaseMigrationWarning.fromJson(data) as T;
    }
    if (t == _i23.DatabaseMigrationWarningType) {
      return _i23.DatabaseMigrationWarningType.fromJson(data) as T;
    }
    if (t == _i24.EnumSerialization) {
      return _i24.EnumSerialization.fromJson(data) as T;
    }
    if (t == _i25.Filter) {
      return _i25.Filter.fromJson(data) as T;
    }
    if (t == _i26.FilterConstraint) {
      return _i26.FilterConstraint.fromJson(data) as T;
    }
    if (t == _i27.FilterConstraintType) {
      return _i27.FilterConstraintType.fromJson(data) as T;
    }
    if (t == _i28.ForeignKeyAction) {
      return _i28.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _i29.ForeignKeyDefinition) {
      return _i29.ForeignKeyDefinition.fromJson(data) as T;
    }
    if (t == _i30.ForeignKeyMatchType) {
      return _i30.ForeignKeyMatchType.fromJson(data) as T;
    }
    if (t == _i31.IndexDefinition) {
      return _i31.IndexDefinition.fromJson(data) as T;
    }
    if (t == _i32.IndexElementDefinition) {
      return _i32.IndexElementDefinition.fromJson(data) as T;
    }
    if (t == _i33.IndexElementDefinitionType) {
      return _i33.IndexElementDefinitionType.fromJson(data) as T;
    }
    if (t == _i34.TableDefinition) {
      return _i34.TableDefinition.fromJson(data) as T;
    }
    if (t == _i35.TableMigration) {
      return _i35.TableMigration.fromJson(data) as T;
    }
    if (t == _i36.DistributedCacheEntry) {
      return _i36.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _i37.AccessDeniedException) {
      return _i37.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i38.FileNotFoundException) {
      return _i38.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _i39.FutureCallEntry) {
      return _i39.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _i40.LogEntry) {
      return _i40.LogEntry.fromJson(data) as T;
    }
    if (t == _i41.LogLevel) {
      return _i41.LogLevel.fromJson(data) as T;
    }
    if (t == _i42.LogResult) {
      return _i42.LogResult.fromJson(data) as T;
    }
    if (t == _i43.LogSettings) {
      return _i43.LogSettings.fromJson(data) as T;
    }
    if (t == _i44.LogSettingsOverride) {
      return _i44.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _i45.MessageLogEntry) {
      return _i45.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _i46.MethodInfo) {
      return _i46.MethodInfo.fromJson(data) as T;
    }
    if (t == _i47.QueryLogEntry) {
      return _i47.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i48.ReadWriteTestEntry) {
      return _i48.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _i49.RuntimeSettings) {
      return _i49.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _i50.ServerHealthConnectionInfo) {
      return _i50.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i51.ServerHealthMetric) {
      return _i51.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _i52.ServerHealthResult) {
      return _i52.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i53.ServerpodSqlException) {
      return _i53.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i54.SessionLogEntry) {
      return _i54.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i55.SessionLogFilter) {
      return _i55.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i56.SessionLogInfo) {
      return _i56.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _i57.SessionLogResult) {
      return _i57.SessionLogResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.CacheInfo?>()) {
      return (data != null ? _i3.CacheInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.CachesInfo?>()) {
      return (data != null ? _i4.CachesInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.CloudStorageEntry?>()) {
      return (data != null ? _i5.CloudStorageEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CloudStorageDirectUploadEntry?>()) {
      return (data != null
          ? _i6.CloudStorageDirectUploadEntry.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.ClusterInfo?>()) {
      return (data != null ? _i7.ClusterInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ClusterServerInfo?>()) {
      return (data != null ? _i8.ClusterServerInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.BulkData?>()) {
      return (data != null ? _i9.BulkData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BulkDataException?>()) {
      return (data != null ? _i10.BulkDataException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.BulkQueryColumnDescription?>()) {
      return (data != null
          ? _i11.BulkQueryColumnDescription.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.BulkQueryResult?>()) {
      return (data != null ? _i12.BulkQueryResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.ColumnDefinition?>()) {
      return (data != null ? _i13.ColumnDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.ColumnMigration?>()) {
      return (data != null ? _i14.ColumnMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.ColumnType?>()) {
      return (data != null ? _i15.ColumnType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.DatabaseDefinition?>()) {
      return (data != null ? _i16.DatabaseDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.DatabaseDefinitions?>()) {
      return (data != null ? _i17.DatabaseDefinitions.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.DatabaseMigration?>()) {
      return (data != null ? _i18.DatabaseMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.DatabaseMigrationAction?>()) {
      return (data != null ? _i19.DatabaseMigrationAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.DatabaseMigrationActionType?>()) {
      return (data != null
          ? _i20.DatabaseMigrationActionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i21.DatabaseMigrationVersion?>()) {
      return (data != null
          ? _i21.DatabaseMigrationVersion.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i22.DatabaseMigrationWarning?>()) {
      return (data != null
          ? _i22.DatabaseMigrationWarning.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i23.DatabaseMigrationWarningType?>()) {
      return (data != null
          ? _i23.DatabaseMigrationWarningType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i24.EnumSerialization?>()) {
      return (data != null ? _i24.EnumSerialization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.Filter?>()) {
      return (data != null ? _i25.Filter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.FilterConstraint?>()) {
      return (data != null ? _i26.FilterConstraint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.FilterConstraintType?>()) {
      return (data != null ? _i27.FilterConstraintType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.ForeignKeyAction?>()) {
      return (data != null ? _i28.ForeignKeyAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ForeignKeyDefinition?>()) {
      return (data != null ? _i29.ForeignKeyDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.ForeignKeyMatchType?>()) {
      return (data != null ? _i30.ForeignKeyMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.IndexDefinition?>()) {
      return (data != null ? _i31.IndexDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.IndexElementDefinition?>()) {
      return (data != null ? _i32.IndexElementDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.IndexElementDefinitionType?>()) {
      return (data != null
          ? _i33.IndexElementDefinitionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i34.TableDefinition?>()) {
      return (data != null ? _i34.TableDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.TableMigration?>()) {
      return (data != null ? _i35.TableMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.DistributedCacheEntry?>()) {
      return (data != null ? _i36.DistributedCacheEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.AccessDeniedException?>()) {
      return (data != null ? _i37.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.FileNotFoundException?>()) {
      return (data != null ? _i38.FileNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.FutureCallEntry?>()) {
      return (data != null ? _i39.FutureCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.LogEntry?>()) {
      return (data != null ? _i40.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.LogLevel?>()) {
      return (data != null ? _i41.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.LogResult?>()) {
      return (data != null ? _i42.LogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.LogSettings?>()) {
      return (data != null ? _i43.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.LogSettingsOverride?>()) {
      return (data != null ? _i44.LogSettingsOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.MessageLogEntry?>()) {
      return (data != null ? _i45.MessageLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.MethodInfo?>()) {
      return (data != null ? _i46.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.QueryLogEntry?>()) {
      return (data != null ? _i47.QueryLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ReadWriteTestEntry?>()) {
      return (data != null ? _i48.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.RuntimeSettings?>()) {
      return (data != null ? _i49.RuntimeSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i50.ServerHealthConnectionInfo.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i51.ServerHealthMetric?>()) {
      return (data != null ? _i51.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.ServerHealthResult?>()) {
      return (data != null ? _i52.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.ServerpodSqlException?>()) {
      return (data != null ? _i53.ServerpodSqlException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.SessionLogEntry?>()) {
      return (data != null ? _i54.SessionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.SessionLogFilter?>()) {
      return (data != null ? _i55.SessionLogFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.SessionLogInfo?>()) {
      return (data != null ? _i56.SessionLogInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.SessionLogResult?>()) {
      return (data != null ? _i57.SessionLogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i58.ClusterServerInfo>) {
      return (data as List)
          .map((e) => deserialize<_i58.ClusterServerInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.BulkQueryColumnDescription>) {
      return (data as List)
          .map((e) => deserialize<_i58.BulkQueryColumnDescription>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i58.TableDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.DatabaseMigrationVersion>) {
      return (data as List)
          .map((e) => deserialize<_i58.DatabaseMigrationVersion>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.DatabaseMigrationAction>) {
      return (data as List)
          .map((e) => deserialize<_i58.DatabaseMigrationAction>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.DatabaseMigrationWarning>) {
      return (data as List)
          .map((e) => deserialize<_i58.DatabaseMigrationWarning>(e))
          .toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i58.FilterConstraint>) {
      return (data as List)
          .map((e) => deserialize<_i58.FilterConstraint>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.IndexElementDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i58.IndexElementDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.ColumnDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i58.ColumnDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.ForeignKeyDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i58.ForeignKeyDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.IndexDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i58.IndexDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.ColumnMigration>) {
      return (data as List)
          .map((e) => deserialize<_i58.ColumnMigration>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.LogEntry>) {
      return (data as List).map((e) => deserialize<_i58.LogEntry>(e)).toList()
          as dynamic;
    }
    if (t == List<_i58.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserialize<_i58.LogSettingsOverride>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserialize<_i58.ServerHealthMetric>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserialize<_i58.ServerHealthConnectionInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i58.QueryLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i58.MessageLogEntry>(e))
          .toList() as dynamic;
    }
    if (t == List<_i58.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserialize<_i58.SessionLogInfo>(e))
          .toList() as dynamic;
    }
    if (t == List<_i59.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i59.TableDefinition>(e))
          .toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    if (data is _i3.CacheInfo) {
      return 'CacheInfo';
    }
    if (data is _i4.CachesInfo) {
      return 'CachesInfo';
    }
    if (data is _i5.CloudStorageEntry) {
      return 'CloudStorageEntry';
    }
    if (data is _i6.CloudStorageDirectUploadEntry) {
      return 'CloudStorageDirectUploadEntry';
    }
    if (data is _i7.ClusterInfo) {
      return 'ClusterInfo';
    }
    if (data is _i8.ClusterServerInfo) {
      return 'ClusterServerInfo';
    }
    if (data is _i9.BulkData) {
      return 'BulkData';
    }
    if (data is _i10.BulkDataException) {
      return 'BulkDataException';
    }
    if (data is _i11.BulkQueryColumnDescription) {
      return 'BulkQueryColumnDescription';
    }
    if (data is _i12.BulkQueryResult) {
      return 'BulkQueryResult';
    }
    if (data is _i13.ColumnDefinition) {
      return 'ColumnDefinition';
    }
    if (data is _i14.ColumnMigration) {
      return 'ColumnMigration';
    }
    if (data is _i15.ColumnType) {
      return 'ColumnType';
    }
    if (data is _i16.DatabaseDefinition) {
      return 'DatabaseDefinition';
    }
    if (data is _i17.DatabaseDefinitions) {
      return 'DatabaseDefinitions';
    }
    if (data is _i18.DatabaseMigration) {
      return 'DatabaseMigration';
    }
    if (data is _i19.DatabaseMigrationAction) {
      return 'DatabaseMigrationAction';
    }
    if (data is _i20.DatabaseMigrationActionType) {
      return 'DatabaseMigrationActionType';
    }
    if (data is _i21.DatabaseMigrationVersion) {
      return 'DatabaseMigrationVersion';
    }
    if (data is _i22.DatabaseMigrationWarning) {
      return 'DatabaseMigrationWarning';
    }
    if (data is _i23.DatabaseMigrationWarningType) {
      return 'DatabaseMigrationWarningType';
    }
    if (data is _i24.EnumSerialization) {
      return 'EnumSerialization';
    }
    if (data is _i25.Filter) {
      return 'Filter';
    }
    if (data is _i26.FilterConstraint) {
      return 'FilterConstraint';
    }
    if (data is _i27.FilterConstraintType) {
      return 'FilterConstraintType';
    }
    if (data is _i28.ForeignKeyAction) {
      return 'ForeignKeyAction';
    }
    if (data is _i29.ForeignKeyDefinition) {
      return 'ForeignKeyDefinition';
    }
    if (data is _i30.ForeignKeyMatchType) {
      return 'ForeignKeyMatchType';
    }
    if (data is _i31.IndexDefinition) {
      return 'IndexDefinition';
    }
    if (data is _i32.IndexElementDefinition) {
      return 'IndexElementDefinition';
    }
    if (data is _i33.IndexElementDefinitionType) {
      return 'IndexElementDefinitionType';
    }
    if (data is _i34.TableDefinition) {
      return 'TableDefinition';
    }
    if (data is _i35.TableMigration) {
      return 'TableMigration';
    }
    if (data is _i36.DistributedCacheEntry) {
      return 'DistributedCacheEntry';
    }
    if (data is _i37.AccessDeniedException) {
      return 'AccessDeniedException';
    }
    if (data is _i38.FileNotFoundException) {
      return 'FileNotFoundException';
    }
    if (data is _i39.FutureCallEntry) {
      return 'FutureCallEntry';
    }
    if (data is _i40.LogEntry) {
      return 'LogEntry';
    }
    if (data is _i41.LogLevel) {
      return 'LogLevel';
    }
    if (data is _i42.LogResult) {
      return 'LogResult';
    }
    if (data is _i43.LogSettings) {
      return 'LogSettings';
    }
    if (data is _i44.LogSettingsOverride) {
      return 'LogSettingsOverride';
    }
    if (data is _i45.MessageLogEntry) {
      return 'MessageLogEntry';
    }
    if (data is _i46.MethodInfo) {
      return 'MethodInfo';
    }
    if (data is _i47.QueryLogEntry) {
      return 'QueryLogEntry';
    }
    if (data is _i48.ReadWriteTestEntry) {
      return 'ReadWriteTestEntry';
    }
    if (data is _i49.RuntimeSettings) {
      return 'RuntimeSettings';
    }
    if (data is _i50.ServerHealthConnectionInfo) {
      return 'ServerHealthConnectionInfo';
    }
    if (data is _i51.ServerHealthMetric) {
      return 'ServerHealthMetric';
    }
    if (data is _i52.ServerHealthResult) {
      return 'ServerHealthResult';
    }
    if (data is _i53.ServerpodSqlException) {
      return 'ServerpodSqlException';
    }
    if (data is _i54.SessionLogEntry) {
      return 'SessionLogEntry';
    }
    if (data is _i55.SessionLogFilter) {
      return 'SessionLogFilter';
    }
    if (data is _i56.SessionLogInfo) {
      return 'SessionLogInfo';
    }
    if (data is _i57.SessionLogResult) {
      return 'SessionLogResult';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'CacheInfo') {
      return deserialize<_i3.CacheInfo>(data['data']);
    }
    if (data['className'] == 'CachesInfo') {
      return deserialize<_i4.CachesInfo>(data['data']);
    }
    if (data['className'] == 'CloudStorageEntry') {
      return deserialize<_i5.CloudStorageEntry>(data['data']);
    }
    if (data['className'] == 'CloudStorageDirectUploadEntry') {
      return deserialize<_i6.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (data['className'] == 'ClusterInfo') {
      return deserialize<_i7.ClusterInfo>(data['data']);
    }
    if (data['className'] == 'ClusterServerInfo') {
      return deserialize<_i8.ClusterServerInfo>(data['data']);
    }
    if (data['className'] == 'BulkData') {
      return deserialize<_i9.BulkData>(data['data']);
    }
    if (data['className'] == 'BulkDataException') {
      return deserialize<_i10.BulkDataException>(data['data']);
    }
    if (data['className'] == 'BulkQueryColumnDescription') {
      return deserialize<_i11.BulkQueryColumnDescription>(data['data']);
    }
    if (data['className'] == 'BulkQueryResult') {
      return deserialize<_i12.BulkQueryResult>(data['data']);
    }
    if (data['className'] == 'ColumnDefinition') {
      return deserialize<_i13.ColumnDefinition>(data['data']);
    }
    if (data['className'] == 'ColumnMigration') {
      return deserialize<_i14.ColumnMigration>(data['data']);
    }
    if (data['className'] == 'ColumnType') {
      return deserialize<_i15.ColumnType>(data['data']);
    }
    if (data['className'] == 'DatabaseDefinition') {
      return deserialize<_i16.DatabaseDefinition>(data['data']);
    }
    if (data['className'] == 'DatabaseDefinitions') {
      return deserialize<_i17.DatabaseDefinitions>(data['data']);
    }
    if (data['className'] == 'DatabaseMigration') {
      return deserialize<_i18.DatabaseMigration>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationAction') {
      return deserialize<_i19.DatabaseMigrationAction>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationActionType') {
      return deserialize<_i20.DatabaseMigrationActionType>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationVersion') {
      return deserialize<_i21.DatabaseMigrationVersion>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationWarning') {
      return deserialize<_i22.DatabaseMigrationWarning>(data['data']);
    }
    if (data['className'] == 'DatabaseMigrationWarningType') {
      return deserialize<_i23.DatabaseMigrationWarningType>(data['data']);
    }
    if (data['className'] == 'EnumSerialization') {
      return deserialize<_i24.EnumSerialization>(data['data']);
    }
    if (data['className'] == 'Filter') {
      return deserialize<_i25.Filter>(data['data']);
    }
    if (data['className'] == 'FilterConstraint') {
      return deserialize<_i26.FilterConstraint>(data['data']);
    }
    if (data['className'] == 'FilterConstraintType') {
      return deserialize<_i27.FilterConstraintType>(data['data']);
    }
    if (data['className'] == 'ForeignKeyAction') {
      return deserialize<_i28.ForeignKeyAction>(data['data']);
    }
    if (data['className'] == 'ForeignKeyDefinition') {
      return deserialize<_i29.ForeignKeyDefinition>(data['data']);
    }
    if (data['className'] == 'ForeignKeyMatchType') {
      return deserialize<_i30.ForeignKeyMatchType>(data['data']);
    }
    if (data['className'] == 'IndexDefinition') {
      return deserialize<_i31.IndexDefinition>(data['data']);
    }
    if (data['className'] == 'IndexElementDefinition') {
      return deserialize<_i32.IndexElementDefinition>(data['data']);
    }
    if (data['className'] == 'IndexElementDefinitionType') {
      return deserialize<_i33.IndexElementDefinitionType>(data['data']);
    }
    if (data['className'] == 'TableDefinition') {
      return deserialize<_i34.TableDefinition>(data['data']);
    }
    if (data['className'] == 'TableMigration') {
      return deserialize<_i35.TableMigration>(data['data']);
    }
    if (data['className'] == 'DistributedCacheEntry') {
      return deserialize<_i36.DistributedCacheEntry>(data['data']);
    }
    if (data['className'] == 'AccessDeniedException') {
      return deserialize<_i37.AccessDeniedException>(data['data']);
    }
    if (data['className'] == 'FileNotFoundException') {
      return deserialize<_i38.FileNotFoundException>(data['data']);
    }
    if (data['className'] == 'FutureCallEntry') {
      return deserialize<_i39.FutureCallEntry>(data['data']);
    }
    if (data['className'] == 'LogEntry') {
      return deserialize<_i40.LogEntry>(data['data']);
    }
    if (data['className'] == 'LogLevel') {
      return deserialize<_i41.LogLevel>(data['data']);
    }
    if (data['className'] == 'LogResult') {
      return deserialize<_i42.LogResult>(data['data']);
    }
    if (data['className'] == 'LogSettings') {
      return deserialize<_i43.LogSettings>(data['data']);
    }
    if (data['className'] == 'LogSettingsOverride') {
      return deserialize<_i44.LogSettingsOverride>(data['data']);
    }
    if (data['className'] == 'MessageLogEntry') {
      return deserialize<_i45.MessageLogEntry>(data['data']);
    }
    if (data['className'] == 'MethodInfo') {
      return deserialize<_i46.MethodInfo>(data['data']);
    }
    if (data['className'] == 'QueryLogEntry') {
      return deserialize<_i47.QueryLogEntry>(data['data']);
    }
    if (data['className'] == 'ReadWriteTestEntry') {
      return deserialize<_i48.ReadWriteTestEntry>(data['data']);
    }
    if (data['className'] == 'RuntimeSettings') {
      return deserialize<_i49.RuntimeSettings>(data['data']);
    }
    if (data['className'] == 'ServerHealthConnectionInfo') {
      return deserialize<_i50.ServerHealthConnectionInfo>(data['data']);
    }
    if (data['className'] == 'ServerHealthMetric') {
      return deserialize<_i51.ServerHealthMetric>(data['data']);
    }
    if (data['className'] == 'ServerHealthResult') {
      return deserialize<_i52.ServerHealthResult>(data['data']);
    }
    if (data['className'] == 'ServerpodSqlException') {
      return deserialize<_i53.ServerpodSqlException>(data['data']);
    }
    if (data['className'] == 'SessionLogEntry') {
      return deserialize<_i54.SessionLogEntry>(data['data']);
    }
    if (data['className'] == 'SessionLogFilter') {
      return deserialize<_i55.SessionLogFilter>(data['data']);
    }
    if (data['className'] == 'SessionLogInfo') {
      return deserialize<_i56.SessionLogInfo>(data['data']);
    }
    if (data['className'] == 'SessionLogResult') {
      return deserialize<_i57.SessionLogResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    switch (t) {
      case _i5.CloudStorageEntry:
        return _i5.CloudStorageEntry.t;
      case _i6.CloudStorageDirectUploadEntry:
        return _i6.CloudStorageDirectUploadEntry.t;
      case _i21.DatabaseMigrationVersion:
        return _i21.DatabaseMigrationVersion.t;
      case _i39.FutureCallEntry:
        return _i39.FutureCallEntry.t;
      case _i40.LogEntry:
        return _i40.LogEntry.t;
      case _i45.MessageLogEntry:
        return _i45.MessageLogEntry.t;
      case _i46.MethodInfo:
        return _i46.MethodInfo.t;
      case _i47.QueryLogEntry:
        return _i47.QueryLogEntry.t;
      case _i48.ReadWriteTestEntry:
        return _i48.ReadWriteTestEntry.t;
      case _i49.RuntimeSettings:
        return _i49.RuntimeSettings.t;
      case _i50.ServerHealthConnectionInfo:
        return _i50.ServerHealthConnectionInfo.t;
      case _i51.ServerHealthMetric:
        return _i51.ServerHealthMetric.t;
      case _i54.SessionLogEntry:
        return _i54.SessionLogEntry.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod';
}
