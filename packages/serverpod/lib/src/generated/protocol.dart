/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'authentication/revoked_authentication_auth_id.dart' as _i3;
import 'authentication/revoked_authentication_scope.dart' as _i4;
import 'authentication/revoked_authentication_user.dart' as _i5;
import 'cache_info.dart' as _i6;
import 'caches_info.dart' as _i7;
import 'cloud_storage.dart' as _i8;
import 'cloud_storage_direct_upload.dart' as _i9;
import 'cluster_info.dart' as _i10;
import 'cluster_server_info.dart' as _i11;
import 'database/bulk_data.dart' as _i12;
import 'database/bulk_data_exception.dart' as _i13;
import 'database/bulk_query_column_description.dart' as _i14;
import 'database/bulk_query_result.dart' as _i15;
import 'database/column_definition.dart' as _i16;
import 'database/column_migration.dart' as _i17;
import 'database/column_type.dart' as _i18;
import 'database/database_definition.dart' as _i19;
import 'database/database_definitions.dart' as _i20;
import 'database/database_migration.dart' as _i21;
import 'database/database_migration_action.dart' as _i22;
import 'database/database_migration_action_type.dart' as _i23;
import 'database/database_migration_version.dart' as _i24;
import 'database/database_migration_warning.dart' as _i25;
import 'database/database_migration_warning_type.dart' as _i26;
import 'database/enum_serialization.dart' as _i27;
import 'database/filter/filter.dart' as _i28;
import 'database/filter/filter_constraint.dart' as _i29;
import 'database/filter/filter_constraint_type.dart' as _i30;
import 'database/foreign_key_action.dart' as _i31;
import 'database/foreign_key_definition.dart' as _i32;
import 'database/foreign_key_match_type.dart' as _i33;
import 'database/index_definition.dart' as _i34;
import 'database/index_element_definition.dart' as _i35;
import 'database/index_element_definition_type.dart' as _i36;
import 'database/table_definition.dart' as _i37;
import 'database/table_migration.dart' as _i38;
import 'distributed_cache_entry.dart' as _i39;
import 'exceptions/access_denied.dart' as _i40;
import 'exceptions/file_not_found.dart' as _i41;
import 'future_call_entry.dart' as _i42;
import 'log_entry.dart' as _i43;
import 'log_level.dart' as _i44;
import 'log_result.dart' as _i45;
import 'log_settings.dart' as _i46;
import 'log_settings_override.dart' as _i47;
import 'message_log_entry.dart' as _i48;
import 'method_info.dart' as _i49;
import 'query_log_entry.dart' as _i50;
import 'readwrite_test.dart' as _i51;
import 'runtime_settings.dart' as _i52;
import 'server_health_connection_info.dart' as _i53;
import 'server_health_metric.dart' as _i54;
import 'server_health_result.dart' as _i55;
import 'serverpod_sql_exception.dart' as _i56;
import 'session_log_entry.dart' as _i57;
import 'session_log_filter.dart' as _i58;
import 'session_log_info.dart' as _i59;
import 'session_log_result.dart' as _i60;
import 'package:serverpod/src/generated/database/table_definition.dart' as _i61;
export 'authentication/revoked_authentication_auth_id.dart';
export 'authentication/revoked_authentication_scope.dart';
export 'authentication/revoked_authentication_user.dart';
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
    if (t == _i3.RevokedAuthenticationAuthId) {
      return _i3.RevokedAuthenticationAuthId.fromJson(data) as T;
    }
    if (t == _i4.RevokedAuthenticationScope) {
      return _i4.RevokedAuthenticationScope.fromJson(data) as T;
    }
    if (t == _i5.RevokedAuthenticationUser) {
      return _i5.RevokedAuthenticationUser.fromJson(data) as T;
    }
    if (t == _i6.CacheInfo) {
      return _i6.CacheInfo.fromJson(data) as T;
    }
    if (t == _i7.CachesInfo) {
      return _i7.CachesInfo.fromJson(data) as T;
    }
    if (t == _i8.CloudStorageEntry) {
      return _i8.CloudStorageEntry.fromJson(data) as T;
    }
    if (t == _i9.CloudStorageDirectUploadEntry) {
      return _i9.CloudStorageDirectUploadEntry.fromJson(data) as T;
    }
    if (t == _i10.ClusterInfo) {
      return _i10.ClusterInfo.fromJson(data) as T;
    }
    if (t == _i11.ClusterServerInfo) {
      return _i11.ClusterServerInfo.fromJson(data) as T;
    }
    if (t == _i12.BulkData) {
      return _i12.BulkData.fromJson(data) as T;
    }
    if (t == _i13.BulkDataException) {
      return _i13.BulkDataException.fromJson(data) as T;
    }
    if (t == _i14.BulkQueryColumnDescription) {
      return _i14.BulkQueryColumnDescription.fromJson(data) as T;
    }
    if (t == _i15.BulkQueryResult) {
      return _i15.BulkQueryResult.fromJson(data) as T;
    }
    if (t == _i16.ColumnDefinition) {
      return _i16.ColumnDefinition.fromJson(data) as T;
    }
    if (t == _i17.ColumnMigration) {
      return _i17.ColumnMigration.fromJson(data) as T;
    }
    if (t == _i18.ColumnType) {
      return _i18.ColumnType.fromJson(data) as T;
    }
    if (t == _i19.DatabaseDefinition) {
      return _i19.DatabaseDefinition.fromJson(data) as T;
    }
    if (t == _i20.DatabaseDefinitions) {
      return _i20.DatabaseDefinitions.fromJson(data) as T;
    }
    if (t == _i21.DatabaseMigration) {
      return _i21.DatabaseMigration.fromJson(data) as T;
    }
    if (t == _i22.DatabaseMigrationAction) {
      return _i22.DatabaseMigrationAction.fromJson(data) as T;
    }
    if (t == _i23.DatabaseMigrationActionType) {
      return _i23.DatabaseMigrationActionType.fromJson(data) as T;
    }
    if (t == _i24.DatabaseMigrationVersion) {
      return _i24.DatabaseMigrationVersion.fromJson(data) as T;
    }
    if (t == _i25.DatabaseMigrationWarning) {
      return _i25.DatabaseMigrationWarning.fromJson(data) as T;
    }
    if (t == _i26.DatabaseMigrationWarningType) {
      return _i26.DatabaseMigrationWarningType.fromJson(data) as T;
    }
    if (t == _i27.EnumSerialization) {
      return _i27.EnumSerialization.fromJson(data) as T;
    }
    if (t == _i28.Filter) {
      return _i28.Filter.fromJson(data) as T;
    }
    if (t == _i29.FilterConstraint) {
      return _i29.FilterConstraint.fromJson(data) as T;
    }
    if (t == _i30.FilterConstraintType) {
      return _i30.FilterConstraintType.fromJson(data) as T;
    }
    if (t == _i31.ForeignKeyAction) {
      return _i31.ForeignKeyAction.fromJson(data) as T;
    }
    if (t == _i32.ForeignKeyDefinition) {
      return _i32.ForeignKeyDefinition.fromJson(data) as T;
    }
    if (t == _i33.ForeignKeyMatchType) {
      return _i33.ForeignKeyMatchType.fromJson(data) as T;
    }
    if (t == _i34.IndexDefinition) {
      return _i34.IndexDefinition.fromJson(data) as T;
    }
    if (t == _i35.IndexElementDefinition) {
      return _i35.IndexElementDefinition.fromJson(data) as T;
    }
    if (t == _i36.IndexElementDefinitionType) {
      return _i36.IndexElementDefinitionType.fromJson(data) as T;
    }
    if (t == _i37.TableDefinition) {
      return _i37.TableDefinition.fromJson(data) as T;
    }
    if (t == _i38.TableMigration) {
      return _i38.TableMigration.fromJson(data) as T;
    }
    if (t == _i39.DistributedCacheEntry) {
      return _i39.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _i40.AccessDeniedException) {
      return _i40.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i41.FileNotFoundException) {
      return _i41.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _i42.FutureCallEntry) {
      return _i42.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _i43.LogEntry) {
      return _i43.LogEntry.fromJson(data) as T;
    }
    if (t == _i44.LogLevel) {
      return _i44.LogLevel.fromJson(data) as T;
    }
    if (t == _i45.LogResult) {
      return _i45.LogResult.fromJson(data) as T;
    }
    if (t == _i46.LogSettings) {
      return _i46.LogSettings.fromJson(data) as T;
    }
    if (t == _i47.LogSettingsOverride) {
      return _i47.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _i48.MessageLogEntry) {
      return _i48.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _i49.MethodInfo) {
      return _i49.MethodInfo.fromJson(data) as T;
    }
    if (t == _i50.QueryLogEntry) {
      return _i50.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i51.ReadWriteTestEntry) {
      return _i51.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _i52.RuntimeSettings) {
      return _i52.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _i53.ServerHealthConnectionInfo) {
      return _i53.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i54.ServerHealthMetric) {
      return _i54.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _i55.ServerHealthResult) {
      return _i55.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i56.ServerpodSqlException) {
      return _i56.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i57.SessionLogEntry) {
      return _i57.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i58.SessionLogFilter) {
      return _i58.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i59.SessionLogInfo) {
      return _i59.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _i60.SessionLogResult) {
      return _i60.SessionLogResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.RevokedAuthenticationAuthId?>()) {
      return (data != null
          ? _i3.RevokedAuthenticationAuthId.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i4.RevokedAuthenticationScope?>()) {
      return (data != null
          ? _i4.RevokedAuthenticationScope.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i5.RevokedAuthenticationUser?>()) {
      return (data != null
          ? _i5.RevokedAuthenticationUser.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.CacheInfo?>()) {
      return (data != null ? _i6.CacheInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.CachesInfo?>()) {
      return (data != null ? _i7.CachesInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.CloudStorageEntry?>()) {
      return (data != null ? _i8.CloudStorageEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CloudStorageDirectUploadEntry?>()) {
      return (data != null
          ? _i9.CloudStorageDirectUploadEntry.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.ClusterInfo?>()) {
      return (data != null ? _i10.ClusterInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ClusterServerInfo?>()) {
      return (data != null ? _i11.ClusterServerInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BulkData?>()) {
      return (data != null ? _i12.BulkData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.BulkDataException?>()) {
      return (data != null ? _i13.BulkDataException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BulkQueryColumnDescription?>()) {
      return (data != null
          ? _i14.BulkQueryColumnDescription.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.BulkQueryResult?>()) {
      return (data != null ? _i15.BulkQueryResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ColumnDefinition?>()) {
      return (data != null ? _i16.ColumnDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ColumnMigration?>()) {
      return (data != null ? _i17.ColumnMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ColumnType?>()) {
      return (data != null ? _i18.ColumnType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.DatabaseDefinition?>()) {
      return (data != null ? _i19.DatabaseDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.DatabaseDefinitions?>()) {
      return (data != null ? _i20.DatabaseDefinitions.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.DatabaseMigration?>()) {
      return (data != null ? _i21.DatabaseMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.DatabaseMigrationAction?>()) {
      return (data != null ? _i22.DatabaseMigrationAction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.DatabaseMigrationActionType?>()) {
      return (data != null
          ? _i23.DatabaseMigrationActionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i24.DatabaseMigrationVersion?>()) {
      return (data != null
          ? _i24.DatabaseMigrationVersion.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i25.DatabaseMigrationWarning?>()) {
      return (data != null
          ? _i25.DatabaseMigrationWarning.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i26.DatabaseMigrationWarningType?>()) {
      return (data != null
          ? _i26.DatabaseMigrationWarningType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i27.EnumSerialization?>()) {
      return (data != null ? _i27.EnumSerialization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Filter?>()) {
      return (data != null ? _i28.Filter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.FilterConstraint?>()) {
      return (data != null ? _i29.FilterConstraint.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.FilterConstraintType?>()) {
      return (data != null ? _i30.FilterConstraintType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.ForeignKeyAction?>()) {
      return (data != null ? _i31.ForeignKeyAction.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.ForeignKeyDefinition?>()) {
      return (data != null ? _i32.ForeignKeyDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.ForeignKeyMatchType?>()) {
      return (data != null ? _i33.ForeignKeyMatchType.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.IndexDefinition?>()) {
      return (data != null ? _i34.IndexDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.IndexElementDefinition?>()) {
      return (data != null ? _i35.IndexElementDefinition.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.IndexElementDefinitionType?>()) {
      return (data != null
          ? _i36.IndexElementDefinitionType.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i37.TableDefinition?>()) {
      return (data != null ? _i37.TableDefinition.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.TableMigration?>()) {
      return (data != null ? _i38.TableMigration.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.DistributedCacheEntry?>()) {
      return (data != null ? _i39.DistributedCacheEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.AccessDeniedException?>()) {
      return (data != null ? _i40.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.FileNotFoundException?>()) {
      return (data != null ? _i41.FileNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.FutureCallEntry?>()) {
      return (data != null ? _i42.FutureCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.LogEntry?>()) {
      return (data != null ? _i43.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.LogLevel?>()) {
      return (data != null ? _i44.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.LogResult?>()) {
      return (data != null ? _i45.LogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.LogSettings?>()) {
      return (data != null ? _i46.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.LogSettingsOverride?>()) {
      return (data != null ? _i47.LogSettingsOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.MessageLogEntry?>()) {
      return (data != null ? _i48.MessageLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.MethodInfo?>()) {
      return (data != null ? _i49.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.QueryLogEntry?>()) {
      return (data != null ? _i50.QueryLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.ReadWriteTestEntry?>()) {
      return (data != null ? _i51.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.RuntimeSettings?>()) {
      return (data != null ? _i52.RuntimeSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i53.ServerHealthConnectionInfo.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i54.ServerHealthMetric?>()) {
      return (data != null ? _i54.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.ServerHealthResult?>()) {
      return (data != null ? _i55.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.ServerpodSqlException?>()) {
      return (data != null ? _i56.ServerpodSqlException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.SessionLogEntry?>()) {
      return (data != null ? _i57.SessionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.SessionLogFilter?>()) {
      return (data != null ? _i58.SessionLogFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.SessionLogInfo?>()) {
      return (data != null ? _i59.SessionLogInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.SessionLogResult?>()) {
      return (data != null ? _i60.SessionLogResult.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<_i11.ClusterServerInfo>) {
      return (data as List)
          .map((e) => deserialize<_i11.ClusterServerInfo>(e))
          .toList() as T;
    }
    if (t == List<_i14.BulkQueryColumnDescription>) {
      return (data as List)
          .map((e) => deserialize<_i14.BulkQueryColumnDescription>(e))
          .toList() as T;
    }
    if (t == List<_i37.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i37.TableDefinition>(e))
          .toList() as T;
    }
    if (t == List<_i24.DatabaseMigrationVersion>) {
      return (data as List)
          .map((e) => deserialize<_i24.DatabaseMigrationVersion>(e))
          .toList() as T;
    }
    if (t == List<_i22.DatabaseMigrationAction>) {
      return (data as List)
          .map((e) => deserialize<_i22.DatabaseMigrationAction>(e))
          .toList() as T;
    }
    if (t == List<_i25.DatabaseMigrationWarning>) {
      return (data as List)
          .map((e) => deserialize<_i25.DatabaseMigrationWarning>(e))
          .toList() as T;
    }
    if (t == List<_i29.FilterConstraint>) {
      return (data as List)
          .map((e) => deserialize<_i29.FilterConstraint>(e))
          .toList() as T;
    }
    if (t == List<_i35.IndexElementDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i35.IndexElementDefinition>(e))
          .toList() as T;
    }
    if (t == List<_i16.ColumnDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i16.ColumnDefinition>(e))
          .toList() as T;
    }
    if (t == List<_i32.ForeignKeyDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i32.ForeignKeyDefinition>(e))
          .toList() as T;
    }
    if (t == List<_i34.IndexDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i34.IndexDefinition>(e))
          .toList() as T;
    }
    if (t == List<_i17.ColumnMigration>) {
      return (data as List)
          .map((e) => deserialize<_i17.ColumnMigration>(e))
          .toList() as T;
    }
    if (t == List<_i43.LogEntry>) {
      return (data as List).map((e) => deserialize<_i43.LogEntry>(e)).toList()
          as T;
    }
    if (t == List<_i47.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserialize<_i47.LogSettingsOverride>(e))
          .toList() as T;
    }
    if (t == List<_i54.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserialize<_i54.ServerHealthMetric>(e))
          .toList() as T;
    }
    if (t == List<_i53.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserialize<_i53.ServerHealthConnectionInfo>(e))
          .toList() as T;
    }
    if (t == List<_i50.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i50.QueryLogEntry>(e))
          .toList() as T;
    }
    if (t == List<_i48.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i48.MessageLogEntry>(e))
          .toList() as T;
    }
    if (t == List<_i59.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserialize<_i59.SessionLogInfo>(e))
          .toList() as T;
    }
    if (t == List<_i61.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i61.TableDefinition>(e))
          .toList() as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i3.RevokedAuthenticationAuthId) {
      return 'RevokedAuthenticationAuthId';
    }
    if (data is _i4.RevokedAuthenticationScope) {
      return 'RevokedAuthenticationScope';
    }
    if (data is _i5.RevokedAuthenticationUser) {
      return 'RevokedAuthenticationUser';
    }
    if (data is _i6.CacheInfo) {
      return 'CacheInfo';
    }
    if (data is _i7.CachesInfo) {
      return 'CachesInfo';
    }
    if (data is _i8.CloudStorageEntry) {
      return 'CloudStorageEntry';
    }
    if (data is _i9.CloudStorageDirectUploadEntry) {
      return 'CloudStorageDirectUploadEntry';
    }
    if (data is _i10.ClusterInfo) {
      return 'ClusterInfo';
    }
    if (data is _i11.ClusterServerInfo) {
      return 'ClusterServerInfo';
    }
    if (data is _i12.BulkData) {
      return 'BulkData';
    }
    if (data is _i13.BulkDataException) {
      return 'BulkDataException';
    }
    if (data is _i14.BulkQueryColumnDescription) {
      return 'BulkQueryColumnDescription';
    }
    if (data is _i15.BulkQueryResult) {
      return 'BulkQueryResult';
    }
    if (data is _i16.ColumnDefinition) {
      return 'ColumnDefinition';
    }
    if (data is _i17.ColumnMigration) {
      return 'ColumnMigration';
    }
    if (data is _i18.ColumnType) {
      return 'ColumnType';
    }
    if (data is _i19.DatabaseDefinition) {
      return 'DatabaseDefinition';
    }
    if (data is _i20.DatabaseDefinitions) {
      return 'DatabaseDefinitions';
    }
    if (data is _i21.DatabaseMigration) {
      return 'DatabaseMigration';
    }
    if (data is _i22.DatabaseMigrationAction) {
      return 'DatabaseMigrationAction';
    }
    if (data is _i23.DatabaseMigrationActionType) {
      return 'DatabaseMigrationActionType';
    }
    if (data is _i24.DatabaseMigrationVersion) {
      return 'DatabaseMigrationVersion';
    }
    if (data is _i25.DatabaseMigrationWarning) {
      return 'DatabaseMigrationWarning';
    }
    if (data is _i26.DatabaseMigrationWarningType) {
      return 'DatabaseMigrationWarningType';
    }
    if (data is _i27.EnumSerialization) {
      return 'EnumSerialization';
    }
    if (data is _i28.Filter) {
      return 'Filter';
    }
    if (data is _i29.FilterConstraint) {
      return 'FilterConstraint';
    }
    if (data is _i30.FilterConstraintType) {
      return 'FilterConstraintType';
    }
    if (data is _i31.ForeignKeyAction) {
      return 'ForeignKeyAction';
    }
    if (data is _i32.ForeignKeyDefinition) {
      return 'ForeignKeyDefinition';
    }
    if (data is _i33.ForeignKeyMatchType) {
      return 'ForeignKeyMatchType';
    }
    if (data is _i34.IndexDefinition) {
      return 'IndexDefinition';
    }
    if (data is _i35.IndexElementDefinition) {
      return 'IndexElementDefinition';
    }
    if (data is _i36.IndexElementDefinitionType) {
      return 'IndexElementDefinitionType';
    }
    if (data is _i37.TableDefinition) {
      return 'TableDefinition';
    }
    if (data is _i38.TableMigration) {
      return 'TableMigration';
    }
    if (data is _i39.DistributedCacheEntry) {
      return 'DistributedCacheEntry';
    }
    if (data is _i40.AccessDeniedException) {
      return 'AccessDeniedException';
    }
    if (data is _i41.FileNotFoundException) {
      return 'FileNotFoundException';
    }
    if (data is _i42.FutureCallEntry) {
      return 'FutureCallEntry';
    }
    if (data is _i43.LogEntry) {
      return 'LogEntry';
    }
    if (data is _i44.LogLevel) {
      return 'LogLevel';
    }
    if (data is _i45.LogResult) {
      return 'LogResult';
    }
    if (data is _i46.LogSettings) {
      return 'LogSettings';
    }
    if (data is _i47.LogSettingsOverride) {
      return 'LogSettingsOverride';
    }
    if (data is _i48.MessageLogEntry) {
      return 'MessageLogEntry';
    }
    if (data is _i49.MethodInfo) {
      return 'MethodInfo';
    }
    if (data is _i50.QueryLogEntry) {
      return 'QueryLogEntry';
    }
    if (data is _i51.ReadWriteTestEntry) {
      return 'ReadWriteTestEntry';
    }
    if (data is _i52.RuntimeSettings) {
      return 'RuntimeSettings';
    }
    if (data is _i53.ServerHealthConnectionInfo) {
      return 'ServerHealthConnectionInfo';
    }
    if (data is _i54.ServerHealthMetric) {
      return 'ServerHealthMetric';
    }
    if (data is _i55.ServerHealthResult) {
      return 'ServerHealthResult';
    }
    if (data is _i56.ServerpodSqlException) {
      return 'ServerpodSqlException';
    }
    if (data is _i57.SessionLogEntry) {
      return 'SessionLogEntry';
    }
    if (data is _i58.SessionLogFilter) {
      return 'SessionLogFilter';
    }
    if (data is _i59.SessionLogInfo) {
      return 'SessionLogInfo';
    }
    if (data is _i60.SessionLogResult) {
      return 'SessionLogResult';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'RevokedAuthenticationAuthId') {
      return deserialize<_i3.RevokedAuthenticationAuthId>(data['data']);
    }
    if (dataClassName == 'RevokedAuthenticationScope') {
      return deserialize<_i4.RevokedAuthenticationScope>(data['data']);
    }
    if (dataClassName == 'RevokedAuthenticationUser') {
      return deserialize<_i5.RevokedAuthenticationUser>(data['data']);
    }
    if (dataClassName == 'CacheInfo') {
      return deserialize<_i6.CacheInfo>(data['data']);
    }
    if (dataClassName == 'CachesInfo') {
      return deserialize<_i7.CachesInfo>(data['data']);
    }
    if (dataClassName == 'CloudStorageEntry') {
      return deserialize<_i8.CloudStorageEntry>(data['data']);
    }
    if (dataClassName == 'CloudStorageDirectUploadEntry') {
      return deserialize<_i9.CloudStorageDirectUploadEntry>(data['data']);
    }
    if (dataClassName == 'ClusterInfo') {
      return deserialize<_i10.ClusterInfo>(data['data']);
    }
    if (dataClassName == 'ClusterServerInfo') {
      return deserialize<_i11.ClusterServerInfo>(data['data']);
    }
    if (dataClassName == 'BulkData') {
      return deserialize<_i12.BulkData>(data['data']);
    }
    if (dataClassName == 'BulkDataException') {
      return deserialize<_i13.BulkDataException>(data['data']);
    }
    if (dataClassName == 'BulkQueryColumnDescription') {
      return deserialize<_i14.BulkQueryColumnDescription>(data['data']);
    }
    if (dataClassName == 'BulkQueryResult') {
      return deserialize<_i15.BulkQueryResult>(data['data']);
    }
    if (dataClassName == 'ColumnDefinition') {
      return deserialize<_i16.ColumnDefinition>(data['data']);
    }
    if (dataClassName == 'ColumnMigration') {
      return deserialize<_i17.ColumnMigration>(data['data']);
    }
    if (dataClassName == 'ColumnType') {
      return deserialize<_i18.ColumnType>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinition') {
      return deserialize<_i19.DatabaseDefinition>(data['data']);
    }
    if (dataClassName == 'DatabaseDefinitions') {
      return deserialize<_i20.DatabaseDefinitions>(data['data']);
    }
    if (dataClassName == 'DatabaseMigration') {
      return deserialize<_i21.DatabaseMigration>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationAction') {
      return deserialize<_i22.DatabaseMigrationAction>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationActionType') {
      return deserialize<_i23.DatabaseMigrationActionType>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersion') {
      return deserialize<_i24.DatabaseMigrationVersion>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarning') {
      return deserialize<_i25.DatabaseMigrationWarning>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationWarningType') {
      return deserialize<_i26.DatabaseMigrationWarningType>(data['data']);
    }
    if (dataClassName == 'EnumSerialization') {
      return deserialize<_i27.EnumSerialization>(data['data']);
    }
    if (dataClassName == 'Filter') {
      return deserialize<_i28.Filter>(data['data']);
    }
    if (dataClassName == 'FilterConstraint') {
      return deserialize<_i29.FilterConstraint>(data['data']);
    }
    if (dataClassName == 'FilterConstraintType') {
      return deserialize<_i30.FilterConstraintType>(data['data']);
    }
    if (dataClassName == 'ForeignKeyAction') {
      return deserialize<_i31.ForeignKeyAction>(data['data']);
    }
    if (dataClassName == 'ForeignKeyDefinition') {
      return deserialize<_i32.ForeignKeyDefinition>(data['data']);
    }
    if (dataClassName == 'ForeignKeyMatchType') {
      return deserialize<_i33.ForeignKeyMatchType>(data['data']);
    }
    if (dataClassName == 'IndexDefinition') {
      return deserialize<_i34.IndexDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinition') {
      return deserialize<_i35.IndexElementDefinition>(data['data']);
    }
    if (dataClassName == 'IndexElementDefinitionType') {
      return deserialize<_i36.IndexElementDefinitionType>(data['data']);
    }
    if (dataClassName == 'TableDefinition') {
      return deserialize<_i37.TableDefinition>(data['data']);
    }
    if (dataClassName == 'TableMigration') {
      return deserialize<_i38.TableMigration>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_i39.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i40.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_i41.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_i42.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_i43.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_i44.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i45.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_i46.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i47.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_i48.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_i49.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_i50.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i51.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_i52.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_i53.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i54.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_i55.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i56.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i57.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i58.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i59.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_i60.SessionLogResult>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    switch (t) {
      case _i8.CloudStorageEntry:
        return _i8.CloudStorageEntry.t;
      case _i9.CloudStorageDirectUploadEntry:
        return _i9.CloudStorageDirectUploadEntry.t;
      case _i24.DatabaseMigrationVersion:
        return _i24.DatabaseMigrationVersion.t;
      case _i42.FutureCallEntry:
        return _i42.FutureCallEntry.t;
      case _i43.LogEntry:
        return _i43.LogEntry.t;
      case _i48.MessageLogEntry:
        return _i48.MessageLogEntry.t;
      case _i49.MethodInfo:
        return _i49.MethodInfo.t;
      case _i50.QueryLogEntry:
        return _i50.QueryLogEntry.t;
      case _i51.ReadWriteTestEntry:
        return _i51.ReadWriteTestEntry.t;
      case _i52.RuntimeSettings:
        return _i52.RuntimeSettings.t;
      case _i53.ServerHealthConnectionInfo:
        return _i53.ServerHealthConnectionInfo.t;
      case _i54.ServerHealthMetric:
        return _i54.ServerHealthMetric.t;
      case _i57.SessionLogEntry:
        return _i57.SessionLogEntry.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod';
}
