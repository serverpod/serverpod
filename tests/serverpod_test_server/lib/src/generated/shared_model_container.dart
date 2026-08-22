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
import 'package:meta/meta.dart' as _i057hz1u;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_test_server/src/generated/protocol.dart' as _igqrxdcj;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'shared_model_subclass.dart' as _iu5vt3uc;

abstract class SharedModelContainer
    implements _is.TableRow<int?>, _is.ProtocolSerialization {
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
    required _ilwf0zl1.SharedModel sharedModel,
    required _ilwf0zl1.SharedModel sharedModelWithModuleAlias,
    _ilwf0zl1.SharedModel? sharedModelNullable,
    _ilwf0zl1.SharedModel? nonPersistedSharedModel,
    _ilwf0zl1.SharedModel? serverOnlySharedModel,
    required _ilwf0zl1.SharedSubclass sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    required _ilwf0zl1.SharedSealedParent sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    required _ilwf0zl1.SharedSealedChild sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    required _iu5vt3uc.SharedModelSubclass sharedModelSubclass,
    _iu5vt3uc.SharedModelSubclass? sharedModelSubclassNullable,
    required List<_ilwf0zl1.SharedModel> sharedModelList,
    required List<_ilwf0zl1.SharedModel?> sharedModelNullableList,
    List<_ilwf0zl1.SharedModel>? sharedModelListNullable,
    required Map<String, _ilwf0zl1.SharedModel> sharedModelMap,
    Map<String, _ilwf0zl1.SharedModel>? sharedModelMapNullable,
    required Map<String, _ilwf0zl1.SharedSubclass> sharedSubclassMap,
    required Set<_ilwf0zl1.SharedModel> sharedModelSet,
    Set<_ilwf0zl1.SharedModel>? sharedModelSetNullable,
  }) = _SharedModelContainerImpl;

  factory SharedModelContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return SharedModelContainer(
      id: jsonSerialization['id'] as int?,
      sharedModel: _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedModel>(
        jsonSerialization['sharedModel'],
      ),
      sharedModelWithModuleAlias: _igqrxdcj.Protocol()
          .deserialize<_ilwf0zl1.SharedModel>(
            jsonSerialization['sharedModelWithModuleAlias'],
          ),
      sharedModelNullable: jsonSerialization['sharedModelNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedModel>(
              jsonSerialization['sharedModelNullable'],
            ),
      nonPersistedSharedModel:
          jsonSerialization['nonPersistedSharedModel'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedModel>(
              jsonSerialization['nonPersistedSharedModel'],
            ),
      serverOnlySharedModel: jsonSerialization['serverOnlySharedModel'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedModel>(
              jsonSerialization['serverOnlySharedModel'],
            ),
      sharedSubclass: _igqrxdcj.Protocol()
          .deserialize<_ilwf0zl1.SharedSubclass>(
            jsonSerialization['sharedSubclass'],
          ),
      sharedSubclassNullable:
          jsonSerialization['sharedSubclassNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedSubclass>(
              jsonSerialization['sharedSubclassNullable'],
            ),
      sharedEnum: _ilwf0zl1.SharedEnum.fromJson(
        (jsonSerialization['sharedEnum'] as String),
      ),
      sharedEnumNullable: jsonSerialization['sharedEnumNullable'] == null
          ? null
          : _ilwf0zl1.SharedEnum.fromJson(
              (jsonSerialization['sharedEnumNullable'] as String),
            ),
      sharedSealedParent: _igqrxdcj.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedParent>(
            jsonSerialization['sharedSealedParent'],
          ),
      sharedSealedParentNullable:
          jsonSerialization['sharedSealedParentNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedSealedParent>(
              jsonSerialization['sharedSealedParentNullable'],
            ),
      sharedSealedChild: _igqrxdcj.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedChild>(
            jsonSerialization['sharedSealedChild'],
          ),
      sharedSealedChildNullable:
          jsonSerialization['sharedSealedChildNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_ilwf0zl1.SharedSealedChild>(
              jsonSerialization['sharedSealedChildNullable'],
            ),
      sharedModelSubclass: _igqrxdcj.Protocol()
          .deserialize<_iu5vt3uc.SharedModelSubclass>(
            jsonSerialization['sharedModelSubclass'],
          ),
      sharedModelSubclassNullable:
          jsonSerialization['sharedModelSubclassNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<_iu5vt3uc.SharedModelSubclass>(
              jsonSerialization['sharedModelSubclassNullable'],
            ),
      sharedModelList: _igqrxdcj.Protocol()
          .deserialize<List<_ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelList'],
          ),
      sharedModelNullableList: _igqrxdcj.Protocol()
          .deserialize<List<_ilwf0zl1.SharedModel?>>(
            jsonSerialization['sharedModelNullableList'],
          ),
      sharedModelListNullable:
          jsonSerialization['sharedModelListNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<List<_ilwf0zl1.SharedModel>>(
              jsonSerialization['sharedModelListNullable'],
            ),
      sharedModelMap: _igqrxdcj.Protocol()
          .deserialize<Map<String, _ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelMap'],
          ),
      sharedModelMapNullable:
          jsonSerialization['sharedModelMapNullable'] == null
          ? null
          : _igqrxdcj.Protocol()
                .deserialize<Map<String, _ilwf0zl1.SharedModel>>(
                  jsonSerialization['sharedModelMapNullable'],
                ),
      sharedSubclassMap: _igqrxdcj.Protocol()
          .deserialize<Map<String, _ilwf0zl1.SharedSubclass>>(
            jsonSerialization['sharedSubclassMap'],
          ),
      sharedModelSet: _igqrxdcj.Protocol()
          .deserialize<Set<_ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelSet'],
          ),
      sharedModelSetNullable:
          jsonSerialization['sharedModelSetNullable'] == null
          ? null
          : _igqrxdcj.Protocol().deserialize<Set<_ilwf0zl1.SharedModel>>(
              jsonSerialization['sharedModelSetNullable'],
            ),
    );
  }

  static final t = SharedModelContainerTable();

  static const db = SharedModelContainerRepository._();

  @override
  int? id;

  _ilwf0zl1.SharedModel sharedModel;

  _ilwf0zl1.SharedModel sharedModelWithModuleAlias;

  _ilwf0zl1.SharedModel? sharedModelNullable;

  _ilwf0zl1.SharedModel? nonPersistedSharedModel;

  _ilwf0zl1.SharedModel? serverOnlySharedModel;

  _ilwf0zl1.SharedSubclass sharedSubclass;

  _ilwf0zl1.SharedSubclass? sharedSubclassNullable;

  _ilwf0zl1.SharedEnum sharedEnum;

  _ilwf0zl1.SharedEnum? sharedEnumNullable;

  _ilwf0zl1.SharedSealedParent sharedSealedParent;

  _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable;

  _ilwf0zl1.SharedSealedChild sharedSealedChild;

  _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable;

  _iu5vt3uc.SharedModelSubclass sharedModelSubclass;

  _iu5vt3uc.SharedModelSubclass? sharedModelSubclassNullable;

  List<_ilwf0zl1.SharedModel> sharedModelList;

  List<_ilwf0zl1.SharedModel?> sharedModelNullableList;

  List<_ilwf0zl1.SharedModel>? sharedModelListNullable;

  Map<String, _ilwf0zl1.SharedModel> sharedModelMap;

  Map<String, _ilwf0zl1.SharedModel>? sharedModelMapNullable;

  Map<String, _ilwf0zl1.SharedSubclass> sharedSubclassMap;

  Set<_ilwf0zl1.SharedModel> sharedModelSet;

  Set<_ilwf0zl1.SharedModel>? sharedModelSetNullable;

  @override
  _is.Table<int?> get table => t;

  /// Returns a shallow copy of this [SharedModelContainer]
  /// with some or all fields replaced by the given arguments.
  @_is.useResult
  SharedModelContainer copyWith({
    int? id,
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    _ilwf0zl1.SharedModel? sharedModelNullable,
    _ilwf0zl1.SharedModel? nonPersistedSharedModel,
    _ilwf0zl1.SharedModel? serverOnlySharedModel,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    _ilwf0zl1.SharedEnum? sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    _ilwf0zl1.SharedSealedParent? sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    _ilwf0zl1.SharedSealedChild? sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    _iu5vt3uc.SharedModelSubclass? sharedModelSubclass,
    _iu5vt3uc.SharedModelSubclass? sharedModelSubclassNullable,
    List<_ilwf0zl1.SharedModel>? sharedModelList,
    List<_ilwf0zl1.SharedModel?>? sharedModelNullableList,
    List<_ilwf0zl1.SharedModel>? sharedModelListNullable,
    Map<String, _ilwf0zl1.SharedModel>? sharedModelMap,
    Map<String, _ilwf0zl1.SharedModel>? sharedModelMapNullable,
    Map<String, _ilwf0zl1.SharedSubclass>? sharedSubclassMap,
    Set<_ilwf0zl1.SharedModel>? sharedModelSet,
    Set<_ilwf0zl1.SharedModel>? sharedModelSetNullable,
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
      'sharedModel': sharedModel.toJsonForProtocol(),
      'sharedModelWithModuleAlias': sharedModelWithModuleAlias
          .toJsonForProtocol(),
      if (sharedModelNullable != null)
        'sharedModelNullable': sharedModelNullable?.toJsonForProtocol(),
      if (nonPersistedSharedModel != null)
        'nonPersistedSharedModel': nonPersistedSharedModel?.toJsonForProtocol(),
      'sharedSubclass': sharedSubclass.toJsonForProtocol(),
      if (sharedSubclassNullable != null)
        'sharedSubclassNullable': sharedSubclassNullable?.toJsonForProtocol(),
      'sharedEnum': sharedEnum.toJson(),
      if (sharedEnumNullable != null)
        'sharedEnumNullable': sharedEnumNullable?.toJson(),
      'sharedSealedParent': sharedSealedParent.toJsonForProtocol(),
      if (sharedSealedParentNullable != null)
        'sharedSealedParentNullable': sharedSealedParentNullable
            ?.toJsonForProtocol(),
      'sharedSealedChild': sharedSealedChild.toJsonForProtocol(),
      if (sharedSealedChildNullable != null)
        'sharedSealedChildNullable': sharedSealedChildNullable
            ?.toJsonForProtocol(),
      'sharedModelSubclass': sharedModelSubclass.toJsonForProtocol(),
      if (sharedModelSubclassNullable != null)
        'sharedModelSubclassNullable': sharedModelSubclassNullable
            ?.toJsonForProtocol(),
      'sharedModelList': sharedModelList.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'sharedModelNullableList': sharedModelNullableList.toJson(
        valueToJson: (v) => v?.toJsonForProtocol(),
      ),
      if (sharedModelListNullable != null)
        'sharedModelListNullable': sharedModelListNullable?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'sharedModelMap': sharedModelMap.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (sharedModelMapNullable != null)
        'sharedModelMapNullable': sharedModelMapNullable?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
      'sharedSubclassMap': sharedSubclassMap.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      'sharedModelSet': sharedModelSet.toJson(
        valueToJson: (v) => v.toJsonForProtocol(),
      ),
      if (sharedModelSetNullable != null)
        'sharedModelSetNullable': sharedModelSetNullable?.toJson(
          valueToJson: (v) => v.toJsonForProtocol(),
        ),
    };
  }

  static SharedModelContainerInclude include() {
    return SharedModelContainerInclude.internal_();
  }

  static SharedModelContainerIncludeList includeList({
    _is.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    SharedModelContainerInclude? include,
  }) {
    return SharedModelContainerIncludeList.internal_(
      where: where,
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      include: include,
    );
  }

  @override
  String toString() {
    return _is.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedModelContainerImpl extends SharedModelContainer {
  _SharedModelContainerImpl({
    int? id,
    required _ilwf0zl1.SharedModel sharedModel,
    required _ilwf0zl1.SharedModel sharedModelWithModuleAlias,
    _ilwf0zl1.SharedModel? sharedModelNullable,
    _ilwf0zl1.SharedModel? nonPersistedSharedModel,
    _ilwf0zl1.SharedModel? serverOnlySharedModel,
    required _ilwf0zl1.SharedSubclass sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    required _ilwf0zl1.SharedSealedParent sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    required _ilwf0zl1.SharedSealedChild sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    required _iu5vt3uc.SharedModelSubclass sharedModelSubclass,
    _iu5vt3uc.SharedModelSubclass? sharedModelSubclassNullable,
    required List<_ilwf0zl1.SharedModel> sharedModelList,
    required List<_ilwf0zl1.SharedModel?> sharedModelNullableList,
    List<_ilwf0zl1.SharedModel>? sharedModelListNullable,
    required Map<String, _ilwf0zl1.SharedModel> sharedModelMap,
    Map<String, _ilwf0zl1.SharedModel>? sharedModelMapNullable,
    required Map<String, _ilwf0zl1.SharedSubclass> sharedSubclassMap,
    required Set<_ilwf0zl1.SharedModel> sharedModelSet,
    Set<_ilwf0zl1.SharedModel>? sharedModelSetNullable,
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
  @_is.useResult
  @override
  SharedModelContainer copyWith({
    Object? id = _Undefined,
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    Object? sharedModelNullable = _Undefined,
    Object? nonPersistedSharedModel = _Undefined,
    Object? serverOnlySharedModel = _Undefined,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
    Object? sharedSubclassNullable = _Undefined,
    _ilwf0zl1.SharedEnum? sharedEnum,
    Object? sharedEnumNullable = _Undefined,
    _ilwf0zl1.SharedSealedParent? sharedSealedParent,
    Object? sharedSealedParentNullable = _Undefined,
    _ilwf0zl1.SharedSealedChild? sharedSealedChild,
    Object? sharedSealedChildNullable = _Undefined,
    _iu5vt3uc.SharedModelSubclass? sharedModelSubclass,
    Object? sharedModelSubclassNullable = _Undefined,
    List<_ilwf0zl1.SharedModel>? sharedModelList,
    List<_ilwf0zl1.SharedModel?>? sharedModelNullableList,
    Object? sharedModelListNullable = _Undefined,
    Map<String, _ilwf0zl1.SharedModel>? sharedModelMap,
    Object? sharedModelMapNullable = _Undefined,
    Map<String, _ilwf0zl1.SharedSubclass>? sharedSubclassMap,
    Set<_ilwf0zl1.SharedModel>? sharedModelSet,
    Object? sharedModelSetNullable = _Undefined,
  }) {
    return SharedModelContainer(
      id: id is int? ? id : this.id,
      sharedModel: sharedModel ?? this.sharedModel.copyWith(),
      sharedModelWithModuleAlias:
          sharedModelWithModuleAlias ??
          this.sharedModelWithModuleAlias.copyWith(),
      sharedModelNullable: sharedModelNullable is _ilwf0zl1.SharedModel?
          ? sharedModelNullable
          : this.sharedModelNullable?.copyWith(),
      nonPersistedSharedModel: nonPersistedSharedModel is _ilwf0zl1.SharedModel?
          ? nonPersistedSharedModel
          : this.nonPersistedSharedModel?.copyWith(),
      serverOnlySharedModel: serverOnlySharedModel is _ilwf0zl1.SharedModel?
          ? serverOnlySharedModel
          : this.serverOnlySharedModel?.copyWith(),
      sharedSubclass: sharedSubclass ?? this.sharedSubclass.copyWith(),
      sharedSubclassNullable:
          sharedSubclassNullable is _ilwf0zl1.SharedSubclass?
          ? sharedSubclassNullable
          : this.sharedSubclassNullable?.copyWith(),
      sharedEnum: sharedEnum ?? this.sharedEnum,
      sharedEnumNullable: sharedEnumNullable is _ilwf0zl1.SharedEnum?
          ? sharedEnumNullable
          : this.sharedEnumNullable,
      sharedSealedParent:
          sharedSealedParent ?? this.sharedSealedParent.copyWith(),
      sharedSealedParentNullable:
          sharedSealedParentNullable is _ilwf0zl1.SharedSealedParent?
          ? sharedSealedParentNullable
          : this.sharedSealedParentNullable?.copyWith(),
      sharedSealedChild: sharedSealedChild ?? this.sharedSealedChild.copyWith(),
      sharedSealedChildNullable:
          sharedSealedChildNullable is _ilwf0zl1.SharedSealedChild?
          ? sharedSealedChildNullable
          : this.sharedSealedChildNullable?.copyWith(),
      sharedModelSubclass:
          sharedModelSubclass ?? this.sharedModelSubclass.copyWith(),
      sharedModelSubclassNullable:
          sharedModelSubclassNullable is _iu5vt3uc.SharedModelSubclass?
          ? sharedModelSubclassNullable
          : this.sharedModelSubclassNullable?.copyWith(),
      sharedModelList:
          sharedModelList ??
          this.sharedModelList.map((e0) => e0.copyWith()).toList(),
      sharedModelNullableList:
          sharedModelNullableList ??
          this.sharedModelNullableList.map((e0) => e0?.copyWith()).toList(),
      sharedModelListNullable:
          sharedModelListNullable is List<_ilwf0zl1.SharedModel>?
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
          sharedModelMapNullable is Map<String, _ilwf0zl1.SharedModel>?
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
      sharedModelSetNullable:
          sharedModelSetNullable is Set<_ilwf0zl1.SharedModel>?
          ? sharedModelSetNullable
          : this.sharedModelSetNullable?.map((e0) => e0.copyWith()).toSet(),
    );
  }
}

class SharedModelContainerUpdateTable
    extends _is.UpdateTable<SharedModelContainerTable> {
  SharedModelContainerUpdateTable(super.table);

  _is.ColumnValue<_ilwf0zl1.SharedModel, _ilwf0zl1.SharedModel> sharedModel(
    _ilwf0zl1.SharedModel value,
  ) => _is.ColumnValue(
    table.sharedModel,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedModel, _ilwf0zl1.SharedModel>
  sharedModelWithModuleAlias(_ilwf0zl1.SharedModel value) => _is.ColumnValue(
    table.sharedModelWithModuleAlias,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedModel, _ilwf0zl1.SharedModel>
  sharedModelNullable(_ilwf0zl1.SharedModel? value) => _is.ColumnValue(
    table.sharedModelNullable,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedModel, _ilwf0zl1.SharedModel>
  serverOnlySharedModel(_ilwf0zl1.SharedModel? value) => _is.ColumnValue(
    table.serverOnlySharedModel,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedSubclass, _ilwf0zl1.SharedSubclass>
  sharedSubclass(_ilwf0zl1.SharedSubclass value) => _is.ColumnValue(
    table.sharedSubclass,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedSubclass, _ilwf0zl1.SharedSubclass>
  sharedSubclassNullable(_ilwf0zl1.SharedSubclass? value) => _is.ColumnValue(
    table.sharedSubclassNullable,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedEnum, _ilwf0zl1.SharedEnum> sharedEnum(
    _ilwf0zl1.SharedEnum value,
  ) => _is.ColumnValue(
    table.sharedEnum,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedEnum, _ilwf0zl1.SharedEnum>
  sharedEnumNullable(_ilwf0zl1.SharedEnum? value) => _is.ColumnValue(
    table.sharedEnumNullable,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedSealedParent, _ilwf0zl1.SharedSealedParent>
  sharedSealedParent(_ilwf0zl1.SharedSealedParent value) => _is.ColumnValue(
    table.sharedSealedParent,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedSealedParent, _ilwf0zl1.SharedSealedParent>
  sharedSealedParentNullable(_ilwf0zl1.SharedSealedParent? value) =>
      _is.ColumnValue(
        table.sharedSealedParentNullable,
        value,
      );

  _is.ColumnValue<_ilwf0zl1.SharedSealedChild, _ilwf0zl1.SharedSealedChild>
  sharedSealedChild(_ilwf0zl1.SharedSealedChild value) => _is.ColumnValue(
    table.sharedSealedChild,
    value,
  );

  _is.ColumnValue<_ilwf0zl1.SharedSealedChild, _ilwf0zl1.SharedSealedChild>
  sharedSealedChildNullable(_ilwf0zl1.SharedSealedChild? value) =>
      _is.ColumnValue(
        table.sharedSealedChildNullable,
        value,
      );

  _is.ColumnValue<_iu5vt3uc.SharedModelSubclass, _iu5vt3uc.SharedModelSubclass>
  sharedModelSubclass(_iu5vt3uc.SharedModelSubclass value) => _is.ColumnValue(
    table.sharedModelSubclass,
    value,
  );

  _is.ColumnValue<_iu5vt3uc.SharedModelSubclass, _iu5vt3uc.SharedModelSubclass>
  sharedModelSubclassNullable(_iu5vt3uc.SharedModelSubclass? value) =>
      _is.ColumnValue(
        table.sharedModelSubclassNullable,
        value,
      );

  _is.ColumnValue<List<_ilwf0zl1.SharedModel>, List<_ilwf0zl1.SharedModel>>
  sharedModelList(List<_ilwf0zl1.SharedModel> value) => _is.ColumnValue(
    table.sharedModelList,
    value,
  );

  _is.ColumnValue<List<_ilwf0zl1.SharedModel?>, List<_ilwf0zl1.SharedModel?>>
  sharedModelNullableList(List<_ilwf0zl1.SharedModel?> value) =>
      _is.ColumnValue(
        table.sharedModelNullableList,
        value,
      );

  _is.ColumnValue<List<_ilwf0zl1.SharedModel>, List<_ilwf0zl1.SharedModel>>
  sharedModelListNullable(List<_ilwf0zl1.SharedModel>? value) =>
      _is.ColumnValue(
        table.sharedModelListNullable,
        value,
      );

  _is.ColumnValue<
    Map<String, _ilwf0zl1.SharedModel>,
    Map<String, _ilwf0zl1.SharedModel>
  >
  sharedModelMap(Map<String, _ilwf0zl1.SharedModel> value) => _is.ColumnValue(
    table.sharedModelMap,
    value,
  );

  _is.ColumnValue<
    Map<String, _ilwf0zl1.SharedModel>,
    Map<String, _ilwf0zl1.SharedModel>
  >
  sharedModelMapNullable(Map<String, _ilwf0zl1.SharedModel>? value) =>
      _is.ColumnValue(
        table.sharedModelMapNullable,
        value,
      );

  _is.ColumnValue<
    Map<String, _ilwf0zl1.SharedSubclass>,
    Map<String, _ilwf0zl1.SharedSubclass>
  >
  sharedSubclassMap(Map<String, _ilwf0zl1.SharedSubclass> value) =>
      _is.ColumnValue(
        table.sharedSubclassMap,
        value,
      );

  _is.ColumnValue<Set<_ilwf0zl1.SharedModel>, Set<_ilwf0zl1.SharedModel>>
  sharedModelSet(Set<_ilwf0zl1.SharedModel> value) => _is.ColumnValue(
    table.sharedModelSet,
    value,
  );

  _is.ColumnValue<Set<_ilwf0zl1.SharedModel>, Set<_ilwf0zl1.SharedModel>>
  sharedModelSetNullable(Set<_ilwf0zl1.SharedModel>? value) => _is.ColumnValue(
    table.sharedModelSetNullable,
    value,
  );
}

class SharedModelContainerTable extends _is.Table<int?> {
  SharedModelContainerTable({super.tableRelation})
    : super(tableName: 'shared_model_container') {
    updateTable = SharedModelContainerUpdateTable(this);
    sharedModel = _is.ColumnSerializable<_ilwf0zl1.SharedModel>(
      'sharedModel',
      this,
    );
    sharedModelWithModuleAlias = _is.ColumnSerializable<_ilwf0zl1.SharedModel>(
      'sharedModelWithModuleAlias',
      this,
    );
    sharedModelNullable = _is.ColumnSerializable<_ilwf0zl1.SharedModel>(
      'sharedModelNullable',
      this,
    );
    serverOnlySharedModel = _is.ColumnSerializable<_ilwf0zl1.SharedModel>(
      'serverOnlySharedModel',
      this,
    );
    sharedSubclass = _is.ColumnSerializable<_ilwf0zl1.SharedSubclass>(
      'sharedSubclass',
      this,
    );
    sharedSubclassNullable = _is.ColumnSerializable<_ilwf0zl1.SharedSubclass>(
      'sharedSubclassNullable',
      this,
    );
    sharedEnum = _is.ColumnEnum(
      'sharedEnum',
      this,
      _is.EnumSerialization.byName,
    );
    sharedEnumNullable = _is.ColumnEnum(
      'sharedEnumNullable',
      this,
      _is.EnumSerialization.byName,
    );
    sharedSealedParent = _is.ColumnSerializable<_ilwf0zl1.SharedSealedParent>(
      'sharedSealedParent',
      this,
    );
    sharedSealedParentNullable =
        _is.ColumnSerializable<_ilwf0zl1.SharedSealedParent>(
          'sharedSealedParentNullable',
          this,
        );
    sharedSealedChild = _is.ColumnSerializable<_ilwf0zl1.SharedSealedChild>(
      'sharedSealedChild',
      this,
    );
    sharedSealedChildNullable =
        _is.ColumnSerializable<_ilwf0zl1.SharedSealedChild>(
          'sharedSealedChildNullable',
          this,
        );
    sharedModelSubclass = _is.ColumnSerializable<_iu5vt3uc.SharedModelSubclass>(
      'sharedModelSubclass',
      this,
    );
    sharedModelSubclassNullable =
        _is.ColumnSerializable<_iu5vt3uc.SharedModelSubclass>(
          'sharedModelSubclassNullable',
          this,
        );
    sharedModelList = _is.ColumnSerializable<List<_ilwf0zl1.SharedModel>>(
      'sharedModelList',
      this,
    );
    sharedModelNullableList =
        _is.ColumnSerializable<List<_ilwf0zl1.SharedModel?>>(
          'sharedModelNullableList',
          this,
        );
    sharedModelListNullable =
        _is.ColumnSerializable<List<_ilwf0zl1.SharedModel>>(
          'sharedModelListNullable',
          this,
        );
    sharedModelMap = _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedModel>>(
      'sharedModelMap',
      this,
    );
    sharedModelMapNullable =
        _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedModel>>(
          'sharedModelMapNullable',
          this,
        );
    sharedSubclassMap =
        _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedSubclass>>(
          'sharedSubclassMap',
          this,
        );
    sharedModelSet = _is.ColumnSerializable<Set<_ilwf0zl1.SharedModel>>(
      'sharedModelSet',
      this,
    );
    sharedModelSetNullable = _is.ColumnSerializable<Set<_ilwf0zl1.SharedModel>>(
      'sharedModelSetNullable',
      this,
    );
  }

  late final SharedModelContainerUpdateTable updateTable;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedModel> sharedModel;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedModel>
  sharedModelWithModuleAlias;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedModel> sharedModelNullable;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedModel>
  serverOnlySharedModel;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSubclass> sharedSubclass;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSubclass>
  sharedSubclassNullable;

  late final _is.ColumnEnum<_ilwf0zl1.SharedEnum> sharedEnum;

  late final _is.ColumnEnum<_ilwf0zl1.SharedEnum> sharedEnumNullable;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSealedParent>
  sharedSealedParent;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSealedParent>
  sharedSealedParentNullable;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSealedChild>
  sharedSealedChild;

  late final _is.ColumnSerializable<_ilwf0zl1.SharedSealedChild>
  sharedSealedChildNullable;

  late final _is.ColumnSerializable<_iu5vt3uc.SharedModelSubclass>
  sharedModelSubclass;

  late final _is.ColumnSerializable<_iu5vt3uc.SharedModelSubclass>
  sharedModelSubclassNullable;

  late final _is.ColumnSerializable<List<_ilwf0zl1.SharedModel>>
  sharedModelList;

  late final _is.ColumnSerializable<List<_ilwf0zl1.SharedModel?>>
  sharedModelNullableList;

  late final _is.ColumnSerializable<List<_ilwf0zl1.SharedModel>>
  sharedModelListNullable;

  late final _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedModel>>
  sharedModelMap;

  late final _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedModel>>
  sharedModelMapNullable;

  late final _is.ColumnSerializable<Map<String, _ilwf0zl1.SharedSubclass>>
  sharedSubclassMap;

  late final _is.ColumnSerializable<Set<_ilwf0zl1.SharedModel>> sharedModelSet;

  late final _is.ColumnSerializable<Set<_ilwf0zl1.SharedModel>>
  sharedModelSetNullable;

  @override
  List<_is.Column> get columns => [
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

class SharedModelContainerInclude extends _is.IncludeObject {
  @_i057hz1u.internal
  SharedModelContainerInclude.internal_({
    List<_is.Column>? this.selectedColumns,
  }) {}

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => {};

  @override
  _is.Table<int?> get table => SharedModelContainer.t;
}

class SharedModelContainerIncludeList extends _is.IncludeList {
  @_i057hz1u.internal
  SharedModelContainerIncludeList.internal_({
    _is.WhereExpressionBuilder<SharedModelContainerTable>? where,
    super.limit,
    super.offset,
    super.orderBy,
    super.orderByList,
    super.include,
    List<_is.Column>? this.selectedColumns,
  }) {
    super.where = where?.call(SharedModelContainer.t);
  }

  final List<_is.Column>? selectedColumns;

  @override
  Map<String, _is.Include?> get includes => include?.includes ?? {};

  @override
  _is.Table<int?> get table => SharedModelContainer.t;
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.find<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
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
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? offset,
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
  }) async {
    return session.db.findFirstRow<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      offset: offset,
      transaction: transaction,
      lockMode: lockMode,
      lockBehavior: lockBehavior,
    );
  }

  /// Finds a single [SharedModelContainer] by its [id] or null if no such row exists.
  Future<SharedModelContainer?> findById(
    _is.DatabaseSession session,
    int id, {
    _is.Transaction? transaction,
    _is.LockMode? lockMode,
    _is.LockBehavior? lockBehavior,
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
  ///
  /// If [noReturn] is set to `true`, the inserted rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModelContainer>> insert(
    _is.DatabaseSession session,
    List<SharedModelContainer> rows, {
    _is.Transaction? transaction,
    bool ignoreConflicts = false,
    bool noReturn = false,
  }) async {
    return session.db.insert<SharedModelContainer>(
      rows,
      transaction: transaction,
      ignoreConflicts: ignoreConflicts,
      noReturn: noReturn,
    );
  }

  /// Inserts a single [SharedModelContainer] and returns the inserted row.
  ///
  /// The returned [SharedModelContainer] will have its `id` field set.
  Future<SharedModelContainer> insertRow(
    _is.DatabaseSession session,
    SharedModelContainer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.insertRow<SharedModelContainer>(
      row,
      transaction: transaction,
    );
  }

  /// Upserts all [SharedModelContainer]s in the list and returns the resulting rows.
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
  /// The returned [SharedModelContainer]s will have their `id` fields set.
  ///
  /// This is an atomic operation, meaning that if one of the rows fails,
  /// none of the rows will be affected.
  ///
  /// If [noReturn] is set to `true`, the resulting rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModelContainer>> upsert(
    _is.DatabaseSession session,
    List<SharedModelContainer> rows, {
    required _is.ColumnSelections<SharedModelContainerTable> conflictColumns,
    _is.ColumnSelections<SharedModelContainerTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedModelContainerTable>? updateWhere,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.upsert<SharedModelContainer>(
      rows,
      conflictColumns: conflictColumns(SharedModelContainer.t),
      updateColumns: updateColumns?.call(SharedModelContainer.t),
      updateWhere: updateWhere?.call(SharedModelContainer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Upserts a single [SharedModelContainer] and returns the resulting row.
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
  /// The returned [SharedModelContainer] will have its `id` field set.
  Future<SharedModelContainer?> upsertRow(
    _is.DatabaseSession session,
    SharedModelContainer row, {
    required _is.ColumnSelections<SharedModelContainerTable> conflictColumns,
    _is.ColumnSelections<SharedModelContainerTable>? updateColumns,
    _is.WhereExpressionBuilder<SharedModelContainerTable>? updateWhere,
    _is.Transaction? transaction,
  }) async {
    return session.db.upsertRow<SharedModelContainer>(
      row,
      conflictColumns: conflictColumns(SharedModelContainer.t),
      updateColumns: updateColumns?.call(SharedModelContainer.t),
      updateWhere: updateWhere?.call(SharedModelContainer.t),
      transaction: transaction,
    );
  }

  /// Updates all [SharedModelContainer]s in the list and returns the updated rows. If
  /// [columns] is provided, only those columns will be updated. Defaults to
  /// all columns.
  /// This is an atomic operation, meaning that if one of the rows fails to
  /// update, none of the rows will be updated.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModelContainer>> update(
    _is.DatabaseSession session,
    List<SharedModelContainer> rows, {
    _is.ColumnSelections<SharedModelContainerTable>? columns,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.update<SharedModelContainer>(
      rows,
      columns: columns?.call(SharedModelContainer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Updates a single [SharedModelContainer]. The row needs to have its id set.
  /// Optionally, a list of [columns] can be provided to only update those
  /// columns. Defaults to all columns.
  Future<SharedModelContainer> updateRow(
    _is.DatabaseSession session,
    SharedModelContainer row, {
    _is.ColumnSelections<SharedModelContainerTable>? columns,
    _is.Transaction? transaction,
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
    _is.DatabaseSession session,
    int id, {
    required _is.ColumnValueListBuilder<SharedModelContainerUpdateTable>
    columnValues,
    _is.Transaction? transaction,
  }) async {
    return session.db.updateById<SharedModelContainer>(
      id,
      columnValues: columnValues(SharedModelContainer.t.updateTable),
      transaction: transaction,
    );
  }

  /// Updates all [SharedModelContainer]s matching the [where] expression with the specified [columnValues].
  /// Returns the list of updated rows.
  ///
  /// If [noReturn] is set to `true`, the updated rows are not read back from
  /// the database and an empty list is returned. This avoids the overhead of
  /// transferring and deserializing the rows when the result is not needed.
  Future<List<SharedModelContainer>> updateWhere(
    _is.DatabaseSession session, {
    required _is.ColumnValueListBuilder<SharedModelContainerUpdateTable>
    columnValues,
    required _is.WhereExpressionBuilder<SharedModelContainerTable> where,
    int? limit,
    int? offset,
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.updateWhere<SharedModelContainer>(
      columnValues: columnValues(SharedModelContainer.t.updateTable),
      where: where(SharedModelContainer.t),
      limit: limit,
      offset: offset,
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes all [SharedModelContainer]s in the list and returns the deleted rows.
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
  Future<List<SharedModelContainer>> delete(
    _is.DatabaseSession session,
    List<SharedModelContainer> rows, {
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.delete<SharedModelContainer>(
      rows,
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Deletes a single [SharedModelContainer].
  Future<SharedModelContainer> deleteRow(
    _is.DatabaseSession session,
    SharedModelContainer row, {
    _is.Transaction? transaction,
  }) async {
    return session.db.deleteRow<SharedModelContainer>(
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
  Future<List<SharedModelContainer>> deleteWhere(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedModelContainerTable> where,
    _is.OrderByBuilder<SharedModelContainerTable>? orderBy,
    _is.OrderByListBuilder<SharedModelContainerTable>? orderByList,
    _is.Transaction? transaction,
    bool noReturn = false,
  }) async {
    return session.db.deleteWhere<SharedModelContainer>(
      where: where(SharedModelContainer.t),
      orderBy: orderBy?.call(SharedModelContainer.t),
      orderByList: orderByList?.call(SharedModelContainer.t),
      transaction: transaction,
      noReturn: noReturn,
    );
  }

  /// Counts the number of rows matching the [where] expression. If omitted,
  /// will return the count of all rows in the table.
  Future<int> count(
    _is.DatabaseSession session, {
    _is.WhereExpressionBuilder<SharedModelContainerTable>? where,
    int? limit,
    _is.Transaction? transaction,
  }) async {
    return session.db.count<SharedModelContainer>(
      where: where?.call(SharedModelContainer.t),
      limit: limit,
      transaction: transaction,
    );
  }

  /// Acquires row-level locks on [SharedModelContainer] rows matching the [where] expression.
  Future<void> lockRows(
    _is.DatabaseSession session, {
    required _is.WhereExpressionBuilder<SharedModelContainerTable> where,
    required _is.LockMode lockMode,
    required _is.Transaction transaction,
    _is.LockBehavior lockBehavior = _is.LockBehavior.wait,
  }) async {
    return session.db.lockRows<SharedModelContainer>(
      where: where(SharedModelContainer.t),
      lockMode: lockMode,
      lockBehavior: lockBehavior,
      transaction: transaction,
    );
  }
}
