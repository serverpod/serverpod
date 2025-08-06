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
import 'package:serverpod_auth_profile_server/serverpod_auth_profile_server.dart'
    as _i3;
import 'package:serverpod_auth_session_server/serverpod_auth_session_server.dart'
    as _i4;
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i5;
import 'providers/apple/models/apple_account.dart' as _i6;
import 'providers/email/models/email_account.dart' as _i7;
import 'providers/email/models/email_account_failed_login_attempt.dart' as _i8;
import 'providers/email/models/email_account_password_reset_attempt.dart'
    as _i9;
import 'providers/email/models/email_account_password_reset_request.dart'
    as _i10;
import 'providers/email/models/email_account_password_reset_request_attempt.dart'
    as _i11;
import 'providers/email/models/email_account_request.dart' as _i12;
import 'providers/email/models/email_account_request_completion_attempt.dart'
    as _i13;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i14;
import 'providers/email/models/exceptions/email_account_login_failure_reason.dart'
    as _i15;
import 'providers/email/models/exceptions/email_account_password_policy_violation_exception.dart'
    as _i16;
import 'providers/email/models/exceptions/email_account_password_reset_request_expired_exception.dart'
    as _i17;
import 'providers/email/models/exceptions/email_account_password_reset_request_not_found_exception.dart'
    as _i18;
import 'providers/email/models/exceptions/email_account_password_reset_request_too_many_attempts_exception.dart'
    as _i19;
import 'providers/email/models/exceptions/email_account_password_reset_request_unauthorized_exception.dart'
    as _i20;
import 'providers/email/models/exceptions/email_account_password_reset_too_many_attempts_exception.dart'
    as _i21;
import 'providers/email/models/exceptions/email_account_request_expired_exception.dart'
    as _i22;
import 'providers/email/models/exceptions/email_account_request_not_found_exception.dart'
    as _i23;
import 'providers/email/models/exceptions/email_account_request_not_verified_exception.dart'
    as _i24;
import 'providers/email/models/exceptions/email_account_request_too_many_attempts_exception.dart'
    as _i25;
import 'providers/email/models/exceptions/email_account_request_unauthorized_exception.dart'
    as _i26;
import 'providers/google/models/google_account.dart' as _i27;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i28;
export 'providers/apple/models/apple_account.dart';
export 'providers/email/models/email_account.dart';
export 'providers/email/models/email_account_failed_login_attempt.dart';
export 'providers/email/models/email_account_password_reset_attempt.dart';
export 'providers/email/models/email_account_password_reset_request.dart';
export 'providers/email/models/email_account_password_reset_request_attempt.dart';
export 'providers/email/models/email_account_request.dart';
export 'providers/email/models/email_account_request_completion_attempt.dart';
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_failure_reason.dart';
export 'providers/email/models/exceptions/email_account_password_policy_violation_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_request_expired_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_request_not_found_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_request_too_many_attempts_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_request_unauthorized_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_too_many_attempts_exception.dart';
export 'providers/email/models/exceptions/email_account_request_expired_exception.dart';
export 'providers/email/models/exceptions/email_account_request_not_found_exception.dart';
export 'providers/email/models/exceptions/email_account_request_not_verified_exception.dart';
export 'providers/email/models/exceptions/email_account_request_too_many_attempts_exception.dart';
export 'providers/email/models/exceptions/email_account_request_unauthorized_exception.dart';
export 'providers/google/models/google_account.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_idp_apple_account',
      dartName: 'AppleAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'refreshToken',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'refreshTokenRequestedWithBundleIdentifier',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'lastRefreshedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'isEmailVerified',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'isPrivateEmail',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'firstName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'lastName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_apple_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_apple_account_pkey',
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
          indexName: 'serverpod_auth_apple_account_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
      name: 'serverpod_auth_idp_email_account',
      dartName: 'EmailAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'passwordHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'passwordSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
      name: 'serverpod_auth_idp_email_account_failed_login_attempt',
      dartName: 'EmailAccountFailedLoginAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName:
              'serverpod_auth_idp_email_account_failed_login_attempt_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_failed_login_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_failed_login_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attemptedAt',
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
      name: 'serverpod_auth_idp_email_account_password_reset',
      dartName: 'EmailAccountPasswordResetAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'passwordResetRequestId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_fk_0',
          columns: ['passwordResetRequestId'],
          referenceTable:
              'serverpod_auth_idp_email_account_password_reset_request',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_password_reset_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_password_reset_ip',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ipAddress',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_password_reset_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attemptedAt',
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
      name: 'serverpod_auth_idp_email_account_password_reset_request',
      dartName: 'EmailAccountPasswordResetRequest',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'emailAccountId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCodeHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCodeSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_0',
          columns: ['emailAccountId'],
          referenceTable: 'serverpod_auth_idp_email_account',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName:
              'serverpod_auth_idp_email_account_password_reset_request_pkey',
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
      name: 'serverpod_auth_idp_email_account_pw_reset_request',
      dartName: 'EmailAccountPasswordResetRequestAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_pw_reset_request_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_pw_reset_request_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_pw_reset_request_ip',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ipAddress',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_pw_reset_request_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attemptedAt',
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
      name: 'serverpod_auth_idp_email_account_request',
      dartName: 'EmailAccountRequest',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'passwordHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'passwordSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCodeHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCodeSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'verifiedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_request_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_request_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
      name: 'serverpod_auth_idp_email_account_request_completion',
      dartName: 'EmailAccountRequestCompletionAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'emailAccountRequestId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_request_completion_fk_0',
          columns: ['emailAccountRequestId'],
          referenceTable: 'serverpod_auth_idp_email_account_request',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_request_completion_pkey',
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
          indexName: 'serverpod_auth_idp_email_account_request_completion_ip',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'ipAddress',
            )
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_request_completion_at',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attemptedAt',
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
      name: 'serverpod_auth_idp_google_account',
      dartName: 'GoogleAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'created',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_google_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_google_account_pkey',
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
          indexName: 'serverpod_auth_google_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i5.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i6.AppleAccount) {
      return _i6.AppleAccount.fromJson(data) as T;
    }
    if (t == _i7.EmailAccount) {
      return _i7.EmailAccount.fromJson(data) as T;
    }
    if (t == _i8.EmailAccountFailedLoginAttempt) {
      return _i8.EmailAccountFailedLoginAttempt.fromJson(data) as T;
    }
    if (t == _i9.EmailAccountPasswordResetAttempt) {
      return _i9.EmailAccountPasswordResetAttempt.fromJson(data) as T;
    }
    if (t == _i10.EmailAccountPasswordResetRequest) {
      return _i10.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _i11.EmailAccountPasswordResetRequestAttempt) {
      return _i11.EmailAccountPasswordResetRequestAttempt.fromJson(data) as T;
    }
    if (t == _i12.EmailAccountRequest) {
      return _i12.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _i13.EmailAccountRequestCompletionAttempt) {
      return _i13.EmailAccountRequestCompletionAttempt.fromJson(data) as T;
    }
    if (t == _i14.EmailAccountLoginException) {
      return _i14.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i15.EmailAccountLoginFailureReason) {
      return _i15.EmailAccountLoginFailureReason.fromJson(data) as T;
    }
    if (t == _i16.EmailAccountPasswordPolicyViolationException) {
      return _i16.EmailAccountPasswordPolicyViolationException.fromJson(data)
          as T;
    }
    if (t == _i17.EmailAccountPasswordResetRequestExpiredException) {
      return _i17.EmailAccountPasswordResetRequestExpiredException.fromJson(
          data) as T;
    }
    if (t == _i18.EmailAccountPasswordResetRequestNotFoundException) {
      return _i18.EmailAccountPasswordResetRequestNotFoundException.fromJson(
          data) as T;
    }
    if (t == _i19.EmailAccountPasswordResetRequestTooManyAttemptsException) {
      return _i19.EmailAccountPasswordResetRequestTooManyAttemptsException
          .fromJson(data) as T;
    }
    if (t == _i20.EmailAccountPasswordResetRequestUnauthorizedException) {
      return _i20.EmailAccountPasswordResetRequestUnauthorizedException
          .fromJson(data) as T;
    }
    if (t == _i21.EmailAccountPasswordResetTooManyAttemptsException) {
      return _i21.EmailAccountPasswordResetTooManyAttemptsException.fromJson(
          data) as T;
    }
    if (t == _i22.EmailAccountRequestExpiredException) {
      return _i22.EmailAccountRequestExpiredException.fromJson(data) as T;
    }
    if (t == _i23.EmailAccountRequestNotFoundException) {
      return _i23.EmailAccountRequestNotFoundException.fromJson(data) as T;
    }
    if (t == _i24.EmailAccountRequestNotVerifiedException) {
      return _i24.EmailAccountRequestNotVerifiedException.fromJson(data) as T;
    }
    if (t == _i25.EmailAccountRequestTooManyAttemptsException) {
      return _i25.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          as T;
    }
    if (t == _i26.EmailAccountRequestUnauthorizedException) {
      return _i26.EmailAccountRequestUnauthorizedException.fromJson(data) as T;
    }
    if (t == _i27.GoogleAccount) {
      return _i27.GoogleAccount.fromJson(data) as T;
    }
    if (t == _i28.GoogleIdTokenVerificationException) {
      return _i28.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i6.AppleAccount?>()) {
      return (data != null ? _i6.AppleAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccount?>()) {
      return (data != null ? _i7.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EmailAccountFailedLoginAttempt?>()) {
      return (data != null
          ? _i8.EmailAccountFailedLoginAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.EmailAccountPasswordResetAttempt?>()) {
      return (data != null
          ? _i9.EmailAccountPasswordResetAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i10.EmailAccountPasswordResetRequest?>()) {
      return (data != null
          ? _i10.EmailAccountPasswordResetRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.EmailAccountPasswordResetRequestAttempt?>()) {
      return (data != null
          ? _i11.EmailAccountPasswordResetRequestAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.EmailAccountRequest?>()) {
      return (data != null ? _i12.EmailAccountRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i13.EmailAccountRequestCompletionAttempt?>()) {
      return (data != null
          ? _i13.EmailAccountRequestCompletionAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.EmailAccountLoginException?>()) {
      return (data != null
          ? _i14.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.EmailAccountLoginFailureReason?>()) {
      return (data != null
          ? _i15.EmailAccountLoginFailureReason.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i16.EmailAccountPasswordPolicyViolationException?>()) {
      return (data != null
          ? _i16.EmailAccountPasswordPolicyViolationException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i17.EmailAccountPasswordResetRequestExpiredException?>()) {
      return (data != null
          ? _i17.EmailAccountPasswordResetRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i18.EmailAccountPasswordResetRequestNotFoundException?>()) {
      return (data != null
          ? _i18.EmailAccountPasswordResetRequestNotFoundException.fromJson(
              data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i19.EmailAccountPasswordResetRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i19.EmailAccountPasswordResetRequestTooManyAttemptsException
              .fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i20.EmailAccountPasswordResetRequestUnauthorizedException?>()) {
      return (data != null
          ? _i20.EmailAccountPasswordResetRequestUnauthorizedException.fromJson(
              data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i21.EmailAccountPasswordResetTooManyAttemptsException?>()) {
      return (data != null
          ? _i21.EmailAccountPasswordResetTooManyAttemptsException.fromJson(
              data)
          : null) as T;
    }
    if (t == _i1.getType<_i22.EmailAccountRequestExpiredException?>()) {
      return (data != null
          ? _i22.EmailAccountRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i23.EmailAccountRequestNotFoundException?>()) {
      return (data != null
          ? _i23.EmailAccountRequestNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i24.EmailAccountRequestNotVerifiedException?>()) {
      return (data != null
          ? _i24.EmailAccountRequestNotVerifiedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i25.EmailAccountRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i25.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i26.EmailAccountRequestUnauthorizedException?>()) {
      return (data != null
          ? _i26.EmailAccountRequestUnauthorizedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i27.GoogleAccount?>()) {
      return (data != null ? _i27.GoogleAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.GoogleIdTokenVerificationException?>()) {
      return (data != null
          ? _i28.GoogleIdTokenVerificationException.fromJson(data)
          : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i5.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    switch (data) {
      case _i6.AppleAccount():
        return 'AppleAccount';
      case _i7.EmailAccount():
        return 'EmailAccount';
      case _i8.EmailAccountFailedLoginAttempt():
        return 'EmailAccountFailedLoginAttempt';
      case _i9.EmailAccountPasswordResetAttempt():
        return 'EmailAccountPasswordResetAttempt';
      case _i10.EmailAccountPasswordResetRequest():
        return 'EmailAccountPasswordResetRequest';
      case _i11.EmailAccountPasswordResetRequestAttempt():
        return 'EmailAccountPasswordResetRequestAttempt';
      case _i12.EmailAccountRequest():
        return 'EmailAccountRequest';
      case _i13.EmailAccountRequestCompletionAttempt():
        return 'EmailAccountRequestCompletionAttempt';
      case _i14.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i15.EmailAccountLoginFailureReason():
        return 'EmailAccountLoginFailureReason';
      case _i16.EmailAccountPasswordPolicyViolationException():
        return 'EmailAccountPasswordPolicyViolationException';
      case _i17.EmailAccountPasswordResetRequestExpiredException():
        return 'EmailAccountPasswordResetRequestExpiredException';
      case _i18.EmailAccountPasswordResetRequestNotFoundException():
        return 'EmailAccountPasswordResetRequestNotFoundException';
      case _i19.EmailAccountPasswordResetRequestTooManyAttemptsException():
        return 'EmailAccountPasswordResetRequestTooManyAttemptsException';
      case _i20.EmailAccountPasswordResetRequestUnauthorizedException():
        return 'EmailAccountPasswordResetRequestUnauthorizedException';
      case _i21.EmailAccountPasswordResetTooManyAttemptsException():
        return 'EmailAccountPasswordResetTooManyAttemptsException';
      case _i22.EmailAccountRequestExpiredException():
        return 'EmailAccountRequestExpiredException';
      case _i23.EmailAccountRequestNotFoundException():
        return 'EmailAccountRequestNotFoundException';
      case _i24.EmailAccountRequestNotVerifiedException():
        return 'EmailAccountRequestNotVerifiedException';
      case _i25.EmailAccountRequestTooManyAttemptsException():
        return 'EmailAccountRequestTooManyAttemptsException';
      case _i26.EmailAccountRequestUnauthorizedException():
        return 'EmailAccountRequestUnauthorizedException';
      case _i27.GoogleAccount():
        return 'GoogleAccount';
      case _i28.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_profile.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_session.$className';
    }
    className = _i5.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_user.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'AppleAccount') {
      return deserialize<_i6.AppleAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i7.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountFailedLoginAttempt') {
      return deserialize<_i8.EmailAccountFailedLoginAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetAttempt') {
      return deserialize<_i9.EmailAccountPasswordResetAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i10.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestAttempt') {
      return deserialize<_i11.EmailAccountPasswordResetRequestAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i12.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestCompletionAttempt') {
      return deserialize<_i13.EmailAccountRequestCompletionAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i14.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginFailureReason') {
      return deserialize<_i15.EmailAccountLoginFailureReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordPolicyViolationException') {
      return deserialize<_i16.EmailAccountPasswordPolicyViolationException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestExpiredException') {
      return deserialize<_i17.EmailAccountPasswordResetRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestNotFoundException') {
      return deserialize<
          _i18.EmailAccountPasswordResetRequestNotFoundException>(data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestTooManyAttemptsException') {
      return deserialize<
              _i19.EmailAccountPasswordResetRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestUnauthorizedException') {
      return deserialize<
          _i20
          .EmailAccountPasswordResetRequestUnauthorizedException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetTooManyAttemptsException') {
      return deserialize<
          _i21.EmailAccountPasswordResetTooManyAttemptsException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExpiredException') {
      return deserialize<_i22.EmailAccountRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotFoundException') {
      return deserialize<_i23.EmailAccountRequestNotFoundException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotVerifiedException') {
      return deserialize<_i24.EmailAccountRequestNotVerifiedException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestTooManyAttemptsException') {
      return deserialize<_i25.EmailAccountRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestUnauthorizedException') {
      return deserialize<_i26.EmailAccountRequestUnauthorizedException>(
          data['data']);
    }
    if (dataClassName == 'GoogleAccount') {
      return deserialize<_i27.GoogleAccount>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i28.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_profile.')) {
      data['className'] = dataClassName.substring(23);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_session.')) {
      data['className'] = dataClassName.substring(23);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
      data['className'] = dataClassName.substring(20);
      return _i5.Protocol().deserializeByClassName(data);
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
      var table = _i5.Protocol().getTableForType(t);
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
      case _i6.AppleAccount:
        return _i6.AppleAccount.t;
      case _i7.EmailAccount:
        return _i7.EmailAccount.t;
      case _i8.EmailAccountFailedLoginAttempt:
        return _i8.EmailAccountFailedLoginAttempt.t;
      case _i9.EmailAccountPasswordResetAttempt:
        return _i9.EmailAccountPasswordResetAttempt.t;
      case _i10.EmailAccountPasswordResetRequest:
        return _i10.EmailAccountPasswordResetRequest.t;
      case _i11.EmailAccountPasswordResetRequestAttempt:
        return _i11.EmailAccountPasswordResetRequestAttempt.t;
      case _i12.EmailAccountRequest:
        return _i12.EmailAccountRequest.t;
      case _i13.EmailAccountRequestCompletionAttempt:
        return _i13.EmailAccountRequestCompletionAttempt.t;
      case _i27.GoogleAccount:
        return _i27.GoogleAccount.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_idp';
}
