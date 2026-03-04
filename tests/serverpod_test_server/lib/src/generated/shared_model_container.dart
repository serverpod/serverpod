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
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;
import 'shared_model_subclass.dart' as _i3;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _i4;

abstract class SharedModelContainer
    implements _i1.TableRow<int?>, _i1.ProtocolSerialization {
  SharedModelContainer._({
    this.id,
    required this.sharedModel,
    required this.sharedModelWithModuleAlias,
    this.sharedModelNullable,
    this.nonPersistedSharedModel,
    this.serverOnlySharedModel,
    required this.sharedSubclass,
    this.sharedSubclassNullable,
    required this.sharedEnum,
    this.sharedEnumNullable,
    required this.sharedSealedParent,
    this.sharedSealedParentNullable,
    required this.sharedSealedChild,
    this.sharedSealedChildNullable,
    required this.sharedModelSubclass,
    this.sharedModelSubclassNullable,
    required this.sharedModelList,
    required this.sharedModelNullableList,
    this.sharedModelListNullable,
    required this.sharedModelMap,
    this.sharedModelMapNullable,
    required this.sharedSubclassMap,
    required this.sharedModelSet,
    this.sharedModelSetNullable,
  });

  factory SharedModelContainer({
    int? id,
    required _i2.SharedModel sharedModel,
    required _i2.SharedModel sharedModelWithModuleAlias,
    _i2.SharedModel? sharedModelNullable,
    _i2.SharedModel? nonPersistedSharedModel,
    _i2.SharedModel? serverOnlySharedModel,
    required _i2.SharedSubclass sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    required _i2.SharedEnum sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    required _i2.SharedSealedParent sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    required _i2.SharedSealedChild sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
    required _i3.SharedModelSubclass sharedModelSubclass,
    _i3.SharedModelSubclass? sharedModelSubclassNullable,
    required List<_i2.SharedModel> sharedModelList,
    required List<_i2.SharedModel?> sharedModelNullableList,
    List<_i2.SharedModel>? sharedModelListNullable,
    required Map<String, _i2.SharedModel> sharedModelMap,
    Map<String, _i2.SharedModel>? sharedModelMapNullable,
    required Map<String, _i2.SharedSubclass> sharedSubclassMap,
    required Set<_i2.SharedModel> sharedModelSet,
    Set<_i2.SharedModel>? sharedModelSetNullable,
  }) = _SharedModelContainerImpl;

  factory SharedModelContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedModelContainer(
      id: jsonSerialization['id'] as int?,
      sharedModel: _i4.Protocol().deserialize<_i2.SharedModel>(
        jsonSerialization['sharedModel'],
      ),
      sharedModelWithModuleAlias: _i4.Protocol().deserialize<_i2.SharedModel>(
        jsonSerialization['sharedModelWithModuleAlias'],
      ),
      sharedModelNullable: jsonSerialization['sharedModelNullable'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedModel>(
              jsonSerialization['sharedModelNullable'],
            ),
      nonPersistedSharedModel:
          jsonSerialization['nonPersistedSharedModel'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedModel>(
              jsonSerialization['nonPersistedSharedModel'],
            ),
      serverOnlySharedModel: jsonSerialization['serverOnlySharedModel'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedModel>(
              jsonSerialization['serverOnlySharedModel'],
            ),
      sharedSubclass: _i4.Protocol().deserialize<_i2.SharedSubclass>(
        jsonSerialization['sharedSubclass'],
      ),
      sharedSubclassNullable:
          jsonSerialization['sharedSubclassNullable'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedSubclass>(
              jsonSerialization['sharedSubclassNullable'],
            ),
      sharedEnum: _i2.SharedEnum.fromJson(
        (jsonSerialization['sharedEnum'] as String),
      ),
      sharedEnumNullable: jsonSerialization['sharedEnumNullable'] == null
          ? null
          : _i2.SharedEnum.fromJson(
              (jsonSerialization['sharedEnumNullable'] as String),
            ),
      sharedSealedParent: _i4.Protocol().deserialize<_i2.SharedSealedParent>(
        jsonSerialization['sharedSealedParent'],
      ),
      sharedSealedParentNullable:
          jsonSerialization['sharedSealedParentNullable'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedSealedParent>(
              jsonSerialization['sharedSealedParentNullable'],
            ),
      sharedSealedChild: _i4.Protocol().deserialize<_i2.SharedSealedChild>(
        jsonSerialization['sharedSealedChild'],
      ),
      sharedSealedChildNullable:
          jsonSerialization['sharedSealedChildNullable'] == null
          ? null
          : _i4.Protocol().deserialize<_i2.SharedSealedChild>(
              jsonSerialization['sharedSealedChildNullable'],
            ),
      sharedModelSubclass: _i4.Protocol().deserialize<_i3.SharedModelSubclass>(
        jsonSerialization['sharedModelSubclass'],
      ),
      sharedModelSubclassNullable:
          jsonSerialization['sharedModelSubclassNullable'] == null
          ? null
          : _i4.Protocol().deserialize<_i3.SharedModelSubclass>(
              jsonSerialization['sharedModelSubclassNullable'],
            ),
      sharedModelList: _i4.Protocol().deserialize<List<_i2.SharedModel>>(
        jsonSerialization['sharedModelList'],
      ),
      sharedModelNullableList: _i4.Protocol()
          .deserialize<List<_i2.SharedModel?>>(
            jsonSerialization['sharedModelNullableList'],
          ),
      sharedModelListNullable:
          jsonSerialization['sharedModelListNullable'] == null
          ? null
          : _i4.Protocol().deserialize<List<_i2.SharedModel>>(
              jsonSerialization['sharedModelListNullable'],
            ),
      sharedModelMap: _i4.Protocol().deserialize<Map<String, _i2.SharedModel>>(
        jsonSerialization['sharedModelMap'],
      ),
      sharedModelMapNullable:
          jsonSerialization['sharedModelMapNullable'] == null
          ? null
          : _i4.Protocol().deserialize<Map<String, _i2.SharedModel>>(
              jsonSerialization['sharedModelMapNullable'],
            ),
      sharedSubclassMap: _i4.Protocol()
          .deserialize<Map<String, _i2.SharedSubclass>>(
            jsonSerialization['sharedSubclassMap'],
          ),
      sharedModelSet: _i4.Protocol().deserialize<Set<_i2.SharedModel>>(
        jsonSerialization['sharedModelSet'],
      ),
      sharedModelSetNullable:
          jsonSerialization['sharedModelSetNullable'] == null
          ? null
          : _i4.Protocol().deserialize<Set<_i2.SharedModel>>(
              jsonSerialization['sharedModelSetNullable'],
            ),
    );
  }

  static final t = SharedModelContainerTable();

  static const db = SharedModelContainerRepository._();

  @override
  int? id;

  _i2.SharedModel sharedModel;

  _i2.SharedModel sharedModelWithModuleAlias;

  _i2.SharedModel? sharedModelNullable;

  _i2.SharedModel? nonPersistedSharedModel;

  _i2.SharedModel? serverOnlySharedModel;

  _i2.SharedSubclass sharedSubclass;

  _i2.SharedSubclass? sharedSubclassNullable;

  _i2.SharedEnum sharedEnum;

  _i2.SharedEnum? sharedEnumNullable;

  _i2.SharedSealedParent sharedSealedParent;

  _i2.SharedSealedParent? sharedSealedParentNullable;

  _i2.SharedSealedChild sharedSealedChild;

  _i2.SharedSealedChild? sharedSealedChildNullable;

  _i3.SharedModelSubclass sharedModelSubclass;

  _i3.SharedModelSubclass? sharedModelSubclassNullable;

  List<_i2.SharedModel> sharedModelList;

  List<_i2.SharedModel?> sharedModelNullableList;

  List<_i2.SharedModel>? sharedModelListNullable;

  Map<String, _i2.SharedModel> sharedModelMap;

  Map<String, _i2.SharedModel>? sharedModelMapNullable;

  Map<String, _i2.SharedSubclass> sharedSubclassMap;

  Set<_i2.SharedModel> sharedModelSet;

  Set<_i2.SharedModel>? sharedModelSetNullable;

  @override
  _i1.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedModelContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedModelContainer copyWith({
    int? id,
    _i2.SharedModel? sharedModel,
    _i2.SharedModel? sharedModelWithModuleAlias,
    _i2.SharedModel? sharedModelNullable,
    _i2.SharedModel? nonPersistedSharedModel,
    _i2.SharedModel? serverOnlySharedModel,
    _i2.SharedSubclass? sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    _i2.SharedEnum? sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    _i2.SharedSealedParent? sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    _i2.SharedSealedChild? sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
    _i3.SharedModelSubclass? sharedModelSubclass,
    _i3.SharedModelSubclass? sharedModelSubclassNullable,
    List<_i2.SharedModel>? sharedModelList,
    List<_i2.SharedModel?>? sharedModelNullableList,
    List<_i2.SharedModel>? sharedModelListNullable,
    Map<String, _i2.SharedModel>? sharedModelMap,
    Map<String, _i2.SharedModel>? sharedModelMapNullable,
    Map<String, _i2.SharedSubclass>? sharedSubclassMap,
    Set<_i2.SharedModel>? sharedModelSet,
    Set<_i2.SharedModel>? sharedModelSetNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedModelContainer',
      if (id != null) 'id': id,
      'sharedModel': sharedModel.toJson(),
      'sharedModelWithModuleAlias': sharedModelWithModuleAlias.toJson(),
      if (sharedModelNullable != null)
        'sharedModelNullable': sharedModelNullable?.toJson(),
      if (nonPersistedSharedModel != null)
        'nonPersistedSharedModel': nonPersistedSharedModel?.toJson(),
      if (serverOnlySharedModel != null)
        'serverOnlySharedModel': serverOnlySharedModel?.toJson(),
      'sharedSubclass': sharedSubclass.toJson(),
      if (sharedSubclassNullable != null)
        'sharedSubclassNullable': sharedSubclassNullable?.toJson(),
      'sharedEnum': sharedEnum.toJson(),
      if (sharedEnumNullable != null)
        'sharedEnumNullable': sharedEnumNullable?.toJson(),
      'sharedSealedParent': sharedSealedParent.toJson(),
      if (sharedSealedParentNullable != null)
        'sharedSealedParentNullable': sharedSealedParentNullable?.toJson(),
      'sharedSealedChild': sharedSealedChild.toJson(),
      if (sharedSealedChildNullable != null)
        'sharedSealedChildNullable': sharedSealedChildNullable?.toJson(),
      'sharedModelSubclass': sharedModelSubclass.toJson(),
      if (sharedModelSubclassNullable != null)
        'sharedModelSubclassNullable': sharedModelSubclassNullable?.toJson(),
      'sharedModelList': sharedModelList.toJson(valueToJson: (v) => v.toJson()),
      'sharedModelNullableList': sharedModelNullableList.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (sharedModelListNullable != null)
        'sharedModelListNullable': sharedModelListNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'sharedModelMap': sharedModelMap.toJson(valueToJson: (v) => v.toJson()),
      if (sharedModelMapNullable != null)
        'sharedModelMapNullable': sharedModelMapNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'sharedSubclassMap': sharedSubclassMap.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'sharedModelSet': sharedModelSet.toJson(valueToJson: (v) => v.toJson()),
      if (sharedModelSetNullable != null)
        'sharedModelSetNullable': sharedModelSetNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedModelContainer',
      if (id != null) 'id': id,
      'sharedModel': sharedModel.toJson(),
      'sharedModelWithModuleAlias': sharedModelWithModuleAlias.toJson(),
      if (sharedModelNullable != null)
        'sharedModelNullable': sharedModelNullable?.toJson(),
      if (nonPersistedSharedModel != null)
        'nonPersistedSharedModel': nonPersistedSharedModel?.toJson(),
      'sharedSubclass': sharedSubclass.toJson(),
      if (sharedSubclassNullable != null)
        'sharedSubclassNullable': sharedSubclassNullable?.toJson(),
      'sharedEnum': sharedEnum.toJson(),
      if (sharedEnumNullable != null)
        'sharedEnumNullable': sharedEnumNullable?.toJson(),
      'sharedSealedParent': sharedSealedParent.toJson(),
      if (sharedSealedParentNullable != null)
        'sharedSealedParentNullable': sharedSealedParentNullable?.toJson(),
      'sharedSealedChild': sharedSealedChild.toJson(),
      if (sharedSealedChildNullable != null)
        'sharedSealedChildNullable': sharedSealedChildNullable?.toJson(),
      'sharedModelSubclass': sharedModelSubclass.toJsonForProtocol(),
      if (sharedModelSubclassNullable != null)
        'sharedModelSubclassNullable': sharedModelSubclassNullable
            ?.toJsonForProtocol(),
      'sharedModelList': sharedModelList.toJson(valueToJson: (v) => v.toJson()),
      'sharedModelNullableList': sharedModelNullableList.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      if (sharedModelListNullable != null)
        'sharedModelListNullable': sharedModelListNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'sharedModelMap': sharedModelMap.toJson(valueToJson: (v) => v.toJson()),
      if (sharedModelMapNullable != null)
        'sharedModelMapNullable': sharedModelMapNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
      'sharedSubclassMap': sharedSubclassMap.toJson(
        valueToJson: (v) => v.toJson(),
      ),
      'sharedModelSet': sharedModelSet.toJson(valueToJson: (v) => v.toJson()),
      if (sharedModelSetNullable != null)
        'sharedModelSetNullable': sharedModelSetNullable?.toJson(
          valueToJson: (v) => v.toJson(),
        ),
    };
  }

  static SharedModelContainerInclude include() {
    return SharedModelContainerInclude._();
  }

  static SharedModelContainerIncludeList includeList({
    _i1.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedModelContainerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    SharedModelContainerInclude? include,
  }) {
    return SharedModelContainerIncludeList._(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderDescending: orderDescending,
      orderByList: orderByList?.call(SharedModelContainer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedModelContainerImpl extends SharedModelContainer {
  _SharedModelContainerImpl({
    int? id,
    required _i2.SharedModel sharedModel,
    required _i2.SharedModel sharedModelWithModuleAlias,
    _i2.SharedModel? sharedModelNullable,
    _i2.SharedModel? nonPersistedSharedModel,
    _i2.SharedModel? serverOnlySharedModel,
    required _i2.SharedSubclass sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    required _i2.SharedEnum sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    required _i2.SharedSealedParent sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    required _i2.SharedSealedChild sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
    required _i3.SharedModelSubclass sharedModelSubclass,
    _i3.SharedModelSubclass? sharedModelSubclassNullable,
    required List<_i2.SharedModel> sharedModelList,
    required List<_i2.SharedModel?> sharedModelNullableList,
    List<_i2.SharedModel>? sharedModelListNullable,
    required Map<String, _i2.SharedModel> sharedModelMap,
    Map<String, _i2.SharedModel>? sharedModelMapNullable,
    required Map<String, _i2.SharedSubclass> sharedSubclassMap,
    required Set<_i2.SharedModel> sharedModelSet,
    Set<_i2.SharedModel>? sharedModelSetNullable,
  }) : super._(
         id: id,
         sharedModel: sharedModel,
         sharedModelWithModuleAlias: sharedModelWithModuleAlias,
         sharedModelNullable: sharedModelNullable,
         nonPersistedSharedModel: nonPersistedSharedModel,
         serverOnlySharedModel: serverOnlySharedModel,
         sharedSubclass: sharedSubclass,
         sharedSubclassNullable: sharedSubclassNullable,
         sharedEnum: sharedEnum,
         sharedEnumNullable: sharedEnumNullable,
         sharedSealedParent: sharedSealedParent,
         sharedSealedParentNullable: sharedSealedParentNullable,
         sharedSealedChild: sharedSealedChild,
         sharedSealedChildNullable: sharedSealedChildNullable,
         sharedModelSubclass: sharedModelSubclass,
         sharedModelSubclassNullable: sharedModelSubclassNullable,
         sharedModelList: sharedModelList,
         sharedModelNullableList: sharedModelNullableList,
         sharedModelListNullable: sharedModelListNullable,
         sharedModelMap: sharedModelMap,
         sharedModelMapNullable: sharedModelMapNullable,
         sharedSubclassMap: sharedSubclassMap,
         sharedModelSet: sharedModelSet,
         sharedModelSetNullable: sharedModelSetNullable,
       );

  /// Returns a shallow copy of this [SharedModelContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedModelContainer copyWith({
    Object? id = _Undefined,
    _i2.SharedModel? sharedModel,
    _i2.SharedModel? sharedModelWithModuleAlias,
    Object? sharedModelNullable = _Undefined,
    Object? nonPersistedSharedModel = _Undefined,
    Object? serverOnlySharedModel = _Undefined,
    _i2.SharedSubclass? sharedSubclass,
    Object? sharedSubclassNullable = _Undefined,
    _i2.SharedEnum? sharedEnum,
    Object? sharedEnumNullable = _Undefined,
    _i2.SharedSealedParent? sharedSealedParent,
    Object? sharedSealedParentNullable = _Undefined,
    _i2.SharedSealedChild? sharedSealedChild,
    Object? sharedSealedChildNullable = _Undefined,
    _i3.SharedModelSubclass? sharedModelSubclass,
    Object? sharedModelSubclassNullable = _Undefined,
    List<_i2.SharedModel>? sharedModelList,
    List<_i2.SharedModel?>? sharedModelNullableList,
    Object? sharedModelListNullable = _Undefined,
    Map<String, _i2.SharedModel>? sharedModelMap,
    Object? sharedModelMapNullable = _Undefined,
    Map<String, _i2.SharedSubclass>? sharedSubclassMap,
    Set<_i2.SharedModel>? sharedModelSet,
    Object? sharedModelSetNullable = _Undefined,
  }) {
    return SharedModelContainer(
      id: id is int? ? id : this.id,
      sharedModel: sharedModel ?? this.sharedModel.copyWith(),
      sharedModelWithModuleAlias:
          sharedModelWithModuleAlias ??
          this.sharedModelWithModuleAlias.copyWith(),
      sharedModelNullable: sharedModelNullable is _i2.SharedModel?
          ? sharedModelNullable
          : this.sharedModelNullable?.copyWith(),
      nonPersistedSharedModel: nonPersistedSharedModel is _i2.SharedModel?
          ? nonPersistedSharedModel
          : this.nonPersistedSharedModel?.copyWith(),
      serverOnlySharedModel: serverOnlySharedModel is _i2.SharedModel?
          ? serverOnlySharedModel
          : this.serverOnlySharedModel?.copyWith(),
      sharedSubclass: sharedSubclass ?? this.sharedSubclass.copyWith(),
      sharedSubclassNullable: sharedSubclassNullable is _i2.SharedSubclass?
          ? sharedSubclassNullable
          : this.sharedSubclassNullable?.copyWith(),
      sharedEnum: sharedEnum ?? this.sharedEnum,
      sharedEnumNullable: sharedEnumNullable is _i2.SharedEnum?
          ? sharedEnumNullable
          : this.sharedEnumNullable,
      sharedSealedParent:
          sharedSealedParent ?? this.sharedSealedParent.copyWith(),
      sharedSealedParentNullable:
          sharedSealedParentNullable is _i2.SharedSealedParent?
          ? sharedSealedParentNullable
          : this.sharedSealedParentNullable?.copyWith(),
      sharedSealedChild: sharedSealedChild ?? this.sharedSealedChild.copyWith(),
      sharedSealedChildNullable:
          sharedSealedChildNullable is _i2.SharedSealedChild?
          ? sharedSealedChildNullable
          : this.sharedSealedChildNullable?.copyWith(),
      sharedModelSubclass:
          sharedModelSubclass ?? this.sharedModelSubclass.copyWith(),
      sharedModelSubclassNullable:
          sharedModelSubclassNullable is _i3.SharedModelSubclass?
          ? sharedModelSubclassNullable
          : this.sharedModelSubclassNullable?.copyWith(),
      sharedModelList:
          sharedModelList ??
          this.sharedModelList.map((e0) => e0.copyWith()).toList(),
      sharedModelNullableList:
          sharedModelNullableList ??
          this.sharedModelNullableList.map((e0) => e0?.copyWith()).toList(),
      sharedModelListNullable: sharedModelListNullable is List<_i2.SharedModel>?
          ? sharedModelListNullable
          : this.sharedModelListNullable?.map((e0) => e0.copyWith()).toList(),
      sharedModelMap:
          sharedModelMap ??
          this.sharedModelMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
      sharedModelMapNullable:
          sharedModelMapNullable is Map<String, _i2.SharedModel>?
          ? sharedModelMapNullable
          : this.sharedModelMapNullable?.map(
              (
                key0,
                value0,
              ) => MapEntry(
                key0,
                value0.copyWith(),
              ),
            ),
      sharedSubclassMap:
          sharedSubclassMap ??
          this.sharedSubclassMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
      sharedModelSet:
          sharedModelSet ??
          this.sharedModelSet.map((e0) => e0.copyWith()).toSet(),
      sharedModelSetNullable: sharedModelSetNullable is Set<_i2.SharedModel>?
          ? sharedModelSetNullable
          : this.sharedModelSetNullable?.map((e0) => e0.copyWith()).toSet(),
    );
  }
}

class SharedModelContainerUpdateTable
    extends _i1.UpdateTable<SharedModelContainerTable> {
  SharedModelContainerUpdateTable(super.table);

  _i1.ColumnValue<_i2.SharedModel, _i2.SharedModel> sharedModel(
    _i2.SharedModel value,
  ) => _i1.ColumnValue(
    table.sharedModel,
    value,
  );

  _i1.ColumnValue<_i2.SharedModel, _i2.SharedModel> sharedModelWithModuleAlias(
    _i2.SharedModel value,
  ) => _i1.ColumnValue(
    table.sharedModelWithModuleAlias,
    value,
  );

  _i1.ColumnValue<_i2.SharedModel, _i2.SharedModel> sharedModelNullable(
    _i2.SharedModel? value,
  ) => _i1.ColumnValue(
    table.sharedModelNullable,
    value,
  );

  _i1.ColumnValue<_i2.SharedModel, _i2.SharedModel> serverOnlySharedModel(
    _i2.SharedModel? value,
  ) => _i1.ColumnValue(
    table.serverOnlySharedModel,
    value,
  );

  _i1.ColumnValue<_i2.SharedSubclass, _i2.SharedSubclass> sharedSubclass(
    _i2.SharedSubclass value,
  ) => _i1.ColumnValue(
    table.sharedSubclass,
    value,
  );

  _i1.ColumnValue<_i2.SharedSubclass, _i2.SharedSubclass>
  sharedSubclassNullable(_i2.SharedSubclass? value) => _i1.ColumnValue(
    table.sharedSubclassNullable,
    value,
  );

  _i1.ColumnValue<_i2.SharedEnum, _i2.SharedEnum> sharedEnum(
    _i2.SharedEnum value,
  ) => _i1.ColumnValue(
    table.sharedEnum,
    value,
  );

  _i1.ColumnValue<_i2.SharedEnum, _i2.SharedEnum> sharedEnumNullable(
    _i2.SharedEnum? value,
  ) => _i1.ColumnValue(
    table.sharedEnumNullable,
    value,
  );

  _i1.ColumnValue<_i2.SharedSealedParent, _i2.SharedSealedParent>
  sharedSealedParent(_i2.SharedSealedParent value) => _i1.ColumnValue(
    table.sharedSealedParent,
    value,
  );

  _i1.ColumnValue<_i2.SharedSealedParent, _i2.SharedSealedParent>
  sharedSealedParentNullable(_i2.SharedSealedParent? value) => _i1.ColumnValue(
    table.sharedSealedParentNullable,
    value,
  );

  _i1.ColumnValue<_i2.SharedSealedChild, _i2.SharedSealedChild>
  sharedSealedChild(_i2.SharedSealedChild value) => _i1.ColumnValue(
    table.sharedSealedChild,
    value,
  );

  _i1.ColumnValue<_i2.SharedSealedChild, _i2.SharedSealedChild>
  sharedSealedChildNullable(_i2.SharedSealedChild? value) => _i1.ColumnValue(
    table.sharedSealedChildNullable,
    value,
  );

  _i1.ColumnValue<_i3.SharedModelSubclass, _i3.SharedModelSubclass>
  sharedModelSubclass(_i3.SharedModelSubclass value) => _i1.ColumnValue(
    table.sharedModelSubclass,
    value,
  );

  _i1.ColumnValue<_i3.SharedModelSubclass, _i3.SharedModelSubclass>
  sharedModelSubclassNullable(_i3.SharedModelSubclass? value) =>
      _i1.ColumnValue(
        table.sharedModelSubclassNullable,
        value,
      );

  _i1.ColumnValue<List<_i2.SharedModel>, List<_i2.SharedModel>> sharedModelList(
    List<_i2.SharedModel> value,
  ) => _i1.ColumnValue(
    table.sharedModelList,
    value,
  );

  _i1.ColumnValue<List<_i2.SharedModel?>, List<_i2.SharedModel?>>
  sharedModelNullableList(List<_i2.SharedModel?> value) => _i1.ColumnValue(
    table.sharedModelNullableList,
    value,
  );

  _i1.ColumnValue<List<_i2.SharedModel>, List<_i2.SharedModel>>
  sharedModelListNullable(List<_i2.SharedModel>? value) => _i1.ColumnValue(
    table.sharedModelListNullable,
    value,
  );

  _i1.ColumnValue<Map<String, _i2.SharedModel>, Map<String, _i2.SharedModel>>
  sharedModelMap(Map<String, _i2.SharedModel> value) => _i1.ColumnValue(
    table.sharedModelMap,
    value,
  );

  _i1.ColumnValue<Map<String, _i2.SharedModel>, Map<String, _i2.SharedModel>>
  sharedModelMapNullable(Map<String, _i2.SharedModel>? value) =>
      _i1.ColumnValue(
        table.sharedModelMapNullable,
        value,
      );

  _i1.ColumnValue<
    Map<String, _i2.SharedSubclass>,
    Map<String, _i2.SharedSubclass>
  >
  sharedSubclassMap(Map<String, _i2.SharedSubclass> value) => _i1.ColumnValue(
    table.sharedSubclassMap,
    value,
  );

  _i1.ColumnValue<Set<_i2.SharedModel>, Set<_i2.SharedModel>> sharedModelSet(
    Set<_i2.SharedModel> value,
  ) => _i1.ColumnValue(
    table.sharedModelSet,
    value,
  );

  _i1.ColumnValue<Set<_i2.SharedModel>, Set<_i2.SharedModel>>
  sharedModelSetNullable(Set<_i2.SharedModel>? value) => _i1.ColumnValue(
    table.sharedModelSetNullable,
    value,
  );
}

class SharedModelContainerTable extends _i1.Table<int?> {
  SharedModelContainerTable({super.tableRelation})
    : super(tableName: 'shared_model_container') {
    updateTable = SharedModelContainerUpdateTable(this);
    sharedModel = _i1.ColumnSerializable<_i2.SharedModel>(
      'sharedModel',
      this,
    );
    sharedModelWithModuleAlias = _i1.ColumnSerializable<_i2.SharedModel>(
      'sharedModelWithModuleAlias',
      this,
    );
    sharedModelNullable = _i1.ColumnSerializable<_i2.SharedModel>(
      'sharedModelNullable',
      this,
    );
    serverOnlySharedModel = _i1.ColumnSerializable<_i2.SharedModel>(
      'serverOnlySharedModel',
      this,
    );
    sharedSubclass = _i1.ColumnSerializable<_i2.SharedSubclass>(
      'sharedSubclass',
      this,
    );
    sharedSubclassNullable = _i1.ColumnSerializable<_i2.SharedSubclass>(
      'sharedSubclassNullable',
      this,
    );
    sharedEnum = _i1.ColumnEnum(
      'sharedEnum',
      this,
      _i1.EnumSerialization.byName,
    );
    sharedEnumNullable = _i1.ColumnEnum(
      'sharedEnumNullable',
      this,
      _i1.EnumSerialization.byName,
    );
    sharedSealedParent = _i1.ColumnSerializable<_i2.SharedSealedParent>(
      'sharedSealedParent',
      this,
    );
    sharedSealedParentNullable = _i1.ColumnSerializable<_i2.SharedSealedParent>(
      'sharedSealedParentNullable',
      this,
    );
    sharedSealedChild = _i1.ColumnSerializable<_i2.SharedSealedChild>(
      'sharedSealedChild',
      this,
    );
    sharedSealedChildNullable = _i1.ColumnSerializable<_i2.SharedSealedChild>(
      'sharedSealedChildNullable',
      this,
    );
    sharedModelSubclass = _i1.ColumnSerializable<_i3.SharedModelSubclass>(
      'sharedModelSubclass',
      this,
    );
    sharedModelSubclassNullable =
        _i1.ColumnSerializable<_i3.SharedModelSubclass>(
          'sharedModelSubclassNullable',
          this,
        );
    sharedModelList = _i1.ColumnSerializable<List<_i2.SharedModel>>(
      'sharedModelList',
      this,
    );
    sharedModelNullableList = _i1.ColumnSerializable<List<_i2.SharedModel?>>(
      'sharedModelNullableList',
      this,
    );
    sharedModelListNullable = _i1.ColumnSerializable<List<_i2.SharedModel>>(
      'sharedModelListNullable',
      this,
    );
    sharedModelMap = _i1.ColumnSerializable<Map<String, _i2.SharedModel>>(
      'sharedModelMap',
      this,
    );
    sharedModelMapNullable =
        _i1.ColumnSerializable<Map<String, _i2.SharedModel>>(
          'sharedModelMapNullable',
          this,
        );
    sharedSubclassMap = _i1.ColumnSerializable<Map<String, _i2.SharedSubclass>>(
      'sharedSubclassMap',
      this,
    );
    sharedModelSet = _i1.ColumnSerializable<Set<_i2.SharedModel>>(
      'sharedModelSet',
      this,
    );
    sharedModelSetNullable = _i1.ColumnSerializable<Set<_i2.SharedModel>>(
      'sharedModelSetNullable',
      this,
    );
  }

  late final SharedModelContainerUpdateTable updateTable;

  late final _i1.ColumnSerializable<_i2.SharedModel> sharedModel;

  late final _i1.ColumnSerializable<_i2.SharedModel> sharedModelWithModuleAlias;

  late final _i1.ColumnSerializable<_i2.SharedModel> sharedModelNullable;

  late final _i1.ColumnSerializable<_i2.SharedModel> serverOnlySharedModel;

  late final _i1.ColumnSerializable<_i2.SharedSubclass> sharedSubclass;

  late final _i1.ColumnSerializable<_i2.SharedSubclass> sharedSubclassNullable;

  late final _i1.ColumnEnum<_i2.SharedEnum> sharedEnum;

  late final _i1.ColumnEnum<_i2.SharedEnum> sharedEnumNullable;

  late final _i1.ColumnSerializable<_i2.SharedSealedParent> sharedSealedParent;

  late final _i1.ColumnSerializable<_i2.SharedSealedParent>
  sharedSealedParentNullable;

  late final _i1.ColumnSerializable<_i2.SharedSealedChild> sharedSealedChild;

  late final _i1.ColumnSerializable<_i2.SharedSealedChild>
  sharedSealedChildNullable;

  late final _i1.ColumnSerializable<_i3.SharedModelSubclass>
  sharedModelSubclass;

  late final _i1.ColumnSerializable<_i3.SharedModelSubclass>
  sharedModelSubclassNullable;

  late final _i1.ColumnSerializable<List<_i2.SharedModel>> sharedModelList;

  late final _i1.ColumnSerializable<List<_i2.SharedModel?>>
  sharedModelNullableList;

  late final _i1.ColumnSerializable<List<_i2.SharedModel>>
  sharedModelListNullable;

  late final _i1.ColumnSerializable<Map<String, _i2.SharedModel>>
  sharedModelMap;

  late final _i1.ColumnSerializable<Map<String, _i2.SharedModel>>
  sharedModelMapNullable;

  late final _i1.ColumnSerializable<Map<String, _i2.SharedSubclass>>
  sharedSubclassMap;

  late final _i1.ColumnSerializable<Set<_i2.SharedModel>> sharedModelSet;

  late final _i1.ColumnSerializable<Set<_i2.SharedModel>>
  sharedModelSetNullable;

  @override
  List<_i1.Column> get columns => [
    id,
    sharedModel,
    sharedModelWithModuleAlias,
    sharedModelNullable,
    serverOnlySharedModel,
    sharedSubclass,
    sharedSubclassNullable,
    sharedEnum,
    sharedEnumNullable,
    sharedSealedParent,
    sharedSealedParentNullable,
    sharedSealedChild,
    sharedSealedChildNullable,
    sharedModelSubclass,
    sharedModelSubclassNullable,
    sharedModelList,
    sharedModelNullableList,
    sharedModelListNullable,
    sharedModelMap,
    sharedModelMapNullable,
    sharedSubclassMap,
    sharedModelSet,
    sharedModelSetNullable,
  ];
}

class SharedModelContainerInclude extends _i1.IncludeObject {
  SharedModelContainerInclude._();

  @override
  Map<String, _i1.Include?> get includes => {};

  @override
  _i1.Table<int?> get table => SharedModelContainer.t;
}

class SharedModelContainerIncludeList extends _i1.IncludeList {
  SharedModelContainerIncludeList._({
    _i1.WhereExpressionBuilder<SharedModelContainerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderDescending,
    super.orderByList,
    super.include,
  }) {
    super.where = where?.call(SharedModelContainer.t);
  }

  @override
  Map<String, _i1.Include?> get includes => include?.includes ?? {};

  @override
  _i1.Table<int?> get table => SharedModelContainer.t;
}

class SharedModelContainerRepository {
  const SharedModelContainerRepository._();

  /// Returns a list of [SharedModelContainer]s matching the given query parameters.
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
  Future<List<SharedModelContainer>> find(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedModelContainerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      orderDescending: orderDescending,
      limit: limit,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Returns the first matching [SharedModelContainer] matching the given query parameters.
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
  Future<SharedModelContainer?> findFirstRow(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? offset,
    _i1.OrderByBuilder<SharedModelContainerTable>? orderBy,
    bool orderDescending = false,
    _i1.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      orderDescending: orderDescending,
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedModelContainer] by its [id] or null if no such row exists.
  Future<SharedModelContainer?> findById(
    _i1.Session session,
    int id, {
    _i1.Transaction? transaction,
    _i1.LockMode? lockMode,
    _i1.LockBehavior? lockBehavior,
  }) async {
    return session.db.findById<SharedModelContainer>(
      id,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Inserts all [SharedModelContainer]s in the list and returns the inserted rows.
  ///
  /// The returned [SharedModelContainer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// insert, none of the rows will be inserted.
  ///
  /// If [ignoreConflicts] is set to `true`, rows that conflict with existing
  /// rows are silently skipped, and only the successfully inserted rows are
  /// returned.
  Future<List<SharedModelContainer>> insert(
    _i1.Session session,
    List<SharedModelContainer> rows, {
    _i1.Transaction? transaction,
    bool ignoreConflicts = false,
  }) async {
    return session.db.insert<SharedModelContainer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
    );
  }

  /// Inserts a single [SharedModelContainer] and returns the inserted row.
  ///
  /// The returned [SharedModelContainer] will have its `id` field set.
  Future<SharedModelContainer> insertRow(
    _i1.Session session,
    SharedModelContainer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedModelContainer>(
      row,
      transaction: transaction,
    );
  }

  /// Updates all [SharedModelContainer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  Future<List<SharedModelContainer>> update(
    _i1.Session session,
    List<SharedModelContainer> rows, {
    _i1.ColumnSelections<SharedModelContainerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.update<SharedModelContainer>(
      rows,
      columns: columns?.call(SharedModelContainer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedModelContainer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedModelContainer> updateRow(
    _i1.Session session,
    SharedModelContainer row, {
    _i1.ColumnSelections<SharedModelContainerTable>? columns,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateRow<SharedModelContainer>(
      row,
      columns: columns?.call(SharedModelContainer.t),
      transaction: transaction,
    );
  }

  /// Updates a single [SharedModelContainer] by its [id] with the specified [columnValues].
  /// Returns the updated row or null if no row with the given id exists.
  Future<SharedModelContainer?> updateById(
    _i1.Session session,
    int id, {
    required _i1.ColumnValueListBuilder<SharedModelContainerUpdateTable>
    columnValues,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedModelContainer>(
      id,
      columnValues: columnValues(SharedModelContainer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedModelContainer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  Future<List<SharedModelContainer>> updateWhere(
    _i1.Session session, {
    required _i1.ColumnValueListBuilder<SharedModelContainerUpdateTable>
    columnValues,
    required _i1.WhereExpressionBuilder<SharedModelContainerTable> where,
    int? limit,
    int? offset,
    _i1.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _i1.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    bool orderDescending = false,
    _i1.Transaction? transaction,
  }) async {
    return session.db.updateWhere<SharedModelContainer>(
      columnValues: columnValues(SharedModelContainer.t.updateTable),
      where: where(SharedModelContainer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      orderDescending: orderDescending,
      transaction: transaction,
    );
  }

  /// Deletes all [SharedModelContainer]s in the list and returns the deleted rows.
  /// This is an atomic operation, meaning that if one of the rows fail to
  /// be deleted, none of the rows will be deleted.
  Future<List<SharedModelContainer>> delete(
    _i1.Session session,
    List<SharedModelContainer> rows, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.delete<SharedModelContainer>(
      rows,
      transaction: transaction,
    );
  }

  /// Deletes a single [SharedModelContainer].
  Future<SharedModelContainer> deleteRow(
    _i1.Session session,
    SharedModelContainer row, {
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedModelContainer>(
      row,
      transaction: transaction,
    );
  }

  /// Deletes all rows matching the [where] expression.
  Future<List<SharedModelContainer>> deleteWhere(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SharedModelContainerTable> where,
    _i1.Transaction? transaction,
  }) async {
    return session.db.deleteWhere<SharedModelContainer>(
      where: where(SharedModelContainer.t),
      transaction: transaction,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _i1.Session session, {
    _i1.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    _i1.Transaction? transaction,
  }) async {
    return session.db.count<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedModelContainer] rows matching the [where] expression.
  Future<void> lockRows(
    _i1.Session session, {
    required _i1.WhereExpressionBuilder<SharedModelContainerTable> where,
    required _i1.LockMode lockMode,
    required _i1.Transaction transaction,
    _i1.LockBehavior lockBehavior = _i1.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedModelContainer>(
      where: where(SharedModelContainer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
