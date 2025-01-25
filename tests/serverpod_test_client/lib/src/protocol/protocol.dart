/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod_client/serverpod_client.dart' as _i1;
import 'by_index_enum_with_name_value.dart' as _i2;
import 'by_name_enum_with_name_value.dart' as _i3;
import 'defaults/boolean/bool_default.dart' as _i4;
import 'defaults/boolean/bool_default_mix.dart' as _i5;
import 'defaults/boolean/bool_default_model.dart' as _i6;
import 'defaults/boolean/bool_default_persist.dart' as _i7;
import 'defaults/datetime/datetime_default.dart' as _i8;
import 'defaults/datetime/datetime_default_mix.dart' as _i9;
import 'defaults/datetime/datetime_default_model.dart' as _i10;
import 'defaults/datetime/datetime_default_persist.dart' as _i11;
import 'defaults/double/double_default.dart' as _i12;
import 'defaults/double/double_default_mix.dart' as _i13;
import 'defaults/double/double_default_model.dart' as _i14;
import 'defaults/double/double_default_persist.dart' as _i15;
import 'defaults/duration/duration_default.dart' as _i16;
import 'defaults/duration/duration_default_mix.dart' as _i17;
import 'defaults/duration/duration_default_model.dart' as _i18;
import 'defaults/duration/duration_default_persist.dart' as _i19;
import 'defaults/enum/enum_default.dart' as _i20;
import 'defaults/enum/enum_default_mix.dart' as _i21;
import 'defaults/enum/enum_default_model.dart' as _i22;
import 'defaults/enum/enum_default_persist.dart' as _i23;
import 'defaults/enum/enums/by_index_enum.dart' as _i24;
import 'defaults/enum/enums/by_name_enum.dart' as _i25;
import 'defaults/exception/default_exception.dart' as _i26;
import 'defaults/integer/int_default.dart' as _i27;
import 'defaults/integer/int_default_mix.dart' as _i28;
import 'defaults/integer/int_default_model.dart' as _i29;
import 'defaults/integer/int_default_persist.dart' as _i30;
import 'defaults/string/string_default.dart' as _i31;
import 'defaults/string/string_default_mix.dart' as _i32;
import 'defaults/string/string_default_model.dart' as _i33;
import 'defaults/string/string_default_persist.dart' as _i34;
import 'defaults/uuid/uuid_default.dart' as _i35;
import 'defaults/uuid/uuid_default_mix.dart' as _i36;
import 'defaults/uuid/uuid_default_model.dart' as _i37;
import 'defaults/uuid/uuid_default_persist.dart' as _i38;
import 'empty_model/empty_model.dart' as _i39;
import 'empty_model/empty_model_relation_item.dart' as _i40;
import 'empty_model/empty_model_with_table.dart' as _i41;
import 'empty_model/relation_empy_model.dart' as _i42;
import 'exception_with_data.dart' as _i43;
import 'inheritance/child_class.dart' as _i44;
import 'inheritance/child_with_default.dart' as _i45;
import 'inheritance/grandparent_class.dart' as _i46;
import 'inheritance/parent_class.dart' as _i47;
import 'inheritance/parent_with_default.dart' as _i48;
import 'inheritance/sealed_parent.dart' as _i49;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i50;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i51;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i52;
import 'long_identifiers/max_field_name.dart' as _i53;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i54;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i55;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i56;
import 'long_identifiers/models_with_relations/user_note.dart' as _i57;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i58;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i59;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i60;
import 'long_identifiers/multiple_max_field_name.dart' as _i61;
import 'models_with_list_relations/city.dart' as _i62;
import 'models_with_list_relations/organization.dart' as _i63;
import 'models_with_list_relations/person.dart' as _i64;
import 'models_with_relations/many_to_many/course.dart' as _i65;
import 'models_with_relations/many_to_many/enrollment.dart' as _i66;
import 'models_with_relations/many_to_many/student.dart' as _i67;
import 'models_with_relations/module/object_user.dart' as _i68;
import 'models_with_relations/module/parent_user.dart' as _i69;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i70;
import 'models_with_relations/nested_one_to_many/player.dart' as _i71;
import 'models_with_relations/nested_one_to_many/team.dart' as _i72;
import 'models_with_relations/one_to_many/comment.dart' as _i73;
import 'models_with_relations/one_to_many/customer.dart' as _i74;
import 'models_with_relations/one_to_many/order.dart' as _i75;
import 'models_with_relations/one_to_one/address.dart' as _i76;
import 'models_with_relations/one_to_one/citizen.dart' as _i77;
import 'models_with_relations/one_to_one/company.dart' as _i78;
import 'models_with_relations/one_to_one/town.dart' as _i79;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i80;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i81;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i82;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i83;
import 'module_datatype.dart' as _i84;
import 'nullability.dart' as _i85;
import 'object_field_persist.dart' as _i86;
import 'object_field_scopes.dart' as _i87;
import 'object_with_bytedata.dart' as _i88;
import 'object_with_custom_class.dart' as _i89;
import 'object_with_duration.dart' as _i90;
import 'object_with_enum.dart' as _i91;
import 'object_with_index.dart' as _i92;
import 'object_with_maps.dart' as _i93;
import 'object_with_object.dart' as _i94;
import 'object_with_parent.dart' as _i95;
import 'object_with_self_parent.dart' as _i96;
import 'object_with_uuid.dart' as _i97;
import 'related_unique_data.dart' as _i98;
import 'scopes/scope_none_fields.dart' as _i99;
import 'scopes/scope_server_only_field.dart' as _i100;
import 'scopes/scope_server_only_field_child.dart' as _i101;
import 'scopes/serverOnly/default_server_only_class.dart' as _i102;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i103;
import 'scopes/serverOnly/not_server_only_class.dart' as _i104;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i105;
import 'scopes/server_only_class_field.dart' as _i106;
import 'simple_data.dart' as _i107;
import 'simple_data_list.dart' as _i108;
import 'simple_data_map.dart' as _i109;
import 'simple_data_object.dart' as _i110;
import 'simple_date_time.dart' as _i111;
import 'test_enum.dart' as _i112;
import 'test_enum_stringified.dart' as _i113;
import 'types.dart' as _i114;
import 'types_list.dart' as _i115;
import 'types_map.dart' as _i116;
import 'unique_data.dart' as _i117;
import 'my_feature/models/my_feature_model.dart' as _i118;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i119;
import 'dart:typed_data' as _i120;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i121;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i122;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i123;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i124;
export 'by_index_enum_with_name_value.dart';
export 'by_name_enum_with_name_value.dart';
export 'defaults/boolean/bool_default.dart';
export 'defaults/boolean/bool_default_mix.dart';
export 'defaults/boolean/bool_default_model.dart';
export 'defaults/boolean/bool_default_persist.dart';
export 'defaults/datetime/datetime_default.dart';
export 'defaults/datetime/datetime_default_mix.dart';
export 'defaults/datetime/datetime_default_model.dart';
export 'defaults/datetime/datetime_default_persist.dart';
export 'defaults/double/double_default.dart';
export 'defaults/double/double_default_mix.dart';
export 'defaults/double/double_default_model.dart';
export 'defaults/double/double_default_persist.dart';
export 'defaults/duration/duration_default.dart';
export 'defaults/duration/duration_default_mix.dart';
export 'defaults/duration/duration_default_model.dart';
export 'defaults/duration/duration_default_persist.dart';
export 'defaults/enum/enum_default.dart';
export 'defaults/enum/enum_default_mix.dart';
export 'defaults/enum/enum_default_model.dart';
export 'defaults/enum/enum_default_persist.dart';
export 'defaults/enum/enums/by_index_enum.dart';
export 'defaults/enum/enums/by_name_enum.dart';
export 'defaults/exception/default_exception.dart';
export 'defaults/integer/int_default.dart';
export 'defaults/integer/int_default_mix.dart';
export 'defaults/integer/int_default_model.dart';
export 'defaults/integer/int_default_persist.dart';
export 'defaults/string/string_default.dart';
export 'defaults/string/string_default_mix.dart';
export 'defaults/string/string_default_model.dart';
export 'defaults/string/string_default_persist.dart';
export 'defaults/uuid/uuid_default.dart';
export 'defaults/uuid/uuid_default_mix.dart';
export 'defaults/uuid/uuid_default_model.dart';
export 'defaults/uuid/uuid_default_persist.dart';
export 'empty_model/empty_model.dart';
export 'empty_model/empty_model_relation_item.dart';
export 'empty_model/empty_model_with_table.dart';
export 'empty_model/relation_empy_model.dart';
export 'exception_with_data.dart';
export 'inheritance/child_class.dart';
export 'inheritance/child_with_default.dart';
export 'inheritance/grandparent_class.dart';
export 'inheritance/parent_class.dart';
export 'inheritance/parent_with_default.dart';
export 'inheritance/sealed_no_child.dart';
export 'inheritance/sealed_parent.dart';
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
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
export 'object_with_custom_class.dart';
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
export 'scopes/scope_server_only_field_child.dart';
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
export 'my_feature/models/my_feature_model.dart';
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
    if (t == _i2.ByIndexEnumWithNameValue) {
      return _i2.ByIndexEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i3.ByNameEnumWithNameValue) {
      return _i3.ByNameEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i4.BoolDefault) {
      return _i4.BoolDefault.fromJson(data) as T;
    }
    if (t == _i5.BoolDefaultMix) {
      return _i5.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i6.BoolDefaultModel) {
      return _i6.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i7.BoolDefaultPersist) {
      return _i7.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i8.DateTimeDefault) {
      return _i8.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i9.DateTimeDefaultMix) {
      return _i9.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i10.DateTimeDefaultModel) {
      return _i10.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i11.DateTimeDefaultPersist) {
      return _i11.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i12.DoubleDefault) {
      return _i12.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i13.DoubleDefaultMix) {
      return _i13.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i14.DoubleDefaultModel) {
      return _i14.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i15.DoubleDefaultPersist) {
      return _i15.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i16.DurationDefault) {
      return _i16.DurationDefault.fromJson(data) as T;
    }
    if (t == _i17.DurationDefaultMix) {
      return _i17.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i18.DurationDefaultModel) {
      return _i18.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i19.DurationDefaultPersist) {
      return _i19.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i20.EnumDefault) {
      return _i20.EnumDefault.fromJson(data) as T;
    }
    if (t == _i21.EnumDefaultMix) {
      return _i21.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i22.EnumDefaultModel) {
      return _i22.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i23.EnumDefaultPersist) {
      return _i23.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i24.ByIndexEnum) {
      return _i24.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i25.ByNameEnum) {
      return _i25.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i26.DefaultException) {
      return _i26.DefaultException.fromJson(data) as T;
    }
    if (t == _i27.IntDefault) {
      return _i27.IntDefault.fromJson(data) as T;
    }
    if (t == _i28.IntDefaultMix) {
      return _i28.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i29.IntDefaultModel) {
      return _i29.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i30.IntDefaultPersist) {
      return _i30.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i31.StringDefault) {
      return _i31.StringDefault.fromJson(data) as T;
    }
    if (t == _i32.StringDefaultMix) {
      return _i32.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i33.StringDefaultModel) {
      return _i33.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i34.StringDefaultPersist) {
      return _i34.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i35.UuidDefault) {
      return _i35.UuidDefault.fromJson(data) as T;
    }
    if (t == _i36.UuidDefaultMix) {
      return _i36.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i37.UuidDefaultModel) {
      return _i37.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i38.UuidDefaultPersist) {
      return _i38.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i39.EmptyModel) {
      return _i39.EmptyModel.fromJson(data) as T;
    }
    if (t == _i40.EmptyModelRelationItem) {
      return _i40.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i41.EmptyModelWithTable) {
      return _i41.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i42.RelationEmptyModel) {
      return _i42.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i43.ExceptionWithData) {
      return _i43.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i44.ChildClass) {
      return _i44.ChildClass.fromJson(data) as T;
    }
    if (t == _i45.ChildWithDefault) {
      return _i45.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i46.GrandparentClass) {
      return _i46.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i47.ParentClass) {
      return _i47.ParentClass.fromJson(data) as T;
    }
    if (t == _i48.ParentWithDefault) {
      return _i48.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i49.SealedChild) {
      return _i49.SealedChild.fromJson(data) as T;
    }
    if (t == _i49.SealedGrandChild) {
      return _i49.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i49.SealedOtherChild) {
      return _i49.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i50.CityWithLongTableName) {
      return _i50.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i51.OrganizationWithLongTableName) {
      return _i51.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i52.PersonWithLongTableName) {
      return _i52.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i53.MaxFieldName) {
      return _i53.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i54.LongImplicitIdField) {
      return _i54.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i55.LongImplicitIdFieldCollection) {
      return _i55.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i56.RelationToMultipleMaxFieldName) {
      return _i56.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i57.UserNote) {
      return _i57.UserNote.fromJson(data) as T;
    }
    if (t == _i58.UserNoteCollection) {
      return _i58.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i59.UserNoteCollectionWithALongName) {
      return _i59.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i60.UserNoteWithALongName) {
      return _i60.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i61.MultipleMaxFieldName) {
      return _i61.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i62.City) {
      return _i62.City.fromJson(data) as T;
    }
    if (t == _i63.Organization) {
      return _i63.Organization.fromJson(data) as T;
    }
    if (t == _i64.Person) {
      return _i64.Person.fromJson(data) as T;
    }
    if (t == _i65.Course) {
      return _i65.Course.fromJson(data) as T;
    }
    if (t == _i66.Enrollment) {
      return _i66.Enrollment.fromJson(data) as T;
    }
    if (t == _i67.Student) {
      return _i67.Student.fromJson(data) as T;
    }
    if (t == _i68.ObjectUser) {
      return _i68.ObjectUser.fromJson(data) as T;
    }
    if (t == _i69.ParentUser) {
      return _i69.ParentUser.fromJson(data) as T;
    }
    if (t == _i70.Arena) {
      return _i70.Arena.fromJson(data) as T;
    }
    if (t == _i71.Player) {
      return _i71.Player.fromJson(data) as T;
    }
    if (t == _i72.Team) {
      return _i72.Team.fromJson(data) as T;
    }
    if (t == _i73.Comment) {
      return _i73.Comment.fromJson(data) as T;
    }
    if (t == _i74.Customer) {
      return _i74.Customer.fromJson(data) as T;
    }
    if (t == _i75.Order) {
      return _i75.Order.fromJson(data) as T;
    }
    if (t == _i76.Address) {
      return _i76.Address.fromJson(data) as T;
    }
    if (t == _i77.Citizen) {
      return _i77.Citizen.fromJson(data) as T;
    }
    if (t == _i78.Company) {
      return _i78.Company.fromJson(data) as T;
    }
    if (t == _i79.Town) {
      return _i79.Town.fromJson(data) as T;
    }
    if (t == _i80.Blocking) {
      return _i80.Blocking.fromJson(data) as T;
    }
    if (t == _i81.Member) {
      return _i81.Member.fromJson(data) as T;
    }
    if (t == _i82.Cat) {
      return _i82.Cat.fromJson(data) as T;
    }
    if (t == _i83.Post) {
      return _i83.Post.fromJson(data) as T;
    }
    if (t == _i84.ModuleDatatype) {
      return _i84.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i85.Nullability) {
      return _i85.Nullability.fromJson(data) as T;
    }
    if (t == _i86.ObjectFieldPersist) {
      return _i86.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i87.ObjectFieldScopes) {
      return _i87.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i88.ObjectWithByteData) {
      return _i88.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i89.ObjectWithCustomClass) {
      return _i89.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i90.ObjectWithDuration) {
      return _i90.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i91.ObjectWithEnum) {
      return _i91.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i92.ObjectWithIndex) {
      return _i92.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i93.ObjectWithMaps) {
      return _i93.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i94.ObjectWithObject) {
      return _i94.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i95.ObjectWithParent) {
      return _i95.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i96.ObjectWithSelfParent) {
      return _i96.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i97.ObjectWithUuid) {
      return _i97.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i98.RelatedUniqueData) {
      return _i98.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i99.ScopeNoneFields) {
      return _i99.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i100.ScopeServerOnlyField) {
      return _i100.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i101.ScopeServerOnlyFieldChild) {
      return _i101.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i102.DefaultServerOnlyClass) {
      return _i102.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i103.DefaultServerOnlyEnum) {
      return _i103.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i104.NotServerOnlyClass) {
      return _i104.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i105.NotServerOnlyEnum) {
      return _i105.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i106.ServerOnlyClassField) {
      return _i106.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i107.SimpleData) {
      return _i107.SimpleData.fromJson(data) as T;
    }
    if (t == _i108.SimpleDataList) {
      return _i108.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i109.SimpleDataMap) {
      return _i109.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i110.SimpleDataObject) {
      return _i110.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i111.SimpleDateTime) {
      return _i111.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i112.TestEnum) {
      return _i112.TestEnum.fromJson(data) as T;
    }
    if (t == _i113.TestEnumStringified) {
      return _i113.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i114.Types) {
      return _i114.Types.fromJson(data) as T;
    }
    if (t == _i115.TypesList) {
      return _i115.TypesList.fromJson(data) as T;
    }
    if (t == _i116.TypesMap) {
      return _i116.TypesMap.fromJson(data) as T;
    }
    if (t == _i117.UniqueData) {
      return _i117.UniqueData.fromJson(data) as T;
    }
    if (t == _i118.MyFeatureModel) {
      return _i118.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ByIndexEnumWithNameValue?>()) {
      return (data != null ? _i2.ByIndexEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ByNameEnumWithNameValue?>()) {
      return (data != null ? _i3.ByNameEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.BoolDefault?>()) {
      return (data != null ? _i4.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.BoolDefaultMix?>()) {
      return (data != null ? _i5.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.BoolDefaultModel?>()) {
      return (data != null ? _i6.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.BoolDefaultPersist?>()) {
      return (data != null ? _i7.BoolDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.DateTimeDefault?>()) {
      return (data != null ? _i8.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.DateTimeDefaultMix?>()) {
      return (data != null ? _i9.DateTimeDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.DateTimeDefaultModel?>()) {
      return (data != null ? _i10.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.DateTimeDefaultPersist?>()) {
      return (data != null ? _i11.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i12.DoubleDefault?>()) {
      return (data != null ? _i12.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.DoubleDefaultMix?>()) {
      return (data != null ? _i13.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.DoubleDefaultModel?>()) {
      return (data != null ? _i14.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.DoubleDefaultPersist?>()) {
      return (data != null ? _i15.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i16.DurationDefault?>()) {
      return (data != null ? _i16.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.DurationDefaultMix?>()) {
      return (data != null ? _i17.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.DurationDefaultModel?>()) {
      return (data != null ? _i18.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.DurationDefaultPersist?>()) {
      return (data != null ? _i19.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i20.EnumDefault?>()) {
      return (data != null ? _i20.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.EnumDefaultMix?>()) {
      return (data != null ? _i21.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.EnumDefaultModel?>()) {
      return (data != null ? _i22.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.EnumDefaultPersist?>()) {
      return (data != null ? _i23.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.ByIndexEnum?>()) {
      return (data != null ? _i24.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ByNameEnum?>()) {
      return (data != null ? _i25.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.DefaultException?>()) {
      return (data != null ? _i26.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.IntDefault?>()) {
      return (data != null ? _i27.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.IntDefaultMix?>()) {
      return (data != null ? _i28.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.IntDefaultModel?>()) {
      return (data != null ? _i29.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.IntDefaultPersist?>()) {
      return (data != null ? _i30.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.StringDefault?>()) {
      return (data != null ? _i31.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.StringDefaultMix?>()) {
      return (data != null ? _i32.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.StringDefaultModel?>()) {
      return (data != null ? _i33.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.StringDefaultPersist?>()) {
      return (data != null ? _i34.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.UuidDefault?>()) {
      return (data != null ? _i35.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.UuidDefaultMix?>()) {
      return (data != null ? _i36.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.UuidDefaultModel?>()) {
      return (data != null ? _i37.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.UuidDefaultPersist?>()) {
      return (data != null ? _i38.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.EmptyModel?>()) {
      return (data != null ? _i39.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.EmptyModelRelationItem?>()) {
      return (data != null ? _i40.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.EmptyModelWithTable?>()) {
      return (data != null ? _i41.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.RelationEmptyModel?>()) {
      return (data != null ? _i42.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.ExceptionWithData?>()) {
      return (data != null ? _i43.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.ChildClass?>()) {
      return (data != null ? _i44.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ChildWithDefault?>()) {
      return (data != null ? _i45.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.GrandparentClass?>()) {
      return (data != null ? _i46.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ParentClass?>()) {
      return (data != null ? _i47.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ParentWithDefault?>()) {
      return (data != null ? _i48.ParentWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.SealedChild?>()) {
      return (data != null ? _i49.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.SealedGrandChild?>()) {
      return (data != null ? _i49.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.SealedOtherChild?>()) {
      return (data != null ? _i49.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.CityWithLongTableName?>()) {
      return (data != null ? _i50.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i51.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i52.PersonWithLongTableName?>()) {
      return (data != null ? _i52.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.MaxFieldName?>()) {
      return (data != null ? _i53.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.LongImplicitIdField?>()) {
      return (data != null ? _i54.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i55.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i56.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i56.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i57.UserNote?>()) {
      return (data != null ? _i57.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.UserNoteCollection?>()) {
      return (data != null ? _i58.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i59.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i59.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i60.UserNoteWithALongName?>()) {
      return (data != null ? _i60.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.MultipleMaxFieldName?>()) {
      return (data != null ? _i61.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.City?>()) {
      return (data != null ? _i62.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.Organization?>()) {
      return (data != null ? _i63.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.Person?>()) {
      return (data != null ? _i64.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.Course?>()) {
      return (data != null ? _i65.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.Enrollment?>()) {
      return (data != null ? _i66.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.Student?>()) {
      return (data != null ? _i67.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.ObjectUser?>()) {
      return (data != null ? _i68.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.ParentUser?>()) {
      return (data != null ? _i69.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.Arena?>()) {
      return (data != null ? _i70.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.Player?>()) {
      return (data != null ? _i71.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.Team?>()) {
      return (data != null ? _i72.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.Comment?>()) {
      return (data != null ? _i73.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.Customer?>()) {
      return (data != null ? _i74.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.Order?>()) {
      return (data != null ? _i75.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.Address?>()) {
      return (data != null ? _i76.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.Citizen?>()) {
      return (data != null ? _i77.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.Company?>()) {
      return (data != null ? _i78.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.Town?>()) {
      return (data != null ? _i79.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.Blocking?>()) {
      return (data != null ? _i80.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.Member?>()) {
      return (data != null ? _i81.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i82.Cat?>()) {
      return (data != null ? _i82.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.Post?>()) {
      return (data != null ? _i83.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i84.ModuleDatatype?>()) {
      return (data != null ? _i84.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.Nullability?>()) {
      return (data != null ? _i85.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.ObjectFieldPersist?>()) {
      return (data != null ? _i86.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.ObjectFieldScopes?>()) {
      return (data != null ? _i87.ObjectFieldScopes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.ObjectWithByteData?>()) {
      return (data != null ? _i88.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i89.ObjectWithCustomClass?>()) {
      return (data != null ? _i89.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i90.ObjectWithDuration?>()) {
      return (data != null ? _i90.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i91.ObjectWithEnum?>()) {
      return (data != null ? _i91.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.ObjectWithIndex?>()) {
      return (data != null ? _i92.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.ObjectWithMaps?>()) {
      return (data != null ? _i93.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.ObjectWithObject?>()) {
      return (data != null ? _i94.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.ObjectWithParent?>()) {
      return (data != null ? _i95.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.ObjectWithSelfParent?>()) {
      return (data != null ? _i96.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.ObjectWithUuid?>()) {
      return (data != null ? _i97.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.RelatedUniqueData?>()) {
      return (data != null ? _i98.RelatedUniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.ScopeNoneFields?>()) {
      return (data != null ? _i99.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.ScopeServerOnlyField?>()) {
      return (data != null ? _i100.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i101.ScopeServerOnlyFieldChild?>()) {
      return (data != null
          ? _i101.ScopeServerOnlyFieldChild.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i102.DefaultServerOnlyClass?>()) {
      return (data != null ? _i102.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i103.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i103.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i104.NotServerOnlyClass?>()) {
      return (data != null ? _i104.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i105.NotServerOnlyEnum?>()) {
      return (data != null ? _i105.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i106.ServerOnlyClassField?>()) {
      return (data != null ? _i106.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.SimpleData?>()) {
      return (data != null ? _i107.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.SimpleDataList?>()) {
      return (data != null ? _i108.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.SimpleDataMap?>()) {
      return (data != null ? _i109.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.SimpleDataObject?>()) {
      return (data != null ? _i110.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.SimpleDateTime?>()) {
      return (data != null ? _i111.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i112.TestEnum?>()) {
      return (data != null ? _i112.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i113.TestEnumStringified?>()) {
      return (data != null ? _i113.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i114.Types?>()) {
      return (data != null ? _i114.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.TypesList?>()) {
      return (data != null ? _i115.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i116.TypesMap?>()) {
      return (data != null ? _i116.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.UniqueData?>()) {
      return (data != null ? _i117.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i118.MyFeatureModel?>()) {
      return (data != null ? _i118.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i40.EmptyModelRelationItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i40.EmptyModelRelationItem>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i52.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i52.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i51.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i51.OrganizationWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i52.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i52.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i54.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i54.LongImplicitIdField>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i61.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i61.MultipleMaxFieldName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i57.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i57.UserNote>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i60.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i60.UserNoteWithALongName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i64.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i64.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i63.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i63.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i64.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i64.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i66.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i66.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i66.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i66.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i71.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i71.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i75.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i80.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i80.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i80.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i80.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i82.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i82.Cat>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i119.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i119.ModuleClass>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i119.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i119.ModuleClass>(v)))
          as dynamic;
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
    if (t == List<_i107.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i107.SimpleData>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i107.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i107.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i107.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i107.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i107.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i107.SimpleData?>(e))
              .toList()
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
    if (t == List<_i120.ByteData>) {
      return (data as List).map((e) => deserialize<_i120.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i120.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i120.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i120.ByteData?>) {
      return (data as List).map((e) => deserialize<_i120.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i120.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i120.ByteData?>(e)).toList()
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
    if (t == _i121.CustomClassWithoutProtocolSerialization) {
      return _i121.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i121.CustomClassWithProtocolSerialization) {
      return _i121.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i121.CustomClassWithProtocolSerializationMethod) {
      return _i121.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i112.TestEnum>) {
      return (data as List).map((e) => deserialize<_i112.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i112.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i112.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i112.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i112.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i107.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i107.SimpleData>(v))) as dynamic;
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
    if (t == Map<String, _i120.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i120.ByteData>(v)))
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
    if (t == Map<String, _i107.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i107.SimpleData?>(v)))
          as dynamic;
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
    if (t == Map<String, _i120.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i120.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i107.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i107.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i107.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i107.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<_i107.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i107.SimpleData>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i107.SimpleData>>?>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<List<List<Map<int, _i107.SimpleData>>?>>(v)))
          : null) as dynamic;
    }
    if (t == List<List<Map<int, _i107.SimpleData>>?>) {
      return (data as List)
          .map((e) => deserialize<List<Map<int, _i107.SimpleData>>?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<Map<int, _i107.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<int, _i107.SimpleData>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<int, _i107.SimpleData>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<int>(e['k']), deserialize<_i107.SimpleData>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<int, _i107.SimpleData>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<Map<int, _i107.SimpleData>>(v)))
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
    if (t == _i1.getType<List<_i120.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i120.ByteData>(e)).toList()
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
    if (t == _i1.getType<List<_i112.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i112.TestEnum>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i113.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i113.TestEnumStringified>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i114.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i114.Types>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Map<String, _i114.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i114.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, _i114.Types>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i114.Types>(v)))
          as dynamic;
    }
    if (t == _i1.getType<List<List<_i114.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i114.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i114.Types>) {
      return (data as List).map((e) => deserialize<_i114.Types>(e)).toList()
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
    if (t == _i1.getType<Map<_i120.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i120.ByteData>(e['k']),
              deserialize<String>(e['v']))))
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
    if (t == _i1.getType<Map<_i112.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i112.TestEnum>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i113.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i113.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i114.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i114.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Map<_i114.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i114.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == Map<_i114.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i114.Types>(e['k']), deserialize<String>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<List<_i114.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i114.Types>>(e['k']),
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
    if (t == _i1.getType<Map<String, _i120.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i120.ByteData>(v)))
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
    if (t == _i1.getType<Map<String, _i112.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i112.TestEnum>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i113.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<_i113.TestEnumStringified>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i114.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i114.Types>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<String, _i114.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i114.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, List<_i114.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i114.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i122.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i122.SimpleData>(e))
          .toList() as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
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
    if (t == List<_i120.ByteData>) {
      return (data as List).map((e) => deserialize<_i120.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i120.ByteData?>) {
      return (data as List).map((e) => deserialize<_i120.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i122.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i122.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i122.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i122.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i122.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i122.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i122.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i122.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i122.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i122.SimpleData?>(e))
              .toList()
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
    if (t == Map<_i123.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i123.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i123.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i123.TestEnum>(v)))
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
    if (t == Map<String, _i120.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i120.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i120.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i120.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i122.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i122.SimpleData>(v))) as dynamic;
    }
    if (t == Map<String, _i122.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i122.SimpleData?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, _i122.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i122.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i122.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i122.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i122.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i122.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i122.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i122.SimpleData?>(v)))
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
    if (t == _i121.CustomClass) {
      return _i121.CustomClass.fromJson(data) as T;
    }
    if (t == _i121.CustomClass2) {
      return _i121.CustomClass2.fromJson(data) as T;
    }
    if (t == _i121.ProtocolCustomClass) {
      return _i121.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i121.ExternalCustomClass) {
      return _i121.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i121.FreezedCustomClass) {
      return _i121.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i121.CustomClass?>()) {
      return (data != null ? _i121.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.CustomClass2?>()) {
      return (data != null ? _i121.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
          ? _i121.CustomClassWithoutProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i121.CustomClassWithProtocolSerialization?>()) {
      return (data != null
          ? _i121.CustomClassWithProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i121.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
          ? _i121.CustomClassWithProtocolSerializationMethod.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i121.ProtocolCustomClass?>()) {
      return (data != null ? _i121.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i121.ExternalCustomClass?>()) {
      return (data != null ? _i121.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i121.FreezedCustomClass?>()) {
      return (data != null ? _i121.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    try {
      return _i124.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i119.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i121.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i121.CustomClass2) {
      return 'CustomClass2';
    }
    if (data is _i121.CustomClassWithoutProtocolSerialization) {
      return 'CustomClassWithoutProtocolSerialization';
    }
    if (data is _i121.CustomClassWithProtocolSerialization) {
      return 'CustomClassWithProtocolSerialization';
    }
    if (data is _i121.CustomClassWithProtocolSerializationMethod) {
      return 'CustomClassWithProtocolSerializationMethod';
    }
    if (data is _i121.ProtocolCustomClass) {
      return 'ProtocolCustomClass';
    }
    if (data is _i121.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i121.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.ByIndexEnumWithNameValue) {
      return 'ByIndexEnumWithNameValue';
    }
    if (data is _i3.ByNameEnumWithNameValue) {
      return 'ByNameEnumWithNameValue';
    }
    if (data is _i4.BoolDefault) {
      return 'BoolDefault';
    }
    if (data is _i5.BoolDefaultMix) {
      return 'BoolDefaultMix';
    }
    if (data is _i6.BoolDefaultModel) {
      return 'BoolDefaultModel';
    }
    if (data is _i7.BoolDefaultPersist) {
      return 'BoolDefaultPersist';
    }
    if (data is _i8.DateTimeDefault) {
      return 'DateTimeDefault';
    }
    if (data is _i9.DateTimeDefaultMix) {
      return 'DateTimeDefaultMix';
    }
    if (data is _i10.DateTimeDefaultModel) {
      return 'DateTimeDefaultModel';
    }
    if (data is _i11.DateTimeDefaultPersist) {
      return 'DateTimeDefaultPersist';
    }
    if (data is _i12.DoubleDefault) {
      return 'DoubleDefault';
    }
    if (data is _i13.DoubleDefaultMix) {
      return 'DoubleDefaultMix';
    }
    if (data is _i14.DoubleDefaultModel) {
      return 'DoubleDefaultModel';
    }
    if (data is _i15.DoubleDefaultPersist) {
      return 'DoubleDefaultPersist';
    }
    if (data is _i16.DurationDefault) {
      return 'DurationDefault';
    }
    if (data is _i17.DurationDefaultMix) {
      return 'DurationDefaultMix';
    }
    if (data is _i18.DurationDefaultModel) {
      return 'DurationDefaultModel';
    }
    if (data is _i19.DurationDefaultPersist) {
      return 'DurationDefaultPersist';
    }
    if (data is _i20.EnumDefault) {
      return 'EnumDefault';
    }
    if (data is _i21.EnumDefaultMix) {
      return 'EnumDefaultMix';
    }
    if (data is _i22.EnumDefaultModel) {
      return 'EnumDefaultModel';
    }
    if (data is _i23.EnumDefaultPersist) {
      return 'EnumDefaultPersist';
    }
    if (data is _i24.ByIndexEnum) {
      return 'ByIndexEnum';
    }
    if (data is _i25.ByNameEnum) {
      return 'ByNameEnum';
    }
    if (data is _i26.DefaultException) {
      return 'DefaultException';
    }
    if (data is _i27.IntDefault) {
      return 'IntDefault';
    }
    if (data is _i28.IntDefaultMix) {
      return 'IntDefaultMix';
    }
    if (data is _i29.IntDefaultModel) {
      return 'IntDefaultModel';
    }
    if (data is _i30.IntDefaultPersist) {
      return 'IntDefaultPersist';
    }
    if (data is _i31.StringDefault) {
      return 'StringDefault';
    }
    if (data is _i32.StringDefaultMix) {
      return 'StringDefaultMix';
    }
    if (data is _i33.StringDefaultModel) {
      return 'StringDefaultModel';
    }
    if (data is _i34.StringDefaultPersist) {
      return 'StringDefaultPersist';
    }
    if (data is _i35.UuidDefault) {
      return 'UuidDefault';
    }
    if (data is _i36.UuidDefaultMix) {
      return 'UuidDefaultMix';
    }
    if (data is _i37.UuidDefaultModel) {
      return 'UuidDefaultModel';
    }
    if (data is _i38.UuidDefaultPersist) {
      return 'UuidDefaultPersist';
    }
    if (data is _i39.EmptyModel) {
      return 'EmptyModel';
    }
    if (data is _i40.EmptyModelRelationItem) {
      return 'EmptyModelRelationItem';
    }
    if (data is _i41.EmptyModelWithTable) {
      return 'EmptyModelWithTable';
    }
    if (data is _i42.RelationEmptyModel) {
      return 'RelationEmptyModel';
    }
    if (data is _i43.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i44.ChildClass) {
      return 'ChildClass';
    }
    if (data is _i45.ChildWithDefault) {
      return 'ChildWithDefault';
    }
    if (data is _i46.GrandparentClass) {
      return 'GrandparentClass';
    }
    if (data is _i47.ParentClass) {
      return 'ParentClass';
    }
    if (data is _i48.ParentWithDefault) {
      return 'ParentWithDefault';
    }
    if (data is _i49.SealedChild) {
      return 'SealedChild';
    }
    if (data is _i49.SealedGrandChild) {
      return 'SealedGrandChild';
    }
    if (data is _i49.SealedOtherChild) {
      return 'SealedOtherChild';
    }
    if (data is _i50.CityWithLongTableName) {
      return 'CityWithLongTableName';
    }
    if (data is _i51.OrganizationWithLongTableName) {
      return 'OrganizationWithLongTableName';
    }
    if (data is _i52.PersonWithLongTableName) {
      return 'PersonWithLongTableName';
    }
    if (data is _i53.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i54.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i55.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i56.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i57.UserNote) {
      return 'UserNote';
    }
    if (data is _i58.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i59.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i60.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i61.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i62.City) {
      return 'City';
    }
    if (data is _i63.Organization) {
      return 'Organization';
    }
    if (data is _i64.Person) {
      return 'Person';
    }
    if (data is _i65.Course) {
      return 'Course';
    }
    if (data is _i66.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i67.Student) {
      return 'Student';
    }
    if (data is _i68.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i69.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i70.Arena) {
      return 'Arena';
    }
    if (data is _i71.Player) {
      return 'Player';
    }
    if (data is _i72.Team) {
      return 'Team';
    }
    if (data is _i73.Comment) {
      return 'Comment';
    }
    if (data is _i74.Customer) {
      return 'Customer';
    }
    if (data is _i75.Order) {
      return 'Order';
    }
    if (data is _i76.Address) {
      return 'Address';
    }
    if (data is _i77.Citizen) {
      return 'Citizen';
    }
    if (data is _i78.Company) {
      return 'Company';
    }
    if (data is _i79.Town) {
      return 'Town';
    }
    if (data is _i80.Blocking) {
      return 'Blocking';
    }
    if (data is _i81.Member) {
      return 'Member';
    }
    if (data is _i82.Cat) {
      return 'Cat';
    }
    if (data is _i83.Post) {
      return 'Post';
    }
    if (data is _i84.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i85.Nullability) {
      return 'Nullability';
    }
    if (data is _i86.ObjectFieldPersist) {
      return 'ObjectFieldPersist';
    }
    if (data is _i87.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i88.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i89.ObjectWithCustomClass) {
      return 'ObjectWithCustomClass';
    }
    if (data is _i90.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i91.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i92.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i93.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i94.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i95.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i96.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i97.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i98.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i99.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i100.ScopeServerOnlyField) {
      return 'ScopeServerOnlyField';
    }
    if (data is _i101.ScopeServerOnlyFieldChild) {
      return 'ScopeServerOnlyFieldChild';
    }
    if (data is _i102.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i103.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i104.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i105.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i106.ServerOnlyClassField) {
      return 'ServerOnlyClassField';
    }
    if (data is _i107.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i108.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i109.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i110.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i111.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i112.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i113.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i114.Types) {
      return 'Types';
    }
    if (data is _i115.TypesList) {
      return 'TypesList';
    }
    if (data is _i116.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i117.UniqueData) {
      return 'UniqueData';
    }
    if (data is _i118.MyFeatureModel) {
      return 'MyFeatureModel';
    }
    className = _i124.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i119.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CustomClass') {
      return deserialize<_i121.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i121.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i121.CustomClassWithoutProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i121.CustomClassWithProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i121.CustomClassWithProtocolSerializationMethod>(
          data['data']);
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i121.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i121.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i121.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_i2.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_i3.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i4.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i5.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i6.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i7.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i8.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i9.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i10.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i11.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i12.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i13.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i14.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i15.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i16.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i17.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i18.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i19.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i20.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i21.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i22.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i23.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i24.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i25.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i26.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i27.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i28.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i29.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i30.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i31.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i32.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i33.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i34.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i35.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i36.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i37.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i38.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i39.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i40.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i41.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i42.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i43.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i44.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i45.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i46.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i47.ParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i48.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i49.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i49.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i49.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i50.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i51.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i52.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i53.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i54.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i55.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i56.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i57.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i58.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i59.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i60.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i61.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i62.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i63.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i64.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i65.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i66.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i67.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i68.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i69.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i70.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i71.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i72.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i73.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i74.Customer>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i75.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i76.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i77.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i78.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i79.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i80.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i81.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i82.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i83.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i84.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i85.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i86.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i87.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i88.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i89.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i90.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i91.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i92.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i93.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i94.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i95.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i96.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i97.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i98.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i99.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i100.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i101.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i102.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i103.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i104.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i105.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i106.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i107.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i108.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i109.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i110.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i111.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i112.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i113.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i114.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i115.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i116.TypesMap>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i117.UniqueData>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i118.MyFeatureModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i124.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i119.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }
}
