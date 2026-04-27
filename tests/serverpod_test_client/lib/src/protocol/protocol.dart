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
import 'defaults/enum/enums/default_value_enum.dart' as _i44;
import 'defaults/exception/default_exception.dart' as _i45;
import 'defaults/integer/int_default.dart' as _i46;
import 'defaults/integer/int_default_mix.dart' as _i47;
import 'defaults/integer/int_default_model.dart' as _i48;
import 'defaults/integer/int_default_persist.dart' as _i49;
import 'defaults/string/string_default.dart' as _i50;
import 'defaults/string/string_default_mix.dart' as _i51;
import 'defaults/string/string_default_model.dart' as _i52;
import 'defaults/string/string_default_persist.dart' as _i53;
import 'defaults/uri/uri_default.dart' as _i54;
import 'defaults/uri/uri_default_mix.dart' as _i55;
import 'defaults/uri/uri_default_model.dart' as _i56;
import 'defaults/uri/uri_default_persist.dart' as _i57;
import 'defaults/uuid/uuid_default.dart' as _i58;
import 'defaults/uuid/uuid_default_mix.dart' as _i59;
import 'defaults/uuid/uuid_default_model.dart' as _i60;
import 'defaults/uuid/uuid_default_persist.dart' as _i61;
import 'empty_model/empty_model.dart' as _i62;
import 'empty_model/empty_model_relation_item.dart' as _i63;
import 'empty_model/empty_model_with_table.dart' as _i64;
import 'empty_model/relation_empy_model.dart' as _i65;
import 'exception_with_data.dart' as _i66;
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i67;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i68;
import 'explicit_column_name/modified_column_name.dart' as _i69;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i70;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i71;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i72;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i73;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i74;
import 'immutable/immutable_child_object.dart' as _i75;
import 'immutable/immutable_child_object_with_no_additional_fields.dart'
    as _i76;
import 'immutable/immutable_object.dart' as _i77;
import 'immutable/immutable_object_with_immutable_object.dart' as _i78;
import 'immutable/immutable_object_with_list.dart' as _i79;
import 'immutable/immutable_object_with_map.dart' as _i80;
import 'immutable/immutable_object_with_multiple_fields.dart' as _i81;
import 'immutable/immutable_object_with_no_fields.dart' as _i82;
import 'immutable/immutable_object_with_record.dart' as _i83;
import 'immutable/immutable_object_with_table.dart' as _i84;
import 'immutable/immutable_object_with_twenty_fields.dart' as _i85;
import 'inheritance/child_class.dart' as _i86;
import 'inheritance/child_with_default.dart' as _i87;
import 'inheritance/child_without_id.dart' as _i88;
import 'inheritance/parent_class.dart' as _i89;
import 'inheritance/grandparent_class.dart' as _i90;
import 'inheritance/parent_without_id.dart' as _i91;
import 'inheritance/grandparent_with_id.dart' as _i92;
import 'inheritance/list_relation_of_child/child_entity.dart' as _i93;
import 'inheritance/list_relation_of_child/base_entity.dart' as _i94;
import 'inheritance/list_relation_of_child/parent_entity.dart' as _i95;
import 'inheritance/parent_non_server_only.dart' as _i96;
import 'inheritance/parent_with_default.dart' as _i97;
import 'inheritance/polymorphism/grandchild.dart' as _i98;
import 'inheritance/polymorphism/child.dart' as _i99;
import 'inheritance/polymorphism/container.dart' as _i100;
import 'inheritance/polymorphism/container_module.dart' as _i101;
import 'inheritance/polymorphism/other.dart' as _i102;
import 'inheritance/polymorphism/parent.dart' as _i103;
import 'inheritance/polymorphism/unrelated.dart' as _i104;
import 'inheritance/sealed_parent.dart' as _i105;
import 'inheritance/sealed_parent_nullable_field.dart' as _i106;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i107;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i108;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i109;
import 'long_identifiers/max_field_name.dart' as _i110;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i111;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i112;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i113;
import 'long_identifiers/models_with_relations/user_note.dart' as _i114;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i115;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i116;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i117;
import 'long_identifiers/multiple_max_field_name.dart' as _i118;
import 'models_with_list_relations/city.dart' as _i119;
import 'models_with_list_relations/organization.dart' as _i120;
import 'models_with_list_relations/person.dart' as _i121;
import 'models_with_relations/many_to_many/course.dart' as _i122;
import 'models_with_relations/many_to_many/enrollment.dart' as _i123;
import 'models_with_relations/many_to_many/student.dart' as _i124;
import 'models_with_relations/module/object_user.dart' as _i125;
import 'models_with_relations/module/parent_user.dart' as _i126;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i127;
import 'models_with_relations/nested_one_to_many/player.dart' as _i128;
import 'models_with_relations/nested_one_to_many/team.dart' as _i129;
import 'models_with_relations/one_to_many/comment.dart' as _i130;
import 'models_with_relations/one_to_many/customer.dart' as _i131;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i132;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i133;
import 'models_with_relations/one_to_many/order.dart' as _i134;
import 'models_with_relations/one_to_one/address.dart' as _i135;
import 'models_with_relations/one_to_one/citizen.dart' as _i136;
import 'models_with_relations/one_to_one/company.dart' as _i137;
import 'models_with_relations/one_to_one/town.dart' as _i138;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i139;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i140;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i141;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i142;
import 'module_datatype.dart' as _i143;
import 'my_feature/models/my_feature_model.dart' as _i144;
import 'my_trigger_type.dart' as _i145;
import 'nullability.dart' as _i146;
import 'object_field_persist.dart' as _i147;
import 'object_field_scopes.dart' as _i148;
import 'object_with_bit.dart' as _i149;
import 'object_with_bytedata.dart' as _i150;
import 'object_with_custom_class.dart' as _i151;
import 'object_with_duration.dart' as _i152;
import 'object_with_dynamic.dart' as _i153;
import 'object_with_enum.dart' as _i154;
import 'object_with_enum_enhanced.dart' as _i155;
import 'object_with_half_vector.dart' as _i156;
import 'object_with_index.dart' as _i157;
import 'object_with_jsonb.dart' as _i158;
import 'object_with_jsonb_class_level.dart' as _i159;
import 'object_with_maps.dart' as _i160;
import 'object_with_nullable_custom_class.dart' as _i161;
import 'object_with_object.dart' as _i162;
import 'object_with_parent.dart' as _i163;
import 'object_with_sealed_class.dart' as _i164;
import 'object_with_self_parent.dart' as _i165;
import 'object_with_sparse_vector.dart' as _i166;
import 'object_with_uuid.dart' as _i167;
import 'object_with_vector.dart' as _i168;
import 'record.dart' as _i169;
import 'related_unique_data.dart' as _i170;
import 'required/exception_with_required_field.dart' as _i171;
import 'required/model_with_required_field.dart' as _i172;
import 'scopes/scope_none_fields.dart' as _i173;
import 'scopes/scope_server_only_field_child.dart' as _i174;
import 'scopes/scope_server_only_field.dart' as _i175;
import 'scopes/serverOnly/default_server_only_class.dart' as _i176;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i177;
import 'scopes/serverOnly/not_server_only_class.dart' as _i178;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i179;
import 'scopes/server_only_class_field.dart' as _i180;
import 'server_only_default.dart' as _i181;
import 'session_auth_info.dart' as _i182;
import 'shared_model_container.dart' as _i183;
import 'shared_model_subclass.dart' as _i184;
import 'simple_data.dart' as _i185;
import 'simple_data_list.dart' as _i186;
import 'simple_data_map.dart' as _i187;
import 'simple_data_object.dart' as _i188;
import 'simple_date_time.dart' as _i189;
import 'subfolder/model_in_subfolder.dart' as _i190;
import 'test_enum.dart' as _i191;
import 'test_enum_default_serialization.dart' as _i192;
import 'test_enum_enhanced.dart' as _i193;
import 'test_enum_enhanced_by_name.dart' as _i194;
import 'test_enum_stringified.dart' as _i195;
import 'types.dart' as _i196;
import 'types_list.dart' as _i197;
import 'types_map.dart' as _i198;
import 'types_record.dart' as _i199;
import 'types_set.dart' as _i200;
import 'types_set_required.dart' as _i201;
import 'unique_data.dart' as _i202;
import 'unique_data_with_non_persist.dart' as _i203;
import 'upsert_test_model.dart' as _i204;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i205;
import 'dart:typed_data' as _i206;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i207;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i208;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i209;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i210;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/parent.dart'
    as _i211;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i212;
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
export 'defaults/enum/enums/default_value_enum.dart';
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
export 'explicit_column_name/inheritance/child_class_explicit_column.dart';
export 'explicit_column_name/inheritance/non_table_parent_class.dart';
export 'explicit_column_name/modified_column_name.dart';
export 'explicit_column_name/relations/one_to_many/department.dart';
export 'explicit_column_name/relations/one_to_many/employee.dart';
export 'explicit_column_name/relations/one_to_one/contractor.dart';
export 'explicit_column_name/relations/one_to_one/service.dart';
export 'explicit_column_name/table_with_explicit_column_names.dart';
export 'immutable/immutable_child_object.dart';
export 'immutable/immutable_child_object_with_no_additional_fields.dart';
export 'immutable/immutable_object.dart';
export 'immutable/immutable_object_with_immutable_object.dart';
export 'immutable/immutable_object_with_list.dart';
export 'immutable/immutable_object_with_map.dart';
export 'immutable/immutable_object_with_multiple_fields.dart';
export 'immutable/immutable_object_with_no_fields.dart';
export 'immutable/immutable_object_with_record.dart';
export 'immutable/immutable_object_with_table.dart';
export 'immutable/immutable_object_with_twenty_fields.dart';
export 'inheritance/child_class.dart';
export 'inheritance/child_with_default.dart';
export 'inheritance/child_without_id.dart';
export 'inheritance/parent_class.dart';
export 'inheritance/grandparent_class.dart';
export 'inheritance/parent_without_id.dart';
export 'inheritance/grandparent_with_id.dart';
export 'inheritance/list_relation_of_child/child_entity.dart';
export 'inheritance/list_relation_of_child/base_entity.dart';
export 'inheritance/list_relation_of_child/parent_entity.dart';
export 'inheritance/parent_non_server_only.dart';
export 'inheritance/parent_with_default.dart';
export 'inheritance/polymorphism/grandchild.dart';
export 'inheritance/polymorphism/child.dart';
export 'inheritance/polymorphism/container.dart';
export 'inheritance/polymorphism/container_module.dart';
export 'inheritance/polymorphism/other.dart';
export 'inheritance/polymorphism/parent.dart';
export 'inheritance/polymorphism/unrelated.dart';
export 'inheritance/sealed_no_child.dart';
export 'inheritance/sealed_parent.dart';
export 'inheritance/sealed_parent_nullable_field.dart';
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
export 'models_with_relations/one_to_many/implicit/book.dart';
export 'models_with_relations/one_to_many/implicit/chapter.dart';
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
export 'my_feature/models/my_feature_model.dart';
export 'my_trigger_type.dart';
export 'nullability.dart';
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bit.dart';
export 'object_with_bytedata.dart';
export 'object_with_custom_class.dart';
export 'object_with_duration.dart';
export 'object_with_dynamic.dart';
export 'object_with_enum.dart';
export 'object_with_enum_enhanced.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
export 'object_with_jsonb.dart';
export 'object_with_jsonb_class_level.dart';
export 'object_with_maps.dart';
export 'object_with_nullable_custom_class.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_sealed_class.dart';
export 'object_with_self_parent.dart';
export 'object_with_sparse_vector.dart';
export 'object_with_uuid.dart';
export 'object_with_vector.dart';
export 'record.dart';
export 'related_unique_data.dart';
export 'required/exception_with_required_field.dart';
export 'required/model_with_required_field.dart';
export 'scopes/scope_none_fields.dart';
export 'scopes/scope_server_only_field_child.dart';
export 'scopes/scope_server_only_field.dart';
export 'scopes/serverOnly/default_server_only_class.dart';
export 'scopes/serverOnly/default_server_only_enum.dart';
export 'scopes/serverOnly/not_server_only_class.dart';
export 'scopes/serverOnly/not_server_only_enum.dart';
export 'scopes/server_only_class_field.dart';
export 'server_only_default.dart';
export 'session_auth_info.dart';
export 'shared_model_container.dart';
export 'shared_model_subclass.dart';
export 'simple_data.dart';
export 'simple_data_list.dart';
export 'simple_data_map.dart';
export 'simple_data_object.dart';
export 'simple_date_time.dart';
export 'subfolder/model_in_subfolder.dart';
export 'test_enum.dart';
export 'test_enum_default_serialization.dart';
export 'test_enum_enhanced.dart';
export 'test_enum_enhanced_by_name.dart';
export 'test_enum_stringified.dart';
export 'types.dart';
export 'types_list.dart';
export 'types_map.dart';
export 'types_record.dart';
export 'types_set.dart';
export 'types_set_required.dart';
export 'unique_data.dart';
export 'unique_data_with_non_persist.dart';
export 'upsert_test_model.dart';
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i2.ByIndexEnumWithNameValue] = (data, protocol) =>
        _i2.ByIndexEnumWithNameValue.fromJson(data);
    map[_i3.ByNameEnumWithNameValue] = (data, protocol) =>
        _i3.ByNameEnumWithNameValue.fromJson(data);
    map[_i4.CourseUuid] = (data, protocol) => _i4.CourseUuid.fromJson(data);
    map[_i5.EnrollmentInt] = (data, protocol) =>
        _i5.EnrollmentInt.fromJson(data);
    map[_i6.StudentUuid] = (data, protocol) => _i6.StudentUuid.fromJson(data);
    map[_i7.ArenaUuid] = (data, protocol) => _i7.ArenaUuid.fromJson(data);
    map[_i8.PlayerUuid] = (data, protocol) => _i8.PlayerUuid.fromJson(data);
    map[_i9.TeamInt] = (data, protocol) => _i9.TeamInt.fromJson(data);
    map[_i10.CommentInt] = (data, protocol) => _i10.CommentInt.fromJson(data);
    map[_i11.CustomerInt] = (data, protocol) => _i11.CustomerInt.fromJson(data);
    map[_i12.OrderUuid] = (data, protocol) => _i12.OrderUuid.fromJson(data);
    map[_i13.AddressUuid] = (data, protocol) => _i13.AddressUuid.fromJson(data);
    map[_i14.CitizenInt] = (data, protocol) => _i14.CitizenInt.fromJson(data);
    map[_i15.CompanyUuid] = (data, protocol) => _i15.CompanyUuid.fromJson(data);
    map[_i16.TownInt] = (data, protocol) => _i16.TownInt.fromJson(data);
    map[_i17.ChangedIdTypeSelf] = (data, protocol) =>
        _i17.ChangedIdTypeSelf.fromJson(data);
    map[_i18.BigIntDefault] = (data, protocol) =>
        _i18.BigIntDefault.fromJson(data);
    map[_i19.BigIntDefaultMix] = (data, protocol) =>
        _i19.BigIntDefaultMix.fromJson(data);
    map[_i20.BigIntDefaultModel] = (data, protocol) =>
        _i20.BigIntDefaultModel.fromJson(data);
    map[_i21.BigIntDefaultPersist] = (data, protocol) =>
        _i21.BigIntDefaultPersist.fromJson(data);
    map[_i22.BoolDefault] = (data, protocol) => _i22.BoolDefault.fromJson(data);
    map[_i23.BoolDefaultMix] = (data, protocol) =>
        _i23.BoolDefaultMix.fromJson(data);
    map[_i24.BoolDefaultModel] = (data, protocol) =>
        _i24.BoolDefaultModel.fromJson(data);
    map[_i25.BoolDefaultPersist] = (data, protocol) =>
        _i25.BoolDefaultPersist.fromJson(data);
    map[_i26.DateTimeDefault] = (data, protocol) =>
        _i26.DateTimeDefault.fromJson(data);
    map[_i27.DateTimeDefaultMix] = (data, protocol) =>
        _i27.DateTimeDefaultMix.fromJson(data);
    map[_i28.DateTimeDefaultModel] = (data, protocol) =>
        _i28.DateTimeDefaultModel.fromJson(data);
    map[_i29.DateTimeDefaultPersist] = (data, protocol) =>
        _i29.DateTimeDefaultPersist.fromJson(data);
    map[_i30.DoubleDefault] = (data, protocol) =>
        _i30.DoubleDefault.fromJson(data);
    map[_i31.DoubleDefaultMix] = (data, protocol) =>
        _i31.DoubleDefaultMix.fromJson(data);
    map[_i32.DoubleDefaultModel] = (data, protocol) =>
        _i32.DoubleDefaultModel.fromJson(data);
    map[_i33.DoubleDefaultPersist] = (data, protocol) =>
        _i33.DoubleDefaultPersist.fromJson(data);
    map[_i34.DurationDefault] = (data, protocol) =>
        _i34.DurationDefault.fromJson(data);
    map[_i35.DurationDefaultMix] = (data, protocol) =>
        _i35.DurationDefaultMix.fromJson(data);
    map[_i36.DurationDefaultModel] = (data, protocol) =>
        _i36.DurationDefaultModel.fromJson(data);
    map[_i37.DurationDefaultPersist] = (data, protocol) =>
        _i37.DurationDefaultPersist.fromJson(data);
    map[_i38.EnumDefault] = (data, protocol) => _i38.EnumDefault.fromJson(data);
    map[_i39.EnumDefaultMix] = (data, protocol) =>
        _i39.EnumDefaultMix.fromJson(data);
    map[_i40.EnumDefaultModel] = (data, protocol) =>
        _i40.EnumDefaultModel.fromJson(data);
    map[_i41.EnumDefaultPersist] = (data, protocol) =>
        _i41.EnumDefaultPersist.fromJson(data);
    map[_i42.ByIndexEnum] = (data, protocol) => _i42.ByIndexEnum.fromJson(data);
    map[_i43.ByNameEnum] = (data, protocol) => _i43.ByNameEnum.fromJson(data);
    map[_i44.DefaultValueEnum] = (data, protocol) =>
        _i44.DefaultValueEnum.fromJson(data);
    map[_i45.DefaultException] = (data, protocol) =>
        _i45.DefaultException.fromJson(data);
    map[_i46.IntDefault] = (data, protocol) => _i46.IntDefault.fromJson(data);
    map[_i47.IntDefaultMix] = (data, protocol) =>
        _i47.IntDefaultMix.fromJson(data);
    map[_i48.IntDefaultModel] = (data, protocol) =>
        _i48.IntDefaultModel.fromJson(data);
    map[_i49.IntDefaultPersist] = (data, protocol) =>
        _i49.IntDefaultPersist.fromJson(data);
    map[_i50.StringDefault] = (data, protocol) =>
        _i50.StringDefault.fromJson(data);
    map[_i51.StringDefaultMix] = (data, protocol) =>
        _i51.StringDefaultMix.fromJson(data);
    map[_i52.StringDefaultModel] = (data, protocol) =>
        _i52.StringDefaultModel.fromJson(data);
    map[_i53.StringDefaultPersist] = (data, protocol) =>
        _i53.StringDefaultPersist.fromJson(data);
    map[_i54.UriDefault] = (data, protocol) => _i54.UriDefault.fromJson(data);
    map[_i55.UriDefaultMix] = (data, protocol) =>
        _i55.UriDefaultMix.fromJson(data);
    map[_i56.UriDefaultModel] = (data, protocol) =>
        _i56.UriDefaultModel.fromJson(data);
    map[_i57.UriDefaultPersist] = (data, protocol) =>
        _i57.UriDefaultPersist.fromJson(data);
    map[_i58.UuidDefault] = (data, protocol) => _i58.UuidDefault.fromJson(data);
    map[_i59.UuidDefaultMix] = (data, protocol) =>
        _i59.UuidDefaultMix.fromJson(data);
    map[_i60.UuidDefaultModel] = (data, protocol) =>
        _i60.UuidDefaultModel.fromJson(data);
    map[_i61.UuidDefaultPersist] = (data, protocol) =>
        _i61.UuidDefaultPersist.fromJson(data);
    map[_i62.EmptyModel] = (data, protocol) => _i62.EmptyModel.fromJson(data);
    map[_i63.EmptyModelRelationItem] = (data, protocol) =>
        _i63.EmptyModelRelationItem.fromJson(data);
    map[_i64.EmptyModelWithTable] = (data, protocol) =>
        _i64.EmptyModelWithTable.fromJson(data);
    map[_i65.RelationEmptyModel] = (data, protocol) =>
        _i65.RelationEmptyModel.fromJson(data);
    map[_i66.ExceptionWithData] = (data, protocol) =>
        _i66.ExceptionWithData.fromJson(data);
    map[_i67.ChildClassExplicitColumn] = (data, protocol) =>
        _i67.ChildClassExplicitColumn.fromJson(data);
    map[_i68.NonTableParentClass] = (data, protocol) =>
        _i68.NonTableParentClass.fromJson(data);
    map[_i69.ModifiedColumnName] = (data, protocol) =>
        _i69.ModifiedColumnName.fromJson(data);
    map[_i70.Department] = (data, protocol) => _i70.Department.fromJson(data);
    map[_i71.Employee] = (data, protocol) => _i71.Employee.fromJson(data);
    map[_i72.Contractor] = (data, protocol) => _i72.Contractor.fromJson(data);
    map[_i73.Service] = (data, protocol) => _i73.Service.fromJson(data);
    map[_i74.TableWithExplicitColumnName] = (data, protocol) =>
        _i74.TableWithExplicitColumnName.fromJson(data);
    map[_i75.ImmutableChildObject] = (data, protocol) =>
        _i75.ImmutableChildObject.fromJson(data);
    map[_i76.ImmutableChildObjectWithNoAdditionalFields] = (data, protocol) =>
        _i76.ImmutableChildObjectWithNoAdditionalFields.fromJson(data);
    map[_i77.ImmutableObject] = (data, protocol) =>
        _i77.ImmutableObject.fromJson(data);
    map[_i78.ImmutableObjectWithImmutableObject] = (data, protocol) =>
        _i78.ImmutableObjectWithImmutableObject.fromJson(data);
    map[_i79.ImmutableObjectWithList] = (data, protocol) =>
        _i79.ImmutableObjectWithList.fromJson(data);
    map[_i80.ImmutableObjectWithMap] = (data, protocol) =>
        _i80.ImmutableObjectWithMap.fromJson(data);
    map[_i81.ImmutableObjectWithMultipleFields] = (data, protocol) =>
        _i81.ImmutableObjectWithMultipleFields.fromJson(data);
    map[_i82.ImmutableObjectWithNoFields] = (data, protocol) =>
        _i82.ImmutableObjectWithNoFields.fromJson(data);
    map[_i83.ImmutableObjectWithRecord] = (data, protocol) =>
        _i83.ImmutableObjectWithRecord.fromJson(data);
    map[_i84.ImmutableObjectWithTable] = (data, protocol) =>
        _i84.ImmutableObjectWithTable.fromJson(data);
    map[_i85.ImmutableObjectWithTwentyFields] = (data, protocol) =>
        _i85.ImmutableObjectWithTwentyFields.fromJson(data);
    map[_i86.ChildClass] = (data, protocol) => _i86.ChildClass.fromJson(data);
    map[_i87.ChildWithDefault] = (data, protocol) =>
        _i87.ChildWithDefault.fromJson(data);
    map[_i88.ChildClassWithoutId] = (data, protocol) =>
        _i88.ChildClassWithoutId.fromJson(data);
    map[_i89.ParentClass] = (data, protocol) => _i89.ParentClass.fromJson(data);
    map[_i90.GrandparentClass] = (data, protocol) =>
        _i90.GrandparentClass.fromJson(data);
    map[_i91.ParentClassWithoutId] = (data, protocol) =>
        _i91.ParentClassWithoutId.fromJson(data);
    map[_i92.GrandparentClassWithId] = (data, protocol) =>
        _i92.GrandparentClassWithId.fromJson(data);
    map[_i93.ChildEntity] = (data, protocol) => _i93.ChildEntity.fromJson(data);
    map[_i94.BaseEntity] = (data, protocol) => _i94.BaseEntity.fromJson(data);
    map[_i95.ParentEntity] = (data, protocol) =>
        _i95.ParentEntity.fromJson(data);
    map[_i96.NonServerOnlyParentClass] = (data, protocol) =>
        _i96.NonServerOnlyParentClass.fromJson(data);
    map[_i97.ParentWithDefault] = (data, protocol) =>
        _i97.ParentWithDefault.fromJson(data);
    map[_i98.PolymorphicGrandChild] = (data, protocol) =>
        _i98.PolymorphicGrandChild.fromJson(data);
    map[_i99.PolymorphicChild] = (data, protocol) =>
        _i99.PolymorphicChild.fromJson(data);
    map[_i100.PolymorphicChildContainer] = (data, protocol) =>
        _i100.PolymorphicChildContainer.fromJson(data);
    map[_i101.ModulePolymorphicChildContainer] = (data, protocol) =>
        _i101.ModulePolymorphicChildContainer.fromJson(data);
    map[_i102.SimilarButNotParent] = (data, protocol) =>
        _i102.SimilarButNotParent.fromJson(data);
    map[_i103.PolymorphicParent] = (data, protocol) =>
        _i103.PolymorphicParent.fromJson(data);
    map[_i104.UnrelatedToPolymorphism] = (data, protocol) =>
        _i104.UnrelatedToPolymorphism.fromJson(data);
    map[_i105.SealedGrandChild] = (data, protocol) =>
        _i105.SealedGrandChild.fromJson(data);
    map[_i105.SealedChild] = (data, protocol) =>
        _i105.SealedChild.fromJson(data);
    map[_i106.SealedChildOnlyRequired] = (data, protocol) =>
        _i106.SealedChildOnlyRequired.fromJson(data);
    map[_i105.SealedOtherChild] = (data, protocol) =>
        _i105.SealedOtherChild.fromJson(data);
    map[_i107.CityWithLongTableName] = (data, protocol) =>
        _i107.CityWithLongTableName.fromJson(data);
    map[_i108.OrganizationWithLongTableName] = (data, protocol) =>
        _i108.OrganizationWithLongTableName.fromJson(data);
    map[_i109.PersonWithLongTableName] = (data, protocol) =>
        _i109.PersonWithLongTableName.fromJson(data);
    map[_i110.MaxFieldName] = (data, protocol) =>
        _i110.MaxFieldName.fromJson(data);
    map[_i111.LongImplicitIdField] = (data, protocol) =>
        _i111.LongImplicitIdField.fromJson(data);
    map[_i112.LongImplicitIdFieldCollection] = (data, protocol) =>
        _i112.LongImplicitIdFieldCollection.fromJson(data);
    map[_i113.RelationToMultipleMaxFieldName] = (data, protocol) =>
        _i113.RelationToMultipleMaxFieldName.fromJson(data);
    map[_i114.UserNote] = (data, protocol) => _i114.UserNote.fromJson(data);
    map[_i115.UserNoteCollection] = (data, protocol) =>
        _i115.UserNoteCollection.fromJson(data);
    map[_i116.UserNoteCollectionWithALongName] = (data, protocol) =>
        _i116.UserNoteCollectionWithALongName.fromJson(data);
    map[_i117.UserNoteWithALongName] = (data, protocol) =>
        _i117.UserNoteWithALongName.fromJson(data);
    map[_i118.MultipleMaxFieldName] = (data, protocol) =>
        _i118.MultipleMaxFieldName.fromJson(data);
    map[_i119.City] = (data, protocol) => _i119.City.fromJson(data);
    map[_i120.Organization] = (data, protocol) =>
        _i120.Organization.fromJson(data);
    map[_i121.Person] = (data, protocol) => _i121.Person.fromJson(data);
    map[_i122.Course] = (data, protocol) => _i122.Course.fromJson(data);
    map[_i123.Enrollment] = (data, protocol) => _i123.Enrollment.fromJson(data);
    map[_i124.Student] = (data, protocol) => _i124.Student.fromJson(data);
    map[_i125.ObjectUser] = (data, protocol) => _i125.ObjectUser.fromJson(data);
    map[_i126.ParentUser] = (data, protocol) => _i126.ParentUser.fromJson(data);
    map[_i127.Arena] = (data, protocol) => _i127.Arena.fromJson(data);
    map[_i128.Player] = (data, protocol) => _i128.Player.fromJson(data);
    map[_i129.Team] = (data, protocol) => _i129.Team.fromJson(data);
    map[_i130.Comment] = (data, protocol) => _i130.Comment.fromJson(data);
    map[_i131.Customer] = (data, protocol) => _i131.Customer.fromJson(data);
    map[_i132.Book] = (data, protocol) => _i132.Book.fromJson(data);
    map[_i133.Chapter] = (data, protocol) => _i133.Chapter.fromJson(data);
    map[_i134.Order] = (data, protocol) => _i134.Order.fromJson(data);
    map[_i135.Address] = (data, protocol) => _i135.Address.fromJson(data);
    map[_i136.Citizen] = (data, protocol) => _i136.Citizen.fromJson(data);
    map[_i137.Company] = (data, protocol) => _i137.Company.fromJson(data);
    map[_i138.Town] = (data, protocol) => _i138.Town.fromJson(data);
    map[_i139.Blocking] = (data, protocol) => _i139.Blocking.fromJson(data);
    map[_i140.Member] = (data, protocol) => _i140.Member.fromJson(data);
    map[_i141.Cat] = (data, protocol) => _i141.Cat.fromJson(data);
    map[_i142.Post] = (data, protocol) => _i142.Post.fromJson(data);
    map[_i143.ModuleDatatype] = (data, protocol) =>
        _i143.ModuleDatatype.fromJson(data);
    map[_i144.MyFeatureModel] = (data, protocol) =>
        _i144.MyFeatureModel.fromJson(data);
    map[_i145.MyTriggerType] = (data, protocol) =>
        _i145.MyTriggerType.fromJson(data);
    map[_i146.Nullability] = (data, protocol) =>
        _i146.Nullability.fromJson(data);
    map[_i147.ObjectFieldPersist] = (data, protocol) =>
        _i147.ObjectFieldPersist.fromJson(data);
    map[_i148.ObjectFieldScopes] = (data, protocol) =>
        _i148.ObjectFieldScopes.fromJson(data);
    map[_i149.ObjectWithBit] = (data, protocol) =>
        _i149.ObjectWithBit.fromJson(data);
    map[_i150.ObjectWithByteData] = (data, protocol) =>
        _i150.ObjectWithByteData.fromJson(data);
    map[_i151.ObjectWithCustomClass] = (data, protocol) =>
        _i151.ObjectWithCustomClass.fromJson(data);
    map[_i152.ObjectWithDuration] = (data, protocol) =>
        _i152.ObjectWithDuration.fromJson(data);
    map[_i153.ObjectWithDynamic] = (data, protocol) =>
        _i153.ObjectWithDynamic.fromJson(data);
    map[_i154.ObjectWithEnum] = (data, protocol) =>
        _i154.ObjectWithEnum.fromJson(data);
    map[_i155.ObjectWithEnumEnhanced] = (data, protocol) =>
        _i155.ObjectWithEnumEnhanced.fromJson(data);
    map[_i156.ObjectWithHalfVector] = (data, protocol) =>
        _i156.ObjectWithHalfVector.fromJson(data);
    map[_i157.ObjectWithIndex] = (data, protocol) =>
        _i157.ObjectWithIndex.fromJson(data);
    map[_i158.ObjectWithJsonb] = (data, protocol) =>
        _i158.ObjectWithJsonb.fromJson(data);
    map[_i159.ObjectWithJsonbClassLevel] = (data, protocol) =>
        _i159.ObjectWithJsonbClassLevel.fromJson(data);
    map[_i160.ObjectWithMaps] = (data, protocol) =>
        _i160.ObjectWithMaps.fromJson(data);
    map[_i161.ObjectWithNullableCustomClass] = (data, protocol) =>
        _i161.ObjectWithNullableCustomClass.fromJson(data);
    map[_i162.ObjectWithObject] = (data, protocol) =>
        _i162.ObjectWithObject.fromJson(data);
    map[_i163.ObjectWithParent] = (data, protocol) =>
        _i163.ObjectWithParent.fromJson(data);
    map[_i164.ObjectWithSealedClass] = (data, protocol) =>
        _i164.ObjectWithSealedClass.fromJson(data);
    map[_i165.ObjectWithSelfParent] = (data, protocol) =>
        _i165.ObjectWithSelfParent.fromJson(data);
    map[_i166.ObjectWithSparseVector] = (data, protocol) =>
        _i166.ObjectWithSparseVector.fromJson(data);
    map[_i167.ObjectWithUuid] = (data, protocol) =>
        _i167.ObjectWithUuid.fromJson(data);
    map[_i168.ObjectWithVector] = (data, protocol) =>
        _i168.ObjectWithVector.fromJson(data);
    map[_i169.Record] = (data, protocol) => _i169.Record.fromJson(data);
    map[_i170.RelatedUniqueData] = (data, protocol) =>
        _i170.RelatedUniqueData.fromJson(data);
    map[_i171.ExceptionWithRequiredField] = (data, protocol) =>
        _i171.ExceptionWithRequiredField.fromJson(data);
    map[_i172.ModelWithRequiredField] = (data, protocol) =>
        _i172.ModelWithRequiredField.fromJson(data);
    map[_i173.ScopeNoneFields] = (data, protocol) =>
        _i173.ScopeNoneFields.fromJson(data);
    map[_i174.ScopeServerOnlyFieldChild] = (data, protocol) =>
        _i174.ScopeServerOnlyFieldChild.fromJson(data);
    map[_i175.ScopeServerOnlyField] = (data, protocol) =>
        _i175.ScopeServerOnlyField.fromJson(data);
    map[_i176.DefaultServerOnlyClass] = (data, protocol) =>
        _i176.DefaultServerOnlyClass.fromJson(data);
    map[_i177.DefaultServerOnlyEnum] = (data, protocol) =>
        _i177.DefaultServerOnlyEnum.fromJson(data);
    map[_i178.NotServerOnlyClass] = (data, protocol) =>
        _i178.NotServerOnlyClass.fromJson(data);
    map[_i179.NotServerOnlyEnum] = (data, protocol) =>
        _i179.NotServerOnlyEnum.fromJson(data);
    map[_i180.ServerOnlyClassField] = (data, protocol) =>
        _i180.ServerOnlyClassField.fromJson(data);
    map[_i181.ServerOnlyDefault] = (data, protocol) =>
        _i181.ServerOnlyDefault.fromJson(data);
    map[_i182.SessionAuthInfo] = (data, protocol) =>
        _i182.SessionAuthInfo.fromJson(data);
    map[_i183.SharedModelContainer] = (data, protocol) =>
        _i183.SharedModelContainer.fromJson(data);
    map[_i184.SharedModelSubclass] = (data, protocol) =>
        _i184.SharedModelSubclass.fromJson(data);
    map[_i185.SimpleData] = (data, protocol) => _i185.SimpleData.fromJson(data);
    map[_i186.SimpleDataList] = (data, protocol) =>
        _i186.SimpleDataList.fromJson(data);
    map[_i187.SimpleDataMap] = (data, protocol) =>
        _i187.SimpleDataMap.fromJson(data);
    map[_i188.SimpleDataObject] = (data, protocol) =>
        _i188.SimpleDataObject.fromJson(data);
    map[_i189.SimpleDateTime] = (data, protocol) =>
        _i189.SimpleDateTime.fromJson(data);
    map[_i190.ModelInSubfolder] = (data, protocol) =>
        _i190.ModelInSubfolder.fromJson(data);
    map[_i191.TestEnum] = (data, protocol) => _i191.TestEnum.fromJson(data);
    map[_i192.TestEnumDefaultSerialization] = (data, protocol) =>
        _i192.TestEnumDefaultSerialization.fromJson(data);
    map[_i193.TestEnumEnhanced] = (data, protocol) =>
        _i193.TestEnumEnhanced.fromJson(data);
    map[_i194.TestEnumEnhancedByName] = (data, protocol) =>
        _i194.TestEnumEnhancedByName.fromJson(data);
    map[_i195.TestEnumStringified] = (data, protocol) =>
        _i195.TestEnumStringified.fromJson(data);
    map[_i196.Types] = (data, protocol) => _i196.Types.fromJson(data);
    map[_i197.TypesList] = (data, protocol) => _i197.TypesList.fromJson(data);
    map[_i198.TypesMap] = (data, protocol) => _i198.TypesMap.fromJson(data);
    map[_i199.TypesRecord] = (data, protocol) =>
        _i199.TypesRecord.fromJson(data);
    map[_i200.TypesSet] = (data, protocol) => _i200.TypesSet.fromJson(data);
    map[_i201.TypesSetRequired] = (data, protocol) =>
        _i201.TypesSetRequired.fromJson(data);
    map[_i202.UniqueData] = (data, protocol) => _i202.UniqueData.fromJson(data);
    map[_i203.UniqueDataWithNonPersist] = (data, protocol) =>
        _i203.UniqueDataWithNonPersist.fromJson(data);
    map[_i204.UpsertTestModel] = (data, protocol) =>
        _i204.UpsertTestModel.fromJson(data);
    map[_i1.getType<_i2.ByIndexEnumWithNameValue?>()] = (data, protocol) =>
        (data != null ? _i2.ByIndexEnumWithNameValue.fromJson(data) : null);
    map[_i1.getType<_i3.ByNameEnumWithNameValue?>()] = (data, protocol) =>
        (data != null ? _i3.ByNameEnumWithNameValue.fromJson(data) : null);
    map[_i1.getType<_i4.CourseUuid?>()] = (data, protocol) =>
        (data != null ? _i4.CourseUuid.fromJson(data) : null);
    map[_i1.getType<_i5.EnrollmentInt?>()] = (data, protocol) =>
        (data != null ? _i5.EnrollmentInt.fromJson(data) : null);
    map[_i1.getType<_i6.StudentUuid?>()] = (data, protocol) =>
        (data != null ? _i6.StudentUuid.fromJson(data) : null);
    map[_i1.getType<_i7.ArenaUuid?>()] = (data, protocol) =>
        (data != null ? _i7.ArenaUuid.fromJson(data) : null);
    map[_i1.getType<_i8.PlayerUuid?>()] = (data, protocol) =>
        (data != null ? _i8.PlayerUuid.fromJson(data) : null);
    map[_i1.getType<_i9.TeamInt?>()] = (data, protocol) =>
        (data != null ? _i9.TeamInt.fromJson(data) : null);
    map[_i1.getType<_i10.CommentInt?>()] = (data, protocol) =>
        (data != null ? _i10.CommentInt.fromJson(data) : null);
    map[_i1.getType<_i11.CustomerInt?>()] = (data, protocol) =>
        (data != null ? _i11.CustomerInt.fromJson(data) : null);
    map[_i1.getType<_i12.OrderUuid?>()] = (data, protocol) =>
        (data != null ? _i12.OrderUuid.fromJson(data) : null);
    map[_i1.getType<_i13.AddressUuid?>()] = (data, protocol) =>
        (data != null ? _i13.AddressUuid.fromJson(data) : null);
    map[_i1.getType<_i14.CitizenInt?>()] = (data, protocol) =>
        (data != null ? _i14.CitizenInt.fromJson(data) : null);
    map[_i1.getType<_i15.CompanyUuid?>()] = (data, protocol) =>
        (data != null ? _i15.CompanyUuid.fromJson(data) : null);
    map[_i1.getType<_i16.TownInt?>()] = (data, protocol) =>
        (data != null ? _i16.TownInt.fromJson(data) : null);
    map[_i1.getType<_i17.ChangedIdTypeSelf?>()] = (data, protocol) =>
        (data != null ? _i17.ChangedIdTypeSelf.fromJson(data) : null);
    map[_i1.getType<_i18.BigIntDefault?>()] = (data, protocol) =>
        (data != null ? _i18.BigIntDefault.fromJson(data) : null);
    map[_i1.getType<_i19.BigIntDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i19.BigIntDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i20.BigIntDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i20.BigIntDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i21.BigIntDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i21.BigIntDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i22.BoolDefault?>()] = (data, protocol) =>
        (data != null ? _i22.BoolDefault.fromJson(data) : null);
    map[_i1.getType<_i23.BoolDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i23.BoolDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i24.BoolDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i24.BoolDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i25.BoolDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i25.BoolDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i26.DateTimeDefault?>()] = (data, protocol) =>
        (data != null ? _i26.DateTimeDefault.fromJson(data) : null);
    map[_i1.getType<_i27.DateTimeDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i27.DateTimeDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i28.DateTimeDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i28.DateTimeDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i29.DateTimeDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i29.DateTimeDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i30.DoubleDefault?>()] = (data, protocol) =>
        (data != null ? _i30.DoubleDefault.fromJson(data) : null);
    map[_i1.getType<_i31.DoubleDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i31.DoubleDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i32.DoubleDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i32.DoubleDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i33.DoubleDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i33.DoubleDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i34.DurationDefault?>()] = (data, protocol) =>
        (data != null ? _i34.DurationDefault.fromJson(data) : null);
    map[_i1.getType<_i35.DurationDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i35.DurationDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i36.DurationDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i36.DurationDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i37.DurationDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i37.DurationDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i38.EnumDefault?>()] = (data, protocol) =>
        (data != null ? _i38.EnumDefault.fromJson(data) : null);
    map[_i1.getType<_i39.EnumDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i39.EnumDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i40.EnumDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i40.EnumDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i41.EnumDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i41.EnumDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i42.ByIndexEnum?>()] = (data, protocol) =>
        (data != null ? _i42.ByIndexEnum.fromJson(data) : null);
    map[_i1.getType<_i43.ByNameEnum?>()] = (data, protocol) =>
        (data != null ? _i43.ByNameEnum.fromJson(data) : null);
    map[_i1.getType<_i44.DefaultValueEnum?>()] = (data, protocol) =>
        (data != null ? _i44.DefaultValueEnum.fromJson(data) : null);
    map[_i1.getType<_i45.DefaultException?>()] = (data, protocol) =>
        (data != null ? _i45.DefaultException.fromJson(data) : null);
    map[_i1.getType<_i46.IntDefault?>()] = (data, protocol) =>
        (data != null ? _i46.IntDefault.fromJson(data) : null);
    map[_i1.getType<_i47.IntDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i47.IntDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i48.IntDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i48.IntDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i49.IntDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i49.IntDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i50.StringDefault?>()] = (data, protocol) =>
        (data != null ? _i50.StringDefault.fromJson(data) : null);
    map[_i1.getType<_i51.StringDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i51.StringDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i52.StringDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i52.StringDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i53.StringDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i53.StringDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i54.UriDefault?>()] = (data, protocol) =>
        (data != null ? _i54.UriDefault.fromJson(data) : null);
    map[_i1.getType<_i55.UriDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i55.UriDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i56.UriDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i56.UriDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i57.UriDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i57.UriDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i58.UuidDefault?>()] = (data, protocol) =>
        (data != null ? _i58.UuidDefault.fromJson(data) : null);
    map[_i1.getType<_i59.UuidDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i59.UuidDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i60.UuidDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i60.UuidDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i61.UuidDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i61.UuidDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i62.EmptyModel?>()] = (data, protocol) =>
        (data != null ? _i62.EmptyModel.fromJson(data) : null);
    map[_i1.getType<_i63.EmptyModelRelationItem?>()] = (data, protocol) =>
        (data != null ? _i63.EmptyModelRelationItem.fromJson(data) : null);
    map[_i1.getType<_i64.EmptyModelWithTable?>()] = (data, protocol) =>
        (data != null ? _i64.EmptyModelWithTable.fromJson(data) : null);
    map[_i1.getType<_i65.RelationEmptyModel?>()] = (data, protocol) =>
        (data != null ? _i65.RelationEmptyModel.fromJson(data) : null);
    map[_i1.getType<_i66.ExceptionWithData?>()] = (data, protocol) =>
        (data != null ? _i66.ExceptionWithData.fromJson(data) : null);
    map[_i1.getType<_i67.ChildClassExplicitColumn?>()] = (data, protocol) =>
        (data != null ? _i67.ChildClassExplicitColumn.fromJson(data) : null);
    map[_i1.getType<_i68.NonTableParentClass?>()] = (data, protocol) =>
        (data != null ? _i68.NonTableParentClass.fromJson(data) : null);
    map[_i1.getType<_i69.ModifiedColumnName?>()] = (data, protocol) =>
        (data != null ? _i69.ModifiedColumnName.fromJson(data) : null);
    map[_i1.getType<_i70.Department?>()] = (data, protocol) =>
        (data != null ? _i70.Department.fromJson(data) : null);
    map[_i1.getType<_i71.Employee?>()] = (data, protocol) =>
        (data != null ? _i71.Employee.fromJson(data) : null);
    map[_i1.getType<_i72.Contractor?>()] = (data, protocol) =>
        (data != null ? _i72.Contractor.fromJson(data) : null);
    map[_i1.getType<_i73.Service?>()] = (data, protocol) =>
        (data != null ? _i73.Service.fromJson(data) : null);
    map[_i1.getType<_i74.TableWithExplicitColumnName?>()] = (data, protocol) =>
        (data != null ? _i74.TableWithExplicitColumnName.fromJson(data) : null);
    map[_i1.getType<_i75.ImmutableChildObject?>()] = (data, protocol) =>
        (data != null ? _i75.ImmutableChildObject.fromJson(data) : null);
    map[_i1.getType<_i76.ImmutableChildObjectWithNoAdditionalFields?>()] =
        (data, protocol) => (data != null
        ? _i76.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
        : null);
    map[_i1.getType<_i77.ImmutableObject?>()] = (data, protocol) =>
        (data != null ? _i77.ImmutableObject.fromJson(data) : null);
    map[_i1.getType<_i78.ImmutableObjectWithImmutableObject?>()] =
        (data, protocol) => (data != null
        ? _i78.ImmutableObjectWithImmutableObject.fromJson(data)
        : null);
    map[_i1.getType<_i79.ImmutableObjectWithList?>()] = (data, protocol) =>
        (data != null ? _i79.ImmutableObjectWithList.fromJson(data) : null);
    map[_i1.getType<_i80.ImmutableObjectWithMap?>()] = (data, protocol) =>
        (data != null ? _i80.ImmutableObjectWithMap.fromJson(data) : null);
    map[_i1.getType<_i81.ImmutableObjectWithMultipleFields?>()] =
        (data, protocol) => (data != null
        ? _i81.ImmutableObjectWithMultipleFields.fromJson(data)
        : null);
    map[_i1.getType<_i82.ImmutableObjectWithNoFields?>()] = (data, protocol) =>
        (data != null ? _i82.ImmutableObjectWithNoFields.fromJson(data) : null);
    map[_i1.getType<_i83.ImmutableObjectWithRecord?>()] = (data, protocol) =>
        (data != null ? _i83.ImmutableObjectWithRecord.fromJson(data) : null);
    map[_i1.getType<_i84.ImmutableObjectWithTable?>()] = (data, protocol) =>
        (data != null ? _i84.ImmutableObjectWithTable.fromJson(data) : null);
    map[_i1
        .getType<_i85.ImmutableObjectWithTwentyFields?>()] = (data, protocol) =>
        (data != null
        ? _i85.ImmutableObjectWithTwentyFields.fromJson(data)
        : null);
    map[_i1.getType<_i86.ChildClass?>()] = (data, protocol) =>
        (data != null ? _i86.ChildClass.fromJson(data) : null);
    map[_i1.getType<_i87.ChildWithDefault?>()] = (data, protocol) =>
        (data != null ? _i87.ChildWithDefault.fromJson(data) : null);
    map[_i1.getType<_i88.ChildClassWithoutId?>()] = (data, protocol) =>
        (data != null ? _i88.ChildClassWithoutId.fromJson(data) : null);
    map[_i1.getType<_i89.ParentClass?>()] = (data, protocol) =>
        (data != null ? _i89.ParentClass.fromJson(data) : null);
    map[_i1.getType<_i90.GrandparentClass?>()] = (data, protocol) =>
        (data != null ? _i90.GrandparentClass.fromJson(data) : null);
    map[_i1.getType<_i91.ParentClassWithoutId?>()] = (data, protocol) =>
        (data != null ? _i91.ParentClassWithoutId.fromJson(data) : null);
    map[_i1.getType<_i92.GrandparentClassWithId?>()] = (data, protocol) =>
        (data != null ? _i92.GrandparentClassWithId.fromJson(data) : null);
    map[_i1.getType<_i93.ChildEntity?>()] = (data, protocol) =>
        (data != null ? _i93.ChildEntity.fromJson(data) : null);
    map[_i1.getType<_i94.BaseEntity?>()] = (data, protocol) =>
        (data != null ? _i94.BaseEntity.fromJson(data) : null);
    map[_i1.getType<_i95.ParentEntity?>()] = (data, protocol) =>
        (data != null ? _i95.ParentEntity.fromJson(data) : null);
    map[_i1.getType<_i96.NonServerOnlyParentClass?>()] = (data, protocol) =>
        (data != null ? _i96.NonServerOnlyParentClass.fromJson(data) : null);
    map[_i1.getType<_i97.ParentWithDefault?>()] = (data, protocol) =>
        (data != null ? _i97.ParentWithDefault.fromJson(data) : null);
    map[_i1.getType<_i98.PolymorphicGrandChild?>()] = (data, protocol) =>
        (data != null ? _i98.PolymorphicGrandChild.fromJson(data) : null);
    map[_i1.getType<_i99.PolymorphicChild?>()] = (data, protocol) =>
        (data != null ? _i99.PolymorphicChild.fromJson(data) : null);
    map[_i1.getType<_i100.PolymorphicChildContainer?>()] = (data, protocol) =>
        (data != null ? _i100.PolymorphicChildContainer.fromJson(data) : null);
    map[_i1.getType<_i101.ModulePolymorphicChildContainer?>()] =
        (data, protocol) => (data != null
        ? _i101.ModulePolymorphicChildContainer.fromJson(data)
        : null);
    map[_i1.getType<_i102.SimilarButNotParent?>()] = (data, protocol) =>
        (data != null ? _i102.SimilarButNotParent.fromJson(data) : null);
    map[_i1.getType<_i103.PolymorphicParent?>()] = (data, protocol) =>
        (data != null ? _i103.PolymorphicParent.fromJson(data) : null);
    map[_i1.getType<_i104.UnrelatedToPolymorphism?>()] = (data, protocol) =>
        (data != null ? _i104.UnrelatedToPolymorphism.fromJson(data) : null);
    map[_i1.getType<_i105.SealedGrandChild?>()] = (data, protocol) =>
        (data != null ? _i105.SealedGrandChild.fromJson(data) : null);
    map[_i1.getType<_i105.SealedChild?>()] = (data, protocol) =>
        (data != null ? _i105.SealedChild.fromJson(data) : null);
    map[_i1.getType<_i106.SealedChildOnlyRequired?>()] = (data, protocol) =>
        (data != null ? _i106.SealedChildOnlyRequired.fromJson(data) : null);
    map[_i1.getType<_i105.SealedOtherChild?>()] = (data, protocol) =>
        (data != null ? _i105.SealedOtherChild.fromJson(data) : null);
    map[_i1.getType<_i107.CityWithLongTableName?>()] = (data, protocol) =>
        (data != null ? _i107.CityWithLongTableName.fromJson(data) : null);
    map[_i1
        .getType<_i108.OrganizationWithLongTableName?>()] = (data, protocol) =>
        (data != null
        ? _i108.OrganizationWithLongTableName.fromJson(data)
        : null);
    map[_i1.getType<_i109.PersonWithLongTableName?>()] = (data, protocol) =>
        (data != null ? _i109.PersonWithLongTableName.fromJson(data) : null);
    map[_i1.getType<_i110.MaxFieldName?>()] = (data, protocol) =>
        (data != null ? _i110.MaxFieldName.fromJson(data) : null);
    map[_i1.getType<_i111.LongImplicitIdField?>()] = (data, protocol) =>
        (data != null ? _i111.LongImplicitIdField.fromJson(data) : null);
    map[_i1
        .getType<_i112.LongImplicitIdFieldCollection?>()] = (data, protocol) =>
        (data != null
        ? _i112.LongImplicitIdFieldCollection.fromJson(data)
        : null);
    map[_i1
        .getType<_i113.RelationToMultipleMaxFieldName?>()] = (data, protocol) =>
        (data != null
        ? _i113.RelationToMultipleMaxFieldName.fromJson(data)
        : null);
    map[_i1.getType<_i114.UserNote?>()] = (data, protocol) =>
        (data != null ? _i114.UserNote.fromJson(data) : null);
    map[_i1.getType<_i115.UserNoteCollection?>()] = (data, protocol) =>
        (data != null ? _i115.UserNoteCollection.fromJson(data) : null);
    map[_i1.getType<_i116.UserNoteCollectionWithALongName?>()] =
        (data, protocol) => (data != null
        ? _i116.UserNoteCollectionWithALongName.fromJson(data)
        : null);
    map[_i1.getType<_i117.UserNoteWithALongName?>()] = (data, protocol) =>
        (data != null ? _i117.UserNoteWithALongName.fromJson(data) : null);
    map[_i1.getType<_i118.MultipleMaxFieldName?>()] = (data, protocol) =>
        (data != null ? _i118.MultipleMaxFieldName.fromJson(data) : null);
    map[_i1.getType<_i119.City?>()] = (data, protocol) =>
        (data != null ? _i119.City.fromJson(data) : null);
    map[_i1.getType<_i120.Organization?>()] = (data, protocol) =>
        (data != null ? _i120.Organization.fromJson(data) : null);
    map[_i1.getType<_i121.Person?>()] = (data, protocol) =>
        (data != null ? _i121.Person.fromJson(data) : null);
    map[_i1.getType<_i122.Course?>()] = (data, protocol) =>
        (data != null ? _i122.Course.fromJson(data) : null);
    map[_i1.getType<_i123.Enrollment?>()] = (data, protocol) =>
        (data != null ? _i123.Enrollment.fromJson(data) : null);
    map[_i1.getType<_i124.Student?>()] = (data, protocol) =>
        (data != null ? _i124.Student.fromJson(data) : null);
    map[_i1.getType<_i125.ObjectUser?>()] = (data, protocol) =>
        (data != null ? _i125.ObjectUser.fromJson(data) : null);
    map[_i1.getType<_i126.ParentUser?>()] = (data, protocol) =>
        (data != null ? _i126.ParentUser.fromJson(data) : null);
    map[_i1.getType<_i127.Arena?>()] = (data, protocol) =>
        (data != null ? _i127.Arena.fromJson(data) : null);
    map[_i1.getType<_i128.Player?>()] = (data, protocol) =>
        (data != null ? _i128.Player.fromJson(data) : null);
    map[_i1.getType<_i129.Team?>()] = (data, protocol) =>
        (data != null ? _i129.Team.fromJson(data) : null);
    map[_i1.getType<_i130.Comment?>()] = (data, protocol) =>
        (data != null ? _i130.Comment.fromJson(data) : null);
    map[_i1.getType<_i131.Customer?>()] = (data, protocol) =>
        (data != null ? _i131.Customer.fromJson(data) : null);
    map[_i1.getType<_i132.Book?>()] = (data, protocol) =>
        (data != null ? _i132.Book.fromJson(data) : null);
    map[_i1.getType<_i133.Chapter?>()] = (data, protocol) =>
        (data != null ? _i133.Chapter.fromJson(data) : null);
    map[_i1.getType<_i134.Order?>()] = (data, protocol) =>
        (data != null ? _i134.Order.fromJson(data) : null);
    map[_i1.getType<_i135.Address?>()] = (data, protocol) =>
        (data != null ? _i135.Address.fromJson(data) : null);
    map[_i1.getType<_i136.Citizen?>()] = (data, protocol) =>
        (data != null ? _i136.Citizen.fromJson(data) : null);
    map[_i1.getType<_i137.Company?>()] = (data, protocol) =>
        (data != null ? _i137.Company.fromJson(data) : null);
    map[_i1.getType<_i138.Town?>()] = (data, protocol) =>
        (data != null ? _i138.Town.fromJson(data) : null);
    map[_i1.getType<_i139.Blocking?>()] = (data, protocol) =>
        (data != null ? _i139.Blocking.fromJson(data) : null);
    map[_i1.getType<_i140.Member?>()] = (data, protocol) =>
        (data != null ? _i140.Member.fromJson(data) : null);
    map[_i1.getType<_i141.Cat?>()] = (data, protocol) =>
        (data != null ? _i141.Cat.fromJson(data) : null);
    map[_i1.getType<_i142.Post?>()] = (data, protocol) =>
        (data != null ? _i142.Post.fromJson(data) : null);
    map[_i1.getType<_i143.ModuleDatatype?>()] = (data, protocol) =>
        (data != null ? _i143.ModuleDatatype.fromJson(data) : null);
    map[_i1.getType<_i144.MyFeatureModel?>()] = (data, protocol) =>
        (data != null ? _i144.MyFeatureModel.fromJson(data) : null);
    map[_i1.getType<_i145.MyTriggerType?>()] = (data, protocol) =>
        (data != null ? _i145.MyTriggerType.fromJson(data) : null);
    map[_i1.getType<_i146.Nullability?>()] = (data, protocol) =>
        (data != null ? _i146.Nullability.fromJson(data) : null);
    map[_i1.getType<_i147.ObjectFieldPersist?>()] = (data, protocol) =>
        (data != null ? _i147.ObjectFieldPersist.fromJson(data) : null);
    map[_i1.getType<_i148.ObjectFieldScopes?>()] = (data, protocol) =>
        (data != null ? _i148.ObjectFieldScopes.fromJson(data) : null);
    map[_i1.getType<_i149.ObjectWithBit?>()] = (data, protocol) =>
        (data != null ? _i149.ObjectWithBit.fromJson(data) : null);
    map[_i1.getType<_i150.ObjectWithByteData?>()] = (data, protocol) =>
        (data != null ? _i150.ObjectWithByteData.fromJson(data) : null);
    map[_i1.getType<_i151.ObjectWithCustomClass?>()] = (data, protocol) =>
        (data != null ? _i151.ObjectWithCustomClass.fromJson(data) : null);
    map[_i1.getType<_i152.ObjectWithDuration?>()] = (data, protocol) =>
        (data != null ? _i152.ObjectWithDuration.fromJson(data) : null);
    map[_i1.getType<_i153.ObjectWithDynamic?>()] = (data, protocol) =>
        (data != null ? _i153.ObjectWithDynamic.fromJson(data) : null);
    map[_i1.getType<_i154.ObjectWithEnum?>()] = (data, protocol) =>
        (data != null ? _i154.ObjectWithEnum.fromJson(data) : null);
    map[_i1.getType<_i155.ObjectWithEnumEnhanced?>()] = (data, protocol) =>
        (data != null ? _i155.ObjectWithEnumEnhanced.fromJson(data) : null);
    map[_i1.getType<_i156.ObjectWithHalfVector?>()] = (data, protocol) =>
        (data != null ? _i156.ObjectWithHalfVector.fromJson(data) : null);
    map[_i1.getType<_i157.ObjectWithIndex?>()] = (data, protocol) =>
        (data != null ? _i157.ObjectWithIndex.fromJson(data) : null);
    map[_i1.getType<_i158.ObjectWithJsonb?>()] = (data, protocol) =>
        (data != null ? _i158.ObjectWithJsonb.fromJson(data) : null);
    map[_i1.getType<_i159.ObjectWithJsonbClassLevel?>()] = (data, protocol) =>
        (data != null ? _i159.ObjectWithJsonbClassLevel.fromJson(data) : null);
    map[_i1.getType<_i160.ObjectWithMaps?>()] = (data, protocol) =>
        (data != null ? _i160.ObjectWithMaps.fromJson(data) : null);
    map[_i1
        .getType<_i161.ObjectWithNullableCustomClass?>()] = (data, protocol) =>
        (data != null
        ? _i161.ObjectWithNullableCustomClass.fromJson(data)
        : null);
    map[_i1.getType<_i162.ObjectWithObject?>()] = (data, protocol) =>
        (data != null ? _i162.ObjectWithObject.fromJson(data) : null);
    map[_i1.getType<_i163.ObjectWithParent?>()] = (data, protocol) =>
        (data != null ? _i163.ObjectWithParent.fromJson(data) : null);
    map[_i1.getType<_i164.ObjectWithSealedClass?>()] = (data, protocol) =>
        (data != null ? _i164.ObjectWithSealedClass.fromJson(data) : null);
    map[_i1.getType<_i165.ObjectWithSelfParent?>()] = (data, protocol) =>
        (data != null ? _i165.ObjectWithSelfParent.fromJson(data) : null);
    map[_i1.getType<_i166.ObjectWithSparseVector?>()] = (data, protocol) =>
        (data != null ? _i166.ObjectWithSparseVector.fromJson(data) : null);
    map[_i1.getType<_i167.ObjectWithUuid?>()] = (data, protocol) =>
        (data != null ? _i167.ObjectWithUuid.fromJson(data) : null);
    map[_i1.getType<_i168.ObjectWithVector?>()] = (data, protocol) =>
        (data != null ? _i168.ObjectWithVector.fromJson(data) : null);
    map[_i1.getType<_i169.Record?>()] = (data, protocol) =>
        (data != null ? _i169.Record.fromJson(data) : null);
    map[_i1.getType<_i170.RelatedUniqueData?>()] = (data, protocol) =>
        (data != null ? _i170.RelatedUniqueData.fromJson(data) : null);
    map[_i1.getType<_i171.ExceptionWithRequiredField?>()] = (data, protocol) =>
        (data != null ? _i171.ExceptionWithRequiredField.fromJson(data) : null);
    map[_i1.getType<_i172.ModelWithRequiredField?>()] = (data, protocol) =>
        (data != null ? _i172.ModelWithRequiredField.fromJson(data) : null);
    map[_i1.getType<_i173.ScopeNoneFields?>()] = (data, protocol) =>
        (data != null ? _i173.ScopeNoneFields.fromJson(data) : null);
    map[_i1.getType<_i174.ScopeServerOnlyFieldChild?>()] = (data, protocol) =>
        (data != null ? _i174.ScopeServerOnlyFieldChild.fromJson(data) : null);
    map[_i1.getType<_i175.ScopeServerOnlyField?>()] = (data, protocol) =>
        (data != null ? _i175.ScopeServerOnlyField.fromJson(data) : null);
    map[_i1.getType<_i176.DefaultServerOnlyClass?>()] = (data, protocol) =>
        (data != null ? _i176.DefaultServerOnlyClass.fromJson(data) : null);
    map[_i1.getType<_i177.DefaultServerOnlyEnum?>()] = (data, protocol) =>
        (data != null ? _i177.DefaultServerOnlyEnum.fromJson(data) : null);
    map[_i1.getType<_i178.NotServerOnlyClass?>()] = (data, protocol) =>
        (data != null ? _i178.NotServerOnlyClass.fromJson(data) : null);
    map[_i1.getType<_i179.NotServerOnlyEnum?>()] = (data, protocol) =>
        (data != null ? _i179.NotServerOnlyEnum.fromJson(data) : null);
    map[_i1.getType<_i180.ServerOnlyClassField?>()] = (data, protocol) =>
        (data != null ? _i180.ServerOnlyClassField.fromJson(data) : null);
    map[_i1.getType<_i181.ServerOnlyDefault?>()] = (data, protocol) =>
        (data != null ? _i181.ServerOnlyDefault.fromJson(data) : null);
    map[_i1.getType<_i182.SessionAuthInfo?>()] = (data, protocol) =>
        (data != null ? _i182.SessionAuthInfo.fromJson(data) : null);
    map[_i1.getType<_i183.SharedModelContainer?>()] = (data, protocol) =>
        (data != null ? _i183.SharedModelContainer.fromJson(data) : null);
    map[_i1.getType<_i184.SharedModelSubclass?>()] = (data, protocol) =>
        (data != null ? _i184.SharedModelSubclass.fromJson(data) : null);
    map[_i1.getType<_i185.SimpleData?>()] = (data, protocol) =>
        (data != null ? _i185.SimpleData.fromJson(data) : null);
    map[_i1.getType<_i186.SimpleDataList?>()] = (data, protocol) =>
        (data != null ? _i186.SimpleDataList.fromJson(data) : null);
    map[_i1.getType<_i187.SimpleDataMap?>()] = (data, protocol) =>
        (data != null ? _i187.SimpleDataMap.fromJson(data) : null);
    map[_i1.getType<_i188.SimpleDataObject?>()] = (data, protocol) =>
        (data != null ? _i188.SimpleDataObject.fromJson(data) : null);
    map[_i1.getType<_i189.SimpleDateTime?>()] = (data, protocol) =>
        (data != null ? _i189.SimpleDateTime.fromJson(data) : null);
    map[_i1.getType<_i190.ModelInSubfolder?>()] = (data, protocol) =>
        (data != null ? _i190.ModelInSubfolder.fromJson(data) : null);
    map[_i1.getType<_i191.TestEnum?>()] = (data, protocol) =>
        (data != null ? _i191.TestEnum.fromJson(data) : null);
    map[_i1
        .getType<_i192.TestEnumDefaultSerialization?>()] = (data, protocol) =>
        (data != null
        ? _i192.TestEnumDefaultSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i193.TestEnumEnhanced?>()] = (data, protocol) =>
        (data != null ? _i193.TestEnumEnhanced.fromJson(data) : null);
    map[_i1.getType<_i194.TestEnumEnhancedByName?>()] = (data, protocol) =>
        (data != null ? _i194.TestEnumEnhancedByName.fromJson(data) : null);
    map[_i1.getType<_i195.TestEnumStringified?>()] = (data, protocol) =>
        (data != null ? _i195.TestEnumStringified.fromJson(data) : null);
    map[_i1.getType<_i196.Types?>()] = (data, protocol) =>
        (data != null ? _i196.Types.fromJson(data) : null);
    map[_i1.getType<_i197.TypesList?>()] = (data, protocol) =>
        (data != null ? _i197.TypesList.fromJson(data) : null);
    map[_i1.getType<_i198.TypesMap?>()] = (data, protocol) =>
        (data != null ? _i198.TypesMap.fromJson(data) : null);
    map[_i1.getType<_i199.TypesRecord?>()] = (data, protocol) =>
        (data != null ? _i199.TypesRecord.fromJson(data) : null);
    map[_i1.getType<_i200.TypesSet?>()] = (data, protocol) =>
        (data != null ? _i200.TypesSet.fromJson(data) : null);
    map[_i1.getType<_i201.TypesSetRequired?>()] = (data, protocol) =>
        (data != null ? _i201.TypesSetRequired.fromJson(data) : null);
    map[_i1.getType<_i202.UniqueData?>()] = (data, protocol) =>
        (data != null ? _i202.UniqueData.fromJson(data) : null);
    map[_i1.getType<_i203.UniqueDataWithNonPersist?>()] = (data, protocol) =>
        (data != null ? _i203.UniqueDataWithNonPersist.fromJson(data) : null);
    map[_i1.getType<_i204.UpsertTestModel?>()] = (data, protocol) =>
        (data != null ? _i204.UpsertTestModel.fromJson(data) : null);
    map[List<_i5.EnrollmentInt>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i5.EnrollmentInt>(e))
        .toList();
    map[_i1.getType<List<_i5.EnrollmentInt>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i5.EnrollmentInt>(e))
              .toList()
        : null);
    map[List<_i8.PlayerUuid>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i8.PlayerUuid>(e))
        .toList();
    map[_i1.getType<List<_i8.PlayerUuid>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i8.PlayerUuid>(e))
              .toList()
        : null);
    map[List<_i12.OrderUuid>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i12.OrderUuid>(e))
        .toList();
    map[_i1.getType<List<_i12.OrderUuid>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i12.OrderUuid>(e))
              .toList()
        : null);
    map[List<_i10.CommentInt>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i10.CommentInt>(e))
        .toList();
    map[_i1.getType<List<_i10.CommentInt>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i10.CommentInt>(e))
              .toList()
        : null);
    map[List<_i17.ChangedIdTypeSelf>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i17.ChangedIdTypeSelf>(e))
        .toList();
    map[_i1.getType<List<_i17.ChangedIdTypeSelf>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i17.ChangedIdTypeSelf>(e))
              .toList()
        : null);
    map[List<_i63.EmptyModelRelationItem>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i63.EmptyModelRelationItem>(e))
        .toList();
    map[_i1.getType<List<_i63.EmptyModelRelationItem>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i63.EmptyModelRelationItem>(e))
              .toList()
        : null);
    map[List<_i71.Employee>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i71.Employee>(e))
        .toList();
    map[_i1.getType<List<_i71.Employee>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i71.Employee>(e))
              .toList()
        : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[Map<String, String>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String>(v),
      ),
    );
    map[_i1.getType<(int, String)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<String>(data['p'][1]),
    );
    map[List<_i93.ChildEntity>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i93.ChildEntity>(e))
        .toList();
    map[_i1.getType<List<_i93.ChildEntity>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i93.ChildEntity>(e))
              .toList()
        : null);
    map[List<_i99.PolymorphicChild>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i99.PolymorphicChild>(e))
        .toList();
    map[List<_i99.PolymorphicChild?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i99.PolymorphicChild?>(e))
        .toList();
    map[Map<String, _i99.PolymorphicChild>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i99.PolymorphicChild>(v),
          ),
        );
    map[Map<String, _i99.PolymorphicChild?>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i99.PolymorphicChild?>(v),
          ),
        );
    map[List<_i205.ModulePolymorphicChild>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i205.ModulePolymorphicChild>(e))
        .toList();
    map[Map<String, _i205.ModulePolymorphicChild>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i205.ModulePolymorphicChild>(v),
          ),
        );
    map[List<_i109.PersonWithLongTableName>] = (data, protocol) =>
        (data as List)
            .map((e) => protocol.deserialize<_i109.PersonWithLongTableName>(e))
            .toList();
    map[_i1.getType<List<_i109.PersonWithLongTableName>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol.deserialize<_i109.PersonWithLongTableName>(e),
              )
              .toList()
        : null);
    map[List<_i108.OrganizationWithLongTableName>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<_i108.OrganizationWithLongTableName>(e),
            )
            .toList();
    map[_i1.getType<List<_i108.OrganizationWithLongTableName>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<_i108.OrganizationWithLongTableName>(e),
              )
              .toList()
        : null);
    map[List<_i111.LongImplicitIdField>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i111.LongImplicitIdField>(e))
        .toList();
    map[_i1.getType<List<_i111.LongImplicitIdField>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i111.LongImplicitIdField>(e))
              .toList()
        : null);
    map[List<_i118.MultipleMaxFieldName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i118.MultipleMaxFieldName>(e))
        .toList();
    map[_i1.getType<List<_i118.MultipleMaxFieldName>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i118.MultipleMaxFieldName>(e))
              .toList()
        : null);
    map[List<_i114.UserNote>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i114.UserNote>(e))
        .toList();
    map[_i1.getType<List<_i114.UserNote>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i114.UserNote>(e))
              .toList()
        : null);
    map[List<_i117.UserNoteWithALongName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i117.UserNoteWithALongName>(e))
        .toList();
    map[_i1.getType<List<_i117.UserNoteWithALongName>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i117.UserNoteWithALongName>(e))
              .toList()
        : null);
    map[List<_i121.Person>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i121.Person>(e))
        .toList();
    map[_i1.getType<List<_i121.Person>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i121.Person>(e))
              .toList()
        : null);
    map[List<_i120.Organization>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i120.Organization>(e))
        .toList();
    map[_i1.getType<List<_i120.Organization>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i120.Organization>(e))
              .toList()
        : null);
    map[List<_i123.Enrollment>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i123.Enrollment>(e))
        .toList();
    map[_i1.getType<List<_i123.Enrollment>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i123.Enrollment>(e))
              .toList()
        : null);
    map[List<_i128.Player>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i128.Player>(e))
        .toList();
    map[_i1.getType<List<_i128.Player>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i128.Player>(e))
              .toList()
        : null);
    map[List<_i134.Order>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i134.Order>(e))
        .toList();
    map[_i1.getType<List<_i134.Order>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i134.Order>(e))
              .toList()
        : null);
    map[List<_i133.Chapter>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i133.Chapter>(e))
        .toList();
    map[_i1.getType<List<_i133.Chapter>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i133.Chapter>(e))
              .toList()
        : null);
    map[List<_i130.Comment>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i130.Comment>(e))
        .toList();
    map[_i1.getType<List<_i130.Comment>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i130.Comment>(e))
              .toList()
        : null);
    map[List<_i139.Blocking>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i139.Blocking>(e))
        .toList();
    map[_i1.getType<List<_i139.Blocking>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i139.Blocking>(e))
              .toList()
        : null);
    map[List<_i141.Cat>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<_i141.Cat>(e)).toList();
    map[_i1.getType<List<_i141.Cat>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<_i141.Cat>(e)).toList()
        : null);
    map[List<_i205.ModuleClass>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i205.ModuleClass>(e))
        .toList();
    map[Map<String, _i205.ModuleClass>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i205.ModuleClass>(v),
      ),
    );
    map[_i1.getType<(_i205.ModuleClass,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i205.ModuleClass>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[_i1.getType<List<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toList()
        : null);
    map[List<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toList();
    map[List<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toList();
    map[_i1.getType<List<int?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int?>(e)).toList()
        : null);
    map[List<_i185.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData>(e))
        .toList();
    map[List<_i185.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i185.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i185.SimpleData>(e))
              .toList()
        : null);
    map[List<_i185.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData?>(e))
        .toList();
    map[List<_i185.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData?>(e))
        .toList();
    map[_i1.getType<List<_i185.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i185.SimpleData?>(e))
              .toList()
        : null);
    map[List<DateTime>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime>(e)).toList();
    map[List<DateTime>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime>(e)).toList();
    map[_i1.getType<List<DateTime>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<DateTime>(e)).toList()
        : null);
    map[List<DateTime?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime?>(e)).toList();
    map[List<DateTime?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime?>(e)).toList();
    map[_i1.getType<List<DateTime?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<DateTime?>(e)).toList()
        : null);
    map[List<_i206.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData>(e))
        .toList();
    map[List<_i206.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData>(e))
        .toList();
    map[_i1.getType<List<_i206.ByteData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i206.ByteData>(e))
              .toList()
        : null);
    map[List<_i206.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData?>(e))
        .toList();
    map[List<_i206.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData?>(e))
        .toList();
    map[_i1.getType<List<_i206.ByteData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i206.ByteData?>(e))
              .toList()
        : null);
    map[List<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toList();
    map[List<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toList();
    map[_i1.getType<List<Duration>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<Duration>(e)).toList()
        : null);
    map[List<Duration?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration?>(e)).toList();
    map[List<Duration?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration?>(e)).toList();
    map[_i1.getType<List<Duration?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<Duration?>(e)).toList()
        : null);
    map[List<_i1.UuidValue>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i1.UuidValue>(e))
        .toList();
    map[List<_i1.UuidValue>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i1.UuidValue>(e))
        .toList();
    map[_i1.getType<List<_i1.UuidValue>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i1.UuidValue>(e))
              .toList()
        : null);
    map[List<_i1.UuidValue?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i1.UuidValue?>(e))
        .toList();
    map[List<_i1.UuidValue?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i1.UuidValue?>(e))
        .toList();
    map[_i1.getType<List<_i1.UuidValue?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i1.UuidValue?>(e))
              .toList()
        : null);
    map[Map<String, int>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int>(v),
      ),
    );
    map[Map<String, int>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int>(v),
      ),
    );
    map[_i1.getType<Map<String, int>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<int>(v),
            ),
          )
        : null);
    map[Map<String, int?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int?>(v),
      ),
    );
    map[Map<String, int?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int?>(v),
      ),
    );
    map[_i1.getType<Map<String, int?>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<int?>(v),
            ),
          )
        : null);
    map[_i207.CustomClassWithoutProtocolSerialization] = (data, protocol) =>
        _i207.CustomClassWithoutProtocolSerialization.fromJson(data);
    map[_i207.CustomClassWithProtocolSerialization] = (data, protocol) =>
        _i207.CustomClassWithProtocolSerialization.fromJson(data);
    map[_i207.CustomClassWithProtocolSerializationMethod] = (data, protocol) =>
        _i207.CustomClassWithProtocolSerializationMethod.fromJson(data);
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[List<dynamic>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<dynamic>(e)).toList();
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[Map<String, dynamic>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<dynamic>(v),
      ),
    );
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[Set<dynamic>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<dynamic>(e)).toSet();
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[Map<dynamic, dynamic>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<dynamic>(e['k']),
          protocol.deserialize<dynamic>(e['v']),
        ),
      ),
    );
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[List<_i191.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i191.TestEnum>(e))
        .toList();
    map[List<_i191.TestEnum?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i191.TestEnum?>(e))
        .toList();
    map[List<List<_i191.TestEnum>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i191.TestEnum>>(e))
        .toList();
    map[List<_i191.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i191.TestEnum>(e))
        .toList();
    map[List<_i193.TestEnumEnhanced>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i193.TestEnumEnhanced>(e))
        .toList();
    map[List<_i194.TestEnumEnhancedByName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i194.TestEnumEnhancedByName>(e))
        .toList();
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[_i1.getType<List<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toList()
        : null);
    map[Map<String, _i185.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i185.SimpleData>(v),
      ),
    );
    map[Map<String, DateTime>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime>(v),
      ),
    );
    map[Map<String, _i206.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.ByteData>(v),
      ),
    );
    map[Map<String, Duration>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Duration>(v),
      ),
    );
    map[Map<String, _i1.UuidValue>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i1.UuidValue>(v),
      ),
    );
    map[Map<String, _i185.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i185.SimpleData?>(v),
      ),
    );
    map[Map<String, String?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String?>(v),
      ),
    );
    map[Map<String, DateTime?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime?>(v),
      ),
    );
    map[Map<String, _i206.ByteData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.ByteData?>(v),
      ),
    );
    map[Map<String, Duration?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Duration?>(v),
      ),
    );
    map[Map<String, _i1.UuidValue?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i1.UuidValue?>(v),
      ),
    );
    map[Map<int, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[_i1.getType<_i207.CustomClassWithoutProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithoutProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i207.CustomClassWithProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i207.CustomClassWithProtocolSerializationMethod?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithProtocolSerializationMethod.fromJson(data)
        : null);
    map[List<List<_i185.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i185.SimpleData>>(e))
        .toList();
    map[List<_i185.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData>(e))
        .toList();
    map[_i1.getType<List<List<_i185.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i185.SimpleData>>(e))
              .toList()
        : null);
    map[List<_i185.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i185.SimpleData>(e))
        .toList();
    map[Map<String, List<List<Map<int, _i185.SimpleData>>?>>] =
        (data, protocol) => (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<List<List<Map<int, _i185.SimpleData>>?>>(v),
          ),
        );
    map[List<List<Map<int, _i185.SimpleData>>?>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<List<Map<int, _i185.SimpleData>>?>(e),
            )
            .toList();
    map[List<Map<int, _i185.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<int, _i185.SimpleData>>(e))
        .toList();
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<List<Map<int, _i185.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<int, _i185.SimpleData>>(e))
              .toList()
        : null);
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<String, List<List<Map<int, _i185.SimpleData>>?>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<List<List<Map<int, _i185.SimpleData>>?>>(v),
            ),
          )
        : null);
    map[List<List<Map<int, _i185.SimpleData>>?>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<List<Map<int, _i185.SimpleData>>?>(e),
            )
            .toList();
    map[List<Map<int, _i185.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<int, _i185.SimpleData>>(e))
        .toList();
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<List<Map<int, _i185.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<int, _i185.SimpleData>>(e))
              .toList()
        : null);
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[Map<String, Map<int, _i185.SimpleData>>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<Map<int, _i185.SimpleData>>(v),
          ),
        );
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<String, Map<int, _i185.SimpleData>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Map<int, _i185.SimpleData>>(v),
            ),
          )
        : null);
    map[Map<int, _i185.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i185.SimpleData>(e['v']),
        ),
      ),
    );
    map[List<_i105.SealedParent>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i105.SealedParent>(e))
        .toList();
    map[_i1.getType<(bool,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[List<_i207.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i207.SharedModel>(e))
        .toList();
    map[List<_i207.SharedModel?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i207.SharedModel?>(e))
        .toList();
    map[List<_i207.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i207.SharedModel>(e))
        .toList();
    map[_i1.getType<List<_i207.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i207.SharedModel>(e))
              .toList()
        : null);
    map[Map<String, _i207.SharedModel>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i207.SharedModel>(v),
      ),
    );
    map[Map<String, _i207.SharedModel>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i207.SharedModel>(v),
      ),
    );
    map[_i1.getType<Map<String, _i207.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i207.SharedModel>(v),
            ),
          )
        : null);
    map[Map<String, _i207.SharedSubclass>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i207.SharedSubclass>(v),
          ),
        );
    map[Set<_i207.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i207.SharedModel>(e))
        .toSet();
    map[Set<_i207.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i207.SharedModel>(e))
        .toSet();
    map[_i1.getType<Set<_i207.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i207.SharedModel>(e))
              .toSet()
        : null);
    map[List<_i195.TestEnumStringified>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i195.TestEnumStringified>(e))
        .toList();
    map[_i1.getType<List<_i195.TestEnumStringified>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i195.TestEnumStringified>(e))
              .toList()
        : null);
    map[_i1.getType<(_i195.TestEnumStringified,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i195.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[List<(_i195.TestEnumStringified,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i195.TestEnumStringified,)>(e))
        .toList();
    map[_i1.getType<(_i195.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<List<(_i195.TestEnumStringified,)>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i195.TestEnumStringified,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i195.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i146.Nullability,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i146.Nullability>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i195.TestEnumStringified value})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            value: protocol.deserialize<_i195.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[List<({_i195.TestEnumStringified value})>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<({_i195.TestEnumStringified value})>(e),
            )
            .toList();
    map[_i1
        .getType<({_i195.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<List<({_i195.TestEnumStringified value})>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<({_i195.TestEnumStringified value})>(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<({_i195.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<({_i205.ModuleClass value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i205.ModuleClass>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[_i1.getType<({_i146.Nullability value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i146.Nullability>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[Map<int, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<int, int>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<int>(e['k']),
                protocol.deserialize<int>(e['v']),
              ),
            ),
          )
        : null);
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[_i1.getType<Set<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toSet()
        : null);
    map[_i1.getType<(String, {Uri? optionalUri})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                ? null
                : protocol.deserialize<Uri>(data['n']['optionalUri']),
          );
    map[List<bool>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool>(e)).toList();
    map[_i1.getType<List<bool>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<bool>(e)).toList()
        : null);
    map[List<double>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double>(e)).toList();
    map[_i1.getType<List<double>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<double>(e)).toList()
        : null);
    map[List<Uri>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Uri>(e)).toList();
    map[_i1.getType<List<Uri>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<Uri>(e)).toList()
        : null);
    map[List<BigInt>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<BigInt>(e)).toList();
    map[_i1.getType<List<BigInt>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<BigInt>(e)).toList()
        : null);
    map[List<_i191.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i191.TestEnum>(e))
        .toList();
    map[_i1.getType<List<_i191.TestEnum>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i191.TestEnum>(e))
              .toList()
        : null);
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[_i1.getType<List<_i196.Types>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i196.Types>(e))
              .toList()
        : null);
    map[List<Map<String, _i196.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, _i196.Types>>(e))
        .toList();
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[_i1.getType<List<Map<String, _i196.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<String, _i196.Types>>(e))
              .toList()
        : null);
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[List<List<_i196.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i196.Types>>(e))
        .toList();
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[_i1.getType<List<List<_i196.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i196.Types>>(e))
              .toList()
        : null);
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[List<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toList();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<List<(int,)>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)>(e)).toList()
        : null);
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<(int,)?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toList();
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<List<(int,)?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toList()
        : null);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<(_i191.TestEnum,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i191.TestEnum,)>(e))
        .toList();
    map[_i1.getType<(_i191.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i191.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<List<(_i191.TestEnum,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i191.TestEnum,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i191.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i191.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[Map<int, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<int, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<int>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<bool, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<bool>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<bool, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<bool>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<double, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<double>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<double, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<double>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<DateTime, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<DateTime>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<DateTime, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<DateTime>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<String, String>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String>(v),
      ),
    );
    map[_i1.getType<Map<String, String>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<String>(v),
            ),
          )
        : null);
    map[Map<_i206.ByteData, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i206.ByteData>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i206.ByteData, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i206.ByteData>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<Duration, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<Duration>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<Duration, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<Duration>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i1.UuidValue, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i1.UuidValue>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i1.UuidValue, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i1.UuidValue>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<Uri, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<Uri>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<Uri, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<Uri>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<BigInt, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<BigInt>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<BigInt, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<BigInt>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i191.TestEnum, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i191.TestEnum>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i191.TestEnum, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i191.TestEnum>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i195.TestEnumStringified, String>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<_i195.TestEnumStringified>(e['k']),
              protocol.deserialize<String>(e['v']),
            ),
          ),
        );
    map[_i1.getType<Map<_i195.TestEnumStringified, String>?>()] =
        (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i195.TestEnumStringified>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i196.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i196.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i196.Types, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i196.Types>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<Map<_i196.Types, String>, String>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<Map<_i196.Types, String>>(e['k']),
              protocol.deserialize<String>(e['v']),
            ),
          ),
        );
    map[Map<_i196.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i196.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<Map<_i196.Types, String>, String>?>()] =
        (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<Map<_i196.Types, String>>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i196.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i196.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[Map<List<_i196.Types>, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<List<_i196.Types>>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[_i1.getType<Map<List<_i196.Types>, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<List<_i196.Types>>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[Map<(String,), String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<(String,)>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<(String,), String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<(String,)>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<String, bool>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<bool>(v),
      ),
    );
    map[_i1.getType<Map<String, bool>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<bool>(v),
            ),
          )
        : null);
    map[Map<String, double>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<double>(v),
      ),
    );
    map[_i1.getType<Map<String, double>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<double>(v),
            ),
          )
        : null);
    map[Map<String, DateTime>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime>(v),
      ),
    );
    map[_i1.getType<Map<String, DateTime>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<DateTime>(v),
            ),
          )
        : null);
    map[Map<String, _i206.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.ByteData>(v),
      ),
    );
    map[_i1.getType<Map<String, _i206.ByteData>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i206.ByteData>(v),
            ),
          )
        : null);
    map[Map<String, Duration>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Duration>(v),
      ),
    );
    map[_i1.getType<Map<String, Duration>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Duration>(v),
            ),
          )
        : null);
    map[Map<String, _i1.UuidValue>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i1.UuidValue>(v),
      ),
    );
    map[_i1.getType<Map<String, _i1.UuidValue>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i1.UuidValue>(v),
            ),
          )
        : null);
    map[Map<String, Uri>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Uri>(v),
      ),
    );
    map[_i1.getType<Map<String, Uri>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Uri>(v),
            ),
          )
        : null);
    map[Map<String, BigInt>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<BigInt>(v),
      ),
    );
    map[_i1.getType<Map<String, BigInt>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<BigInt>(v),
            ),
          )
        : null);
    map[Map<String, _i191.TestEnum>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i191.TestEnum>(v),
      ),
    );
    map[_i1.getType<Map<String, _i191.TestEnum>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i191.TestEnum>(v),
            ),
          )
        : null);
    map[Map<String, _i195.TestEnumStringified>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i195.TestEnumStringified>(v),
          ),
        );
    map[_i1.getType<Map<String, _i195.TestEnumStringified>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i195.TestEnumStringified>(v),
            ),
          )
        : null);
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[_i1.getType<Map<String, _i196.Types>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i196.Types>(v),
            ),
          )
        : null);
    map[Map<String, Map<String, _i196.Types>>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<Map<String, _i196.Types>>(v),
          ),
        );
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[_i1.getType<Map<String, Map<String, _i196.Types>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Map<String, _i196.Types>>(v),
            ),
          )
        : null);
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[Map<String, List<_i196.Types>>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<List<_i196.Types>>(v),
      ),
    );
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[_i1.getType<Map<String, List<_i196.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<List<_i196.Types>>(v),
            ),
          )
        : null);
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[Map<String, (String,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(String,)>(v),
      ),
    );
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<String, (String,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<(String,)>(v),
            ),
          )
        : null);
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<String, (String,)?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(String,)?>(v),
      ),
    );
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<String, (String,)?>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<(String,)?>(v),
            ),
          )
        : null);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<(String,)?, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<(String,)?>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<(String,)?, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<(String,)?>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(double,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<double>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(DateTime,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<DateTime>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i206.ByteData,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i206.ByteData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(Duration,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Duration>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i1.UuidValue,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i1.UuidValue>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(Uri,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Uri>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(BigInt,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<BigInt>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i191.TestEnum,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i191.TestEnum>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(List<int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<List<int>>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(Map<int, int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<Map<int, int>>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(Set<int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Set<int>>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i185.SimpleData,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i185.SimpleData namedModel})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            namedModel: protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['n'] as Map)['namedModel'],
            ),
          );
    map[_i1.getType<(_i185.SimpleData, {_i185.SimpleData namedModel})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            namedModel: protocol.deserialize<_i185.SimpleData>(
              data['n']['namedModel'],
            ),
          );
    map[_i1.getType<((int, String), {(int, String) namedNestedRecord})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol.deserialize<(int, String)>(
              data['n']['namedNestedRecord'],
            ),
          );
    map[_i1
        .getType<
          (
            (List<(_i185.SimpleData,)>,), {
            (_i185.SimpleData, Map<String, _i185.SimpleData>) namedNestedRecord,
          })?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(List<(_i185.SimpleData,)>,)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol
                .deserialize<(_i185.SimpleData, Map<String, _i185.SimpleData>)>(
                  data['n']['namedNestedRecord'],
                ),
          );
    map[Set<bool>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool>(e)).toSet();
    map[_i1.getType<Set<bool>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<bool>(e)).toSet()
        : null);
    map[Set<double>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double>(e)).toSet();
    map[_i1.getType<Set<double>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<double>(e)).toSet()
        : null);
    map[Set<DateTime>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime>(e)).toSet();
    map[_i1.getType<Set<DateTime>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<DateTime>(e)).toSet()
        : null);
    map[Set<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toSet();
    map[_i1.getType<Set<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toSet()
        : null);
    map[Set<_i206.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData>(e))
        .toSet();
    map[_i1.getType<Set<_i206.ByteData>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i206.ByteData>(e))
              .toSet()
        : null);
    map[Set<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toSet();
    map[_i1.getType<Set<Duration>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<Duration>(e)).toSet()
        : null);
    map[Set<_i1.UuidValue>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i1.UuidValue>(e))
        .toSet();
    map[_i1.getType<Set<_i1.UuidValue>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i1.UuidValue>(e))
              .toSet()
        : null);
    map[Set<BigInt>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<BigInt>(e)).toSet();
    map[_i1.getType<Set<BigInt>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<BigInt>(e)).toSet()
        : null);
    map[Set<_i191.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i191.TestEnum>(e))
        .toSet();
    map[_i1.getType<Set<_i191.TestEnum>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i191.TestEnum>(e))
              .toSet()
        : null);
    map[Set<_i195.TestEnumStringified>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i195.TestEnumStringified>(e))
        .toSet();
    map[_i1.getType<Set<_i195.TestEnumStringified>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i195.TestEnumStringified>(e))
              .toSet()
        : null);
    map[Set<_i196.Types>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<_i196.Types>(e)).toSet();
    map[_i1.getType<Set<_i196.Types>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i196.Types>(e))
              .toSet()
        : null);
    map[Set<Map<String, _i196.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, _i196.Types>>(e))
        .toSet();
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[_i1.getType<Set<Map<String, _i196.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<String, _i196.Types>>(e))
              .toSet()
        : null);
    map[Map<String, _i196.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i196.Types>(v),
      ),
    );
    map[Set<List<_i196.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i196.Types>>(e))
        .toSet();
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[_i1.getType<Set<List<_i196.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i196.Types>>(e))
              .toSet()
        : null);
    map[List<_i196.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i196.Types>(e))
        .toList();
    map[Set<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Set<(int,)>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet()
        : null);
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[Set<(int,)?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toSet();
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Set<(int,)?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toSet()
        : null);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[_i1.getType<List<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toList()
        : null);
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[List<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<List<int>>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<List<int>>(e)).toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[_i1.getType<List<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toList()
        : null);
    map[List<List<int>?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<List<int>?>(e)).toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[_i1.getType<List<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toList()
        : null);
    map[List<List<int>>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<List<int>>(e)).toList();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[_i1.getType<List<List<int>>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<List<int>>(e)).toList()
        : null);
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toList();
    map[List<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toList();
    map[_i1.getType<List<int?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int?>(e)).toList()
        : null);
    map[List<double>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double>(e)).toList();
    map[List<double?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double?>(e)).toList();
    map[List<bool>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool>(e)).toList();
    map[List<bool?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool?>(e)).toList();
    map[List<String?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String?>(e)).toList();
    map[List<DateTime>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime>(e)).toList();
    map[List<DateTime?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime?>(e)).toList();
    map[List<_i206.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData>(e))
        .toList();
    map[List<_i206.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData?>(e))
        .toList();
    map[List<_i208.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData?>(e))
        .toList();
    map[List<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i208.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i208.SimpleData>(e))
              .toList()
        : null);
    map[List<_i208.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData?>(e))
        .toList();
    map[_i1.getType<List<_i208.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i208.SimpleData?>(e))
              .toList()
        : null);
    map[List<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toList();
    map[List<Duration?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration?>(e)).toList();
    map[Map<String, int>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int>(v),
      ),
    );
    map[Map<String, int>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int>(v),
      ),
    );
    map[_i1.getType<Map<String, int>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<int>(v),
            ),
          )
        : null);
    map[Map<String, Map<String, int>>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Map<String, int>>(v),
      ),
    );
    map[Map<String, int>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int>(v),
      ),
    );
    map[Map<String, int?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int?>(v),
      ),
    );
    map[Map<String, int?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<int?>(v),
      ),
    );
    map[_i1.getType<Map<String, int?>?>()] = (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<int?>(v),
            ),
          )
        : null);
    map[Map<int, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[Map<String, Map<int, int>>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Map<int, int>>(v),
      ),
    );
    map[Map<int, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[Map<_i209.TestEnum, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i209.TestEnum>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[Map<String, _i209.TestEnum>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i209.TestEnum>(v),
      ),
    );
    map[Map<String, double>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<double>(v),
      ),
    );
    map[Map<String, double?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<double?>(v),
      ),
    );
    map[Map<String, bool>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<bool>(v),
      ),
    );
    map[Map<String, bool?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<bool?>(v),
      ),
    );
    map[Map<String, String>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String>(v),
      ),
    );
    map[Map<String, String?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<String?>(v),
      ),
    );
    map[Map<String, DateTime>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime>(v),
      ),
    );
    map[Map<String, DateTime?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime?>(v),
      ),
    );
    map[Map<String, _i206.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.ByteData>(v),
      ),
    );
    map[Map<String, _i206.ByteData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.ByteData?>(v),
      ),
    );
    map[Map<String, _i208.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i208.SimpleData>(v),
      ),
    );
    map[Map<String, _i208.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i208.SimpleData?>(v),
      ),
    );
    map[Map<String, _i208.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i208.SimpleData>(v),
      ),
    );
    map[_i1.getType<Map<String, _i208.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i208.SimpleData>(v),
            ),
          )
        : null);
    map[Map<String, _i208.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i208.SimpleData?>(v),
      ),
    );
    map[_i1.getType<Map<String, _i208.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i208.SimpleData?>(v),
            ),
          )
        : null);
    map[Map<String, Duration>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Duration>(v),
      ),
    );
    map[Map<String, Duration?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<Duration?>(v),
      ),
    );
    map[Map<(Map<int, String>, String), String>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<(Map<int, String>, String)>(e['k']),
              protocol.deserialize<String>(e['v']),
            ),
          ),
        );
    map[_i1.getType<(Map<int, String>, String)>()] = (data, protocol) => (
      protocol.deserialize<Map<int, String>>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<String>(data['p'][1]),
    );
    map[_i1.getType<(Map<int, String>, String)>()] = (data, protocol) => (
      protocol.deserialize<Map<int, String>>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<String>(data['p'][1]),
    );
    map[Map<int, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[Map<String, (Map<int, int>,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(Map<int, int>,)>(v),
      ),
    );
    map[_i1.getType<(Map<int, int>,)>()] = (data, protocol) =>
        (protocol.deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(Map<int, int>,)>()] = (data, protocol) =>
        (protocol.deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),);
    map[Map<DateTime, bool>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<DateTime>(e['k']),
          protocol.deserialize<bool>(e['v']),
        ),
      ),
    );
    map[Map<DateTime, bool>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<DateTime>(e['k']),
          protocol.deserialize<bool>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<DateTime, bool>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<DateTime>(e['k']),
                protocol.deserialize<bool>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<int, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<int, String>?>()] = (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<int>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[dynamic] = (data, protocol) => deserializeDynamicFieldValue(data) as T;
    map[List<_i210.UserInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i210.UserInfo>(e))
        .toList();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toSet();
    map[List<Set<_i208.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<_i208.SimpleData>>(e))
        .toList();
    map[Set<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toSet();
    map[_i1.getType<(int, BigInt)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<BigInt>(data['p'][1]),
    );
    map[_i1.getType<(String, _i211.PolymorphicParent)>()] = (data, protocol) =>
        (
          protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
          protocol.deserialize<_i211.PolymorphicParent>(data['p'][1]),
        );
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(int?,)>()] = (data, protocol) => (
      ((data as Map)['p'] as List)[0] == null
          ? null
          : protocol.deserialize<int>(data['p'][0]),
    );
    map[_i1.getType<(int?,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : protocol.deserialize<int>(data['p'][0]),
          );
    map[_i1.getType<(int, String)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<String>(data['p'][1]),
    );
    map[_i1.getType<(int, String)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<String>(data['p'][1]),
          );
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[_i1.getType<(int, _i208.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i208.SimpleData>(data['p'][1]),
          );
    map[_i1.getType<(Map<String, int>,)>()] = (data, protocol) => (
      protocol.deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(Set<(int,)>,)>()] = (data, protocol) =>
        (protocol.deserialize<Set<(int,)>>(((data as Map)['p'] as List)[0]),);
    map[Set<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<({int number, String text})>()] = (data, protocol) => (
      number: protocol.deserialize<int>(((data as Map)['n'] as Map)['number']),
      text: protocol.deserialize<String>(data['n']['text']),
    );
    map[_i1.getType<({int number, String text})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            number: protocol.deserialize<int>(
              ((data as Map)['n'] as Map)['number'],
            ),
            text: protocol.deserialize<String>(data['n']['text']),
          );
    map[_i1.getType<({_i208.SimpleData data, int number})>()] =
        (data, protocol) => (
          data: protocol.deserialize<_i208.SimpleData>(
            ((data as Map)['n'] as Map)['data'],
          ),
          number: protocol.deserialize<int>(data['n']['number']),
        );
    map[_i1.getType<({_i208.SimpleData data, int number})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            data: protocol.deserialize<_i208.SimpleData>(
              ((data as Map)['n'] as Map)['data'],
            ),
            number: protocol.deserialize<int>(data['n']['number']),
          );
    map[_i1.getType<({_i208.SimpleData? data, int? number})>()] =
        (data, protocol) => (
          data: ((data as Map)['n'] as Map)['data'] == null
              ? null
              : protocol.deserialize<_i208.SimpleData>(data['n']['data']),
          number: ((data)['n'] as Map)['number'] == null
              ? null
              : protocol.deserialize<int>(data['n']['number']),
        );
    map[_i1.getType<({Map<int, int> intIntMap})>()] = (data, protocol) => (
      intIntMap: protocol.deserialize<Map<int, int>>(
        ((data as Map)['n'] as Map)['intIntMap'],
      ),
    );
    map[_i1.getType<({Set<(bool,)> boolSet})>()] = (data, protocol) => (
      boolSet: protocol.deserialize<Set<(bool,)>>(
        ((data as Map)['n'] as Map)['boolSet'],
      ),
    );
    map[Set<(bool,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(bool,)>(e)).toSet();
    map[_i1.getType<(bool,)>()] = (data, protocol) =>
        (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(bool,)>()] = (data, protocol) =>
        (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(Map<(Map<int, String>, String), String>,)>()] =
        (data, protocol) => (
          protocol.deserialize<Map<(Map<int, String>, String), String>>(
            ((data as Map)['p'] as List)[0],
          ),
        );
    map[_i1.getType<(int, {_i208.SimpleData data})>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      data: protocol.deserialize<_i208.SimpleData>(data['n']['data']),
    );
    map[_i1.getType<(int, {_i208.SimpleData data})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            data: protocol.deserialize<_i208.SimpleData>(data['n']['data']),
          );
    map[List<(int, _i208.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i208.SimpleData)>(e))
        .toList();
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[List<(int, _i208.SimpleData)?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i208.SimpleData)?>(e))
        .toList();
    map[_i1.getType<(int, _i208.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i208.SimpleData>(data['p'][1]),
          );
    map[Set<(int, _i208.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i208.SimpleData)>(e))
        .toSet();
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[Set<(int, _i208.SimpleData)?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i208.SimpleData)?>(e))
        .toSet();
    map[_i1.getType<(int, _i208.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i208.SimpleData>(data['p'][1]),
          );
    map[Set<(int, _i208.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i208.SimpleData)>(e))
        .toSet();
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[_i1.getType<Set<(int, _i208.SimpleData)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(int, _i208.SimpleData)>(e))
              .toSet()
        : null);
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[Map<String, (int, _i208.SimpleData)>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<(int, _i208.SimpleData)>(v),
          ),
        );
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[Map<String, (int, _i208.SimpleData)?>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<(int, _i208.SimpleData)?>(v),
          ),
        );
    map[_i1.getType<(int, _i208.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i208.SimpleData>(data['p'][1]),
          );
    map[Map<(String, int), (int, _i208.SimpleData)>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<(String, int)>(e['k']),
              protocol.deserialize<(int, _i208.SimpleData)>(e['v']),
            ),
          ),
        );
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1.getType<(int, _i208.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i208.SimpleData>(data['p'][1]),
    );
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[Map<String, List<Set<(int,)>>>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<List<Set<(int,)>>>(v),
      ),
    );
    map[List<Set<(int,)>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<(int,)>>(e))
        .toList();
    map[Set<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<Set<(int,)>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<(int,)>>(e))
        .toList();
    map[Set<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[Set<List<Map<String, (int,)>>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<Map<String, (int,)>>>(e))
        .toSet();
    map[List<Map<String, (int,)>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, (int,)>>(e))
        .toList();
    map[Map<String, (int,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(int,)>(v),
      ),
    );
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<Map<String, (int,)>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, (int,)>>(e))
        .toList();
    map[Map<String, (int,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(int,)>(v),
      ),
    );
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[Map<String, (int,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(int,)>(v),
      ),
    );
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<({(_i208.SimpleData, double) namedSubRecord})>()] =
        (data, protocol) => (
          namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
            ((data as Map)['n'] as Map)['namedSubRecord'],
          ),
        );
    map[_i1.getType<(_i208.SimpleData, double)>()] = (data, protocol) => (
      protocol.deserialize<_i208.SimpleData>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<double>(data['p'][1]),
    );
    map[_i1.getType<({(_i208.SimpleData, double)? namedSubRecord})>()] =
        (data, protocol) => (
          namedSubRecord: ((data as Map)['n'] as Map)['namedSubRecord'] == null
              ? null
              : protocol.deserialize<(_i208.SimpleData, double)>(
                  data['n']['namedSubRecord'],
                ),
        );
    map[_i1.getType<(_i208.SimpleData, double)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i208.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            protocol.deserialize<double>(data['p'][1]),
          );
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})
        >()] = (data, protocol) => (
      protocol.deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
      namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
        data['n']['namedSubRecord'],
      ),
    );
    map[List<((int, String), {(_i208.SimpleData, double) namedSubRecord})>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    ((int, String), {(_i208.SimpleData, double) namedSubRecord})
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})
        >()] = (data, protocol) => (
      protocol.deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
      namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
        data['n']['namedSubRecord'],
      ),
    );
    map[List<((int, String), {(_i208.SimpleData, double) namedSubRecord})?>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    (
                      (int, String), {
                      (_i208.SimpleData, double) namedSubRecord,
                    })?
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          List<((int, String), {(_i208.SimpleData, double) namedSubRecord})?>?
        >()] = (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) =>
                    protocol.deserialize<
                      (
                        (int, String), {
                        (_i208.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1.getType<(int?, _i205.ProjectStreamingClass?)>()] =
        (data, protocol) => (
          ((data as Map)['p'] as List)[0] == null
              ? null
              : protocol.deserialize<int>(data['p'][0]),
          ((data)['p'] as List)[1] == null
              ? null
              : protocol.deserialize<_i205.ProjectStreamingClass>(data['p'][1]),
        );
    map[Set<Set<int>>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Set<int>>(e)).toSet();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<List<int>>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<List<int>>(e)).toSet();
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[_i1.getType<Set<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toSet()
        : null);
    map[Set<Set<int>?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Set<int>?>(e)).toSet();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[_i1.getType<Set<int>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int>(e)).toSet()
        : null);
    map[Set<Set<int>>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Set<int>>(e)).toSet();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[_i1.getType<Set<Set<int>>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<Set<int>>(e)).toSet()
        : null);
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toSet();
    map[Set<int?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int?>(e)).toSet();
    map[_i1.getType<Set<int?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<int?>(e)).toSet()
        : null);
    map[Set<double>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double>(e)).toSet();
    map[Set<double?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<double?>(e)).toSet();
    map[Set<bool>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool>(e)).toSet();
    map[Set<bool?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<bool?>(e)).toSet();
    map[Set<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toSet();
    map[Set<String?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String?>(e)).toSet();
    map[Set<DateTime>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime>(e)).toSet();
    map[Set<DateTime?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<DateTime?>(e)).toSet();
    map[Set<_i206.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData>(e))
        .toSet();
    map[Set<_i206.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.ByteData?>(e))
        .toSet();
    map[Set<_i208.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData?>(e))
        .toSet();
    map[Set<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toSet();
    map[Set<Duration?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration?>(e)).toSet();
    map[List<_i212.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i212.Types>(e))
        .toList();
    map[_i1.getType<(String, (int, bool))>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<(int, bool)>(data['p'][1]),
    );
    map[_i1.getType<(int, bool)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<bool>(data['p'][1]),
    );
    map[List<(String, (int, bool))>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(String, (int, bool))>(e))
        .toList();
    map[_i1.getType<(String, (int, bool))>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<(int, bool)>(data['p'][1]),
    );
    map[_i1
        .getType<
          (String, (Map<String, int>, {bool flag, _i208.SimpleData simpleData}))
        >()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<
        (Map<String, int>, {bool flag, _i208.SimpleData simpleData})
      >(data['p'][1]),
    );
    map[_i1
        .getType<
          (Map<String, int>, {bool flag, _i208.SimpleData simpleData})
        >()] = (data, protocol) => (
      protocol.deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
      flag: protocol.deserialize<bool>(data['n']['flag']),
      simpleData: protocol.deserialize<_i208.SimpleData>(
        data['n']['simpleData'],
      ),
    );
    map[List<(String, int)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(String, int)>(e))
        .toList();
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1
        .getType<
          (
            String,
            (Map<String, int>, {bool flag, _i208.SimpleData simpleData}),
          )?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<
              (Map<String, int>, {bool flag, _i208.SimpleData simpleData})
            >(data['p'][1]),
          );
    map[List<(String, int)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(String, int)>(e))
        .toList();
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1.getType<List<(String, int)>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(String, int)>(e))
              .toList()
        : null);
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1.getType<(int, String)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<String>(data['p'][1]),
    );
    map[_i1.getType<(_i205.ModuleClass,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i205.ModuleClass>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(bool,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i195.TestEnumStringified,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i195.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[List<(_i195.TestEnumStringified,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i195.TestEnumStringified,)>(e))
        .toList();
    map[_i1.getType<(_i195.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<List<(_i195.TestEnumStringified,)>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i195.TestEnumStringified,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i195.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i195.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i146.Nullability,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i146.Nullability>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i195.TestEnumStringified value})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            value: protocol.deserialize<_i195.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[List<({_i195.TestEnumStringified value})>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<({_i195.TestEnumStringified value})>(e),
            )
            .toList();
    map[_i1
        .getType<({_i195.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<List<({_i195.TestEnumStringified value})>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<({_i195.TestEnumStringified value})>(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<({_i195.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1
        .getType<({_i195.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i195.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<({_i205.ModuleClass value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i205.ModuleClass>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[_i1.getType<({_i146.Nullability value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i146.Nullability>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[_i1.getType<(String, {Uri? optionalUri})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                ? null
                : protocol.deserialize<Uri>(data['n']['optionalUri']),
          );
    map[List<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toList();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<List<(int,)>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)>(e)).toList()
        : null);
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<(int,)?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toList();
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<List<(int,)?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toList()
        : null);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[List<(_i191.TestEnum,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i191.TestEnum,)>(e))
        .toList();
    map[_i1.getType<(_i191.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i191.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<List<(_i191.TestEnum,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i191.TestEnum,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i191.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i191.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i191.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i191.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[Map<(String,), String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<(String,)>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<(String,), String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<(String,)>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<String, (String,)>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(String,)>(v),
      ),
    );
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<String, (String,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<(String,)>(v),
            ),
          )
        : null);
    map[_i1.getType<(String,)>()] = (data, protocol) =>
        (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<String, (String,)?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<(String,)?>(v),
      ),
    );
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<String, (String,)?>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<(String,)?>(v),
            ),
          )
        : null);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[Map<(String,)?, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<(String,)?>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Map<(String,)?, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<(String,)?>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[_i1.getType<(String,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<String>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(double,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<double>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(DateTime,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<DateTime>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i206.ByteData,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i206.ByteData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(Duration,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Duration>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i1.UuidValue,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i1.UuidValue>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(Uri,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Uri>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(BigInt,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<BigInt>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i191.TestEnum,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i191.TestEnum>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(List<int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<List<int>>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(Map<int, int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<Map<int, int>>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[Map<int, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[_i1.getType<(Set<int>,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<Set<int>>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i185.SimpleData,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i185.SimpleData namedModel})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            namedModel: protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['n'] as Map)['namedModel'],
            ),
          );
    map[_i1.getType<(_i185.SimpleData, {_i185.SimpleData namedModel})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i185.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            namedModel: protocol.deserialize<_i185.SimpleData>(
              data['n']['namedModel'],
            ),
          );
    map[_i1.getType<((int, String), {(int, String) namedNestedRecord})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol.deserialize<(int, String)>(
              data['n']['namedNestedRecord'],
            ),
          );
    map[_i1
        .getType<
          (
            (List<(_i185.SimpleData,)>,), {
            (_i185.SimpleData, Map<String, _i185.SimpleData>) namedNestedRecord,
          })?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(List<(_i185.SimpleData,)>,)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol
                .deserialize<(_i185.SimpleData, Map<String, _i185.SimpleData>)>(
                  data['n']['namedNestedRecord'],
                ),
          );
    map[_i1.getType<(List<(_i185.SimpleData,)>,)>()] = (data, protocol) => (
      protocol.deserialize<List<(_i185.SimpleData,)>>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[List<(_i185.SimpleData,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i185.SimpleData,)>(e))
        .toList();
    map[_i1.getType<(_i185.SimpleData,)>()] = (data, protocol) => (
      protocol.deserialize<_i185.SimpleData>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i185.SimpleData,)>()] = (data, protocol) => (
      protocol.deserialize<_i185.SimpleData>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i185.SimpleData, Map<String, _i185.SimpleData>)>()] =
        (data, protocol) => (
          protocol.deserialize<_i185.SimpleData>(
            ((data as Map)['p'] as List)[0],
          ),
          protocol.deserialize<Map<String, _i185.SimpleData>>(data['p'][1]),
        );
    map[Map<String, _i185.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i185.SimpleData>(v),
      ),
    );
    map[Set<(int,)>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet();
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Set<(int,)>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)>(e)).toSet()
        : null);
    map[_i1.getType<(int,)>()] = (data, protocol) =>
        (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[Set<(int,)?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toSet();
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<Set<(int,)?>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<(int,)?>(e)).toSet()
        : null);
    map[_i1.getType<(int,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<int>(((data as Map)['p'] as List)[0]),);
    map[_i207.CustomClass] = (data, protocol) =>
        _i207.CustomClass.fromJson(data);
    map[_i207.CustomClass2] = (data, protocol) =>
        _i207.CustomClass2.fromJson(data);
    map[_i207.CustomClassWithoutProtocolSerialization] = (data, protocol) =>
        _i207.CustomClassWithoutProtocolSerialization.fromJson(data);
    map[_i207.CustomClassWithProtocolSerialization] = (data, protocol) =>
        _i207.CustomClassWithProtocolSerialization.fromJson(data);
    map[_i207.CustomClassWithProtocolSerializationMethod] = (data, protocol) =>
        _i207.CustomClassWithProtocolSerializationMethod.fromJson(data);
    map[_i207.ProtocolCustomClass] = (data, protocol) =>
        _i207.ProtocolCustomClass.fromJson(data);
    map[_i207.ExternalCustomClass] = (data, protocol) =>
        _i207.ExternalCustomClass.fromJson(data);
    map[_i207.FreezedCustomClass] = (data, protocol) =>
        _i207.FreezedCustomClass.fromJson(data);
    map[_i1.getType<_i207.CustomClass?>()] = (data, protocol) =>
        (data != null ? _i207.CustomClass.fromJson(data) : null);
    map[_i1.getType<_i207.CustomClass2?>()] = (data, protocol) =>
        (data != null ? _i207.CustomClass2.fromJson(data) : null);
    map[_i1.getType<_i207.CustomClassWithoutProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithoutProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i207.CustomClassWithProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i207.CustomClassWithProtocolSerializationMethod?>()] =
        (data, protocol) => (data != null
        ? _i207.CustomClassWithProtocolSerializationMethod.fromJson(data)
        : null);
    map[_i1.getType<_i207.ProtocolCustomClass?>()] = (data, protocol) =>
        (data != null ? _i207.ProtocolCustomClass.fromJson(data) : null);
    map[_i1.getType<_i207.ExternalCustomClass?>()] = (data, protocol) =>
        (data != null ? _i207.ExternalCustomClass.fromJson(data) : null);
    map[_i1.getType<_i207.FreezedCustomClass?>()] = (data, protocol) =>
        (data != null ? _i207.FreezedCustomClass.fromJson(data) : null);
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toList();
    map[List<_i210.UserInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i210.UserInfo>(e))
        .toList();
    map[List<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i208.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i208.SimpleData>(e))
              .toList()
        : null);
    map[List<_i208.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData?>(e))
        .toList();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toSet();
    map[List<Set<_i208.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<_i208.SimpleData>>(e))
        .toList();
    map[Set<_i208.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.SimpleData>(e))
        .toSet();
    map[_i1.getType<(String, _i211.PolymorphicParent)>()] = (data, protocol) =>
        (
          protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
          protocol.deserialize<_i211.PolymorphicParent>(data['p'][1]),
        );
    map[_i1.getType<(int?,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : protocol.deserialize<int>(data['p'][0]),
          );
    map[List<((int, String), {(_i208.SimpleData, double) namedSubRecord})?>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    (
                      (int, String), {
                      (_i208.SimpleData, double) namedSubRecord,
                    })?
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          List<((int, String), {(_i208.SimpleData, double) namedSubRecord})?>?
        >()] = (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) =>
                    protocol.deserialize<
                      (
                        (int, String), {
                        (_i208.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i208.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1.getType<(int?, _i205.ProjectStreamingClass?)>()] =
        (data, protocol) => (
          ((data as Map)['p'] as List)[0] == null
              ? null
              : protocol.deserialize<int>(data['p'][0]),
          ((data)['p'] as List)[1] == null
              ? null
              : protocol.deserialize<_i205.ProjectStreamingClass>(data['p'][1]),
        );
    map[_i1
        .getType<
          (String, (Map<String, int>, {bool flag, _i208.SimpleData simpleData}))
        >()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<
        (Map<String, int>, {bool flag, _i208.SimpleData simpleData})
      >(data['p'][1]),
    );
    map[List<(String, int)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(String, int)>(e))
        .toList();
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1
        .getType<
          (
            String,
            (Map<String, int>, {bool flag, _i208.SimpleData simpleData}),
          )?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<
              (Map<String, int>, {bool flag, _i208.SimpleData simpleData})
            >(data['p'][1]),
          );
    map[List<(String, int)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(String, int)>(e))
        .toList();
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1.getType<List<(String, int)>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(String, int)>(e))
              .toList()
        : null);
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    return map;
  }

  static String? getClassNameFromObjectJson(dynamic data) {
    if (data is! Map) return null;
    final className = data['__className__'] as String?;
    return className;
  }

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;

    final dataClassName = getClassNameFromObjectJson(data);
    if (dataClassName != null && dataClassName != getClassNameForType(t)) {
      try {
        return deserializeByClassName({
          'className': dataClassName,
          'data': data,
        });
      } on FormatException catch (_) {
        // If the className is not recognized (e.g., older client receiving
        // data with a new subtype), fall back to deserializing without the
        // className, using the expected type T.
      }
    }

    final fn = _deserializers[t];
    if (fn != null) {
      return fn(data, this) as T;
    }
    try {
      return _i210.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i205.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i207.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i207.CustomClass => 'CustomClass',
      _i207.CustomClass2 => 'CustomClass2',
      _i207.CustomClassWithoutProtocolSerialization =>
        'CustomClassWithoutProtocolSerialization',
      _i207.CustomClassWithProtocolSerialization =>
        'CustomClassWithProtocolSerialization',
      _i207.CustomClassWithProtocolSerializationMethod =>
        'CustomClassWithProtocolSerializationMethod',
      _i207.ProtocolCustomClass => 'ProtocolCustomClass',
      _i207.ExternalCustomClass => 'ExternalCustomClass',
      _i207.FreezedCustomClass => 'FreezedCustomClass',
      _i2.ByIndexEnumWithNameValue => 'ByIndexEnumWithNameValue',
      _i3.ByNameEnumWithNameValue => 'ByNameEnumWithNameValue',
      _i4.CourseUuid => 'CourseUuid',
      _i5.EnrollmentInt => 'EnrollmentInt',
      _i6.StudentUuid => 'StudentUuid',
      _i7.ArenaUuid => 'ArenaUuid',
      _i8.PlayerUuid => 'PlayerUuid',
      _i9.TeamInt => 'TeamInt',
      _i10.CommentInt => 'CommentInt',
      _i11.CustomerInt => 'CustomerInt',
      _i12.OrderUuid => 'OrderUuid',
      _i13.AddressUuid => 'AddressUuid',
      _i14.CitizenInt => 'CitizenInt',
      _i15.CompanyUuid => 'CompanyUuid',
      _i16.TownInt => 'TownInt',
      _i17.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _i18.BigIntDefault => 'BigIntDefault',
      _i19.BigIntDefaultMix => 'BigIntDefaultMix',
      _i20.BigIntDefaultModel => 'BigIntDefaultModel',
      _i21.BigIntDefaultPersist => 'BigIntDefaultPersist',
      _i22.BoolDefault => 'BoolDefault',
      _i23.BoolDefaultMix => 'BoolDefaultMix',
      _i24.BoolDefaultModel => 'BoolDefaultModel',
      _i25.BoolDefaultPersist => 'BoolDefaultPersist',
      _i26.DateTimeDefault => 'DateTimeDefault',
      _i27.DateTimeDefaultMix => 'DateTimeDefaultMix',
      _i28.DateTimeDefaultModel => 'DateTimeDefaultModel',
      _i29.DateTimeDefaultPersist => 'DateTimeDefaultPersist',
      _i30.DoubleDefault => 'DoubleDefault',
      _i31.DoubleDefaultMix => 'DoubleDefaultMix',
      _i32.DoubleDefaultModel => 'DoubleDefaultModel',
      _i33.DoubleDefaultPersist => 'DoubleDefaultPersist',
      _i34.DurationDefault => 'DurationDefault',
      _i35.DurationDefaultMix => 'DurationDefaultMix',
      _i36.DurationDefaultModel => 'DurationDefaultModel',
      _i37.DurationDefaultPersist => 'DurationDefaultPersist',
      _i38.EnumDefault => 'EnumDefault',
      _i39.EnumDefaultMix => 'EnumDefaultMix',
      _i40.EnumDefaultModel => 'EnumDefaultModel',
      _i41.EnumDefaultPersist => 'EnumDefaultPersist',
      _i42.ByIndexEnum => 'ByIndexEnum',
      _i43.ByNameEnum => 'ByNameEnum',
      _i44.DefaultValueEnum => 'DefaultValueEnum',
      _i45.DefaultException => 'DefaultException',
      _i46.IntDefault => 'IntDefault',
      _i47.IntDefaultMix => 'IntDefaultMix',
      _i48.IntDefaultModel => 'IntDefaultModel',
      _i49.IntDefaultPersist => 'IntDefaultPersist',
      _i50.StringDefault => 'StringDefault',
      _i51.StringDefaultMix => 'StringDefaultMix',
      _i52.StringDefaultModel => 'StringDefaultModel',
      _i53.StringDefaultPersist => 'StringDefaultPersist',
      _i54.UriDefault => 'UriDefault',
      _i55.UriDefaultMix => 'UriDefaultMix',
      _i56.UriDefaultModel => 'UriDefaultModel',
      _i57.UriDefaultPersist => 'UriDefaultPersist',
      _i58.UuidDefault => 'UuidDefault',
      _i59.UuidDefaultMix => 'UuidDefaultMix',
      _i60.UuidDefaultModel => 'UuidDefaultModel',
      _i61.UuidDefaultPersist => 'UuidDefaultPersist',
      _i62.EmptyModel => 'EmptyModel',
      _i63.EmptyModelRelationItem => 'EmptyModelRelationItem',
      _i64.EmptyModelWithTable => 'EmptyModelWithTable',
      _i65.RelationEmptyModel => 'RelationEmptyModel',
      _i66.ExceptionWithData => 'ExceptionWithData',
      _i67.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i68.NonTableParentClass => 'NonTableParentClass',
      _i69.ModifiedColumnName => 'ModifiedColumnName',
      _i70.Department => 'Department',
      _i71.Employee => 'Employee',
      _i72.Contractor => 'Contractor',
      _i73.Service => 'Service',
      _i74.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i75.ImmutableChildObject => 'ImmutableChildObject',
      _i76.ImmutableChildObjectWithNoAdditionalFields =>
        'ImmutableChildObjectWithNoAdditionalFields',
      _i77.ImmutableObject => 'ImmutableObject',
      _i78.ImmutableObjectWithImmutableObject =>
        'ImmutableObjectWithImmutableObject',
      _i79.ImmutableObjectWithList => 'ImmutableObjectWithList',
      _i80.ImmutableObjectWithMap => 'ImmutableObjectWithMap',
      _i81.ImmutableObjectWithMultipleFields =>
        'ImmutableObjectWithMultipleFields',
      _i82.ImmutableObjectWithNoFields => 'ImmutableObjectWithNoFields',
      _i83.ImmutableObjectWithRecord => 'ImmutableObjectWithRecord',
      _i84.ImmutableObjectWithTable => 'ImmutableObjectWithTable',
      _i85.ImmutableObjectWithTwentyFields => 'ImmutableObjectWithTwentyFields',
      _i86.ChildClass => 'ChildClass',
      _i87.ChildWithDefault => 'ChildWithDefault',
      _i88.ChildClassWithoutId => 'ChildClassWithoutId',
      _i89.ParentClass => 'ParentClass',
      _i90.GrandparentClass => 'GrandparentClass',
      _i91.ParentClassWithoutId => 'ParentClassWithoutId',
      _i92.GrandparentClassWithId => 'GrandparentClassWithId',
      _i93.ChildEntity => 'ChildEntity',
      _i94.BaseEntity => 'BaseEntity',
      _i95.ParentEntity => 'ParentEntity',
      _i96.NonServerOnlyParentClass => 'NonServerOnlyParentClass',
      _i97.ParentWithDefault => 'ParentWithDefault',
      _i98.PolymorphicGrandChild => 'PolymorphicGrandChild',
      _i99.PolymorphicChild => 'PolymorphicChild',
      _i100.PolymorphicChildContainer => 'PolymorphicChildContainer',
      _i101.ModulePolymorphicChildContainer =>
        'ModulePolymorphicChildContainer',
      _i102.SimilarButNotParent => 'SimilarButNotParent',
      _i103.PolymorphicParent => 'PolymorphicParent',
      _i104.UnrelatedToPolymorphism => 'UnrelatedToPolymorphism',
      _i105.SealedGrandChild => 'SealedGrandChild',
      _i105.SealedChild => 'SealedChild',
      _i106.SealedChildOnlyRequired => 'SealedChildOnlyRequired',
      _i105.SealedOtherChild => 'SealedOtherChild',
      _i107.CityWithLongTableName => 'CityWithLongTableName',
      _i108.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i109.PersonWithLongTableName => 'PersonWithLongTableName',
      _i110.MaxFieldName => 'MaxFieldName',
      _i111.LongImplicitIdField => 'LongImplicitIdField',
      _i112.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i113.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i114.UserNote => 'UserNote',
      _i115.UserNoteCollection => 'UserNoteCollection',
      _i116.UserNoteCollectionWithALongName =>
        'UserNoteCollectionWithALongName',
      _i117.UserNoteWithALongName => 'UserNoteWithALongName',
      _i118.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i119.City => 'City',
      _i120.Organization => 'Organization',
      _i121.Person => 'Person',
      _i122.Course => 'Course',
      _i123.Enrollment => 'Enrollment',
      _i124.Student => 'Student',
      _i125.ObjectUser => 'ObjectUser',
      _i126.ParentUser => 'ParentUser',
      _i127.Arena => 'Arena',
      _i128.Player => 'Player',
      _i129.Team => 'Team',
      _i130.Comment => 'Comment',
      _i131.Customer => 'Customer',
      _i132.Book => 'Book',
      _i133.Chapter => 'Chapter',
      _i134.Order => 'Order',
      _i135.Address => 'Address',
      _i136.Citizen => 'Citizen',
      _i137.Company => 'Company',
      _i138.Town => 'Town',
      _i139.Blocking => 'Blocking',
      _i140.Member => 'Member',
      _i141.Cat => 'Cat',
      _i142.Post => 'Post',
      _i143.ModuleDatatype => 'ModuleDatatype',
      _i144.MyFeatureModel => 'MyFeatureModel',
      _i145.MyTriggerType => 'MyTriggerType',
      _i146.Nullability => 'Nullability',
      _i147.ObjectFieldPersist => 'ObjectFieldPersist',
      _i148.ObjectFieldScopes => 'ObjectFieldScopes',
      _i149.ObjectWithBit => 'ObjectWithBit',
      _i150.ObjectWithByteData => 'ObjectWithByteData',
      _i151.ObjectWithCustomClass => 'ObjectWithCustomClass',
      _i152.ObjectWithDuration => 'ObjectWithDuration',
      _i153.ObjectWithDynamic => 'ObjectWithDynamic',
      _i154.ObjectWithEnum => 'ObjectWithEnum',
      _i155.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i156.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i157.ObjectWithIndex => 'ObjectWithIndex',
      _i158.ObjectWithJsonb => 'ObjectWithJsonb',
      _i159.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i160.ObjectWithMaps => 'ObjectWithMaps',
      _i161.ObjectWithNullableCustomClass => 'ObjectWithNullableCustomClass',
      _i162.ObjectWithObject => 'ObjectWithObject',
      _i163.ObjectWithParent => 'ObjectWithParent',
      _i164.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i165.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i166.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i167.ObjectWithUuid => 'ObjectWithUuid',
      _i168.ObjectWithVector => 'ObjectWithVector',
      _i169.Record => 'Record',
      _i170.RelatedUniqueData => 'RelatedUniqueData',
      _i171.ExceptionWithRequiredField => 'ExceptionWithRequiredField',
      _i172.ModelWithRequiredField => 'ModelWithRequiredField',
      _i173.ScopeNoneFields => 'ScopeNoneFields',
      _i174.ScopeServerOnlyFieldChild => 'ScopeServerOnlyFieldChild',
      _i175.ScopeServerOnlyField => 'ScopeServerOnlyField',
      _i176.DefaultServerOnlyClass => 'DefaultServerOnlyClass',
      _i177.DefaultServerOnlyEnum => 'DefaultServerOnlyEnum',
      _i178.NotServerOnlyClass => 'NotServerOnlyClass',
      _i179.NotServerOnlyEnum => 'NotServerOnlyEnum',
      _i180.ServerOnlyClassField => 'ServerOnlyClassField',
      _i181.ServerOnlyDefault => 'ServerOnlyDefault',
      _i182.SessionAuthInfo => 'SessionAuthInfo',
      _i183.SharedModelContainer => 'SharedModelContainer',
      _i184.SharedModelSubclass => 'SharedModelSubclass',
      _i185.SimpleData => 'SimpleData',
      _i186.SimpleDataList => 'SimpleDataList',
      _i187.SimpleDataMap => 'SimpleDataMap',
      _i188.SimpleDataObject => 'SimpleDataObject',
      _i189.SimpleDateTime => 'SimpleDateTime',
      _i190.ModelInSubfolder => 'ModelInSubfolder',
      _i191.TestEnum => 'TestEnum',
      _i192.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i193.TestEnumEnhanced => 'TestEnumEnhanced',
      _i194.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i195.TestEnumStringified => 'TestEnumStringified',
      _i196.Types => 'Types',
      _i197.TypesList => 'TypesList',
      _i198.TypesMap => 'TypesMap',
      _i199.TypesRecord => 'TypesRecord',
      _i200.TypesSet => 'TypesSet',
      _i201.TypesSetRequired => 'TypesSetRequired',
      _i202.UniqueData => 'UniqueData',
      _i203.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
      _i204.UpsertTestModel => 'UpsertTestModel',
      _ => null,
    };
  }

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;

    if (data is Map<String, dynamic> && data['__className__'] is String) {
      return (data['__className__'] as String).replaceFirst(
        'serverpod_test.',
        '',
      );
    }

    switch (data) {
      case _i207.CustomClass():
        return 'CustomClass';
      case _i207.CustomClass2():
        return 'CustomClass2';
      case _i207.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _i207.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _i207.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _i207.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _i207.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _i207.FreezedCustomClass():
        return 'FreezedCustomClass';
      case _i2.ByIndexEnumWithNameValue():
        return 'ByIndexEnumWithNameValue';
      case _i3.ByNameEnumWithNameValue():
        return 'ByNameEnumWithNameValue';
      case _i4.CourseUuid():
        return 'CourseUuid';
      case _i5.EnrollmentInt():
        return 'EnrollmentInt';
      case _i6.StudentUuid():
        return 'StudentUuid';
      case _i7.ArenaUuid():
        return 'ArenaUuid';
      case _i8.PlayerUuid():
        return 'PlayerUuid';
      case _i9.TeamInt():
        return 'TeamInt';
      case _i10.CommentInt():
        return 'CommentInt';
      case _i11.CustomerInt():
        return 'CustomerInt';
      case _i12.OrderUuid():
        return 'OrderUuid';
      case _i13.AddressUuid():
        return 'AddressUuid';
      case _i14.CitizenInt():
        return 'CitizenInt';
      case _i15.CompanyUuid():
        return 'CompanyUuid';
      case _i16.TownInt():
        return 'TownInt';
      case _i17.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _i18.BigIntDefault():
        return 'BigIntDefault';
      case _i19.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i20.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _i21.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _i22.BoolDefault():
        return 'BoolDefault';
      case _i23.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _i24.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i25.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _i26.DateTimeDefault():
        return 'DateTimeDefault';
      case _i27.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _i28.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _i29.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _i30.DoubleDefault():
        return 'DoubleDefault';
      case _i31.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i32.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _i33.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _i34.DurationDefault():
        return 'DurationDefault';
      case _i35.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i36.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _i37.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _i38.EnumDefault():
        return 'EnumDefault';
      case _i39.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _i40.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i41.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i42.ByIndexEnum():
        return 'ByIndexEnum';
      case _i43.ByNameEnum():
        return 'ByNameEnum';
      case _i44.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _i45.DefaultException():
        return 'DefaultException';
      case _i46.IntDefault():
        return 'IntDefault';
      case _i47.IntDefaultMix():
        return 'IntDefaultMix';
      case _i48.IntDefaultModel():
        return 'IntDefaultModel';
      case _i49.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i50.StringDefault():
        return 'StringDefault';
      case _i51.StringDefaultMix():
        return 'StringDefaultMix';
      case _i52.StringDefaultModel():
        return 'StringDefaultModel';
      case _i53.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i54.UriDefault():
        return 'UriDefault';
      case _i55.UriDefaultMix():
        return 'UriDefaultMix';
      case _i56.UriDefaultModel():
        return 'UriDefaultModel';
      case _i57.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _i58.UuidDefault():
        return 'UuidDefault';
      case _i59.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i60.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i61.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _i62.EmptyModel():
        return 'EmptyModel';
      case _i63.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _i64.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _i65.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _i66.ExceptionWithData():
        return 'ExceptionWithData';
      case _i67.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i68.NonTableParentClass():
        return 'NonTableParentClass';
      case _i69.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i70.Department():
        return 'Department';
      case _i71.Employee():
        return 'Employee';
      case _i72.Contractor():
        return 'Contractor';
      case _i73.Service():
        return 'Service';
      case _i74.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i75.ImmutableChildObject():
        return 'ImmutableChildObject';
      case _i76.ImmutableChildObjectWithNoAdditionalFields():
        return 'ImmutableChildObjectWithNoAdditionalFields';
      case _i77.ImmutableObject():
        return 'ImmutableObject';
      case _i78.ImmutableObjectWithImmutableObject():
        return 'ImmutableObjectWithImmutableObject';
      case _i79.ImmutableObjectWithList():
        return 'ImmutableObjectWithList';
      case _i80.ImmutableObjectWithMap():
        return 'ImmutableObjectWithMap';
      case _i81.ImmutableObjectWithMultipleFields():
        return 'ImmutableObjectWithMultipleFields';
      case _i82.ImmutableObjectWithNoFields():
        return 'ImmutableObjectWithNoFields';
      case _i83.ImmutableObjectWithRecord():
        return 'ImmutableObjectWithRecord';
      case _i84.ImmutableObjectWithTable():
        return 'ImmutableObjectWithTable';
      case _i85.ImmutableObjectWithTwentyFields():
        return 'ImmutableObjectWithTwentyFields';
      case _i86.ChildClass():
        return 'ChildClass';
      case _i87.ChildWithDefault():
        return 'ChildWithDefault';
      case _i88.ChildClassWithoutId():
        return 'ChildClassWithoutId';
      case _i89.ParentClass():
        return 'ParentClass';
      case _i90.GrandparentClass():
        return 'GrandparentClass';
      case _i91.ParentClassWithoutId():
        return 'ParentClassWithoutId';
      case _i92.GrandparentClassWithId():
        return 'GrandparentClassWithId';
      case _i93.ChildEntity():
        return 'ChildEntity';
      case _i94.BaseEntity():
        return 'BaseEntity';
      case _i95.ParentEntity():
        return 'ParentEntity';
      case _i96.NonServerOnlyParentClass():
        return 'NonServerOnlyParentClass';
      case _i97.ParentWithDefault():
        return 'ParentWithDefault';
      case _i98.PolymorphicGrandChild():
        return 'PolymorphicGrandChild';
      case _i99.PolymorphicChild():
        return 'PolymorphicChild';
      case _i100.PolymorphicChildContainer():
        return 'PolymorphicChildContainer';
      case _i101.ModulePolymorphicChildContainer():
        return 'ModulePolymorphicChildContainer';
      case _i102.SimilarButNotParent():
        return 'SimilarButNotParent';
      case _i103.PolymorphicParent():
        return 'PolymorphicParent';
      case _i104.UnrelatedToPolymorphism():
        return 'UnrelatedToPolymorphism';
      case _i105.SealedGrandChild():
        return 'SealedGrandChild';
      case _i105.SealedChild():
        return 'SealedChild';
      case _i106.SealedChildOnlyRequired():
        return 'SealedChildOnlyRequired';
      case _i105.SealedOtherChild():
        return 'SealedOtherChild';
      case _i107.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i108.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i109.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i110.MaxFieldName():
        return 'MaxFieldName';
      case _i111.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i112.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i113.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i114.UserNote():
        return 'UserNote';
      case _i115.UserNoteCollection():
        return 'UserNoteCollection';
      case _i116.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i117.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i118.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i119.City():
        return 'City';
      case _i120.Organization():
        return 'Organization';
      case _i121.Person():
        return 'Person';
      case _i122.Course():
        return 'Course';
      case _i123.Enrollment():
        return 'Enrollment';
      case _i124.Student():
        return 'Student';
      case _i125.ObjectUser():
        return 'ObjectUser';
      case _i126.ParentUser():
        return 'ParentUser';
      case _i127.Arena():
        return 'Arena';
      case _i128.Player():
        return 'Player';
      case _i129.Team():
        return 'Team';
      case _i130.Comment():
        return 'Comment';
      case _i131.Customer():
        return 'Customer';
      case _i132.Book():
        return 'Book';
      case _i133.Chapter():
        return 'Chapter';
      case _i134.Order():
        return 'Order';
      case _i135.Address():
        return 'Address';
      case _i136.Citizen():
        return 'Citizen';
      case _i137.Company():
        return 'Company';
      case _i138.Town():
        return 'Town';
      case _i139.Blocking():
        return 'Blocking';
      case _i140.Member():
        return 'Member';
      case _i141.Cat():
        return 'Cat';
      case _i142.Post():
        return 'Post';
      case _i143.ModuleDatatype():
        return 'ModuleDatatype';
      case _i144.MyFeatureModel():
        return 'MyFeatureModel';
      case _i145.MyTriggerType():
        return 'MyTriggerType';
      case _i146.Nullability():
        return 'Nullability';
      case _i147.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i148.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i149.ObjectWithBit():
        return 'ObjectWithBit';
      case _i150.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i151.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _i152.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i153.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _i154.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i155.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i156.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i157.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i158.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i159.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i160.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i161.ObjectWithNullableCustomClass():
        return 'ObjectWithNullableCustomClass';
      case _i162.ObjectWithObject():
        return 'ObjectWithObject';
      case _i163.ObjectWithParent():
        return 'ObjectWithParent';
      case _i164.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i165.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i166.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i167.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i168.ObjectWithVector():
        return 'ObjectWithVector';
      case _i169.Record():
        return 'Record';
      case _i170.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i171.ExceptionWithRequiredField():
        return 'ExceptionWithRequiredField';
      case _i172.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i173.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _i174.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _i175.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _i176.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i177.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _i178.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _i179.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _i180.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _i181.ServerOnlyDefault():
        return 'ServerOnlyDefault';
      case _i182.SessionAuthInfo():
        return 'SessionAuthInfo';
      case _i183.SharedModelContainer():
        return 'SharedModelContainer';
      case _i184.SharedModelSubclass():
        return 'SharedModelSubclass';
      case _i185.SimpleData():
        return 'SimpleData';
      case _i186.SimpleDataList():
        return 'SimpleDataList';
      case _i187.SimpleDataMap():
        return 'SimpleDataMap';
      case _i188.SimpleDataObject():
        return 'SimpleDataObject';
      case _i189.SimpleDateTime():
        return 'SimpleDateTime';
      case _i190.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _i191.TestEnum():
        return 'TestEnum';
      case _i192.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i193.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i194.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i195.TestEnumStringified():
        return 'TestEnumStringified';
      case _i196.Types():
        return 'Types';
      case _i197.TypesList():
        return 'TypesList';
      case _i198.TypesMap():
        return 'TypesMap';
      case _i199.TypesRecord():
        return 'TypesRecord';
      case _i200.TypesSet():
        return 'TypesSet';
      case _i201.TypesSetRequired():
        return 'TypesSetRequired';
      case _i202.UniqueData():
        return 'UniqueData';
      case _i203.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _i204.UpsertTestModel():
        return 'UpsertTestModel';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i208.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i210.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i208.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i208.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i208.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i208.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (String, _i211.PolymorphicParent)) {
      return '(String,PolymorphicParent)';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data
        is List<
          ((int, String), {(_i208.SimpleData, double) namedSubRecord})?
        >?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (int?, _i205.ProjectStreamingClass?)) {
      return '(int?,serverpod_test_module.ProjectStreamingClass?)';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i208.SimpleData simpleData}),
        )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i208.SimpleData simpleData}),
        )?) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?';
    }
    if (data is List<(String, int)>?) {
      return 'List<(String,int)>?';
    }
    className = _i210.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _i205.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_module.$className';
    }
    className = _i207.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_shared.$className';
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
      return deserialize<_i207.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i207.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i207.CustomClassWithoutProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i207.CustomClassWithProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i207.CustomClassWithProtocolSerializationMethod>(
        data['data'],
      );
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i207.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i207.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i207.FreezedCustomClass>(data['data']);
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
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_i44.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i45.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i46.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i47.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i48.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i49.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i50.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i51.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i52.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i53.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i54.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i55.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i56.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i57.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i58.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i59.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i60.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i61.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i62.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i63.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i64.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i65.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i66.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i67.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i68.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i69.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i70.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i71.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i72.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i73.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i74.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObject') {
      return deserialize<_i75.ImmutableChildObject>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObjectWithNoAdditionalFields') {
      return deserialize<_i76.ImmutableChildObjectWithNoAdditionalFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObject') {
      return deserialize<_i77.ImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithImmutableObject') {
      return deserialize<_i78.ImmutableObjectWithImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithList') {
      return deserialize<_i79.ImmutableObjectWithList>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMap') {
      return deserialize<_i80.ImmutableObjectWithMap>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMultipleFields') {
      return deserialize<_i81.ImmutableObjectWithMultipleFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithNoFields') {
      return deserialize<_i82.ImmutableObjectWithNoFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithRecord') {
      return deserialize<_i83.ImmutableObjectWithRecord>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTable') {
      return deserialize<_i84.ImmutableObjectWithTable>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTwentyFields') {
      return deserialize<_i85.ImmutableObjectWithTwentyFields>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i86.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i87.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ChildClassWithoutId') {
      return deserialize<_i88.ChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i89.ParentClass>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i90.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClassWithoutId') {
      return deserialize<_i91.ParentClassWithoutId>(data['data']);
    }
    if (dataClassName == 'GrandparentClassWithId') {
      return deserialize<_i92.GrandparentClassWithId>(data['data']);
    }
    if (dataClassName == 'ChildEntity') {
      return deserialize<_i93.ChildEntity>(data['data']);
    }
    if (dataClassName == 'BaseEntity') {
      return deserialize<_i94.BaseEntity>(data['data']);
    }
    if (dataClassName == 'ParentEntity') {
      return deserialize<_i95.ParentEntity>(data['data']);
    }
    if (dataClassName == 'NonServerOnlyParentClass') {
      return deserialize<_i96.NonServerOnlyParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i97.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'PolymorphicGrandChild') {
      return deserialize<_i98.PolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChild') {
      return deserialize<_i99.PolymorphicChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChildContainer') {
      return deserialize<_i100.PolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChildContainer') {
      return deserialize<_i101.ModulePolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'SimilarButNotParent') {
      return deserialize<_i102.SimilarButNotParent>(data['data']);
    }
    if (dataClassName == 'PolymorphicParent') {
      return deserialize<_i103.PolymorphicParent>(data['data']);
    }
    if (dataClassName == 'UnrelatedToPolymorphism') {
      return deserialize<_i104.UnrelatedToPolymorphism>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i105.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i105.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedChildOnlyRequired') {
      return deserialize<_i106.SealedChildOnlyRequired>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i105.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i107.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i108.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i109.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i110.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i111.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i112.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i113.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i114.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i115.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i116.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i117.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i118.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i119.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i120.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i121.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i122.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i123.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i124.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i125.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i126.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i127.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i128.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i129.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i130.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i131.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i132.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i133.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i134.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i135.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i136.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i137.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i138.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i139.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i140.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i141.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i142.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i143.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i144.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'MyTriggerType') {
      return deserialize<_i145.MyTriggerType>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i146.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i147.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i148.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i149.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i150.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i151.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i152.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithDynamic') {
      return deserialize<_i153.ObjectWithDynamic>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i154.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i155.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i156.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i157.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_i158.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i159.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i160.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithNullableCustomClass') {
      return deserialize<_i161.ObjectWithNullableCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i162.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i163.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i164.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i165.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i166.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i167.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i168.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_i169.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i170.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ExceptionWithRequiredField') {
      return deserialize<_i171.ExceptionWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i172.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i173.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i174.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i175.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i176.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i177.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i178.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i179.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i180.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'ServerOnlyDefault') {
      return deserialize<_i181.ServerOnlyDefault>(data['data']);
    }
    if (dataClassName == 'SessionAuthInfo') {
      return deserialize<_i182.SessionAuthInfo>(data['data']);
    }
    if (dataClassName == 'SharedModelContainer') {
      return deserialize<_i183.SharedModelContainer>(data['data']);
    }
    if (dataClassName == 'SharedModelSubclass') {
      return deserialize<_i184.SharedModelSubclass>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i185.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i186.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i187.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i188.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i189.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_i190.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i191.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i192.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i193.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i194.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i195.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i196.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i197.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i198.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_i199.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i200.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_i201.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i202.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i203.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_i204.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i210.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i205.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_shared.')) {
      data['className'] = dataClassName.substring(22);
      return _i207.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i208.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i210.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i208.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i208.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i208.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i208.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(String,PolymorphicParent)') {
      return deserialize<(String, _i211.PolymorphicParent)>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
        List<((int, String), {(_i208.SimpleData, double) namedSubRecord})?>?
      >(data['data']);
    }
    if (dataClassName ==
        '(int?,serverpod_test_module.ProjectStreamingClass?)') {
      return deserialize<(int?, _i205.ProjectStreamingClass?)>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i208.SimpleData simpleData}))
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i208.SimpleData simpleData}))?
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>?') {
      return deserialize<List<(String, int)>?>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i210.Protocol().registerHostProtocol('serverpod_test', this);
    _i205.Protocol().registerHostProtocol('serverpod_test', this);
    _i207.Protocol().registerHostProtocol('serverpod_test', this);
  }

  /// Wraps serialized data with its class name so that it can be deserialized
  /// with [deserializeByClassName].
  ///
  /// Records and containers containing records will be return in their JSON representation in the returned map.
  @override
  Map<String, dynamic> wrapWithClassName(Object? data) {
    /// In case the value (to be streamed) contains a record or potentially empty non-String-keyed Map, we need to map it before it reaches the underlying JSON encode
    if (data != null && (data is Iterable || data is Map)) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapContainerToJson(data),
      };
    } else if (data is Record) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordToJson(data),
      };
    }

    return super.wrapWithClassName(data);
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
    if (record is (Map<int, String>, String)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
          record.$2,
        ],
      };
    }
    if (record is (Map<int, int>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (int, BigInt)) {
      return {
        "p": [
          record.$1,
          record.$2.toJson(),
        ],
      };
    }
    if (record is (String, _i211.PolymorphicParent)) {
      return {
        "p": [
          record.$1,
          record.$2.toJson(),
        ],
      };
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
    if (record is (int, _i208.SimpleData)) {
      return {
        "p": [
          record.$1,
          record.$2.toJson(),
        ],
      };
    }
    if (record is (Map<String, int>,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (Set<(int,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
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
    if (record is ({_i208.SimpleData data, int number})) {
      return {
        "n": {
          "data": record.data.toJson(),
          "number": record.number,
        },
      };
    }
    if (record is ({_i208.SimpleData? data, int? number})) {
      return {
        "n": {
          "data": record.data?.toJson(),
          "number": record.number,
        },
      };
    }
    if (record is ({Map<int, int> intIntMap})) {
      return {
        "n": {
          "intIntMap": mapContainerToJson(record.intIntMap),
        },
      };
    }
    if (record is ({Set<(bool,)> boolSet})) {
      return {
        "n": {
          "boolSet": mapContainerToJson(record.boolSet),
        },
      };
    }
    if (record is (bool,)) {
      return {
        "p": [
          record.$1,
        ],
      };
    }
    if (record is (Map<(Map<int, String>, String), String>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (int, {_i208.SimpleData data})) {
      return {
        "p": [
          record.$1,
        ],
        "n": {
          "data": record.data.toJson(),
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
    if (record is ({(_i208.SimpleData, double) namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (_i208.SimpleData, double)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2,
        ],
      };
    }
    if (record is ({(_i208.SimpleData, double)? namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record
        is ((int, String), {(_i208.SimpleData, double) namedSubRecord})) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (int?, _i205.ProjectStreamingClass?)) {
      return {
        "p": [
          record.$1,
          record.$2?.toJson(),
        ],
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
    if (record
        is (
          String,
          (Map<String, int>, {bool flag, _i208.SimpleData simpleData}),
        )) {
      return {
        "p": [
          record.$1,
          mapRecordToJson(record.$2),
        ],
      };
    }
    if (record
        is (Map<String, int>, {bool flag, _i208.SimpleData simpleData})) {
      return {
        "p": [
          record.$1.toJson(),
        ],
        "n": {
          "flag": record.flag,
          "simpleData": record.simpleData.toJson(),
        },
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
    if (record is (_i205.ModuleClass,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (bool,)) {
      return {
        "p": [
          record.$1,
        ],
      };
    }
    if (record is (_i195.TestEnumStringified,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i146.Nullability,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i195.TestEnumStringified value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i205.ModuleClass value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i146.Nullability value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is (String, {Uri? optionalUri})) {
      return {
        "p": [
          record.$1,
        ],
        "n": {
          "optionalUri": record.optionalUri?.toJson(),
        },
      };
    }
    if (record is (_i191.TestEnum,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (String,)) {
      return {
        "p": [
          record.$1,
        ],
      };
    }
    if (record is (double,)) {
      return {
        "p": [
          record.$1,
        ],
      };
    }
    if (record is (DateTime,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i206.ByteData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (Duration,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i1.UuidValue,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (Uri,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (BigInt,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (List<int>,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (Map<int, int>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (Set<int>,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i185.SimpleData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i185.SimpleData namedModel})) {
      return {
        "n": {
          "namedModel": record.namedModel.toJson(),
        },
      };
    }
    if (record is (_i185.SimpleData, {_i185.SimpleData namedModel})) {
      return {
        "p": [
          record.$1.toJson(),
        ],
        "n": {
          "namedModel": record.namedModel.toJson(),
        },
      };
    }
    if (record is ((int, String), {(int, String) namedNestedRecord})) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedNestedRecord": mapRecordToJson(record.namedNestedRecord),
        },
      };
    }
    if (record
        is (
          (List<(_i185.SimpleData,)>,), {
          (_i185.SimpleData, Map<String, _i185.SimpleData>) namedNestedRecord,
        })) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedNestedRecord": mapRecordToJson(record.namedNestedRecord),
        },
      };
    }
    if (record is (List<(_i185.SimpleData,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (_i185.SimpleData, Map<String, _i185.SimpleData>)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2.toJson(),
        ],
      };
    }
    try {
      return _i210.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i205.Protocol().mapRecordToJson(record);
    } catch (_) {}
    throw Exception('Unsupported record type ${record.runtimeType}');
  }

  /// Maps container types (like [List], [Map], [Set]) containing
  /// [Record]s or non-String-keyed [Map]s to their JSON representation.
  ///
  /// It should not be called for [SerializableModel] types. These
  /// handle the "[Record] in container" mapping internally already.
  ///
  /// It is only supposed to be called from generated protocol code.
  ///
  /// Returns either a `List<dynamic>` (for List, Sets, and Maps with
  /// non-String keys) or a `Map<String, dynamic>` in case the input was
  /// a `Map<String, …>`.
  Object? mapContainerToJson(Object obj) {
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
        Iterable iterable => mapContainerToJson(iterable),
        Map map => mapContainerToJson(map),
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
            },
        ];

      case Iterable():
        return [
          for (var e in obj) mapIfNeeded(e),
        ];
    }

    return obj;
  }
}
