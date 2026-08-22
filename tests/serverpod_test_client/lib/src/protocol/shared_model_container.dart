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
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _iza9lbb5;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'shared_model_subclass.dart' as _iu5vt3uc;

abstract class SharedModelContainer
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  SharedModelContainer._({
    this.id,
    required this.sharedModel,
    required this.sharedModelWithModuleAlias,
    this.sharedModelNullable,
    this.nonPersistedSharedModel,
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
      sharedModel: _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedModel>(
        jsonSerialization['sharedModel'],
      ),
      sharedModelWithModuleAlias: _iza9lbb5.Protocol()
          .deserialize<_ilwf0zl1.SharedModel>(
            jsonSerialization['sharedModelWithModuleAlias'],
          ),
      sharedModelNullable: jsonSerialization['sharedModelNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedModel>(
              jsonSerialization['sharedModelNullable'],
            ),
      nonPersistedSharedModel:
          jsonSerialization['nonPersistedSharedModel'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedModel>(
              jsonSerialization['nonPersistedSharedModel'],
            ),
      sharedSubclass: _iza9lbb5.Protocol()
          .deserialize<_ilwf0zl1.SharedSubclass>(
            jsonSerialization['sharedSubclass'],
          ),
      sharedSubclassNullable:
          jsonSerialization['sharedSubclassNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedSubclass>(
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
      sharedSealedParent: _iza9lbb5.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedParent>(
            jsonSerialization['sharedSealedParent'],
          ),
      sharedSealedParentNullable:
          jsonSerialization['sharedSealedParentNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedSealedParent>(
              jsonSerialization['sharedSealedParentNullable'],
            ),
      sharedSealedChild: _iza9lbb5.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedChild>(
            jsonSerialization['sharedSealedChild'],
          ),
      sharedSealedChildNullable:
          jsonSerialization['sharedSealedChildNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_ilwf0zl1.SharedSealedChild>(
              jsonSerialization['sharedSealedChildNullable'],
            ),
      sharedModelSubclass: _iza9lbb5.Protocol()
          .deserialize<_iu5vt3uc.SharedModelSubclass>(
            jsonSerialization['sharedModelSubclass'],
          ),
      sharedModelSubclassNullable:
          jsonSerialization['sharedModelSubclassNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<_iu5vt3uc.SharedModelSubclass>(
              jsonSerialization['sharedModelSubclassNullable'],
            ),
      sharedModelList: _iza9lbb5.Protocol()
          .deserialize<List<_ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelList'],
          ),
      sharedModelNullableList: _iza9lbb5.Protocol()
          .deserialize<List<_ilwf0zl1.SharedModel?>>(
            jsonSerialization['sharedModelNullableList'],
          ),
      sharedModelListNullable:
          jsonSerialization['sharedModelListNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<List<_ilwf0zl1.SharedModel>>(
              jsonSerialization['sharedModelListNullable'],
            ),
      sharedModelMap: _iza9lbb5.Protocol()
          .deserialize<Map<String, _ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelMap'],
          ),
      sharedModelMapNullable:
          jsonSerialization['sharedModelMapNullable'] == null
          ? null
          : _iza9lbb5.Protocol()
                .deserialize<Map<String, _ilwf0zl1.SharedModel>>(
                  jsonSerialization['sharedModelMapNullable'],
                ),
      sharedSubclassMap: _iza9lbb5.Protocol()
          .deserialize<Map<String, _ilwf0zl1.SharedSubclass>>(
            jsonSerialization['sharedSubclassMap'],
          ),
      sharedModelSet: _iza9lbb5.Protocol()
          .deserialize<Set<_ilwf0zl1.SharedModel>>(
            jsonSerialization['sharedModelSet'],
          ),
      sharedModelSetNullable:
          jsonSerialization['sharedModelSetNullable'] == null
          ? null
          : _iza9lbb5.Protocol().deserialize<Set<_ilwf0zl1.SharedModel>>(
              jsonSerialization['sharedModelSetNullable'],
            ),
    );
  }

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _ilwf0zl1.SharedModel sharedModel;

  _ilwf0zl1.SharedModel sharedModelWithModuleAlias;

  _ilwf0zl1.SharedModel? sharedModelNullable;

  _ilwf0zl1.SharedModel? nonPersistedSharedModel;

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

  /// Returns a shallow copy of this [SharedModelContainer]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  SharedModelContainer copyWith({
    int? id,
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    _ilwf0zl1.SharedModel? sharedModelNullable,
    _ilwf0zl1.SharedModel? nonPersistedSharedModel,
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

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
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
  @_isc.useResult
  @override
  SharedModelContainer copyWith({
    Object? id = _Undefined,
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    Object? sharedModelNullable = _Undefined,
    Object? nonPersistedSharedModel = _Undefined,
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
