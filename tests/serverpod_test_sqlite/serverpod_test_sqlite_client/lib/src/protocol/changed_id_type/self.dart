/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: depend_on_referenced_packages

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_serialization/undefined_sentinel.dart' as _issu;
import 'package:serverpod_test_sqlite_client/src/protocol/protocol.dart'
    as _i0ntutnq;
import '../changed_id_type/self.dart' as _iqjmn1nu;

abstract class ChangedIdTypeSelf
    implements _isc.SerializableModel, _isc.ProtocolSerialization {
  ChangedIdTypeSelf._({
    _isc.UuidValue? id,
    required this.name,
    this.previous,
    this.nextId,
    this.next,
    this.parentId,
    this.parent,
    this.children,
  }) : id = id ?? const _isc.Uuid().v4obj();

  factory ChangedIdTypeSelf({
    _isc.UuidValue? id,
    required String name,
    _iqjmn1nu.ChangedIdTypeSelf? previous,
    _isc.UuidValue? nextId,
    _iqjmn1nu.ChangedIdTypeSelf? next,
    _isc.UuidValue? parentId,
    _iqjmn1nu.ChangedIdTypeSelf? parent,
    List<_iqjmn1nu.ChangedIdTypeSelf>? children,
  }) = _ChangedIdTypeSelfImpl;

  factory ChangedIdTypeSelf.fromJson(Map<String, dynamic> jsonSerialization) {
    return ChangedIdTypeSelf(
      id: jsonSerialization['id'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['id']),
      name: jsonSerialization['name'] as String,
      previous: jsonSerialization['previous'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['previous'],
            ),
      nextId: jsonSerialization['nextId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['nextId']),
      next: jsonSerialization['next'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['next'],
            ),
      parentId: jsonSerialization['parentId'] == null
          ? null
          : _isc.UuidValueJsonExtension.fromJson(jsonSerialization['parentId']),
      parent: jsonSerialization['parent'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<_iqjmn1nu.ChangedIdTypeSelf>(
              jsonSerialization['parent'],
            ),
      children: jsonSerialization['children'] == null
          ? null
          : _i0ntutnq.Protocol().deserialize<List<_iqjmn1nu.ChangedIdTypeSelf>>(
              jsonSerialization['children'],
            ),
    );
  }

  /// The id of the object.
  _isc.UuidValue? id;

  String name;

  _iqjmn1nu.ChangedIdTypeSelf? previous;

  _isc.UuidValue? nextId;

  _iqjmn1nu.ChangedIdTypeSelf? next;

  _isc.UuidValue? parentId;

  _iqjmn1nu.ChangedIdTypeSelf? parent;

  List<_iqjmn1nu.ChangedIdTypeSelf>? children;

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  ChangedIdTypeSelf copyWith({
    _isc.UuidValue? id = const _issu.$UndefinedUuidValue(),
    String? name,
    _iqjmn1nu.ChangedIdTypeSelf? previous =
        const _UndefinedChangedIdTypeSelf$previous(),
    _isc.UuidValue? nextId = const _issu.$UndefinedUuidValue(),
    _iqjmn1nu.ChangedIdTypeSelf? next =
        const _UndefinedChangedIdTypeSelf$previous(),
    _isc.UuidValue? parentId = const _issu.$UndefinedUuidValue(),
    _iqjmn1nu.ChangedIdTypeSelf? parent =
        const _UndefinedChangedIdTypeSelf$previous(),
    List<_iqjmn1nu.ChangedIdTypeSelf>? children =
        const _issu.$UndefinedList<_iqjmn1nu.ChangedIdTypeSelf>(),
  });
  @override
  Map<String, dynamic> toJson() {
    return {
      '__className__': 'ChangedIdTypeSelf',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (previous != null) 'previous': previous?.toJson(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      if (next != null) 'next': next?.toJson(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (parent != null) 'parent': parent?.toJson(),
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJson()),
    };
  }

  @override
  Map<String, dynamic> toJsonForProtocol() {
    return {
      '__className__': 'ChangedIdTypeSelf',
      if (id != null) 'id': id?.toJson(),
      'name': name,
      if (previous != null) 'previous': previous?.toJsonForProtocol(),
      if (nextId != null) 'nextId': nextId?.toJson(),
      if (next != null) 'next': next?.toJsonForProtocol(),
      if (parentId != null) 'parentId': parentId?.toJson(),
      if (parent != null) 'parent': parent?.toJsonForProtocol(),
      if (children != null)
        'children': children?.toJson(valueToJson: (v) => v.toJsonForProtocol()),
    };
  }

  @override
  String toString() {
    return _isc.SerializationManager.encode(this);
  }
}

class _UndefinedChangedIdTypeSelf$previous extends _issu.UndefinedSentinel
    implements _iqjmn1nu.ChangedIdTypeSelf {
  const _UndefinedChangedIdTypeSelf$previous();
}

class _ChangedIdTypeSelfImpl extends ChangedIdTypeSelf {
  _ChangedIdTypeSelfImpl({
    _isc.UuidValue? id,
    required String name,
    _iqjmn1nu.ChangedIdTypeSelf? previous,
    _isc.UuidValue? nextId,
    _iqjmn1nu.ChangedIdTypeSelf? next,
    _isc.UuidValue? parentId,
    _iqjmn1nu.ChangedIdTypeSelf? parent,
    List<_iqjmn1nu.ChangedIdTypeSelf>? children,
  }) : super._(
         id: id,
         name: name,
         previous: previous,
         nextId: nextId,
         next: next,
         parentId: parentId,
         parent: parent,
         children: children,
       );

  /// Returns a shallow copy of this [ChangedIdTypeSelf]
  /// with some or all fields replaced by the given arguments.
  @_isc.useResult
  @override
  ChangedIdTypeSelf copyWith({
    _isc.UuidValue? id = const _issu.$UndefinedUuidValue(),
    String? name,
    _iqjmn1nu.ChangedIdTypeSelf? previous =
        const _UndefinedChangedIdTypeSelf$previous(),
    _isc.UuidValue? nextId = const _issu.$UndefinedUuidValue(),
    _iqjmn1nu.ChangedIdTypeSelf? next =
        const _UndefinedChangedIdTypeSelf$previous(),
    _isc.UuidValue? parentId = const _issu.$UndefinedUuidValue(),
    _iqjmn1nu.ChangedIdTypeSelf? parent =
        const _UndefinedChangedIdTypeSelf$previous(),
    List<_iqjmn1nu.ChangedIdTypeSelf>? children =
        const _issu.$UndefinedList<_iqjmn1nu.ChangedIdTypeSelf>(),
  }) {
    return ChangedIdTypeSelf(
      id: id is _issu.UndefinedSentinel ? this.id : id,
      name: name ?? this.name,
      previous: previous is _issu.UndefinedSentinel
          ? this.previous?.copyWith()
          : previous,
      nextId: nextId is _issu.UndefinedSentinel ? this.nextId : nextId,
      next: next is _issu.UndefinedSentinel ? this.next?.copyWith() : next,
      parentId: parentId is _issu.UndefinedSentinel ? this.parentId : parentId,
      parent: parent is _issu.UndefinedSentinel
          ? this.parent?.copyWith()
          : parent,
      children: children is _issu.UndefinedSentinel
          ? this.children?.map((e0) => e0.copyWith()).toList()
          : children,
    );
  }
}
