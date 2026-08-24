/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _iacs;
import 'common/rate_limited_request_attempt/models/rate_limited_request_attempt.dart'
    as _iddjx2hh;
import 'common/secret_challenge/models/secret_challenge.dart' as _ihjuvfpt;
import 'providers/anonymous/models/anonymous_account.dart' as _i5yjjpde;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception.dart'
    as _ite257iv;
import 'providers/anonymous/models/exceptions/anonymous_account_blocked_exception_reason.dart'
    as _ig3ph7nw;
import 'providers/apple/models/apple_account.dart' as _i9aj4p8a;
import 'providers/email/models/email_account.dart' as _i047o257;
import 'providers/email/models/email_account_password_reset_request.dart'
    as _iouphhkf;
import 'providers/email/models/email_account_request.dart' as _iaib0xb9;
import 'providers/email/models/exceptions/email_account_login_exception.dart'
    as _ij1yj4f1;
import 'providers/email/models/exceptions/email_account_login_exception_reason.dart'
    as _ihd5znj2;
import 'providers/email/models/exceptions/email_account_password_reset_exception.dart'
    as _i7yyr103;
import 'providers/email/models/exceptions/email_account_password_reset_exception_reason.dart'
    as _io8tbstn;
import 'providers/email/models/exceptions/email_account_request_exception.dart'
    as _iqtw285f;
import 'providers/email/models/exceptions/email_account_request_exception_reason.dart'
    as _isgeino8;
import 'providers/facebook/models/facebook_access_token_verification_exception.dart'
    as _i92zrjf0;
import 'providers/facebook/models/facebook_account.dart' as _ivl5gkpe;
import 'providers/firebase/models/firebase_account.dart' as _i923yrzc;
import 'providers/firebase/models/firebase_email_not_verified_exception.dart'
    as _imswdwet;
import 'providers/firebase/models/firebase_id_token_verification_exception.dart'
    as _i14hfyiz;
import 'providers/github/models/github_access_token_verification_exception.dart'
    as _i8u0zfwn;
import 'providers/github/models/github_account.dart' as _i3l39it4;
import 'providers/google/models/google_account.dart' as _inlwg89o;
import 'providers/google/models/google_id_token_verification_exception.dart'
    as _iyz9kvht;
import 'providers/microsoft/models/microsoft_access_token_verification_exception.dart'
    as _i0bj371b;
import 'providers/microsoft/models/microsoft_account.dart' as _i8aemsss;
import 'providers/passkey/models/passkey_account.dart' as _iha3dd74;
import 'providers/passkey/models/passkey_challenge.dart' as _ini0eg2j;
import 'providers/passkey/models/passkey_challenge_expired_exception.dart'
    as _ihzslz1a;
import 'providers/passkey/models/passkey_challenge_not_found_exception.dart'
    as _ihzssrx9;
import 'providers/passkey/models/passkey_login_request.dart' as _itcmwg9u;
import 'providers/passkey/models/passkey_public_key_not_found_exception.dart'
    as _isvo2sb5;
import 'providers/passkey/models/passkey_registration_request.dart'
    as _izjoggd8;
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
export 'providers/firebase/models/firebase_email_not_verified_exception.dart';
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  final Set<_is.SerializationManager> _hostProtocols = {};

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_anonymous_account',
      dartName: 'AnonymousAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_anonymous_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_apple_account',
      dartName: 'AppleAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'refreshToken',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'refreshTokenRequestedWithBundleIdentifier',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'lastRefreshedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'isEmailVerified',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'isPrivateEmail',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'firstName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lastName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_apple_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_apple_account_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_email_account',
      dartName: 'EmailAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'passwordHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_email',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_email_account_password_reset_request',
      dartName: 'EmailAccountPasswordResetRequest',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'emailAccountId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'challengeId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'setPasswordChallengeId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_0',
          columns: ['emailAccountId'],
          referenceTable: 'serverpod_auth_idp_email_account',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_1',
          columns: ['challengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_idp_email_account_password_reset_request_fk_2',
          columns: ['setPasswordChallengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_email_account_request',
      dartName: 'EmailAccountRequest',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'challengeId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createAccountChallengeId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_request_fk_0',
          columns: ['challengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_email_account_request_fk_1',
          columns: ['createAccountChallengeId'],
          referenceTable: 'serverpod_auth_idp_secret_challenge',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_idp_email_account_request_email',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_facebook_account',
      dartName: 'FacebookAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'fullName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'firstName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'lastName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_facebook_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_facebook_account_user_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_firebase_account',
      dartName: 'FirebaseAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'created',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_firebase_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_firebase_account_user_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_github_account',
      dartName: 'GitHubAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'created',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_github_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_github_account_user_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_google_account',
      dartName: 'GoogleAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'created',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_google_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_google_account_user_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_microsoft_account',
      dartName: 'MicrosoftAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'userIdentifier',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'created',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_microsoft_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_microsoft_account_user_identifier',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_passkey_account',
      dartName: 'PasskeyAccount',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'authUserId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'keyId',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _isp.ColumnDefinition(
          name: 'keyIdBase64',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'clientDataJSON',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _isp.ColumnDefinition(
          name: 'attestationObject',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
        _isp.ColumnDefinition(
          name: 'originalChallenge',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'serverpod_auth_idp_passkey_account_fk_0',
          columns: ['authUserId'],
          referenceTable: 'serverpod_auth_core_user',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'serverpod_auth_idp_passkey_account_key_id_base64',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_passkey_challenge',
      dartName: 'PasskeyChallenge',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'challenge',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_rate_limited_request_attempt',
      dartName: 'RateLimitedRequestAttempt',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'domain',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'source',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nonce',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'ipAddress',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'attemptedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'extraData',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,String>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName:
              'serverpod_auth_idp_rate_limited_request_attempt_composite',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'domain',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'source',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'nonce',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'serverpod_auth_idp_secret_challenge',
      dartName: 'SecretChallenge',
      schema: 'public',
      module: 'serverpod_auth_idp',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'challengeCodeHash',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._iacs.Protocol.targetTableDefinitions,
  ];

  void registerHostProtocol(
    String projectName,
    _is.SerializationManager protocol,
  ) {
    _hostProtocols.add(protocol);
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

    if (t == _iddjx2hh.RateLimitedRequestAttempt) {
      return _iddjx2hh.RateLimitedRequestAttempt.fromJson(data) as T;
    }
    if (t == _ihjuvfpt.SecretChallenge) {
      return _ihjuvfpt.SecretChallenge.fromJson(data) as T;
    }
    if (t == _i5yjjpde.AnonymousAccount) {
      return _i5yjjpde.AnonymousAccount.fromJson(data) as T;
    }
    if (t == _ite257iv.AnonymousAccountBlockedException) {
      return _ite257iv.AnonymousAccountBlockedException.fromJson(data) as T;
    }
    if (t == _ig3ph7nw.AnonymousAccountBlockedExceptionReason) {
      return _ig3ph7nw.AnonymousAccountBlockedExceptionReason.fromJson(data)
          as T;
    }
    if (t == _i9aj4p8a.AppleAccount) {
      return _i9aj4p8a.AppleAccount.fromJson(data) as T;
    }
    if (t == _i047o257.EmailAccount) {
      return _i047o257.EmailAccount.fromJson(data) as T;
    }
    if (t == _iouphhkf.EmailAccountPasswordResetRequest) {
      return _iouphhkf.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _iaib0xb9.EmailAccountRequest) {
      return _iaib0xb9.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _ij1yj4f1.EmailAccountLoginException) {
      return _ij1yj4f1.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _ihd5znj2.EmailAccountLoginExceptionReason) {
      return _ihd5znj2.EmailAccountLoginExceptionReason.fromJson(data) as T;
    }
    if (t == _i7yyr103.EmailAccountPasswordResetException) {
      return _i7yyr103.EmailAccountPasswordResetException.fromJson(data) as T;
    }
    if (t == _io8tbstn.EmailAccountPasswordResetExceptionReason) {
      return _io8tbstn.EmailAccountPasswordResetExceptionReason.fromJson(data)
          as T;
    }
    if (t == _iqtw285f.EmailAccountRequestException) {
      return _iqtw285f.EmailAccountRequestException.fromJson(data) as T;
    }
    if (t == _isgeino8.EmailAccountRequestExceptionReason) {
      return _isgeino8.EmailAccountRequestExceptionReason.fromJson(data) as T;
    }
    if (t == _i92zrjf0.FacebookAccessTokenVerificationException) {
      return _i92zrjf0.FacebookAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _ivl5gkpe.FacebookAccount) {
      return _ivl5gkpe.FacebookAccount.fromJson(data) as T;
    }
    if (t == _i923yrzc.FirebaseAccount) {
      return _i923yrzc.FirebaseAccount.fromJson(data) as T;
    }
    if (t == _imswdwet.FirebaseEmailNotVerifiedException) {
      return _imswdwet.FirebaseEmailNotVerifiedException.fromJson(data) as T;
    }
    if (t == _i14hfyiz.FirebaseIdTokenVerificationException) {
      return _i14hfyiz.FirebaseIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i8u0zfwn.GitHubAccessTokenVerificationException) {
      return _i8u0zfwn.GitHubAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _i3l39it4.GitHubAccount) {
      return _i3l39it4.GitHubAccount.fromJson(data) as T;
    }
    if (t == _inlwg89o.GoogleAccount) {
      return _inlwg89o.GoogleAccount.fromJson(data) as T;
    }
    if (t == _iyz9kvht.GoogleIdTokenVerificationException) {
      return _iyz9kvht.GoogleIdTokenVerificationException.fromJson(data) as T;
    }
    if (t == _i0bj371b.MicrosoftAccessTokenVerificationException) {
      return _i0bj371b.MicrosoftAccessTokenVerificationException.fromJson(data)
          as T;
    }
    if (t == _i8aemsss.MicrosoftAccount) {
      return _i8aemsss.MicrosoftAccount.fromJson(data) as T;
    }
    if (t == _iha3dd74.PasskeyAccount) {
      return _iha3dd74.PasskeyAccount.fromJson(data) as T;
    }
    if (t == _ini0eg2j.PasskeyChallenge) {
      return _ini0eg2j.PasskeyChallenge.fromJson(data) as T;
    }
    if (t == _ihzslz1a.PasskeyChallengeExpiredException) {
      return _ihzslz1a.PasskeyChallengeExpiredException.fromJson(data) as T;
    }
    if (t == _ihzssrx9.PasskeyChallengeNotFoundException) {
      return _ihzssrx9.PasskeyChallengeNotFoundException.fromJson(data) as T;
    }
    if (t == _itcmwg9u.PasskeyLoginRequest) {
      return _itcmwg9u.PasskeyLoginRequest.fromJson(data) as T;
    }
    if (t == _isvo2sb5.PasskeyPublicKeyNotFoundException) {
      return _isvo2sb5.PasskeyPublicKeyNotFoundException.fromJson(data) as T;
    }
    if (t == _izjoggd8.PasskeyRegistrationRequest) {
      return _izjoggd8.PasskeyRegistrationRequest.fromJson(data) as T;
    }
    if (t == _is.getType<_iddjx2hh.RateLimitedRequestAttempt?>()) {
      return (data != null
              ? _iddjx2hh.RateLimitedRequestAttempt.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihjuvfpt.SecretChallenge?>()) {
      return (data != null ? _ihjuvfpt.SecretChallenge.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5yjjpde.AnonymousAccount?>()) {
      return (data != null ? _i5yjjpde.AnonymousAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ite257iv.AnonymousAccountBlockedException?>()) {
      return (data != null
              ? _ite257iv.AnonymousAccountBlockedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ig3ph7nw.AnonymousAccountBlockedExceptionReason?>()) {
      return (data != null
              ? _ig3ph7nw.AnonymousAccountBlockedExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9aj4p8a.AppleAccount?>()) {
      return (data != null ? _i9aj4p8a.AppleAccount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i047o257.EmailAccount?>()) {
      return (data != null ? _i047o257.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iouphhkf.EmailAccountPasswordResetRequest?>()) {
      return (data != null
              ? _iouphhkf.EmailAccountPasswordResetRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iaib0xb9.EmailAccountRequest?>()) {
      return (data != null
              ? _iaib0xb9.EmailAccountRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij1yj4f1.EmailAccountLoginException?>()) {
      return (data != null
              ? _ij1yj4f1.EmailAccountLoginException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihd5znj2.EmailAccountLoginExceptionReason?>()) {
      return (data != null
              ? _ihd5znj2.EmailAccountLoginExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7yyr103.EmailAccountPasswordResetException?>()) {
      return (data != null
              ? _i7yyr103.EmailAccountPasswordResetException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_io8tbstn.EmailAccountPasswordResetExceptionReason?>()) {
      return (data != null
              ? _io8tbstn.EmailAccountPasswordResetExceptionReason.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_iqtw285f.EmailAccountRequestException?>()) {
      return (data != null
              ? _iqtw285f.EmailAccountRequestException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isgeino8.EmailAccountRequestExceptionReason?>()) {
      return (data != null
              ? _isgeino8.EmailAccountRequestExceptionReason.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_i92zrjf0.FacebookAccessTokenVerificationException?>()) {
      return (data != null
              ? _i92zrjf0.FacebookAccessTokenVerificationException.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_ivl5gkpe.FacebookAccount?>()) {
      return (data != null ? _ivl5gkpe.FacebookAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i923yrzc.FirebaseAccount?>()) {
      return (data != null ? _i923yrzc.FirebaseAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imswdwet.FirebaseEmailNotVerifiedException?>()) {
      return (data != null
              ? _imswdwet.FirebaseEmailNotVerifiedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i14hfyiz.FirebaseIdTokenVerificationException?>()) {
      return (data != null
              ? _i14hfyiz.FirebaseIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i8u0zfwn.GitHubAccessTokenVerificationException?>()) {
      return (data != null
              ? _i8u0zfwn.GitHubAccessTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3l39it4.GitHubAccount?>()) {
      return (data != null ? _i3l39it4.GitHubAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_inlwg89o.GoogleAccount?>()) {
      return (data != null ? _inlwg89o.GoogleAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iyz9kvht.GoogleIdTokenVerificationException?>()) {
      return (data != null
              ? _iyz9kvht.GoogleIdTokenVerificationException.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_i0bj371b.MicrosoftAccessTokenVerificationException?>()) {
      return (data != null
              ? _i0bj371b.MicrosoftAccessTokenVerificationException.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_i8aemsss.MicrosoftAccount?>()) {
      return (data != null ? _i8aemsss.MicrosoftAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iha3dd74.PasskeyAccount?>()) {
      return (data != null ? _iha3dd74.PasskeyAccount.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ini0eg2j.PasskeyChallenge?>()) {
      return (data != null ? _ini0eg2j.PasskeyChallenge.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihzslz1a.PasskeyChallengeExpiredException?>()) {
      return (data != null
              ? _ihzslz1a.PasskeyChallengeExpiredException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihzssrx9.PasskeyChallengeNotFoundException?>()) {
      return (data != null
              ? _ihzssrx9.PasskeyChallengeNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_itcmwg9u.PasskeyLoginRequest?>()) {
      return (data != null
              ? _itcmwg9u.PasskeyLoginRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isvo2sb5.PasskeyPublicKeyNotFoundException?>()) {
      return (data != null
              ? _isvo2sb5.PasskeyPublicKeyNotFoundException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izjoggd8.PasskeyRegistrationRequest?>()) {
      return (data != null
              ? _izjoggd8.PasskeyRegistrationRequest.fromJson(data)
              : null)
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _is.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == _is.getType<({_idt.ByteData challenge, _is.UuidValue id})>()) {
      return (
            challenge: deserialize<_idt.ByteData>(
              ((data as Map)['n'] as Map)['challenge'],
            ),
            id: deserialize<_is.UuidValue>(data['n']['id']),
          )
          as T;
    }
    try {
      return _iacs.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _iddjx2hh.RateLimitedRequestAttempt => 'RateLimitedRequestAttempt',
      _ihjuvfpt.SecretChallenge => 'SecretChallenge',
      _i5yjjpde.AnonymousAccount => 'AnonymousAccount',
      _ite257iv.AnonymousAccountBlockedException =>
        'AnonymousAccountBlockedException',
      _ig3ph7nw.AnonymousAccountBlockedExceptionReason =>
        'AnonymousAccountBlockedExceptionReason',
      _i9aj4p8a.AppleAccount => 'AppleAccount',
      _i047o257.EmailAccount => 'EmailAccount',
      _iouphhkf.EmailAccountPasswordResetRequest =>
        'EmailAccountPasswordResetRequest',
      _iaib0xb9.EmailAccountRequest => 'EmailAccountRequest',
      _ij1yj4f1.EmailAccountLoginException => 'EmailAccountLoginException',
      _ihd5znj2.EmailAccountLoginExceptionReason =>
        'EmailAccountLoginExceptionReason',
      _i7yyr103.EmailAccountPasswordResetException =>
        'EmailAccountPasswordResetException',
      _io8tbstn.EmailAccountPasswordResetExceptionReason =>
        'EmailAccountPasswordResetExceptionReason',
      _iqtw285f.EmailAccountRequestException => 'EmailAccountRequestException',
      _isgeino8.EmailAccountRequestExceptionReason =>
        'EmailAccountRequestExceptionReason',
      _i92zrjf0.FacebookAccessTokenVerificationException =>
        'FacebookAccessTokenVerificationException',
      _ivl5gkpe.FacebookAccount => 'FacebookAccount',
      _i923yrzc.FirebaseAccount => 'FirebaseAccount',
      _imswdwet.FirebaseEmailNotVerifiedException =>
        'FirebaseEmailNotVerifiedException',
      _i14hfyiz.FirebaseIdTokenVerificationException =>
        'FirebaseIdTokenVerificationException',
      _i8u0zfwn.GitHubAccessTokenVerificationException =>
        'GitHubAccessTokenVerificationException',
      _i3l39it4.GitHubAccount => 'GitHubAccount',
      _inlwg89o.GoogleAccount => 'GoogleAccount',
      _iyz9kvht.GoogleIdTokenVerificationException =>
        'GoogleIdTokenVerificationException',
      _i0bj371b.MicrosoftAccessTokenVerificationException =>
        'MicrosoftAccessTokenVerificationException',
      _i8aemsss.MicrosoftAccount => 'MicrosoftAccount',
      _iha3dd74.PasskeyAccount => 'PasskeyAccount',
      _ini0eg2j.PasskeyChallenge => 'PasskeyChallenge',
      _ihzslz1a.PasskeyChallengeExpiredException =>
        'PasskeyChallengeExpiredException',
      _ihzssrx9.PasskeyChallengeNotFoundException =>
        'PasskeyChallengeNotFoundException',
      _itcmwg9u.PasskeyLoginRequest => 'PasskeyLoginRequest',
      _isvo2sb5.PasskeyPublicKeyNotFoundException =>
        'PasskeyPublicKeyNotFoundException',
      _izjoggd8.PasskeyRegistrationRequest => 'PasskeyRegistrationRequest',
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
      case _iddjx2hh.RateLimitedRequestAttempt():
        return 'RateLimitedRequestAttempt';
      case _ihjuvfpt.SecretChallenge():
        return 'SecretChallenge';
      case _i5yjjpde.AnonymousAccount():
        return 'AnonymousAccount';
      case _ite257iv.AnonymousAccountBlockedException():
        return 'AnonymousAccountBlockedException';
      case _ig3ph7nw.AnonymousAccountBlockedExceptionReason():
        return 'AnonymousAccountBlockedExceptionReason';
      case _i9aj4p8a.AppleAccount():
        return 'AppleAccount';
      case _i047o257.EmailAccount():
        return 'EmailAccount';
      case _iouphhkf.EmailAccountPasswordResetRequest():
        return 'EmailAccountPasswordResetRequest';
      case _iaib0xb9.EmailAccountRequest():
        return 'EmailAccountRequest';
      case _ij1yj4f1.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _ihd5znj2.EmailAccountLoginExceptionReason():
        return 'EmailAccountLoginExceptionReason';
      case _i7yyr103.EmailAccountPasswordResetException():
        return 'EmailAccountPasswordResetException';
      case _io8tbstn.EmailAccountPasswordResetExceptionReason():
        return 'EmailAccountPasswordResetExceptionReason';
      case _iqtw285f.EmailAccountRequestException():
        return 'EmailAccountRequestException';
      case _isgeino8.EmailAccountRequestExceptionReason():
        return 'EmailAccountRequestExceptionReason';
      case _i92zrjf0.FacebookAccessTokenVerificationException():
        return 'FacebookAccessTokenVerificationException';
      case _ivl5gkpe.FacebookAccount():
        return 'FacebookAccount';
      case _i923yrzc.FirebaseAccount():
        return 'FirebaseAccount';
      case _imswdwet.FirebaseEmailNotVerifiedException():
        return 'FirebaseEmailNotVerifiedException';
      case _i14hfyiz.FirebaseIdTokenVerificationException():
        return 'FirebaseIdTokenVerificationException';
      case _i8u0zfwn.GitHubAccessTokenVerificationException():
        return 'GitHubAccessTokenVerificationException';
      case _i3l39it4.GitHubAccount():
        return 'GitHubAccount';
      case _inlwg89o.GoogleAccount():
        return 'GoogleAccount';
      case _iyz9kvht.GoogleIdTokenVerificationException():
        return 'GoogleIdTokenVerificationException';
      case _i0bj371b.MicrosoftAccessTokenVerificationException():
        return 'MicrosoftAccessTokenVerificationException';
      case _i8aemsss.MicrosoftAccount():
        return 'MicrosoftAccount';
      case _iha3dd74.PasskeyAccount():
        return 'PasskeyAccount';
      case _ini0eg2j.PasskeyChallenge():
        return 'PasskeyChallenge';
      case _ihzslz1a.PasskeyChallengeExpiredException():
        return 'PasskeyChallengeExpiredException';
      case _ihzssrx9.PasskeyChallengeNotFoundException():
        return 'PasskeyChallengeNotFoundException';
      case _itcmwg9u.PasskeyLoginRequest():
        return 'PasskeyLoginRequest';
      case _isvo2sb5.PasskeyPublicKeyNotFoundException():
        return 'PasskeyPublicKeyNotFoundException';
      case _izjoggd8.PasskeyRegistrationRequest():
        return 'PasskeyRegistrationRequest';
    }
    className = _isp.Protocol().getClassNameForObject(data);
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
      return deserialize<_iddjx2hh.RateLimitedRequestAttempt>(data['data']);
    }
    if (dataClassName == 'SecretChallenge') {
      return deserialize<_ihjuvfpt.SecretChallenge>(data['data']);
    }
    if (dataClassName == 'AnonymousAccount') {
      return deserialize<_i5yjjpde.AnonymousAccount>(data['data']);
    }
    if (dataClassName == 'AnonymousAccountBlockedException') {
      return deserialize<_ite257iv.AnonymousAccountBlockedException>(
        data['data'],
      );
    }
    if (dataClassName == 'AnonymousAccountBlockedExceptionReason') {
      return deserialize<_ig3ph7nw.AnonymousAccountBlockedExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'AppleAccount') {
      return deserialize<_i9aj4p8a.AppleAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i047o257.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_iouphhkf.EmailAccountPasswordResetRequest>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_iaib0xb9.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_ij1yj4f1.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginExceptionReason') {
      return deserialize<_ihd5znj2.EmailAccountLoginExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountPasswordResetException') {
      return deserialize<_i7yyr103.EmailAccountPasswordResetException>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountPasswordResetExceptionReason') {
      return deserialize<_io8tbstn.EmailAccountPasswordResetExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'EmailAccountRequestException') {
      return deserialize<_iqtw285f.EmailAccountRequestException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExceptionReason') {
      return deserialize<_isgeino8.EmailAccountRequestExceptionReason>(
        data['data'],
      );
    }
    if (dataClassName == 'FacebookAccessTokenVerificationException') {
      return deserialize<_i92zrjf0.FacebookAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'FacebookAccount') {
      return deserialize<_ivl5gkpe.FacebookAccount>(data['data']);
    }
    if (dataClassName == 'FirebaseAccount') {
      return deserialize<_i923yrzc.FirebaseAccount>(data['data']);
    }
    if (dataClassName == 'FirebaseEmailNotVerifiedException') {
      return deserialize<_imswdwet.FirebaseEmailNotVerifiedException>(
        data['data'],
      );
    }
    if (dataClassName == 'FirebaseIdTokenVerificationException') {
      return deserialize<_i14hfyiz.FirebaseIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccessTokenVerificationException') {
      return deserialize<_i8u0zfwn.GitHubAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'GitHubAccount') {
      return deserialize<_i3l39it4.GitHubAccount>(data['data']);
    }
    if (dataClassName == 'GoogleAccount') {
      return deserialize<_inlwg89o.GoogleAccount>(data['data']);
    }
    if (dataClassName == 'GoogleIdTokenVerificationException') {
      return deserialize<_iyz9kvht.GoogleIdTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'MicrosoftAccessTokenVerificationException') {
      return deserialize<_i0bj371b.MicrosoftAccessTokenVerificationException>(
        data['data'],
      );
    }
    if (dataClassName == 'MicrosoftAccount') {
      return deserialize<_i8aemsss.MicrosoftAccount>(data['data']);
    }
    if (dataClassName == 'PasskeyAccount') {
      return deserialize<_iha3dd74.PasskeyAccount>(data['data']);
    }
    if (dataClassName == 'PasskeyChallenge') {
      return deserialize<_ini0eg2j.PasskeyChallenge>(data['data']);
    }
    if (dataClassName == 'PasskeyChallengeExpiredException') {
      return deserialize<_ihzslz1a.PasskeyChallengeExpiredException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyChallengeNotFoundException') {
      return deserialize<_ihzssrx9.PasskeyChallengeNotFoundException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyLoginRequest') {
      return deserialize<_itcmwg9u.PasskeyLoginRequest>(data['data']);
    }
    if (dataClassName == 'PasskeyPublicKeyNotFoundException') {
      return deserialize<_isvo2sb5.PasskeyPublicKeyNotFoundException>(
        data['data'],
      );
    }
    if (dataClassName == 'PasskeyRegistrationRequest') {
      return deserialize<_izjoggd8.PasskeyRegistrationRequest>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
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
    for (final protocol in _hostProtocols) {
      final className = protocol.getClassNameForObject(object);
      if (className == null) continue;
      final host = protocol.getModuleName();
      final wrapped = {
        'className': className.contains('.') ? className : '$host.$className',
        'data': object,
      };
      return forProtocol
          ? _is.SerializationManager.toEncodableForProtocol(wrapped)
          : _is.SerializationManager.toEncodable(wrapped);
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
    for (final protocol in _hostProtocols) {
      final host = protocol.getModuleName();
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
      for (final protocol in _hostProtocols) {
        try {
          return protocol.deserializeByClassName(value);
        } on FormatException catch (_) {}
      }
    }
    return deserializeByClassName(value);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _iacs.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _iddjx2hh.RateLimitedRequestAttempt:
        return _iddjx2hh.RateLimitedRequestAttempt.t;
      case _ihjuvfpt.SecretChallenge:
        return _ihjuvfpt.SecretChallenge.t;
      case _i5yjjpde.AnonymousAccount:
        return _i5yjjpde.AnonymousAccount.t;
      case _i9aj4p8a.AppleAccount:
        return _i9aj4p8a.AppleAccount.t;
      case _i047o257.EmailAccount:
        return _i047o257.EmailAccount.t;
      case _iouphhkf.EmailAccountPasswordResetRequest:
        return _iouphhkf.EmailAccountPasswordResetRequest.t;
      case _iaib0xb9.EmailAccountRequest:
        return _iaib0xb9.EmailAccountRequest.t;
      case _ivl5gkpe.FacebookAccount:
        return _ivl5gkpe.FacebookAccount.t;
      case _i923yrzc.FirebaseAccount:
        return _i923yrzc.FirebaseAccount.t;
      case _i3l39it4.GitHubAccount:
        return _i3l39it4.GitHubAccount.t;
      case _inlwg89o.GoogleAccount:
        return _inlwg89o.GoogleAccount.t;
      case _i8aemsss.MicrosoftAccount:
        return _i8aemsss.MicrosoftAccount.t;
      case _iha3dd74.PasskeyAccount:
        return _iha3dd74.PasskeyAccount.t;
      case _ini0eg2j.PasskeyChallenge:
        return _ini0eg2j.PasskeyChallenge.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
    if (record is ({_idt.ByteData challenge, _is.UuidValue id})) {
      return {
        "n": {
          "challenge": record.challenge.toJson(),
          "id": record.id.toJson(),
        },
      };
    }
    try {
      return _iacs.Protocol().mapRecordToJson(record);
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
