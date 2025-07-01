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
import 'package:serverpod_auth_user_server/serverpod_auth_user_server.dart'
    as _i3;
import 'email_account.dart' as _i4;
import 'email_account_failed_login_attempt.dart' as _i5;
import 'email_account_password_reset_attempt.dart' as _i6;
import 'email_account_password_reset_request.dart' as _i7;
import 'email_account_password_reset_request_attempt.dart' as _i8;
import 'email_account_request.dart' as _i9;
import 'email_account_request_completion_attempt.dart' as _i10;
import 'exceptions/email_account_login_exception.dart' as _i11;
import 'exceptions/email_account_login_failure_reason.dart' as _i12;
import 'exceptions/email_account_password_policy_violation_exception.dart'
    as _i13;
import 'exceptions/email_account_password_reset_request_expired_exception.dart'
    as _i14;
import 'exceptions/email_account_password_reset_request_not_found_exception.dart'
    as _i15;
import 'exceptions/email_account_password_reset_request_too_many_attempts_exception.dart'
    as _i16;
import 'exceptions/email_account_password_reset_request_unauthorized_exception.dart'
    as _i17;
import 'exceptions/email_account_password_reset_too_many_attempts_exception.dart'
    as _i18;
import 'exceptions/email_account_request_expired_exception.dart' as _i19;
import 'exceptions/email_account_request_not_found_exception.dart' as _i20;
import 'exceptions/email_account_request_not_verified_exception.dart' as _i21;
import 'exceptions/email_account_request_too_many_attempts_exception.dart'
    as _i22;
import 'exceptions/email_account_request_unauthorized_exception.dart' as _i23;
export 'email_account.dart';
export 'email_account_failed_login_attempt.dart';
export 'email_account_password_reset_attempt.dart';
export 'email_account_password_reset_request.dart';
export 'email_account_password_reset_request_attempt.dart';
export 'email_account_request.dart';
export 'email_account_request_completion_attempt.dart';
export 'exceptions/email_account_login_exception.dart';
export 'exceptions/email_account_login_failure_reason.dart';
export 'exceptions/email_account_password_policy_violation_exception.dart';
export 'exceptions/email_account_password_reset_request_expired_exception.dart';
export 'exceptions/email_account_password_reset_request_not_found_exception.dart';
export 'exceptions/email_account_password_reset_request_too_many_attempts_exception.dart';
export 'exceptions/email_account_password_reset_request_unauthorized_exception.dart';
export 'exceptions/email_account_password_reset_too_many_attempts_exception.dart';
export 'exceptions/email_account_request_expired_exception.dart';
export 'exceptions/email_account_request_not_found_exception.dart';
export 'exceptions/email_account_request_not_verified_exception.dart';
export 'exceptions/email_account_request_too_many_attempts_exception.dart';
export 'exceptions/email_account_request_unauthorized_exception.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'serverpod_auth_email_account',
      dartName: 'EmailAccount',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
          constraintName: 'serverpod_auth_email_account_fk_0',
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
          indexName: 'serverpod_auth_email_account_pkey',
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
          indexName: 'serverpod_auth_email_account_email',
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
      name: 'serverpod_auth_email_account_failed_login_attempt',
      dartName: 'EmailAccountFailedLoginAttempt',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
          indexName: 'serverpod_auth_email_account_failed_login_attempt_pkey',
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
          indexName: 'serverpod_auth_email_account_failed_login_attempt_email',
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
          indexName:
              'serverpod_auth_email_account_failed_login_attempt_attempted_at',
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
      name: 'serverpod_auth_email_account_password_reset_attempt',
      dartName: 'EmailAccountPasswordResetAttempt',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
              'serverpod_auth_email_account_password_reset_attempt_fk_0',
          columns: ['passwordResetRequestId'],
          referenceTable: 'serverpod_auth_email_account_password_reset_request',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_email_account_password_reset_attempt_pkey',
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
          indexName: 'serverpod_auth_email_account_password_reset_attempt_ip',
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
          indexName: 'serverpod_auth_email_account_password_reset_attempt_at',
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
      name: 'serverpod_auth_email_account_password_reset_request',
      dartName: 'EmailAccountPasswordResetRequest',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
          name: 'created',
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
              'serverpod_auth_email_account_password_reset_request_fk_0',
          columns: ['emailAccountId'],
          referenceTable: 'serverpod_auth_email_account',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'serverpod_auth_email_account_password_reset_request_pkey',
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
      name: 'serverpod_auth_email_account_pw_reset_request_attempt',
      dartName: 'EmailAccountPasswordResetRequestAttempt',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
              'serverpod_auth_email_account_pw_reset_request_attempt_pkey',
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
          indexName:
              'serverpod_auth_email_account_pw_reset_request_attempt_email',
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
          indexName: 'serverpod_auth_email_account_pw_reset_request_attempt_ip',
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
          indexName: 'serverpod_auth_email_account_pw_reset_request_attempt_at',
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
      name: 'serverpod_auth_email_account_request',
      dartName: 'EmailAccountRequest',
      schema: 'public',
      module: 'serverpod_auth_email_account',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'created',
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
          indexName: 'serverpod_auth_email_account_request_pkey',
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
          indexName: 'serverpod_auth_email_account_request_email',
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
      name: 'serverpod_auth_email_account_request_completion_attempt',
      dartName: 'EmailAccountRequestCompletionAttempt',
      schema: 'public',
      module: 'serverpod_auth_email_account',
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
              'serverpod_auth_email_account_request_completion_attempt_fk_0',
          columns: ['emailAccountRequestId'],
          referenceTable: 'serverpod_auth_email_account_request',
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
              'serverpod_auth_email_account_request_completion_attempt_pkey',
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
          indexName:
              'serverpod_auth_email_account_request_completion_attempt_ip',
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
          indexName:
              'serverpod_auth_email_account_request_completion_attempt_at',
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
    ..._i3.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i4.EmailAccount) {
      return _i4.EmailAccount.fromJson(data) as T;
    }
    if (t == _i5.EmailAccountFailedLoginAttempt) {
      return _i5.EmailAccountFailedLoginAttempt.fromJson(data) as T;
    }
    if (t == _i6.EmailAccountPasswordResetAttempt) {
      return _i6.EmailAccountPasswordResetAttempt.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountPasswordResetRequest) {
      return _i7.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _i8.EmailAccountPasswordResetRequestAttempt) {
      return _i8.EmailAccountPasswordResetRequestAttempt.fromJson(data) as T;
    }
    if (t == _i9.EmailAccountRequest) {
      return _i9.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _i10.EmailAccountRequestCompletionAttempt) {
      return _i10.EmailAccountRequestCompletionAttempt.fromJson(data) as T;
    }
    if (t == _i11.EmailAccountLoginException) {
      return _i11.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i12.EmailAccountLoginFailureReason) {
      return _i12.EmailAccountLoginFailureReason.fromJson(data) as T;
    }
    if (t == _i13.EmailAccountPasswordPolicyViolationException) {
      return _i13.EmailAccountPasswordPolicyViolationException.fromJson(data)
          as T;
    }
    if (t == _i14.EmailAccountPasswordResetRequestExpiredException) {
      return _i14.EmailAccountPasswordResetRequestExpiredException.fromJson(
          data) as T;
    }
    if (t == _i15.EmailAccountPasswordResetRequestNotFoundException) {
      return _i15.EmailAccountPasswordResetRequestNotFoundException.fromJson(
          data) as T;
    }
    if (t == _i16.EmailAccountPasswordResetRequestTooManyAttemptsException) {
      return _i16.EmailAccountPasswordResetRequestTooManyAttemptsException
          .fromJson(data) as T;
    }
    if (t == _i17.EmailAccountPasswordResetRequestUnauthorizedException) {
      return _i17.EmailAccountPasswordResetRequestUnauthorizedException
          .fromJson(data) as T;
    }
    if (t == _i18.EmailAccountPasswordResetTooManyAttemptsException) {
      return _i18.EmailAccountPasswordResetTooManyAttemptsException.fromJson(
          data) as T;
    }
    if (t == _i19.EmailAccountRequestExpiredException) {
      return _i19.EmailAccountRequestExpiredException.fromJson(data) as T;
    }
    if (t == _i20.EmailAccountRequestNotFoundException) {
      return _i20.EmailAccountRequestNotFoundException.fromJson(data) as T;
    }
    if (t == _i21.EmailAccountRequestNotVerifiedException) {
      return _i21.EmailAccountRequestNotVerifiedException.fromJson(data) as T;
    }
    if (t == _i22.EmailAccountRequestTooManyAttemptsException) {
      return _i22.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          as T;
    }
    if (t == _i23.EmailAccountRequestUnauthorizedException) {
      return _i23.EmailAccountRequestUnauthorizedException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.EmailAccount?>()) {
      return (data != null ? _i4.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EmailAccountFailedLoginAttempt?>()) {
      return (data != null
          ? _i5.EmailAccountFailedLoginAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.EmailAccountPasswordResetAttempt?>()) {
      return (data != null
          ? _i6.EmailAccountPasswordResetAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccountPasswordResetRequest?>()) {
      return (data != null
          ? _i7.EmailAccountPasswordResetRequest.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.EmailAccountPasswordResetRequestAttempt?>()) {
      return (data != null
          ? _i8.EmailAccountPasswordResetRequestAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i9.EmailAccountRequest?>()) {
      return (data != null ? _i9.EmailAccountRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.EmailAccountRequestCompletionAttempt?>()) {
      return (data != null
          ? _i10.EmailAccountRequestCompletionAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.EmailAccountLoginException?>()) {
      return (data != null
          ? _i11.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.EmailAccountLoginFailureReason?>()) {
      return (data != null
          ? _i12.EmailAccountLoginFailureReason.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i13.EmailAccountPasswordPolicyViolationException?>()) {
      return (data != null
          ? _i13.EmailAccountPasswordPolicyViolationException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<_i14.EmailAccountPasswordResetRequestExpiredException?>()) {
      return (data != null
          ? _i14.EmailAccountPasswordResetRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i15.EmailAccountPasswordResetRequestNotFoundException?>()) {
      return (data != null
          ? _i15.EmailAccountPasswordResetRequestNotFoundException.fromJson(
              data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i16.EmailAccountPasswordResetRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i16.EmailAccountPasswordResetRequestTooManyAttemptsException
              .fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i17.EmailAccountPasswordResetRequestUnauthorizedException?>()) {
      return (data != null
          ? _i17.EmailAccountPasswordResetRequestUnauthorizedException.fromJson(
              data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i18.EmailAccountPasswordResetTooManyAttemptsException?>()) {
      return (data != null
          ? _i18.EmailAccountPasswordResetTooManyAttemptsException.fromJson(
              data)
          : null) as T;
    }
    if (t == _i1.getType<_i19.EmailAccountRequestExpiredException?>()) {
      return (data != null
          ? _i19.EmailAccountRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i20.EmailAccountRequestNotFoundException?>()) {
      return (data != null
          ? _i20.EmailAccountRequestNotFoundException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i21.EmailAccountRequestNotVerifiedException?>()) {
      return (data != null
          ? _i21.EmailAccountRequestNotVerifiedException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i22.EmailAccountRequestTooManyAttemptsException?>()) {
      return (data != null
          ? _i22.EmailAccountRequestTooManyAttemptsException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i23.EmailAccountRequestUnauthorizedException?>()) {
      return (data != null
          ? _i23.EmailAccountRequestUnauthorizedException.fromJson(data)
          : null) as T;
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
      case _i4.EmailAccount():
        return 'EmailAccount';
      case _i5.EmailAccountFailedLoginAttempt():
        return 'EmailAccountFailedLoginAttempt';
      case _i6.EmailAccountPasswordResetAttempt():
        return 'EmailAccountPasswordResetAttempt';
      case _i7.EmailAccountPasswordResetRequest():
        return 'EmailAccountPasswordResetRequest';
      case _i8.EmailAccountPasswordResetRequestAttempt():
        return 'EmailAccountPasswordResetRequestAttempt';
      case _i9.EmailAccountRequest():
        return 'EmailAccountRequest';
      case _i10.EmailAccountRequestCompletionAttempt():
        return 'EmailAccountRequestCompletionAttempt';
      case _i11.EmailAccountLoginException():
        return 'EmailAccountLoginException';
      case _i12.EmailAccountLoginFailureReason():
        return 'EmailAccountLoginFailureReason';
      case _i13.EmailAccountPasswordPolicyViolationException():
        return 'EmailAccountPasswordPolicyViolationException';
      case _i14.EmailAccountPasswordResetRequestExpiredException():
        return 'EmailAccountPasswordResetRequestExpiredException';
      case _i15.EmailAccountPasswordResetRequestNotFoundException():
        return 'EmailAccountPasswordResetRequestNotFoundException';
      case _i16.EmailAccountPasswordResetRequestTooManyAttemptsException():
        return 'EmailAccountPasswordResetRequestTooManyAttemptsException';
      case _i17.EmailAccountPasswordResetRequestUnauthorizedException():
        return 'EmailAccountPasswordResetRequestUnauthorizedException';
      case _i18.EmailAccountPasswordResetTooManyAttemptsException():
        return 'EmailAccountPasswordResetTooManyAttemptsException';
      case _i19.EmailAccountRequestExpiredException():
        return 'EmailAccountRequestExpiredException';
      case _i20.EmailAccountRequestNotFoundException():
        return 'EmailAccountRequestNotFoundException';
      case _i21.EmailAccountRequestNotVerifiedException():
        return 'EmailAccountRequestNotVerifiedException';
      case _i22.EmailAccountRequestTooManyAttemptsException():
        return 'EmailAccountRequestTooManyAttemptsException';
      case _i23.EmailAccountRequestUnauthorizedException():
        return 'EmailAccountRequestUnauthorizedException';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
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
    if (dataClassName == 'EmailAccount') {
      return deserialize<_i4.EmailAccount>(data['data']);
    }
    if (dataClassName == 'EmailAccountFailedLoginAttempt') {
      return deserialize<_i5.EmailAccountFailedLoginAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetAttempt') {
      return deserialize<_i6.EmailAccountPasswordResetAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i7.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestAttempt') {
      return deserialize<_i8.EmailAccountPasswordResetRequestAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i9.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestCompletionAttempt') {
      return deserialize<_i10.EmailAccountRequestCompletionAttempt>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i11.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginFailureReason') {
      return deserialize<_i12.EmailAccountLoginFailureReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordPolicyViolationException') {
      return deserialize<_i13.EmailAccountPasswordPolicyViolationException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestExpiredException') {
      return deserialize<_i14.EmailAccountPasswordResetRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestNotFoundException') {
      return deserialize<
          _i15.EmailAccountPasswordResetRequestNotFoundException>(data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestTooManyAttemptsException') {
      return deserialize<
              _i16.EmailAccountPasswordResetRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName ==
        'EmailAccountPasswordResetRequestUnauthorizedException') {
      return deserialize<
          _i17
          .EmailAccountPasswordResetRequestUnauthorizedException>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetTooManyAttemptsException') {
      return deserialize<
          _i18.EmailAccountPasswordResetTooManyAttemptsException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExpiredException') {
      return deserialize<_i19.EmailAccountRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotFoundException') {
      return deserialize<_i20.EmailAccountRequestNotFoundException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotVerifiedException') {
      return deserialize<_i21.EmailAccountRequestNotVerifiedException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestTooManyAttemptsException') {
      return deserialize<_i22.EmailAccountRequestTooManyAttemptsException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestUnauthorizedException') {
      return deserialize<_i23.EmailAccountRequestUnauthorizedException>(
          data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_user.')) {
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
      case _i4.EmailAccount:
        return _i4.EmailAccount.t;
      case _i5.EmailAccountFailedLoginAttempt:
        return _i5.EmailAccountFailedLoginAttempt.t;
      case _i6.EmailAccountPasswordResetAttempt:
        return _i6.EmailAccountPasswordResetAttempt.t;
      case _i7.EmailAccountPasswordResetRequest:
        return _i7.EmailAccountPasswordResetRequest.t;
      case _i8.EmailAccountPasswordResetRequestAttempt:
        return _i8.EmailAccountPasswordResetRequestAttempt.t;
      case _i9.EmailAccountRequest:
        return _i9.EmailAccountRequest.t;
      case _i10.EmailAccountRequestCompletionAttempt:
        return _i10.EmailAccountRequestCompletionAttempt.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_email_account';
}
