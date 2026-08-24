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
import 'package:serverpod_serialization/serverpod_serialization.dart' as _iss;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;

abstract class SharedContainer
    implements _iss.SerializableModel, _iss.ProtocolSerialization {
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
    required this.sharedSealedAppException,
    this.sharedSealedAppExceptionNullable,
    required this.sharedNotFoundException,
    this.sharedNotFoundExceptionNullable,
    required this.sharedExtendedAppException,
    this.sharedExtendedAppExceptionNullable,
  });

  factory SharedContainer({
    required _ilwf0zl1.SharedModel sharedModel,
    required _ilwf0zl1.SharedModel sharedModelWithModuleAlias,
    required _ilwf0zl1.SharedSubclass sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    required _ilwf0zl1.SharedSealedParent sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    required _ilwf0zl1.SharedSealedChild sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    required _ilwf0zl1.SharedSealedAppException sharedSealedAppException,
    _ilwf0zl1.SharedSealedAppException? sharedSealedAppExceptionNullable,
    required _ilwf0zl1.SharedNotFoundException sharedNotFoundException,
    _ilwf0zl1.SharedNotFoundException? sharedNotFoundExceptionNullable,
    required _ilwf0zl1.SharedExtendedAppException sharedExtendedAppException,
    _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppExceptionNullable,
  }) = _SharedContainerImpl;

  factory SharedContainer.fromJson(Map<String, dynamic> jsonSerialization) {
    return SharedContainer(
      sharedModel: _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedModel>(
        jsonSerialization['sharedModel'],
      ),
      sharedModelWithModuleAlias: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedModel>(
            jsonSerialization['sharedModelWithModuleAlias'],
          ),
      sharedSubclass: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedSubclass>(
            jsonSerialization['sharedSubclass'],
          ),
      sharedSubclassNullable:
          jsonSerialization['sharedSubclassNullable'] == null
          ? null
          : _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedSubclass>(
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
      sharedSealedParent: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedParent>(
            jsonSerialization['sharedSealedParent'],
          ),
      sharedSealedParentNullable:
          jsonSerialization['sharedSealedParentNullable'] == null
          ? null
          : _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedSealedParent>(
              jsonSerialization['sharedSealedParentNullable'],
            ),
      sharedSealedChild: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedChild>(
            jsonSerialization['sharedSealedChild'],
          ),
      sharedSealedChildNullable:
          jsonSerialization['sharedSealedChildNullable'] == null
          ? null
          : _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedSealedChild>(
              jsonSerialization['sharedSealedChildNullable'],
            ),
      sharedSealedAppException: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedSealedAppException>(
            jsonSerialization['sharedSealedAppException'],
          ),
      sharedSealedAppExceptionNullable:
          jsonSerialization['sharedSealedAppExceptionNullable'] == null
          ? null
          : _ilwf0zl1.Protocol()
                .deserialize<_ilwf0zl1.SharedSealedAppException>(
                  jsonSerialization['sharedSealedAppExceptionNullable'],
                ),
      sharedNotFoundException: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedNotFoundException>(
            jsonSerialization['sharedNotFoundException'],
          ),
      sharedNotFoundExceptionNullable:
          jsonSerialization['sharedNotFoundExceptionNullable'] == null
          ? null
          : _ilwf0zl1.Protocol().deserialize<_ilwf0zl1.SharedNotFoundException>(
              jsonSerialization['sharedNotFoundExceptionNullable'],
            ),
      sharedExtendedAppException: _ilwf0zl1.Protocol()
          .deserialize<_ilwf0zl1.SharedExtendedAppException>(
            jsonSerialization['sharedExtendedAppException'],
          ),
      sharedExtendedAppExceptionNullable:
          jsonSerialization['sharedExtendedAppExceptionNullable'] == null
          ? null
          : _ilwf0zl1.Protocol()
                .deserialize<_ilwf0zl1.SharedExtendedAppException>(
                  jsonSerialization['sharedExtendedAppExceptionNullable'],
                ),
    );
  }

  _ilwf0zl1.SharedModel sharedModel;

  _ilwf0zl1.SharedModel sharedModelWithModuleAlias;

  _ilwf0zl1.SharedSubclass sharedSubclass;

  _ilwf0zl1.SharedSubclass? sharedSubclassNullable;

  _ilwf0zl1.SharedEnum sharedEnum;

  _ilwf0zl1.SharedEnum? sharedEnumNullable;

  _ilwf0zl1.SharedSealedParent sharedSealedParent;

  _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable;

  _ilwf0zl1.SharedSealedChild sharedSealedChild;

  _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable;

  _ilwf0zl1.SharedSealedAppException sharedSealedAppException;

  _ilwf0zl1.SharedSealedAppException? sharedSealedAppExceptionNullable;

  _ilwf0zl1.SharedNotFoundException sharedNotFoundException;

  _ilwf0zl1.SharedNotFoundException? sharedNotFoundExceptionNullable;

  _ilwf0zl1.SharedExtendedAppException sharedExtendedAppException;

  _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppExceptionNullable;

  /// Returns a shallow copy of this [SharedContainer]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  SharedContainer copyWith({
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    _ilwf0zl1.SharedEnum? sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    _ilwf0zl1.SharedSealedParent? sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    _ilwf0zl1.SharedSealedChild? sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    _ilwf0zl1.SharedSealedAppException? sharedSealedAppException,
    _ilwf0zl1.SharedSealedAppException? sharedSealedAppExceptionNullable,
    _ilwf0zl1.SharedNotFoundException? sharedNotFoundException,
    _ilwf0zl1.SharedNotFoundException? sharedNotFoundExceptionNullable,
    _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppException,
    _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppExceptionNullable,
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
      'sharedSealedAppException': sharedSealedAppException.toJson(),
      if (sharedSealedAppExceptionNullable != null)
        'sharedSealedAppExceptionNullable': sharedSealedAppExceptionNullable
            ?.toJson(),
      'sharedNotFoundException': sharedNotFoundException.toJson(),
      if (sharedNotFoundExceptionNullable != null)
        'sharedNotFoundExceptionNullable': sharedNotFoundExceptionNullable
            ?.toJson(),
      'sharedExtendedAppException': sharedExtendedAppException.toJson(),
      if (sharedExtendedAppExceptionNullable != null)
        'sharedExtendedAppExceptionNullable': sharedExtendedAppExceptionNullable
            ?.toJson(),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'SharedContainer',
      'sharedModel': sharedModel.toJsonForProtocol(),
      'sharedModelWithModuleAlias': sharedModelWithModuleAlias
          .toJsonForProtocol(),
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
      'sharedSealedAppException': sharedSealedAppException.toJsonForProtocol(),
      if (sharedSealedAppExceptionNullable != null)
        'sharedSealedAppExceptionNullable': sharedSealedAppExceptionNullable
            ?.toJsonForProtocol(),
      'sharedNotFoundException': sharedNotFoundException.toJsonForProtocol(),
      if (sharedNotFoundExceptionNullable != null)
        'sharedNotFoundExceptionNullable': sharedNotFoundExceptionNullable
            ?.toJsonForProtocol(),
      'sharedExtendedAppException': sharedExtendedAppException
          .toJsonForProtocol(),
      if (sharedExtendedAppExceptionNullable != null)
        'sharedExtendedAppExceptionNullable': sharedExtendedAppExceptionNullable
            ?.toJsonForProtocol(),
    };
  }

  @override
  String toString() {
    return _iss.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _SharedContainerImpl extends SharedContainer {
  _SharedContainerImpl({
    required _ilwf0zl1.SharedModel sharedModel,
    required _ilwf0zl1.SharedModel sharedModelWithModuleAlias,
    required _ilwf0zl1.SharedSubclass sharedSubclass,
    _ilwf0zl1.SharedSubclass? sharedSubclassNullable,
    required _ilwf0zl1.SharedEnum sharedEnum,
    _ilwf0zl1.SharedEnum? sharedEnumNullable,
    required _ilwf0zl1.SharedSealedParent sharedSealedParent,
    _ilwf0zl1.SharedSealedParent? sharedSealedParentNullable,
    required _ilwf0zl1.SharedSealedChild sharedSealedChild,
    _ilwf0zl1.SharedSealedChild? sharedSealedChildNullable,
    required _ilwf0zl1.SharedSealedAppException sharedSealedAppException,
    _ilwf0zl1.SharedSealedAppException? sharedSealedAppExceptionNullable,
    required _ilwf0zl1.SharedNotFoundException sharedNotFoundException,
    _ilwf0zl1.SharedNotFoundException? sharedNotFoundExceptionNullable,
    required _ilwf0zl1.SharedExtendedAppException sharedExtendedAppException,
    _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppExceptionNullable,
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
         sharedSealedAppException: sharedSealedAppException,
         sharedSealedAppExceptionNullable: sharedSealedAppExceptionNullable,
         sharedNotFoundException: sharedNotFoundException,
         sharedNotFoundExceptionNullable: sharedNotFoundExceptionNullable,
         sharedExtendedAppException: sharedExtendedAppException,
         sharedExtendedAppExceptionNullable: sharedExtendedAppExceptionNullable,
       );

  /// Returns a shallow copy of this [SharedContainer]
  /// with some or all fields replaced by the given arguments.
  @_iss.useResult
  @override
  SharedContainer copyWith({
    _ilwf0zl1.SharedModel? sharedModel,
    _ilwf0zl1.SharedModel? sharedModelWithModuleAlias,
    _ilwf0zl1.SharedSubclass? sharedSubclass,
    Object? sharedSubclassNullable = _Undefined,
    _ilwf0zl1.SharedEnum? sharedEnum,
    Object? sharedEnumNullable = _Undefined,
    _ilwf0zl1.SharedSealedParent? sharedSealedParent,
    Object? sharedSealedParentNullable = _Undefined,
    _ilwf0zl1.SharedSealedChild? sharedSealedChild,
    Object? sharedSealedChildNullable = _Undefined,
    _ilwf0zl1.SharedSealedAppException? sharedSealedAppException,
    Object? sharedSealedAppExceptionNullable = _Undefined,
    _ilwf0zl1.SharedNotFoundException? sharedNotFoundException,
    Object? sharedNotFoundExceptionNullable = _Undefined,
    _ilwf0zl1.SharedExtendedAppException? sharedExtendedAppException,
    Object? sharedExtendedAppExceptionNullable = _Undefined,
  }) {
    return SharedContainer(
      sharedModel: sharedModel ?? this.sharedModel.copyWith(),
      sharedModelWithModuleAlias:
          sharedModelWithModuleAlias ??
          this.sharedModelWithModuleAlias.copyWith(),
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
      sharedSealedAppException:
          sharedSealedAppException ?? this.sharedSealedAppException.copyWith(),
      sharedSealedAppExceptionNullable:
          sharedSealedAppExceptionNullable
              is _ilwf0zl1.SharedSealedAppException?
          ? sharedSealedAppExceptionNullable
          : this.sharedSealedAppExceptionNullable?.copyWith(),
      sharedNotFoundException:
          sharedNotFoundException ?? this.sharedNotFoundException.copyWith(),
      sharedNotFoundExceptionNullable:
          sharedNotFoundExceptionNullable is _ilwf0zl1.SharedNotFoundException?
          ? sharedNotFoundExceptionNullable
          : this.sharedNotFoundExceptionNullable?.copyWith(),
      sharedExtendedAppException:
          sharedExtendedAppException ??
          this.sharedExtendedAppException.copyWith(),
      sharedExtendedAppExceptionNullable:
          sharedExtendedAppExceptionNullable
              is _ilwf0zl1.SharedExtendedAppException?
          ? sharedExtendedAppExceptionNullable
          : this.sharedExtendedAppExceptionNullable?.copyWith(),
    );
  }
}
