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
import '../../inheritance/polymorphism/child.dart' as _i2;

/// A class that holds child objects.
abstract class PolymorphicChildContainer implements _i1.SerializableModel {
  PolymorphicChildContainer._({
    required this.child,
    this.nullableChild,
    required this.childrenList,
    required this.nullableChildrenList,
    required this.childrenMap,
    required this.nullableChildrenMap,
  });

  factory PolymorphicChildContainer({
    required _i2.PolymorphicChild child,
    _i2.PolymorphicChild? nullableChild,
    required List<_i2.PolymorphicChild> childrenList,
    required List<_i2.PolymorphicChild?> nullableChildrenList,
    required Map<String, _i2.PolymorphicChild> childrenMap,
    required Map<String, _i2.PolymorphicChild?> nullableChildrenMap,
  }) = _PolymorphicChildContainerImpl;

  factory PolymorphicChildContainer.fromJson(
    Map<String, dynamic> jsonSerialization,
  ) {
    return PolymorphicChildContainer(
      child: _i2.PolymorphicChild.fromJson(
        (jsonSerialization['child'] as Map<String, dynamic>),
      ),
      nullableChild: jsonSerialization['nullableChild'] == null
          ? null
          : _i2.PolymorphicChild.fromJson(
              (jsonSerialization['nullableChild'] as Map<String, dynamic>),
            ),
      childrenList: (jsonSerialization['childrenList'] as List)
          .map(
            (e) => _i2.PolymorphicChild.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      nullableChildrenList: (jsonSerialization['nullableChildrenList'] as List)
          .map(
            (e) => e == null
                ? null
                : _i2.PolymorphicChild.fromJson((e as Map<String, dynamic>)),
          )
          .toList(),
      childrenMap: (jsonSerialization['childrenMap'] as Map).map(
        (k, v) => MapEntry(
          k as String,
          _i2.PolymorphicChild.fromJson((v as Map<String, dynamic>)),
        ),
      ),
      nullableChildrenMap: (jsonSerialization['nullableChildrenMap'] as Map)
          .map(
            (k, v) => MapEntry(
              k as String,
              v == null
                  ? null
                  : _i2.PolymorphicChild.fromJson((v as Map<String, dynamic>)),
            ),
          ),
    );
  }

  /// Direct contained child.
  _i2.PolymorphicChild child;

  /// Nullable direct contained child.
  _i2.PolymorphicChild? nullableChild;

  /// List of children.
  List<_i2.PolymorphicChild> childrenList;

  /// List of nullable children.
  List<_i2.PolymorphicChild?> nullableChildrenList;

  /// Map of children.
  Map<String, _i2.PolymorphicChild> childrenMap;

  /// Map of nullable children.
  Map<String, _i2.PolymorphicChild?> nullableChildrenMap;

  /// Returns a shallow copy of this [PolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  PolymorphicChildContainer copyWith({
    _i2.PolymorphicChild? child,
    _i2.PolymorphicChild? nullableChild,
    List<_i2.PolymorphicChild>? childrenList,
    List<_i2.PolymorphicChild?>? nullableChildrenList,
    Map<String, _i2.PolymorphicChild>? childrenMap,
    Map<String, _i2.PolymorphicChild?>? nullableChildrenMap,
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      'child': child.toJson(),
      if (nullableChild != null) 'nullableChild': nullableChild?.toJson(),
      'childrenList': childrenList.toJson(valueToJson: (v) => v.toJson()),
      'nullableChildrenList': nullableChildrenList.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
      'childrenMap': childrenMap.toJson(valueToJson: (v) => v.toJson()),
      'nullableChildrenMap': nullableChildrenMap.toJson(
        valueToJson: (v) => v?.toJson(),
      ),
    };
  }

  @override
  String toString() {
    return _i1.SerializationManager.encode(this);
  }
}

class _Undefined {}

class _PolymorphicChildContainerImpl extends PolymorphicChildContainer {
  _PolymorphicChildContainerImpl({
    required _i2.PolymorphicChild child,
    _i2.PolymorphicChild? nullableChild,
    required List<_i2.PolymorphicChild> childrenList,
    required List<_i2.PolymorphicChild?> nullableChildrenList,
    required Map<String, _i2.PolymorphicChild> childrenMap,
    required Map<String, _i2.PolymorphicChild?> nullableChildrenMap,
  }) : super._(
         child: child,
         nullableChild: nullableChild,
         childrenList: childrenList,
         nullableChildrenList: nullableChildrenList,
         childrenMap: childrenMap,
         nullableChildrenMap: nullableChildrenMap,
       );

  /// Returns a shallow copy of this [PolymorphicChildContainer]
  /// with some or all fields replaced by the given arguments.
  @_i1.useResult
  @override
  PolymorphicChildContainer copyWith({
    _i2.PolymorphicChild? child,
    Object? nullableChild = _Undefined,
    List<_i2.PolymorphicChild>? childrenList,
    List<_i2.PolymorphicChild?>? nullableChildrenList,
    Map<String, _i2.PolymorphicChild>? childrenMap,
    Map<String, _i2.PolymorphicChild?>? nullableChildrenMap,
  }) {
    return PolymorphicChildContainer(
      child: child ?? this.child.copyWith(),
      nullableChild: nullableChild is _i2.PolymorphicChild?
          ? nullableChild
          : this.nullableChild?.copyWith(),
      childrenList:
          childrenList ?? this.childrenList.map((e0) => e0.copyWith()).toList(),
      nullableChildrenList:
          nullableChildrenList ??
          this.nullableChildrenList.map((e0) => e0?.copyWith()).toList(),
      childrenMap:
          childrenMap ??
          this.childrenMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0.copyWith(),
            ),
          ),
      nullableChildrenMap:
          nullableChildrenMap ??
          this.nullableChildrenMap.map(
            (
              key0,
              value0,
            ) => MapEntry(
              key0,
              value0?.copyWith(),
            ),
          ),
    );
  }
}
