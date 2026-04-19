/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member

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
import 'future_call_scheduling.dart' as _i12;
import 'database_migration_version.dart' as _i13;
import 'distributed_cache_entry.dart' as _i14;
import 'exceptions/access_denied.dart' as _i15;
import 'exceptions/file_not_found.dart' as _i16;
import 'future_call_claim_entry.dart' as _i17;
import 'future_call_entry.dart' as _i18;
import 'log_entry.dart' as _i19;
import 'log_level.dart' as _i20;
import 'log_result.dart' as _i21;
import 'log_settings.dart' as _i22;
import 'log_settings_override.dart' as _i23;
import 'message_log_entry.dart' as _i24;
import 'method_info.dart' as _i25;
import 'query_log_entry.dart' as _i26;
import 'readwrite_test.dart' as _i27;
import 'runtime_settings.dart' as _i28;
import 'server_health_connection_info.dart' as _i29;
import 'server_health_metric.dart' as _i30;
import 'server_health_result.dart' as _i31;
import 'serverpod_sql_exception.dart' as _i32;
import 'session_log_entry.dart' as _i33;
import 'session_log_filter.dart' as _i34;
import 'session_log_info.dart' as _i35;
import 'session_log_result.dart' as _i36;
import 'package:serverpod_database/src/generated/table_definition.dart' as _i37;
import 'package:serverpod_database/serverpod_database.dart' as _i38;
export 'authentication/revoked_authentication_auth_id.dart';
export 'authentication/revoked_authentication_scope.dart';
export 'authentication/revoked_authentication_user.dart';
export 'cache_info.dart';
export 'caches_info.dart';
export 'cloud_storage.dart';
export 'cloud_storage_direct_upload.dart';
export 'cluster_info.dart';
export 'cluster_server_info.dart';
export 'database_migration_version.dart';
export 'distributed_cache_entry.dart';
export 'exceptions/access_denied.dart';
export 'exceptions/file_not_found.dart';
export 'future_call_claim_entry.dart';
export 'future_call_entry.dart';
export 'future_call_scheduling.dart';
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
          columnDefault: 'serial',
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
            ),
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
          columnDefault: 'serial',
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
          columnDefault: 'serial',
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
        _i2.ColumnDefinition(
          name: 'scheduling',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:FutureCallScheduling?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_future_call_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'time',
            ),
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
            ),
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
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_future_call_claim',
      dartName: 'FutureCallClaimEntry',
      schema: 'public',
      module: 'serverpod',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'futureCallId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'lastHeartbeatTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_future_call_claim_fk_0',
          columns: ['futureCallId'],
          referenceTable: 'serverpod_future_call',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'future_call_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'futureCallId',
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
          columnDefault: 'serial',
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
          columnDefault: 'serial',
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
          columnDefault: 'serial',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_log_sessionLogId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionLogId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'order',
            ),
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
          columnDefault: 'serial',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_message_log_sessionLogId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionLogId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'order',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
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
          columnDefault: 'serial',
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
          columnDefault: 'serial',
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
          indexName: 'serverpod_migrations_ids',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'module',
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
          columnDefault: 'serial',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_query_log_sessionLogId_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sessionLogId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'order',
            ),
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
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
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
          columnDefault: 'serial',
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
      indexes: [],
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
          columnDefault: 'serial',
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
          name: 'userId',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          indexName: 'serverpod_session_log_serverid_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'serverId',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_session_log_time_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'time',
            ),
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
            ),
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
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
  ];

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod.')) return className;
    return className.substring(10);
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

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
    if (t == _i12.CronFutureCallScheduling) {
      return _i12.CronFutureCallScheduling.fromJson(data) as T;
    }
    if (t == _i13.DatabaseMigrationVersion) {
      return _i13.DatabaseMigrationVersion.fromJson(data) as T;
    }
    if (t == _i14.DistributedCacheEntry) {
      return _i14.DistributedCacheEntry.fromJson(data) as T;
    }
    if (t == _i15.AccessDeniedException) {
      return _i15.AccessDeniedException.fromJson(data) as T;
    }
    if (t == _i16.FileNotFoundException) {
      return _i16.FileNotFoundException.fromJson(data) as T;
    }
    if (t == _i17.FutureCallClaimEntry) {
      return _i17.FutureCallClaimEntry.fromJson(data) as T;
    }
    if (t == _i18.FutureCallEntry) {
      return _i18.FutureCallEntry.fromJson(data) as T;
    }
    if (t == _i12.IntervalFutureCallScheduling) {
      return _i12.IntervalFutureCallScheduling.fromJson(data) as T;
    }
    if (t == _i19.LogEntry) {
      return _i19.LogEntry.fromJson(data) as T;
    }
    if (t == _i20.LogLevel) {
      return _i20.LogLevel.fromJson(data) as T;
    }
    if (t == _i21.LogResult) {
      return _i21.LogResult.fromJson(data) as T;
    }
    if (t == _i22.LogSettings) {
      return _i22.LogSettings.fromJson(data) as T;
    }
    if (t == _i23.LogSettingsOverride) {
      return _i23.LogSettingsOverride.fromJson(data) as T;
    }
    if (t == _i24.MessageLogEntry) {
      return _i24.MessageLogEntry.fromJson(data) as T;
    }
    if (t == _i25.MethodInfo) {
      return _i25.MethodInfo.fromJson(data) as T;
    }
    if (t == _i26.QueryLogEntry) {
      return _i26.QueryLogEntry.fromJson(data) as T;
    }
    if (t == _i27.ReadWriteTestEntry) {
      return _i27.ReadWriteTestEntry.fromJson(data) as T;
    }
    if (t == _i28.RuntimeSettings) {
      return _i28.RuntimeSettings.fromJson(data) as T;
    }
    if (t == _i29.ServerHealthConnectionInfo) {
      return _i29.ServerHealthConnectionInfo.fromJson(data) as T;
    }
    if (t == _i30.ServerHealthMetric) {
      return _i30.ServerHealthMetric.fromJson(data) as T;
    }
    if (t == _i31.ServerHealthResult) {
      return _i31.ServerHealthResult.fromJson(data) as T;
    }
    if (t == _i32.ServerpodSqlException) {
      return _i32.ServerpodSqlException.fromJson(data) as T;
    }
    if (t == _i33.SessionLogEntry) {
      return _i33.SessionLogEntry.fromJson(data) as T;
    }
    if (t == _i34.SessionLogFilter) {
      return _i34.SessionLogFilter.fromJson(data) as T;
    }
    if (t == _i35.SessionLogInfo) {
      return _i35.SessionLogInfo.fromJson(data) as T;
    }
    if (t == _i36.SessionLogResult) {
      return _i36.SessionLogResult.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.RevokedAuthenticationAuthId?>()) {
      return (data != null
              ? _i3.RevokedAuthenticationAuthId.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i4.RevokedAuthenticationScope?>()) {
      return (data != null
              ? _i4.RevokedAuthenticationScope.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i5.RevokedAuthenticationUser?>()) {
      return (data != null
              ? _i5.RevokedAuthenticationUser.fromJson(data)
              : null)
          as T;
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
              : null)
          as T;
    }
    if (t == _i1.getType<_i10.ClusterInfo?>()) {
      return (data != null ? _i10.ClusterInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.ClusterServerInfo?>()) {
      return (data != null ? _i11.ClusterServerInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CronFutureCallScheduling?>()) {
      return (data != null
              ? _i12.CronFutureCallScheduling.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i13.DatabaseMigrationVersion?>()) {
      return (data != null
              ? _i13.DatabaseMigrationVersion.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i14.DistributedCacheEntry?>()) {
      return (data != null ? _i14.DistributedCacheEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.AccessDeniedException?>()) {
      return (data != null ? _i15.AccessDeniedException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.FileNotFoundException?>()) {
      return (data != null ? _i16.FileNotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.FutureCallClaimEntry?>()) {
      return (data != null ? _i17.FutureCallClaimEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.FutureCallEntry?>()) {
      return (data != null ? _i18.FutureCallEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.IntervalFutureCallScheduling?>()) {
      return (data != null
              ? _i12.IntervalFutureCallScheduling.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i19.LogEntry?>()) {
      return (data != null ? _i19.LogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.LogLevel?>()) {
      return (data != null ? _i20.LogLevel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.LogResult?>()) {
      return (data != null ? _i21.LogResult.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.LogSettings?>()) {
      return (data != null ? _i22.LogSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.LogSettingsOverride?>()) {
      return (data != null ? _i23.LogSettingsOverride.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.MessageLogEntry?>()) {
      return (data != null ? _i24.MessageLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.MethodInfo?>()) {
      return (data != null ? _i25.MethodInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.QueryLogEntry?>()) {
      return (data != null ? _i26.QueryLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ReadWriteTestEntry?>()) {
      return (data != null ? _i27.ReadWriteTestEntry.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.RuntimeSettings?>()) {
      return (data != null ? _i28.RuntimeSettings.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.ServerHealthConnectionInfo?>()) {
      return (data != null
              ? _i29.ServerHealthConnectionInfo.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i30.ServerHealthMetric?>()) {
      return (data != null ? _i30.ServerHealthMetric.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.ServerHealthResult?>()) {
      return (data != null ? _i31.ServerHealthResult.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.ServerpodSqlException?>()) {
      return (data != null ? _i32.ServerpodSqlException.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.SessionLogEntry?>()) {
      return (data != null ? _i33.SessionLogEntry.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.SessionLogFilter?>()) {
      return (data != null ? _i34.SessionLogFilter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.SessionLogInfo?>()) {
      return (data != null ? _i35.SessionLogInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.SessionLogResult?>()) {
      return (data != null ? _i36.SessionLogResult.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i11.ClusterServerInfo>) {
      return (data as List)
              .map((e) => deserialize<_i11.ClusterServerInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i19.LogEntry>) {
      return (data as List).map((e) => deserialize<_i19.LogEntry>(e)).toList()
          as T;
    }
    if (t == List<_i23.LogSettingsOverride>) {
      return (data as List)
              .map((e) => deserialize<_i23.LogSettingsOverride>(e))
              .toList()
          as T;
    }
    if (t == List<_i30.ServerHealthMetric>) {
      return (data as List)
              .map((e) => deserialize<_i30.ServerHealthMetric>(e))
              .toList()
          as T;
    }
    if (t == List<_i29.ServerHealthConnectionInfo>) {
      return (data as List)
              .map((e) => deserialize<_i29.ServerHealthConnectionInfo>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i19.LogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i19.LogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i26.QueryLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i26.QueryLogEntry>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i26.QueryLogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i26.QueryLogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i24.MessageLogEntry>) {
      return (data as List)
              .map((e) => deserialize<_i24.MessageLogEntry>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i24.MessageLogEntry>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i24.MessageLogEntry>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i35.SessionLogInfo>) {
      return (data as List)
              .map((e) => deserialize<_i35.SessionLogInfo>(e))
              .toList()
          as T;
    }
    if (t == List<_i37.TableDefinition>) {
      return (data as List)
              .map((e) => deserialize<_i37.TableDefinition>(e))
              .toList()
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    try {
      return _i38.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.RevokedAuthenticationAuthId => 'RevokedAuthenticationAuthId',
      _i4.RevokedAuthenticationScope => 'RevokedAuthenticationScope',
      _i5.RevokedAuthenticationUser => 'RevokedAuthenticationUser',
      _i6.CacheInfo => 'CacheInfo',
      _i7.CachesInfo => 'CachesInfo',
      _i8.CloudStorageEntry => 'CloudStorageEntry',
      _i9.CloudStorageDirectUploadEntry => 'CloudStorageDirectUploadEntry',
      _i10.ClusterInfo => 'ClusterInfo',
      _i11.ClusterServerInfo => 'ClusterServerInfo',
      _i12.CronFutureCallScheduling => 'CronFutureCallScheduling',
      _i13.DatabaseMigrationVersion => 'DatabaseMigrationVersion',
      _i14.DistributedCacheEntry => 'DistributedCacheEntry',
      _i15.AccessDeniedException => 'AccessDeniedException',
      _i16.FileNotFoundException => 'FileNotFoundException',
      _i17.FutureCallClaimEntry => 'FutureCallClaimEntry',
      _i18.FutureCallEntry => 'FutureCallEntry',
      _i12.IntervalFutureCallScheduling => 'IntervalFutureCallScheduling',
      _i19.LogEntry => 'LogEntry',
      _i20.LogLevel => 'LogLevel',
      _i21.LogResult => 'LogResult',
      _i22.LogSettings => 'LogSettings',
      _i23.LogSettingsOverride => 'LogSettingsOverride',
      _i24.MessageLogEntry => 'MessageLogEntry',
      _i25.MethodInfo => 'MethodInfo',
      _i26.QueryLogEntry => 'QueryLogEntry',
      _i27.ReadWriteTestEntry => 'ReadWriteTestEntry',
      _i28.RuntimeSettings => 'RuntimeSettings',
      _i29.ServerHealthConnectionInfo => 'ServerHealthConnectionInfo',
      _i30.ServerHealthMetric => 'ServerHealthMetric',
      _i31.ServerHealthResult => 'ServerHealthResult',
      _i32.ServerpodSqlException => 'ServerpodSqlException',
      _i33.SessionLogEntry => 'SessionLogEntry',
      _i34.SessionLogFilter => 'SessionLogFilter',
      _i35.SessionLogInfo => 'SessionLogInfo',
      _i36.SessionLogResult => 'SessionLogResult',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst('serverpod.', '');
    }

    switch (data) {
      case _i3.RevokedAuthenticationAuthId():
        return 'RevokedAuthenticationAuthId';
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
      case _i12.CronFutureCallScheduling():
        return 'CronFutureCallScheduling';
      case _i13.DatabaseMigrationVersion():
        return 'DatabaseMigrationVersion';
      case _i14.DistributedCacheEntry():
        return 'DistributedCacheEntry';
      case _i15.AccessDeniedException():
        return 'AccessDeniedException';
      case _i16.FileNotFoundException():
        return 'FileNotFoundException';
      case _i17.FutureCallClaimEntry():
        return 'FutureCallClaimEntry';
      case _i18.FutureCallEntry():
        return 'FutureCallEntry';
      case _i12.IntervalFutureCallScheduling():
        return 'IntervalFutureCallScheduling';
      case _i19.LogEntry():
        return 'LogEntry';
      case _i20.LogLevel():
        return 'LogLevel';
      case _i21.LogResult():
        return 'LogResult';
      case _i22.LogSettings():
        return 'LogSettings';
      case _i23.LogSettingsOverride():
        return 'LogSettingsOverride';
      case _i24.MessageLogEntry():
        return 'MessageLogEntry';
      case _i25.MethodInfo():
        return 'MethodInfo';
      case _i26.QueryLogEntry():
        return 'QueryLogEntry';
      case _i27.ReadWriteTestEntry():
        return 'ReadWriteTestEntry';
      case _i28.RuntimeSettings():
        return 'RuntimeSettings';
      case _i29.ServerHealthConnectionInfo():
        return 'ServerHealthConnectionInfo';
      case _i30.ServerHealthMetric():
        return 'ServerHealthMetric';
      case _i31.ServerHealthResult():
        return 'ServerHealthResult';
      case _i32.ServerpodSqlException():
        return 'ServerpodSqlException';
      case _i33.SessionLogEntry():
        return 'SessionLogEntry';
      case _i34.SessionLogFilter():
        return 'SessionLogFilter';
      case _i35.SessionLogInfo():
        return 'SessionLogInfo';
      case _i36.SessionLogResult():
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
    if (dataClassName == 'CronFutureCallScheduling') {
      return deserialize<_i12.CronFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'DatabaseMigrationVersion') {
      return deserialize<_i13.DatabaseMigrationVersion>(data['data']);
    }
    if (dataClassName == 'DistributedCacheEntry') {
      return deserialize<_i14.DistributedCacheEntry>(data['data']);
    }
    if (dataClassName == 'AccessDeniedException') {
      return deserialize<_i15.AccessDeniedException>(data['data']);
    }
    if (dataClassName == 'FileNotFoundException') {
      return deserialize<_i16.FileNotFoundException>(data['data']);
    }
    if (dataClassName == 'FutureCallClaimEntry') {
      return deserialize<_i17.FutureCallClaimEntry>(data['data']);
    }
    if (dataClassName == 'FutureCallEntry') {
      return deserialize<_i18.FutureCallEntry>(data['data']);
    }
    if (dataClassName == 'IntervalFutureCallScheduling') {
      return deserialize<_i12.IntervalFutureCallScheduling>(data['data']);
    }
    if (dataClassName == 'LogEntry') {
      return deserialize<_i19.LogEntry>(data['data']);
    }
    if (dataClassName == 'LogLevel') {
      return deserialize<_i20.LogLevel>(data['data']);
    }
    if (dataClassName == 'LogResult') {
      return deserialize<_i21.LogResult>(data['data']);
    }
    if (dataClassName == 'LogSettings') {
      return deserialize<_i22.LogSettings>(data['data']);
    }
    if (dataClassName == 'LogSettingsOverride') {
      return deserialize<_i23.LogSettingsOverride>(data['data']);
    }
    if (dataClassName == 'MessageLogEntry') {
      return deserialize<_i24.MessageLogEntry>(data['data']);
    }
    if (dataClassName == 'MethodInfo') {
      return deserialize<_i25.MethodInfo>(data['data']);
    }
    if (dataClassName == 'QueryLogEntry') {
      return deserialize<_i26.QueryLogEntry>(data['data']);
    }
    if (dataClassName == 'ReadWriteTestEntry') {
      return deserialize<_i27.ReadWriteTestEntry>(data['data']);
    }
    if (dataClassName == 'RuntimeSettings') {
      return deserialize<_i28.RuntimeSettings>(data['data']);
    }
    if (dataClassName == 'ServerHealthConnectionInfo') {
      return deserialize<_i29.ServerHealthConnectionInfo>(data['data']);
    }
    if (dataClassName == 'ServerHealthMetric') {
      return deserialize<_i30.ServerHealthMetric>(data['data']);
    }
    if (dataClassName == 'ServerHealthResult') {
      return deserialize<_i31.ServerHealthResult>(data['data']);
    }
    if (dataClassName == 'ServerpodSqlException') {
      return deserialize<_i32.ServerpodSqlException>(data['data']);
    }
    if (dataClassName == 'SessionLogEntry') {
      return deserialize<_i33.SessionLogEntry>(data['data']);
    }
    if (dataClassName == 'SessionLogFilter') {
      return deserialize<_i34.SessionLogFilter>(data['data']);
    }
    if (dataClassName == 'SessionLogInfo') {
      return deserialize<_i35.SessionLogInfo>(data['data']);
    }
    if (dataClassName == 'SessionLogResult') {
      return deserialize<_i36.SessionLogResult>(data['data']);
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
      case _i13.DatabaseMigrationVersion:
        return _i13.DatabaseMigrationVersion.t;
      case _i17.FutureCallClaimEntry:
        return _i17.FutureCallClaimEntry.t;
      case _i18.FutureCallEntry:
        return _i18.FutureCallEntry.t;
      case _i19.LogEntry:
        return _i19.LogEntry.t;
      case _i24.MessageLogEntry:
        return _i24.MessageLogEntry.t;
      case _i25.MethodInfo:
        return _i25.MethodInfo.t;
      case _i26.QueryLogEntry:
        return _i26.QueryLogEntry.t;
      case _i27.ReadWriteTestEntry:
        return _i27.ReadWriteTestEntry.t;
      case _i28.RuntimeSettings:
        return _i28.RuntimeSettings.t;
      case _i29.ServerHealthConnectionInfo:
        return _i29.ServerHealthConnectionInfo.t;
      case _i30.ServerHealthMetric:
        return _i30.ServerHealthMetric.t;
      case _i33.SessionLogEntry:
        return _i33.SessionLogEntry.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    throw Exception('Unsupported record type ${record.runtimeType}');
  }
}
