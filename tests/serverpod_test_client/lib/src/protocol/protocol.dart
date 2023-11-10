/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'entities_with_list_relations/city.dart' as _i2;
import 'entities_with_list_relations/organization.dart' as _i3;
import 'entities_with_list_relations/person.dart' as _i4;
import 'entities_with_relations/many_to_many/course.dart' as _i5;
import 'entities_with_relations/many_to_many/enrollment.dart' as _i6;
import 'entities_with_relations/many_to_many/student.dart' as _i7;
import 'entities_with_relations/nested_one_to_many/arena.dart' as _i8;
import 'entities_with_relations/nested_one_to_many/player.dart' as _i9;
import 'entities_with_relations/nested_one_to_many/team.dart' as _i10;
import 'entities_with_relations/one_to_many/comment.dart' as _i11;
import 'entities_with_relations/one_to_many/customer.dart' as _i12;
import 'entities_with_relations/one_to_many/order.dart' as _i13;
import 'entities_with_relations/one_to_one/address.dart' as _i14;
import 'entities_with_relations/one_to_one/citizen.dart' as _i15;
import 'entities_with_relations/one_to_one/company.dart' as _i16;
import 'entities_with_relations/one_to_one/town.dart' as _i17;
<<<<<<< HEAD
import 'entities_with_relations/self_relation/many_to_many/blocking.dart'
    as _i18;
import 'entities_with_relations/self_relation/many_to_many/member.dart' as _i19;
import 'entities_with_relations/self_relation/one_to_many/cat.dart' as _i20;
import 'entities_with_relations/self_relation/one_to_one/post.dart' as _i21;
import 'exception_with_data.dart' as _i22;
import 'module_datatype.dart' as _i23;
import 'nullability.dart' as _i24;
import 'object_field_scopes.dart' as _i25;
import 'object_with_bytedata.dart' as _i26;
import 'object_with_duration.dart' as _i27;
import 'object_with_enum.dart' as _i28;
import 'object_with_index.dart' as _i29;
import 'object_with_maps.dart' as _i30;
import 'object_with_object.dart' as _i31;
import 'object_with_parent.dart' as _i32;
import 'object_with_self_parent.dart' as _i33;
import 'object_with_uuid.dart' as _i34;
import 'related_unique_data.dart' as _i35;
import 'serverOnly/default_server_only_class.dart' as _i36;
import 'serverOnly/default_server_only_enum.dart' as _i37;
import 'serverOnly/not_server_only_class.dart' as _i38;
import 'serverOnly/not_server_only_enum.dart' as _i39;
import 'simple_data.dart' as _i40;
import 'simple_data_list.dart' as _i41;
import 'simple_data_map.dart' as _i42;
import 'simple_date_time.dart' as _i43;
import 'test_enum.dart' as _i44;
import 'types.dart' as _i45;
import 'unique_data.dart' as _i46;
import 'protocol.dart' as _i47;
import 'package:serverpod_test_module_client/module.dart' as _i48;
import 'dart:typed_data' as _i49;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i50;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i51;
import 'package:uuid/uuid.dart' as _i52;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i53;
import 'package:serverpod_test_client/src/protocol/unique_data.dart' as _i54;
import 'package:serverpod_test_client/src/protocol/entities_with_list_relations/person.dart'
    as _i55;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/customer.dart'
    as _i56;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/comment.dart'
    as _i57;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/order.dart'
    as _i58;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/citizen.dart'
    as _i59;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/address.dart'
    as _i60;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/self_relation/one_to_one/post.dart'
    as _i61;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/company.dart'
    as _i62;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i63;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i64;
import 'package:serverpod_auth_client/module.dart' as _i65;
=======
import 'entities_with_relations/self_relation/post.dart' as _i18;
import 'exception_with_data.dart' as _i19;
import 'module_datatype.dart' as _i20;
import 'nullability.dart' as _i21;
import 'object_field_scopes.dart' as _i22;
import 'object_with_bytedata.dart' as _i23;
import 'object_with_duration.dart' as _i24;
import 'object_with_enum.dart' as _i25;
import 'object_with_index.dart' as _i26;
import 'object_with_maps.dart' as _i27;
import 'object_with_object.dart' as _i28;
import 'object_with_parent.dart' as _i29;
import 'object_with_self_parent.dart' as _i30;
import 'object_with_uuid.dart' as _i31;
import 'related_unique_data.dart' as _i32;
import 'serverOnly/default_server_only_class.dart' as _i33;
import 'serverOnly/default_server_only_enum.dart' as _i34;
import 'serverOnly/not_server_only_class.dart' as _i35;
import 'serverOnly/not_server_only_enum.dart' as _i36;
import 'simple_data.dart' as _i37;
import 'simple_data_list.dart' as _i38;
import 'simple_data_map.dart' as _i39;
import 'simple_date_time.dart' as _i40;
import 'test_enum.dart' as _i41;
import 'test_enum_stringified.dart' as _i42;
import 'types.dart' as _i43;
import 'unique_data.dart' as _i44;
import 'protocol.dart' as _i45;
import 'package:serverpod_test_module_client/module.dart' as _i46;
import 'dart:typed_data' as _i47;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i48;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i49;
import 'package:uuid/uuid.dart' as _i50;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i51;
import 'package:serverpod_test_client/src/protocol/unique_data.dart' as _i52;
import 'package:serverpod_test_client/src/protocol/entities_with_list_relations/person.dart'
    as _i53;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/customer.dart'
    as _i54;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/comment.dart'
    as _i55;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_many/order.dart'
    as _i56;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/citizen.dart'
    as _i57;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/address.dart'
    as _i58;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/self_relation/post.dart'
    as _i59;
import 'package:serverpod_test_client/src/protocol/entities_with_relations/one_to_one/company.dart'
    as _i60;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i61;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i62;
import 'package:serverpod_auth_client/module.dart' as _i63;
>>>>>>> c44799ee (test: Enum serialization.)
export 'entities_with_list_relations/city.dart';
export 'entities_with_list_relations/organization.dart';
export 'entities_with_list_relations/person.dart';
export 'entities_with_relations/many_to_many/course.dart';
export 'entities_with_relations/many_to_many/enrollment.dart';
export 'entities_with_relations/many_to_many/student.dart';
export 'entities_with_relations/nested_one_to_many/arena.dart';
export 'entities_with_relations/nested_one_to_many/player.dart';
export 'entities_with_relations/nested_one_to_many/team.dart';
export 'entities_with_relations/one_to_many/comment.dart';
export 'entities_with_relations/one_to_many/customer.dart';
export 'entities_with_relations/one_to_many/order.dart';
export 'entities_with_relations/one_to_one/address.dart';
export 'entities_with_relations/one_to_one/citizen.dart';
export 'entities_with_relations/one_to_one/company.dart';
export 'entities_with_relations/one_to_one/town.dart';
export 'entities_with_relations/self_relation/many_to_many/blocking.dart';
export 'entities_with_relations/self_relation/many_to_many/member.dart';
export 'entities_with_relations/self_relation/one_to_many/cat.dart';
export 'entities_with_relations/self_relation/one_to_one/post.dart';
export 'exception_with_data.dart';
export 'module_datatype.dart';
export 'nullability.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_index.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_self_parent.dart';
export 'object_with_uuid.dart';
export 'related_unique_data.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'simple_data_map.dart';
export 'simple_date_time.dart';
export 'test_enum.dart';
export 'test_enum_stringified.dart';
export 'types.dart';
export 'unique_data.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i2.City) {
      return _i2.City.fromJson(data, this) as T;
    }
    if (t == _i3.Organization) {
      return _i3.Organization.fromJson(data, this) as T;
    }
    if (t == _i4.Person) {
      return _i4.Person.fromJson(data, this) as T;
    }
    if (t == _i5.Course) {
      return _i5.Course.fromJson(data, this) as T;
    }
    if (t == _i6.Enrollment) {
      return _i6.Enrollment.fromJson(data, this) as T;
    }
    if (t == _i7.Student) {
      return _i7.Student.fromJson(data, this) as T;
    }
    if (t == _i8.Arena) {
      return _i8.Arena.fromJson(data, this) as T;
    }
    if (t == _i9.Player) {
      return _i9.Player.fromJson(data, this) as T;
    }
    if (t == _i10.Team) {
      return _i10.Team.fromJson(data, this) as T;
    }
    if (t == _i11.Comment) {
      return _i11.Comment.fromJson(data, this) as T;
    }
    if (t == _i12.Customer) {
      return _i12.Customer.fromJson(data, this) as T;
    }
    if (t == _i13.Order) {
      return _i13.Order.fromJson(data, this) as T;
    }
    if (t == _i14.Address) {
      return _i14.Address.fromJson(data, this) as T;
    }
    if (t == _i15.Citizen) {
      return _i15.Citizen.fromJson(data, this) as T;
    }
    if (t == _i16.Company) {
      return _i16.Company.fromJson(data, this) as T;
    }
    if (t == _i17.Town) {
      return _i17.Town.fromJson(data, this) as T;
    }
    if (t == _i18.Blocking) {
      return _i18.Blocking.fromJson(data, this) as T;
    }
    if (t == _i19.Member) {
      return _i19.Member.fromJson(data, this) as T;
    }
    if (t == _i20.Cat) {
      return _i20.Cat.fromJson(data, this) as T;
    }
    if (t == _i21.Post) {
      return _i21.Post.fromJson(data, this) as T;
    }
    if (t == _i22.ExceptionWithData) {
      return _i22.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i23.ModuleDatatype) {
      return _i23.ModuleDatatype.fromJson(data, this) as T;
    }
    if (t == _i24.Nullability) {
      return _i24.Nullability.fromJson(data, this) as T;
    }
    if (t == _i25.ObjectFieldScopes) {
      return _i25.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i26.ObjectWithByteData) {
      return _i26.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i27.ObjectWithDuration) {
      return _i27.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i28.ObjectWithEnum) {
      return _i28.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i29.ObjectWithIndex) {
      return _i29.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i30.ObjectWithMaps) {
      return _i30.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i31.ObjectWithObject) {
      return _i31.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i32.ObjectWithParent) {
      return _i32.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i33.ObjectWithSelfParent) {
      return _i33.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i34.ObjectWithUuid) {
      return _i34.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i35.RelatedUniqueData) {
      return _i35.RelatedUniqueData.fromJson(data, this) as T;
    }
    if (t == _i36.DefaultServerOnlyClass) {
      return _i36.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i37.DefaultServerOnlyEnum) {
      return _i37.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i38.NotServerOnlyClass) {
      return _i38.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i39.NotServerOnlyEnum) {
      return _i39.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i40.SimpleData) {
      return _i40.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i41.SimpleDataList) {
      return _i41.SimpleDataList.fromJson(data, this) as T;
    }
<<<<<<< HEAD
    if (t == _i42.SimpleDataMap) {
      return _i42.SimpleDataMap.fromJson(data, this) as T;
    }
    if (t == _i43.SimpleDateTime) {
      return _i43.SimpleDateTime.fromJson(data, this) as T;
    }
    if (t == _i44.TestEnum) {
      return _i44.TestEnum.fromJson(data) as T;
    }
    if (t == _i45.Types) {
      return _i45.Types.fromJson(data, this) as T;
    }
    if (t == _i46.UniqueData) {
      return _i46.UniqueData.fromJson(data, this) as T;
=======
    if (t == _i42.TestEnumStringified) {
      return _i42.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i43.Types) {
      return _i43.Types.fromJson(data, this) as T;
    }
    if (t == _i44.UniqueData) {
      return _i44.UniqueData.fromJson(data, this) as T;
>>>>>>> c44799ee (test: Enum serialization.)
    }
    if (t == _i1.getType<_i2.City?>()) {
      return (data != null ? _i2.City.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i3.Organization?>()) {
      return (data != null ? _i3.Organization.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.Person?>()) {
      return (data != null ? _i4.Person.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i5.Course?>()) {
      return (data != null ? _i5.Course.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i6.Enrollment?>()) {
      return (data != null ? _i6.Enrollment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.Student?>()) {
      return (data != null ? _i7.Student.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.Arena?>()) {
      return (data != null ? _i8.Arena.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i9.Player?>()) {
      return (data != null ? _i9.Player.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i10.Team?>()) {
      return (data != null ? _i10.Team.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i11.Comment?>()) {
      return (data != null ? _i11.Comment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i12.Customer?>()) {
      return (data != null ? _i12.Customer.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i13.Order?>()) {
      return (data != null ? _i13.Order.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i14.Address?>()) {
      return (data != null ? _i14.Address.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i15.Citizen?>()) {
      return (data != null ? _i15.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i16.Company?>()) {
      return (data != null ? _i16.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i17.Town?>()) {
      return (data != null ? _i17.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i18.Blocking?>()) {
      return (data != null ? _i18.Blocking.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i19.Member?>()) {
      return (data != null ? _i19.Member.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i20.Cat?>()) {
      return (data != null ? _i20.Cat.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i21.Post?>()) {
      return (data != null ? _i21.Post.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i22.ExceptionWithData?>()) {
      return (data != null ? _i22.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i23.ModuleDatatype?>()) {
      return (data != null ? _i23.ModuleDatatype.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i24.Nullability?>()) {
      return (data != null ? _i24.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i25.ObjectFieldScopes?>()) {
      return (data != null ? _i25.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i26.ObjectWithByteData?>()) {
      return (data != null
          ? _i26.ObjectWithByteData.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i27.ObjectWithDuration?>()) {
      return (data != null
          ? _i27.ObjectWithDuration.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i28.ObjectWithEnum?>()) {
      return (data != null ? _i28.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i29.ObjectWithIndex?>()) {
      return (data != null ? _i29.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i30.ObjectWithMaps?>()) {
      return (data != null ? _i30.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i31.ObjectWithObject?>()) {
      return (data != null ? _i31.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i32.ObjectWithParent?>()) {
      return (data != null ? _i32.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i33.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i33.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i34.ObjectWithUuid?>()) {
      return (data != null ? _i34.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i35.RelatedUniqueData?>()) {
      return (data != null ? _i35.RelatedUniqueData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i36.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i36.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i37.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i37.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.NotServerOnlyClass?>()) {
      return (data != null
          ? _i38.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i39.NotServerOnlyEnum?>()) {
      return (data != null ? _i39.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.SimpleData?>()) {
      return (data != null ? _i40.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i41.SimpleDataList?>()) {
      return (data != null ? _i41.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i42.SimpleDataMap?>()) {
      return (data != null ? _i42.SimpleDataMap.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i43.SimpleDateTime?>()) {
      return (data != null ? _i43.SimpleDateTime.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i44.TestEnum?>()) {
      return (data != null ? _i44.TestEnum.fromJson(data) : null) as T;
    }
<<<<<<< HEAD
    if (t == _i1.getType<_i45.Types?>()) {
      return (data != null ? _i45.Types.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i46.UniqueData?>()) {
      return (data != null ? _i46.UniqueData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<List<_i47.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i47.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.Cat>(e)).toList()
=======
    if (t == _i1.getType<_i42.TestEnumStringified?>()) {
      return (data != null ? _i42.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.Types?>()) {
      return (data != null ? _i43.Types.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i44.UniqueData?>()) {
      return (data != null ? _i44.UniqueData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<List<_i45.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i45.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.Comment>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i48.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i48.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i48.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i48.ModuleClass>(v))) as dynamic;
=======
    if (t == List<_i46.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i46.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i46.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i46.ModuleClass>(v))) as dynamic;
>>>>>>> c44799ee (test: Enum serialization.)
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i47.SimpleData>) {
      return (data as List).map((e) => deserialize<_i47.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i47.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i47.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i47.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i47.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.SimpleData?>(e)).toList()
=======
    if (t == List<_i45.SimpleData>) {
      return (data as List).map((e) => deserialize<_i45.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i45.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i45.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i45.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i45.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.SimpleData?>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          : null) as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          : null) as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i49.ByteData>) {
      return (data as List).map((e) => deserialize<_i49.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i49.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i49.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i49.ByteData?>) {
      return (data as List).map((e) => deserialize<_i49.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i49.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i49.ByteData?>(e)).toList()
=======
    if (t == List<_i47.ByteData>) {
      return (data as List).map((e) => deserialize<_i47.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i47.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i47.ByteData?>) {
      return (data as List).map((e) => deserialize<_i47.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i47.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.ByteData?>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<Duration?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i1.UuidValue?>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i47.TestEnum>) {
      return (data as List).map((e) => deserialize<_i47.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i47.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i47.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i47.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i47.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i47.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i47.SimpleData>(v)))
=======
    if (t == List<_i45.TestEnum>) {
      return (data as List).map((e) => deserialize<_i45.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i45.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i45.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i45.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i45.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i45.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i45.SimpleData>(v)))
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == Map<String, _i49.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i49.ByteData>(v)))
=======
    if (t == Map<String, _i47.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i47.ByteData>(v)))
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == Map<String, _i47.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i47.SimpleData?>(v))) as dynamic;
=======
    if (t == Map<String, _i45.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i45.SimpleData?>(v))) as dynamic;
>>>>>>> c44799ee (test: Enum serialization.)
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == Map<String, _i49.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i49.ByteData?>(v)))
=======
    if (t == Map<String, _i47.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i47.ByteData?>(v)))
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i1.UuidValue?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue?>(v)))
          as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == _i1.getType<List<_i47.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i47.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i47.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i50.Types>) {
      return (data as List).map((e) => deserialize<_i50.Types>(e)).toList()
=======
    if (t == _i1.getType<List<_i45.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i45.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i45.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i48.Types>) {
      return (data as List).map((e) => deserialize<_i48.Types>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i51.TestEnum>) {
      return (data as List).map((e) => deserialize<_i51.TestEnum>(e)).toList()
=======
    if (t == List<_i49.TestEnum>) {
      return (data as List).map((e) => deserialize<_i49.TestEnum>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i52.UuidValue>) {
      return (data as List).map((e) => deserialize<_i52.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == List<_i53.SimpleData>) {
      return (data as List).map((e) => deserialize<_i53.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i54.UniqueData>) {
      return (data as List).map((e) => deserialize<_i54.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i55.Person>) {
      return (data as List).map((e) => deserialize<_i55.Person>(e)).toList()
          as dynamic;
    }
    if (t == List<_i56.Customer>) {
      return (data as List).map((e) => deserialize<_i56.Customer>(e)).toList()
          as dynamic;
    }
    if (t == List<_i57.Comment>) {
      return (data as List).map((e) => deserialize<_i57.Comment>(e)).toList()
          as dynamic;
    }
    if (t == List<_i58.Order>) {
      return (data as List).map((e) => deserialize<_i58.Order>(e)).toList()
          as dynamic;
    }
    if (t == List<_i59.Citizen>) {
      return (data as List).map((e) => deserialize<_i59.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i60.Address>) {
      return (data as List).map((e) => deserialize<_i60.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i61.Post>) {
      return (data as List).map((e) => deserialize<_i61.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i62.Company>) {
      return (data as List).map((e) => deserialize<_i62.Company>(e)).toList()
=======
    if (t == List<_i50.UuidValue>) {
      return (data as List).map((e) => deserialize<_i50.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == List<_i51.SimpleData>) {
      return (data as List).map((e) => deserialize<_i51.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i52.UniqueData>) {
      return (data as List).map((e) => deserialize<_i52.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i53.Person>) {
      return (data as List).map((e) => deserialize<_i53.Person>(e)).toList()
          as dynamic;
    }
    if (t == List<_i54.Customer>) {
      return (data as List).map((e) => deserialize<_i54.Customer>(e)).toList()
          as dynamic;
    }
    if (t == List<_i55.Comment>) {
      return (data as List).map((e) => deserialize<_i55.Comment>(e)).toList()
          as dynamic;
    }
    if (t == List<_i56.Order>) {
      return (data as List).map((e) => deserialize<_i56.Order>(e)).toList()
          as dynamic;
    }
    if (t == List<_i57.Citizen>) {
      return (data as List).map((e) => deserialize<_i57.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i58.Address>) {
      return (data as List).map((e) => deserialize<_i58.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i59.Post>) {
      return (data as List).map((e) => deserialize<_i59.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i60.Company>) {
      return (data as List).map((e) => deserialize<_i60.Company>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
<<<<<<< HEAD
    if (t == List<_i49.ByteData>) {
      return (data as List).map((e) => deserialize<_i49.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i49.ByteData?>) {
      return (data as List).map((e) => deserialize<_i49.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i53.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i53.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i53.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i53.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i53.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i53.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i53.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i53.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i53.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i53.SimpleData?>(e)).toList()
=======
    if (t == List<_i47.ByteData>) {
      return (data as List).map((e) => deserialize<_i47.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i47.ByteData?>) {
      return (data as List).map((e) => deserialize<_i47.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i51.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i51.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i51.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i51.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i51.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i51.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i51.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i51.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i51.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i51.SimpleData?>(e)).toList()
>>>>>>> c44799ee (test: Enum serialization.)
          : null) as dynamic;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList()
          as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<Map<String, int>>(v))) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == Map<_i51.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i51.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i51.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i51.TestEnum>(v)))
=======
    if (t == Map<_i49.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i49.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i49.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i49.TestEnum>(v)))
>>>>>>> c44799ee (test: Enum serialization.)
          as dynamic;
    }
    if (t == Map<String, double>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double>(v))) as dynamic;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double?>(v))) as dynamic;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          as dynamic;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool?>(v)))
          as dynamic;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as dynamic;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as dynamic;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          as dynamic;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == Map<String, _i49.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i49.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i49.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i49.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i53.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i53.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i53.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i53.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i53.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i53.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i53.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i53.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i53.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i53.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i53.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i53.SimpleData?>(v)))
=======
    if (t == Map<String, _i47.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i47.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i47.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i47.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i51.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i51.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i51.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i51.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i51.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i51.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i51.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i51.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i51.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i51.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i51.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i51.SimpleData?>(v)))
>>>>>>> c44799ee (test: Enum serialization.)
          : null) as dynamic;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          as dynamic;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration?>(v)))
          as dynamic;
    }
<<<<<<< HEAD
    if (t == _i63.CustomClass) {
      return _i63.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i64.ExternalCustomClass) {
      return _i64.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i64.FreezedCustomClass) {
      return _i64.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i63.CustomClass?>()) {
      return (data != null ? _i63.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i64.ExternalCustomClass?>()) {
      return (data != null
          ? _i64.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i64.FreezedCustomClass?>()) {
      return (data != null
          ? _i64.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i48.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i65.Protocol().deserialize<T>(data, t);
=======
    if (t == _i61.CustomClass) {
      return _i61.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i62.ExternalCustomClass) {
      return _i62.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i62.FreezedCustomClass) {
      return _i62.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i61.CustomClass?>()) {
      return (data != null ? _i61.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i62.ExternalCustomClass?>()) {
      return (data != null
          ? _i62.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i62.FreezedCustomClass?>()) {
      return (data != null
          ? _i62.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i46.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i63.Protocol().deserialize<T>(data, t);
>>>>>>> c44799ee (test: Enum serialization.)
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
<<<<<<< HEAD
    className = _i48.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i65.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i63.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i64.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i64.FreezedCustomClass) {
=======
    className = _i46.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    className = _i63.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    if (data is _i61.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i62.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i62.FreezedCustomClass) {
>>>>>>> c44799ee (test: Enum serialization.)
      return 'FreezedCustomClass';
    }
    if (data is _i2.City) {
      return 'City';
    }
    if (data is _i3.Organization) {
      return 'Organization';
    }
    if (data is _i4.Person) {
      return 'Person';
    }
    if (data is _i5.Course) {
      return 'Course';
    }
    if (data is _i6.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i7.Student) {
      return 'Student';
    }
    if (data is _i8.Arena) {
      return 'Arena';
    }
    if (data is _i9.Player) {
      return 'Player';
    }
    if (data is _i10.Team) {
      return 'Team';
    }
    if (data is _i11.Comment) {
      return 'Comment';
    }
    if (data is _i12.Customer) {
      return 'Customer';
    }
    if (data is _i13.Order) {
      return 'Order';
    }
    if (data is _i14.Address) {
      return 'Address';
    }
    if (data is _i15.Citizen) {
      return 'Citizen';
    }
    if (data is _i16.Company) {
      return 'Company';
    }
    if (data is _i17.Town) {
      return 'Town';
    }
    if (data is _i18.Blocking) {
      return 'Blocking';
    }
    if (data is _i19.Member) {
      return 'Member';
    }
    if (data is _i20.Cat) {
      return 'Cat';
    }
    if (data is _i21.Post) {
      return 'Post';
    }
    if (data is _i22.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i23.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i24.Nullability) {
      return 'Nullability';
    }
    if (data is _i25.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i26.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i27.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i28.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i29.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i30.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i31.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i32.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i33.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i34.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i35.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i36.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i37.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i38.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i39.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i40.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i41.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i42.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i43.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i44.TestEnum) {
      return 'TestEnum';
    }
<<<<<<< HEAD
    if (data is _i45.Types) {
      return 'Types';
    }
    if (data is _i46.UniqueData) {
=======
    if (data is _i42.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i43.Types) {
      return 'Types';
    }
    if (data is _i44.UniqueData) {
>>>>>>> c44799ee (test: Enum serialization.)
      return 'UniqueData';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
<<<<<<< HEAD
      return _i48.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i65.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i63.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i64.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i64.FreezedCustomClass>(data['data']);
=======
      return _i46.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i63.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i61.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i62.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i62.FreezedCustomClass>(data['data']);
>>>>>>> c44799ee (test: Enum serialization.)
    }
    if (data['className'] == 'City') {
      return deserialize<_i2.City>(data['data']);
    }
    if (data['className'] == 'Organization') {
      return deserialize<_i3.Organization>(data['data']);
    }
    if (data['className'] == 'Person') {
      return deserialize<_i4.Person>(data['data']);
    }
    if (data['className'] == 'Course') {
      return deserialize<_i5.Course>(data['data']);
    }
    if (data['className'] == 'Enrollment') {
      return deserialize<_i6.Enrollment>(data['data']);
    }
    if (data['className'] == 'Student') {
      return deserialize<_i7.Student>(data['data']);
    }
    if (data['className'] == 'Arena') {
      return deserialize<_i8.Arena>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i9.Player>(data['data']);
    }
    if (data['className'] == 'Team') {
      return deserialize<_i10.Team>(data['data']);
    }
    if (data['className'] == 'Comment') {
      return deserialize<_i11.Comment>(data['data']);
    }
    if (data['className'] == 'Customer') {
      return deserialize<_i12.Customer>(data['data']);
    }
    if (data['className'] == 'Order') {
      return deserialize<_i13.Order>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i14.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i15.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i16.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i17.Town>(data['data']);
    }
    if (data['className'] == 'Blocking') {
      return deserialize<_i18.Blocking>(data['data']);
    }
    if (data['className'] == 'Member') {
      return deserialize<_i19.Member>(data['data']);
    }
    if (data['className'] == 'Cat') {
      return deserialize<_i20.Cat>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i21.Post>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i22.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i23.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i24.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i25.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i26.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i27.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i28.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i29.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i30.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i31.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i32.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i33.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i34.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i35.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i36.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i37.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i38.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i39.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i40.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i41.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i42.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i43.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i44.TestEnum>(data['data']);
    }
    if (data['className'] == 'TestEnumStringified') {
      return deserialize<_i42.TestEnumStringified>(data['data']);
    }
    if (data['className'] == 'Types') {
<<<<<<< HEAD
      return deserialize<_i45.Types>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i46.UniqueData>(data['data']);
=======
      return deserialize<_i43.Types>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i44.UniqueData>(data['data']);
>>>>>>> c44799ee (test: Enum serialization.)
    }
    return super.deserializeByClassName(data);
  }
}
