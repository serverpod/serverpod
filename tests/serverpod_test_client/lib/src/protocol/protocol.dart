/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'defaults/datetime_default.dart' as _i2;
import 'defaults/datetime_default_mix.dart' as _i3;
import 'defaults/datetime_default_model.dart' as _i4;
import 'defaults/datetime_default_persist.dart' as _i5;
import 'empty_model/empty_model_relation_item.dart' as _i6;
import 'empty_model/empy_model.dart' as _i7;
import 'exception_with_data.dart' as _i8;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i9;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i10;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i11;
import 'long_identifiers/max_field_name.dart' as _i12;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i13;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i14;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i15;
import 'long_identifiers/models_with_relations/user_note.dart' as _i16;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i17;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i18;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i19;
import 'long_identifiers/multiple_max_field_name.dart' as _i20;
import 'models_with_list_relations/city.dart' as _i21;
import 'models_with_list_relations/organization.dart' as _i22;
import 'models_with_list_relations/person.dart' as _i23;
import 'models_with_relations/many_to_many/course.dart' as _i24;
import 'models_with_relations/many_to_many/enrollment.dart' as _i25;
import 'models_with_relations/many_to_many/student.dart' as _i26;
import 'models_with_relations/module/object_user.dart' as _i27;
import 'models_with_relations/module/parent_user.dart' as _i28;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i29;
import 'models_with_relations/nested_one_to_many/player.dart' as _i30;
import 'models_with_relations/nested_one_to_many/team.dart' as _i31;
import 'models_with_relations/one_to_many/comment.dart' as _i32;
import 'models_with_relations/one_to_many/customer.dart' as _i33;
import 'models_with_relations/one_to_many/order.dart' as _i34;
import 'models_with_relations/one_to_one/address.dart' as _i35;
import 'models_with_relations/one_to_one/citizen.dart' as _i36;
import 'models_with_relations/one_to_one/company.dart' as _i37;
import 'models_with_relations/one_to_one/town.dart' as _i38;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i39;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i40;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i41;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i42;
import 'module_datatype.dart' as _i43;
import 'nullability.dart' as _i44;
import 'object_field_scopes.dart' as _i45;
import 'object_with_bytedata.dart' as _i46;
import 'object_with_duration.dart' as _i47;
import 'object_with_enum.dart' as _i48;
import 'object_with_index.dart' as _i49;
import 'object_with_maps.dart' as _i50;
import 'object_with_object.dart' as _i51;
import 'object_with_parent.dart' as _i52;
import 'object_with_self_parent.dart' as _i53;
import 'object_with_uuid.dart' as _i54;
import 'related_unique_data.dart' as _i55;
import 'scopes/scope_none_fields.dart' as _i56;
import 'scopes/scope_server_only_field.dart' as _i57;
import 'scopes/serverOnly/default_server_only_class.dart' as _i58;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i59;
import 'scopes/serverOnly/not_server_only_class.dart' as _i60;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i61;
import 'scopes/server_only_class_field.dart' as _i62;
import 'simple_data.dart' as _i63;
import 'simple_data_list.dart' as _i64;
import 'simple_data_map.dart' as _i65;
import 'simple_data_object.dart' as _i66;
import 'simple_date_time.dart' as _i67;
import 'test_enum.dart' as _i68;
import 'test_enum_stringified.dart' as _i69;
import 'types.dart' as _i70;
import 'types_list.dart' as _i71;
import 'types_map.dart' as _i72;
import 'unique_data.dart' as _i73;
import 'protocol.dart' as _i74;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i75;
import 'dart:typed_data' as _i76;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i77;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i78;
import 'package:serverpod_test_client/src/custom_classes.dart' as _i79;
import 'package:serverpod_test_client/src/protocol_custom_classes.dart' as _i80;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i81;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i82;
export 'defaults/datetime_default.dart';
export 'defaults/datetime_default_mix.dart';
export 'defaults/datetime_default_model.dart';
export 'defaults/datetime_default_persist.dart';
export 'empty_model/empty_model_relation_item.dart';
export 'empty_model/empy_model.dart';
export 'exception_with_data.dart';
export 'long_identifiers/deep_includes/city_with_long_table_name.dart';
export 'long_identifiers/deep_includes/organization_with_long_table_name.dart';
export 'long_identifiers/deep_includes/person_with_long_table_name.dart';
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
export 'scopes/scope_server_only_field.dart';
export 'scopes/serverOnly/default_server_only_class.dart';
export 'scopes/serverOnly/default_server_only_enum.dart';
export 'scopes/serverOnly/not_server_only_class.dart';
export 'scopes/serverOnly/not_server_only_enum.dart';
export 'scopes/server_only_class_field.dart';
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

  static final Protocol _instance = Protocol._();

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i2.DateTimeDefault) {
      return _i2.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i3.DateTimeDefaultMix) {
      return _i3.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i4.DateTimeDefaultModel) {
      return _i4.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i5.DateTimeDefaultPersist) {
      return _i5.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i6.EmptyModelRelationItem) {
      return _i6.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i7.EmptyModel) {
      return _i7.EmptyModel.fromJson(data) as T;
    }
    if (t == _i8.ExceptionWithData) {
      return _i8.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i9.CityWithLongTableName) {
      return _i9.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i10.OrganizationWithLongTableName) {
      return _i10.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i11.PersonWithLongTableName) {
      return _i11.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i12.MaxFieldName) {
      return _i12.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i13.LongImplicitIdField) {
      return _i13.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i14.LongImplicitIdFieldCollection) {
      return _i14.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i15.RelationToMultipleMaxFieldName) {
      return _i15.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i16.UserNote) {
      return _i16.UserNote.fromJson(data) as T;
    }
    if (t == _i17.UserNoteCollection) {
      return _i17.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i18.UserNoteCollectionWithALongName) {
      return _i18.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i19.UserNoteWithALongName) {
      return _i19.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i20.MultipleMaxFieldName) {
      return _i20.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i21.City) {
      return _i21.City.fromJson(data) as T;
    }
    if (t == _i22.Organization) {
      return _i22.Organization.fromJson(data) as T;
    }
    if (t == _i23.Person) {
      return _i23.Person.fromJson(data) as T;
    }
    if (t == _i24.Course) {
      return _i24.Course.fromJson(data) as T;
    }
    if (t == _i25.Enrollment) {
      return _i25.Enrollment.fromJson(data) as T;
    }
    if (t == _i26.Student) {
      return _i26.Student.fromJson(data) as T;
    }
    if (t == _i27.ObjectUser) {
      return _i27.ObjectUser.fromJson(data) as T;
    }
    if (t == _i28.ParentUser) {
      return _i28.ParentUser.fromJson(data) as T;
    }
    if (t == _i29.Arena) {
      return _i29.Arena.fromJson(data) as T;
    }
    if (t == _i30.Player) {
      return _i30.Player.fromJson(data) as T;
    }
    if (t == _i31.Team) {
      return _i31.Team.fromJson(data) as T;
    }
    if (t == _i32.Comment) {
      return _i32.Comment.fromJson(data) as T;
    }
    if (t == _i33.Customer) {
      return _i33.Customer.fromJson(data) as T;
    }
    if (t == _i34.Order) {
      return _i34.Order.fromJson(data) as T;
    }
    if (t == _i35.Address) {
      return _i35.Address.fromJson(data) as T;
    }
    if (t == _i36.Citizen) {
      return _i36.Citizen.fromJson(data) as T;
    }
    if (t == _i37.Company) {
      return _i37.Company.fromJson(data) as T;
    }
    if (t == _i38.Town) {
      return _i38.Town.fromJson(data) as T;
    }
    if (t == _i39.Blocking) {
      return _i39.Blocking.fromJson(data) as T;
    }
    if (t == _i40.Member) {
      return _i40.Member.fromJson(data) as T;
    }
    if (t == _i41.Cat) {
      return _i41.Cat.fromJson(data) as T;
    }
    if (t == _i42.Post) {
      return _i42.Post.fromJson(data) as T;
    }
    if (t == _i43.ModuleDatatype) {
      return _i43.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i44.Nullability) {
      return _i44.Nullability.fromJson(data) as T;
    }
    if (t == _i45.ObjectFieldScopes) {
      return _i45.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i46.ObjectWithByteData) {
      return _i46.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i47.ObjectWithDuration) {
      return _i47.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i48.ObjectWithEnum) {
      return _i48.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i49.ObjectWithIndex) {
      return _i49.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i50.ObjectWithMaps) {
      return _i50.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i51.ObjectWithObject) {
      return _i51.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i52.ObjectWithParent) {
      return _i52.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i53.ObjectWithSelfParent) {
      return _i53.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i54.ObjectWithUuid) {
      return _i54.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i55.RelatedUniqueData) {
      return _i55.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i56.ScopeNoneFields) {
      return _i56.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i57.ScopeServerOnlyField) {
      return _i57.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i58.DefaultServerOnlyClass) {
      return _i58.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i59.DefaultServerOnlyEnum) {
      return _i59.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i60.NotServerOnlyClass) {
      return _i60.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i61.NotServerOnlyEnum) {
      return _i61.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i62.ServerOnlyClassField) {
      return _i62.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i63.SimpleData) {
      return _i63.SimpleData.fromJson(data) as T;
    }
    if (t == _i64.SimpleDataList) {
      return _i64.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i65.SimpleDataMap) {
      return _i65.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i66.SimpleDataObject) {
      return _i66.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i67.SimpleDateTime) {
      return _i67.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i68.TestEnum) {
      return _i68.TestEnum.fromJson(data) as T;
    }
    if (t == _i69.TestEnumStringified) {
      return _i69.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i70.Types) {
      return _i70.Types.fromJson(data) as T;
    }
    if (t == _i71.TypesList) {
      return _i71.TypesList.fromJson(data) as T;
    }
    if (t == _i72.TypesMap) {
      return _i72.TypesMap.fromJson(data) as T;
    }
    if (t == _i73.UniqueData) {
      return _i73.UniqueData.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.DateTimeDefault?>()) {
      return (data != null ? _i2.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i3.DateTimeDefaultMix?>()) {
      return (data != null ? _i3.DateTimeDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.DateTimeDefaultModel?>()) {
      return (data != null ? _i4.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i5.DateTimeDefaultPersist?>()) {
      return (data != null ? _i5.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.EmptyModelRelationItem?>()) {
      return (data != null ? _i6.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.EmptyModel?>()) {
      return (data != null ? _i7.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ExceptionWithData?>()) {
      return (data != null ? _i8.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CityWithLongTableName?>()) {
      return (data != null ? _i9.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i10.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i10.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i11.PersonWithLongTableName?>()) {
      return (data != null ? _i11.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.MaxFieldName?>()) {
      return (data != null ? _i12.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.LongImplicitIdField?>()) {
      return (data != null ? _i13.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i14.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i14.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i15.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i15.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i16.UserNote?>()) {
      return (data != null ? _i16.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.UserNoteCollection?>()) {
      return (data != null ? _i17.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i18.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i19.UserNoteWithALongName?>()) {
      return (data != null ? _i19.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.MultipleMaxFieldName?>()) {
      return (data != null ? _i20.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.City?>()) {
      return (data != null ? _i21.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Organization?>()) {
      return (data != null ? _i22.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Person?>()) {
      return (data != null ? _i23.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.Course?>()) {
      return (data != null ? _i24.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.Enrollment?>()) {
      return (data != null ? _i25.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.Student?>()) {
      return (data != null ? _i26.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.ObjectUser?>()) {
      return (data != null ? _i27.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.ParentUser?>()) {
      return (data != null ? _i28.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Arena?>()) {
      return (data != null ? _i29.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Player?>()) {
      return (data != null ? _i30.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Team?>()) {
      return (data != null ? _i31.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.Comment?>()) {
      return (data != null ? _i32.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Customer?>()) {
      return (data != null ? _i33.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Order?>()) {
      return (data != null ? _i34.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.Address?>()) {
      return (data != null ? _i35.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.Citizen?>()) {
      return (data != null ? _i36.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.Company?>()) {
      return (data != null ? _i37.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.Town?>()) {
      return (data != null ? _i38.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.Blocking?>()) {
      return (data != null ? _i39.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.Member?>()) {
      return (data != null ? _i40.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.Cat?>()) {
      return (data != null ? _i41.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.Post?>()) {
      return (data != null ? _i42.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ModuleDatatype?>()) {
      return (data != null ? _i43.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.Nullability?>()) {
      return (data != null ? _i44.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ObjectFieldScopes?>()) {
      return (data != null ? _i45.ObjectFieldScopes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.ObjectWithByteData?>()) {
      return (data != null ? _i46.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i47.ObjectWithDuration?>()) {
      return (data != null ? _i47.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.ObjectWithEnum?>()) {
      return (data != null ? _i48.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.ObjectWithIndex?>()) {
      return (data != null ? _i49.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ObjectWithMaps?>()) {
      return (data != null ? _i50.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.ObjectWithObject?>()) {
      return (data != null ? _i51.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ObjectWithParent?>()) {
      return (data != null ? _i52.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.ObjectWithSelfParent?>()) {
      return (data != null ? _i53.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.ObjectWithUuid?>()) {
      return (data != null ? _i54.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.RelatedUniqueData?>()) {
      return (data != null ? _i55.RelatedUniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.ScopeNoneFields?>()) {
      return (data != null ? _i56.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.ScopeServerOnlyField?>()) {
      return (data != null ? _i57.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.DefaultServerOnlyClass?>()) {
      return (data != null ? _i58.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i59.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.NotServerOnlyClass?>()) {
      return (data != null ? _i60.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.NotServerOnlyEnum?>()) {
      return (data != null ? _i61.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.ServerOnlyClassField?>()) {
      return (data != null ? _i62.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.SimpleData?>()) {
      return (data != null ? _i63.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.SimpleDataList?>()) {
      return (data != null ? _i64.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.SimpleDataMap?>()) {
      return (data != null ? _i65.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.SimpleDataObject?>()) {
      return (data != null ? _i66.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.SimpleDateTime?>()) {
      return (data != null ? _i67.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.TestEnum?>()) {
      return (data != null ? _i68.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.TestEnumStringified?>()) {
      return (data != null ? _i69.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.Types?>()) {
      return (data != null ? _i70.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.TypesList?>()) {
      return (data != null ? _i71.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.TypesMap?>()) {
      return (data != null ? _i72.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.UniqueData?>()) {
      return (data != null ? _i73.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i74.EmptyModelRelationItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.EmptyModelRelationItem>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i74.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.OrganizationWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.LongImplicitIdField>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.MultipleMaxFieldName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.UserNote>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.UserNoteWithALongName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Cat>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i75.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i75.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i75.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i75.ModuleClass>(v))) as dynamic;
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
    if (t == List<_i74.SimpleData>) {
      return (data as List).map((e) => deserialize<_i74.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i74.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i74.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i74.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i74.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.SimpleData?>(e)).toList()
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
    if (t == List<_i76.ByteData>) {
      return (data as List).map((e) => deserialize<_i76.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i76.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i76.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i76.ByteData?>) {
      return (data as List).map((e) => deserialize<_i76.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i76.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i76.ByteData?>(e)).toList()
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
    if (t == List<_i74.TestEnum>) {
      return (data as List).map((e) => deserialize<_i74.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i74.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i74.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i74.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i74.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i74.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.SimpleData>(v)))
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
    if (t == Map<String, _i76.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i76.ByteData>(v)))
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
    if (t == Map<String, _i74.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i74.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i76.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i76.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i74.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.SimpleData?>(e)).toList()
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
    if (t == _i1.getType<List<_i76.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i76.ByteData>(e)).toList()
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
    if (t == _i1.getType<List<_i74.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.TestEnum>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.TestEnumStringified>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i74.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.Types>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Map<String, _i74.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i74.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, _i74.Types>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.Types>(v)))
          as dynamic;
    }
    if (t == _i1.getType<List<List<_i74.Types>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<_i74.Types>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i74.Types>) {
      return (data as List).map((e) => deserialize<_i74.Types>(e)).toList()
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
    if (t == _i1.getType<Map<_i76.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i76.ByteData>(e['k']), deserialize<String>(e['v']))))
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
    if (t == _i1.getType<Map<_i74.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i74.TestEnum>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i74.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i74.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i74.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i74.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Map<_i74.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i74.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == Map<_i74.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i74.Types>(e['k']), deserialize<String>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<List<_i74.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i74.Types>>(e['k']),
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
    if (t == _i1.getType<Map<String, _i76.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i76.ByteData>(v)))
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
    if (t == _i1.getType<Map<String, _i74.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.TestEnum>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i74.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i74.TestEnumStringified>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i74.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.Types>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<String, _i74.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i74.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, List<_i74.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i74.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i77.SimpleData>) {
      return (data as List).map((e) => deserialize<_i77.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
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
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList()
          as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i76.ByteData>) {
      return (data as List).map((e) => deserialize<_i76.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i76.ByteData?>) {
      return (data as List).map((e) => deserialize<_i76.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i77.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i77.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i77.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i77.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i77.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i77.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i77.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i77.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i77.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i77.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
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
    if (t == Map<_i78.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i78.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i78.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i78.TestEnum>(v)))
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
    if (t == Map<String, _i76.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i76.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i76.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i76.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i77.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i77.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i77.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i77.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i77.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i77.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i77.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i77.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i77.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i77.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i77.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i77.SimpleData?>(v)))
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
    if (t == _i79.CustomClass) {
      return _i79.CustomClass.fromJson(data) as T;
    }
    if (t == _i79.CustomClass2) {
      return _i79.CustomClass2.fromJson(data) as T;
    }
    if (t == _i80.ProtocolCustomClass) {
      return _i80.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i81.ExternalCustomClass) {
      return _i81.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i81.FreezedCustomClass) {
      return _i81.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i79.CustomClass?>()) {
      return (data != null ? _i79.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.CustomClass2?>()) {
      return (data != null ? _i79.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.ProtocolCustomClass?>()) {
      return (data != null ? _i80.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.ExternalCustomClass?>()) {
      return (data != null ? _i81.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.FreezedCustomClass?>()) {
      return (data != null ? _i81.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    try {
      return _i82.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i75.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i79.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i79.CustomClass2) {
      return 'CustomClass2';
    }
    if (data is _i80.ProtocolCustomClass) {
      return 'ProtocolCustomClass';
    }
    if (data is _i81.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i81.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.DateTimeDefault) {
      return 'DateTimeDefault';
    }
    if (data is _i3.DateTimeDefaultMix) {
      return 'DateTimeDefaultMix';
    }
    if (data is _i4.DateTimeDefaultModel) {
      return 'DateTimeDefaultModel';
    }
    if (data is _i5.DateTimeDefaultPersist) {
      return 'DateTimeDefaultPersist';
    }
    if (data is _i6.EmptyModelRelationItem) {
      return 'EmptyModelRelationItem';
    }
    if (data is _i7.EmptyModel) {
      return 'EmptyModel';
    }
    if (data is _i8.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i9.CityWithLongTableName) {
      return 'CityWithLongTableName';
    }
    if (data is _i10.OrganizationWithLongTableName) {
      return 'OrganizationWithLongTableName';
    }
    if (data is _i11.PersonWithLongTableName) {
      return 'PersonWithLongTableName';
    }
    if (data is _i12.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i13.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i14.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i15.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i16.UserNote) {
      return 'UserNote';
    }
    if (data is _i17.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i18.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i19.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i20.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i21.City) {
      return 'City';
    }
    if (data is _i22.Organization) {
      return 'Organization';
    }
    if (data is _i23.Person) {
      return 'Person';
    }
    if (data is _i24.Course) {
      return 'Course';
    }
    if (data is _i25.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i26.Student) {
      return 'Student';
    }
    if (data is _i27.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i28.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i29.Arena) {
      return 'Arena';
    }
    if (data is _i30.Player) {
      return 'Player';
    }
    if (data is _i31.Team) {
      return 'Team';
    }
    if (data is _i32.Comment) {
      return 'Comment';
    }
    if (data is _i33.Customer) {
      return 'Customer';
    }
    if (data is _i34.Order) {
      return 'Order';
    }
    if (data is _i35.Address) {
      return 'Address';
    }
    if (data is _i36.Citizen) {
      return 'Citizen';
    }
    if (data is _i37.Company) {
      return 'Company';
    }
    if (data is _i38.Town) {
      return 'Town';
    }
    if (data is _i39.Blocking) {
      return 'Blocking';
    }
    if (data is _i40.Member) {
      return 'Member';
    }
    if (data is _i41.Cat) {
      return 'Cat';
    }
    if (data is _i42.Post) {
      return 'Post';
    }
    if (data is _i43.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i44.Nullability) {
      return 'Nullability';
    }
    if (data is _i45.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i46.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i47.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i48.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i49.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i50.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i51.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i52.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i53.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i54.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i55.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i56.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i57.ScopeServerOnlyField) {
      return 'ScopeServerOnlyField';
    }
    if (data is _i58.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i59.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i60.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i61.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i62.ServerOnlyClassField) {
      return 'ServerOnlyClassField';
    }
    if (data is _i63.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i64.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i65.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i66.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i67.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i68.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i69.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i70.Types) {
      return 'Types';
    }
    if (data is _i71.TypesList) {
      return 'TypesList';
    }
    if (data is _i72.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i73.UniqueData) {
      return 'UniqueData';
    }
    className = _i82.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i75.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'] == 'CustomClass') {
      return deserialize<_i79.CustomClass>(data['data']);
    }
    if (data['className'] == 'CustomClass2') {
      return deserialize<_i79.CustomClass2>(data['data']);
    }
    if (data['className'] == 'ProtocolCustomClass') {
      return deserialize<_i80.ProtocolCustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i81.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i81.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'DateTimeDefault') {
      return deserialize<_i2.DateTimeDefault>(data['data']);
    }
    if (data['className'] == 'DateTimeDefaultMix') {
      return deserialize<_i3.DateTimeDefaultMix>(data['data']);
    }
    if (data['className'] == 'DateTimeDefaultModel') {
      return deserialize<_i4.DateTimeDefaultModel>(data['data']);
    }
    if (data['className'] == 'DateTimeDefaultPersist') {
      return deserialize<_i5.DateTimeDefaultPersist>(data['data']);
    }
    if (data['className'] == 'EmptyModelRelationItem') {
      return deserialize<_i6.EmptyModelRelationItem>(data['data']);
    }
    if (data['className'] == 'EmptyModel') {
      return deserialize<_i7.EmptyModel>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i8.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'CityWithLongTableName') {
      return deserialize<_i9.CityWithLongTableName>(data['data']);
    }
    if (data['className'] == 'OrganizationWithLongTableName') {
      return deserialize<_i10.OrganizationWithLongTableName>(data['data']);
    }
    if (data['className'] == 'PersonWithLongTableName') {
      return deserialize<_i11.PersonWithLongTableName>(data['data']);
    }
    if (data['className'] == 'MaxFieldName') {
      return deserialize<_i12.MaxFieldName>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdField') {
      return deserialize<_i13.LongImplicitIdField>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdFieldCollection') {
      return deserialize<_i14.LongImplicitIdFieldCollection>(data['data']);
    }
    if (data['className'] == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i15.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'UserNote') {
      return deserialize<_i16.UserNote>(data['data']);
    }
    if (data['className'] == 'UserNoteCollection') {
      return deserialize<_i17.UserNoteCollection>(data['data']);
    }
    if (data['className'] == 'UserNoteCollectionWithALongName') {
      return deserialize<_i18.UserNoteCollectionWithALongName>(data['data']);
    }
    if (data['className'] == 'UserNoteWithALongName') {
      return deserialize<_i19.UserNoteWithALongName>(data['data']);
    }
    if (data['className'] == 'MultipleMaxFieldName') {
      return deserialize<_i20.MultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'City') {
      return deserialize<_i21.City>(data['data']);
    }
    if (data['className'] == 'Organization') {
      return deserialize<_i22.Organization>(data['data']);
    }
    if (data['className'] == 'Person') {
      return deserialize<_i23.Person>(data['data']);
    }
    if (data['className'] == 'Course') {
      return deserialize<_i24.Course>(data['data']);
    }
    if (data['className'] == 'Enrollment') {
      return deserialize<_i25.Enrollment>(data['data']);
    }
    if (data['className'] == 'Student') {
      return deserialize<_i26.Student>(data['data']);
    }
    if (data['className'] == 'ObjectUser') {
      return deserialize<_i27.ObjectUser>(data['data']);
    }
    if (data['className'] == 'ParentUser') {
      return deserialize<_i28.ParentUser>(data['data']);
    }
    if (data['className'] == 'Arena') {
      return deserialize<_i29.Arena>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i30.Player>(data['data']);
    }
    if (data['className'] == 'Team') {
      return deserialize<_i31.Team>(data['data']);
    }
    if (data['className'] == 'Comment') {
      return deserialize<_i32.Comment>(data['data']);
    }
    if (data['className'] == 'Customer') {
      return deserialize<_i33.Customer>(data['data']);
    }
    if (data['className'] == 'Order') {
      return deserialize<_i34.Order>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i35.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i36.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i37.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i38.Town>(data['data']);
    }
    if (data['className'] == 'Blocking') {
      return deserialize<_i39.Blocking>(data['data']);
    }
    if (data['className'] == 'Member') {
      return deserialize<_i40.Member>(data['data']);
    }
    if (data['className'] == 'Cat') {
      return deserialize<_i41.Cat>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i42.Post>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i43.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i44.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i45.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i46.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i47.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i48.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i49.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i50.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i51.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i52.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i53.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i54.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i55.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'ScopeNoneFields') {
      return deserialize<_i56.ScopeNoneFields>(data['data']);
    }
    if (data['className'] == 'ScopeServerOnlyField') {
      return deserialize<_i57.ScopeServerOnlyField>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i58.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i59.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i60.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i61.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClassField') {
      return deserialize<_i62.ServerOnlyClassField>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i63.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i64.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i65.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDataObject') {
      return deserialize<_i66.SimpleDataObject>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i67.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i68.TestEnum>(data['data']);
    }
    if (data['className'] == 'TestEnumStringified') {
      return deserialize<_i69.TestEnumStringified>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i70.Types>(data['data']);
    }
    if (data['className'] == 'TypesList') {
      return deserialize<_i71.TypesList>(data['data']);
    }
    if (data['className'] == 'TypesMap') {
      return deserialize<_i72.TypesMap>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i73.UniqueData>(data['data']);
    }
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i82.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i75.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
