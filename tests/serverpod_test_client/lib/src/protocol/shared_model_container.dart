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
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;
import 'shared_model_subclass.dart' as _i3;
import 'package:serverpod_test_client/src/protocol/protocol.dart' as _i4;

abstract class SharedModelContainer implements _i1.SerializableModel {
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
    required _i2.SharedModel sharedModel,
    required _i2.SharedModel sharedModelWithModuleAlias,
    _i2.SharedModel? sharedModelNullable,
    _i2.SharedModel? nonPersistedSharedModel,
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

  /// The database id, set if the object has been inserted into the
  /// database or if it has been fetched from the database. Otherwise,
  /// the id will be null.
  int? id;

  _i2.SharedModel sharedModel;

  _i2.SharedModel sharedModelWithModuleAlias;

  _i2.SharedModel? sharedModelNullable;

  _i2.SharedModel? nonPersistedSharedModel;

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

  /// Returns a shallow copy of this [SharedModelContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedModelContainer copyWith({
    int? id,
    _i2.SharedModel? sharedModel,
    _i2.SharedModel? sharedModelWithModuleAlias,
    _i2.SharedModel? sharedModelNullable,
    _i2.SharedModel? nonPersistedSharedModel,
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
