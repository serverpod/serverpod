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
import 'changed_id_type/many_to_many/course.dart' as _i4;
import 'changed_id_type/many_to_many/enrollment.dart' as _i5;
import 'changed_id_type/many_to_many/student.dart' as _i6;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i7;
import 'changed_id_type/nested_one_to_many/player.dart' as _i8;
import 'changed_id_type/nested_one_to_many/team.dart' as _i9;
import 'changed_id_type/one_to_many/comment.dart' as _i10;
import 'changed_id_type/one_to_many/customer.dart' as _i11;
import 'changed_id_type/one_to_many/order.dart' as _i12;
import 'changed_id_type/one_to_one/address.dart' as _i13;
import 'changed_id_type/one_to_one/citizen.dart' as _i14;
import 'changed_id_type/one_to_one/company.dart' as _i15;
import 'changed_id_type/one_to_one/town.dart' as _i16;
import 'changed_id_type/self.dart' as _i17;
import 'defaults/bigint/bigint_default.dart' as _i18;
import 'defaults/bigint/bigint_default_mix.dart' as _i19;
import 'defaults/bigint/bigint_default_model.dart' as _i20;
import 'defaults/bigint/bigint_default_persist.dart' as _i21;
import 'defaults/boolean/bool_default.dart' as _i22;
import 'defaults/boolean/bool_default_mix.dart' as _i23;
import 'defaults/boolean/bool_default_model.dart' as _i24;
import 'defaults/boolean/bool_default_persist.dart' as _i25;
import 'defaults/datetime/datetime_default.dart' as _i26;
import 'defaults/datetime/datetime_default_mix.dart' as _i27;
import 'defaults/datetime/datetime_default_model.dart' as _i28;
import 'defaults/datetime/datetime_default_persist.dart' as _i29;
import 'defaults/double/double_default.dart' as _i30;
import 'defaults/double/double_default_mix.dart' as _i31;
import 'defaults/double/double_default_model.dart' as _i32;
import 'defaults/double/double_default_persist.dart' as _i33;
import 'defaults/duration/duration_default.dart' as _i34;
import 'defaults/duration/duration_default_mix.dart' as _i35;
import 'defaults/duration/duration_default_model.dart' as _i36;
import 'defaults/duration/duration_default_persist.dart' as _i37;
import 'defaults/enum/enum_default.dart' as _i38;
import 'defaults/enum/enum_default_mix.dart' as _i39;
import 'defaults/enum/enum_default_model.dart' as _i40;
import 'defaults/enum/enum_default_persist.dart' as _i41;
import 'defaults/enum/enums/by_index_enum.dart' as _i42;
import 'defaults/enum/enums/by_name_enum.dart' as _i43;
import 'defaults/exception/default_exception.dart' as _i44;
import 'defaults/integer/int_default.dart' as _i45;
import 'defaults/integer/int_default_mix.dart' as _i46;
import 'defaults/integer/int_default_model.dart' as _i47;
import 'defaults/integer/int_default_persist.dart' as _i48;
import 'defaults/string/string_default.dart' as _i49;
import 'defaults/string/string_default_mix.dart' as _i50;
import 'defaults/string/string_default_model.dart' as _i51;
import 'defaults/string/string_default_persist.dart' as _i52;
import 'defaults/uri/uri_default.dart' as _i53;
import 'defaults/uri/uri_default_mix.dart' as _i54;
import 'defaults/uri/uri_default_model.dart' as _i55;
import 'defaults/uri/uri_default_persist.dart' as _i56;
import 'defaults/uuid/uuid_default.dart' as _i57;
import 'defaults/uuid/uuid_default_mix.dart' as _i58;
import 'defaults/uuid/uuid_default_model.dart' as _i59;
import 'defaults/uuid/uuid_default_persist.dart' as _i60;
import 'empty_model/empty_model.dart' as _i61;
import 'empty_model/empty_model_relation_item.dart' as _i62;
import 'empty_model/empty_model_with_table.dart' as _i63;
import 'empty_model/relation_empy_model.dart' as _i64;
import 'exception_with_data.dart' as _i65;
import 'inheritance/child_class.dart' as _i66;
import 'inheritance/child_with_default.dart' as _i67;
import 'inheritance/grandparent_class.dart' as _i68;
import 'inheritance/parent_class.dart' as _i69;
import 'inheritance/parent_with_default.dart' as _i70;
import 'inheritance/sealed_parent.dart' as _i71;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i72;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i73;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i74;
import 'long_identifiers/max_field_name.dart' as _i75;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i76;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i77;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i78;
import 'long_identifiers/models_with_relations/user_note.dart' as _i79;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i80;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i81;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i82;
import 'long_identifiers/multiple_max_field_name.dart' as _i83;
import 'models_with_list_relations/city.dart' as _i84;
import 'models_with_list_relations/organization.dart' as _i85;
import 'models_with_list_relations/person.dart' as _i86;
import 'models_with_relations/many_to_many/course.dart' as _i87;
import 'models_with_relations/many_to_many/enrollment.dart' as _i88;
import 'models_with_relations/many_to_many/student.dart' as _i89;
import 'models_with_relations/module/object_user.dart' as _i90;
import 'models_with_relations/module/parent_user.dart' as _i91;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i92;
import 'models_with_relations/nested_one_to_many/player.dart' as _i93;
import 'models_with_relations/nested_one_to_many/team.dart' as _i94;
import 'models_with_relations/one_to_many/comment.dart' as _i95;
import 'models_with_relations/one_to_many/customer.dart' as _i96;
import 'models_with_relations/one_to_many/order.dart' as _i97;
import 'models_with_relations/one_to_one/address.dart' as _i98;
import 'models_with_relations/one_to_one/citizen.dart' as _i99;
import 'models_with_relations/one_to_one/company.dart' as _i100;
import 'models_with_relations/one_to_one/town.dart' as _i101;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i102;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i103;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i104;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i105;
import 'module_datatype.dart' as _i106;
import 'nullability.dart' as _i107;
import 'object_field_persist.dart' as _i108;
import 'object_field_scopes.dart' as _i109;
import 'object_with_bytedata.dart' as _i110;
import 'object_with_custom_class.dart' as _i111;
import 'object_with_duration.dart' as _i112;
import 'object_with_enum.dart' as _i113;
import 'object_with_index.dart' as _i114;
import 'object_with_maps.dart' as _i115;
import 'object_with_object.dart' as _i116;
import 'object_with_parent.dart' as _i117;
import 'object_with_self_parent.dart' as _i118;
import 'object_with_uuid.dart' as _i119;
import 'related_unique_data.dart' as _i120;
import 'scopes/scope_none_fields.dart' as _i121;
import 'scopes/scope_server_only_field.dart' as _i122;
import 'scopes/scope_server_only_field_child.dart' as _i123;
import 'scopes/serverOnly/default_server_only_class.dart' as _i124;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i125;
import 'scopes/serverOnly/not_server_only_class.dart' as _i126;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i127;
import 'scopes/server_only_class_field.dart' as _i128;
import 'simple_data.dart' as _i129;
import 'simple_data_list.dart' as _i130;
import 'simple_data_map.dart' as _i131;
import 'simple_data_object.dart' as _i132;
import 'simple_date_time.dart' as _i133;
import 'test_enum.dart' as _i134;
import 'test_enum_stringified.dart' as _i135;
import 'types.dart' as _i136;
import 'types_list.dart' as _i137;
import 'types_map.dart' as _i138;
import 'types_set.dart' as _i139;
import 'unique_data.dart' as _i140;
import 'my_feature/models/my_feature_model.dart' as _i141;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i142;
import 'dart:typed_data' as _i143;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i144;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i145;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i146;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i147;
export 'by_index_enum_with_name_value.dart';
export 'by_name_enum_with_name_value.dart';
export 'changed_id_type/many_to_many/course.dart';
export 'changed_id_type/many_to_many/enrollment.dart';
export 'changed_id_type/many_to_many/student.dart';
export 'changed_id_type/nested_one_to_many/arena.dart';
export 'changed_id_type/nested_one_to_many/player.dart';
export 'changed_id_type/nested_one_to_many/team.dart';
export 'changed_id_type/one_to_many/comment.dart';
export 'changed_id_type/one_to_many/customer.dart';
export 'changed_id_type/one_to_many/order.dart';
export 'changed_id_type/one_to_one/address.dart';
export 'changed_id_type/one_to_one/citizen.dart';
export 'changed_id_type/one_to_one/company.dart';
export 'changed_id_type/one_to_one/town.dart';
export 'changed_id_type/self.dart';
export 'defaults/bigint/bigint_default.dart';
export 'defaults/bigint/bigint_default_mix.dart';
export 'defaults/bigint/bigint_default_model.dart';
export 'defaults/bigint/bigint_default_persist.dart';
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
export 'defaults/uri/uri_default.dart';
export 'defaults/uri/uri_default_mix.dart';
export 'defaults/uri/uri_default_model.dart';
export 'defaults/uri/uri_default_persist.dart';
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
export 'types_set.dart';
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
    if (t == _i4.CourseUuid) {
      return _i4.CourseUuid.fromJson(data) as T;
    }
    if (t == _i5.EnrollmentInt) {
      return _i5.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i6.StudentUuid) {
      return _i6.StudentUuid.fromJson(data) as T;
    }
    if (t == _i7.ArenaUuid) {
      return _i7.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i8.PlayerUuid) {
      return _i8.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i9.TeamInt) {
      return _i9.TeamInt.fromJson(data) as T;
    }
    if (t == _i10.CommentInt) {
      return _i10.CommentInt.fromJson(data) as T;
    }
    if (t == _i11.CustomerInt) {
      return _i11.CustomerInt.fromJson(data) as T;
    }
    if (t == _i12.OrderUuid) {
      return _i12.OrderUuid.fromJson(data) as T;
    }
    if (t == _i13.AddressUuid) {
      return _i13.AddressUuid.fromJson(data) as T;
    }
    if (t == _i14.CitizenInt) {
      return _i14.CitizenInt.fromJson(data) as T;
    }
    if (t == _i15.CompanyUuid) {
      return _i15.CompanyUuid.fromJson(data) as T;
    }
    if (t == _i16.TownInt) {
      return _i16.TownInt.fromJson(data) as T;
    }
    if (t == _i17.ChangedIdTypeSelf) {
      return _i17.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _i18.BigIntDefault) {
      return _i18.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i19.BigIntDefaultMix) {
      return _i19.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i20.BigIntDefaultModel) {
      return _i20.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i21.BigIntDefaultPersist) {
      return _i21.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i22.BoolDefault) {
      return _i22.BoolDefault.fromJson(data) as T;
    }
    if (t == _i23.BoolDefaultMix) {
      return _i23.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i24.BoolDefaultModel) {
      return _i24.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i25.BoolDefaultPersist) {
      return _i25.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i26.DateTimeDefault) {
      return _i26.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i27.DateTimeDefaultMix) {
      return _i27.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i28.DateTimeDefaultModel) {
      return _i28.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i29.DateTimeDefaultPersist) {
      return _i29.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i30.DoubleDefault) {
      return _i30.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i31.DoubleDefaultMix) {
      return _i31.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i32.DoubleDefaultModel) {
      return _i32.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i33.DoubleDefaultPersist) {
      return _i33.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i34.DurationDefault) {
      return _i34.DurationDefault.fromJson(data) as T;
    }
    if (t == _i35.DurationDefaultMix) {
      return _i35.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i36.DurationDefaultModel) {
      return _i36.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i37.DurationDefaultPersist) {
      return _i37.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i38.EnumDefault) {
      return _i38.EnumDefault.fromJson(data) as T;
    }
    if (t == _i39.EnumDefaultMix) {
      return _i39.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i40.EnumDefaultModel) {
      return _i40.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i41.EnumDefaultPersist) {
      return _i41.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i42.ByIndexEnum) {
      return _i42.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i43.ByNameEnum) {
      return _i43.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i44.DefaultException) {
      return _i44.DefaultException.fromJson(data) as T;
    }
    if (t == _i45.IntDefault) {
      return _i45.IntDefault.fromJson(data) as T;
    }
    if (t == _i46.IntDefaultMix) {
      return _i46.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i47.IntDefaultModel) {
      return _i47.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i48.IntDefaultPersist) {
      return _i48.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i49.StringDefault) {
      return _i49.StringDefault.fromJson(data) as T;
    }
    if (t == _i50.StringDefaultMix) {
      return _i50.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i51.StringDefaultModel) {
      return _i51.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i52.StringDefaultPersist) {
      return _i52.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i53.UriDefault) {
      return _i53.UriDefault.fromJson(data) as T;
    }
    if (t == _i54.UriDefaultMix) {
      return _i54.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i55.UriDefaultModel) {
      return _i55.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i56.UriDefaultPersist) {
      return _i56.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i57.UuidDefault) {
      return _i57.UuidDefault.fromJson(data) as T;
    }
    if (t == _i58.UuidDefaultMix) {
      return _i58.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i59.UuidDefaultModel) {
      return _i59.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i60.UuidDefaultPersist) {
      return _i60.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i61.EmptyModel) {
      return _i61.EmptyModel.fromJson(data) as T;
    }
    if (t == _i62.EmptyModelRelationItem) {
      return _i62.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i63.EmptyModelWithTable) {
      return _i63.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i64.RelationEmptyModel) {
      return _i64.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i65.ExceptionWithData) {
      return _i65.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i66.ChildClass) {
      return _i66.ChildClass.fromJson(data) as T;
    }
    if (t == _i67.ChildWithDefault) {
      return _i67.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i68.GrandparentClass) {
      return _i68.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i69.ParentClass) {
      return _i69.ParentClass.fromJson(data) as T;
    }
    if (t == _i70.ParentWithDefault) {
      return _i70.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i71.SealedChild) {
      return _i71.SealedChild.fromJson(data) as T;
    }
    if (t == _i71.SealedGrandChild) {
      return _i71.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i71.SealedOtherChild) {
      return _i71.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i72.CityWithLongTableName) {
      return _i72.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i73.OrganizationWithLongTableName) {
      return _i73.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i74.PersonWithLongTableName) {
      return _i74.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i75.MaxFieldName) {
      return _i75.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i76.LongImplicitIdField) {
      return _i76.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i77.LongImplicitIdFieldCollection) {
      return _i77.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i78.RelationToMultipleMaxFieldName) {
      return _i78.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i79.UserNote) {
      return _i79.UserNote.fromJson(data) as T;
    }
    if (t == _i80.UserNoteCollection) {
      return _i80.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i81.UserNoteCollectionWithALongName) {
      return _i81.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i82.UserNoteWithALongName) {
      return _i82.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i83.MultipleMaxFieldName) {
      return _i83.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i84.City) {
      return _i84.City.fromJson(data) as T;
    }
    if (t == _i85.Organization) {
      return _i85.Organization.fromJson(data) as T;
    }
    if (t == _i86.Person) {
      return _i86.Person.fromJson(data) as T;
    }
    if (t == _i87.Course) {
      return _i87.Course.fromJson(data) as T;
    }
    if (t == _i88.Enrollment) {
      return _i88.Enrollment.fromJson(data) as T;
    }
    if (t == _i89.Student) {
      return _i89.Student.fromJson(data) as T;
    }
    if (t == _i90.ObjectUser) {
      return _i90.ObjectUser.fromJson(data) as T;
    }
    if (t == _i91.ParentUser) {
      return _i91.ParentUser.fromJson(data) as T;
    }
    if (t == _i92.Arena) {
      return _i92.Arena.fromJson(data) as T;
    }
    if (t == _i93.Player) {
      return _i93.Player.fromJson(data) as T;
    }
    if (t == _i94.Team) {
      return _i94.Team.fromJson(data) as T;
    }
    if (t == _i95.Comment) {
      return _i95.Comment.fromJson(data) as T;
    }
    if (t == _i96.Customer) {
      return _i96.Customer.fromJson(data) as T;
    }
    if (t == _i97.Order) {
      return _i97.Order.fromJson(data) as T;
    }
    if (t == _i98.Address) {
      return _i98.Address.fromJson(data) as T;
    }
    if (t == _i99.Citizen) {
      return _i99.Citizen.fromJson(data) as T;
    }
    if (t == _i100.Company) {
      return _i100.Company.fromJson(data) as T;
    }
    if (t == _i101.Town) {
      return _i101.Town.fromJson(data) as T;
    }
    if (t == _i102.Blocking) {
      return _i102.Blocking.fromJson(data) as T;
    }
    if (t == _i103.Member) {
      return _i103.Member.fromJson(data) as T;
    }
    if (t == _i104.Cat) {
      return _i104.Cat.fromJson(data) as T;
    }
    if (t == _i105.Post) {
      return _i105.Post.fromJson(data) as T;
    }
    if (t == _i106.ModuleDatatype) {
      return _i106.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i107.Nullability) {
      return _i107.Nullability.fromJson(data) as T;
    }
    if (t == _i108.ObjectFieldPersist) {
      return _i108.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i109.ObjectFieldScopes) {
      return _i109.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i110.ObjectWithByteData) {
      return _i110.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i111.ObjectWithCustomClass) {
      return _i111.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i112.ObjectWithDuration) {
      return _i112.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i113.ObjectWithEnum) {
      return _i113.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i114.ObjectWithIndex) {
      return _i114.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i115.ObjectWithMaps) {
      return _i115.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithObject) {
      return _i116.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithParent) {
      return _i117.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithSelfParent) {
      return _i118.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithUuid) {
      return _i119.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i120.RelatedUniqueData) {
      return _i120.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i121.ScopeNoneFields) {
      return _i121.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i122.ScopeServerOnlyField) {
      return _i122.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i123.ScopeServerOnlyFieldChild) {
      return _i123.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i124.DefaultServerOnlyClass) {
      return _i124.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i125.DefaultServerOnlyEnum) {
      return _i125.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i126.NotServerOnlyClass) {
      return _i126.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i127.NotServerOnlyEnum) {
      return _i127.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i128.ServerOnlyClassField) {
      return _i128.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i129.SimpleData) {
      return _i129.SimpleData.fromJson(data) as T;
    }
    if (t == _i130.SimpleDataList) {
      return _i130.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i131.SimpleDataMap) {
      return _i131.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i132.SimpleDataObject) {
      return _i132.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i133.SimpleDateTime) {
      return _i133.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i134.TestEnum) {
      return _i134.TestEnum.fromJson(data) as T;
    }
    if (t == _i135.TestEnumStringified) {
      return _i135.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i136.Types) {
      return _i136.Types.fromJson(data) as T;
    }
    if (t == _i137.TypesList) {
      return _i137.TypesList.fromJson(data) as T;
    }
    if (t == _i138.TypesMap) {
      return _i138.TypesMap.fromJson(data) as T;
    }
    if (t == _i139.TypesSet) {
      return _i139.TypesSet.fromJson(data) as T;
    }
    if (t == _i140.UniqueData) {
      return _i140.UniqueData.fromJson(data) as T;
    }
    if (t == _i141.MyFeatureModel) {
      return _i141.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i1.getType<_i2.ByIndexEnumWithNameValue?>()) {
      return (data != null ? _i2.ByIndexEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i3.ByNameEnumWithNameValue?>()) {
      return (data != null ? _i3.ByNameEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i4.CourseUuid?>()) {
      return (data != null ? _i4.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.EnrollmentInt?>()) {
      return (data != null ? _i5.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.StudentUuid?>()) {
      return (data != null ? _i6.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ArenaUuid?>()) {
      return (data != null ? _i7.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.PlayerUuid?>()) {
      return (data != null ? _i8.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.TeamInt?>()) {
      return (data != null ? _i9.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CommentInt?>()) {
      return (data != null ? _i10.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CustomerInt?>()) {
      return (data != null ? _i11.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.OrderUuid?>()) {
      return (data != null ? _i12.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.AddressUuid?>()) {
      return (data != null ? _i13.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CitizenInt?>()) {
      return (data != null ? _i14.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CompanyUuid?>()) {
      return (data != null ? _i15.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.TownInt?>()) {
      return (data != null ? _i16.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ChangedIdTypeSelf?>()) {
      return (data != null ? _i17.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.BigIntDefault?>()) {
      return (data != null ? _i18.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.BigIntDefaultMix?>()) {
      return (data != null ? _i19.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.BigIntDefaultModel?>()) {
      return (data != null ? _i20.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i21.BigIntDefaultPersist?>()) {
      return (data != null ? _i21.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.BoolDefault?>()) {
      return (data != null ? _i22.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.BoolDefaultMix?>()) {
      return (data != null ? _i23.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BoolDefaultModel?>()) {
      return (data != null ? _i24.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BoolDefaultPersist?>()) {
      return (data != null ? _i25.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.DateTimeDefault?>()) {
      return (data != null ? _i26.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.DateTimeDefaultMix?>()) {
      return (data != null ? _i27.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.DateTimeDefaultModel?>()) {
      return (data != null ? _i28.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.DateTimeDefaultPersist?>()) {
      return (data != null ? _i29.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.DoubleDefault?>()) {
      return (data != null ? _i30.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.DoubleDefaultMix?>()) {
      return (data != null ? _i31.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.DoubleDefaultModel?>()) {
      return (data != null ? _i32.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.DoubleDefaultPersist?>()) {
      return (data != null ? _i33.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.DurationDefault?>()) {
      return (data != null ? _i34.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.DurationDefaultMix?>()) {
      return (data != null ? _i35.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.DurationDefaultModel?>()) {
      return (data != null ? _i36.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.DurationDefaultPersist?>()) {
      return (data != null ? _i37.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.EnumDefault?>()) {
      return (data != null ? _i38.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.EnumDefaultMix?>()) {
      return (data != null ? _i39.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.EnumDefaultModel?>()) {
      return (data != null ? _i40.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.EnumDefaultPersist?>()) {
      return (data != null ? _i41.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.ByIndexEnum?>()) {
      return (data != null ? _i42.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ByNameEnum?>()) {
      return (data != null ? _i43.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.DefaultException?>()) {
      return (data != null ? _i44.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.IntDefault?>()) {
      return (data != null ? _i45.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.IntDefaultMix?>()) {
      return (data != null ? _i46.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.IntDefaultModel?>()) {
      return (data != null ? _i47.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.IntDefaultPersist?>()) {
      return (data != null ? _i48.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.StringDefault?>()) {
      return (data != null ? _i49.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.StringDefaultMix?>()) {
      return (data != null ? _i50.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.StringDefaultModel?>()) {
      return (data != null ? _i51.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i52.StringDefaultPersist?>()) {
      return (data != null ? _i52.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i53.UriDefault?>()) {
      return (data != null ? _i53.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.UriDefaultMix?>()) {
      return (data != null ? _i54.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.UriDefaultModel?>()) {
      return (data != null ? _i55.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.UriDefaultPersist?>()) {
      return (data != null ? _i56.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.UuidDefault?>()) {
      return (data != null ? _i57.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.UuidDefaultMix?>()) {
      return (data != null ? _i58.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.UuidDefaultModel?>()) {
      return (data != null ? _i59.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.UuidDefaultPersist?>()) {
      return (data != null ? _i60.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i61.EmptyModel?>()) {
      return (data != null ? _i61.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.EmptyModelRelationItem?>()) {
      return (data != null ? _i62.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.EmptyModelWithTable?>()) {
      return (data != null ? _i63.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.RelationEmptyModel?>()) {
      return (data != null ? _i64.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.ExceptionWithData?>()) {
      return (data != null ? _i65.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.ChildClass?>()) {
      return (data != null ? _i66.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.ChildWithDefault?>()) {
      return (data != null ? _i67.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.GrandparentClass?>()) {
      return (data != null ? _i68.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i69.ParentClass?>()) {
      return (data != null ? _i69.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.ParentWithDefault?>()) {
      return (data != null ? _i70.ParentWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.SealedChild?>()) {
      return (data != null ? _i71.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.SealedGrandChild?>()) {
      return (data != null ? _i71.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.SealedOtherChild?>()) {
      return (data != null ? _i71.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.CityWithLongTableName?>()) {
      return (data != null ? _i72.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i73.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i74.PersonWithLongTableName?>()) {
      return (data != null ? _i74.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i75.MaxFieldName?>()) {
      return (data != null ? _i75.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.LongImplicitIdField?>()) {
      return (data != null ? _i76.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i77.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i78.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i78.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i79.UserNote?>()) {
      return (data != null ? _i79.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.UserNoteCollection?>()) {
      return (data != null ? _i80.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i81.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i82.UserNoteWithALongName?>()) {
      return (data != null ? _i82.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i83.MultipleMaxFieldName?>()) {
      return (data != null ? _i83.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.City?>()) {
      return (data != null ? _i84.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.Organization?>()) {
      return (data != null ? _i85.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.Person?>()) {
      return (data != null ? _i86.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.Course?>()) {
      return (data != null ? _i87.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.Enrollment?>()) {
      return (data != null ? _i88.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.Student?>()) {
      return (data != null ? _i89.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.ObjectUser?>()) {
      return (data != null ? _i90.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.ParentUser?>()) {
      return (data != null ? _i91.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.Arena?>()) {
      return (data != null ? _i92.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.Player?>()) {
      return (data != null ? _i93.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.Team?>()) {
      return (data != null ? _i94.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.Comment?>()) {
      return (data != null ? _i95.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.Customer?>()) {
      return (data != null ? _i96.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.Order?>()) {
      return (data != null ? _i97.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.Address?>()) {
      return (data != null ? _i98.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.Citizen?>()) {
      return (data != null ? _i99.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Company?>()) {
      return (data != null ? _i100.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.Town?>()) {
      return (data != null ? _i101.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.Blocking?>()) {
      return (data != null ? _i102.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.Member?>()) {
      return (data != null ? _i103.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.Cat?>()) {
      return (data != null ? _i104.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.Post?>()) {
      return (data != null ? _i105.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i106.ModuleDatatype?>()) {
      return (data != null ? _i106.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i107.Nullability?>()) {
      return (data != null ? _i107.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.ObjectFieldPersist?>()) {
      return (data != null ? _i108.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i109.ObjectFieldScopes?>()) {
      return (data != null ? _i109.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i110.ObjectWithByteData?>()) {
      return (data != null ? _i110.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i111.ObjectWithCustomClass?>()) {
      return (data != null ? _i111.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i112.ObjectWithDuration?>()) {
      return (data != null ? _i112.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i113.ObjectWithEnum?>()) {
      return (data != null ? _i113.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.ObjectWithIndex?>()) {
      return (data != null ? _i114.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.ObjectWithMaps?>()) {
      return (data != null ? _i115.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i116.ObjectWithObject?>()) {
      return (data != null ? _i116.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.ObjectWithParent?>()) {
      return (data != null ? _i117.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i118.ObjectWithSelfParent?>()) {
      return (data != null ? _i118.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i119.ObjectWithUuid?>()) {
      return (data != null ? _i119.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i120.RelatedUniqueData?>()) {
      return (data != null ? _i120.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i121.ScopeNoneFields?>()) {
      return (data != null ? _i121.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i122.ScopeServerOnlyField?>()) {
      return (data != null ? _i122.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i123.ScopeServerOnlyFieldChild?>()) {
      return (data != null
          ? _i123.ScopeServerOnlyFieldChild.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i124.DefaultServerOnlyClass?>()) {
      return (data != null ? _i124.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i125.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i125.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i126.NotServerOnlyClass?>()) {
      return (data != null ? _i126.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i127.NotServerOnlyEnum?>()) {
      return (data != null ? _i127.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i128.ServerOnlyClassField?>()) {
      return (data != null ? _i128.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i129.SimpleData?>()) {
      return (data != null ? _i129.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i130.SimpleDataList?>()) {
      return (data != null ? _i130.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.SimpleDataMap?>()) {
      return (data != null ? _i131.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i132.SimpleDataObject?>()) {
      return (data != null ? _i132.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i133.SimpleDateTime?>()) {
      return (data != null ? _i133.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i134.TestEnum?>()) {
      return (data != null ? _i134.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.TestEnumStringified?>()) {
      return (data != null ? _i135.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i136.Types?>()) {
      return (data != null ? _i136.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i137.TypesList?>()) {
      return (data != null ? _i137.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i138.TypesMap?>()) {
      return (data != null ? _i138.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i139.TypesSet?>()) {
      return (data != null ? _i139.TypesSet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i140.UniqueData?>()) {
      return (data != null ? _i140.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i141.MyFeatureModel?>()) {
      return (data != null ? _i141.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i5.EnrollmentInt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i5.EnrollmentInt>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i5.EnrollmentInt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i5.EnrollmentInt>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i8.PlayerUuid>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i8.PlayerUuid>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i12.OrderUuid>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i12.OrderUuid>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i10.CommentInt>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i10.CommentInt>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i17.ChangedIdTypeSelf>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i17.ChangedIdTypeSelf>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i62.EmptyModelRelationItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i62.EmptyModelRelationItem>(e))
              .toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i74.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.PersonWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i73.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.OrganizationWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i74.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i74.PersonWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i76.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i76.LongImplicitIdField>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i83.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i83.MultipleMaxFieldName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i79.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i79.UserNote>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i82.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i82.UserNoteWithALongName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i86.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i86.Person>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i85.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i85.Organization>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i86.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i86.Person>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i88.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i88.Enrollment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i88.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i88.Enrollment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i93.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i93.Player>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i97.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i97.Order>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i95.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i95.Comment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i102.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i102.Blocking>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i102.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i102.Blocking>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i104.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i104.Cat>(e)).toList()
          : null) as T;
    }
    if (t == List<_i142.ModuleClass>) {
      return (data as List)
          .map((e) => deserialize<_i142.ModuleClass>(e))
          .toList() as T;
    }
    if (t == Map<String, _i142.ModuleClass>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i142.ModuleClass>(v))) as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as T;
    }
    if (t == List<_i129.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i129.SimpleData>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i129.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i129.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == List<_i129.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i129.SimpleData?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i129.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i129.SimpleData?>(e))
              .toList()
          : null) as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as T;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          : null) as T;
    }
    if (t == List<_i143.ByteData>) {
      return (data as List).map((e) => deserialize<_i143.ByteData>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i143.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i143.ByteData>(e)).toList()
          : null) as T;
    }
    if (t == List<_i143.ByteData?>) {
      return (data as List).map((e) => deserialize<_i143.ByteData?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i143.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i143.ByteData?>(e)).toList()
          : null) as T;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList() as T;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as T;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<Duration?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
          : null) as T;
    }
    if (t == List<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as T;
    }
    if (t == List<_i1.UuidValue?>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i1.UuidValue?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          : null) as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
          (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v))) as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as T;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as T;
    }
    if (t == _i144.CustomClassWithoutProtocolSerialization) {
      return _i144.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i144.CustomClassWithProtocolSerialization) {
      return _i144.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i144.CustomClassWithProtocolSerializationMethod) {
      return _i144.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i134.TestEnum>) {
      return (data as List).map((e) => deserialize<_i134.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i134.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i134.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i134.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i134.TestEnum>>(e))
          .toList() as T;
    }
    if (t == Map<String, _i129.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i129.SimpleData>(v))) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime>(v))) as T;
    }
    if (t == Map<String, _i143.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i143.ByteData>(v)))
          as T;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<Duration>(v))) as T;
    }
    if (t == Map<String, _i1.UuidValue>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v))) as T;
    }
    if (t == Map<String, _i129.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i129.SimpleData?>(v))) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime?>(v))) as T;
    }
    if (t == Map<String, _i143.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i143.ByteData?>(v)))
          as T;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<Duration?>(v))) as T;
    }
    if (t == Map<String, _i1.UuidValue?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue?>(v)))
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == _i1.getType<List<_i129.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i129.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i129.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i129.SimpleData?>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<List<_i129.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i129.SimpleData>>(e))
              .toList()
          : null) as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i129.SimpleData>>?>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<List<List<Map<int, _i129.SimpleData>>?>>(v)))
          : null) as T;
    }
    if (t == List<List<Map<int, _i129.SimpleData>>?>) {
      return (data as List)
          .map((e) => deserialize<List<Map<int, _i129.SimpleData>>?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<Map<int, _i129.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<int, _i129.SimpleData>>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<int, _i129.SimpleData>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<int>(e['k']), deserialize<_i129.SimpleData>(e['v']))))
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i129.SimpleData>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<Map<int, _i129.SimpleData>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<Map<int, int>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<bool>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<bool>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<double>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<double>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i143.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i143.ByteData>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<Uri>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Uri>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<BigInt>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<BigInt>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i134.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i134.TestEnum>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i135.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i135.TestEnumStringified>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i136.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i136.Types>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<Map<String, _i136.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i136.Types>>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<String, _i136.Types>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<_i136.Types>(v))) as T;
    }
    if (t == _i1.getType<List<List<_i136.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i136.Types>>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i136.Types>) {
      return (data as List).map((e) => deserialize<_i136.Types>(e)).toList()
          as T;
    }
    if (t == _i1.getType<Map<int, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<int>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<bool, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<bool>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<double, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<double>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<DateTime, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<DateTime>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i143.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i143.ByteData>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<Duration, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Duration>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i1.UuidValue, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i1.UuidValue>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<Uri, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) =>
              MapEntry(deserialize<Uri>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<BigInt, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<BigInt>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i134.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i134.TestEnum>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i135.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i135.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i136.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i136.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<Map<_i136.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i136.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == Map<_i136.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i136.Types>(e['k']), deserialize<String>(e['v'])))) as T;
    }
    if (t == _i1.getType<Map<List<_i136.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i136.Types>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, bool>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, double>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<double>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, DateTime>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<DateTime>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<String>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i143.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i143.ByteData>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, Duration>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<Duration>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i1.UuidValue>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, Uri>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<Uri>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, BigInt>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<BigInt>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i134.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i134.TestEnum>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i135.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<_i135.TestEnumStringified>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i136.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i136.Types>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, Map<String, _i136.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i136.Types>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, List<_i136.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i136.Types>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<bool>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<bool>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<double>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<double>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<DateTime>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<DateTime>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i143.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i143.ByteData>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<Duration>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Duration>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i1.UuidValue>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<BigInt>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<BigInt>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i134.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i134.TestEnum>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i135.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i135.TestEnumStringified>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i136.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i136.Types>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<Map<String, _i136.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i136.Types>>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<List<_i136.Types>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<_i136.Types>>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i145.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i145.SimpleData>(e))
          .toList() as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
          : null) as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toList()
          : null) as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList() as T;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList() as T;
    }
    if (t == List<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toList() as T;
    }
    if (t == List<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toList() as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList() as T;
    }
    if (t == List<_i143.ByteData>) {
      return (data as List).map((e) => deserialize<_i143.ByteData>(e)).toList()
          as T;
    }
    if (t == List<_i143.ByteData?>) {
      return (data as List).map((e) => deserialize<_i143.ByteData?>(e)).toList()
          as T;
    }
    if (t == List<_i145.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i145.SimpleData?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i145.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i145.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i145.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i145.SimpleData?>(e))
              .toList()
          : null) as T;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList() as T;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
          (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v))) as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as T;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<Map<String, int>>(v))) as T;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          as T;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries((data as List).map((e) =>
          MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == Map<_i146.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i146.TestEnum>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == Map<String, _i146.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i146.TestEnum>(v)))
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double>(v))) as T;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<double?>(v))) as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)))
          as T;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<bool?>(v)))
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime>(v))) as T;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime?>(v))) as T;
    }
    if (t == Map<String, _i143.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i143.ByteData>(v)))
          as T;
    }
    if (t == Map<String, _i143.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i143.ByteData?>(v)))
          as T;
    }
    if (t == Map<String, _i145.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i145.SimpleData>(v))) as T;
    }
    if (t == Map<String, _i145.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i145.SimpleData?>(v))) as T;
    }
    if (t == _i1.getType<Map<String, _i145.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i145.SimpleData>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i145.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i145.SimpleData?>(v)))
          : null) as T;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<Duration>(v))) as T;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<Duration?>(v))) as T;
    }
    if (t == List<_i147.UserInfo>) {
      return (data as List).map((e) => deserialize<_i147.UserInfo>(e)).toList()
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == Set<_i145.SimpleData>) {
      return (data as List).map((e) => deserialize<_i145.SimpleData>(e)).toSet()
          as T;
    }
    if (t == List<Set<_i145.SimpleData>>) {
      return (data as List)
          .map((e) => deserialize<Set<_i145.SimpleData>>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int?,)>()) {
      return (
        ((data as Map)['p'] as List)[0] == null
            ? null
            : deserialize<int>(data['p'][0]),
      ) as T;
    }
    if (t == _i1.getType<(int?,)?>()) {
      return (data == null)
          ? null as T
          : (
              ((data as Map)['p'] as List)[0] == null
                  ? null
                  : deserialize<int>(data['p'][0]),
            ) as T;
    }
    if (t == _i1.getType<(int, String)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<String>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, String)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<String>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i145.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<({int number, String text})>()) {
      return (
        number: deserialize<int>(((data as Map)['n'] as Map)['number']),
        text: deserialize<String>(data['n']['text']),
      ) as T;
    }
    if (t == _i1.getType<({int number, String text})?>()) {
      return (data == null)
          ? null as T
          : (
              number: deserialize<int>(((data as Map)['n'] as Map)['number']),
              text: deserialize<String>(data['n']['text']),
            ) as T;
    }
    if (t == _i1.getType<({_i145.SimpleData data, int number})>()) {
      return (
        data:
            deserialize<_i145.SimpleData>(((data as Map)['n'] as Map)['data']),
        number: deserialize<int>(data['n']['number']),
      ) as T;
    }
    if (t == _i1.getType<({_i145.SimpleData data, int number})?>()) {
      return (data == null)
          ? null as T
          : (
              data: deserialize<_i145.SimpleData>(
                  ((data as Map)['n'] as Map)['data']),
              number: deserialize<int>(data['n']['number']),
            ) as T;
    }
    if (t == _i1.getType<({_i145.SimpleData? data, int? number})>()) {
      return (
        data: ((data as Map)['n'] as Map)['data'] == null
            ? null
            : deserialize<_i145.SimpleData>(data['n']['data']),
        number: ((data)['n'] as Map)['number'] == null
            ? null
            : deserialize<int>(data['n']['number']),
      ) as T;
    }
    if (t == _i1.getType<(int, {_i145.SimpleData data})>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        data: deserialize<_i145.SimpleData>(data['n']['data']),
      ) as T;
    }
    if (t == _i1.getType<(int, {_i145.SimpleData data})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              data: deserialize<_i145.SimpleData>(data['n']['data']),
            ) as T;
    }
    if (t == List<(int, _i145.SimpleData)>) {
      return (data as List)
          .map((e) => deserialize<(int, _i145.SimpleData)>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == List<(int, _i145.SimpleData)?>) {
      return (data as List)
          .map((e) => deserialize<(int, _i145.SimpleData)?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i145.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == Set<(int, _i145.SimpleData)>) {
      return (data as List)
          .map((e) => deserialize<(int, _i145.SimpleData)>(e))
          .toSet() as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Set<(int, _i145.SimpleData)?>) {
      return (data as List)
          .map((e) => deserialize<(int, _i145.SimpleData)?>(e))
          .toSet() as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i145.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<Set<(int, _i145.SimpleData)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(int, _i145.SimpleData)>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Map<String, (int, _i145.SimpleData)>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<(int, _i145.SimpleData)>(v)))
          as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Map<String, (int, _i145.SimpleData)?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<(int, _i145.SimpleData)?>(v)))
          as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i145.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == Map<(String, int), (int, _i145.SimpleData)>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<(String, int)>(e['k']),
          deserialize<(int, _i145.SimpleData)>(e['v'])))) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, _i145.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i145.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t == Map<String, List<Set<(int,)>>>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<List<Set<(int,)>>>(v))) as T;
    }
    if (t == List<Set<(int,)>>) {
      return (data as List).map((e) => deserialize<Set<(int,)>>(e)).toList()
          as T;
    }
    if (t == Set<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toSet() as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<List<Map<String, (int,)>>>) {
      return (data as List)
          .map((e) => deserialize<List<Map<String, (int,)>>>(e))
          .toSet() as T;
    }
    if (t == List<Map<String, (int,)>>) {
      return (data as List)
          .map((e) => deserialize<Map<String, (int,)>>(e))
          .toList() as T;
    }
    if (t == Map<String, (int,)>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<(int,)>(v))) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<({(_i145.SimpleData, double) namedSubRecord})>()) {
      return (
        namedSubRecord: deserialize<(_i145.SimpleData, double)>(
            ((data as Map)['n'] as Map)['namedSubRecord']),
      ) as T;
    }
    if (t == _i1.getType<(_i145.SimpleData, double)>()) {
      return (
        deserialize<_i145.SimpleData>(((data as Map)['p'] as List)[0]),
        deserialize<double>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<({(_i145.SimpleData, double)? namedSubRecord})>()) {
      return (
        namedSubRecord: ((data as Map)['n'] as Map)['namedSubRecord'] == null
            ? null
            : deserialize<(_i145.SimpleData, double)>(
                data['n']['namedSubRecord']),
      ) as T;
    }
    if (t == _i1.getType<(_i145.SimpleData, double)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i145.SimpleData>(((data as Map)['p'] as List)[0]),
              deserialize<double>(data['p'][1]),
            ) as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i145.SimpleData, double) namedSubRecord})>()) {
      return (
        deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
        namedSubRecord: deserialize<(_i145.SimpleData, double)>(
            data['n']['namedSubRecord']),
      ) as T;
    }
    if (t ==
        List<((int, String), {(_i145.SimpleData, double) namedSubRecord})>) {
      return (data as List)
          .map((e) => deserialize<
              ((int, String), {(_i145.SimpleData, double) namedSubRecord})>(e))
          .toList() as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i145.SimpleData, double) namedSubRecord})>()) {
      return (
        deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
        namedSubRecord: deserialize<(_i145.SimpleData, double)>(
            data['n']['namedSubRecord']),
      ) as T;
    }
    if (t == Set<Set<int>>) {
      return (data as List).map((e) => deserialize<Set<int>>(e)).toSet() as T;
    }
    if (t == Set<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toSet()
          : null) as T;
    }
    if (t == Set<Set<int>?>) {
      return (data as List).map((e) => deserialize<Set<int>?>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<Set<int>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<Set<int>>(e)).toSet()
          : null) as T;
    }
    if (t == Set<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<int?>(e)).toSet()
          : null) as T;
    }
    if (t == Set<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toSet() as T;
    }
    if (t == Set<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toSet() as T;
    }
    if (t == Set<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toSet() as T;
    }
    if (t == Set<bool?>) {
      return (data as List).map((e) => deserialize<bool?>(e)).toSet() as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == Set<String?>) {
      return (data as List).map((e) => deserialize<String?>(e)).toSet() as T;
    }
    if (t == Set<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toSet() as T;
    }
    if (t == Set<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toSet() as T;
    }
    if (t == Set<_i143.ByteData>) {
      return (data as List).map((e) => deserialize<_i143.ByteData>(e)).toSet()
          as T;
    }
    if (t == Set<_i143.ByteData?>) {
      return (data as List).map((e) => deserialize<_i143.ByteData?>(e)).toSet()
          as T;
    }
    if (t == Set<_i145.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i145.SimpleData?>(e))
          .toSet() as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == Set<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toSet() as T;
    }
    if (t == _i1.getType<(String, (int, bool))>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<(int, bool)>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, bool)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<bool>(data['p'][1]),
      ) as T;
    }
    if (t == List<(String, (int, bool))>) {
      return (data as List)
          .map((e) => deserialize<(String, (int, bool))>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(String, (int, bool))>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<(int, bool)>(data['p'][1]),
      ) as T;
    }
    if (t == _i144.CustomClass) {
      return _i144.CustomClass.fromJson(data) as T;
    }
    if (t == _i144.CustomClass2) {
      return _i144.CustomClass2.fromJson(data) as T;
    }
    if (t == _i144.ProtocolCustomClass) {
      return _i144.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i144.ExternalCustomClass) {
      return _i144.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i144.FreezedCustomClass) {
      return _i144.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i144.CustomClass?>()) {
      return (data != null ? _i144.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i144.CustomClass2?>()) {
      return (data != null ? _i144.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i144.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
          ? _i144.CustomClassWithoutProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i144.CustomClassWithProtocolSerialization?>()) {
      return (data != null
          ? _i144.CustomClassWithProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i144.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
          ? _i144.CustomClassWithProtocolSerializationMethod.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i144.ProtocolCustomClass?>()) {
      return (data != null ? _i144.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i144.ExternalCustomClass?>()) {
      return (data != null ? _i144.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i144.FreezedCustomClass?>()) {
      return (data != null ? _i144.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i145.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i145.SimpleData>(e)).toList()
          : null) as T;
    }
    try {
      return _i147.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i142.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i144.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i144.CustomClass2) {
      return 'CustomClass2';
    }
    if (data is _i144.CustomClassWithoutProtocolSerialization) {
      return 'CustomClassWithoutProtocolSerialization';
    }
    if (data is _i144.CustomClassWithProtocolSerialization) {
      return 'CustomClassWithProtocolSerialization';
    }
    if (data is _i144.CustomClassWithProtocolSerializationMethod) {
      return 'CustomClassWithProtocolSerializationMethod';
    }
    if (data is _i144.ProtocolCustomClass) {
      return 'ProtocolCustomClass';
    }
    if (data is _i144.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i144.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i2.ByIndexEnumWithNameValue) {
      return 'ByIndexEnumWithNameValue';
    }
    if (data is _i3.ByNameEnumWithNameValue) {
      return 'ByNameEnumWithNameValue';
    }
    if (data is _i4.CourseUuid) {
      return 'CourseUuid';
    }
    if (data is _i5.EnrollmentInt) {
      return 'EnrollmentInt';
    }
    if (data is _i6.StudentUuid) {
      return 'StudentUuid';
    }
    if (data is _i7.ArenaUuid) {
      return 'ArenaUuid';
    }
    if (data is _i8.PlayerUuid) {
      return 'PlayerUuid';
    }
    if (data is _i9.TeamInt) {
      return 'TeamInt';
    }
    if (data is _i10.CommentInt) {
      return 'CommentInt';
    }
    if (data is _i11.CustomerInt) {
      return 'CustomerInt';
    }
    if (data is _i12.OrderUuid) {
      return 'OrderUuid';
    }
    if (data is _i13.AddressUuid) {
      return 'AddressUuid';
    }
    if (data is _i14.CitizenInt) {
      return 'CitizenInt';
    }
    if (data is _i15.CompanyUuid) {
      return 'CompanyUuid';
    }
    if (data is _i16.TownInt) {
      return 'TownInt';
    }
    if (data is _i17.ChangedIdTypeSelf) {
      return 'ChangedIdTypeSelf';
    }
    if (data is _i18.BigIntDefault) {
      return 'BigIntDefault';
    }
    if (data is _i19.BigIntDefaultMix) {
      return 'BigIntDefaultMix';
    }
    if (data is _i20.BigIntDefaultModel) {
      return 'BigIntDefaultModel';
    }
    if (data is _i21.BigIntDefaultPersist) {
      return 'BigIntDefaultPersist';
    }
    if (data is _i22.BoolDefault) {
      return 'BoolDefault';
    }
    if (data is _i23.BoolDefaultMix) {
      return 'BoolDefaultMix';
    }
    if (data is _i24.BoolDefaultModel) {
      return 'BoolDefaultModel';
    }
    if (data is _i25.BoolDefaultPersist) {
      return 'BoolDefaultPersist';
    }
    if (data is _i26.DateTimeDefault) {
      return 'DateTimeDefault';
    }
    if (data is _i27.DateTimeDefaultMix) {
      return 'DateTimeDefaultMix';
    }
    if (data is _i28.DateTimeDefaultModel) {
      return 'DateTimeDefaultModel';
    }
    if (data is _i29.DateTimeDefaultPersist) {
      return 'DateTimeDefaultPersist';
    }
    if (data is _i30.DoubleDefault) {
      return 'DoubleDefault';
    }
    if (data is _i31.DoubleDefaultMix) {
      return 'DoubleDefaultMix';
    }
    if (data is _i32.DoubleDefaultModel) {
      return 'DoubleDefaultModel';
    }
    if (data is _i33.DoubleDefaultPersist) {
      return 'DoubleDefaultPersist';
    }
    if (data is _i34.DurationDefault) {
      return 'DurationDefault';
    }
    if (data is _i35.DurationDefaultMix) {
      return 'DurationDefaultMix';
    }
    if (data is _i36.DurationDefaultModel) {
      return 'DurationDefaultModel';
    }
    if (data is _i37.DurationDefaultPersist) {
      return 'DurationDefaultPersist';
    }
    if (data is _i38.EnumDefault) {
      return 'EnumDefault';
    }
    if (data is _i39.EnumDefaultMix) {
      return 'EnumDefaultMix';
    }
    if (data is _i40.EnumDefaultModel) {
      return 'EnumDefaultModel';
    }
    if (data is _i41.EnumDefaultPersist) {
      return 'EnumDefaultPersist';
    }
    if (data is _i42.ByIndexEnum) {
      return 'ByIndexEnum';
    }
    if (data is _i43.ByNameEnum) {
      return 'ByNameEnum';
    }
    if (data is _i44.DefaultException) {
      return 'DefaultException';
    }
    if (data is _i45.IntDefault) {
      return 'IntDefault';
    }
    if (data is _i46.IntDefaultMix) {
      return 'IntDefaultMix';
    }
    if (data is _i47.IntDefaultModel) {
      return 'IntDefaultModel';
    }
    if (data is _i48.IntDefaultPersist) {
      return 'IntDefaultPersist';
    }
    if (data is _i49.StringDefault) {
      return 'StringDefault';
    }
    if (data is _i50.StringDefaultMix) {
      return 'StringDefaultMix';
    }
    if (data is _i51.StringDefaultModel) {
      return 'StringDefaultModel';
    }
    if (data is _i52.StringDefaultPersist) {
      return 'StringDefaultPersist';
    }
    if (data is _i53.UriDefault) {
      return 'UriDefault';
    }
    if (data is _i54.UriDefaultMix) {
      return 'UriDefaultMix';
    }
    if (data is _i55.UriDefaultModel) {
      return 'UriDefaultModel';
    }
    if (data is _i56.UriDefaultPersist) {
      return 'UriDefaultPersist';
    }
    if (data is _i57.UuidDefault) {
      return 'UuidDefault';
    }
    if (data is _i58.UuidDefaultMix) {
      return 'UuidDefaultMix';
    }
    if (data is _i59.UuidDefaultModel) {
      return 'UuidDefaultModel';
    }
    if (data is _i60.UuidDefaultPersist) {
      return 'UuidDefaultPersist';
    }
    if (data is _i61.EmptyModel) {
      return 'EmptyModel';
    }
    if (data is _i62.EmptyModelRelationItem) {
      return 'EmptyModelRelationItem';
    }
    if (data is _i63.EmptyModelWithTable) {
      return 'EmptyModelWithTable';
    }
    if (data is _i64.RelationEmptyModel) {
      return 'RelationEmptyModel';
    }
    if (data is _i65.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i66.ChildClass) {
      return 'ChildClass';
    }
    if (data is _i67.ChildWithDefault) {
      return 'ChildWithDefault';
    }
    if (data is _i68.GrandparentClass) {
      return 'GrandparentClass';
    }
    if (data is _i69.ParentClass) {
      return 'ParentClass';
    }
    if (data is _i70.ParentWithDefault) {
      return 'ParentWithDefault';
    }
    if (data is _i71.SealedChild) {
      return 'SealedChild';
    }
    if (data is _i71.SealedGrandChild) {
      return 'SealedGrandChild';
    }
    if (data is _i71.SealedOtherChild) {
      return 'SealedOtherChild';
    }
    if (data is _i72.CityWithLongTableName) {
      return 'CityWithLongTableName';
    }
    if (data is _i73.OrganizationWithLongTableName) {
      return 'OrganizationWithLongTableName';
    }
    if (data is _i74.PersonWithLongTableName) {
      return 'PersonWithLongTableName';
    }
    if (data is _i75.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i76.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i77.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i78.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i79.UserNote) {
      return 'UserNote';
    }
    if (data is _i80.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i81.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i82.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i83.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i84.City) {
      return 'City';
    }
    if (data is _i85.Organization) {
      return 'Organization';
    }
    if (data is _i86.Person) {
      return 'Person';
    }
    if (data is _i87.Course) {
      return 'Course';
    }
    if (data is _i88.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i89.Student) {
      return 'Student';
    }
    if (data is _i90.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i91.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i92.Arena) {
      return 'Arena';
    }
    if (data is _i93.Player) {
      return 'Player';
    }
    if (data is _i94.Team) {
      return 'Team';
    }
    if (data is _i95.Comment) {
      return 'Comment';
    }
    if (data is _i96.Customer) {
      return 'Customer';
    }
    if (data is _i97.Order) {
      return 'Order';
    }
    if (data is _i98.Address) {
      return 'Address';
    }
    if (data is _i99.Citizen) {
      return 'Citizen';
    }
    if (data is _i100.Company) {
      return 'Company';
    }
    if (data is _i101.Town) {
      return 'Town';
    }
    if (data is _i102.Blocking) {
      return 'Blocking';
    }
    if (data is _i103.Member) {
      return 'Member';
    }
    if (data is _i104.Cat) {
      return 'Cat';
    }
    if (data is _i105.Post) {
      return 'Post';
    }
    if (data is _i106.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i107.Nullability) {
      return 'Nullability';
    }
    if (data is _i108.ObjectFieldPersist) {
      return 'ObjectFieldPersist';
    }
    if (data is _i109.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i110.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i111.ObjectWithCustomClass) {
      return 'ObjectWithCustomClass';
    }
    if (data is _i112.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i113.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i114.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i115.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i116.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i117.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i118.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i119.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i120.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i121.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i122.ScopeServerOnlyField) {
      return 'ScopeServerOnlyField';
    }
    if (data is _i123.ScopeServerOnlyFieldChild) {
      return 'ScopeServerOnlyFieldChild';
    }
    if (data is _i124.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i125.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i126.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i127.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i128.ServerOnlyClassField) {
      return 'ServerOnlyClassField';
    }
    if (data is _i129.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i130.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i131.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i132.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i133.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i134.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i135.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i136.Types) {
      return 'Types';
    }
    if (data is _i137.TypesList) {
      return 'TypesList';
    }
    if (data is _i138.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i139.TypesSet) {
      return 'TypesSet';
    }
    if (data is _i140.UniqueData) {
      return 'UniqueData';
    }
    if (data is _i141.MyFeatureModel) {
      return 'MyFeatureModel';
    }
    className = _i147.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i142.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i145.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i147.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i145.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i145.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i145.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i145.SimpleData>>) {
      return 'List<Set<SimpleData>>';
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
      return deserialize<_i144.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i144.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i144.CustomClassWithoutProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i144.CustomClassWithProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i144.CustomClassWithProtocolSerializationMethod>(
          data['data']);
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i144.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i144.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i144.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_i2.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_i3.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'CourseUuid') {
      return deserialize<_i4.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i5.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i6.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i7.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i8.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i9.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i10.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_i11.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_i12.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_i13.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_i14.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i15.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_i16.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_i17.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i18.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i19.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i20.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i21.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i22.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i23.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i24.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i25.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i26.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i27.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i28.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i29.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i30.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i31.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i32.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i33.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i34.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i35.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i36.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i37.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i38.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i39.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i40.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i41.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i42.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i43.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i44.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i45.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i46.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i47.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i48.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i49.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i50.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i51.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i52.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i53.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i54.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i55.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i56.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i57.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i58.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i59.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i60.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i61.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i62.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i63.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i64.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i65.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i66.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i67.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i68.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i69.ParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i70.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i71.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i71.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i71.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i72.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i73.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i74.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i75.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i76.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i77.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i78.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i79.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i80.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i81.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i82.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i83.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i84.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i85.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i86.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i87.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i88.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i89.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i90.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i91.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i92.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i93.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i94.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i95.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i96.Customer>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i97.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i98.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i99.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i100.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i101.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i102.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i103.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i104.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i105.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i106.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i107.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i108.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i109.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i110.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i111.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i112.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i113.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i114.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i115.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i116.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i117.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i118.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i119.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i120.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i121.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i122.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i123.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i124.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i125.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i126.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i127.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i128.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i129.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i130.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i131.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i132.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i133.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i134.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i135.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i136.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i137.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i138.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i139.TypesSet>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i140.UniqueData>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i141.MyFeatureModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i147.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i142.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i145.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i147.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i145.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i145.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i145.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i145.SimpleData>>>(data['data']);
    }
    return super.deserializeByClassName(data);
  }
}

/// Maps any `Record`s known to this [Protocol] to their JSON representation
///
/// Throws in case the record type is not known.
///
/// This method will return `null` (only) for `null` inputs.
Map<String, dynamic>? mapRecordToJson(Record? record) {
  if (record == null) {
    return null;
  }
  if (record is (int,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (int?,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (int, String)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is (int, _i145.SimpleData)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is ({int number, String text})) {
    return {
      "n": {
        "number": record.number,
        "text": record.text,
      },
    };
  }
  if (record is ({_i145.SimpleData data, int number})) {
    return {
      "n": {
        "data": record.data,
        "number": record.number,
      },
    };
  }
  if (record is ({_i145.SimpleData? data, int? number})) {
    return {
      "n": {
        "data": record.data,
        "number": record.number,
      },
    };
  }
  if (record is (int, {_i145.SimpleData data})) {
    return {
      "p": [
        record.$1,
      ],
      "n": {
        "data": record.data,
      },
    };
  }
  if (record is (String, int)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is ({(_i145.SimpleData, double) namedSubRecord})) {
    return {
      "n": {
        "namedSubRecord": mapRecordToJson(record.namedSubRecord),
      },
    };
  }
  if (record is (_i145.SimpleData, double)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is ({(_i145.SimpleData, double)? namedSubRecord})) {
    return {
      "n": {
        "namedSubRecord": mapRecordToJson(record.namedSubRecord),
      },
    };
  }
  if (record is ((int, String), {(_i145.SimpleData, double) namedSubRecord})) {
    return {
      "p": [
        mapRecordToJson(record.$1),
      ],
      "n": {
        "namedSubRecord": mapRecordToJson(record.namedSubRecord),
      },
    };
  }
  if (record is (String, (int, bool))) {
    return {
      "p": [
        record.$1,
        mapRecordToJson(record.$2),
      ],
    };
  }
  if (record is (int, bool)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  throw Exception('Unsupported record type ${record.runtimeType}');
}

/// Maps container types (like [List], [Map], [Set]) containing [Record]s to their JSON representation.
///
/// It should not be called for [SerializableModel] types. These handle the "[Record] in container" mapping internally already.
///
/// It is only supposed to be called from generated protocol code.
///
/// Returns either a `List<dynamic>` (for List, Sets, and Maps with non-String keys) or a `Map<String, dynamic>` in case the input was a `Map<String, …>`.
Object? mapRecordContainingContainerToJson(Object obj) {
  if (obj is! Iterable && obj is! Map) {
    throw ArgumentError.value(
      obj,
      'obj',
      'The object to serialize should be of type List, Map, or Set',
    );
  }

  dynamic mapIfNeeded(Object? obj) {
    return switch (obj) {
      Record record => mapRecordToJson(record),
      Iterable iterable => mapRecordContainingContainerToJson(iterable),
      Map map => mapRecordContainingContainerToJson(map),
      Object? value => value,
    };
  }

  switch (obj) {
    case Map<String, dynamic>():
      return {
        for (var entry in obj.entries) entry.key: mapIfNeeded(entry.value),
      };
    case Map():
      return [
        for (var entry in obj.entries)
          {
            'k': mapIfNeeded(entry.key),
            'v': mapIfNeeded(entry.value),
          }
      ];

    case Iterable():
      return [
        for (var e in obj) mapIfNeeded(e),
      ];
  }

  return obj;
}
