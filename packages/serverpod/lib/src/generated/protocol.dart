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
import 'database/database_migration_action_type.dart' as _i3;
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
import 'authentication/revoked_authentication_auth_id.dart' as _i23;
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
import 'database/vector_distance_function.dart' as _i39;
import 'distributed_cache_entry.dart' as _i40;
import 'session_log_result.dart' as _i41;
import 'exceptions/file_not_found.dart' as _i42;
import 'future_call_entry.dart' as _i43;
import 'log_entry.dart' as _i44;
import 'log_level.dart' as _i45;
import 'log_result.dart' as _i46;
import 'log_settings.dart' as _i47;
import 'log_settings_override.dart' as _i48;
import 'message_log_entry.dart' as _i49;
import 'method_info.dart' as _i50;
import 'query_log_entry.dart' as _i51;
import 'readwrite_test.dart' as _i52;
import 'runtime_settings.dart' as _i53;
import 'server_health_connection_info.dart' as _i54;
import 'server_health_metric.dart' as _i55;
import 'server_health_result.dart' as _i56;
import 'serverpod_sql_exception.dart' as _i57;
import 'session_log_entry.dart' as _i58;
import 'session_log_filter.dart' as _i59;
import 'session_log_info.dart' as _i60;
import 'exceptions/access_denied.dart' as _i61;
import 'package:serverpod/src/generated/database/table_definition.dart' as _i62;
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
export 'database/vector_distance_function.dart';
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
    if (t == _i3.DatabaseMigrationActionType) {
      return _i3.DatabaseMigrationActionType.fromJson(data) as T;
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
    if (t == _i23.RevokedAuthenticationAuthId) {
      return _i23.RevokedAuthenticationAuthId.fromJson(data) as T;
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
    if (t == _i39.VectorDistanceFunction) {
      return _i39.VectorDistanceFunction.fromJson(data) as T;
    }
    if (t == _i40.DistributedCacheEntry) {
      return _i40.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _i41.SessionLogResult) {
      return _i41.SessionLogResult.fromJson(data) as T;
    }
    if (t == _i42.FileNotFoundException) {
      return _i42.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _i43.FutureCallEntry) {
      return _i43.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _i44.LogEntry) {
      return _i44.LogEntry.fromJson(data) as T;
    }
    if (t == _i45.LogLevel) {
      return _i45.LogLevel.fromJson(data) as T;
    }
    if (t == _i46.LogResult) {
      return _i46.LogResult.fromJson(data) as T;
    }
    if (t == _i47.LogSettings) {
      return _i47.LogSettings.fromJson(data) as T;
    }
    if (t == _i48.LogSettingsOverride) {
      return _i48.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _i49.MessageLogEntry) {
      return _i49.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _i50.MethodInfo) {
      return _i50.MethodInfo.fromJson(data) as T;
    }
    if (t == _i51.QueryLogEntry) {
      return _i51.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i52.ReadWriteTestEntry) {
      return _i52.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _i53.RuntimeSettings) {
      return _i53.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _i54.ServerHealthConnectionInfo) {
      return _i54.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i55.ServerHealthMetric) {
      return _i55.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _i56.ServerHealthResult) {
      return _i56.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i57.ServerpodSqlException) {
      return _i57.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i58.SessionLogEntry) {
      return _i58.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i59.SessionLogFilter) {
      return _i59.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i60.SessionLogInfo) {
      return _i60.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _i61.AccessDeniedException) {
      return _i61.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.DatabaseMigrationActionType?>()) {
      return (data != null
          ? _i3.DatabaseMigrationActionType.fromJson(data)
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
    if (t == _i1.getType<_i23.RevokedAuthenticationAuthId?>()) {
      return (data != null
          ? _i23.RevokedAuthenticationAuthId.fromJson(data)
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
    if (t == _i1.getType<_i39.VectorDistanceFunction?>()) {
      return (data != null ? _i39.VectorDistanceFunction.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.DistributedCacheEntry?>()) {
      return (data != null ? _i40.DistributedCacheEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.SessionLogResult?>()) {
      return (data != null ? _i41.SessionLogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.FileNotFoundException?>()) {
      return (data != null ? _i42.FileNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.FutureCallEntry?>()) {
      return (data != null ? _i43.FutureCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.LogEntry?>()) {
      return (data != null ? _i44.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.LogLevel?>()) {
      return (data != null ? _i45.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.LogResult?>()) {
      return (data != null ? _i46.LogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.LogSettings?>()) {
      return (data != null ? _i47.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.LogSettingsOverride?>()) {
      return (data != null ? _i48.LogSettingsOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.MessageLogEntry?>()) {
      return (data != null ? _i49.MessageLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.MethodInfo?>()) {
      return (data != null ? _i50.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.QueryLogEntry?>()) {
      return (data != null ? _i51.QueryLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ReadWriteTestEntry?>()) {
      return (data != null ? _i52.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.RuntimeSettings?>()) {
      return (data != null ? _i53.RuntimeSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.ServerHealthConnectionInfo?>()) {
      return (data != null
          ? _i54.ServerHealthConnectionInfo.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i55.ServerHealthMetric?>()) {
      return (data != null ? _i55.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.ServerHealthResult?>()) {
      return (data != null ? _i56.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.ServerpodSqlException?>()) {
      return (data != null ? _i57.ServerpodSqlException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.SessionLogEntry?>()) {
      return (data != null ? _i58.SessionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.SessionLogFilter?>()) {
      return (data != null ? _i59.SessionLogFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.SessionLogInfo?>()) {
      return (data != null ? _i60.SessionLogInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.AccessDeniedException?>()) {
      return (data != null ? _i61.AccessDeniedException.fromJson(data) : null)
          as T;
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
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
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
    if (t == List<_i60.SessionLogInfo>) {
      return (data as List)
          .map((e) => deserialize<_i60.SessionLogInfo>(e))
          .toList() as T;
    }
    if (t == List<_i44.LogEntry>) {
      return (data as List).map((e) => deserialize<_i44.LogEntry>(e)).toList()
          as T;
    }
    if (t == List<_i48.LogSettingsOverride>) {
      return (data as List)
          .map((e) => deserialize<_i48.LogSettingsOverride>(e))
          .toList() as T;
    }
    if (t == List<_i55.ServerHealthMetric>) {
      return (data as List)
          .map((e) => deserialize<_i55.ServerHealthMetric>(e))
          .toList() as T;
    }
    if (t == List<_i54.ServerHealthConnectionInfo>) {
      return (data as List)
          .map((e) => deserialize<_i54.ServerHealthConnectionInfo>(e))
          .toList() as T;
    }
    if (t == List<_i51.QueryLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i51.QueryLogEntry>(e))
          .toList() as T;
    }
    if (t == List<_i49.MessageLogEntry>) {
      return (data as List)
          .map((e) => deserialize<_i49.MessageLogEntry>(e))
          .toList() as T;
    }
    if (t == List<_i62.TableDefinition>) {
      return (data as List)
          .map((e) => deserialize<_i62.TableDefinition>(e))
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
    switch (data) {
      case _i3.DatabaseMigrationActionType():
        return 'DatabaseMigrationActionType';
      case _i4.RevokedAuthenticationScope():
        return 'RevokedAuthenticationScope';
      case _i5.RevokedAuthenticationUser():
        return 'RevokedAuthenticationUser';
      case _i6.CacheInfo():
        return 'CacheInfo';
      case _i7.CachesInfo():
        return 'CachesInfo';
      case _i8.CloudStorageEntry():
        return 'CloudStorageEntry';
      case _i9.CloudStorageDirectUploadEntry():
        return 'CloudStorageDirectUploadEntry';
      case _i10.ClusterInfo():
        return 'ClusterInfo';
      case _i11.ClusterServerInfo():
        return 'ClusterServerInfo';
      case _i12.BulkData():
        return 'BulkData';
      case _i13.BulkDataException():
        return 'BulkDataException';
      case _i14.BulkQueryColumnDescription():
        return 'BulkQueryColumnDescription';
      case _i15.BulkQueryResult():
        return 'BulkQueryResult';
      case _i16.ColumnDefinition():
        return 'ColumnDefinition';
      case _i17.ColumnMigration():
        return 'ColumnMigration';
      case _i18.ColumnType():
        return 'ColumnType';
      case _i19.DatabaseDefinition():
        return 'DatabaseDefinition';
      case _i20.DatabaseDefinitions():
        return 'DatabaseDefinitions';
      case _i21.DatabaseMigration():
        return 'DatabaseMigration';
      case _i22.DatabaseMigrationAction():
        return 'DatabaseMigrationAction';
      case _i23.RevokedAuthenticationAuthId():
        return 'RevokedAuthenticationAuthId';
      case _i24.DatabaseMigrationVersion():
        return 'DatabaseMigrationVersion';
      case _i25.DatabaseMigrationWarning():
        return 'DatabaseMigrationWarning';
      case _i26.DatabaseMigrationWarningType():
        return 'DatabaseMigrationWarningType';
      case _i27.EnumSerialization():
        return 'EnumSerialization';
      case _i28.Filter():
        return 'Filter';
      case _i29.FilterConstraint():
        return 'FilterConstraint';
      case _i30.FilterConstraintType():
        return 'FilterConstraintType';
      case _i31.ForeignKeyAction():
        return 'ForeignKeyAction';
      case _i32.ForeignKeyDefinition():
        return 'ForeignKeyDefinition';
      case _i33.ForeignKeyMatchType():
        return 'ForeignKeyMatchType';
      case _i34.IndexDefinition():
        return 'IndexDefinition';
      case _i35.IndexElementDefinition():
        return 'IndexElementDefinition';
      case _i36.IndexElementDefinitionType():
        return 'IndexElementDefinitionType';
      case _i37.TableDefinition():
        return 'TableDefinition';
      case _i38.TableMigration():
        return 'TableMigration';
      case _i39.VectorDistanceFunction():
        return 'VectorDistanceFunction';
      case _i40.DistributedCacheEntry():
        return 'DistributedCacheEntry';
      case _i41.SessionLogResult():
        return 'SessionLogResult';
      case _i42.FileNotFoundException():
        return 'FileNotFoundException';
      case _i43.FutureCallEntry():
        return 'FutureCallEntry';
      case _i44.LogEntry():
        return 'LogEntry';
      case _i45.LogLevel():
        return 'LogLevel';
      case _i46.LogResult():
        return 'LogResult';
      case _i47.LogSettings():
        return 'LogSettings';
      case _i48.LogSettingsOverride():
        return 'LogSettingsOverride';
      case _i49.MessageLogEntry():
        return 'MessageLogEntry';
      case _i50.MethodInfo():
        return 'MethodInfo';
      case _i51.QueryLogEntry():
        return 'QueryLogEntry';
      case _i52.ReadWriteTestEntry():
        return 'ReadWriteTestEntry';
      case _i53.RuntimeSettings():
        return 'RuntimeSettings';
      case _i54.ServerHealthConnectionInfo():
        return 'ServerHealthConnectionInfo';
      case _i55.ServerHealthMetric():
        return 'ServerHealthMetric';
      case _i56.ServerHealthResult():
        return 'ServerHealthResult';
      case _i57.ServerpodSqlException():
        return 'ServerpodSqlException';
      case _i58.SessionLogEntry():
        return 'SessionLogEntry';
      case _i59.SessionLogFilter():
        return 'SessionLogFilter';
      case _i60.SessionLogInfo():
        return 'SessionLogInfo';
      case _i61.AccessDeniedException():
        return 'AccessDeniedException';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'DatabaseMigrationActionType') {
      return deserialize<_i3.DatabaseMigrationActionType>(data['data']);
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
    if (dataClassName == 'RevokedAuthenticationAuthId') {
      return deserialize<_i23.RevokedAuthenticationAuthId>(data['data']);
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
    if (dataClassName == 'VectorDistanceFunction') {
      return deserialize<_i39.VectorDistanceFunction>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_i40.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_i41.SessionLogResult>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_i42.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_i43.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_i44.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_i45.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i46.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_i47.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i48.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_i49.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_i50.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_i51.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i52.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_i53.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_i54.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i55.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_i56.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i57.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i58.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i59.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i60.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i61.AccessDeniedException>(data['data']);
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
      case _i43.FutureCallEntry:
        return _i43.FutureCallEntry.t;
      case _i44.LogEntry:
        return _i44.LogEntry.t;
      case _i49.MessageLogEntry:
        return _i49.MessageLogEntry.t;
      case _i50.MethodInfo:
        return _i50.MethodInfo.t;
      case _i51.QueryLogEntry:
        return _i51.QueryLogEntry.t;
      case _i52.ReadWriteTestEntry:
        return _i52.ReadWriteTestEntry.t;
      case _i53.RuntimeSettings:
        return _i53.RuntimeSettings.t;
      case _i54.ServerHealthConnectionInfo:
        return _i54.ServerHealthConnectionInfo.t;
      case _i55.ServerHealthMetric:
        return _i55.ServerHealthMetric.t;
      case _i58.SessionLogEntry:
        return _i58.SessionLogEntry.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod';
}
