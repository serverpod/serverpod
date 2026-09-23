/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_null_comparison

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_push_core_server/serverpod_push_core_server.dart'
    as _ipcs;
import 'package:serverpod_push_store_server/src/generated/protocol.dart'
    as _idmfqofs;
import 'push_delivery_status.dart' as _i8aiz6cs;
import 'push_device.dart' as _i6cxim7f;
import 'push_notification.dart' as _ieljydam;

/// One (notification, device) send attempt, with retry state.
abstract class PushDelivery
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PushDelivery._({
    this.id,
    required this.notificationId,
    this.notification,
    required this.deviceId,
    this.device,
    required this.provider,
    required this.status,
    int? attempts,
    int? claimCount,
    int? backoffExponent,
    this.expiresAt,
    required this.nextAttemptAt,
    this.firstAttemptAt,
    this.lastAttemptAt,
    this.lastOutcome,
    this.lastErrorCode,
    this.lastErrorMessage,
    this.providerMessageId,
    this.claimedBy,
    this.claimedAt,
    this.receivedAt,
    this.openedAt,
    DateTime? createdAt,
  }) : attempts = attempts ?? 0,
       claimCount = claimCount ?? 0,
       backoffExponent = backoffExponent ?? 0,
       createdAt = createdAt ?? DateTime.now();

  factory PushDelivery({
    _is.UuidValue? id,
    required _is.UuidValue notificationId,
    _ieljydam.PushNotification? notification,
    required _is.UuidValue deviceId,
    _i6cxim7f.PushDevice? device,
    required String provider,
    required _i8aiz6cs.PushDeliveryStatus status,
    int? attempts,
    int? claimCount,
    int? backoffExponent,
    DateTime? expiresAt,
    required DateTime nextAttemptAt,
    DateTime? firstAttemptAt,
    DateTime? lastAttemptAt,
    _ipcs.PushDeliveryOutcome? lastOutcome,
    String? lastErrorCode,
    String? lastErrorMessage,
    String? providerMessageId,
    String? claimedBy,
    DateTime? claimedAt,
    DateTime? receivedAt,
    DateTime? openedAt,
    DateTime? createdAt,
  }) = _PushDeliveryImpl;

  factory PushDelivery.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDelivery(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      notificationId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['notificationId'],
      ),
      notification: jsonSerialization['notification'] == null
          ? null
          : _idmfqofs.Protocol().deserialize<_ieljydam.PushNotification>(
              jsonSerialization['notification'],
            ),
      deviceId: _is.UuidValueJsonExtension.fromJson(
        jsonSerialization['deviceId'],
      ),
      device: jsonSerialization['device'] == null
          ? null
          : _idmfqofs.Protocol().deserialize<_i6cxim7f.PushDevice>(
              jsonSerialization['device'],
            ),
      provider: jsonSerialization['provider'] as String,
      status: _i8aiz6cs.PushDeliveryStatus.fromJson(
        (jsonSerialization['status'] as String),
      ),
      attempts: jsonSerialization['attempts'] as int?,
      claimCount: jsonSerialization['claimCount'] as int?,
      backoffExponent: jsonSerialization['backoffExponent'] as int?,
      expiresAt: jsonSerialization['expiresAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['expiresAt']),
      nextAttemptAt: _is.DateTimeJsonExtension.fromJson(
        jsonSerialization['nextAttemptAt'],
      ),
      firstAttemptAt: jsonSerialization['firstAttemptAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['firstAttemptAt'],
            ),
      lastAttemptAt: jsonSerialization['lastAttemptAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(
              jsonSerialization['lastAttemptAt'],
            ),
      lastOutcome: jsonSerialization['lastOutcome'] == null
          ? null
          : _ipcs.PushDeliveryOutcome.fromJson(
              (jsonSerialization['lastOutcome'] as String),
            ),
      lastErrorCode: jsonSerialization['lastErrorCode'] as String?,
      lastErrorMessage: jsonSerialization['lastErrorMessage'] as String?,
      providerMessageId: jsonSerialization['providerMessageId'] as String?,
      claimedBy: jsonSerialization['claimedBy'] as String?,
      claimedAt: jsonSerialization['claimedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['claimedAt']),
      receivedAt: jsonSerialization['receivedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['receivedAt']),
      openedAt: jsonSerialization['openedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['openedAt']),
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
    );
  }

  static final t = PushDeliveryTable();

  static const db = PushDeliveryRepository._();

  @override
  _is.UuidValue? id;

  _is.UuidValue notificationId;

  _ieljydam.PushNotification? notification;

  _is.UuidValue deviceId;

  _i6cxim7f.PushDevice? device;

  /// Denormalized from PushDevice so the claim query can scope to a provider.
  String provider;

  _i8aiz6cs.PushDeliveryStatus status;

  /// Send budget. Incremented only at completion. Capped by maxAttempts.
  int attempts;

  /// Crash budget. Incremented at claim. Capped by maxClaims.
  int claimCount;

  /// Backoff driver. Incremented on every deferral, including rateLimited.
  int backoffExponent;

  /// Set once at enqueue from PushMessage.timeToLive. Never recomputed.
  DateTime? expiresAt;

  DateTime nextAttemptAt;

  DateTime? firstAttemptAt;

  DateTime? lastAttemptAt;

  _ipcs.PushDeliveryOutcome? lastOutcome;

  String? lastErrorCode;

  String? lastErrorMessage;

  String? providerMessageId;

  String? claimedBy;

  DateTime? claimedAt;

  DateTime? receivedAt;

  DateTime? openedAt;

  DateTime createdAt;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PushDelivery]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushDelivery copyWith({
    _is.UuidValue? id,
    _is.UuidValue? notificationId,
    _ieljydam.PushNotification? notification,
    _is.UuidValue? deviceId,
    _i6cxim7f.PushDevice? device,
    String? provider,
    _i8aiz6cs.PushDeliveryStatus? status,
    int? attempts,
    int? claimCount,
    int? backoffExponent,
    DateTime? expiresAt,
    DateTime? nextAttemptAt,
    DateTime? firstAttemptAt,
    DateTime? lastAttemptAt,
    _ipcs.PushDeliveryOutcome? lastOutcome,
    String? lastErrorCode,
    String? lastErrorMessage,
    String? providerMessageId,
    String? claimedBy,
    DateTime? claimedAt,
    DateTime? receivedAt,
    DateTime? openedAt,
    DateTime? createdAt,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_store.PushDelivery',
      if (id != null) 'id': id?.toJson(),
      'notificationId': notificationId.toJson(),
      if (notification != null) 'notification': notification?.toJson(),
      'deviceId': deviceId.toJson(),
      if (device != null) 'device': device?.toJson(),
      'provider': provider,
      'status': status.toJson(),
      'attempts': attempts,
      'claimCount': claimCount,
      'backoffExponent': backoffExponent,
      if (expiresAt != null) 'expiresAt': expiresAt?.toJson(),
      'nextAttemptAt': nextAttemptAt.toJson(),
      if (firstAttemptAt != null) 'firstAttemptAt': firstAttemptAt?.toJson(),
      if (lastAttemptAt != null) 'lastAttemptAt': lastAttemptAt?.toJson(),
      if (lastOutcome != null) 'lastOutcome': lastOutcome?.toJson(),
      if (lastErrorCode != null) 'lastErrorCode': lastErrorCode,
      if (lastErrorMessage != null) 'lastErrorMessage': lastErrorMessage,
      if (providerMessageId != null) 'providerMessageId': providerMessageId,
      if (claimedBy != null) 'claimedBy': claimedBy,
      if (claimedAt != null) 'claimedAt': claimedAt?.toJson(),
      if (receivedAt != null) 'receivedAt': receivedAt?.toJson(),
      if (openedAt != null) 'openedAt': openedAt?.toJson(),
      'createdAt': createdAt.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PushDeliveryInclude include({
    _ieljydam.PushNotificationInclude? notification,
    _i6cxim7f.PushDeviceInclude? device,
  }) {
    return PushDeliveryInclude._(
      notification: notification,
      device: device,
    );
  }

  static PushDeliveryIncludeList includeList({
    _is.WhereExpressionBuilder<PushDeliveryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    PushDeliveryInclude? include,
  }) {
    return PushDeliveryIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushDeliveryImpl extends PushDelivery {
  _PushDeliveryImpl({
    _is.UuidValue? id,
    required _is.UuidValue notificationId,
    _ieljydam.PushNotification? notification,
    required _is.UuidValue deviceId,
    _i6cxim7f.PushDevice? device,
    required String provider,
    required _i8aiz6cs.PushDeliveryStatus status,
    int? attempts,
    int? claimCount,
    int? backoffExponent,
    DateTime? expiresAt,
    required DateTime nextAttemptAt,
    DateTime? firstAttemptAt,
    DateTime? lastAttemptAt,
    _ipcs.PushDeliveryOutcome? lastOutcome,
    String? lastErrorCode,
    String? lastErrorMessage,
    String? providerMessageId,
    String? claimedBy,
    DateTime? claimedAt,
    DateTime? receivedAt,
    DateTime? openedAt,
    DateTime? createdAt,
  }) : super._(
         id: id,
         notificationId: notificationId,
         notification: notification,
         deviceId: deviceId,
         device: device,
         provider: provider,
         status: status,
         attempts: attempts,
         claimCount: claimCount,
         backoffExponent: backoffExponent,
         expiresAt: expiresAt,
         nextAttemptAt: nextAttemptAt,
         firstAttemptAt: firstAttemptAt,
         lastAttemptAt: lastAttemptAt,
         lastOutcome: lastOutcome,
         lastErrorCode: lastErrorCode,
         lastErrorMessage: lastErrorMessage,
         providerMessageId: providerMessageId,
         claimedBy: claimedBy,
         claimedAt: claimedAt,
         receivedAt: receivedAt,
         openedAt: openedAt,
         createdAt: createdAt,
       );

  /// Returns a shallow copy of this [PushDelivery]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushDelivery copyWith({
    Object? id = _Undefined,
    _is.UuidValue? notificationId,
    Object? notification = _Undefined,
    _is.UuidValue? deviceId,
    Object? device = _Undefined,
    String? provider,
    _i8aiz6cs.PushDeliveryStatus? status,
    int? attempts,
    int? claimCount,
    int? backoffExponent,
    Object? expiresAt = _Undefined,
    DateTime? nextAttemptAt,
    Object? firstAttemptAt = _Undefined,
    Object? lastAttemptAt = _Undefined,
    Object? lastOutcome = _Undefined,
    Object? lastErrorCode = _Undefined,
    Object? lastErrorMessage = _Undefined,
    Object? providerMessageId = _Undefined,
    Object? claimedBy = _Undefined,
    Object? claimedAt = _Undefined,
    Object? receivedAt = _Undefined,
    Object? openedAt = _Undefined,
    DateTime? createdAt,
  }) {
    return PushDelivery(
      id: id is _is.UuidValue? ? id : this.id,
      notificationId: notificationId ?? this.notificationId,
      notification: notification is _ieljydam.PushNotification?
          ? notification
          : this.notification?.copyWith(),
      deviceId: deviceId ?? this.deviceId,
      device: device is _i6cxim7f.PushDevice?
          ? device
          : this.device?.copyWith(),
      provider: provider ?? this.provider,
      status: status ?? this.status,
      attempts: attempts ?? this.attempts,
      claimCount: claimCount ?? this.claimCount,
      backoffExponent: backoffExponent ?? this.backoffExponent,
      expiresAt: expiresAt is DateTime? ? expiresAt : this.expiresAt,
      nextAttemptAt: nextAttemptAt ?? this.nextAttemptAt,
      firstAttemptAt: firstAttemptAt is DateTime?
          ? firstAttemptAt
          : this.firstAttemptAt,
      lastAttemptAt: lastAttemptAt is DateTime?
          ? lastAttemptAt
          : this.lastAttemptAt,
      lastOutcome: lastOutcome is _ipcs.PushDeliveryOutcome?
          ? lastOutcome
          : this.lastOutcome,
      lastErrorCode: lastErrorCode is String?
          ? lastErrorCode
          : this.lastErrorCode,
      lastErrorMessage: lastErrorMessage is String?
          ? lastErrorMessage
          : this.lastErrorMessage,
      providerMessageId: providerMessageId is String?
          ? providerMessageId
          : this.providerMessageId,
      claimedBy: claimedBy is String? ? claimedBy : this.claimedBy,
      claimedAt: claimedAt is DateTime? ? claimedAt : this.claimedAt,
      receivedAt: receivedAt is DateTime? ? receivedAt : this.receivedAt,
      openedAt: openedAt is DateTime? ? openedAt : this.openedAt,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class PushDeliveryUpdateTable extends _is.UpdateTable<PushDeliveryTable> {
  PushDeliveryUpdateTable(super.table);

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> notificationId(
    _is.UuidValue value,
  ) => _is.ColumnValue(
    table.notificationId,
    value,
  );

  _is.ColumnValue<_is.UuidValue, _is.UuidValue> deviceId(_is.UuidValue value) =>
      _is.ColumnValue(
        table.deviceId,
        value,
      );

  _is.ColumnValue<String, String> provider(String value) => _is.ColumnValue(
    table.provider,
    value,
  );

  _is.ColumnValue<_i8aiz6cs.PushDeliveryStatus, _i8aiz6cs.PushDeliveryStatus>
  status(_i8aiz6cs.PushDeliveryStatus value) => _is.ColumnValue(
    table.status,
    value,
  );

  _is.ColumnValue<int, int> attempts(int value) => _is.ColumnValue(
    table.attempts,
    value,
  );

  _is.ColumnValue<int, int> claimCount(int value) => _is.ColumnValue(
    table.claimCount,
    value,
  );

  _is.ColumnValue<int, int> backoffExponent(int value) => _is.ColumnValue(
    table.backoffExponent,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> expiresAt(DateTime? value) =>
      _is.ColumnValue(
        table.expiresAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> nextAttemptAt(DateTime value) =>
      _is.ColumnValue(
        table.nextAttemptAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> firstAttemptAt(DateTime? value) =>
      _is.ColumnValue(
        table.firstAttemptAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> lastAttemptAt(DateTime? value) =>
      _is.ColumnValue(
        table.lastAttemptAt,
        value,
      );

  _is.ColumnValue<_ipcs.PushDeliveryOutcome, _ipcs.PushDeliveryOutcome>
  lastOutcome(_ipcs.PushDeliveryOutcome? value) => _is.ColumnValue(
    table.lastOutcome,
    value,
  );

  _is.ColumnValue<String, String> lastErrorCode(String? value) =>
      _is.ColumnValue(
        table.lastErrorCode,
        value,
      );

  _is.ColumnValue<String, String> lastErrorMessage(String? value) =>
      _is.ColumnValue(
        table.lastErrorMessage,
        value,
      );

  _is.ColumnValue<String, String> providerMessageId(String? value) =>
      _is.ColumnValue(
        table.providerMessageId,
        value,
      );

  _is.ColumnValue<String, String> claimedBy(String? value) => _is.ColumnValue(
    table.claimedBy,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> claimedAt(DateTime? value) =>
      _is.ColumnValue(
        table.claimedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> receivedAt(DateTime? value) =>
      _is.ColumnValue(
        table.receivedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> openedAt(DateTime? value) =>
      _is.ColumnValue(
        table.openedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );
}

class PushDeliveryTable extends _is.Table<_is.UuidValue?> {
  PushDeliveryTable({super.tableRelation})
    : super(tableName: 'serverpod_push_delivery') {
    updateTable = PushDeliveryUpdateTable(this);
    notificationId = _is.ColumnUuid(
      'notificationId',
      this,
    );
    deviceId = _is.ColumnUuid(
      'deviceId',
      this,
    );
    provider = _is.ColumnString(
      'provider',
      this,
    );
    status = _is.ColumnEnum(
      'status',
      this,
      _is.EnumSerialization.byName,
    );
    attempts = _is.ColumnInt(
      'attempts',
      this,
      hasDefault: true,
    );
    claimCount = _is.ColumnInt(
      'claimCount',
      this,
      hasDefault: true,
    );
    backoffExponent = _is.ColumnInt(
      'backoffExponent',
      this,
      hasDefault: true,
    );
    expiresAt = _is.ColumnDateTime(
      'expiresAt',
      this,
    );
    nextAttemptAt = _is.ColumnDateTime(
      'nextAttemptAt',
      this,
    );
    firstAttemptAt = _is.ColumnDateTime(
      'firstAttemptAt',
      this,
    );
    lastAttemptAt = _is.ColumnDateTime(
      'lastAttemptAt',
      this,
    );
    lastOutcome = _is.ColumnEnum(
      'lastOutcome',
      this,
      _is.EnumSerialization.byName,
    );
    lastErrorCode = _is.ColumnString(
      'lastErrorCode',
      this,
    );
    lastErrorMessage = _is.ColumnString(
      'lastErrorMessage',
      this,
    );
    providerMessageId = _is.ColumnString(
      'providerMessageId',
      this,
    );
    claimedBy = _is.ColumnString(
      'claimedBy',
      this,
    );
    claimedAt = _is.ColumnDateTime(
      'claimedAt',
      this,
    );
    receivedAt = _is.ColumnDateTime(
      'receivedAt',
      this,
    );
    openedAt = _is.ColumnDateTime(
      'openedAt',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
  }

  late final PushDeliveryUpdateTable updateTable;

  late final _is.ColumnUuid notificationId;

  _ieljydam.PushNotificationTable? _notification;

  late final _is.ColumnUuid deviceId;

  _i6cxim7f.PushDeviceTable? _device;

  /// Denormalized from PushDevice so the claim query can scope to a provider.
  late final _is.ColumnString provider;

  late final _is.ColumnEnum<_i8aiz6cs.PushDeliveryStatus> status;

  /// Send budget. Incremented only at completion. Capped by maxAttempts.
  late final _is.ColumnInt attempts;

  /// Crash budget. Incremented at claim. Capped by maxClaims.
  late final _is.ColumnInt claimCount;

  /// Backoff driver. Incremented on every deferral, including rateLimited.
  late final _is.ColumnInt backoffExponent;

  /// Set once at enqueue from PushMessage.timeToLive. Never recomputed.
  late final _is.ColumnDateTime expiresAt;

  late final _is.ColumnDateTime nextAttemptAt;

  late final _is.ColumnDateTime firstAttemptAt;

  late final _is.ColumnDateTime lastAttemptAt;

  late final _is.ColumnEnum<_ipcs.PushDeliveryOutcome> lastOutcome;

  late final _is.ColumnString lastErrorCode;

  late final _is.ColumnString lastErrorMessage;

  late final _is.ColumnString providerMessageId;

  late final _is.ColumnString claimedBy;

  late final _is.ColumnDateTime claimedAt;

  late final _is.ColumnDateTime receivedAt;

  late final _is.ColumnDateTime openedAt;

  late final _is.ColumnDateTime createdAt;

  _ieljydam.PushNotificationTable get notification {
    if (_notification != null) return _notification!;
    _notification = _is.createRelationTable(
      relationFieldName: 'notification',
      field: PushDelivery.t.notificationId,
      foreignField: _ieljydam.PushNotification.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _ieljydam.PushNotificationTable(tableRelation: foreignTableRelation),
    );
    return _notification!;
  }

  _i6cxim7f.PushDeviceTable get device {
    if (_device != null) return _device!;
    _device = _is.createRelationTable(
      relationFieldName: 'device',
      field: PushDelivery.t.deviceId,
      foreignField: _i6cxim7f.PushDevice.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i6cxim7f.PushDeviceTable(tableRelation: foreignTableRelation),
    );
    return _device!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    notificationId,
    deviceId,
    provider,
    status,
    attempts,
    claimCount,
    backoffExponent,
    expiresAt,
    nextAttemptAt,
    firstAttemptAt,
    lastAttemptAt,
    lastOutcome,
    lastErrorCode,
    lastErrorMessage,
    providerMessageId,
    claimedBy,
    claimedAt,
    receivedAt,
    openedAt,
    createdAt,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'notification') {
      return notification;
    }
    if (relationField == 'device') {
      return device;
    }
    return null;
  }
}

class PushDeliveryInclude extends _is.IncludeObject {
  PushDeliveryInclude._({
    _ieljydam.PushNotificationInclude? notification,
    _i6cxim7f.PushDeviceInclude? device,
  }) {
    _notification = notification;
    _device = device;
  }

  _ieljydam.PushNotificationInclude? _notification;

  _i6cxim7f.PushDeviceInclude? _device;

  @override
  Map<String, _is.Include?> get includes => {
    'notification': _notification,
    'device': _device,
  };

  @override
  _is.Table<_is.UuidValue?> get table => PushDelivery.t;
}

class PushDeliveryIncludeList extends _is.IncludeList {
  PushDeliveryIncludeList._({
    _is.WhereExpressionBuilder<PushDeliveryTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushDelivery.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PushDelivery.t;
}

class PushDeliveryRepository {
  const PushDeliveryRepository._();

  final attachRow = const PushDeliveryAttachRowRepository._();

  /// Returns a list of [PushDelivery]s matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order of the items use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// The maximum number of items can be set by [limit]. If no limit is set,
  /// all items matching the query will be returned.
  ///
  /// [offset] defines how many items to skip, after which [limit] (or all)
  /// items are read from the database.
  ///
  /// ```dart
  /// var persons = await Persons.db.find(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.firstName,
  ///   limit: 100,
  /// );
  /// ```
  Future<List<PushDelivery>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeliveryTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    _is.Transaction? transaction,
    PushDeliveryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushDelivery>(
      where: where?.call(PushDelivery.t),
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PushDelivery] matching the given query parameters.
  ///
  /// Use [where] to specify which items to include in the return value.
  /// If none is specified, all items will be returned.
  ///
  /// To specify the order use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// [offset] defines how many items to skip, after which the next one will be picked.
  ///
  /// ```dart
  /// var youngestPerson = await Persons.db.findFirstRow(
  ///   session,
  ///   where: (t) => t.lastName.equals('Jones'),
  ///   orderBy: (t) => t.age,
  /// );
  /// ```
  Future<PushDelivery?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeliveryTable>? where,
    int? offset,
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    _is.Transaction? transaction,
    PushDeliveryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushDelivery>(
      where: where?.call(PushDelivery.t),
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushDelivery] by its [id] or null if no such row exists.
  Future<PushDelivery?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    PushDeliveryInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushDelivery>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushDelivery]s in the list and returns the inserted rows.
  ///
  /// The returned [PushDelivery]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> insert(
    _is.DatabaseSession session,
    List<PushDelivery> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushDelivery>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushDelivery] and returns the inserted row.
  ///
  /// The returned [PushDelivery] will have its `id` field set.
  Future<PushDelivery> insertRow(
    _is.DatabaseSession session,
    PushDelivery row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushDelivery>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushDelivery]s in the list and returns the resulting rows.
  ///
  /// If a row conflicts on the given [conflictColumns], the existing row is
  /// updated with the new values. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies to rows matching the
  /// given expression. Conflicting rows that don't match are skipped and not
  /// returned, so the resulting list may be shorter than [rows].
  ///
  /// The returned [PushDelivery]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> upsert(
    _is.DatabaseSession session,
    List<PushDelivery> rows, {
    required _is.ColumnSelections<PushDeliveryTable> conflictColumns,
    _is.ColumnSelections<PushDeliveryTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeliveryTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushDelivery>(
      rows,
      conflictColumns: conflictColumns(PushDelivery.t),
      updateColumns: updateColumns?.call(PushDelivery.t),
      updateWhere: updateWhere?.call(PushDelivery.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushDelivery] and returns the resulting row.
  ///
  /// If the row conflicts on the given [conflictColumns], the existing row is
  /// updated. Otherwise, a new row is inserted.
  ///
  /// If [updateColumns] is provided, only those columns will be updated on
  /// conflict. If null, all non-conflict, non-id columns are updated.
  ///
  /// If [updateWhere] is provided, the update only applies when the existing
  /// row matches the expression. Returns `null` if no row was affected — for
  /// example when [updateWhere] does not match the conflicting row.
  ///
  /// The returned [PushDelivery] will have its `id` field set.
  Future<PushDelivery?> upsertRow(
    _is.DatabaseSession session,
    PushDelivery row, {
    required _is.ColumnSelections<PushDeliveryTable> conflictColumns,
    _is.ColumnSelections<PushDeliveryTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeliveryTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushDelivery>(
      row,
      conflictColumns: conflictColumns(PushDelivery.t),
      updateColumns: updateColumns?.call(PushDelivery.t),
      updateWhere: updateWhere?.call(PushDelivery.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushDelivery]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> update(
    _is.DatabaseSession session,
    List<PushDelivery> rows, {
    _is.ColumnSelections<PushDeliveryTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushDelivery>(
      rows,
      columns: columns?.call(PushDelivery.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushDelivery]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushDelivery> updateRow(
    _is.DatabaseSession session,
    PushDelivery row, {
    _is.ColumnSelections<PushDeliveryTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushDelivery>(
      row,
      columns: columns?.call(PushDelivery.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushDelivery] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushDelivery?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PushDeliveryUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushDelivery>(
      id,
      columnValues: columnValues(PushDelivery.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushDelivery]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushDeliveryUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PushDeliveryTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushDelivery>(
      columnValues: columnValues(PushDelivery.t.updateTable),
      where: where(PushDelivery.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushDelivery]s in the list and returns the deleted rows.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> delete(
    _is.DatabaseSession session,
    List<PushDelivery> rows, {
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushDelivery>(
      rows,
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushDelivery].
  Future<PushDelivery> deleteRow(
    _is.DatabaseSession session,
    PushDelivery row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushDelivery>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  ///
  /// To specify the order of the returned rows use [orderBy] or [orderByList]
  /// when sorting by multiple columns.
  ///
  /// If [noReturn] is set to `true`, the deleted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDelivery>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeliveryTable> where,
    _is.OrderByBuilder<PushDeliveryTable>? orderBy,
    _is.OrderByListBuilder<PushDeliveryTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushDelivery>(
      where: where(PushDelivery.t),
      orderBy: orderBy?.call(PushDelivery.t),
      orderByList: orderByList?.call(PushDelivery.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeliveryTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushDelivery>(
      where: where?.call(PushDelivery.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushDelivery] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeliveryTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushDelivery>(
      where: where(PushDelivery.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PushDeliveryAttachRowRepository {
  const PushDeliveryAttachRowRepository._();

  /// Creates a relation between the given [PushDelivery] and [PushNotification]
  /// by setting the [PushDelivery]'s foreign key `notificationId` to refer to the [PushNotification].
  Future<void> notification(
    _is.DatabaseSession session,
    PushDelivery pushDelivery,
    _ieljydam.PushNotification notification, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.id == null) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (notification.id == null) {
      throw ArgumentError.notNull('notification.id');
    }

    var $pushDelivery = pushDelivery.copyWith(notificationId: notification.id);
    await session.db.updateRow<PushDelivery>(
      $pushDelivery,
      columns: [PushDelivery.t.notificationId],
      transaction: transaction,
    );
  }

  /// Creates a relation between the given [PushDelivery] and [PushDevice]
  /// by setting the [PushDelivery]'s foreign key `deviceId` to refer to the [PushDevice].
  Future<void> device(
    _is.DatabaseSession session,
    PushDelivery pushDelivery,
    _i6cxim7f.PushDevice device, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.id == null) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (device.id == null) {
      throw ArgumentError.notNull('device.id');
    }

    var $pushDelivery = pushDelivery.copyWith(deviceId: device.id);
    await session.db.updateRow<PushDelivery>(
      $pushDelivery,
      columns: [PushDelivery.t.deviceId],
      transaction: transaction,
    );
  }
}
