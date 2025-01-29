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
import '../../long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i2;
import '../../long_identifiers/deep_includes/city_with_long_table_name.dart'
    as _i3;

abstract class OrganizationWithLongTableName
    implements _i1.TableRow, _i1.ProtocolSerialization {
  OrganizationWithLongTableName._({
    this.id,
    required this.name,
    this.people,
    this.cityId,
    this.city,
  });

  factory OrganizationWithLongTableName({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i3.CityWithLongTableName? city,
  }) = _OrganizationWithLongTableNameImpl;

  factory OrganizationWithLongTableName.fromJson(
      Map<String, dynamic> jsonSerialization) {
    return OrganizationWithLongTableName(
      id: jsonSerialization['id'] as int?,
      name: jsonSerialization['name'] as String,
      people: (jsonSerialization['people'] as List?)
          ?.map((e) =>
              _i2.PersonWithLongTableName.fromJson((e as Map<String, dynamic>)))
          .toList(),
      cityId: jsonSerialization['cityId'] as int?,
      city: jsonSerialization['city'] == null
          ? null
          : _i3.CityWithLongTableName.fromJson(
              (jsonSerialization['city'] as Map<String, dynamic>)),
    );
  }

  static final t = OrganizationWithLongTableNameTable();

  static const db = OrganizationWithLongTableNameRepository._();

  @override
  int? id;

  String name;

  List<_i2.PersonWithLongTableName>? people;

  int? cityId;

  _i3.CityWithLongTableName? city;

  @override
  _i1.Table get table => t;

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  OrganizationWithLongTableName copyWith({
    int? id,
    String? name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i3.CityWithLongTableName? city,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJson()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      if (id != null) 'id': id,
      'name': name,
      if (people != null)
        'people': people?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
      if (cityId != null) 'cityId': cityId,
      if (city != null) 'city': city?.toJsonForProtocol(),
    };
  }

  static OrganizationWithLongTableNameInclude include({
    _i2.PersonWithLongTableNameIncludeList? people,
    _i3.CityWithLongTableNameInclude? city,
  }) {
    return OrganizationWithLongTableNameInclude._(
      people: people,
      city: city,
    );
  }

  static OrganizationWithLongTableNameIncludeList includeList({
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    OrganizationWithLongTableNameInclude? include,
  }) {
    return OrganizationWithLongTableNameIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _OrganizationWithLongTableNameImpl extends OrganizationWithLongTableName {
  _OrganizationWithLongTableNameImpl({
    int? id,
    required String name,
    List<_i2.PersonWithLongTableName>? people,
    int? cityId,
    _i3.CityWithLongTableName? city,
  }) : super._(
          id: id,
          name: name,
          people: people,
          cityId: cityId,
          city: city,
        );

  /// Returns a shallow copy of this [OrganizationWithLongTableName]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  OrganizationWithLongTableName copyWith({
    Object? id = _Undefined,
    String? name,
    Object? people = _Undefined,
    Object? cityId = _Undefined,
    Object? city = _Undefined,
  }) {
    return OrganizationWithLongTableName(
      id: id is int? ? id : this.id,
      name: name ?? this.name,
      people: people is List<_i2.PersonWithLongTableName>?
          ? people
          : this.people?.map((e0) => e0.copyWith()).toList(),
      cityId: cityId is int? ? cityId : this.cityId,
      city: city is _i3.CityWithLongTableName? ? city : this.city?.copyWith(),
    );
  }
}

class OrganizationWithLongTableNameTable extends _i1.Table {
  OrganizationWithLongTableNameTable({super.tableRelation})
      : super(
            tableName:
                'organization_with_long_table_name_that_is_still_valid') {
    name = _i1.ColumnString(
      'name',
      this,
    );
    cityId = _i1.ColumnInt(
      'cityId',
      this,
    );
  }

  late final _i1.ColumnString name;

  _i2.PersonWithLongTableNameTable? ___people;

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable>? _people;

  late final _i1.ColumnInt cityId;

  _i3.CityWithLongTableNameTable? _city;

  _i2.PersonWithLongTableNameTable get __people {
    if (___people != null) return ___people!;
    ___people = _i1.createRelationTable(
      relationFieldName: '__people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    return ___people!;
  }

  _i3.CityWithLongTableNameTable get city {
    if (_city != null) return _city!;
    _city = _i1.createRelationTable(
      relationFieldName: 'city',
      field: OrganizationWithLongTableName.t.cityId,
      foreignField: _i3.CityWithLongTableName.t.id,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i3.CityWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    return _city!;
  }

  _i1.ManyRelation<_i2.PersonWithLongTableNameTable> get people {
    if (_people != null) return _people!;
    var relationTable = _i1.createRelationTable(
      relationFieldName: 'people',
      field: OrganizationWithLongTableName.t.id,
      foreignField: _i2.PersonWithLongTableName.t.organizationId,
      tableRelation: tableRelation,
      createTable: (foreignTableRelation) =>
          _i2.PersonWithLongTableNameTable(tableRelation: foreignTableRelation),
    );
    _people = _i1.ManyRelation<_i2.PersonWithLongTableNameTable>(
      tableWithRelations: relationTable,
      table: _i2.PersonWithLongTableNameTable(
          tableRelation: relationTable.tableRelation!.lastRelation),
    );
    return _people!;
  }

  @override
  List<_i1.Column> get columns => [
        id,
        name,
        cityId,
      ];

  @override
  _i1.Table? getRelationTable(String relationField) {
    if (relationField == 'people') {
      return __people;
    }
    if (relationField == 'city') {
      return city;
    }
    return null;
  }
}

class OrganizationWithLongTableNameInclude extends _i1.IncludeObject {
  OrganizationWithLongTableNameInclude._({
    _i2.PersonWithLongTableNameIncludeList? people,
    _i3.CityWithLongTableNameInclude? city,
  }) {
    _people = people;
    _city = city;
  }

  _i2.PersonWithLongTableNameIncludeList? _people;

  _i3.CityWithLongTableNameInclude? _city;

  @override
  Map<String, _i1.Include?> get includes => {
        'people': _people,
        'city': _city,
      };

  @override
  _i1.Table get table => OrganizationWithLongTableName.t;
}

class OrganizationWithLongTableNameIncludeList extends _i1.IncludeList {
  OrganizationWithLongTableNameIncludeList._({
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(OrganizationWithLongTableName.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table get table => OrganizationWithLongTableName.t;
}

class OrganizationWithLongTableNameRepository {
  const OrganizationWithLongTableNameRepository._();

  final attach = const OrganizationWithLongTableNameAttachRepository._();

  final attachRow = const OrganizationWithLongTableNameAttachRowRepository._();

  final detach = const OrganizationWithLongTableNameDetachRepository._();

  final detachRow = const OrganizationWithLongTableNameDetachRowRepository._();

  /// Returns a list of [OrganizationWithLongTableName]s matching the given query parameters.
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
  Future<List<OrganizationWithLongTableName>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.db.find<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Returns the first matching [OrganizationWithLongTableName] matching the given query parameters.
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
  Future<OrganizationWithLongTableName?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? offset,
    _i1.OrderByBuilder<OrganizationWithLongTableNameTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<OrganizationWithLongTableNameTable>? orderByList,
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.db.findFirstRow<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      orderBy: orderBy?.call(OrganizationWithLongTableName.t),
      orderByList: orderByList?.call(OrganizationWithLongTableName.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      include: include,
    );
  }

  /// Finds a single [OrganizationWithLongTableName] by its [id] or null if no such row exists.
  Future<OrganizationWithLongTableName?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    OrganizationWithLongTableNameInclude? include,
  }) async {
    return session.db.findById<OrganizationWithLongTableName>(
      id,
      transaction: transaction,
      include: include,
    );
  }

  /// Inserts all [OrganizationWithLongTableName]s in the list and returns the inserted rows.
  ///
  /// The returned [OrganizationWithLongTableName]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  Future<List<OrganizationWithLongTableName>> insert(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insert<OrganizationWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  /// Inserts a single [OrganizationWithLongTableName] and returns the inserted row.
  ///
  /// The returned [OrganizationWithLongTableName] will have its `id` field set.
  Future<OrganizationWithLongTableName> insertRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<OrganizationWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [OrganizationWithLongTableName]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<OrganizationWithLongTableName>> update(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<OrganizationWithLongTableName>(
      rows,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Updates a single [OrganizationWithLongTableName]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<OrganizationWithLongTableName> updateRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.ColumnSelections<OrganizationWithLongTableNameTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<OrganizationWithLongTableName>(
      row,
      columns: columns?.call(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Deletes all [OrganizationWithLongTableName]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<OrganizationWithLongTableName>> delete(
    _i1.Session session,
    List<OrganizationWithLongTableName> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<OrganizationWithLongTableName>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [OrganizationWithLongTableName].
  Future<OrganizationWithLongTableName> deleteRow(
    _i1.Session session,
    OrganizationWithLongTableName row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<OrganizationWithLongTableName>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<OrganizationWithLongTableName>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>
        where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<OrganizationWithLongTableName>(
      where: where(OrganizationWithLongTableName.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<OrganizationWithLongTableNameTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<OrganizationWithLongTableName>(
      where: where?.call(OrganizationWithLongTableName.t),
      limit: limit,
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameAttachRepository {
  const OrganizationWithLongTableNameAttachRepository._();

  /// Creates a relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]s
  /// by setting each [PersonWithLongTableName]'s foreign key `organizationId` to refer to this [OrganizationWithLongTableName].
  Future<void> people(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    List<_i2.PersonWithLongTableName> personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map(
            (e) => e.copyWith(organizationId: organizationWithLongTableName.id))
        .toList();
    await session.db.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameAttachRowRepository {
  const OrganizationWithLongTableNameAttachRowRepository._();

  /// Creates a relation between the given [OrganizationWithLongTableName] and [CityWithLongTableName]
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to refer to the [CityWithLongTableName].
  Future<void> city(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _i3.CityWithLongTableName city, {
    _i1.Transaction? transaction,
  }) async {
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }
    if (city.id == null) {
      throw ArgumentError.notNull('city.id');
    }

    var $organizationWithLongTableName =
        organizationWithLongTableName.copyWith(cityId: city.id);
    await session.db.updateRow<OrganizationWithLongTableName>(
      $organizationWithLongTableName,
      columns: [OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }

  /// Creates a relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to refer to this [OrganizationWithLongTableName].
  Future<void> people(
    _i1.Session session,
    OrganizationWithLongTableName organizationWithLongTableName,
    _i2.PersonWithLongTableName personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }
    if (organizationWithLongTableName.id == null) {
      throw ArgumentError.notNull('organizationWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName.copyWith(
        organizationId: organizationWithLongTableName.id);
    await session.db.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameDetachRepository {
  const OrganizationWithLongTableNameDetachRepository._();

  /// Detaches the relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _i1.Session session,
    List<_i2.PersonWithLongTableName> personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.any((e) => e.id == null)) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName = personWithLongTableName
        .map((e) => e.copyWith(organizationId: null))
        .toList();
    await session.db.update<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}

class OrganizationWithLongTableNameDetachRowRepository {
  const OrganizationWithLongTableNameDetachRowRepository._();

  /// Detaches the relation between this [OrganizationWithLongTableName] and the [CityWithLongTableName] set in `city`
  /// by setting the [OrganizationWithLongTableName]'s foreign key `cityId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> city(
    _i1.Session session,
    OrganizationWithLongTableName organizationwithlongtablename, {
    _i1.Transaction? transaction,
  }) async {
    if (organizationwithlongtablename.id == null) {
      throw ArgumentError.notNull('organizationwithlongtablename.id');
    }

    var $organizationwithlongtablename =
        organizationwithlongtablename.copyWith(cityId: null);
    await session.db.updateRow<OrganizationWithLongTableName>(
      $organizationwithlongtablename,
      columns: [OrganizationWithLongTableName.t.cityId],
      transaction: transaction,
    );
  }

  /// Detaches the relation between this [OrganizationWithLongTableName] and the given [PersonWithLongTableName]
  /// by setting the [PersonWithLongTableName]'s foreign key `organizationId` to `null`.
  ///
  /// This removes the association between the two models without deleting
  /// the related record.
  Future<void> people(
    _i1.Session session,
    _i2.PersonWithLongTableName personWithLongTableName, {
    _i1.Transaction? transaction,
  }) async {
    if (personWithLongTableName.id == null) {
      throw ArgumentError.notNull('personWithLongTableName.id');
    }

    var $personWithLongTableName =
        personWithLongTableName.copyWith(organizationId: null);
    await session.db.updateRow<_i2.PersonWithLongTableName>(
      $personWithLongTableName,
      columns: [_i2.PersonWithLongTableName.t.organizationId],
      transaction: transaction,
    );
  }
}
