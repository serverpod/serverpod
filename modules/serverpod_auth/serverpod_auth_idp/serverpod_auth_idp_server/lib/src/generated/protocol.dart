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
import 'common/rate_limited_request_attempt/models/rate_limited_request_attempt.dart'
    as _i4;
import 'common/secret_challenge/models/secret_challenge.dart' as _i5;
import 'providers/anonymous/models/anonymous_account.dart' as _i6;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart'
    as _i7;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart'
    as _i8;
import 'providers/apple/models/apple_account.dart' as _i9;
import 'providers/email/models/email_account.dart' as _i10;
import 'providers/email/models/email_account_password_reset_request.dart'
    as _i11;
import 'providers/email/models/email_account_request.dart' as _i12;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _i13;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _i14;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i15;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _i16;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _i17;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _i18;
import 'providers/facebook/models/facebook_access_token_verification_exception.dart'
    as _i19;
import 'providers/facebook/models/facebook_account.dart' as _i20;
import 'providers/firebase/models/firebase_account.dart' as _i21;
import 'providers/firebase/models/firebase_id_token_verification_exception.dart'
    as _i22;
import 'providers/github/models/github_access_token_verification_exception.dart'
    as _i23;
import 'providers/github/models/github_account.dart' as _i24;
import 'providers/google/models/google_account.dart' as _i25;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _i26;
import 'providers/microsoft/models/microsoft_access_token_verification_exception.dart'
    as _i27;
import 'providers/microsoft/models/microsoft_account.dart' as _i28;
import 'providers/passkey/models/passkey_account.dart' as _i29;
import 'providers/passkey/models/passkey_challenge.dart' as _i30;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _i31;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _i32;
import 'providers/passkey/models/passkey_login_request.dart' as _i33;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _i34;
import 'providers/passkey/models/passkey_registration_request.dart' as _i35;
import 'dart:typed_data' as _i36;
export 'common/rate_limited_request_attempt/models/rate_limited_request_attempt.dart';
export 'common/secret_challenge/models/secret_challenge.dart';
export 'providers/anonymous/models/anonymous_account.dart';
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart';
export 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart';
export 'providers/apple/models/apple_account.dart';
export 'providers/email/models/email_account.dart';
export 'providers/email/models/email_account_password_reset_request.dart';
export 'providers/email/models/email_account_request.dart';
export 'providers/email/models/exceptions/email_account_login_exception.dart';
export 'providers/email/models/exceptions/email_account_login_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception.dart';
export 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart';
export 'providers/email/models/exceptions/email_account_request_exception.dart';
export 'providers/email/models/exceptions/email_account_request_exception_reason.dart';
export 'providers/facebook/models/facebook_access_token_verification_exception.dart';
export 'providers/facebook/models/facebook_account.dart';
export 'providers/firebase/models/firebase_account.dart';
export 'providers/firebase/models/firebase_id_token_verification_exception.dart';
export 'providers/github/models/github_access_token_verification_exception.dart';
export 'providers/github/models/github_account.dart';
export 'providers/google/models/google_account.dart';
export 'providers/google/models/google_id_token_verification_exception.dart';
export 'providers/microsoft/models/microsoft_access_token_verification_exception.dart';
export 'providers/microsoft/models/microsoft_account.dart';
export 'providers/passkey/models/passkey_account.dart';
export 'providers/passkey/models/passkey_challenge.dart';
export 'providers/passkey/models/passkey_challenge_expired_exception.dart';
export 'providers/passkey/models/passkey_challenge_not_found_exception.dart';
export 'providers/passkey/models/passkey_login_request.dart';
export 'providers/passkey/models/passkey_public_key_not_found_exception.dart';
export 'providers/passkey/models/passkey_registration_request.dart';

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_idp_anonymous_account',
      dartName: 'AnonymousAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
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
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_anonymous_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
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
          columnDefault: 'random_v7',
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
          columnDefault: 'now',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_apple_account_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
          columnDefault: 'random_v7',
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
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
          columnDefault: 'random_v7',
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
          columnDefault: 'now',
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
      indexes: [],
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
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'createdAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
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
          indexName: 'serverpod_auth_idp_email_account_request_email',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
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
      name: 'serverpod_auth_idp_facebook_account',
      dartName: 'FacebookAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
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
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'fullName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          constraintName: 'serverpod_auth_idp_facebook_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_facebook_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
      name: 'serverpod_auth_idp_firebase_account',
      dartName: 'FirebaseAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
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
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
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
          constraintName: 'serverpod_auth_idp_firebase_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_firebase_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
      name: 'serverpod_auth_idp_github_account',
      dartName: 'GitHubAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'created',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_github_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_github_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
          columnDefault: 'random_v7',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_google_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
      name: 'serverpod_auth_idp_microsoft_account',
      dartName: 'MicrosoftAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'authUserId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'created',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_microsoft_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_microsoft_account_user_identifier',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'userIdentifier',
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
          columnDefault: 'random_v7',
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
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_idp_passkey_account_key_id_base64',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'keyIdBase64',
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
          columnDefault: 'random_v7',
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
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'serverpod_auth_idp_rate_limited_request_attempt',
      dartName: 'RateLimitedRequestAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'domain',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'source',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nonce',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'ipAddress',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'extraData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,String>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName:
              'serverpod_auth_idp_rate_limited_request_attempt_composite',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'domain',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'source',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'nonce',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'attemptedAt',
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
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'challengeCodeHash',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
  ];

  final Map<String, _i1.SerializationManager> _hostProtocols = {};

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i4.RateLimitedRequestAttempt] = (data, protocol) =>
        _i4.RateLimitedRequestAttempt.fromJson(data);
    map[_i5.SecretChallenge] = (data, protocol) =>
        _i5.SecretChallenge.fromJson(data);
    map[_i6.AnonymousAccount] = (data, protocol) =>
        _i6.AnonymousAccount.fromJson(data);
    map[_i7.AnonymousAccountBlockedException] = (data, protocol) =>
        _i7.AnonymousAccountBlockedException.fromJson(data);
    map[_i8.AnonymousAccountBlockedExceptionReason] = (data, protocol) =>
        _i8.AnonymousAccountBlockedExceptionReason.fromJson(data);
    map[_i9.AppleAccount] = (data, protocol) => _i9.AppleAccount.fromJson(data);
    map[_i10.EmailAccount] = (data, protocol) =>
        _i10.EmailAccount.fromJson(data);
    map[_i11.EmailAccountPasswordResetRequest] = (data, protocol) =>
        _i11.EmailAccountPasswordResetRequest.fromJson(data);
    map[_i12.EmailAccountRequest] = (data, protocol) =>
        _i12.EmailAccountRequest.fromJson(data);
    map[_i13.EmailAccountLoginException] = (data, protocol) =>
        _i13.EmailAccountLoginException.fromJson(data);
    map[_i14.EmailAccountLoginExceptionReason] = (data, protocol) =>
        _i14.EmailAccountLoginExceptionReason.fromJson(data);
    map[_i15.EmailAccountPasswordResetException] = (data, protocol) =>
        _i15.EmailAccountPasswordResetException.fromJson(data);
    map[_i16.EmailAccountPasswordResetExceptionReason] = (data, protocol) =>
        _i16.EmailAccountPasswordResetExceptionReason.fromJson(data);
    map[_i17.EmailAccountRequestException] = (data, protocol) =>
        _i17.EmailAccountRequestException.fromJson(data);
    map[_i18.EmailAccountRequestExceptionReason] = (data, protocol) =>
        _i18.EmailAccountRequestExceptionReason.fromJson(data);
    map[_i19.FacebookAccessTokenVerificationException] = (data, protocol) =>
        _i19.FacebookAccessTokenVerificationException.fromJson(data);
    map[_i20.FacebookAccount] = (data, protocol) =>
        _i20.FacebookAccount.fromJson(data);
    map[_i21.FirebaseAccount] = (data, protocol) =>
        _i21.FirebaseAccount.fromJson(data);
    map[_i22.FirebaseIdTokenVerificationException] = (data, protocol) =>
        _i22.FirebaseIdTokenVerificationException.fromJson(data);
    map[_i23.GitHubAccessTokenVerificationException] = (data, protocol) =>
        _i23.GitHubAccessTokenVerificationException.fromJson(data);
    map[_i24.GitHubAccount] = (data, protocol) =>
        _i24.GitHubAccount.fromJson(data);
    map[_i25.GoogleAccount] = (data, protocol) =>
        _i25.GoogleAccount.fromJson(data);
    map[_i26.GoogleIdTokenVerificationException] = (data, protocol) =>
        _i26.GoogleIdTokenVerificationException.fromJson(data);
    map[_i27.MicrosoftAccessTokenVerificationException] = (data, protocol) =>
        _i27.MicrosoftAccessTokenVerificationException.fromJson(data);
    map[_i28.MicrosoftAccount] = (data, protocol) =>
        _i28.MicrosoftAccount.fromJson(data);
    map[_i29.PasskeyAccount] = (data, protocol) =>
        _i29.PasskeyAccount.fromJson(data);
    map[_i30.PasskeyChallenge] = (data, protocol) =>
        _i30.PasskeyChallenge.fromJson(data);
    map[_i31.PasskeyChallengeExpiredException] = (data, protocol) =>
        _i31.PasskeyChallengeExpiredException.fromJson(data);
    map[_i32.PasskeyChallengeNotFoundException] = (data, protocol) =>
        _i32.PasskeyChallengeNotFoundException.fromJson(data);
    map[_i33.PasskeyLoginRequest] = (data, protocol) =>
        _i33.PasskeyLoginRequest.fromJson(data);
    map[_i34.PasskeyPublicKeyNotFoundException] = (data, protocol) =>
        _i34.PasskeyPublicKeyNotFoundException.fromJson(data);
    map[_i35.PasskeyRegistrationRequest] = (data, protocol) =>
        _i35.PasskeyRegistrationRequest.fromJson(data);
    map[_i1.getType<_i4.RateLimitedRequestAttempt?>()] = (data, protocol) =>
        (data != null ? _i4.RateLimitedRequestAttempt.fromJson(data) : null);
    map[_i1.getType<_i5.SecretChallenge?>()] = (data, protocol) =>
        (data != null ? _i5.SecretChallenge.fromJson(data) : null);
    map[_i1.getType<_i6.AnonymousAccount?>()] = (data, protocol) =>
        (data != null ? _i6.AnonymousAccount.fromJson(data) : null);
    map[_i1
        .getType<_i7.AnonymousAccountBlockedException?>()] = (data, protocol) =>
        (data != null
        ? _i7.AnonymousAccountBlockedException.fromJson(data)
        : null);
    map[_i1.getType<_i8.AnonymousAccountBlockedExceptionReason?>()] =
        (data, protocol) => (data != null
        ? _i8.AnonymousAccountBlockedExceptionReason.fromJson(data)
        : null);
    map[_i1.getType<_i9.AppleAccount?>()] = (data, protocol) =>
        (data != null ? _i9.AppleAccount.fromJson(data) : null);
    map[_i1.getType<_i10.EmailAccount?>()] = (data, protocol) =>
        (data != null ? _i10.EmailAccount.fromJson(data) : null);
    map[_i1.getType<_i11.EmailAccountPasswordResetRequest?>()] =
        (data, protocol) => (data != null
        ? _i11.EmailAccountPasswordResetRequest.fromJson(data)
        : null);
    map[_i1.getType<_i12.EmailAccountRequest?>()] = (data, protocol) =>
        (data != null ? _i12.EmailAccountRequest.fromJson(data) : null);
    map[_i1.getType<_i13.EmailAccountLoginException?>()] = (data, protocol) =>
        (data != null ? _i13.EmailAccountLoginException.fromJson(data) : null);
    map[_i1.getType<_i14.EmailAccountLoginExceptionReason?>()] =
        (data, protocol) => (data != null
        ? _i14.EmailAccountLoginExceptionReason.fromJson(data)
        : null);
    map[_i1.getType<_i15.EmailAccountPasswordResetException?>()] =
        (data, protocol) => (data != null
        ? _i15.EmailAccountPasswordResetException.fromJson(data)
        : null);
    map[_i1.getType<_i16.EmailAccountPasswordResetExceptionReason?>()] =
        (data, protocol) => (data != null
        ? _i16.EmailAccountPasswordResetExceptionReason.fromJson(data)
        : null);
    map[_i1.getType<_i17.EmailAccountRequestException?>()] = (data, protocol) =>
        (data != null
        ? _i17.EmailAccountRequestException.fromJson(data)
        : null);
    map[_i1.getType<_i18.EmailAccountRequestExceptionReason?>()] =
        (data, protocol) => (data != null
        ? _i18.EmailAccountRequestExceptionReason.fromJson(data)
        : null);
    map[_i1.getType<_i19.FacebookAccessTokenVerificationException?>()] =
        (data, protocol) => (data != null
        ? _i19.FacebookAccessTokenVerificationException.fromJson(data)
        : null);
    map[_i1.getType<_i20.FacebookAccount?>()] = (data, protocol) =>
        (data != null ? _i20.FacebookAccount.fromJson(data) : null);
    map[_i1.getType<_i21.FirebaseAccount?>()] = (data, protocol) =>
        (data != null ? _i21.FirebaseAccount.fromJson(data) : null);
    map[_i1.getType<_i22.FirebaseIdTokenVerificationException?>()] =
        (data, protocol) => (data != null
        ? _i22.FirebaseIdTokenVerificationException.fromJson(data)
        : null);
    map[_i1.getType<_i23.GitHubAccessTokenVerificationException?>()] =
        (data, protocol) => (data != null
        ? _i23.GitHubAccessTokenVerificationException.fromJson(data)
        : null);
    map[_i1.getType<_i24.GitHubAccount?>()] = (data, protocol) =>
        (data != null ? _i24.GitHubAccount.fromJson(data) : null);
    map[_i1.getType<_i25.GoogleAccount?>()] = (data, protocol) =>
        (data != null ? _i25.GoogleAccount.fromJson(data) : null);
    map[_i1.getType<_i26.GoogleIdTokenVerificationException?>()] =
        (data, protocol) => (data != null
        ? _i26.GoogleIdTokenVerificationException.fromJson(data)
        : null);
    map[_i1.getType<_i27.MicrosoftAccessTokenVerificationException?>()] =
        (data, protocol) => (data != null
        ? _i27.MicrosoftAccessTokenVerificationException.fromJson(data)
        : null);
    map[_i1.getType<_i28.MicrosoftAccount?>()] = (data, protocol) =>
        (data != null ? _i28.MicrosoftAccount.fromJson(data) : null);
    map[_i1.getType<_i29.PasskeyAccount?>()] = (data, protocol) =>
        (data != null ? _i29.PasskeyAccount.fromJson(data) : null);
    map[_i1.getType<_i30.PasskeyChallenge?>()] = (data, protocol) =>
        (data != null ? _i30.PasskeyChallenge.fromJson(data) : null);
    map[_i1.getType<_i31.PasskeyChallengeExpiredException?>()] =
        (data, protocol) => (data != null
        ? _i31.PasskeyChallengeExpiredException.fromJson(data)
        : null);
    map[_i1.getType<_i32.PasskeyChallengeNotFoundException?>()] =
        (data, protocol) => (data != null
        ? _i32.PasskeyChallengeNotFoundException.fromJson(data)
        : null);
    map[_i1.getType<_i33.PasskeyLoginRequest?>()] = (data, protocol) =>
        (data != null ? _i33.PasskeyLoginRequest.fromJson(data) : null);
    map[_i1.getType<_i34.PasskeyPublicKeyNotFoundException?>()] =
        (data, protocol) => (data != null
        ? _i34.PasskeyPublicKeyNotFoundException.fromJson(data)
        : null);
    map[_i1.getType<_i35.PasskeyRegistrationRequest?>()] = (data, protocol) =>
        (data != null ? _i35.PasskeyRegistrationRequest.fromJson(data) : null);
    map[Map<String, String>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String>(v),
      ),
    );
    map[_i1.getType<Map<String, String>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<String>(v),
            ),
          )
        : null);
    map[_i1.getType<({_i36.ByteData challenge, _i1.UuidValue id})>()] =
        (data, protocol) => (
          challenge: protocol.deserialize<_i36.ByteData>(
            ((data as Map)['n'] as Map)['challenge'],
          ),
          id: protocol.deserialize<_i1.UuidValue>(data['n']['id']),
        );
    return map;
  }

  void registerHostProtocol(
    String projectName,
    _i1.SerializationManager protocol,
  ) {
    _hostProtocols[projectName] = protocol;
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    if (className == null) return null;
    if (!className.startsWith('serverpod_auth_idp.')) return className;
    return className.substring(19);
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

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i4.RateLimitedRequestAttempt => 'RateLimitedRequestAttempt',
      _i5.SecretChallenge => 'SecretChallenge',
      _i6.AnonymousAccount => 'AnonymousAccount',
      _i7.AnonymousAccountBlockedException =>
        'AnonymousAccountBlockedException',
      _i8.AnonymousAccountBlockedExceptionReason =>
        'AnonymousAccountBlockedExceptionReason',
      _i9.AppleAccount => 'AppleAccount',
      _i10.EmailAccount => 'EmailAccount',
      _i11.EmailAccountPasswordResetRequest =>
        'EmailAccountPasswordResetRequest',
      _i12.EmailAccountRequest => 'EmailAccountRequest',
      _i13.EmailAccountLoginException => 'EmailAccountLoginException',
      _i14.EmailAccountLoginExceptionReason =>
        'EmailAccountLoginExceptionReason',
      _i15.EmailAccountPasswordResetException =>
        'EmailAccountPasswordResetException',
      _i16.EmailAccountPasswordResetExceptionReason =>
        'EmailAccountPasswordResetExceptionReason',
      _i17.EmailAccountRequestException => 'EmailAccountRequestException',
      _i18.EmailAccountRequestExceptionReason =>
        'EmailAccountRequestExceptionReason',
      _i19.FacebookAccessTokenVerificationException =>
        'FacebookAccessTokenVerificationException',
      _i20.FacebookAccount => 'FacebookAccount',
      _i21.FirebaseAccount => 'FirebaseAccount',
      _i22.FirebaseIdTokenVerificationException =>
        'FirebaseIdTokenVerificationException',
      _i23.GitHubAccessTokenVerificationException =>
        'GitHubAccessTokenVerificationException',
      _i24.GitHubAccount => 'GitHubAccount',
      _i25.GoogleAccount => 'GoogleAccount',
      _i26.GoogleIdTokenVerificationException =>
        'GoogleIdTokenVerificationException',
      _i27.MicrosoftAccessTokenVerificationException =>
        'MicrosoftAccessTokenVerificationException',
      _i28.MicrosoftAccount => 'MicrosoftAccount',
      _i29.PasskeyAccount => 'PasskeyAccount',
      _i30.PasskeyChallenge => 'PasskeyChallenge',
      _i31.PasskeyChallengeExpiredException =>
        'PasskeyChallengeExpiredException',
      _i32.PasskeyChallengeNotFoundException =>
        'PasskeyChallengeNotFoundException',
      _i33.PasskeyLoginRequest => 'PasskeyLoginRequest',
      _i34.PasskeyPublicKeyNotFoundException =>
        'PasskeyPublicKeyNotFoundException',
      _i35.PasskeyRegistrationRequest => 'PasskeyRegistrationRequest',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_auth_idp.',
        '',
      );
    }

    switch (data) {
      case _i4.RateLimitedRequestAttempt():
        return 'RateLimitedRequestAttempt';
      case _i5.SecretChallenge():
        return 'SecretChallenge';
      case _i6.AnonymousAccount():
        return 'AnonymousAccount';
      case _i7.AnonymousAccountBlockedException():
        return 'AnonymousAccountBlockedException';
      case _i8.AnonymousAccountBlockedExceptionReason():
        return 'AnonymousAccountBlockedExceptionReason';
      case _i9.AppleAccount():
        return 'AppleAccount';
      case _i10.EmailAccount():
        return 'EmailAccount';
      case _i11.EmailAccountPasswordResetRequest():
        return 'EmailAccountPasswordResetRequest';
      case _i12.EmailAccountRequest():
        return 'EmailAccountRequest';
      case _i13.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i14.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i15.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _i16.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _i17.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _i18.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i19.FacebookAccessTokenVerificationException():
        return 'FacebookAccessTokenVerificationException';
      case _i20.FacebookAccount():
        return 'FacebookAccount';
      case _i21.FirebaseAccount():
        return 'FirebaseAccount';
      case _i22.FirebaseIdTokenVerificationException():
        return 'FirebaseIdTokenVerificationException';
      case _i23.GitHubAccessTokenVerificationException():
        return 'GitHubAccessTokenVerificationException';
      case _i24.GitHubAccount():
        return 'GitHubAccount';
      case _i25.GoogleAccount():
        return 'GoogleAccount';
      case _i26.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i27.MicrosoftAccessTokenVerificationException():
        return 'MicrosoftAccessTokenVerificationException';
      case _i28.MicrosoftAccount():
        return 'MicrosoftAccount';
      case _i29.PasskeyAccount():
        return 'PasskeyAccount';
      case _i30.PasskeyChallenge():
        return 'PasskeyChallenge';
      case _i31.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _i32.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _i33.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _i34.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _i35.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'RateLimitedRequestAttempt') {
      return deserialize<_i4.RateLimitedRequestAttempt>(data['data']);
    }
    if (dataClassName == 'SecretChallenge') {
      return deserialize<_i5.SecretChallenge>(data['data']);
    }
    if (dataClassName == 'AnonymousAccount') {
      return deserialize<_i6.AnonymousAccount>(data['data']);
    }
    if (dataClassName == 'AnonymousAccountBlockedException') {
      return deserialize<_i7.AnonymousAccountBlockedException>(data['data']);
    }
    if (dataClassName == 'AnonymousAccountBlockedExceptionReason') {
      return deserialize<_i8.AnonymousAccountBlockedExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'AppleAccount') {
      return deserialize<_i9.AppleAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i10.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i11.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i12.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i13.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_i14.EmailAccountLoginExceptionReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i15.EmailAccountPasswordResetException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_i16.EmailAccountPasswordResetExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_i17.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_i18.EmailAccountRequestExceptionReason>(data['data']);
    }
    if (dataClassName == 'FacebookAccessTokenVerificationException') {
      return deserialize<_i19.FacebookAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'FacebookAccount') {
      return deserialize<_i20.FacebookAccount>(data['data']);
    }
    if (dataClassName == 'FirebaseAccount') {
      return deserialize<_i21.FirebaseAccount>(data['data']);
    }
    if (dataClassName == 'FirebaseIdTokenVerificationException') {
      return deserialize<_i22.FirebaseIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccessTokenVerificationException') {
      return deserialize<_i23.GitHubAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccount') {
      return deserialize<_i24.GitHubAccount>(data['data']);
    }
    if (dataClassName == 'GoogleAccount') {
      return deserialize<_i25.GoogleAccount>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_i26.GoogleIdTokenVerificationException>(data['data']);
    }
    if (dataClassName == 'MicrosoftAccessTokenVerificationException') {
      return deserialize<_i27.MicrosoftAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'MicrosoftAccount') {
      return deserialize<_i28.MicrosoftAccount>(data['data']);
    }
    if (dataClassName == 'PasskeyAccount') {
      return deserialize<_i29.PasskeyAccount>(data['data']);
    }
    if (dataClassName == 'PasskeyChallenge') {
      return deserialize<_i30.PasskeyChallenge>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_i31.PasskeyChallengeExpiredException>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_i32.PasskeyChallengeNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_i33.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_i34.PasskeyPublicKeyNotFoundException>(data['data']);
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_i35.PasskeyRegistrationRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  Object? dynamicFieldToJson(
    Object? object, {
    bool forProtocol = false,
  }) {
    if ((object is List || object is Set || object is Map) ||
        getClassNameForObject(object) != null) {
      return super.dynamicFieldToJson(object, forProtocol: forProtocol);
    }
    for (final MapEntry(key: host, value: protocol) in _hostProtocols.entries) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _i1.SerializationManager.toEncodableForProtocol(wrapped)
          : _i1.SerializationManager.toEncodable(wrapped);
    }
    return super.dynamicFieldToJson(object, forProtocol: forProtocol);
  }

  @override
  dynamic deserializeDynamicFieldValue(Object? value) {
    if (value == null) return null;
    if (value is! Map<String, dynamic> || value['className'] is! String) {
      throw FormatException(
        'Dynamic fields are encoded as a Map with className and data, but got '
        '${value.runtimeType} instead.',
      );
    }
    final className = value['className'] as String;
    for (final MapEntry(key: host, value: protocol) in _hostProtocols.entries) {
      final hostPrefix = '$host.';
      if (className.startsWith(hostPrefix)) {
        final strippedClassName = className.substring(hostPrefix.length);
        if (strippedClassName.contains('.')) {
          throw FormatException(
            'Dynamic field className must not use multiple prefixes: $className',
          );
        }
        final hostData = Map<String, dynamic>.from(value);
        hostData['className'] = strippedClassName;
        return protocol.deserializeByClassName(hostData);
      }
    }
    if (className.contains('.')) {
      for (final protocol in _hostProtocols.values) {
        try {
          return protocol.deserializeByClassName(value);
        } on FormatException catch (_) {}
      }
    }
    return deserializeByClassName(value);
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
      case _i4.RateLimitedRequestAttempt:
        return _i4.RateLimitedRequestAttempt.t;
      case _i5.SecretChallenge:
        return _i5.SecretChallenge.t;
      case _i6.AnonymousAccount:
        return _i6.AnonymousAccount.t;
      case _i9.AppleAccount:
        return _i9.AppleAccount.t;
      case _i10.EmailAccount:
        return _i10.EmailAccount.t;
      case _i11.EmailAccountPasswordResetRequest:
        return _i11.EmailAccountPasswordResetRequest.t;
      case _i12.EmailAccountRequest:
        return _i12.EmailAccountRequest.t;
      case _i20.FacebookAccount:
        return _i20.FacebookAccount.t;
      case _i21.FirebaseAccount:
        return _i21.FirebaseAccount.t;
      case _i24.GitHubAccount:
        return _i24.GitHubAccount.t;
      case _i25.GoogleAccount:
        return _i25.GoogleAccount.t;
      case _i28.MicrosoftAccount:
        return _i28.MicrosoftAccount.t;
      case _i29.PasskeyAccount:
        return _i29.PasskeyAccount.t;
      case _i30.PasskeyChallenge:
        return _i30.PasskeyChallenge.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_idp';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
    }
    if (record is ({_i36.ByteData challenge, _i1.UuidValue id})) {
      return {
        "n": {
          "challenge": record.challenge.toJson(),
          "id": record.id.toJson(),
        },
      };
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
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
            },
        ];

      case Iterable():
        return [
          for (var e in obj) mapIfNeeded(e),
        ];
    }

    return obj;
  }
}
