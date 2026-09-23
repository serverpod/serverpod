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
import 'push_delivery.dart' as _i3bkdlz1;

/// A registered push device.
abstract class PushDevice
    implements _is.TableRow<_is.UuidValue?>, _is.ProtocolSerialization {
  PushDevice._({
    this.id,
    required this.provider,
    required this.credential,
    required this.identityHash,
    required this.platform,
    this.userIdentifier,
    this.installationId,
    this.locale,
    this.appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    this.disabledAt,
    this.disabledReason,
    this.deliveries,
  }) : createdAt = createdAt ?? DateTime.now(),
       updatedAt = updatedAt ?? DateTime.now();

  factory PushDevice({
    _is.UuidValue? id,
    required String provider,
    required String credential,
    required String identityHash,
    required _ipcs.PushPlatform platform,
    String? userIdentifier,
    String? installationId,
    String? locale,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? disabledAt,
    String? disabledReason,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  }) = _PushDeviceImpl;

  factory PushDevice.fromJson(Map<String, dynamic> jsonSerialization) {
    return PushDevice(
      id: jsonSerialization['id'] == null
          ? null
          : _is.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      provider: jsonSerialization['provider'] as String,
      credential: jsonSerialization['credential'] as String,
      identityHash: jsonSerialization['identityHash'] as String,
      platform: _ipcs.PushPlatform.fromJson(
        (jsonSerialization['platform'] as String),
      ),
      userIdentifier: jsonSerialization['userIdentifier'] as String?,
      installationId: jsonSerialization['installationId'] as String?,
      locale: jsonSerialization['locale'] as String?,
      appVersion: jsonSerialization['appVersion'] as String?,
      createdAt: jsonSerialization['createdAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['createdAt']),
      updatedAt: jsonSerialization['updatedAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['updatedAt']),
      disabledAt: jsonSerialization['disabledAt'] == null
          ? null
          : _is.DateTimeJsonExtension.fromJson(jsonSerialization['disabledAt']),
      disabledReason: jsonSerialization['disabledReason'] as String?,
      deliveries: jsonSerialization['deliveries'] == null
          ? null
          : _idmfqofs.Protocol().deserialize<List<_i3bkdlz1.PushDelivery>>(
              jsonSerialization['deliveries'],
            ),
    );
  }

  static final t = PushDeviceTable();

  static const db = PushDeviceRepository._();

  @override
  _is.UuidValue? id;

  String provider;

  /// Credential used for sending. Rotates.
  String credential;

  /// sha256 of PushProvider.identityKeyFor(credential) — the stable identity,
  /// not the credential.
  String identityHash;

  _ipcs.PushPlatform platform;

  String? userIdentifier;

  /// Client-generated, stable across token rotation. When present it is the
  /// upsert key, so a rotated token replaces its predecessor instead of
  /// accumulating a duplicate.
  String? installationId;

  String? locale;

  String? appVersion;

  DateTime createdAt;

  DateTime updatedAt;

  DateTime? disabledAt;

  String? disabledReason;

  List<_i3bkdlz1.PushDelivery>? deliveries;

  @override
  _is.Table<_is.UuidValue?> get table => t;

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  PushDevice copyWith({
    _is.UuidValue? id,
    String? provider,
    String? credential,
    String? identityHash,
    _ipcs.PushPlatform? platform,
    String? userIdentifier,
    String? installationId,
    String? locale,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? disabledAt,
    String? disabledReason,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'serverpod_push_store.PushDevice',
      if (id != null) 'id': id?.toJson(),
      'provider': provider,
      'credential': credential,
      'identityHash': identityHash,
      'platform': platform.toJson(),
      if (userIdentifier != null) 'userIdentifier': userIdentifier,
      if (installationId != null) 'installationId': installationId,
      if (locale != null) 'locale': locale,
      if (appVersion != null) 'appVersion': appVersion,
      'createdAt': createdAt.toJson(),
      'updatedAt': updatedAt.toJson(),
      if (disabledAt != null) 'disabledAt': disabledAt?.toJson(),
      if (disabledReason != null) 'disabledReason': disabledReason,
      if (deliveries != null)
        'deliveries': deliveries?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {};
  }

  static PushDeviceInclude include({
    _i3bkdlz1.PushDeliveryIncludeList? deliveries,
  }) {
    return PushDeviceInclude._(deliveries: deliveries);
  }

  static PushDeviceIncludeList includeList({
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    PushDeviceInclude? include,
  }) {
    return PushDeviceIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PushDeviceImpl extends PushDevice {
  _PushDeviceImpl({
    _is.UuidValue? id,
    required String provider,
    required String credential,
    required String identityHash,
    required _ipcs.PushPlatform platform,
    String? userIdentifier,
    String? installationId,
    String? locale,
    String? appVersion,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? disabledAt,
    String? disabledReason,
    List<_i3bkdlz1.PushDelivery>? deliveries,
  }) : super._(
         id: id,
         provider: provider,
         credential: credential,
         identityHash: identityHash,
         platform: platform,
         userIdentifier: userIdentifier,
         installationId: installationId,
         locale: locale,
         appVersion: appVersion,
         createdAt: createdAt,
         updatedAt: updatedAt,
         disabledAt: disabledAt,
         disabledReason: disabledReason,
         deliveries: deliveries,
       );

  /// Returns a shallow copy of this [PushDevice]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  @override
  PushDevice copyWith({
    Object? id = _Undefined,
    String? provider,
    String? credential,
    String? identityHash,
    _ipcs.PushPlatform? platform,
    Object? userIdentifier = _Undefined,
    Object? installationId = _Undefined,
    Object? locale = _Undefined,
    Object? appVersion = _Undefined,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? disabledAt = _Undefined,
    Object? disabledReason = _Undefined,
    Object? deliveries = _Undefined,
  }) {
    return PushDevice(
      id: id is _is.UuidValue? ? id : this.id,
      provider: provider ?? this.provider,
      credential: credential ?? this.credential,
      identityHash: identityHash ?? this.identityHash,
      platform: platform ?? this.platform,
      userIdentifier: userIdentifier is String?
          ? userIdentifier
          : this.userIdentifier,
      installationId: installationId is String?
          ? installationId
          : this.installationId,
      locale: locale is String? ? locale : this.locale,
      appVersion: appVersion is String? ? appVersion : this.appVersion,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      disabledAt: disabledAt is DateTime? ? disabledAt : this.disabledAt,
      disabledReason: disabledReason is String?
          ? disabledReason
          : this.disabledReason,
      deliveries: deliveries is List<_i3bkdlz1.PushDelivery>?
          ? deliveries
          : this.deliveries?.map((e0) => e0.copyWith()).toList(),
    );
  }
}

class PushDeviceUpdateTable extends _is.UpdateTable<PushDeviceTable> {
  PushDeviceUpdateTable(super.table);

  _is.ColumnValue<String, String> provider(String value) => _is.ColumnValue(
    table.provider,
    value,
  );

  _is.ColumnValue<String, String> credential(String value) => _is.ColumnValue(
    table.credential,
    value,
  );

  _is.ColumnValue<String, String> identityHash(String value) => _is.ColumnValue(
    table.identityHash,
    value,
  );

  _is.ColumnValue<_ipcs.PushPlatform, _ipcs.PushPlatform> platform(
    _ipcs.PushPlatform value,
  ) => _is.ColumnValue(
    table.platform,
    value,
  );

  _is.ColumnValue<String, String> userIdentifier(String? value) =>
      _is.ColumnValue(
        table.userIdentifier,
        value,
      );

  _is.ColumnValue<String, String> installationId(String? value) =>
      _is.ColumnValue(
        table.installationId,
        value,
      );

  _is.ColumnValue<String, String> locale(String? value) => _is.ColumnValue(
    table.locale,
    value,
  );

  _is.ColumnValue<String, String> appVersion(String? value) => _is.ColumnValue(
    table.appVersion,
    value,
  );

  _is.ColumnValue<DateTime, DateTime> createdAt(DateTime value) =>
      _is.ColumnValue(
        table.createdAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> updatedAt(DateTime value) =>
      _is.ColumnValue(
        table.updatedAt,
        value,
      );

  _is.ColumnValue<DateTime, DateTime> disabledAt(DateTime? value) =>
      _is.ColumnValue(
        table.disabledAt,
        value,
      );

  _is.ColumnValue<String, String> disabledReason(String? value) =>
      _is.ColumnValue(
        table.disabledReason,
        value,
      );
}

class PushDeviceTable extends _is.Table<_is.UuidValue?> {
  PushDeviceTable({super.tableRelation})
    : super(tableName: 'serverpod_push_device') {
    updateTable = PushDeviceUpdateTable(this);
    provider = _is.ColumnString(
      'provider',
      this,
    );
    credential = _is.ColumnString(
      'credential',
      this,
    );
    identityHash = _is.ColumnString(
      'identityHash',
      this,
    );
    platform = _is.ColumnEnum(
      'platform',
      this,
      _is.EnumSerialization.byName,
    );
    userIdentifier = _is.ColumnString(
      'userIdentifier',
      this,
    );
    installationId = _is.ColumnString(
      'installationId',
      this,
    );
    locale = _is.ColumnString(
      'locale',
      this,
    );
    appVersion = _is.ColumnString(
      'appVersion',
      this,
    );
    createdAt = _is.ColumnDateTime(
      'createdAt',
      this,
    );
    updatedAt = _is.ColumnDateTime(
      'updatedAt',
      this,
    );
    disabledAt = _is.ColumnDateTime(
      'disabledAt',
      this,
    );
    disabledReason = _is.ColumnString(
      'disabledReason',
      this,
    );
  }

  late final PushDeviceUpdateTable updateTable;

  late final _is.ColumnString provider;

  /// Credential used for sending. Rotates.
  late final _is.ColumnString credential;

  /// sha256 of PushProvider.identityKeyFor(credential) — the stable identity,
  /// not the credential.
  late final _is.ColumnString identityHash;

  late final _is.ColumnEnum<_ipcs.PushPlatform> platform;

  late final _is.ColumnString userIdentifier;

  /// Client-generated, stable across token rotation. When present it is the
  /// upsert key, so a rotated token replaces its predecessor instead of
  /// accumulating a duplicate.
  late final _is.ColumnString installationId;

  late final _is.ColumnString locale;

  late final _is.ColumnString appVersion;

  late final _is.ColumnDateTime createdAt;

  late final _is.ColumnDateTime updatedAt;

  late final _is.ColumnDateTime disabledAt;

  late final _is.ColumnString disabledReason;

  _i3bkdlz1.PushDeliveryTable? ___deliveries;

  _is.ManyRelation<_i3bkdlz1.PushDeliveryTable>? _deliveries;

  _i3bkdlz1.PushDeliveryTable get __deliveries {
    if (___deliveries != null) return ___deliveries!;
    ___deliveries = _is.createRelationTable(
      relationFieldName: '__deliveries',
      field: PushDevice.t.id,
      foreignField: _i3bkdlz1.PushDelivery.t.deviceId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3bkdlz1.PushDeliveryTable(tableRelation: foreignTableRelation),
    );
    return ___deliveries!;
  }

  _is.ManyRelation<_i3bkdlz1.PushDeliveryTable> get deliveries {
    if (_deliveries != null) return _deliveries!;
    var relationTable = _is.createRelationTable(
      relationFieldName: 'deliveries',
      field: PushDevice.t.id,
      foreignField: _i3bkdlz1.PushDelivery.t.deviceId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3bkdlz1.PushDeliveryTable(tableRelation: foreignTableRelation),
    );
    _deliveries = _is.ManyRelation<_i3bkdlz1.PushDeliveryTable>(
      tableWithRelations: relationTable,
      table: _i3bkdlz1.PushDeliveryTable(
        tableRelation: relationTable.tableRelation!.lastRelation,
      ),
    );
    return _deliveries!;
  }

  @override
  List<_is.Column> get columns => [
    id,
    provider,
    credential,
    identityHash,
    platform,
    userIdentifier,
    installationId,
    locale,
    appVersion,
    createdAt,
    updatedAt,
    disabledAt,
    disabledReason,
  ];

  @override
  _is.Table? getRelationTable(String relationField) {
    if (relationField == 'deliveries') {
      return __deliveries;
    }
    return null;
  }
}

class PushDeviceInclude extends _is.IncludeObject {
  PushDeviceInclude._({_i3bkdlz1.PushDeliveryIncludeList? deliveries}) {
    _deliveries = deliveries;
  }

  _i3bkdlz1.PushDeliveryIncludeList? _deliveries;

  @override
  Map<String, _is.Include?> get includes => {'deliveries': _deliveries};

  @override
  _is.Table<_is.UuidValue?> get table => PushDevice.t;
}

class PushDeviceIncludeList extends _is.IncludeList {
  PushDeviceIncludeList._({
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(PushDevice.t);
  }

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<_is.UuidValue?> get table => PushDevice.t;
}

class PushDeviceRepository {
  const PushDeviceRepository._();

  final attach = const PushDeviceAttachRepository._();

  final attachRow = const PushDeviceAttachRowRepository._();

  /// Returns a list of [PushDevice]s matching the given query parameters.
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
  Future<List<PushDevice>> find(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<PushDevice>(
      where: where?.call(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [PushDevice] matching the given query parameters.
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
  Future<PushDevice?> findFirstRow(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<PushDevice>(
      where: where?.call(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      offset: offset,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [PushDevice] by its [id] or null if no such row exists.
  Future<PushDevice?> findById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    _is.Transaction? transaction,
    PushDeviceInclude? include,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<PushDevice>(
      id,
      transaction: transaction,
      include: include,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [PushDevice]s in the list and returns the inserted rows.
  ///
  /// The returned [PushDevice]s will have their `id` fields set.
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
  Future<List<PushDevice>> insert(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<PushDevice>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [PushDevice] and returns the inserted row.
  ///
  /// The returned [PushDevice] will have its `id` field set.
  Future<PushDevice> insertRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<PushDevice>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [PushDevice]s in the list and returns the resulting rows.
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
  /// The returned [PushDevice]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> upsert(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    required _is.ColumnSelections<PushDeviceTable> conflictColumns,
    _is.ColumnSelections<PushDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<PushDevice>(
      rows,
      conflictColumns: conflictColumns(PushDevice.t),
      updateColumns: updateColumns?.call(PushDevice.t),
      updateWhere: updateWhere?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [PushDevice] and returns the resulting row.
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
  /// The returned [PushDevice] will have its `id` field set.
  Future<PushDevice?> upsertRow(
    _is.DatabaseSession session,
    PushDevice row, {
    required _is.ColumnSelections<PushDeviceTable> conflictColumns,
    _is.ColumnSelections<PushDeviceTable>? updateColumns,
    _is.WhereExpressionBuilder<PushDeviceTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<PushDevice>(
      row,
      conflictColumns: conflictColumns(PushDevice.t),
      updateColumns: updateColumns?.call(PushDevice.t),
      updateWhere: updateWhere?.call(PushDevice.t),
      transaction: transaction,
    );
  }

  /// Updates all [PushDevice]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> update(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.ColumnSelections<PushDeviceTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<PushDevice>(
      rows,
      columns: columns?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [PushDevice]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<PushDevice> updateRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.ColumnSelections<PushDeviceTable>? columns,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateRow<PushDevice>(
      row,
      columns: columns?.call(PushDevice.t),
      transaction: transaction,
    );
  }

  /// Updates a single [PushDevice] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<PushDevice?> updateById(
    _is.DatabaseSession session,
    _is.UuidValue id, {
    required _is.ColumnValueListBuilder<PushDeviceUpdateTable> columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<PushDevice>(
      id,
      columnValues: columnValues(PushDevice.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [PushDevice]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<PushDevice>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<PushDeviceUpdateTable> columnValues,
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<PushDevice>(
      columnValues: columnValues(PushDevice.t.updateTable),
      where: where(PushDevice.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [PushDevice]s in the list and returns the deleted rows.
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
  Future<List<PushDevice>> delete(
    _is.DatabaseSession session,
    List<PushDevice> rows, {
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<PushDevice>(
      rows,
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [PushDevice].
  Future<PushDevice> deleteRow(
    _is.DatabaseSession session,
    PushDevice row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<PushDevice>(
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
  Future<List<PushDevice>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    _is.OrderByBuilder<PushDeviceTable>? orderBy,
    _is.OrderByListBuilder<PushDeviceTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<PushDevice>(
      where: where(PushDevice.t),
      orderBy: orderBy?.call(PushDevice.t),
      orderByList: orderByList?.call(PushDevice.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<PushDeviceTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<PushDevice>(
      where: where?.call(PushDevice.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [PushDevice] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<PushDeviceTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<PushDevice>(
      where: where(PushDevice.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}

class PushDeviceAttachRepository {
  const PushDeviceAttachRepository._();

  /// Creates a relation between this [PushDevice] and the given [PushDelivery]s
  /// by setting each [PushDelivery]'s foreign key `deviceId` to refer to this [PushDevice].
  Future<void> deliveries(
    _is.DatabaseSession session,
    PushDevice pushDevice,
    List<_i3bkdlz1.PushDelivery> pushDelivery, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.any((e) => e.id == null)) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (pushDevice.id == null) {
      throw ArgumentError.notNull('pushDevice.id');
    }

    var $pushDelivery = pushDelivery
        .map((e) => e.copyWith(deviceId: pushDevice.id))
        .toList();
    await session.db.update<_i3bkdlz1.PushDelivery>(
      $pushDelivery,
      columns: [_i3bkdlz1.PushDelivery.t.deviceId],
      transaction: transaction,
    );
  }
}

class PushDeviceAttachRowRepository {
  const PushDeviceAttachRowRepository._();

  /// Creates a relation between this [PushDevice] and the given [PushDelivery]
  /// by setting the [PushDelivery]'s foreign key `deviceId` to refer to this [PushDevice].
  Future<void> deliveries(
    _is.DatabaseSession session,
    PushDevice pushDevice,
    _i3bkdlz1.PushDelivery pushDelivery, {
    _is.Transaction? transaction,
  }) async {
    if (pushDelivery.id == null) {
      throw ArgumentError.notNull('pushDelivery.id');
    }
    if (pushDevice.id == null) {
      throw ArgumentError.notNull('pushDevice.id');
    }

    var $pushDelivery = pushDelivery.copyWith(deviceId: pushDevice.id);
    await session.db.updateRow<_i3bkdlz1.PushDelivery>(
      $pushDelivery,
      columns: [_i3bkdlz1.PushDelivery.t.deviceId],
      transaction: transaction,
    );
  }
}
