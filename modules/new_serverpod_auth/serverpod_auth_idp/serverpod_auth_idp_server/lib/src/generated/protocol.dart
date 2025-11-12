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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i3;
import 'common/models/secret_challenge.dart' as _i4;
import 'providers/apple/models/apple_account.dart' as _i5;
import 'providers/email/models/create_account/email_account_failed_login_attempt.dart'
    as _i6;
import 'providers/email/models/create_account/email_account_request.dart'
    as _i7;
import 'providers/email/models/create_account/email_account_request_completion_attempt.dart'
    as _i8;
import 'providers/email/models/email_account.dart' as _i9;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i10;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _i11;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i12;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i13;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _i14;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _i15;
import 'providers/email/models/password_reset/email_account_password_reset_complete_attempt.dart'
    as _i16;
import 'providers/email/models/password_reset/email_account_password_reset_request.dart'
    as _i17;
import 'providers/email/models/password_reset/email_account_password_reset_request_attempt.dart'
    as _i18;
import 'providers/google/models/google_account.dart' as _i19;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i20;
import 'providers/passkey/models/passkey_account.dart' as _i21;
import 'providers/passkey/models/passkey_challenge.dart' as _i22;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _i23;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _i24;
import 'providers/passkey/models/passkey_login_request.dart' as _i25;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _i26;
import 'providers/passkey/models/passkey_registration_request.dart' as _i27;
import 'dart:typed_data' as _i28;
export 'common/models/secret_challenge.dart';
export 'providers/apple/models/apple_account.dart';
export 'providers/email/models/create_account/email_account_failed_login_attempt.dart';
export 'providers/email/models/create_account/email_account_request.dart';
export 'providers/email/models/create_account/email_account_request_completion_attempt.dart';
export 'providers/email/models/email_account.dart';
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/email/models/password_reset/email_account_password_reset_complete_attempt.dart';
export 'providers/email/models/password_reset/email_account_password_reset_request.dart';
export 'providers/email/models/password_reset/email_account_password_reset_request_attempt.dart';
export 'providers/google/models/google_account.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
export 'providers/passkey/models/passkey_account.dart';
export 'providers/passkey/models/passkey_challenge.dart';
export 'providers/passkey/models/passkey_challenge_expired_exception.dart';
export 'providers/passkey/models/passkey_challenge_not_found_exception.dart';
export 'providers/passkey/models/passkey_login_request.dart';
export 'providers/passkey/models/passkey_public_key_not_found_exception.dart';
export 'providers/passkey/models/passkey_registration_request.dart';

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
          columnDefault: 'gen_random_uuid_v7()',
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
          referenceTable: 'serverpod_auth_core_user',
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
          columnDefault: 'gen_random_uuid_v7()',
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
          referenceTable: 'serverpod_auth_core_user',
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
          columnDefault: 'gen_random_uuid_v7()',
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
      name: 'serverpod_auth_idp_email_account_password_reset_complete',
      dartName: 'EmailAccountPasswordResetCompleteAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
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
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName:
              'serverpod_auth_idp_email_account_password_reset_complete_pkey',
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
          columnDefault: 'gen_random_uuid_v7()',
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
          name: 'challengeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'setPasswordChallengeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
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
        ),
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_1',
          columns: ['challengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_2',
          columns: ['setPasswordChallengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
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
          columnDefault: 'gen_random_uuid_v7()',
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
          columnDefault: 'gen_random_uuid_v7()',
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
          name: 'challengeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'createAccountChallengeId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_request_fk_0',
          columns: ['challengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_request_fk_1',
          columns: ['createAccountChallengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
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
          columnDefault: 'gen_random_uuid_v7()',
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
      foreignKeys: [],
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
          columnDefault: 'gen_random_uuid_v7()',
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
          referenceTable: 'serverpod_auth_core_user',
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
    _i2.TableDefinition(
      name: 'serverpod_auth_idp_passkey_account',
      dartName: 'PasskeyAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
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
          name: 'keyId',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'keyIdBase64',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'clientDataJSON',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'attestationObject',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'originalChallenge',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_passkey_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_passkey_account_pkey',
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
          indexName: 'serverpod_auth_idp_passkey_account_key_id_base64',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'keyIdBase64',
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
      name: 'serverpod_auth_idp_passkey_challenge',
      dartName: 'PasskeyChallenge',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'challenge',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_passkey_challenge_pkey',
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
      name: 'serverpod_auth_idp_secret_challenge',
      dartName: 'SecretChallenge',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'challengeCodeHash',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _i2.ColumnDefinition(
          name: 'challengeCodeSalt',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_secret_challenge_pkey',
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
    ..._i3.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.SecretChallenge) {
      return _i4.SecretChallenge.fromJson(data) as T;
    }
    if (t == _i5.AppleAccount) {
      return _i5.AppleAccount.fromJson(data) as T;
    }
    if (t == _i6.EmailAccountFailedLoginAttempt) {
      return _i6.EmailAccountFailedLoginAttempt.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountRequest) {
      return _i7.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _i8.EmailAccountRequestCompletionAttempt) {
      return _i8.EmailAccountRequestCompletionAttempt.fromJson(data) as T;
    }
    if (t == _i9.EmailAccount) {
      return _i9.EmailAccount.fromJson(data) as T;
    }
    if (t == _i10.EmailAccountLoginException) {
      return _i10.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i11.EmailAccountLoginExceptionReason) {
      return _i11.EmailAccountLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i12.EmailAccountPasswordResetException) {
      return _i12.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _i13.EmailAccountPasswordResetExceptionReason) {
      return _i13.EmailAccountPasswordResetExceptionReason.fromJson(data) as T;
    }
    if (t == _i14.EmailAccountRequestException) {
      return _i14.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _i15.EmailAccountRequestExceptionReason) {
      return _i15.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i16.EmailAccountPasswordResetCompleteAttempt) {
      return _i16.EmailAccountPasswordResetCompleteAttempt.fromJson(data) as T;
    }
    if (t == _i17.EmailAccountPasswordResetRequest) {
      return _i17.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _i18.EmailAccountPasswordResetRequestAttempt) {
      return _i18.EmailAccountPasswordResetRequestAttempt.fromJson(data) as T;
    }
    if (t == _i19.GoogleAccount) {
      return _i19.GoogleAccount.fromJson(data) as T;
    }
    if (t == _i20.GoogleIdTokenVerificationException) {
      return _i20.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i21.PasskeyAccount) {
      return _i21.PasskeyAccount.fromJson(data) as T;
    }
    if (t == _i22.PasskeyChallenge) {
      return _i22.PasskeyChallenge.fromJson(data) as T;
    }
    if (t == _i23.PasskeyChallengeExpiredException) {
      return _i23.PasskeyChallengeExpiredException.fromJson(data) as T;
    }
    if (t == _i24.PasskeyChallengeNotFoundException) {
      return _i24.PasskeyChallengeNotFoundException.fromJson(data) as T;
    }
    if (t == _i25.PasskeyLoginRequest) {
      return _i25.PasskeyLoginRequest.fromJson(data) as T;
    }
    if (t == _i26.PasskeyPublicKeyNotFoundException) {
      return _i26.PasskeyPublicKeyNotFoundException.fromJson(data) as T;
    }
    if (t == _i27.PasskeyRegistrationRequest) {
      return _i27.PasskeyRegistrationRequest.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.SecretChallenge?>()) {
      return (data != null ? _i4.SecretChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.AppleAccount?>()) {
      return (data != null ? _i5.AppleAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.EmailAccountFailedLoginAttempt?>()) {
      return (data != null
          ? _i6.EmailAccountFailedLoginAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccountRequest?>()) {
      return (data != null ? _i7.EmailAccountRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i8.EmailAccountRequestCompletionAttempt?>()) {
      return (data != null
          ? _i8.EmailAccountRequestCompletionAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.EmailAccount?>()) {
      return (data != null ? _i9.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.EmailAccountLoginException?>()) {
      return (data != null
          ? _i10.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.EmailAccountLoginExceptionReason?>()) {
      return (data != null
          ? _i11.EmailAccountLoginExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.EmailAccountPasswordResetException?>()) {
      return (data != null
          ? _i12.EmailAccountPasswordResetException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
          ? _i13.EmailAccountPasswordResetExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i14.EmailAccountRequestException?>()) {
      return (data != null
          ? _i14.EmailAccountRequestException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.EmailAccountRequestExceptionReason?>()) {
      return (data != null
          ? _i15.EmailAccountRequestExceptionReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i16.EmailAccountPasswordResetCompleteAttempt?>()) {
      return (data != null
          ? _i16.EmailAccountPasswordResetCompleteAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i17.EmailAccountPasswordResetRequest?>()) {
      return (data != null
          ? _i17.EmailAccountPasswordResetRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i18.EmailAccountPasswordResetRequestAttempt?>()) {
      return (data != null
          ? _i18.EmailAccountPasswordResetRequestAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i19.GoogleAccount?>()) {
      return (data != null ? _i19.GoogleAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.GoogleIdTokenVerificationException?>()) {
      return (data != null
          ? _i20.GoogleIdTokenVerificationException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i21.PasskeyAccount?>()) {
      return (data != null ? _i21.PasskeyAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.PasskeyChallenge?>()) {
      return (data != null ? _i22.PasskeyChallenge.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.PasskeyChallengeExpiredException?>()) {
      return (data != null
          ? _i23.PasskeyChallengeExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i24.PasskeyChallengeNotFoundException?>()) {
      return (data != null
          ? _i24.PasskeyChallengeNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i25.PasskeyLoginRequest?>()) {
      return (data != null ? _i25.PasskeyLoginRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.PasskeyPublicKeyNotFoundException?>()) {
      return (data != null
          ? _i26.PasskeyPublicKeyNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i27.PasskeyRegistrationRequest?>()) {
      return (data != null
          ? _i27.PasskeyRegistrationRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<({_i28.ByteData challenge, _i1.UuidValue id})>()) {
      return (
        challenge: deserialize<_i28.ByteData>(
            ((data as Map)['n'] as Map)['challenge']),
        id: deserialize<_i1.UuidValue>(data['n']['id']),
      ) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
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
      case _i4.SecretChallenge():
        return 'SecretChallenge';
      case _i5.AppleAccount():
        return 'AppleAccount';
      case _i6.EmailAccountFailedLoginAttempt():
        return 'EmailAccountFailedLoginAttempt';
      case _i7.EmailAccountRequest():
        return 'EmailAccountRequest';
      case _i8.EmailAccountRequestCompletionAttempt():
        return 'EmailAccountRequestCompletionAttempt';
      case _i9.EmailAccount():
        return 'EmailAccount';
      case _i10.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i11.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i12.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _i13.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _i14.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _i15.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i16.EmailAccountPasswordResetCompleteAttempt():
        return 'EmailAccountPasswordResetCompleteAttempt';
      case _i17.EmailAccountPasswordResetRequest():
        return 'EmailAccountPasswordResetRequest';
      case _i18.EmailAccountPasswordResetRequestAttempt():
        return 'EmailAccountPasswordResetRequestAttempt';
      case _i19.GoogleAccount():
        return 'GoogleAccount';
      case _i20.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i21.PasskeyAccount():
        return 'PasskeyAccount';
      case _i22.PasskeyChallenge():
        return 'PasskeyChallenge';
      case _i23.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _i24.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _i25.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _i26.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _i27.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth_core.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'SecretChallenge') {
      return deserialize<_i4.SecretChallenge>(data['data']);
    }
    if (dataClassName == 'AppleAccount') {
      return deserialize<_i5.AppleAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountFailedLoginAttempt') {
      return deserialize<_i6.EmailAccountFailedLoginAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i7.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestCompletionAttempt') {
      return deserialize<_i8.EmailAccountRequestCompletionAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i9.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i10.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_i11.EmailAccountLoginExceptionReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i12.EmailAccountPasswordResetException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_i13.EmailAccountPasswordResetExceptionReason>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_i14.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_i15.EmailAccountRequestExceptionReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetCompleteAttempt') {
      return deserialize<_i16.EmailAccountPasswordResetCompleteAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i17.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestAttempt') {
      return deserialize<_i18.EmailAccountPasswordResetRequestAttempt>(
          data['data']);
    }
    if (dataClassName == 'GoogleAccount') {
      return deserialize<_i19.GoogleAccount>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i20.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName == 'PasskeyAccount') {
      return deserialize<_i21.PasskeyAccount>(data['data']);
    }
    if (dataClassName == 'PasskeyChallenge') {
      return deserialize<_i22.PasskeyChallenge>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_i23.PasskeyChallengeExpiredException>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_i24.PasskeyChallengeNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_i25.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_i26.PasskeyPublicKeyNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_i27.PasskeyRegistrationRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i3.Protocol().deserializeByClassName(data);
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
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i4.SecretChallenge:
        return _i4.SecretChallenge.t;
      case _i5.AppleAccount:
        return _i5.AppleAccount.t;
      case _i6.EmailAccountFailedLoginAttempt:
        return _i6.EmailAccountFailedLoginAttempt.t;
      case _i7.EmailAccountRequest:
        return _i7.EmailAccountRequest.t;
      case _i8.EmailAccountRequestCompletionAttempt:
        return _i8.EmailAccountRequestCompletionAttempt.t;
      case _i9.EmailAccount:
        return _i9.EmailAccount.t;
      case _i16.EmailAccountPasswordResetCompleteAttempt:
        return _i16.EmailAccountPasswordResetCompleteAttempt.t;
      case _i17.EmailAccountPasswordResetRequest:
        return _i17.EmailAccountPasswordResetRequest.t;
      case _i18.EmailAccountPasswordResetRequestAttempt:
        return _i18.EmailAccountPasswordResetRequestAttempt.t;
      case _i19.GoogleAccount:
        return _i19.GoogleAccount.t;
      case _i21.PasskeyAccount:
        return _i21.PasskeyAccount.t;
      case _i22.PasskeyChallenge:
        return _i22.PasskeyChallenge.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_idp';
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  if (record is ({_i28.ByteData challenge, _i1.UuidValue id})) {
    return {
      "n": {
        "challenge": record.challenge,
        "id": record.id,
      },
    };
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing
/// [Record]s or non-String-keyed [Map]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These
/// handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with
/// non-String keys) or a `Map<String, dynamic>` in case the input was
/// a `Map<String, …>`.
Object? mapContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapContainerToJson(iterable),
      Map map => mapContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          }
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
