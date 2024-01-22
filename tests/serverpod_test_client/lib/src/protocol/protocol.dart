/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'exception_with_data.dart' as _i2;
import 'long_identifiers/max_field_name.dart' as _i3;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i4;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i5;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i6;
import 'long_identifiers/models_with_relations/user_note.dart' as _i7;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i8;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i9;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i10;
import 'long_identifiers/multiple_max_field_name.dart' as _i11;
import 'models_with_list_relations/city.dart' as _i12;
import 'models_with_list_relations/organization.dart' as _i13;
import 'models_with_list_relations/person.dart' as _i14;
import 'models_with_relations/many_to_many/course.dart' as _i15;
import 'models_with_relations/many_to_many/enrollment.dart' as _i16;
import 'models_with_relations/many_to_many/student.dart' as _i17;
import 'models_with_relations/module/object_user.dart' as _i18;
import 'models_with_relations/module/parent_user.dart' as _i19;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i20;
import 'models_with_relations/nested_one_to_many/player.dart' as _i21;
import 'models_with_relations/nested_one_to_many/team.dart' as _i22;
import 'models_with_relations/one_to_many/comment.dart' as _i23;
import 'models_with_relations/one_to_many/customer.dart' as _i24;
import 'models_with_relations/one_to_many/order.dart' as _i25;
import 'models_with_relations/one_to_one/address.dart' as _i26;
import 'models_with_relations/one_to_one/citizen.dart' as _i27;
import 'models_with_relations/one_to_one/company.dart' as _i28;
import 'models_with_relations/one_to_one/town.dart' as _i29;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i30;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i31;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i32;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i33;
import 'module_datatype.dart' as _i34;
import 'nullability.dart' as _i35;
import 'object_field_scopes.dart' as _i36;
import 'object_with_bytedata.dart' as _i37;
import 'object_with_duration.dart' as _i38;
import 'object_with_enum.dart' as _i39;
import 'object_with_index.dart' as _i40;
import 'object_with_maps.dart' as _i41;
import 'object_with_object.dart' as _i42;
import 'object_with_parent.dart' as _i43;
import 'object_with_self_parent.dart' as _i44;
import 'object_with_uuid.dart' as _i45;
import 'related_unique_data.dart' as _i46;
import 'scopes/scope_none_fields.dart' as _i47;
import 'serverOnly/default_server_only_class.dart' as _i48;
import 'serverOnly/default_server_only_enum.dart' as _i49;
import 'serverOnly/not_server_only_class.dart' as _i50;
import 'serverOnly/not_server_only_enum.dart' as _i51;
import 'simple_data.dart' as _i52;
import 'simple_data_list.dart' as _i53;
import 'simple_data_map.dart' as _i54;
import 'simple_data_object.dart' as _i55;
import 'simple_date_time.dart' as _i56;
import 'test_enum.dart' as _i57;
import 'test_enum_stringified.dart' as _i58;
import 'types.dart' as _i59;
import 'types_list.dart' as _i60;
import 'types_map.dart' as _i61;
import 'unique_data.dart' as _i62;
import 'protocol.dart' as _i63;
import 'package:serverpod_test_module_client/module.dart' as _i64;
import 'dart:typed_data' as _i65;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i66;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i67;
import 'package:uuid/uuid_value.dart' as _i68;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i69;
import 'package:serverpod_test_client/src/protocol/unique_data.dart' as _i70;
import 'package:serverpod_test_client/src/protocol/models_with_list_relations/person.dart'
    as _i71;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_one/citizen.dart'
    as _i72;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_one/address.dart'
    as _i73;
import 'package:serverpod_test_client/src/protocol/models_with_relations/self_relation/one_to_one/post.dart'
    as _i74;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_one/company.dart'
    as _i75;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_many/customer.dart'
    as _i76;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_many/comment.dart'
    as _i77;
import 'package:serverpod_test_client/src/protocol/models_with_relations/one_to_many/order.dart'
    as _i78;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i79;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i80;
import 'package:serverpod_auth_client/module.dart' as _i81;
export 'exception_with_data.dart';
export 'long_identifiers/max_field_name.dart';
export 'long_identifiers/models_with_relations/long_implicit_id_field.dart';
export 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart';
export 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart';
export 'long_identifiers/models_with_relations/user_note.dart';
export 'long_identifiers/models_with_relations/user_note_collection.dart';
export 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart';
export 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart';
export 'long_identifiers/multiple_max_field_name.dart';
export 'models_with_list_relations/city.dart';
export 'models_with_list_relations/organization.dart';
export 'models_with_list_relations/person.dart';
export 'models_with_relations/many_to_many/course.dart';
export 'models_with_relations/many_to_many/enrollment.dart';
export 'models_with_relations/many_to_many/student.dart';
export 'models_with_relations/module/object_user.dart';
export 'models_with_relations/module/parent_user.dart';
export 'models_with_relations/nested_one_to_many/arena.dart';
export 'models_with_relations/nested_one_to_many/player.dart';
export 'models_with_relations/nested_one_to_many/team.dart';
export 'models_with_relations/one_to_many/comment.dart';
export 'models_with_relations/one_to_many/customer.dart';
export 'models_with_relations/one_to_many/order.dart';
export 'models_with_relations/one_to_one/address.dart';
export 'models_with_relations/one_to_one/citizen.dart';
export 'models_with_relations/one_to_one/company.dart';
export 'models_with_relations/one_to_one/town.dart';
export 'models_with_relations/self_relation/many_to_many/blocking.dart';
export 'models_with_relations/self_relation/many_to_many/member.dart';
export 'models_with_relations/self_relation/one_to_many/cat.dart';
export 'models_with_relations/self_relation/one_to_one/post.dart';
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
export 'scopes/scope_none_fields.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'simple_data_map.dart';
export 'simple_data_object.dart';
export 'simple_date_time.dart';
export 'test_enum.dart';
export 'test_enum_stringified.dart';
export 'types.dart';
export 'types_list.dart';
export 'types_map.dart';
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
    if (t == _i2.ExceptionWithData) {
      return _i2.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i3.MaxFieldName) {
      return _i3.MaxFieldName.fromJson(data, this) as T;
    }
    if (t == _i4.LongImplicitIdField) {
      return _i4.LongImplicitIdField.fromJson(data, this) as T;
    }
    if (t == _i5.LongImplicitIdFieldCollection) {
      return _i5.LongImplicitIdFieldCollection.fromJson(data, this) as T;
    }
    if (t == _i6.RelationToMultipleMaxFieldName) {
      return _i6.RelationToMultipleMaxFieldName.fromJson(data, this) as T;
    }
    if (t == _i7.UserNote) {
      return _i7.UserNote.fromJson(data, this) as T;
    }
    if (t == _i8.UserNoteCollection) {
      return _i8.UserNoteCollection.fromJson(data, this) as T;
    }
    if (t == _i9.UserNoteCollectionWithALongName) {
      return _i9.UserNoteCollectionWithALongName.fromJson(data, this) as T;
    }
    if (t == _i10.UserNoteWithALongName) {
      return _i10.UserNoteWithALongName.fromJson(data, this) as T;
    }
    if (t == _i11.MultipleMaxFieldName) {
      return _i11.MultipleMaxFieldName.fromJson(data, this) as T;
    }
    if (t == _i12.City) {
      return _i12.City.fromJson(data, this) as T;
    }
    if (t == _i13.Organization) {
      return _i13.Organization.fromJson(data, this) as T;
    }
    if (t == _i14.Person) {
      return _i14.Person.fromJson(data, this) as T;
    }
    if (t == _i15.Course) {
      return _i15.Course.fromJson(data, this) as T;
    }
    if (t == _i16.Enrollment) {
      return _i16.Enrollment.fromJson(data, this) as T;
    }
    if (t == _i17.Student) {
      return _i17.Student.fromJson(data, this) as T;
    }
    if (t == _i18.ObjectUser) {
      return _i18.ObjectUser.fromJson(data, this) as T;
    }
    if (t == _i19.ParentUser) {
      return _i19.ParentUser.fromJson(data, this) as T;
    }
    if (t == _i20.Arena) {
      return _i20.Arena.fromJson(data, this) as T;
    }
    if (t == _i21.Player) {
      return _i21.Player.fromJson(data, this) as T;
    }
    if (t == _i22.Team) {
      return _i22.Team.fromJson(data, this) as T;
    }
    if (t == _i23.Comment) {
      return _i23.Comment.fromJson(data, this) as T;
    }
    if (t == _i24.Customer) {
      return _i24.Customer.fromJson(data, this) as T;
    }
    if (t == _i25.Order) {
      return _i25.Order.fromJson(data, this) as T;
    }
    if (t == _i26.Address) {
      return _i26.Address.fromJson(data, this) as T;
    }
    if (t == _i27.Citizen) {
      return _i27.Citizen.fromJson(data, this) as T;
    }
    if (t == _i28.Company) {
      return _i28.Company.fromJson(data, this) as T;
    }
    if (t == _i29.Town) {
      return _i29.Town.fromJson(data, this) as T;
    }
    if (t == _i30.Blocking) {
      return _i30.Blocking.fromJson(data, this) as T;
    }
    if (t == _i31.Member) {
      return _i31.Member.fromJson(data, this) as T;
    }
    if (t == _i32.Cat) {
      return _i32.Cat.fromJson(data, this) as T;
    }
    if (t == _i33.Post) {
      return _i33.Post.fromJson(data, this) as T;
    }
    if (t == _i34.ModuleDatatype) {
      return _i34.ModuleDatatype.fromJson(data, this) as T;
    }
    if (t == _i35.Nullability) {
      return _i35.Nullability.fromJson(data, this) as T;
    }
    if (t == _i36.ObjectFieldScopes) {
      return _i36.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i37.ObjectWithByteData) {
      return _i37.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i38.ObjectWithDuration) {
      return _i38.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i39.ObjectWithEnum) {
      return _i39.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i40.ObjectWithIndex) {
      return _i40.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i41.ObjectWithMaps) {
      return _i41.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i42.ObjectWithObject) {
      return _i42.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i43.ObjectWithParent) {
      return _i43.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i44.ObjectWithSelfParent) {
      return _i44.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i45.ObjectWithUuid) {
      return _i45.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i46.RelatedUniqueData) {
      return _i46.RelatedUniqueData.fromJson(data, this) as T;
    }
    if (t == _i47.ScopeNoneFields) {
      return _i47.ScopeNoneFields.fromJson(data, this) as T;
    }
    if (t == _i48.DefaultServerOnlyClass) {
      return _i48.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i49.DefaultServerOnlyEnum) {
      return _i49.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i50.NotServerOnlyClass) {
      return _i50.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i51.NotServerOnlyEnum) {
      return _i51.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i52.SimpleData) {
      return _i52.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i53.SimpleDataList) {
      return _i53.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i54.SimpleDataMap) {
      return _i54.SimpleDataMap.fromJson(data, this) as T;
    }
    if (t == _i55.SimpleDataObject) {
      return _i55.SimpleDataObject.fromJson(data, this) as T;
    }
    if (t == _i56.SimpleDateTime) {
      return _i56.SimpleDateTime.fromJson(data, this) as T;
    }
    if (t == _i57.TestEnum) {
      return _i57.TestEnum.fromJson(data) as T;
    }
    if (t == _i58.TestEnumStringified) {
      return _i58.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i59.Types) {
      return _i59.Types.fromJson(data, this) as T;
    }
    if (t == _i60.TypesList) {
      return _i60.TypesList.fromJson(data, this) as T;
    }
    if (t == _i61.TypesMap) {
      return _i61.TypesMap.fromJson(data, this) as T;
    }
    if (t == _i62.UniqueData) {
      return _i62.UniqueData.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i2.ExceptionWithData?>()) {
      return (data != null ? _i2.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i3.MaxFieldName?>()) {
      return (data != null ? _i3.MaxFieldName.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i4.LongImplicitIdField?>()) {
      return (data != null
          ? _i4.LongImplicitIdField.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i5.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i5.LongImplicitIdFieldCollection.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i6.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i6.RelationToMultipleMaxFieldName.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i7.UserNote?>()) {
      return (data != null ? _i7.UserNote.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i8.UserNoteCollection?>()) {
      return (data != null ? _i8.UserNoteCollection.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i9.UserNoteCollectionWithALongName.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i10.UserNoteWithALongName?>()) {
      return (data != null
          ? _i10.UserNoteWithALongName.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i11.MultipleMaxFieldName?>()) {
      return (data != null
          ? _i11.MultipleMaxFieldName.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i12.City?>()) {
      return (data != null ? _i12.City.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i13.Organization?>()) {
      return (data != null ? _i13.Organization.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i14.Person?>()) {
      return (data != null ? _i14.Person.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i15.Course?>()) {
      return (data != null ? _i15.Course.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i16.Enrollment?>()) {
      return (data != null ? _i16.Enrollment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i17.Student?>()) {
      return (data != null ? _i17.Student.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i18.ObjectUser?>()) {
      return (data != null ? _i18.ObjectUser.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i19.ParentUser?>()) {
      return (data != null ? _i19.ParentUser.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i20.Arena?>()) {
      return (data != null ? _i20.Arena.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i21.Player?>()) {
      return (data != null ? _i21.Player.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i22.Team?>()) {
      return (data != null ? _i22.Team.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i23.Comment?>()) {
      return (data != null ? _i23.Comment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i24.Customer?>()) {
      return (data != null ? _i24.Customer.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i25.Order?>()) {
      return (data != null ? _i25.Order.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i26.Address?>()) {
      return (data != null ? _i26.Address.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i27.Citizen?>()) {
      return (data != null ? _i27.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i28.Company?>()) {
      return (data != null ? _i28.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i29.Town?>()) {
      return (data != null ? _i29.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i30.Blocking?>()) {
      return (data != null ? _i30.Blocking.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i31.Member?>()) {
      return (data != null ? _i31.Member.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i32.Cat?>()) {
      return (data != null ? _i32.Cat.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i33.Post?>()) {
      return (data != null ? _i33.Post.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i34.ModuleDatatype?>()) {
      return (data != null ? _i34.ModuleDatatype.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i35.Nullability?>()) {
      return (data != null ? _i35.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i36.ObjectFieldScopes?>()) {
      return (data != null ? _i36.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i37.ObjectWithByteData?>()) {
      return (data != null
          ? _i37.ObjectWithByteData.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i38.ObjectWithDuration?>()) {
      return (data != null
          ? _i38.ObjectWithDuration.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i39.ObjectWithEnum?>()) {
      return (data != null ? _i39.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i40.ObjectWithIndex?>()) {
      return (data != null ? _i40.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i41.ObjectWithMaps?>()) {
      return (data != null ? _i41.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i42.ObjectWithObject?>()) {
      return (data != null ? _i42.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i43.ObjectWithParent?>()) {
      return (data != null ? _i43.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i44.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i44.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i45.ObjectWithUuid?>()) {
      return (data != null ? _i45.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i46.RelatedUniqueData?>()) {
      return (data != null ? _i46.RelatedUniqueData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i47.ScopeNoneFields?>()) {
      return (data != null ? _i47.ScopeNoneFields.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i48.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i48.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i49.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i49.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.NotServerOnlyClass?>()) {
      return (data != null
          ? _i50.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i51.NotServerOnlyEnum?>()) {
      return (data != null ? _i51.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.SimpleData?>()) {
      return (data != null ? _i52.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i53.SimpleDataList?>()) {
      return (data != null ? _i53.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i54.SimpleDataMap?>()) {
      return (data != null ? _i54.SimpleDataMap.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i55.SimpleDataObject?>()) {
      return (data != null ? _i55.SimpleDataObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i56.SimpleDateTime?>()) {
      return (data != null ? _i56.SimpleDateTime.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i57.TestEnum?>()) {
      return (data != null ? _i57.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.TestEnumStringified?>()) {
      return (data != null ? _i58.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.Types?>()) {
      return (data != null ? _i59.Types.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i60.TypesList?>()) {
      return (data != null ? _i60.TypesList.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i61.TypesMap?>()) {
      return (data != null ? _i61.TypesMap.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i62.UniqueData?>()) {
      return (data != null ? _i62.UniqueData.fromJson(data, this) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i63.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.LongImplicitIdField>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.MultipleMaxFieldName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.UserNote>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.UserNoteWithALongName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Cat>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i64.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i64.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i64.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i64.ModuleClass>(v))) as dynamic;
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
    if (t == List<_i63.SimpleData>) {
      return (data as List).map((e) => deserialize<_i63.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i63.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i63.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i63.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i63.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.SimpleData?>(e)).toList()
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
    if (t == List<_i65.ByteData>) {
      return (data as List).map((e) => deserialize<_i65.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i65.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i65.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i65.ByteData?>) {
      return (data as List).map((e) => deserialize<_i65.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i65.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i65.ByteData?>(e)).toList()
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
    if (t == List<_i63.TestEnum>) {
      return (data as List).map((e) => deserialize<_i63.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i63.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i63.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i63.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i63.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i63.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i63.SimpleData>(v)))
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
    if (t == Map<String, _i65.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i65.ByteData>(v)))
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
    if (t == Map<String, _i63.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i63.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i65.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i65.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i63.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<bool>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<bool>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<double>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<double>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i65.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i65.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.TestEnum>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.TestEnumStringified>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i63.Types>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Map<String, _i63.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i63.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, _i63.Types>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i63.Types>(v)))
          as dynamic;
    }
    if (t == _i1.getType<List<List<_i63.Types>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<_i63.Types>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i63.Types>) {
      return (data as List).map((e) => deserialize<_i63.Types>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<Map<int, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<bool, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<bool>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<double, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<double>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<DateTime, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<DateTime>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i65.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i65.ByteData>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Duration, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Duration>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i1.UuidValue, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i1.UuidValue>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i63.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i63.TestEnum>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i63.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i63.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i63.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i63.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Map<_i63.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i63.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == Map<_i63.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i63.Types>(e['k']), deserialize<String>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<List<_i63.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i63.Types>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, bool>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, double>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<double>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, DateTime>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i65.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i65.ByteData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Duration>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i1.UuidValue>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i63.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i63.TestEnum>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i63.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i63.TestEnumStringified>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i63.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i63.Types>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<String, _i63.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i63.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, List<_i63.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i63.Types>>(v)))
          : null) as dynamic;
    }
    if (t == List<_i66.Types>) {
      return (data as List).map((e) => deserialize<_i66.Types>(e)).toList()
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
    if (t == List<_i67.TestEnum>) {
      return (data as List).map((e) => deserialize<_i67.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i68.UuidValue>) {
      return (data as List).map((e) => deserialize<_i68.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == List<_i69.SimpleData>) {
      return (data as List).map((e) => deserialize<_i69.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i70.UniqueData>) {
      return (data as List).map((e) => deserialize<_i70.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i71.Person>) {
      return (data as List).map((e) => deserialize<_i71.Person>(e)).toList()
          as dynamic;
    }
    if (t == List<_i72.Citizen>) {
      return (data as List).map((e) => deserialize<_i72.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i73.Address>) {
      return (data as List).map((e) => deserialize<_i73.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i74.Post>) {
      return (data as List).map((e) => deserialize<_i74.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i75.Company>) {
      return (data as List).map((e) => deserialize<_i75.Company>(e)).toList()
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
    if (t == List<_i65.ByteData>) {
      return (data as List).map((e) => deserialize<_i65.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i65.ByteData?>) {
      return (data as List).map((e) => deserialize<_i65.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i69.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i69.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i69.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i69.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i69.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i69.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i69.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i69.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i69.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i69.SimpleData?>(e)).toList()
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
    if (t == Map<_i67.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i67.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i67.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i67.TestEnum>(v)))
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
    if (t == Map<String, _i65.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i65.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i65.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i65.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i69.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i69.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i69.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i69.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i69.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i69.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i69.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i69.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i69.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i69.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i69.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i69.SimpleData?>(v)))
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
    if (t == List<_i76.Customer>) {
      return (data as List).map((e) => deserialize<_i76.Customer>(e)).toList()
          as dynamic;
    }
    if (t == List<_i77.Comment>) {
      return (data as List).map((e) => deserialize<_i77.Comment>(e)).toList()
          as dynamic;
    }
    if (t == List<_i78.Order>) {
      return (data as List).map((e) => deserialize<_i78.Order>(e)).toList()
          as dynamic;
    }
    if (t == _i79.CustomClass) {
      return _i79.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i80.ExternalCustomClass) {
      return _i80.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i80.FreezedCustomClass) {
      return _i80.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i79.CustomClass?>()) {
      return (data != null ? _i79.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i80.ExternalCustomClass?>()) {
      return (data != null
          ? _i80.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i80.FreezedCustomClass?>()) {
      return (data != null
          ? _i80.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i81.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i64.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i81.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i64.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    if (data is _i79.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i80.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i80.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i3.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i4.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i5.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i6.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i7.UserNote) {
      return 'UserNote';
    }
    if (data is _i8.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i9.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i10.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i11.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i12.City) {
      return 'City';
    }
    if (data is _i13.Organization) {
      return 'Organization';
    }
    if (data is _i14.Person) {
      return 'Person';
    }
    if (data is _i15.Course) {
      return 'Course';
    }
    if (data is _i16.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i17.Student) {
      return 'Student';
    }
    if (data is _i18.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i19.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i20.Arena) {
      return 'Arena';
    }
    if (data is _i21.Player) {
      return 'Player';
    }
    if (data is _i22.Team) {
      return 'Team';
    }
    if (data is _i23.Comment) {
      return 'Comment';
    }
    if (data is _i24.Customer) {
      return 'Customer';
    }
    if (data is _i25.Order) {
      return 'Order';
    }
    if (data is _i26.Address) {
      return 'Address';
    }
    if (data is _i27.Citizen) {
      return 'Citizen';
    }
    if (data is _i28.Company) {
      return 'Company';
    }
    if (data is _i29.Town) {
      return 'Town';
    }
    if (data is _i30.Blocking) {
      return 'Blocking';
    }
    if (data is _i31.Member) {
      return 'Member';
    }
    if (data is _i32.Cat) {
      return 'Cat';
    }
    if (data is _i33.Post) {
      return 'Post';
    }
    if (data is _i34.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i35.Nullability) {
      return 'Nullability';
    }
    if (data is _i36.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i37.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i38.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i39.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i40.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i41.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i42.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i43.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i44.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i45.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i46.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i47.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i48.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i49.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i50.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i51.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i52.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i53.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i54.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i55.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i56.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i57.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i58.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i59.Types) {
      return 'Types';
    }
    if (data is _i60.TypesList) {
      return 'TypesList';
    }
    if (data is _i61.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i62.UniqueData) {
      return 'UniqueData';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i81.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i64.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i79.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i80.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i80.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i2.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'MaxFieldName') {
      return deserialize<_i3.MaxFieldName>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdField') {
      return deserialize<_i4.LongImplicitIdField>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdFieldCollection') {
      return deserialize<_i5.LongImplicitIdFieldCollection>(data['data']);
    }
    if (data['className'] == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i6.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'UserNote') {
      return deserialize<_i7.UserNote>(data['data']);
    }
    if (data['className'] == 'UserNoteCollection') {
      return deserialize<_i8.UserNoteCollection>(data['data']);
    }
    if (data['className'] == 'UserNoteCollectionWithALongName') {
      return deserialize<_i9.UserNoteCollectionWithALongName>(data['data']);
    }
    if (data['className'] == 'UserNoteWithALongName') {
      return deserialize<_i10.UserNoteWithALongName>(data['data']);
    }
    if (data['className'] == 'MultipleMaxFieldName') {
      return deserialize<_i11.MultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'City') {
      return deserialize<_i12.City>(data['data']);
    }
    if (data['className'] == 'Organization') {
      return deserialize<_i13.Organization>(data['data']);
    }
    if (data['className'] == 'Person') {
      return deserialize<_i14.Person>(data['data']);
    }
    if (data['className'] == 'Course') {
      return deserialize<_i15.Course>(data['data']);
    }
    if (data['className'] == 'Enrollment') {
      return deserialize<_i16.Enrollment>(data['data']);
    }
    if (data['className'] == 'Student') {
      return deserialize<_i17.Student>(data['data']);
    }
    if (data['className'] == 'ObjectUser') {
      return deserialize<_i18.ObjectUser>(data['data']);
    }
    if (data['className'] == 'ParentUser') {
      return deserialize<_i19.ParentUser>(data['data']);
    }
    if (data['className'] == 'Arena') {
      return deserialize<_i20.Arena>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i21.Player>(data['data']);
    }
    if (data['className'] == 'Team') {
      return deserialize<_i22.Team>(data['data']);
    }
    if (data['className'] == 'Comment') {
      return deserialize<_i23.Comment>(data['data']);
    }
    if (data['className'] == 'Customer') {
      return deserialize<_i24.Customer>(data['data']);
    }
    if (data['className'] == 'Order') {
      return deserialize<_i25.Order>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i26.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i27.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i28.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i29.Town>(data['data']);
    }
    if (data['className'] == 'Blocking') {
      return deserialize<_i30.Blocking>(data['data']);
    }
    if (data['className'] == 'Member') {
      return deserialize<_i31.Member>(data['data']);
    }
    if (data['className'] == 'Cat') {
      return deserialize<_i32.Cat>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i33.Post>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i34.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i35.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i36.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i37.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i38.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i39.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i40.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i41.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i42.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i43.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i44.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i45.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i46.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'ScopeNoneFields') {
      return deserialize<_i47.ScopeNoneFields>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i48.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i49.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i50.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i51.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i52.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i53.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i54.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDataObject') {
      return deserialize<_i55.SimpleDataObject>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i56.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i57.TestEnum>(data['data']);
    }
    if (data['className'] == 'TestEnumStringified') {
      return deserialize<_i58.TestEnumStringified>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i59.Types>(data['data']);
    }
    if (data['className'] == 'TypesList') {
      return deserialize<_i60.TypesList>(data['data']);
    }
    if (data['className'] == 'TypesMap') {
      return deserialize<_i61.TypesMap>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i62.UniqueData>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}
