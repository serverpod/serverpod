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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _i1;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i2;

abstract class SharedContainer implements _i1.SerializableModel {
  SharedContainer._({
    required this.sharedModel,
    required this.sharedModelWithModuleAlias,
    required this.sharedSubclass,
    this.sharedSubclassNullable,
    required this.sharedEnum,
    this.sharedEnumNullable,
    required this.sharedSealedParent,
    this.sharedSealedParentNullable,
    required this.sharedSealedChild,
    this.sharedSealedChildNullable,
  });

  factory SharedContainer({
    required _i2.SharedModel sharedModel,
    required _i2.SharedModel sharedModelWithModuleAlias,
    required _i2.SharedSubclass sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    required _i2.SharedEnum sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    required _i2.SharedSealedParent sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    required _i2.SharedSealedChild sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
  }) = _SharedContainerImpl;

  factory SharedContainer.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedContainer(
      sharedModel: _i2.Protocol().deserialize<_i2.SharedModel>(
        jsonSerialization['sharedModel'],
      ),
      sharedModelWithModuleAlias: _i2.Protocol().deserialize<_i2.SharedModel>(
        jsonSerialization['sharedModelWithModuleAlias'],
      ),
      sharedSubclass: _i2.Protocol().deserialize<_i2.SharedSubclass>(
        jsonSerialization['sharedSubclass'],
      ),
      sharedSubclassNullable:
          jsonSerialization['sharedSubclassNullable'] == null
          ? null
          : _i2.Protocol().deserialize<_i2.SharedSubclass>(
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
      sharedSealedParent: _i2.Protocol().deserialize<_i2.SharedSealedParent>(
        jsonSerialization['sharedSealedParent'],
      ),
      sharedSealedParentNullable:
          jsonSerialization['sharedSealedParentNullable'] == null
          ? null
          : _i2.Protocol().deserialize<_i2.SharedSealedParent>(
              jsonSerialization['sharedSealedParentNullable'],
            ),
      sharedSealedChild: _i2.Protocol().deserialize<_i2.SharedSealedChild>(
        jsonSerialization['sharedSealedChild'],
      ),
      sharedSealedChildNullable:
          jsonSerialization['sharedSealedChildNullable'] == null
          ? null
          : _i2.Protocol().deserialize<_i2.SharedSealedChild>(
              jsonSerialization['sharedSealedChildNullable'],
            ),
    );
  }

  _i2.SharedModel sharedModel;

  _i2.SharedModel sharedModelWithModuleAlias;

  _i2.SharedSubclass sharedSubclass;

  _i2.SharedSubclass? sharedSubclassNullable;

  _i2.SharedEnum sharedEnum;

  _i2.SharedEnum? sharedEnumNullable;

  _i2.SharedSealedParent sharedSealedParent;

  _i2.SharedSealedParent? sharedSealedParentNullable;

  _i2.SharedSealedChild sharedSealedChild;

  _i2.SharedSealedChild? sharedSealedChildNullable;

  /// Returns a shallow copy of this [SharedContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  SharedContainer copyWith({
    _i2.SharedModel? sharedModel,
    _i2.SharedModel? sharedModelWithModuleAlias,
    _i2.SharedSubclass? sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    _i2.SharedEnum? sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    _i2.SharedSealedParent? sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    _i2.SharedSealedChild? sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'SharedContainer',
      'sharedModel': sharedModel.toJson(),
      'sharedModelWithModuleAlias': sharedModelWithModuleAlias.toJson(),
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
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedContainerImpl extends SharedContainer {
  _SharedContainerImpl({
    required _i2.SharedModel sharedModel,
    required _i2.SharedModel sharedModelWithModuleAlias,
    required _i2.SharedSubclass sharedSubclass,
    _i2.SharedSubclass? sharedSubclassNullable,
    required _i2.SharedEnum sharedEnum,
    _i2.SharedEnum? sharedEnumNullable,
    required _i2.SharedSealedParent sharedSealedParent,
    _i2.SharedSealedParent? sharedSealedParentNullable,
    required _i2.SharedSealedChild sharedSealedChild,
    _i2.SharedSealedChild? sharedSealedChildNullable,
  }) : super._(
         sharedModel: sharedModel,
         sharedModelWithModuleAlias: sharedModelWithModuleAlias,
         sharedSubclass: sharedSubclass,
         sharedSubclassNullable: sharedSubclassNullable,
         sharedEnum: sharedEnum,
         sharedEnumNullable: sharedEnumNullable,
         sharedSealedParent: sharedSealedParent,
         sharedSealedParentNullable: sharedSealedParentNullable,
         sharedSealedChild: sharedSealedChild,
         sharedSealedChildNullable: sharedSealedChildNullable,
       );

  /// Returns a shallow copy of this [SharedContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  SharedContainer copyWith({
    _i2.SharedModel? sharedModel,
    _i2.SharedModel? sharedModelWithModuleAlias,
    _i2.SharedSubclass? sharedSubclass,
    Object? sharedSubclassNullable = _Undefined,
    _i2.SharedEnum? sharedEnum,
    Object? sharedEnumNullable = _Undefined,
    _i2.SharedSealedParent? sharedSealedParent,
    Object? sharedSealedParentNullable = _Undefined,
    _i2.SharedSealedChild? sharedSealedChild,
    Object? sharedSealedChildNullable = _Undefined,
  }) {
    return SharedContainer(
      sharedModel: sharedModel ?? this.sharedModel.copyWith(),
      sharedModelWithModuleAlias:
          sharedModelWithModuleAlias ??
          this.sharedModelWithModuleAlias.copyWith(),
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
    );
  }
}
