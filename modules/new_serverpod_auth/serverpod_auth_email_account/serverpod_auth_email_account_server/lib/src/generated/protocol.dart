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
import 'email_account_login_exception.dart' as _i6;
import 'email_account_login_failure_reason.dart' as _i7;
import 'email_account_password_policy_violation_exception.dart' as _i8;
import 'email_account_password_reset_attempt.dart' as _i9;
import 'email_account_password_reset_request.dart' as _i10;
import 'email_account_password_reset_request_expired_exception.dart' as _i11;
import 'email_account_password_reset_request_not_found_exception.dart' as _i12;
import 'email_account_request.dart' as _i13;
import 'email_account_request_expired_exception.dart' as _i14;
import 'email_account_request_not_found_exception.dart' as _i15;
export 'email_account.dart';
export 'email_account_failed_login_attempt.dart';
export 'email_account_login_exception.dart';
export 'email_account_login_failure_reason.dart';
export 'email_account_password_policy_violation_exception.dart';
export 'email_account_password_reset_attempt.dart';
export 'email_account_password_reset_request.dart';
export 'email_account_password_reset_request_expired_exception.dart';
export 'email_account_password_reset_request_not_found_exception.dart';
export 'email_account_request.dart';
export 'email_account_request_expired_exception.dart';
export 'email_account_request_not_found_exception.dart';

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
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_auth_email_account_failed_login_attempt_id_seq\'::regclass)',
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
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'serverpod_auth_email_account_password_reset_attempt_id_seq\'::regclass)',
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
          indexName:
              'serverpod_auth_email_account_password_reset_attempt_email',
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
              'serverpod_auth_email_account_password_reset_attempt_ip_address',
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
          name: 'authenticationId',
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
          name: 'verificationCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'serverpod_auth_email_account_password_reset_request_fk_0',
          columns: ['authenticationId'],
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
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'verificationCode',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
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
    if (t == _i6.EmailAccountLoginException) {
      return _i6.EmailAccountLoginException.fromJson(data) as T;
    }
    if (t == _i7.EmailAccountLoginFailureReason) {
      return _i7.EmailAccountLoginFailureReason.fromJson(data) as T;
    }
    if (t == _i8.EmailAccountPasswordPolicyViolationException) {
      return _i8.EmailAccountPasswordPolicyViolationException.fromJson(data)
          as T;
    }
    if (t == _i9.EmailAccountPasswordResetAttempt) {
      return _i9.EmailAccountPasswordResetAttempt.fromJson(data) as T;
    }
    if (t == _i10.EmailAccountPasswordResetRequest) {
      return _i10.EmailAccountPasswordResetRequest.fromJson(data) as T;
    }
    if (t == _i11.EmailAccountPasswordResetRequestExpiredException) {
      return _i11.EmailAccountPasswordResetRequestExpiredException.fromJson(
          data) as T;
    }
    if (t == _i12.EmailAccountPasswordResetRequestNotFoundException) {
      return _i12.EmailAccountPasswordResetRequestNotFoundException.fromJson(
          data) as T;
    }
    if (t == _i13.EmailAccountRequest) {
      return _i13.EmailAccountRequest.fromJson(data) as T;
    }
    if (t == _i14.EmailAccountRequestExpiredException) {
      return _i14.EmailAccountRequestExpiredException.fromJson(data) as T;
    }
    if (t == _i15.EmailAccountRequestNotFoundException) {
      return _i15.EmailAccountRequestNotFoundException.fromJson(data) as T;
    }
    if (t == _i1.getType<_i4.EmailAccount?>()) {
      return (data != null ? _i4.EmailAccount.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EmailAccountFailedLoginAttempt?>()) {
      return (data != null
          ? _i5.EmailAccountFailedLoginAttempt.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.EmailAccountLoginException?>()) {
      return (data != null
          ? _i6.EmailAccountLoginException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i7.EmailAccountLoginFailureReason?>()) {
      return (data != null
          ? _i7.EmailAccountLoginFailureReason.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.EmailAccountPasswordPolicyViolationException?>()) {
      return (data != null
          ? _i8.EmailAccountPasswordPolicyViolationException.fromJson(data)
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
    if (t ==
        _i1.getType<_i11.EmailAccountPasswordResetRequestExpiredException?>()) {
      return (data != null
          ? _i11.EmailAccountPasswordResetRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t ==
        _i1.getType<
            _i12.EmailAccountPasswordResetRequestNotFoundException?>()) {
      return (data != null
          ? _i12.EmailAccountPasswordResetRequestNotFoundException.fromJson(
              data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.EmailAccountRequest?>()) {
      return (data != null ? _i13.EmailAccountRequest.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.EmailAccountRequestExpiredException?>()) {
      return (data != null
          ? _i14.EmailAccountRequestExpiredException.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.EmailAccountRequestNotFoundException?>()) {
      return (data != null
          ? _i15.EmailAccountRequestNotFoundException.fromJson(data)
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
    if (data is _i4.EmailAccount) {
      return 'EmailAccount';
    }
    if (data is _i5.EmailAccountFailedLoginAttempt) {
      return 'EmailAccountFailedLoginAttempt';
    }
    if (data is _i6.EmailAccountLoginException) {
      return 'EmailAccountLoginException';
    }
    if (data is _i7.EmailAccountLoginFailureReason) {
      return 'EmailAccountLoginFailureReason';
    }
    if (data is _i8.EmailAccountPasswordPolicyViolationException) {
      return 'EmailAccountPasswordPolicyViolationException';
    }
    if (data is _i9.EmailAccountPasswordResetAttempt) {
      return 'EmailAccountPasswordResetAttempt';
    }
    if (data is _i10.EmailAccountPasswordResetRequest) {
      return 'EmailAccountPasswordResetRequest';
    }
    if (data is _i11.EmailAccountPasswordResetRequestExpiredException) {
      return 'EmailAccountPasswordResetRequestExpiredException';
    }
    if (data is _i12.EmailAccountPasswordResetRequestNotFoundException) {
      return 'EmailAccountPasswordResetRequestNotFoundException';
    }
    if (data is _i13.EmailAccountRequest) {
      return 'EmailAccountRequest';
    }
    if (data is _i14.EmailAccountRequestExpiredException) {
      return 'EmailAccountRequestExpiredException';
    }
    if (data is _i15.EmailAccountRequestNotFoundException) {
      return 'EmailAccountRequestNotFoundException';
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
    if (dataClassName == 'EmailAccountLoginException') {
      return deserialize<_i6.EmailAccountLoginException>(data['data']);
    }
    if (dataClassName == 'EmailAccountLoginFailureReason') {
      return deserialize<_i7.EmailAccountLoginFailureReason>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordPolicyViolationException') {
      return deserialize<_i8.EmailAccountPasswordPolicyViolationException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetAttempt') {
      return deserialize<_i9.EmailAccountPasswordResetAttempt>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequest') {
      return deserialize<_i10.EmailAccountPasswordResetRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestExpiredException') {
      return deserialize<_i11.EmailAccountPasswordResetRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountPasswordResetRequestNotFoundException') {
      return deserialize<
          _i12.EmailAccountPasswordResetRequestNotFoundException>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequest') {
      return deserialize<_i13.EmailAccountRequest>(data['data']);
    }
    if (dataClassName == 'EmailAccountRequestExpiredException') {
      return deserialize<_i14.EmailAccountRequestExpiredException>(
          data['data']);
    }
    if (dataClassName == 'EmailAccountRequestNotFoundException') {
      return deserialize<_i15.EmailAccountRequestNotFoundException>(
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
      case _i9.EmailAccountPasswordResetAttempt:
        return _i9.EmailAccountPasswordResetAttempt.t;
      case _i10.EmailAccountPasswordResetRequest:
        return _i10.EmailAccountPasswordResetRequest.t;
      case _i13.EmailAccountRequest:
        return _i13.EmailAccountRequest.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_auth_email_account';
}
