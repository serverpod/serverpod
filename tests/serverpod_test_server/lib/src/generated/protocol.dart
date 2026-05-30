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
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i4;
import 'by_index_enum_with_name_value.dart' as _i5;
import 'by_name_enum_with_name_value.dart' as _i6;
import 'changed_id_type/many_to_many/course.dart' as _i7;
import 'changed_id_type/many_to_many/enrollment.dart' as _i8;
import 'changed_id_type/many_to_many/student.dart' as _i9;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i10;
import 'changed_id_type/nested_one_to_many/player.dart' as _i11;
import 'changed_id_type/nested_one_to_many/team.dart' as _i12;
import 'changed_id_type/one_to_many/comment.dart' as _i13;
import 'changed_id_type/one_to_many/customer.dart' as _i14;
import 'changed_id_type/one_to_many/order.dart' as _i15;
import 'changed_id_type/one_to_one/address.dart' as _i16;
import 'changed_id_type/one_to_one/citizen.dart' as _i17;
import 'changed_id_type/one_to_one/company.dart' as _i18;
import 'changed_id_type/one_to_one/town.dart' as _i19;
import 'changed_id_type/self.dart' as _i20;
import 'changed_id_type/server_only.dart' as _i21;
import 'defaults/bigint/bigint_default.dart' as _i22;
import 'defaults/bigint/bigint_default_mix.dart' as _i23;
import 'defaults/bigint/bigint_default_model.dart' as _i24;
import 'defaults/bigint/bigint_default_persist.dart' as _i25;
import 'defaults/boolean/bool_default.dart' as _i26;
import 'defaults/boolean/bool_default_mix.dart' as _i27;
import 'defaults/boolean/bool_default_model.dart' as _i28;
import 'defaults/boolean/bool_default_persist.dart' as _i29;
import 'defaults/datetime/datetime_default.dart' as _i30;
import 'defaults/datetime/datetime_default_mix.dart' as _i31;
import 'defaults/datetime/datetime_default_model.dart' as _i32;
import 'defaults/datetime/datetime_default_persist.dart' as _i33;
import 'defaults/double/double_default.dart' as _i34;
import 'defaults/double/double_default_mix.dart' as _i35;
import 'defaults/double/double_default_model.dart' as _i36;
import 'defaults/double/double_default_persist.dart' as _i37;
import 'defaults/duration/duration_default.dart' as _i38;
import 'defaults/duration/duration_default_mix.dart' as _i39;
import 'defaults/duration/duration_default_model.dart' as _i40;
import 'defaults/duration/duration_default_persist.dart' as _i41;
import 'defaults/enum/enum_default.dart' as _i42;
import 'defaults/enum/enum_default_mix.dart' as _i43;
import 'defaults/enum/enum_default_model.dart' as _i44;
import 'defaults/enum/enum_default_persist.dart' as _i45;
import 'defaults/enum/enums/by_index_enum.dart' as _i46;
import 'defaults/enum/enums/by_name_enum.dart' as _i47;
import 'defaults/enum/enums/default_value_enum.dart' as _i48;
import 'defaults/exception/default_exception.dart' as _i49;
import 'defaults/integer/int_default.dart' as _i50;
import 'defaults/integer/int_default_mix.dart' as _i51;
import 'defaults/integer/int_default_model.dart' as _i52;
import 'defaults/integer/int_default_persist.dart' as _i53;
import 'defaults/string/string_default.dart' as _i54;
import 'defaults/string/string_default_mix.dart' as _i55;
import 'defaults/string/string_default_model.dart' as _i56;
import 'defaults/string/string_default_persist.dart' as _i57;
import 'defaults/uri/uri_default.dart' as _i58;
import 'defaults/uri/uri_default_mix.dart' as _i59;
import 'defaults/uri/uri_default_model.dart' as _i60;
import 'defaults/uri/uri_default_persist.dart' as _i61;
import 'defaults/uuid/uuid_default.dart' as _i62;
import 'defaults/uuid/uuid_default_mix.dart' as _i63;
import 'defaults/uuid/uuid_default_model.dart' as _i64;
import 'defaults/uuid/uuid_default_persist.dart' as _i65;
import 'empty_model/empty_model.dart' as _i66;
import 'empty_model/empty_model_relation_item.dart' as _i67;
import 'empty_model/empty_model_with_table.dart' as _i68;
import 'empty_model/relation_empy_model.dart' as _i69;
import 'exception_with_data.dart' as _i70;
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i71;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i72;
import 'explicit_column_name/modified_column_name.dart' as _i73;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i74;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i75;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i76;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i77;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i78;
import 'future_calls_generated_models/test_generated_call_bye_model.dart'
    as _i79;
import 'future_calls_generated_models/test_generated_call_execute_with_trigger_model.dart'
    as _i80;
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _i81;
import 'immutable/immutable_child_object.dart' as _i82;
import 'immutable/immutable_child_object_with_no_additional_fields.dart'
    as _i83;
import 'immutable/immutable_object.dart' as _i84;
import 'immutable/immutable_object_with_immutable_object.dart' as _i85;
import 'immutable/immutable_object_with_list.dart' as _i86;
import 'immutable/immutable_object_with_map.dart' as _i87;
import 'immutable/immutable_object_with_multiple_fields.dart' as _i88;
import 'immutable/immutable_object_with_no_fields.dart' as _i89;
import 'immutable/immutable_object_with_record.dart' as _i90;
import 'immutable/immutable_object_with_table.dart' as _i91;
import 'immutable/immutable_object_with_twenty_fields.dart' as _i92;
import 'inheritance/child_class.dart' as _i93;
import 'inheritance/child_server_only.dart' as _i94;
import 'inheritance/child_with_default.dart' as _i95;
import 'inheritance/child_with_inherited_id.dart' as _i96;
import 'inheritance/child_without_id.dart' as _i97;
import 'inheritance/child_without_id_server_only.dart' as _i98;
import 'inheritance/parent_class.dart' as _i99;
import 'inheritance/grandparent_class.dart' as _i100;
import 'inheritance/parent_without_id.dart' as _i101;
import 'inheritance/grandparent_with_id.dart' as _i102;
import 'inheritance/list_relation_of_child/child_entity.dart' as _i103;
import 'inheritance/list_relation_of_child/base_entity.dart' as _i104;
import 'inheritance/list_relation_of_child/parent_entity.dart' as _i105;
import 'inheritance/parent_non_server_only.dart' as _i106;
import 'inheritance/parent_with_changed_id.dart' as _i107;
import 'inheritance/parent_with_default.dart' as _i108;
import 'inheritance/polymorphism/grandchild.dart' as _i109;
import 'inheritance/polymorphism/child.dart' as _i110;
import 'inheritance/polymorphism/container.dart' as _i111;
import 'inheritance/polymorphism/container_module.dart' as _i112;
import 'inheritance/polymorphism/other.dart' as _i113;
import 'inheritance/polymorphism/parent.dart' as _i114;
import 'inheritance/polymorphism/unrelated.dart' as _i115;
import 'inheritance/sealed_parent.dart' as _i116;
import 'inheritance/sealed_parent_nullable_field.dart' as _i117;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i118;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i119;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i120;
import 'long_identifiers/max_field_name.dart' as _i121;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i122;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i123;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i124;
import 'long_identifiers/models_with_relations/user_note.dart' as _i125;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i126;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i127;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i128;
import 'long_identifiers/multiple_max_field_name.dart' as _i129;
import 'models_with_list_relations/city.dart' as _i130;
import 'models_with_list_relations/organization.dart' as _i131;
import 'models_with_list_relations/person.dart' as _i132;
import 'models_with_relations/many_to_many/course.dart' as _i133;
import 'models_with_relations/many_to_many/enrollment.dart' as _i134;
import 'models_with_relations/many_to_many/student.dart' as _i135;
import 'models_with_relations/module/object_user.dart' as _i136;
import 'models_with_relations/module/parent_user.dart' as _i137;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i138;
import 'models_with_relations/nested_one_to_many/player.dart' as _i139;
import 'models_with_relations/nested_one_to_many/team.dart' as _i140;
import 'models_with_relations/one_to_many/comment.dart' as _i141;
import 'models_with_relations/one_to_many/customer.dart' as _i142;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i143;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i144;
import 'models_with_relations/one_to_many/order.dart' as _i145;
import 'models_with_relations/one_to_one/address.dart' as _i146;
import 'models_with_relations/one_to_one/citizen.dart' as _i147;
import 'models_with_relations/one_to_one/company.dart' as _i148;
import 'models_with_relations/one_to_one/town.dart' as _i149;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i150;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i151;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i152;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i153;
import 'module_datatype.dart' as _i154;
import 'my_feature/models/my_feature_model.dart' as _i155;
import 'my_trigger_type.dart' as _i156;
import 'nullability.dart' as _i157;
import 'object_field_persist.dart' as _i158;
import 'object_field_scopes.dart' as _i159;
import 'object_with_bit.dart' as _i160;
import 'object_with_bytedata.dart' as _i161;
import 'object_with_custom_class.dart' as _i162;
import 'object_with_duration.dart' as _i163;
import 'object_with_dynamic.dart' as _i164;
import 'object_with_enum.dart' as _i165;
import 'object_with_enum_enhanced.dart' as _i166;
import 'object_with_half_vector.dart' as _i167;
import 'object_with_index.dart' as _i168;
import 'object_with_jsonb.dart' as _i169;
import 'object_with_jsonb_class_level.dart' as _i170;
import 'object_with_maps.dart' as _i171;
import 'object_with_nullable_custom_class.dart' as _i172;
import 'object_with_object.dart' as _i173;
import 'object_with_parent.dart' as _i174;
import 'object_with_sealed_class.dart' as _i175;
import 'object_with_self_parent.dart' as _i176;
import 'object_with_sparse_vector.dart' as _i177;
import 'object_with_uuid.dart' as _i178;
import 'object_with_vector.dart' as _i179;
import 'record.dart' as _i180;
import 'related_unique_data.dart' as _i181;
import 'required/exception_with_required_field.dart' as _i182;
import 'required/model_with_required_field.dart' as _i183;
import 'scopes/scope_none_fields.dart' as _i184;
import 'scopes/scope_server_only_field_child.dart' as _i185;
import 'scopes/scope_server_only_field.dart' as _i186;
import 'scopes/serverOnly/article.dart' as _i187;
import 'scopes/serverOnly/article_list.dart' as _i188;
import 'scopes/serverOnly/default_server_only_class.dart' as _i189;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i190;
import 'scopes/serverOnly/not_server_only_class.dart' as _i191;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i192;
import 'scopes/serverOnly/server_only_class.dart' as _i193;
import 'scopes/serverOnly/server_only_enum.dart' as _i194;
import 'scopes/server_only_class_field.dart' as _i195;
import 'server_only_default.dart' as _i196;
import 'session_auth_info.dart' as _i197;
import 'shared_model_container.dart' as _i198;
import 'shared_model_subclass.dart' as _i199;
import 'simple_data.dart' as _i200;
import 'simple_data_list.dart' as _i201;
import 'simple_data_map.dart' as _i202;
import 'simple_data_object.dart' as _i203;
import 'simple_date_time.dart' as _i204;
import 'subfolder/model_in_subfolder.dart' as _i205;
import 'test_enum.dart' as _i206;
import 'test_enum_default_serialization.dart' as _i207;
import 'test_enum_enhanced.dart' as _i208;
import 'test_enum_enhanced_by_name.dart' as _i209;
import 'test_enum_stringified.dart' as _i210;
import 'types.dart' as _i211;
import 'types_list.dart' as _i212;
import 'types_map.dart' as _i213;
import 'types_record.dart' as _i214;
import 'types_set.dart' as _i215;
import 'types_set_required.dart' as _i216;
import 'unique_data.dart' as _i217;
import 'unique_data_with_non_persist.dart' as _i218;
import 'upsert_test_model.dart' as _i219;
import 'dart:typed_data' as _i220;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i221;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i222;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i223;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _i224;
import 'package:serverpod_test_server/src/generated/types.dart' as _i225;
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
export 'changed_id_type/server_only.dart';
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
export 'inheritance/child_server_only.dart';
export 'inheritance/child_with_default.dart';
export 'inheritance/child_with_inherited_id.dart';
export 'inheritance/child_without_id.dart';
export 'inheritance/child_without_id_server_only.dart';
export 'inheritance/parent_class.dart';
export 'inheritance/grandparent_class.dart';
export 'inheritance/parent_without_id.dart';
export 'inheritance/grandparent_with_id.dart';
export 'inheritance/list_relation_of_child/child_entity.dart';
export 'inheritance/list_relation_of_child/base_entity.dart';
export 'inheritance/list_relation_of_child/parent_entity.dart';
export 'inheritance/parent_non_server_only.dart';
export 'inheritance/parent_with_changed_id.dart';
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
export 'scopes/serverOnly/article.dart';
export 'scopes/serverOnly/article_list.dart';
export 'scopes/serverOnly/default_server_only_class.dart';
export 'scopes/serverOnly/default_server_only_enum.dart';
export 'scopes/serverOnly/not_server_only_class.dart';
export 'scopes/serverOnly/not_server_only_enum.dart';
export 'scopes/serverOnly/server_only_class.dart';
export 'scopes/serverOnly/server_only_enum.dart';
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

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'street',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'address_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'inhabitant_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'inhabitantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'address_uuid',
      dartName: 'AddressUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'street',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'address_uuid_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'inhabitant_uuid_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'inhabitantId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'arena',
      dartName: 'Arena',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'arena_uuid',
      dartName: 'ArenaUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bigint_default',
      dartName: 'BigIntDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'bigintDefaultStr',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'',
        ),
        _i2.ColumnDefinition(
          name: 'bigintDefaultStrNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bigint_default_mix',
      dartName: 'BigIntDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'1\'',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'12345678901234567890\'',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bigint_default_model',
      dartName: 'BigIntDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultModelStr',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultModelStrNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bigint_default_persist',
      dartName: 'BigIntDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultPersistStr',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'blocking',
      dartName: 'Blocking',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'blockedId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'blockedById',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'blocking_fk_0',
          columns: ['blockedId'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'blocking_fk_1',
          columns: ['blockedById'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'blocking_blocked_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'blockedId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'blockedById',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'book',
      dartName: 'Book',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bool_default',
      dartName: 'BoolDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultTrue',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultFalse',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultNullFalse',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bool_default_mix',
      dartName: 'BoolDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultAndDefaultModel',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bool_default_model',
      dartName: 'BoolDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultModelTrue',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultModelFalse',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultModelNullFalse',
          columnType: _i2.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'bool_default_persist',
      dartName: 'BoolDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultPersistTrue',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'true',
        ),
        _i2.ColumnDefinition(
          name: 'boolDefaultPersistFalse',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'cat',
      dartName: 'Cat',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'motherId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'cat_fk_0',
          columns: ['motherId'],
          referenceTable: 'cat',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'changed_id_type_self',
      dartName: 'ChangedIdTypeSelf',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nextId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'changed_id_type_self_fk_0',
          columns: ['nextId'],
          referenceTable: 'changed_id_type_self',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'changed_id_type_self_fk_1',
          columns: ['parentId'],
          referenceTable: 'changed_id_type_self',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'changed_id_type_self_next_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'nextId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'chapter',
      dartName: 'Chapter',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: '_bookChaptersBookId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'chapter_fk_0',
          columns: ['_bookChaptersBookId'],
          referenceTable: 'book',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'child_entity',
      dartName: 'ChildEntity',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'sharedField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'localField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: '_parentEntityChildrenParentEntityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'child_entity_fk_0',
          columns: ['_parentEntityChildrenParentEntityId'],
          referenceTable: 'parent_entity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'child_table_explicit_column',
      dartName: 'ChildClassExplicitColumn',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'non_table_parent_field',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'child_field',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'child_table_with_inherited_id',
      dartName: 'ChildClassWithoutId',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'grandParentField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'childField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'child_table_with_inherited_id_base_index',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'grandParentField',
            ),
          ],
          type: 'btree',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'child_with_inherited_id',
      dartName: 'ChildWithInheritedId',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'child_with_inherited_id_fk_0',
          columns: ['parentId'],
          referenceTable: 'child_with_inherited_id',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'companyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_fk_0',
          columns: ['companyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'citizen_int',
      dartName: 'CitizenInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'companyId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_int_fk_0',
          columns: ['companyId'],
          referenceTable: 'company_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'citizen_int_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'city',
      dartName: 'City',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'city_with_long_table_name_that_is_still_valid',
      dartName: 'CityWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'comment_int',
      dartName: 'CommentInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'orderId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'comment_int_fk_0',
          columns: ['orderId'],
          referenceTable: 'order_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'company',
      dartName: 'Company',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'townId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'company_fk_0',
          columns: ['townId'],
          referenceTable: 'town',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'company_uuid',
      dartName: 'CompanyUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'townId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'company_uuid_fk_0',
          columns: ['townId'],
          referenceTable: 'town_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'contractor',
      dartName: 'Contractor',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fk_contractor_service_id',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'contractor_fk_0',
          columns: ['fk_contractor_service_id'],
          referenceTable: 'service',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'contractor_service_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'fk_contractor_service_id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'course',
      dartName: 'Course',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'course_uuid',
      dartName: 'CourseUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'customer',
      dartName: 'Customer',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'customer_int',
      dartName: 'CustomerInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'datetime_default',
      dartName: 'DateTimeDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultNow',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultStr',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-24T22:00:00.000Z',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultStrNull',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '2024-05-24T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'datetime_default_mix',
      dartName: 'DateTimeDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultModel',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-01T22:00:00.000Z',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'datetime_default_model',
      dartName: 'DateTimeDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultModelNow',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultModelStr',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultModelStrNull',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'datetime_default_persist',
      dartName: 'DateTimeDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultPersistNow',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: 'now',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultPersistStr',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'department',
      dartName: 'Department',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'double_default',
      dartName: 'DoubleDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefault',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '10.5',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultNull',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'double_default_mix',
      dartName: 'DoubleDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultAndDefaultModel',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '10.5',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '20.5',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'double_default_model',
      dartName: 'DoubleDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultModel',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultModelNull',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'double_default_persist',
      dartName: 'DoubleDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'doubleDefaultPersist',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
          columnDefault: '10.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'duration_default',
      dartName: 'DurationDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefault',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '94230100',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
          columnDefault: '177640100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'duration_default_mix',
      dartName: 'DurationDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultAndDefaultModel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '94230100',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '177640100',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '177640100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'duration_default_model',
      dartName: 'DurationDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultModel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultModelNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'duration_default_persist',
      dartName: 'DurationDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'durationDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
          columnDefault: '94230100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'employee',
      dartName: 'Employee',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'fk_employee_department_id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'employee_fk_0',
          columns: ['fk_employee_department_id'],
          referenceTable: 'department',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'empty_model_relation_item',
      dartName: 'EmptyModelRelationItem',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: '_relationEmptyModelItemsRelationEmptyModelId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'empty_model_relation_item_fk_0',
          columns: ['_relationEmptyModelItemsRelationEmptyModelId'],
          referenceTable: 'relation_empty_model',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'empty_model_with_table',
      dartName: 'EmptyModelWithTable',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enrollment',
      dartName: 'Enrollment',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'studentId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'courseId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_0',
          columns: ['studentId'],
          referenceTable: 'student',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_1',
          columns: ['courseId'],
          referenceTable: 'course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enrollment_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enrollment_int',
      dartName: 'EnrollmentInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'studentId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'courseId',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'enrollment_int_fk_0',
          columns: ['studentId'],
          referenceTable: 'student_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'enrollment_int_fk_1',
          columns: ['courseId'],
          referenceTable: 'course_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enrollment_int_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'courseId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enum_default',
      dartName: 'EnumDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName2\'',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexEnumDefault',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:ByIndexEnum',
          columnDefault: '0',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexEnumDefaultNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
          columnDefault: '1',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enum_default_mix',
      dartName: 'EnumDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enum_default_model',
      dartName: 'EnumDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultModelNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexEnumDefaultModel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:ByIndexEnum',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexEnumDefaultModelNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'enum_default_persist',
      dartName: 'EnumDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName1\'',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexEnumDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'immutable_object_with_table',
      dartName: 'ImmutableObjectWithTable',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'variable',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'int_default',
      dartName: 'IntDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'intDefault',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
          columnDefault: '20',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'int_default_mix',
      dartName: 'IntDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultAndDefaultModel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'int_default_model',
      dartName: 'IntDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultModel',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultModelNull',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'int_default_persist',
      dartName: 'IntDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'intDefaultPersist',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
          columnDefault: '10',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'long_implicit_id_field',
      dartName: 'LongImplicitIdField',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name:
              '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'long_implicit_id_field_fk_0',
          columns: [
            '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
          ],
          referenceTable: 'long_implicit_id_field_collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'long_implicit_id_field_collection',
      dartName: 'LongImplicitIdFieldCollection',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'max_field_name',
      dartName: 'MaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'member',
      dartName: 'Member',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'model_with_required_field',
      dartName: 'ModelWithRequiredField',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'phone',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'modified_column_name',
      dartName: 'ModifiedColumnName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'originalColumn',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'modified_column',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'multiple_max_field_name',
      dartName: 'MultipleMaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name:
              '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'multiple_max_field_name_fk_0',
          columns: [
            '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
          ],
          referenceTable: 'relation_to_multiple_max_field_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_field_persist',
      dartName: 'ObjectFieldPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'normal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_field_scopes',
      dartName: 'ObjectFieldScopes',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'normal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'database',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_user',
      dartName: 'ObjectUser',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'object_user_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_bit',
      dartName: 'ObjectWithBit',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'bit',
          columnType: _i2.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'bitNullable',
          columnType: _i2.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(512)?',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'bitIndexedHnsw',
          columnType: _i2.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'bitIndexedHnswWithParams',
          columnType: _i2.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'bitIndexedIvfflat',
          columnType: _i2.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'bitIndexedIvfflatWithParams',
          columnType: _i2.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bit_index_default',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bit',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.hamming,
          vectorColumnType: _i2.ColumnType.bit,
        ),
        _i2.IndexDefinition(
          indexName: 'bit_index_hnsw',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bitIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.hamming,
          vectorColumnType: _i2.ColumnType.bit,
        ),
        _i2.IndexDefinition(
          indexName: 'bit_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bitIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.jaccard,
          vectorColumnType: _i2.ColumnType.bit,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _i2.IndexDefinition(
          indexName: 'bit_index_ivfflat',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bitIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.hamming,
          vectorColumnType: _i2.ColumnType.bit,
        ),
        _i2.IndexDefinition(
          indexName: 'bit_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'bitIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.hamming,
          vectorColumnType: _i2.ColumnType.bit,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_bytedata',
      dartName: 'ObjectWithByteData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_duration',
      dartName: 'ObjectWithDuration',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_dynamic',
      dartName: 'ObjectWithDynamic',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'payload',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'dynamic',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbPayload',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'dynamic',
        ),
        _i2.ColumnDefinition(
          name: 'payloadList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<dynamic>',
        ),
        _i2.ColumnDefinition(
          name: 'payloadMap',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,dynamic>',
        ),
        _i2.ColumnDefinition(
          name: 'payloadSet',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<dynamic>',
        ),
        _i2.ColumnDefinition(
          name: 'payloadMapWithDynamicKeys',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'Map<dynamic,dynamic>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_enum',
      dartName: 'ObjectWithEnum',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'testEnum',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:TestEnum',
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnum',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _i2.ColumnDefinition(
          name: 'enumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnumList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum?>',
        ),
        _i2.ColumnDefinition(
          name: 'enumListList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<List<protocol:TestEnum>>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_enum_enhanced',
      dartName: 'ObjectWithEnumEnhanced',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'byIndex',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:TestEnumEnhanced',
        ),
        _i2.ColumnDefinition(
          name: 'nullableByIndex',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnumEnhanced?',
        ),
        _i2.ColumnDefinition(
          name: 'byIndexList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnumEnhanced>',
        ),
        _i2.ColumnDefinition(
          name: 'byName',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TestEnumEnhancedByName',
        ),
        _i2.ColumnDefinition(
          name: 'nullableByName',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumEnhancedByName?',
        ),
        _i2.ColumnDefinition(
          name: 'byNameList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnumEnhancedByName>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_half_vector',
      dartName: 'ObjectWithHalfVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'halfVector',
          columnType: _i2.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'halfVectorNullable',
          columnType: _i2.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(512)?',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'halfVectorIndexedHnsw',
          columnType: _i2.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'halfVectorIndexedHnswWithParams',
          columnType: _i2.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'halfVectorIndexedIvfflat',
          columnType: _i2.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'halfVectorIndexedIvfflatWithParams',
          columnType: _i2.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'half_vector_index_default',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'halfVector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.halfvec,
        ),
        _i2.IndexDefinition(
          indexName: 'half_vector_index_hnsw',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.halfvec,
        ),
        _i2.IndexDefinition(
          indexName: 'half_vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.halfvec,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _i2.IndexDefinition(
          indexName: 'half_vector_index_ivfflat',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.halfvec,
        ),
        _i2.IndexDefinition(
          indexName: 'half_vector_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.cosine,
          vectorColumnType: _i2.ColumnType.halfvec,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_index',
      dartName: 'ObjectWithIndex',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'indexed',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'indexed2',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_index_test_index',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'indexed',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'indexed2',
            ),
          ],
          type: 'brin',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_jsonb',
      dartName: 'ObjectWithJsonb',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'notJsonb',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonb',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbMap',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'Map<String,String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbObject',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'protocol:SimpleData',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbIndexed',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbIndexedGin',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbIndexedGinJsonbPath',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'jsonbIndexedImplicitGin',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableJsonb',
          columnType: _i2.ColumnType.jsonb,
          isNullable: true,
          dartType: 'List<String>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'jsonb_index_gin',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedGin',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _i2.GinOperatorClass.jsonbOps,
        ),
        _i2.IndexDefinition(
          indexName: 'jsonb_index_gin_with_operator_class',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedGinJsonbPath',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _i2.GinOperatorClass.jsonbPathOps,
        ),
        _i2.IndexDefinition(
          indexName: 'jsonb_index_implicit_gin',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedImplicitGin',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _i2.GinOperatorClass.jsonbOps,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_jsonb_class_level',
      dartName: 'ObjectWithJsonbClassLevel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'implicitJsonb',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'explicitJsonb',
          columnType: _i2.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _i2.ColumnDefinition(
          name: 'json',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_object',
      dartName: 'ObjectWithObject',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'data',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:SimpleData',
        ),
        _i2.ColumnDefinition(
          name: 'nullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SimpleData?',
        ),
        _i2.ColumnDefinition(
          name: 'dataList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableDataList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData>?',
        ),
        _i2.ColumnDefinition(
          name: 'listWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData?>',
        ),
        _i2.ColumnDefinition(
          name: 'nullableListWithNullableData',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData?>?',
        ),
        _i2.ColumnDefinition(
          name: 'nestedDataList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<List<protocol:SimpleData>>?',
        ),
        _i2.ColumnDefinition(
          name: 'nestedDataListInMap',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,List<List<Map<int,protocol:SimpleData>>?>>?',
        ),
        _i2.ColumnDefinition(
          name: 'nestedDataMap',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,Map<int,protocol:SimpleData>>?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_parent',
      dartName: 'ObjectWithParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'object_with_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_field_scopes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_self_parent',
      dartName: 'ObjectWithSelfParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'object_with_self_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_with_self_parent',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_sparse_vector',
      dartName: 'ObjectWithSparseVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'sparseVector',
          columnType: _i2.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'sparseVectorNullable',
          columnType: _i2.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(512)?',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'sparseVectorIndexedHnsw',
          columnType: _i2.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'sparseVectorIndexedHnswWithParams',
          columnType: _i2.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'sparse_vector_index_default',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sparseVector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.sparsevec,
        ),
        _i2.IndexDefinition(
          indexName: 'sparse_vector_index_hnsw',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sparseVectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.sparsevec,
        ),
        _i2.IndexDefinition(
          indexName: 'sparse_vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'sparseVectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l1,
          vectorColumnType: _i2.ColumnType.sparsevec,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_uuid',
      dartName: 'ObjectWithUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'uuidNullable',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_vector',
      dartName: 'ObjectWithVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'vector',
          columnType: _i2.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'vectorNullable',
          columnType: _i2.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(512)?',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'vectorIndexedHnsw',
          columnType: _i2.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'vectorIndexedHnswWithParams',
          columnType: _i2.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'vectorIndexedIvfflat',
          columnType: _i2.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _i2.ColumnDefinition(
          name: 'vectorIndexedIvfflatWithParams',
          columnType: _i2.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'vector_index_default',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.vector,
        ),
        _i2.IndexDefinition(
          indexName: 'vector_index_hnsw',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.vector,
        ),
        _i2.IndexDefinition(
          indexName: 'vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.cosine,
          vectorColumnType: _i2.ColumnType.vector,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _i2.IndexDefinition(
          indexName: 'vector_index_ivfflat',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vectorIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.l2,
          vectorColumnType: _i2.ColumnType.vector,
        ),
        _i2.IndexDefinition(
          indexName: 'vector_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'vectorIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _i2.VectorDistanceFunction.innerProduct,
          vectorColumnType: _i2.ColumnType.vector,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order',
      dartName: 'Order',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'customerId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'order_uuid',
      dartName: 'OrderUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'customerId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'order_uuid_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'organization',
      dartName: 'Organization',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'organization_fk_0',
          columns: ['cityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'organization_with_long_table_name_that_is_still_valid',
      dartName: 'OrganizationWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'cityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'organization_with_long_table_name_that_is_still_valid_fk_0',
          columns: ['cityId'],
          referenceTable: 'city_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'parent_class_table',
      dartName: 'ParentClass',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'grandParentField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'parentField',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'parent_entity',
      dartName: 'ParentEntity',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'parent_user',
      dartName: 'ParentUser',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'userInfoId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'parent_user_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'organizationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: '_cityCitizensCityId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'person_fk_0',
          columns: ['organizationId'],
          referenceTable: 'organization',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName: 'person_fk_1',
          columns: ['_cityCitizensCityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'person_with_long_table_name_that_is_still_valid',
      dartName: 'PersonWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'organizationId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name:
              '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName:
              'person_with_long_table_name_that_is_still_valid_fk_0',
          columns: ['organizationId'],
          referenceTable:
              'organization_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i2.ForeignKeyDefinition(
          constraintName:
              'person_with_long_table_name_that_is_still_valid_fk_1',
          columns: [
            '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
          ],
          referenceTable: 'city_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'player',
      dartName: 'Player',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'teamId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'player_fk_0',
          columns: ['teamId'],
          referenceTable: 'team',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'player_uuid',
      dartName: 'PlayerUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'teamId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'player_uuid_fk_0',
          columns: ['teamId'],
          referenceTable: 'team_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'post',
      dartName: 'Post',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'content',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'nextId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['nextId'],
          referenceTable: 'post',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'next_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'nextId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'related_unique_data',
      dartName: 'RelatedUniqueData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uniqueDataId',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'related_unique_data_fk_0',
          columns: ['uniqueDataId'],
          referenceTable: 'unique_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'relation_empty_model',
      dartName: 'RelationEmptyModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'relation_to_multiple_max_field_name',
      dartName: 'RelationToMultipleMaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'scope_none_fields',
      dartName: 'ScopeNoneFields',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'object',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SimpleData?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'server_only_changed_id_field_class',
      dartName: 'ServerOnlyChangedIdFieldClass',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'service',
      dartName: 'Service',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'shared_model_container',
      dartName: 'SharedModelContainer',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModel',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'SharedModel',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelWithModuleAlias',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedModel',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'SharedModel?',
        ),
        _i2.ColumnDefinition(
          name: 'serverOnlySharedModel',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'SharedModel?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSubclass',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'SharedSubclass',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSubclassNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'SharedSubclass?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedEnum',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'SharedEnum',
        ),
        _i2.ColumnDefinition(
          name: 'sharedEnumNullable',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'SharedEnum?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSealedParent',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'SharedSealedParent',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSealedParentNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'SharedSealedParent?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSealedChild',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'SharedSealedChild',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSealedChildNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'SharedSealedChild?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelSubclass',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:SharedModelSubclass',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelSubclassNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SharedModelSubclass?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<SharedModel>',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelNullableList',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'List<SharedModel?>',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelListNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<SharedModel>?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelMap',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,SharedModel>',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelMapNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,SharedModel>?',
        ),
        _i2.ColumnDefinition(
          name: 'sharedSubclassMap',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,SharedSubclass>',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelSet',
          columnType: _i2.ColumnType.json,
          isNullable: false,
          dartType: 'Set<SharedModel>',
        ),
        _i2.ColumnDefinition(
          name: 'sharedModelSetNullable',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Set<SharedModel>?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'num',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'simple_date_time',
      dartName: 'SimpleDateTime',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'dateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'string_default',
      dartName: 'StringDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default null value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'string_default_mix',
      dartName: 'StringDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'string_default_model',
      dartName: 'StringDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultModelNull',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'string_default_persist',
      dartName: 'StringDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneDoubleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoDoubleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneSingleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoSingleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'student',
      dartName: 'Student',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'student_uuid',
      dartName: 'StudentUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'table_with_explicit_column_names',
      dartName: 'TableWithExplicitColumnName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'user_name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'user_description',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'Just some information\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'team',
      dartName: 'Team',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'arenaId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'team_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'arena_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'arenaId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'team_int',
      dartName: 'TeamInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'arenaId',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'team_int_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'arena_uuid_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'arenaId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'town',
      dartName: 'Town',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mayorId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'town_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'town_int',
      dartName: 'TownInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'mayorId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'town_int_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'types',
      dartName: 'Types',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'anInt',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: 'aBool',
          columnType: _i2.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i2.ColumnDefinition(
          name: 'aDouble',
          columnType: _i2.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i2.ColumnDefinition(
          name: 'aDateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i2.ColumnDefinition(
          name: 'aString',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i2.ColumnDefinition(
          name: 'aByteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: true,
          dartType: 'dart:typed_data:ByteData?',
        ),
        _i2.ColumnDefinition(
          name: 'aDuration',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _i2.ColumnDefinition(
          name: 'aUuid',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'aUri',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
        _i2.ColumnDefinition(
          name: 'aBigInt',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
        _i2.ColumnDefinition(
          name: 'aVector',
          columnType: _i2.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(3)?',
          vectorDimension: 3,
        ),
        _i2.ColumnDefinition(
          name: 'aHalfVector',
          columnType: _i2.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(3)?',
          vectorDimension: 3,
        ),
        _i2.ColumnDefinition(
          name: 'aSparseVector',
          columnType: _i2.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(3)?',
          vectorDimension: 3,
        ),
        _i2.ColumnDefinition(
          name: 'aBit',
          columnType: _i2.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(3)?',
          vectorDimension: 3,
        ),
        _i2.ColumnDefinition(
          name: 'anEnum',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _i2.ColumnDefinition(
          name: 'aStringifiedEnum',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumStringified?',
        ),
        _i2.ColumnDefinition(
          name: 'aList',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _i2.ColumnDefinition(
          name: 'aMap',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Map<int,int>?',
        ),
        _i2.ColumnDefinition(
          name: 'aSet',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: 'Set<int>?',
        ),
        _i2.ColumnDefinition(
          name: 'aRecord',
          columnType: _i2.ColumnType.json,
          isNullable: true,
          dartType: '(String, {Uri? optionalUri})?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'unique_data',
      dartName: 'UniqueData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'email_index_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'unique_data_with_non_persist',
      dartName: 'UniqueDataWithNonPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'email',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'unique_email_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'email',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'upsert_test_model',
      dartName: 'UpsertTestModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'code',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'category',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name: 'value',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'code_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _i2.IndexDefinition(
          indexName: 'category_value_unique_idx',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'category',
            ),
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'value',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uri_default',
      dartName: 'UriDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uri_default_mix',
      dartName: 'UriDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uri_default_model',
      dartName: 'UriDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultModelNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uri_default_persist',
      dartName: 'UriDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_note',
      dartName: 'UserNote',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name:
              '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_note_fk_0',
          columns: [
            '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
          ],
          referenceTable: 'user_note_collections',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_note_collection_with_a_long_name',
      dartName: 'UserNoteCollectionWithALongName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_note_collections',
      dartName: 'UserNoteCollection',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'user_note_with_a_long_name',
      dartName: 'UserNoteWithALongName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i2.ColumnDefinition(
          name:
              '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
          columnType: _i2.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i2.ForeignKeyDefinition(
          constraintName: 'user_note_with_a_long_name_fk_0',
          columns: [
            '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
          ],
          referenceTable: 'user_note_collection_with_a_long_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uuid_default',
      dartName: 'UuidDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandom',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandomV7',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandomNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultStr',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultStrNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uuid_default_mix',
      dartName: 'UuidDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultAndDefaultModel',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'9e107d9d-372b-4d97-9b27-2f0907d0b1d4\'',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'f47ac10b-58cc-4372-a567-0e02b2c3d479\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uuid_default_model',
      dartName: 'UuidDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelRandom',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelRandomV7',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelRandomNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelStr',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelStrNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'uuid_default_persist',
      dartName: 'UuidDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistRandom',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistRandomV7',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistStr',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  static final Map<Type, dynamic Function(dynamic, Protocol)> _deserializers =
      _buildDeserializers();

  static Map<Type, dynamic Function(dynamic, Protocol)> _buildDeserializers() {
    final map = <Type, dynamic Function(dynamic, Protocol)>{};
    map[_i5.ByIndexEnumWithNameValue] = (data, protocol) =>
        _i5.ByIndexEnumWithNameValue.fromJson(data);
    map[_i6.ByNameEnumWithNameValue] = (data, protocol) =>
        _i6.ByNameEnumWithNameValue.fromJson(data);
    map[_i7.CourseUuid] = (data, protocol) => _i7.CourseUuid.fromJson(data);
    map[_i8.EnrollmentInt] = (data, protocol) =>
        _i8.EnrollmentInt.fromJson(data);
    map[_i9.StudentUuid] = (data, protocol) => _i9.StudentUuid.fromJson(data);
    map[_i10.ArenaUuid] = (data, protocol) => _i10.ArenaUuid.fromJson(data);
    map[_i11.PlayerUuid] = (data, protocol) => _i11.PlayerUuid.fromJson(data);
    map[_i12.TeamInt] = (data, protocol) => _i12.TeamInt.fromJson(data);
    map[_i13.CommentInt] = (data, protocol) => _i13.CommentInt.fromJson(data);
    map[_i14.CustomerInt] = (data, protocol) => _i14.CustomerInt.fromJson(data);
    map[_i15.OrderUuid] = (data, protocol) => _i15.OrderUuid.fromJson(data);
    map[_i16.AddressUuid] = (data, protocol) => _i16.AddressUuid.fromJson(data);
    map[_i17.CitizenInt] = (data, protocol) => _i17.CitizenInt.fromJson(data);
    map[_i18.CompanyUuid] = (data, protocol) => _i18.CompanyUuid.fromJson(data);
    map[_i19.TownInt] = (data, protocol) => _i19.TownInt.fromJson(data);
    map[_i20.ChangedIdTypeSelf] = (data, protocol) =>
        _i20.ChangedIdTypeSelf.fromJson(data);
    map[_i21.ServerOnlyChangedIdFieldClass] = (data, protocol) =>
        _i21.ServerOnlyChangedIdFieldClass.fromJson(data);
    map[_i22.BigIntDefault] = (data, protocol) =>
        _i22.BigIntDefault.fromJson(data);
    map[_i23.BigIntDefaultMix] = (data, protocol) =>
        _i23.BigIntDefaultMix.fromJson(data);
    map[_i24.BigIntDefaultModel] = (data, protocol) =>
        _i24.BigIntDefaultModel.fromJson(data);
    map[_i25.BigIntDefaultPersist] = (data, protocol) =>
        _i25.BigIntDefaultPersist.fromJson(data);
    map[_i26.BoolDefault] = (data, protocol) => _i26.BoolDefault.fromJson(data);
    map[_i27.BoolDefaultMix] = (data, protocol) =>
        _i27.BoolDefaultMix.fromJson(data);
    map[_i28.BoolDefaultModel] = (data, protocol) =>
        _i28.BoolDefaultModel.fromJson(data);
    map[_i29.BoolDefaultPersist] = (data, protocol) =>
        _i29.BoolDefaultPersist.fromJson(data);
    map[_i30.DateTimeDefault] = (data, protocol) =>
        _i30.DateTimeDefault.fromJson(data);
    map[_i31.DateTimeDefaultMix] = (data, protocol) =>
        _i31.DateTimeDefaultMix.fromJson(data);
    map[_i32.DateTimeDefaultModel] = (data, protocol) =>
        _i32.DateTimeDefaultModel.fromJson(data);
    map[_i33.DateTimeDefaultPersist] = (data, protocol) =>
        _i33.DateTimeDefaultPersist.fromJson(data);
    map[_i34.DoubleDefault] = (data, protocol) =>
        _i34.DoubleDefault.fromJson(data);
    map[_i35.DoubleDefaultMix] = (data, protocol) =>
        _i35.DoubleDefaultMix.fromJson(data);
    map[_i36.DoubleDefaultModel] = (data, protocol) =>
        _i36.DoubleDefaultModel.fromJson(data);
    map[_i37.DoubleDefaultPersist] = (data, protocol) =>
        _i37.DoubleDefaultPersist.fromJson(data);
    map[_i38.DurationDefault] = (data, protocol) =>
        _i38.DurationDefault.fromJson(data);
    map[_i39.DurationDefaultMix] = (data, protocol) =>
        _i39.DurationDefaultMix.fromJson(data);
    map[_i40.DurationDefaultModel] = (data, protocol) =>
        _i40.DurationDefaultModel.fromJson(data);
    map[_i41.DurationDefaultPersist] = (data, protocol) =>
        _i41.DurationDefaultPersist.fromJson(data);
    map[_i42.EnumDefault] = (data, protocol) => _i42.EnumDefault.fromJson(data);
    map[_i43.EnumDefaultMix] = (data, protocol) =>
        _i43.EnumDefaultMix.fromJson(data);
    map[_i44.EnumDefaultModel] = (data, protocol) =>
        _i44.EnumDefaultModel.fromJson(data);
    map[_i45.EnumDefaultPersist] = (data, protocol) =>
        _i45.EnumDefaultPersist.fromJson(data);
    map[_i46.ByIndexEnum] = (data, protocol) => _i46.ByIndexEnum.fromJson(data);
    map[_i47.ByNameEnum] = (data, protocol) => _i47.ByNameEnum.fromJson(data);
    map[_i48.DefaultValueEnum] = (data, protocol) =>
        _i48.DefaultValueEnum.fromJson(data);
    map[_i49.DefaultException] = (data, protocol) =>
        _i49.DefaultException.fromJson(data);
    map[_i50.IntDefault] = (data, protocol) => _i50.IntDefault.fromJson(data);
    map[_i51.IntDefaultMix] = (data, protocol) =>
        _i51.IntDefaultMix.fromJson(data);
    map[_i52.IntDefaultModel] = (data, protocol) =>
        _i52.IntDefaultModel.fromJson(data);
    map[_i53.IntDefaultPersist] = (data, protocol) =>
        _i53.IntDefaultPersist.fromJson(data);
    map[_i54.StringDefault] = (data, protocol) =>
        _i54.StringDefault.fromJson(data);
    map[_i55.StringDefaultMix] = (data, protocol) =>
        _i55.StringDefaultMix.fromJson(data);
    map[_i56.StringDefaultModel] = (data, protocol) =>
        _i56.StringDefaultModel.fromJson(data);
    map[_i57.StringDefaultPersist] = (data, protocol) =>
        _i57.StringDefaultPersist.fromJson(data);
    map[_i58.UriDefault] = (data, protocol) => _i58.UriDefault.fromJson(data);
    map[_i59.UriDefaultMix] = (data, protocol) =>
        _i59.UriDefaultMix.fromJson(data);
    map[_i60.UriDefaultModel] = (data, protocol) =>
        _i60.UriDefaultModel.fromJson(data);
    map[_i61.UriDefaultPersist] = (data, protocol) =>
        _i61.UriDefaultPersist.fromJson(data);
    map[_i62.UuidDefault] = (data, protocol) => _i62.UuidDefault.fromJson(data);
    map[_i63.UuidDefaultMix] = (data, protocol) =>
        _i63.UuidDefaultMix.fromJson(data);
    map[_i64.UuidDefaultModel] = (data, protocol) =>
        _i64.UuidDefaultModel.fromJson(data);
    map[_i65.UuidDefaultPersist] = (data, protocol) =>
        _i65.UuidDefaultPersist.fromJson(data);
    map[_i66.EmptyModel] = (data, protocol) => _i66.EmptyModel.fromJson(data);
    map[_i67.EmptyModelRelationItem] = (data, protocol) =>
        _i67.EmptyModelRelationItem.fromJson(data);
    map[_i68.EmptyModelWithTable] = (data, protocol) =>
        _i68.EmptyModelWithTable.fromJson(data);
    map[_i69.RelationEmptyModel] = (data, protocol) =>
        _i69.RelationEmptyModel.fromJson(data);
    map[_i70.ExceptionWithData] = (data, protocol) =>
        _i70.ExceptionWithData.fromJson(data);
    map[_i71.ChildClassExplicitColumn] = (data, protocol) =>
        _i71.ChildClassExplicitColumn.fromJson(data);
    map[_i72.NonTableParentClass] = (data, protocol) =>
        _i72.NonTableParentClass.fromJson(data);
    map[_i73.ModifiedColumnName] = (data, protocol) =>
        _i73.ModifiedColumnName.fromJson(data);
    map[_i74.Department] = (data, protocol) => _i74.Department.fromJson(data);
    map[_i75.Employee] = (data, protocol) => _i75.Employee.fromJson(data);
    map[_i76.Contractor] = (data, protocol) => _i76.Contractor.fromJson(data);
    map[_i77.Service] = (data, protocol) => _i77.Service.fromJson(data);
    map[_i78.TableWithExplicitColumnName] = (data, protocol) =>
        _i78.TableWithExplicitColumnName.fromJson(data);
    map[_i79.TestGeneratedCallByeModel] = (data, protocol) =>
        _i79.TestGeneratedCallByeModel.fromJson(data);
    map[_i80.TestGeneratedCallExecuteWithTriggerModel] = (data, protocol) =>
        _i80.TestGeneratedCallExecuteWithTriggerModel.fromJson(data);
    map[_i81.TestGeneratedCallHelloModel] = (data, protocol) =>
        _i81.TestGeneratedCallHelloModel.fromJson(data);
    map[_i82.ImmutableChildObject] = (data, protocol) =>
        _i82.ImmutableChildObject.fromJson(data);
    map[_i83.ImmutableChildObjectWithNoAdditionalFields] = (data, protocol) =>
        _i83.ImmutableChildObjectWithNoAdditionalFields.fromJson(data);
    map[_i84.ImmutableObject] = (data, protocol) =>
        _i84.ImmutableObject.fromJson(data);
    map[_i85.ImmutableObjectWithImmutableObject] = (data, protocol) =>
        _i85.ImmutableObjectWithImmutableObject.fromJson(data);
    map[_i86.ImmutableObjectWithList] = (data, protocol) =>
        _i86.ImmutableObjectWithList.fromJson(data);
    map[_i87.ImmutableObjectWithMap] = (data, protocol) =>
        _i87.ImmutableObjectWithMap.fromJson(data);
    map[_i88.ImmutableObjectWithMultipleFields] = (data, protocol) =>
        _i88.ImmutableObjectWithMultipleFields.fromJson(data);
    map[_i89.ImmutableObjectWithNoFields] = (data, protocol) =>
        _i89.ImmutableObjectWithNoFields.fromJson(data);
    map[_i90.ImmutableObjectWithRecord] = (data, protocol) =>
        _i90.ImmutableObjectWithRecord.fromJson(data);
    map[_i91.ImmutableObjectWithTable] = (data, protocol) =>
        _i91.ImmutableObjectWithTable.fromJson(data);
    map[_i92.ImmutableObjectWithTwentyFields] = (data, protocol) =>
        _i92.ImmutableObjectWithTwentyFields.fromJson(data);
    map[_i93.ChildClass] = (data, protocol) => _i93.ChildClass.fromJson(data);
    map[_i94.ServerOnlyChildClass] = (data, protocol) =>
        _i94.ServerOnlyChildClass.fromJson(data);
    map[_i95.ChildWithDefault] = (data, protocol) =>
        _i95.ChildWithDefault.fromJson(data);
    map[_i96.ChildWithInheritedId] = (data, protocol) =>
        _i96.ChildWithInheritedId.fromJson(data);
    map[_i97.ChildClassWithoutId] = (data, protocol) =>
        _i97.ChildClassWithoutId.fromJson(data);
    map[_i98.ServerOnlyChildClassWithoutId] = (data, protocol) =>
        _i98.ServerOnlyChildClassWithoutId.fromJson(data);
    map[_i99.ParentClass] = (data, protocol) => _i99.ParentClass.fromJson(data);
    map[_i100.GrandparentClass] = (data, protocol) =>
        _i100.GrandparentClass.fromJson(data);
    map[_i101.ParentClassWithoutId] = (data, protocol) =>
        _i101.ParentClassWithoutId.fromJson(data);
    map[_i102.GrandparentClassWithId] = (data, protocol) =>
        _i102.GrandparentClassWithId.fromJson(data);
    map[_i103.ChildEntity] = (data, protocol) =>
        _i103.ChildEntity.fromJson(data);
    map[_i104.BaseEntity] = (data, protocol) => _i104.BaseEntity.fromJson(data);
    map[_i105.ParentEntity] = (data, protocol) =>
        _i105.ParentEntity.fromJson(data);
    map[_i106.NonServerOnlyParentClass] = (data, protocol) =>
        _i106.NonServerOnlyParentClass.fromJson(data);
    map[_i107.ParentWithChangedId] = (data, protocol) =>
        _i107.ParentWithChangedId.fromJson(data);
    map[_i108.ParentWithDefault] = (data, protocol) =>
        _i108.ParentWithDefault.fromJson(data);
    map[_i109.PolymorphicGrandChild] = (data, protocol) =>
        _i109.PolymorphicGrandChild.fromJson(data);
    map[_i110.PolymorphicChild] = (data, protocol) =>
        _i110.PolymorphicChild.fromJson(data);
    map[_i111.PolymorphicChildContainer] = (data, protocol) =>
        _i111.PolymorphicChildContainer.fromJson(data);
    map[_i112.ModulePolymorphicChildContainer] = (data, protocol) =>
        _i112.ModulePolymorphicChildContainer.fromJson(data);
    map[_i113.SimilarButNotParent] = (data, protocol) =>
        _i113.SimilarButNotParent.fromJson(data);
    map[_i114.PolymorphicParent] = (data, protocol) =>
        _i114.PolymorphicParent.fromJson(data);
    map[_i115.UnrelatedToPolymorphism] = (data, protocol) =>
        _i115.UnrelatedToPolymorphism.fromJson(data);
    map[_i116.SealedGrandChild] = (data, protocol) =>
        _i116.SealedGrandChild.fromJson(data);
    map[_i116.SealedChild] = (data, protocol) =>
        _i116.SealedChild.fromJson(data);
    map[_i117.SealedChildOnlyRequired] = (data, protocol) =>
        _i117.SealedChildOnlyRequired.fromJson(data);
    map[_i116.SealedOtherChild] = (data, protocol) =>
        _i116.SealedOtherChild.fromJson(data);
    map[_i118.CityWithLongTableName] = (data, protocol) =>
        _i118.CityWithLongTableName.fromJson(data);
    map[_i119.OrganizationWithLongTableName] = (data, protocol) =>
        _i119.OrganizationWithLongTableName.fromJson(data);
    map[_i120.PersonWithLongTableName] = (data, protocol) =>
        _i120.PersonWithLongTableName.fromJson(data);
    map[_i121.MaxFieldName] = (data, protocol) =>
        _i121.MaxFieldName.fromJson(data);
    map[_i122.LongImplicitIdField] = (data, protocol) =>
        _i122.LongImplicitIdField.fromJson(data);
    map[_i123.LongImplicitIdFieldCollection] = (data, protocol) =>
        _i123.LongImplicitIdFieldCollection.fromJson(data);
    map[_i124.RelationToMultipleMaxFieldName] = (data, protocol) =>
        _i124.RelationToMultipleMaxFieldName.fromJson(data);
    map[_i125.UserNote] = (data, protocol) => _i125.UserNote.fromJson(data);
    map[_i126.UserNoteCollection] = (data, protocol) =>
        _i126.UserNoteCollection.fromJson(data);
    map[_i127.UserNoteCollectionWithALongName] = (data, protocol) =>
        _i127.UserNoteCollectionWithALongName.fromJson(data);
    map[_i128.UserNoteWithALongName] = (data, protocol) =>
        _i128.UserNoteWithALongName.fromJson(data);
    map[_i129.MultipleMaxFieldName] = (data, protocol) =>
        _i129.MultipleMaxFieldName.fromJson(data);
    map[_i130.City] = (data, protocol) => _i130.City.fromJson(data);
    map[_i131.Organization] = (data, protocol) =>
        _i131.Organization.fromJson(data);
    map[_i132.Person] = (data, protocol) => _i132.Person.fromJson(data);
    map[_i133.Course] = (data, protocol) => _i133.Course.fromJson(data);
    map[_i134.Enrollment] = (data, protocol) => _i134.Enrollment.fromJson(data);
    map[_i135.Student] = (data, protocol) => _i135.Student.fromJson(data);
    map[_i136.ObjectUser] = (data, protocol) => _i136.ObjectUser.fromJson(data);
    map[_i137.ParentUser] = (data, protocol) => _i137.ParentUser.fromJson(data);
    map[_i138.Arena] = (data, protocol) => _i138.Arena.fromJson(data);
    map[_i139.Player] = (data, protocol) => _i139.Player.fromJson(data);
    map[_i140.Team] = (data, protocol) => _i140.Team.fromJson(data);
    map[_i141.Comment] = (data, protocol) => _i141.Comment.fromJson(data);
    map[_i142.Customer] = (data, protocol) => _i142.Customer.fromJson(data);
    map[_i143.Book] = (data, protocol) => _i143.Book.fromJson(data);
    map[_i144.Chapter] = (data, protocol) => _i144.Chapter.fromJson(data);
    map[_i145.Order] = (data, protocol) => _i145.Order.fromJson(data);
    map[_i146.Address] = (data, protocol) => _i146.Address.fromJson(data);
    map[_i147.Citizen] = (data, protocol) => _i147.Citizen.fromJson(data);
    map[_i148.Company] = (data, protocol) => _i148.Company.fromJson(data);
    map[_i149.Town] = (data, protocol) => _i149.Town.fromJson(data);
    map[_i150.Blocking] = (data, protocol) => _i150.Blocking.fromJson(data);
    map[_i151.Member] = (data, protocol) => _i151.Member.fromJson(data);
    map[_i152.Cat] = (data, protocol) => _i152.Cat.fromJson(data);
    map[_i153.Post] = (data, protocol) => _i153.Post.fromJson(data);
    map[_i154.ModuleDatatype] = (data, protocol) =>
        _i154.ModuleDatatype.fromJson(data);
    map[_i155.MyFeatureModel] = (data, protocol) =>
        _i155.MyFeatureModel.fromJson(data);
    map[_i156.MyTriggerType] = (data, protocol) =>
        _i156.MyTriggerType.fromJson(data);
    map[_i157.Nullability] = (data, protocol) =>
        _i157.Nullability.fromJson(data);
    map[_i158.ObjectFieldPersist] = (data, protocol) =>
        _i158.ObjectFieldPersist.fromJson(data);
    map[_i159.ObjectFieldScopes] = (data, protocol) =>
        _i159.ObjectFieldScopes.fromJson(data);
    map[_i160.ObjectWithBit] = (data, protocol) =>
        _i160.ObjectWithBit.fromJson(data);
    map[_i161.ObjectWithByteData] = (data, protocol) =>
        _i161.ObjectWithByteData.fromJson(data);
    map[_i162.ObjectWithCustomClass] = (data, protocol) =>
        _i162.ObjectWithCustomClass.fromJson(data);
    map[_i163.ObjectWithDuration] = (data, protocol) =>
        _i163.ObjectWithDuration.fromJson(data);
    map[_i164.ObjectWithDynamic] = (data, protocol) =>
        _i164.ObjectWithDynamic.fromJson(data);
    map[_i165.ObjectWithEnum] = (data, protocol) =>
        _i165.ObjectWithEnum.fromJson(data);
    map[_i166.ObjectWithEnumEnhanced] = (data, protocol) =>
        _i166.ObjectWithEnumEnhanced.fromJson(data);
    map[_i167.ObjectWithHalfVector] = (data, protocol) =>
        _i167.ObjectWithHalfVector.fromJson(data);
    map[_i168.ObjectWithIndex] = (data, protocol) =>
        _i168.ObjectWithIndex.fromJson(data);
    map[_i169.ObjectWithJsonb] = (data, protocol) =>
        _i169.ObjectWithJsonb.fromJson(data);
    map[_i170.ObjectWithJsonbClassLevel] = (data, protocol) =>
        _i170.ObjectWithJsonbClassLevel.fromJson(data);
    map[_i171.ObjectWithMaps] = (data, protocol) =>
        _i171.ObjectWithMaps.fromJson(data);
    map[_i172.ObjectWithNullableCustomClass] = (data, protocol) =>
        _i172.ObjectWithNullableCustomClass.fromJson(data);
    map[_i173.ObjectWithObject] = (data, protocol) =>
        _i173.ObjectWithObject.fromJson(data);
    map[_i174.ObjectWithParent] = (data, protocol) =>
        _i174.ObjectWithParent.fromJson(data);
    map[_i175.ObjectWithSealedClass] = (data, protocol) =>
        _i175.ObjectWithSealedClass.fromJson(data);
    map[_i176.ObjectWithSelfParent] = (data, protocol) =>
        _i176.ObjectWithSelfParent.fromJson(data);
    map[_i177.ObjectWithSparseVector] = (data, protocol) =>
        _i177.ObjectWithSparseVector.fromJson(data);
    map[_i178.ObjectWithUuid] = (data, protocol) =>
        _i178.ObjectWithUuid.fromJson(data);
    map[_i179.ObjectWithVector] = (data, protocol) =>
        _i179.ObjectWithVector.fromJson(data);
    map[_i180.Record] = (data, protocol) => _i180.Record.fromJson(data);
    map[_i181.RelatedUniqueData] = (data, protocol) =>
        _i181.RelatedUniqueData.fromJson(data);
    map[_i182.ExceptionWithRequiredField] = (data, protocol) =>
        _i182.ExceptionWithRequiredField.fromJson(data);
    map[_i183.ModelWithRequiredField] = (data, protocol) =>
        _i183.ModelWithRequiredField.fromJson(data);
    map[_i184.ScopeNoneFields] = (data, protocol) =>
        _i184.ScopeNoneFields.fromJson(data);
    map[_i185.ScopeServerOnlyFieldChild] = (data, protocol) =>
        _i185.ScopeServerOnlyFieldChild.fromJson(data);
    map[_i186.ScopeServerOnlyField] = (data, protocol) =>
        _i186.ScopeServerOnlyField.fromJson(data);
    map[_i187.Article] = (data, protocol) => _i187.Article.fromJson(data);
    map[_i188.ArticleList] = (data, protocol) =>
        _i188.ArticleList.fromJson(data);
    map[_i189.DefaultServerOnlyClass] = (data, protocol) =>
        _i189.DefaultServerOnlyClass.fromJson(data);
    map[_i190.DefaultServerOnlyEnum] = (data, protocol) =>
        _i190.DefaultServerOnlyEnum.fromJson(data);
    map[_i191.NotServerOnlyClass] = (data, protocol) =>
        _i191.NotServerOnlyClass.fromJson(data);
    map[_i192.NotServerOnlyEnum] = (data, protocol) =>
        _i192.NotServerOnlyEnum.fromJson(data);
    map[_i193.ServerOnlyClass] = (data, protocol) =>
        _i193.ServerOnlyClass.fromJson(data);
    map[_i194.ServerOnlyEnum] = (data, protocol) =>
        _i194.ServerOnlyEnum.fromJson(data);
    map[_i195.ServerOnlyClassField] = (data, protocol) =>
        _i195.ServerOnlyClassField.fromJson(data);
    map[_i196.ServerOnlyDefault] = (data, protocol) =>
        _i196.ServerOnlyDefault.fromJson(data);
    map[_i197.SessionAuthInfo] = (data, protocol) =>
        _i197.SessionAuthInfo.fromJson(data);
    map[_i198.SharedModelContainer] = (data, protocol) =>
        _i198.SharedModelContainer.fromJson(data);
    map[_i199.SharedModelSubclass] = (data, protocol) =>
        _i199.SharedModelSubclass.fromJson(data);
    map[_i200.SimpleData] = (data, protocol) => _i200.SimpleData.fromJson(data);
    map[_i201.SimpleDataList] = (data, protocol) =>
        _i201.SimpleDataList.fromJson(data);
    map[_i202.SimpleDataMap] = (data, protocol) =>
        _i202.SimpleDataMap.fromJson(data);
    map[_i203.SimpleDataObject] = (data, protocol) =>
        _i203.SimpleDataObject.fromJson(data);
    map[_i204.SimpleDateTime] = (data, protocol) =>
        _i204.SimpleDateTime.fromJson(data);
    map[_i205.ModelInSubfolder] = (data, protocol) =>
        _i205.ModelInSubfolder.fromJson(data);
    map[_i206.TestEnum] = (data, protocol) => _i206.TestEnum.fromJson(data);
    map[_i207.TestEnumDefaultSerialization] = (data, protocol) =>
        _i207.TestEnumDefaultSerialization.fromJson(data);
    map[_i208.TestEnumEnhanced] = (data, protocol) =>
        _i208.TestEnumEnhanced.fromJson(data);
    map[_i209.TestEnumEnhancedByName] = (data, protocol) =>
        _i209.TestEnumEnhancedByName.fromJson(data);
    map[_i210.TestEnumStringified] = (data, protocol) =>
        _i210.TestEnumStringified.fromJson(data);
    map[_i211.Types] = (data, protocol) => _i211.Types.fromJson(data);
    map[_i212.TypesList] = (data, protocol) => _i212.TypesList.fromJson(data);
    map[_i213.TypesMap] = (data, protocol) => _i213.TypesMap.fromJson(data);
    map[_i214.TypesRecord] = (data, protocol) =>
        _i214.TypesRecord.fromJson(data);
    map[_i215.TypesSet] = (data, protocol) => _i215.TypesSet.fromJson(data);
    map[_i216.TypesSetRequired] = (data, protocol) =>
        _i216.TypesSetRequired.fromJson(data);
    map[_i217.UniqueData] = (data, protocol) => _i217.UniqueData.fromJson(data);
    map[_i218.UniqueDataWithNonPersist] = (data, protocol) =>
        _i218.UniqueDataWithNonPersist.fromJson(data);
    map[_i219.UpsertTestModel] = (data, protocol) =>
        _i219.UpsertTestModel.fromJson(data);
    map[_i1.getType<_i5.ByIndexEnumWithNameValue?>()] = (data, protocol) =>
        (data != null ? _i5.ByIndexEnumWithNameValue.fromJson(data) : null);
    map[_i1.getType<_i6.ByNameEnumWithNameValue?>()] = (data, protocol) =>
        (data != null ? _i6.ByNameEnumWithNameValue.fromJson(data) : null);
    map[_i1.getType<_i7.CourseUuid?>()] = (data, protocol) =>
        (data != null ? _i7.CourseUuid.fromJson(data) : null);
    map[_i1.getType<_i8.EnrollmentInt?>()] = (data, protocol) =>
        (data != null ? _i8.EnrollmentInt.fromJson(data) : null);
    map[_i1.getType<_i9.StudentUuid?>()] = (data, protocol) =>
        (data != null ? _i9.StudentUuid.fromJson(data) : null);
    map[_i1.getType<_i10.ArenaUuid?>()] = (data, protocol) =>
        (data != null ? _i10.ArenaUuid.fromJson(data) : null);
    map[_i1.getType<_i11.PlayerUuid?>()] = (data, protocol) =>
        (data != null ? _i11.PlayerUuid.fromJson(data) : null);
    map[_i1.getType<_i12.TeamInt?>()] = (data, protocol) =>
        (data != null ? _i12.TeamInt.fromJson(data) : null);
    map[_i1.getType<_i13.CommentInt?>()] = (data, protocol) =>
        (data != null ? _i13.CommentInt.fromJson(data) : null);
    map[_i1.getType<_i14.CustomerInt?>()] = (data, protocol) =>
        (data != null ? _i14.CustomerInt.fromJson(data) : null);
    map[_i1.getType<_i15.OrderUuid?>()] = (data, protocol) =>
        (data != null ? _i15.OrderUuid.fromJson(data) : null);
    map[_i1.getType<_i16.AddressUuid?>()] = (data, protocol) =>
        (data != null ? _i16.AddressUuid.fromJson(data) : null);
    map[_i1.getType<_i17.CitizenInt?>()] = (data, protocol) =>
        (data != null ? _i17.CitizenInt.fromJson(data) : null);
    map[_i1.getType<_i18.CompanyUuid?>()] = (data, protocol) =>
        (data != null ? _i18.CompanyUuid.fromJson(data) : null);
    map[_i1.getType<_i19.TownInt?>()] = (data, protocol) =>
        (data != null ? _i19.TownInt.fromJson(data) : null);
    map[_i1.getType<_i20.ChangedIdTypeSelf?>()] = (data, protocol) =>
        (data != null ? _i20.ChangedIdTypeSelf.fromJson(data) : null);
    map[_i1
        .getType<_i21.ServerOnlyChangedIdFieldClass?>()] = (data, protocol) =>
        (data != null
        ? _i21.ServerOnlyChangedIdFieldClass.fromJson(data)
        : null);
    map[_i1.getType<_i22.BigIntDefault?>()] = (data, protocol) =>
        (data != null ? _i22.BigIntDefault.fromJson(data) : null);
    map[_i1.getType<_i23.BigIntDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i23.BigIntDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i24.BigIntDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i24.BigIntDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i25.BigIntDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i25.BigIntDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i26.BoolDefault?>()] = (data, protocol) =>
        (data != null ? _i26.BoolDefault.fromJson(data) : null);
    map[_i1.getType<_i27.BoolDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i27.BoolDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i28.BoolDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i28.BoolDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i29.BoolDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i29.BoolDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i30.DateTimeDefault?>()] = (data, protocol) =>
        (data != null ? _i30.DateTimeDefault.fromJson(data) : null);
    map[_i1.getType<_i31.DateTimeDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i31.DateTimeDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i32.DateTimeDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i32.DateTimeDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i33.DateTimeDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i33.DateTimeDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i34.DoubleDefault?>()] = (data, protocol) =>
        (data != null ? _i34.DoubleDefault.fromJson(data) : null);
    map[_i1.getType<_i35.DoubleDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i35.DoubleDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i36.DoubleDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i36.DoubleDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i37.DoubleDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i37.DoubleDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i38.DurationDefault?>()] = (data, protocol) =>
        (data != null ? _i38.DurationDefault.fromJson(data) : null);
    map[_i1.getType<_i39.DurationDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i39.DurationDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i40.DurationDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i40.DurationDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i41.DurationDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i41.DurationDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i42.EnumDefault?>()] = (data, protocol) =>
        (data != null ? _i42.EnumDefault.fromJson(data) : null);
    map[_i1.getType<_i43.EnumDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i43.EnumDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i44.EnumDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i44.EnumDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i45.EnumDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i45.EnumDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i46.ByIndexEnum?>()] = (data, protocol) =>
        (data != null ? _i46.ByIndexEnum.fromJson(data) : null);
    map[_i1.getType<_i47.ByNameEnum?>()] = (data, protocol) =>
        (data != null ? _i47.ByNameEnum.fromJson(data) : null);
    map[_i1.getType<_i48.DefaultValueEnum?>()] = (data, protocol) =>
        (data != null ? _i48.DefaultValueEnum.fromJson(data) : null);
    map[_i1.getType<_i49.DefaultException?>()] = (data, protocol) =>
        (data != null ? _i49.DefaultException.fromJson(data) : null);
    map[_i1.getType<_i50.IntDefault?>()] = (data, protocol) =>
        (data != null ? _i50.IntDefault.fromJson(data) : null);
    map[_i1.getType<_i51.IntDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i51.IntDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i52.IntDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i52.IntDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i53.IntDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i53.IntDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i54.StringDefault?>()] = (data, protocol) =>
        (data != null ? _i54.StringDefault.fromJson(data) : null);
    map[_i1.getType<_i55.StringDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i55.StringDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i56.StringDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i56.StringDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i57.StringDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i57.StringDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i58.UriDefault?>()] = (data, protocol) =>
        (data != null ? _i58.UriDefault.fromJson(data) : null);
    map[_i1.getType<_i59.UriDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i59.UriDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i60.UriDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i60.UriDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i61.UriDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i61.UriDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i62.UuidDefault?>()] = (data, protocol) =>
        (data != null ? _i62.UuidDefault.fromJson(data) : null);
    map[_i1.getType<_i63.UuidDefaultMix?>()] = (data, protocol) =>
        (data != null ? _i63.UuidDefaultMix.fromJson(data) : null);
    map[_i1.getType<_i64.UuidDefaultModel?>()] = (data, protocol) =>
        (data != null ? _i64.UuidDefaultModel.fromJson(data) : null);
    map[_i1.getType<_i65.UuidDefaultPersist?>()] = (data, protocol) =>
        (data != null ? _i65.UuidDefaultPersist.fromJson(data) : null);
    map[_i1.getType<_i66.EmptyModel?>()] = (data, protocol) =>
        (data != null ? _i66.EmptyModel.fromJson(data) : null);
    map[_i1.getType<_i67.EmptyModelRelationItem?>()] = (data, protocol) =>
        (data != null ? _i67.EmptyModelRelationItem.fromJson(data) : null);
    map[_i1.getType<_i68.EmptyModelWithTable?>()] = (data, protocol) =>
        (data != null ? _i68.EmptyModelWithTable.fromJson(data) : null);
    map[_i1.getType<_i69.RelationEmptyModel?>()] = (data, protocol) =>
        (data != null ? _i69.RelationEmptyModel.fromJson(data) : null);
    map[_i1.getType<_i70.ExceptionWithData?>()] = (data, protocol) =>
        (data != null ? _i70.ExceptionWithData.fromJson(data) : null);
    map[_i1.getType<_i71.ChildClassExplicitColumn?>()] = (data, protocol) =>
        (data != null ? _i71.ChildClassExplicitColumn.fromJson(data) : null);
    map[_i1.getType<_i72.NonTableParentClass?>()] = (data, protocol) =>
        (data != null ? _i72.NonTableParentClass.fromJson(data) : null);
    map[_i1.getType<_i73.ModifiedColumnName?>()] = (data, protocol) =>
        (data != null ? _i73.ModifiedColumnName.fromJson(data) : null);
    map[_i1.getType<_i74.Department?>()] = (data, protocol) =>
        (data != null ? _i74.Department.fromJson(data) : null);
    map[_i1.getType<_i75.Employee?>()] = (data, protocol) =>
        (data != null ? _i75.Employee.fromJson(data) : null);
    map[_i1.getType<_i76.Contractor?>()] = (data, protocol) =>
        (data != null ? _i76.Contractor.fromJson(data) : null);
    map[_i1.getType<_i77.Service?>()] = (data, protocol) =>
        (data != null ? _i77.Service.fromJson(data) : null);
    map[_i1.getType<_i78.TableWithExplicitColumnName?>()] = (data, protocol) =>
        (data != null ? _i78.TableWithExplicitColumnName.fromJson(data) : null);
    map[_i1.getType<_i79.TestGeneratedCallByeModel?>()] = (data, protocol) =>
        (data != null ? _i79.TestGeneratedCallByeModel.fromJson(data) : null);
    map[_i1.getType<_i80.TestGeneratedCallExecuteWithTriggerModel?>()] =
        (data, protocol) => (data != null
        ? _i80.TestGeneratedCallExecuteWithTriggerModel.fromJson(data)
        : null);
    map[_i1.getType<_i81.TestGeneratedCallHelloModel?>()] = (data, protocol) =>
        (data != null ? _i81.TestGeneratedCallHelloModel.fromJson(data) : null);
    map[_i1.getType<_i82.ImmutableChildObject?>()] = (data, protocol) =>
        (data != null ? _i82.ImmutableChildObject.fromJson(data) : null);
    map[_i1.getType<_i83.ImmutableChildObjectWithNoAdditionalFields?>()] =
        (data, protocol) => (data != null
        ? _i83.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
        : null);
    map[_i1.getType<_i84.ImmutableObject?>()] = (data, protocol) =>
        (data != null ? _i84.ImmutableObject.fromJson(data) : null);
    map[_i1.getType<_i85.ImmutableObjectWithImmutableObject?>()] =
        (data, protocol) => (data != null
        ? _i85.ImmutableObjectWithImmutableObject.fromJson(data)
        : null);
    map[_i1.getType<_i86.ImmutableObjectWithList?>()] = (data, protocol) =>
        (data != null ? _i86.ImmutableObjectWithList.fromJson(data) : null);
    map[_i1.getType<_i87.ImmutableObjectWithMap?>()] = (data, protocol) =>
        (data != null ? _i87.ImmutableObjectWithMap.fromJson(data) : null);
    map[_i1.getType<_i88.ImmutableObjectWithMultipleFields?>()] =
        (data, protocol) => (data != null
        ? _i88.ImmutableObjectWithMultipleFields.fromJson(data)
        : null);
    map[_i1.getType<_i89.ImmutableObjectWithNoFields?>()] = (data, protocol) =>
        (data != null ? _i89.ImmutableObjectWithNoFields.fromJson(data) : null);
    map[_i1.getType<_i90.ImmutableObjectWithRecord?>()] = (data, protocol) =>
        (data != null ? _i90.ImmutableObjectWithRecord.fromJson(data) : null);
    map[_i1.getType<_i91.ImmutableObjectWithTable?>()] = (data, protocol) =>
        (data != null ? _i91.ImmutableObjectWithTable.fromJson(data) : null);
    map[_i1
        .getType<_i92.ImmutableObjectWithTwentyFields?>()] = (data, protocol) =>
        (data != null
        ? _i92.ImmutableObjectWithTwentyFields.fromJson(data)
        : null);
    map[_i1.getType<_i93.ChildClass?>()] = (data, protocol) =>
        (data != null ? _i93.ChildClass.fromJson(data) : null);
    map[_i1.getType<_i94.ServerOnlyChildClass?>()] = (data, protocol) =>
        (data != null ? _i94.ServerOnlyChildClass.fromJson(data) : null);
    map[_i1.getType<_i95.ChildWithDefault?>()] = (data, protocol) =>
        (data != null ? _i95.ChildWithDefault.fromJson(data) : null);
    map[_i1.getType<_i96.ChildWithInheritedId?>()] = (data, protocol) =>
        (data != null ? _i96.ChildWithInheritedId.fromJson(data) : null);
    map[_i1.getType<_i97.ChildClassWithoutId?>()] = (data, protocol) =>
        (data != null ? _i97.ChildClassWithoutId.fromJson(data) : null);
    map[_i1
        .getType<_i98.ServerOnlyChildClassWithoutId?>()] = (data, protocol) =>
        (data != null
        ? _i98.ServerOnlyChildClassWithoutId.fromJson(data)
        : null);
    map[_i1.getType<_i99.ParentClass?>()] = (data, protocol) =>
        (data != null ? _i99.ParentClass.fromJson(data) : null);
    map[_i1.getType<_i100.GrandparentClass?>()] = (data, protocol) =>
        (data != null ? _i100.GrandparentClass.fromJson(data) : null);
    map[_i1.getType<_i101.ParentClassWithoutId?>()] = (data, protocol) =>
        (data != null ? _i101.ParentClassWithoutId.fromJson(data) : null);
    map[_i1.getType<_i102.GrandparentClassWithId?>()] = (data, protocol) =>
        (data != null ? _i102.GrandparentClassWithId.fromJson(data) : null);
    map[_i1.getType<_i103.ChildEntity?>()] = (data, protocol) =>
        (data != null ? _i103.ChildEntity.fromJson(data) : null);
    map[_i1.getType<_i104.BaseEntity?>()] = (data, protocol) =>
        (data != null ? _i104.BaseEntity.fromJson(data) : null);
    map[_i1.getType<_i105.ParentEntity?>()] = (data, protocol) =>
        (data != null ? _i105.ParentEntity.fromJson(data) : null);
    map[_i1.getType<_i106.NonServerOnlyParentClass?>()] = (data, protocol) =>
        (data != null ? _i106.NonServerOnlyParentClass.fromJson(data) : null);
    map[_i1.getType<_i107.ParentWithChangedId?>()] = (data, protocol) =>
        (data != null ? _i107.ParentWithChangedId.fromJson(data) : null);
    map[_i1.getType<_i108.ParentWithDefault?>()] = (data, protocol) =>
        (data != null ? _i108.ParentWithDefault.fromJson(data) : null);
    map[_i1.getType<_i109.PolymorphicGrandChild?>()] = (data, protocol) =>
        (data != null ? _i109.PolymorphicGrandChild.fromJson(data) : null);
    map[_i1.getType<_i110.PolymorphicChild?>()] = (data, protocol) =>
        (data != null ? _i110.PolymorphicChild.fromJson(data) : null);
    map[_i1.getType<_i111.PolymorphicChildContainer?>()] = (data, protocol) =>
        (data != null ? _i111.PolymorphicChildContainer.fromJson(data) : null);
    map[_i1.getType<_i112.ModulePolymorphicChildContainer?>()] =
        (data, protocol) => (data != null
        ? _i112.ModulePolymorphicChildContainer.fromJson(data)
        : null);
    map[_i1.getType<_i113.SimilarButNotParent?>()] = (data, protocol) =>
        (data != null ? _i113.SimilarButNotParent.fromJson(data) : null);
    map[_i1.getType<_i114.PolymorphicParent?>()] = (data, protocol) =>
        (data != null ? _i114.PolymorphicParent.fromJson(data) : null);
    map[_i1.getType<_i115.UnrelatedToPolymorphism?>()] = (data, protocol) =>
        (data != null ? _i115.UnrelatedToPolymorphism.fromJson(data) : null);
    map[_i1.getType<_i116.SealedGrandChild?>()] = (data, protocol) =>
        (data != null ? _i116.SealedGrandChild.fromJson(data) : null);
    map[_i1.getType<_i116.SealedChild?>()] = (data, protocol) =>
        (data != null ? _i116.SealedChild.fromJson(data) : null);
    map[_i1.getType<_i117.SealedChildOnlyRequired?>()] = (data, protocol) =>
        (data != null ? _i117.SealedChildOnlyRequired.fromJson(data) : null);
    map[_i1.getType<_i116.SealedOtherChild?>()] = (data, protocol) =>
        (data != null ? _i116.SealedOtherChild.fromJson(data) : null);
    map[_i1.getType<_i118.CityWithLongTableName?>()] = (data, protocol) =>
        (data != null ? _i118.CityWithLongTableName.fromJson(data) : null);
    map[_i1
        .getType<_i119.OrganizationWithLongTableName?>()] = (data, protocol) =>
        (data != null
        ? _i119.OrganizationWithLongTableName.fromJson(data)
        : null);
    map[_i1.getType<_i120.PersonWithLongTableName?>()] = (data, protocol) =>
        (data != null ? _i120.PersonWithLongTableName.fromJson(data) : null);
    map[_i1.getType<_i121.MaxFieldName?>()] = (data, protocol) =>
        (data != null ? _i121.MaxFieldName.fromJson(data) : null);
    map[_i1.getType<_i122.LongImplicitIdField?>()] = (data, protocol) =>
        (data != null ? _i122.LongImplicitIdField.fromJson(data) : null);
    map[_i1
        .getType<_i123.LongImplicitIdFieldCollection?>()] = (data, protocol) =>
        (data != null
        ? _i123.LongImplicitIdFieldCollection.fromJson(data)
        : null);
    map[_i1
        .getType<_i124.RelationToMultipleMaxFieldName?>()] = (data, protocol) =>
        (data != null
        ? _i124.RelationToMultipleMaxFieldName.fromJson(data)
        : null);
    map[_i1.getType<_i125.UserNote?>()] = (data, protocol) =>
        (data != null ? _i125.UserNote.fromJson(data) : null);
    map[_i1.getType<_i126.UserNoteCollection?>()] = (data, protocol) =>
        (data != null ? _i126.UserNoteCollection.fromJson(data) : null);
    map[_i1.getType<_i127.UserNoteCollectionWithALongName?>()] =
        (data, protocol) => (data != null
        ? _i127.UserNoteCollectionWithALongName.fromJson(data)
        : null);
    map[_i1.getType<_i128.UserNoteWithALongName?>()] = (data, protocol) =>
        (data != null ? _i128.UserNoteWithALongName.fromJson(data) : null);
    map[_i1.getType<_i129.MultipleMaxFieldName?>()] = (data, protocol) =>
        (data != null ? _i129.MultipleMaxFieldName.fromJson(data) : null);
    map[_i1.getType<_i130.City?>()] = (data, protocol) =>
        (data != null ? _i130.City.fromJson(data) : null);
    map[_i1.getType<_i131.Organization?>()] = (data, protocol) =>
        (data != null ? _i131.Organization.fromJson(data) : null);
    map[_i1.getType<_i132.Person?>()] = (data, protocol) =>
        (data != null ? _i132.Person.fromJson(data) : null);
    map[_i1.getType<_i133.Course?>()] = (data, protocol) =>
        (data != null ? _i133.Course.fromJson(data) : null);
    map[_i1.getType<_i134.Enrollment?>()] = (data, protocol) =>
        (data != null ? _i134.Enrollment.fromJson(data) : null);
    map[_i1.getType<_i135.Student?>()] = (data, protocol) =>
        (data != null ? _i135.Student.fromJson(data) : null);
    map[_i1.getType<_i136.ObjectUser?>()] = (data, protocol) =>
        (data != null ? _i136.ObjectUser.fromJson(data) : null);
    map[_i1.getType<_i137.ParentUser?>()] = (data, protocol) =>
        (data != null ? _i137.ParentUser.fromJson(data) : null);
    map[_i1.getType<_i138.Arena?>()] = (data, protocol) =>
        (data != null ? _i138.Arena.fromJson(data) : null);
    map[_i1.getType<_i139.Player?>()] = (data, protocol) =>
        (data != null ? _i139.Player.fromJson(data) : null);
    map[_i1.getType<_i140.Team?>()] = (data, protocol) =>
        (data != null ? _i140.Team.fromJson(data) : null);
    map[_i1.getType<_i141.Comment?>()] = (data, protocol) =>
        (data != null ? _i141.Comment.fromJson(data) : null);
    map[_i1.getType<_i142.Customer?>()] = (data, protocol) =>
        (data != null ? _i142.Customer.fromJson(data) : null);
    map[_i1.getType<_i143.Book?>()] = (data, protocol) =>
        (data != null ? _i143.Book.fromJson(data) : null);
    map[_i1.getType<_i144.Chapter?>()] = (data, protocol) =>
        (data != null ? _i144.Chapter.fromJson(data) : null);
    map[_i1.getType<_i145.Order?>()] = (data, protocol) =>
        (data != null ? _i145.Order.fromJson(data) : null);
    map[_i1.getType<_i146.Address?>()] = (data, protocol) =>
        (data != null ? _i146.Address.fromJson(data) : null);
    map[_i1.getType<_i147.Citizen?>()] = (data, protocol) =>
        (data != null ? _i147.Citizen.fromJson(data) : null);
    map[_i1.getType<_i148.Company?>()] = (data, protocol) =>
        (data != null ? _i148.Company.fromJson(data) : null);
    map[_i1.getType<_i149.Town?>()] = (data, protocol) =>
        (data != null ? _i149.Town.fromJson(data) : null);
    map[_i1.getType<_i150.Blocking?>()] = (data, protocol) =>
        (data != null ? _i150.Blocking.fromJson(data) : null);
    map[_i1.getType<_i151.Member?>()] = (data, protocol) =>
        (data != null ? _i151.Member.fromJson(data) : null);
    map[_i1.getType<_i152.Cat?>()] = (data, protocol) =>
        (data != null ? _i152.Cat.fromJson(data) : null);
    map[_i1.getType<_i153.Post?>()] = (data, protocol) =>
        (data != null ? _i153.Post.fromJson(data) : null);
    map[_i1.getType<_i154.ModuleDatatype?>()] = (data, protocol) =>
        (data != null ? _i154.ModuleDatatype.fromJson(data) : null);
    map[_i1.getType<_i155.MyFeatureModel?>()] = (data, protocol) =>
        (data != null ? _i155.MyFeatureModel.fromJson(data) : null);
    map[_i1.getType<_i156.MyTriggerType?>()] = (data, protocol) =>
        (data != null ? _i156.MyTriggerType.fromJson(data) : null);
    map[_i1.getType<_i157.Nullability?>()] = (data, protocol) =>
        (data != null ? _i157.Nullability.fromJson(data) : null);
    map[_i1.getType<_i158.ObjectFieldPersist?>()] = (data, protocol) =>
        (data != null ? _i158.ObjectFieldPersist.fromJson(data) : null);
    map[_i1.getType<_i159.ObjectFieldScopes?>()] = (data, protocol) =>
        (data != null ? _i159.ObjectFieldScopes.fromJson(data) : null);
    map[_i1.getType<_i160.ObjectWithBit?>()] = (data, protocol) =>
        (data != null ? _i160.ObjectWithBit.fromJson(data) : null);
    map[_i1.getType<_i161.ObjectWithByteData?>()] = (data, protocol) =>
        (data != null ? _i161.ObjectWithByteData.fromJson(data) : null);
    map[_i1.getType<_i162.ObjectWithCustomClass?>()] = (data, protocol) =>
        (data != null ? _i162.ObjectWithCustomClass.fromJson(data) : null);
    map[_i1.getType<_i163.ObjectWithDuration?>()] = (data, protocol) =>
        (data != null ? _i163.ObjectWithDuration.fromJson(data) : null);
    map[_i1.getType<_i164.ObjectWithDynamic?>()] = (data, protocol) =>
        (data != null ? _i164.ObjectWithDynamic.fromJson(data) : null);
    map[_i1.getType<_i165.ObjectWithEnum?>()] = (data, protocol) =>
        (data != null ? _i165.ObjectWithEnum.fromJson(data) : null);
    map[_i1.getType<_i166.ObjectWithEnumEnhanced?>()] = (data, protocol) =>
        (data != null ? _i166.ObjectWithEnumEnhanced.fromJson(data) : null);
    map[_i1.getType<_i167.ObjectWithHalfVector?>()] = (data, protocol) =>
        (data != null ? _i167.ObjectWithHalfVector.fromJson(data) : null);
    map[_i1.getType<_i168.ObjectWithIndex?>()] = (data, protocol) =>
        (data != null ? _i168.ObjectWithIndex.fromJson(data) : null);
    map[_i1.getType<_i169.ObjectWithJsonb?>()] = (data, protocol) =>
        (data != null ? _i169.ObjectWithJsonb.fromJson(data) : null);
    map[_i1.getType<_i170.ObjectWithJsonbClassLevel?>()] = (data, protocol) =>
        (data != null ? _i170.ObjectWithJsonbClassLevel.fromJson(data) : null);
    map[_i1.getType<_i171.ObjectWithMaps?>()] = (data, protocol) =>
        (data != null ? _i171.ObjectWithMaps.fromJson(data) : null);
    map[_i1
        .getType<_i172.ObjectWithNullableCustomClass?>()] = (data, protocol) =>
        (data != null
        ? _i172.ObjectWithNullableCustomClass.fromJson(data)
        : null);
    map[_i1.getType<_i173.ObjectWithObject?>()] = (data, protocol) =>
        (data != null ? _i173.ObjectWithObject.fromJson(data) : null);
    map[_i1.getType<_i174.ObjectWithParent?>()] = (data, protocol) =>
        (data != null ? _i174.ObjectWithParent.fromJson(data) : null);
    map[_i1.getType<_i175.ObjectWithSealedClass?>()] = (data, protocol) =>
        (data != null ? _i175.ObjectWithSealedClass.fromJson(data) : null);
    map[_i1.getType<_i176.ObjectWithSelfParent?>()] = (data, protocol) =>
        (data != null ? _i176.ObjectWithSelfParent.fromJson(data) : null);
    map[_i1.getType<_i177.ObjectWithSparseVector?>()] = (data, protocol) =>
        (data != null ? _i177.ObjectWithSparseVector.fromJson(data) : null);
    map[_i1.getType<_i178.ObjectWithUuid?>()] = (data, protocol) =>
        (data != null ? _i178.ObjectWithUuid.fromJson(data) : null);
    map[_i1.getType<_i179.ObjectWithVector?>()] = (data, protocol) =>
        (data != null ? _i179.ObjectWithVector.fromJson(data) : null);
    map[_i1.getType<_i180.Record?>()] = (data, protocol) =>
        (data != null ? _i180.Record.fromJson(data) : null);
    map[_i1.getType<_i181.RelatedUniqueData?>()] = (data, protocol) =>
        (data != null ? _i181.RelatedUniqueData.fromJson(data) : null);
    map[_i1.getType<_i182.ExceptionWithRequiredField?>()] = (data, protocol) =>
        (data != null ? _i182.ExceptionWithRequiredField.fromJson(data) : null);
    map[_i1.getType<_i183.ModelWithRequiredField?>()] = (data, protocol) =>
        (data != null ? _i183.ModelWithRequiredField.fromJson(data) : null);
    map[_i1.getType<_i184.ScopeNoneFields?>()] = (data, protocol) =>
        (data != null ? _i184.ScopeNoneFields.fromJson(data) : null);
    map[_i1.getType<_i185.ScopeServerOnlyFieldChild?>()] = (data, protocol) =>
        (data != null ? _i185.ScopeServerOnlyFieldChild.fromJson(data) : null);
    map[_i1.getType<_i186.ScopeServerOnlyField?>()] = (data, protocol) =>
        (data != null ? _i186.ScopeServerOnlyField.fromJson(data) : null);
    map[_i1.getType<_i187.Article?>()] = (data, protocol) =>
        (data != null ? _i187.Article.fromJson(data) : null);
    map[_i1.getType<_i188.ArticleList?>()] = (data, protocol) =>
        (data != null ? _i188.ArticleList.fromJson(data) : null);
    map[_i1.getType<_i189.DefaultServerOnlyClass?>()] = (data, protocol) =>
        (data != null ? _i189.DefaultServerOnlyClass.fromJson(data) : null);
    map[_i1.getType<_i190.DefaultServerOnlyEnum?>()] = (data, protocol) =>
        (data != null ? _i190.DefaultServerOnlyEnum.fromJson(data) : null);
    map[_i1.getType<_i191.NotServerOnlyClass?>()] = (data, protocol) =>
        (data != null ? _i191.NotServerOnlyClass.fromJson(data) : null);
    map[_i1.getType<_i192.NotServerOnlyEnum?>()] = (data, protocol) =>
        (data != null ? _i192.NotServerOnlyEnum.fromJson(data) : null);
    map[_i1.getType<_i193.ServerOnlyClass?>()] = (data, protocol) =>
        (data != null ? _i193.ServerOnlyClass.fromJson(data) : null);
    map[_i1.getType<_i194.ServerOnlyEnum?>()] = (data, protocol) =>
        (data != null ? _i194.ServerOnlyEnum.fromJson(data) : null);
    map[_i1.getType<_i195.ServerOnlyClassField?>()] = (data, protocol) =>
        (data != null ? _i195.ServerOnlyClassField.fromJson(data) : null);
    map[_i1.getType<_i196.ServerOnlyDefault?>()] = (data, protocol) =>
        (data != null ? _i196.ServerOnlyDefault.fromJson(data) : null);
    map[_i1.getType<_i197.SessionAuthInfo?>()] = (data, protocol) =>
        (data != null ? _i197.SessionAuthInfo.fromJson(data) : null);
    map[_i1.getType<_i198.SharedModelContainer?>()] = (data, protocol) =>
        (data != null ? _i198.SharedModelContainer.fromJson(data) : null);
    map[_i1.getType<_i199.SharedModelSubclass?>()] = (data, protocol) =>
        (data != null ? _i199.SharedModelSubclass.fromJson(data) : null);
    map[_i1.getType<_i200.SimpleData?>()] = (data, protocol) =>
        (data != null ? _i200.SimpleData.fromJson(data) : null);
    map[_i1.getType<_i201.SimpleDataList?>()] = (data, protocol) =>
        (data != null ? _i201.SimpleDataList.fromJson(data) : null);
    map[_i1.getType<_i202.SimpleDataMap?>()] = (data, protocol) =>
        (data != null ? _i202.SimpleDataMap.fromJson(data) : null);
    map[_i1.getType<_i203.SimpleDataObject?>()] = (data, protocol) =>
        (data != null ? _i203.SimpleDataObject.fromJson(data) : null);
    map[_i1.getType<_i204.SimpleDateTime?>()] = (data, protocol) =>
        (data != null ? _i204.SimpleDateTime.fromJson(data) : null);
    map[_i1.getType<_i205.ModelInSubfolder?>()] = (data, protocol) =>
        (data != null ? _i205.ModelInSubfolder.fromJson(data) : null);
    map[_i1.getType<_i206.TestEnum?>()] = (data, protocol) =>
        (data != null ? _i206.TestEnum.fromJson(data) : null);
    map[_i1
        .getType<_i207.TestEnumDefaultSerialization?>()] = (data, protocol) =>
        (data != null
        ? _i207.TestEnumDefaultSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i208.TestEnumEnhanced?>()] = (data, protocol) =>
        (data != null ? _i208.TestEnumEnhanced.fromJson(data) : null);
    map[_i1.getType<_i209.TestEnumEnhancedByName?>()] = (data, protocol) =>
        (data != null ? _i209.TestEnumEnhancedByName.fromJson(data) : null);
    map[_i1.getType<_i210.TestEnumStringified?>()] = (data, protocol) =>
        (data != null ? _i210.TestEnumStringified.fromJson(data) : null);
    map[_i1.getType<_i211.Types?>()] = (data, protocol) =>
        (data != null ? _i211.Types.fromJson(data) : null);
    map[_i1.getType<_i212.TypesList?>()] = (data, protocol) =>
        (data != null ? _i212.TypesList.fromJson(data) : null);
    map[_i1.getType<_i213.TypesMap?>()] = (data, protocol) =>
        (data != null ? _i213.TypesMap.fromJson(data) : null);
    map[_i1.getType<_i214.TypesRecord?>()] = (data, protocol) =>
        (data != null ? _i214.TypesRecord.fromJson(data) : null);
    map[_i1.getType<_i215.TypesSet?>()] = (data, protocol) =>
        (data != null ? _i215.TypesSet.fromJson(data) : null);
    map[_i1.getType<_i216.TypesSetRequired?>()] = (data, protocol) =>
        (data != null ? _i216.TypesSetRequired.fromJson(data) : null);
    map[_i1.getType<_i217.UniqueData?>()] = (data, protocol) =>
        (data != null ? _i217.UniqueData.fromJson(data) : null);
    map[_i1.getType<_i218.UniqueDataWithNonPersist?>()] = (data, protocol) =>
        (data != null ? _i218.UniqueDataWithNonPersist.fromJson(data) : null);
    map[_i1.getType<_i219.UpsertTestModel?>()] = (data, protocol) =>
        (data != null ? _i219.UpsertTestModel.fromJson(data) : null);
    map[List<_i8.EnrollmentInt>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i8.EnrollmentInt>(e))
        .toList();
    map[_i1.getType<List<_i8.EnrollmentInt>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i8.EnrollmentInt>(e))
              .toList()
        : null);
    map[List<_i11.PlayerUuid>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i11.PlayerUuid>(e))
        .toList();
    map[_i1.getType<List<_i11.PlayerUuid>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i11.PlayerUuid>(e))
              .toList()
        : null);
    map[List<_i15.OrderUuid>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i15.OrderUuid>(e))
        .toList();
    map[_i1.getType<List<_i15.OrderUuid>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i15.OrderUuid>(e))
              .toList()
        : null);
    map[List<_i13.CommentInt>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i13.CommentInt>(e))
        .toList();
    map[_i1.getType<List<_i13.CommentInt>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i13.CommentInt>(e))
              .toList()
        : null);
    map[List<_i20.ChangedIdTypeSelf>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i20.ChangedIdTypeSelf>(e))
        .toList();
    map[_i1.getType<List<_i20.ChangedIdTypeSelf>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i20.ChangedIdTypeSelf>(e))
              .toList()
        : null);
    map[List<_i67.EmptyModelRelationItem>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i67.EmptyModelRelationItem>(e))
        .toList();
    map[_i1.getType<List<_i67.EmptyModelRelationItem>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i67.EmptyModelRelationItem>(e))
              .toList()
        : null);
    map[List<_i75.Employee>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i75.Employee>(e))
        .toList();
    map[_i1.getType<List<_i75.Employee>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i75.Employee>(e))
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
    map[List<_i103.ChildEntity>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i103.ChildEntity>(e))
        .toList();
    map[_i1.getType<List<_i103.ChildEntity>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i103.ChildEntity>(e))
              .toList()
        : null);
    map[List<_i110.PolymorphicChild>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i110.PolymorphicChild>(e))
        .toList();
    map[List<_i110.PolymorphicChild?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i110.PolymorphicChild?>(e))
        .toList();
    map[Map<String, _i110.PolymorphicChild>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i110.PolymorphicChild>(v),
          ),
        );
    map[Map<String, _i110.PolymorphicChild?>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i110.PolymorphicChild?>(v),
          ),
        );
    map[List<_i4.ModulePolymorphicChild>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i4.ModulePolymorphicChild>(e))
        .toList();
    map[Map<String, _i4.ModulePolymorphicChild>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i4.ModulePolymorphicChild>(v),
          ),
        );
    map[List<_i120.PersonWithLongTableName>] = (data, protocol) =>
        (data as List)
            .map((e) => protocol.deserialize<_i120.PersonWithLongTableName>(e))
            .toList();
    map[_i1.getType<List<_i120.PersonWithLongTableName>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol.deserialize<_i120.PersonWithLongTableName>(e),
              )
              .toList()
        : null);
    map[List<_i119.OrganizationWithLongTableName>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<_i119.OrganizationWithLongTableName>(e),
            )
            .toList();
    map[_i1.getType<List<_i119.OrganizationWithLongTableName>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<_i119.OrganizationWithLongTableName>(e),
              )
              .toList()
        : null);
    map[List<_i122.LongImplicitIdField>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i122.LongImplicitIdField>(e))
        .toList();
    map[_i1.getType<List<_i122.LongImplicitIdField>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i122.LongImplicitIdField>(e))
              .toList()
        : null);
    map[List<_i129.MultipleMaxFieldName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i129.MultipleMaxFieldName>(e))
        .toList();
    map[_i1.getType<List<_i129.MultipleMaxFieldName>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i129.MultipleMaxFieldName>(e))
              .toList()
        : null);
    map[List<_i125.UserNote>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i125.UserNote>(e))
        .toList();
    map[_i1.getType<List<_i125.UserNote>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i125.UserNote>(e))
              .toList()
        : null);
    map[List<_i128.UserNoteWithALongName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i128.UserNoteWithALongName>(e))
        .toList();
    map[_i1.getType<List<_i128.UserNoteWithALongName>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i128.UserNoteWithALongName>(e))
              .toList()
        : null);
    map[List<_i132.Person>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i132.Person>(e))
        .toList();
    map[_i1.getType<List<_i132.Person>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i132.Person>(e))
              .toList()
        : null);
    map[List<_i131.Organization>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i131.Organization>(e))
        .toList();
    map[_i1.getType<List<_i131.Organization>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i131.Organization>(e))
              .toList()
        : null);
    map[List<_i134.Enrollment>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i134.Enrollment>(e))
        .toList();
    map[_i1.getType<List<_i134.Enrollment>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i134.Enrollment>(e))
              .toList()
        : null);
    map[List<_i139.Player>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i139.Player>(e))
        .toList();
    map[_i1.getType<List<_i139.Player>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i139.Player>(e))
              .toList()
        : null);
    map[List<_i145.Order>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i145.Order>(e))
        .toList();
    map[_i1.getType<List<_i145.Order>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i145.Order>(e))
              .toList()
        : null);
    map[List<_i144.Chapter>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i144.Chapter>(e))
        .toList();
    map[_i1.getType<List<_i144.Chapter>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i144.Chapter>(e))
              .toList()
        : null);
    map[List<_i141.Comment>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i141.Comment>(e))
        .toList();
    map[_i1.getType<List<_i141.Comment>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i141.Comment>(e))
              .toList()
        : null);
    map[List<_i150.Blocking>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i150.Blocking>(e))
        .toList();
    map[_i1.getType<List<_i150.Blocking>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i150.Blocking>(e))
              .toList()
        : null);
    map[List<_i152.Cat>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<_i152.Cat>(e)).toList();
    map[_i1.getType<List<_i152.Cat>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<_i152.Cat>(e)).toList()
        : null);
    map[List<_i4.ModuleClass>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i4.ModuleClass>(e))
        .toList();
    map[Map<String, _i4.ModuleClass>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i4.ModuleClass>(v),
      ),
    );
    map[_i1.getType<(_i4.ModuleClass,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i4.ModuleClass>(
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
    map[List<_i200.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData>(e))
        .toList();
    map[List<_i200.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i200.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i200.SimpleData>(e))
              .toList()
        : null);
    map[List<_i200.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData?>(e))
        .toList();
    map[List<_i200.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData?>(e))
        .toList();
    map[_i1.getType<List<_i200.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i200.SimpleData?>(e))
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
    map[List<_i220.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData>(e))
        .toList();
    map[List<_i220.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData>(e))
        .toList();
    map[_i1.getType<List<_i220.ByteData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i220.ByteData>(e))
              .toList()
        : null);
    map[List<_i220.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData?>(e))
        .toList();
    map[List<_i220.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData?>(e))
        .toList();
    map[_i1.getType<List<_i220.ByteData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i220.ByteData?>(e))
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
    map[_i221.CustomClassWithoutProtocolSerialization] = (data, protocol) =>
        _i221.CustomClassWithoutProtocolSerialization.fromJson(data);
    map[_i221.CustomClassWithProtocolSerialization] = (data, protocol) =>
        _i221.CustomClassWithProtocolSerialization.fromJson(data);
    map[_i221.CustomClassWithProtocolSerializationMethod] = (data, protocol) =>
        _i221.CustomClassWithProtocolSerializationMethod.fromJson(data);
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
    map[List<_i206.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.TestEnum>(e))
        .toList();
    map[List<_i206.TestEnum?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.TestEnum?>(e))
        .toList();
    map[List<List<_i206.TestEnum>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i206.TestEnum>>(e))
        .toList();
    map[List<_i206.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.TestEnum>(e))
        .toList();
    map[List<_i208.TestEnumEnhanced>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i208.TestEnumEnhanced>(e))
        .toList();
    map[List<_i209.TestEnumEnhancedByName>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i209.TestEnumEnhancedByName>(e))
        .toList();
    map[List<String>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<String>(e)).toList();
    map[_i1.getType<List<String>?>()] = (data, protocol) => (data != null
        ? (data as List).map((e) => protocol.deserialize<String>(e)).toList()
        : null);
    map[Map<String, _i200.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i200.SimpleData>(v),
      ),
    );
    map[Map<String, DateTime>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<DateTime>(v),
      ),
    );
    map[Map<String, _i220.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i220.ByteData>(v),
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
    map[Map<String, _i200.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i200.SimpleData?>(v),
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
    map[Map<String, _i220.ByteData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i220.ByteData?>(v),
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
    map[_i1.getType<_i221.CustomClassWithoutProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithoutProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i221.CustomClassWithProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i221.CustomClassWithProtocolSerializationMethod?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithProtocolSerializationMethod.fromJson(data)
        : null);
    map[List<List<_i200.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i200.SimpleData>>(e))
        .toList();
    map[List<_i200.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData>(e))
        .toList();
    map[_i1.getType<List<List<_i200.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i200.SimpleData>>(e))
              .toList()
        : null);
    map[List<_i200.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i200.SimpleData>(e))
        .toList();
    map[Map<String, List<List<Map<int, _i200.SimpleData>>?>>] =
        (data, protocol) => (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<List<List<Map<int, _i200.SimpleData>>?>>(v),
          ),
        );
    map[List<List<Map<int, _i200.SimpleData>>?>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<List<Map<int, _i200.SimpleData>>?>(e),
            )
            .toList();
    map[List<Map<int, _i200.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<int, _i200.SimpleData>>(e))
        .toList();
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<List<Map<int, _i200.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<int, _i200.SimpleData>>(e))
              .toList()
        : null);
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<String, List<List<Map<int, _i200.SimpleData>>?>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<List<List<Map<int, _i200.SimpleData>>?>>(v),
            ),
          )
        : null);
    map[List<List<Map<int, _i200.SimpleData>>?>] = (data, protocol) =>
        (data as List)
            .map(
              (e) => protocol.deserialize<List<Map<int, _i200.SimpleData>>?>(e),
            )
            .toList();
    map[List<Map<int, _i200.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<int, _i200.SimpleData>>(e))
        .toList();
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<List<Map<int, _i200.SimpleData>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<int, _i200.SimpleData>>(e))
              .toList()
        : null);
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[Map<String, Map<int, _i200.SimpleData>>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<Map<int, _i200.SimpleData>>(v),
          ),
        );
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<String, Map<int, _i200.SimpleData>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Map<int, _i200.SimpleData>>(v),
            ),
          )
        : null);
    map[Map<int, _i200.SimpleData>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<int>(e['k']),
          protocol.deserialize<_i200.SimpleData>(e['v']),
        ),
      ),
    );
    map[List<_i116.SealedParent>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i116.SealedParent>(e))
        .toList();
    map[_i1.getType<(bool,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[List<_i187.Article>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i187.Article>(e))
        .toList();
    map[List<_i193.ServerOnlyClass>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i193.ServerOnlyClass>(e))
        .toList();
    map[_i1.getType<List<_i193.ServerOnlyClass>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i193.ServerOnlyClass>(e))
              .toList()
        : null);
    map[Map<String, _i193.ServerOnlyClass>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i193.ServerOnlyClass>(v),
          ),
        );
    map[_i1.getType<Map<String, _i193.ServerOnlyClass>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i193.ServerOnlyClass>(v),
            ),
          )
        : null);
    map[List<_i221.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i221.SharedModel>(e))
        .toList();
    map[List<_i221.SharedModel?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i221.SharedModel?>(e))
        .toList();
    map[List<_i221.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i221.SharedModel>(e))
        .toList();
    map[_i1.getType<List<_i221.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i221.SharedModel>(e))
              .toList()
        : null);
    map[Map<String, _i221.SharedModel>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i221.SharedModel>(v),
      ),
    );
    map[Map<String, _i221.SharedModel>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i221.SharedModel>(v),
      ),
    );
    map[_i1.getType<Map<String, _i221.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i221.SharedModel>(v),
            ),
          )
        : null);
    map[Map<String, _i221.SharedSubclass>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i221.SharedSubclass>(v),
          ),
        );
    map[Set<_i221.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i221.SharedModel>(e))
        .toSet();
    map[Set<_i221.SharedModel>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i221.SharedModel>(e))
        .toSet();
    map[_i1.getType<Set<_i221.SharedModel>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i221.SharedModel>(e))
              .toSet()
        : null);
    map[List<_i210.TestEnumStringified>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i210.TestEnumStringified>(e))
        .toList();
    map[_i1.getType<List<_i210.TestEnumStringified>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i210.TestEnumStringified>(e))
              .toList()
        : null);
    map[_i1.getType<(_i210.TestEnumStringified,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i210.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[List<(_i210.TestEnumStringified,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i210.TestEnumStringified,)>(e))
        .toList();
    map[_i1.getType<(_i210.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<List<(_i210.TestEnumStringified,)>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i210.TestEnumStringified,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i210.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i157.Nullability,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i157.Nullability>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i210.TestEnumStringified value})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            value: protocol.deserialize<_i210.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[List<({_i210.TestEnumStringified value})>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<({_i210.TestEnumStringified value})>(e),
            )
            .toList();
    map[_i1
        .getType<({_i210.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<List<({_i210.TestEnumStringified value})>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<({_i210.TestEnumStringified value})>(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<({_i210.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<({_i4.ModuleClass value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i4.ModuleClass>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[_i1.getType<({_i157.Nullability value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i157.Nullability>(
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
    map[List<_i206.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.TestEnum>(e))
        .toList();
    map[_i1.getType<List<_i206.TestEnum>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i206.TestEnum>(e))
              .toList()
        : null);
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
        .toList();
    map[_i1.getType<List<_i211.Types>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i211.Types>(e))
              .toList()
        : null);
    map[List<Map<String, _i211.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, _i211.Types>>(e))
        .toList();
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[_i1.getType<List<Map<String, _i211.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<String, _i211.Types>>(e))
              .toList()
        : null);
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[List<List<_i211.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i211.Types>>(e))
        .toList();
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
        .toList();
    map[_i1.getType<List<List<_i211.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i211.Types>>(e))
              .toList()
        : null);
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
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
    map[List<(_i206.TestEnum,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i206.TestEnum,)>(e))
        .toList();
    map[_i1.getType<(_i206.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i206.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<List<(_i206.TestEnum,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i206.TestEnum,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i206.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i206.TestEnum>(((data as Map)['p'] as List)[0]),
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
    map[Map<_i220.ByteData, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i220.ByteData>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i220.ByteData, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i220.ByteData>(e['k']),
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
    map[Map<_i206.TestEnum, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i206.TestEnum>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i206.TestEnum, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i206.TestEnum>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i210.TestEnumStringified, String>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<_i210.TestEnumStringified>(e['k']),
              protocol.deserialize<String>(e['v']),
            ),
          ),
        );
    map[_i1.getType<Map<_i210.TestEnumStringified, String>?>()] =
        (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i210.TestEnumStringified>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i211.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i211.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<_i211.Types, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<_i211.Types>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<Map<_i211.Types, String>, String>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<Map<_i211.Types, String>>(e['k']),
              protocol.deserialize<String>(e['v']),
            ),
          ),
        );
    map[Map<_i211.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i211.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[_i1.getType<Map<Map<_i211.Types, String>, String>?>()] =
        (data, protocol) => (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<Map<_i211.Types, String>>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[Map<_i211.Types, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i211.Types>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[Map<List<_i211.Types>, String>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<List<_i211.Types>>(e['k']),
          protocol.deserialize<String>(e['v']),
        ),
      ),
    );
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
        .toList();
    map[_i1.getType<Map<List<_i211.Types>, String>?>()] = (data, protocol) =>
        (data != null
        ? Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                protocol.deserialize<List<_i211.Types>>(e['k']),
                protocol.deserialize<String>(e['v']),
              ),
            ),
          )
        : null);
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
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
    map[Map<String, _i220.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i220.ByteData>(v),
      ),
    );
    map[_i1.getType<Map<String, _i220.ByteData>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i220.ByteData>(v),
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
    map[Map<String, _i206.TestEnum>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i206.TestEnum>(v),
      ),
    );
    map[_i1.getType<Map<String, _i206.TestEnum>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i206.TestEnum>(v),
            ),
          )
        : null);
    map[Map<String, _i210.TestEnumStringified>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<_i210.TestEnumStringified>(v),
          ),
        );
    map[_i1.getType<Map<String, _i210.TestEnumStringified>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i210.TestEnumStringified>(v),
            ),
          )
        : null);
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[_i1.getType<Map<String, _i211.Types>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i211.Types>(v),
            ),
          )
        : null);
    map[Map<String, Map<String, _i211.Types>>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<Map<String, _i211.Types>>(v),
          ),
        );
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[_i1.getType<Map<String, Map<String, _i211.Types>>?>()] =
        (data, protocol) => (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<Map<String, _i211.Types>>(v),
            ),
          )
        : null);
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[Map<String, List<_i211.Types>>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<List<_i211.Types>>(v),
      ),
    );
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
        .toList();
    map[_i1.getType<Map<String, List<_i211.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<List<_i211.Types>>(v),
            ),
          )
        : null);
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
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
    map[_i1.getType<(_i220.ByteData,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i220.ByteData>(
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
    map[_i1.getType<(_i206.TestEnum,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i206.TestEnum>(
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
    map[_i1.getType<(_i200.SimpleData,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i200.SimpleData namedModel})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            namedModel: protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['n'] as Map)['namedModel'],
            ),
          );
    map[_i1.getType<(_i200.SimpleData, {_i200.SimpleData namedModel})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            namedModel: protocol.deserialize<_i200.SimpleData>(
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
            (List<(_i200.SimpleData,)>,), {
            (_i200.SimpleData, Map<String, _i200.SimpleData>) namedNestedRecord,
          })?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(List<(_i200.SimpleData,)>,)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol
                .deserialize<(_i200.SimpleData, Map<String, _i200.SimpleData>)>(
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
    map[Set<_i220.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData>(e))
        .toSet();
    map[_i1.getType<Set<_i220.ByteData>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i220.ByteData>(e))
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
    map[Set<_i206.TestEnum>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i206.TestEnum>(e))
        .toSet();
    map[_i1.getType<Set<_i206.TestEnum>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i206.TestEnum>(e))
              .toSet()
        : null);
    map[Set<_i210.TestEnumStringified>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i210.TestEnumStringified>(e))
        .toSet();
    map[_i1.getType<Set<_i210.TestEnumStringified>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i210.TestEnumStringified>(e))
              .toSet()
        : null);
    map[Set<_i211.Types>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<_i211.Types>(e)).toSet();
    map[_i1.getType<Set<_i211.Types>?>()] = (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i211.Types>(e))
              .toSet()
        : null);
    map[Set<Map<String, _i211.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Map<String, _i211.Types>>(e))
        .toSet();
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[_i1.getType<Set<Map<String, _i211.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<Map<String, _i211.Types>>(e))
              .toSet()
        : null);
    map[Map<String, _i211.Types>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i211.Types>(v),
      ),
    );
    map[Set<List<_i211.Types>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<List<_i211.Types>>(e))
        .toSet();
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
        .toList();
    map[_i1.getType<Set<List<_i211.Types>>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<List<_i211.Types>>(e))
              .toSet()
        : null);
    map[List<_i211.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i211.Types>(e))
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
    map[List<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
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
    map[List<_i220.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData>(e))
        .toList();
    map[List<_i220.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData?>(e))
        .toList();
    map[List<_i222.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData?>(e))
        .toList();
    map[List<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i222.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i222.SimpleData>(e))
              .toList()
        : null);
    map[List<_i222.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData?>(e))
        .toList();
    map[_i1.getType<List<_i222.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i222.SimpleData?>(e))
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
    map[Map<_i223.TestEnum, int>] = (data, protocol) => Map.fromEntries(
      (data as List).map(
        (e) => MapEntry(
          protocol.deserialize<_i223.TestEnum>(e['k']),
          protocol.deserialize<int>(e['v']),
        ),
      ),
    );
    map[Map<String, _i223.TestEnum>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i223.TestEnum>(v),
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
    map[Map<String, _i220.ByteData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i220.ByteData>(v),
      ),
    );
    map[Map<String, _i220.ByteData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i220.ByteData?>(v),
      ),
    );
    map[Map<String, _i222.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i222.SimpleData>(v),
      ),
    );
    map[Map<String, _i222.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i222.SimpleData?>(v),
      ),
    );
    map[Map<String, _i222.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i222.SimpleData>(v),
      ),
    );
    map[_i1.getType<Map<String, _i222.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i222.SimpleData>(v),
            ),
          )
        : null);
    map[Map<String, _i222.SimpleData?>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i222.SimpleData?>(v),
      ),
    );
    map[_i1.getType<Map<String, _i222.SimpleData?>?>()] = (data, protocol) =>
        (data != null
        ? (data as Map).map(
            (k, v) => MapEntry(
              protocol.deserialize<String>(k),
              protocol.deserialize<_i222.SimpleData?>(v),
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
    map[List<_i3.UserInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i3.UserInfo>(e))
        .toList();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toSet();
    map[List<Set<_i222.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<_i222.SimpleData>>(e))
        .toList();
    map[Set<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toSet();
    map[_i1.getType<(int, BigInt)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<BigInt>(data['p'][1]),
    );
    map[_i1.getType<(String, _i224.PolymorphicParent)>()] = (data, protocol) =>
        (
          protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
          protocol.deserialize<_i224.PolymorphicParent>(data['p'][1]),
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
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[_i1.getType<(int, _i222.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i222.SimpleData>(data['p'][1]),
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
    map[_i1.getType<({_i222.SimpleData data, int number})>()] =
        (data, protocol) => (
          data: protocol.deserialize<_i222.SimpleData>(
            ((data as Map)['n'] as Map)['data'],
          ),
          number: protocol.deserialize<int>(data['n']['number']),
        );
    map[_i1.getType<({_i222.SimpleData data, int number})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            data: protocol.deserialize<_i222.SimpleData>(
              ((data as Map)['n'] as Map)['data'],
            ),
            number: protocol.deserialize<int>(data['n']['number']),
          );
    map[_i1.getType<({_i222.SimpleData? data, int? number})>()] =
        (data, protocol) => (
          data: ((data as Map)['n'] as Map)['data'] == null
              ? null
              : protocol.deserialize<_i222.SimpleData>(data['n']['data']),
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
    map[_i1.getType<(int, {_i222.SimpleData data})>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      data: protocol.deserialize<_i222.SimpleData>(data['n']['data']),
    );
    map[_i1.getType<(int, {_i222.SimpleData data})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            data: protocol.deserialize<_i222.SimpleData>(data['n']['data']),
          );
    map[List<(int, _i222.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i222.SimpleData)>(e))
        .toList();
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[List<(int, _i222.SimpleData)?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i222.SimpleData)?>(e))
        .toList();
    map[_i1.getType<(int, _i222.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i222.SimpleData>(data['p'][1]),
          );
    map[Set<(int, _i222.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i222.SimpleData)>(e))
        .toSet();
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[Set<(int, _i222.SimpleData)?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i222.SimpleData)?>(e))
        .toSet();
    map[_i1.getType<(int, _i222.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i222.SimpleData>(data['p'][1]),
          );
    map[Set<(int, _i222.SimpleData)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(int, _i222.SimpleData)>(e))
        .toSet();
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[_i1.getType<Set<(int, _i222.SimpleData)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(int, _i222.SimpleData)>(e))
              .toSet()
        : null);
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[Map<String, (int, _i222.SimpleData)>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<(int, _i222.SimpleData)>(v),
          ),
        );
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
    );
    map[Map<String, (int, _i222.SimpleData)?>] = (data, protocol) =>
        (data as Map).map(
          (k, v) => MapEntry(
            protocol.deserialize<String>(k),
            protocol.deserialize<(int, _i222.SimpleData)?>(v),
          ),
        );
    map[_i1.getType<(int, _i222.SimpleData)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<_i222.SimpleData>(data['p'][1]),
          );
    map[Map<(String, int), (int, _i222.SimpleData)>] = (data, protocol) =>
        Map.fromEntries(
          (data as List).map(
            (e) => MapEntry(
              protocol.deserialize<(String, int)>(e['k']),
              protocol.deserialize<(int, _i222.SimpleData)>(e['v']),
            ),
          ),
        );
    map[_i1.getType<(String, int)>()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<int>(data['p'][1]),
    );
    map[_i1.getType<(int, _i222.SimpleData)>()] = (data, protocol) => (
      protocol.deserialize<int>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<_i222.SimpleData>(data['p'][1]),
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
    map[_i1.getType<({(_i222.SimpleData, double) namedSubRecord})>()] =
        (data, protocol) => (
          namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
            ((data as Map)['n'] as Map)['namedSubRecord'],
          ),
        );
    map[_i1.getType<(_i222.SimpleData, double)>()] = (data, protocol) => (
      protocol.deserialize<_i222.SimpleData>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<double>(data['p'][1]),
    );
    map[_i1.getType<({(_i222.SimpleData, double)? namedSubRecord})>()] =
        (data, protocol) => (
          namedSubRecord: ((data as Map)['n'] as Map)['namedSubRecord'] == null
              ? null
              : protocol.deserialize<(_i222.SimpleData, double)>(
                  data['n']['namedSubRecord'],
                ),
        );
    map[_i1.getType<(_i222.SimpleData, double)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i222.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            protocol.deserialize<double>(data['p'][1]),
          );
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})
        >()] = (data, protocol) => (
      protocol.deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
      namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
        data['n']['namedSubRecord'],
      ),
    );
    map[List<((int, String), {(_i222.SimpleData, double) namedSubRecord})>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    ((int, String), {(_i222.SimpleData, double) namedSubRecord})
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})
        >()] = (data, protocol) => (
      protocol.deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
      namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
        data['n']['namedSubRecord'],
      ),
    );
    map[List<((int, String), {(_i222.SimpleData, double) namedSubRecord})?>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    (
                      (int, String), {
                      (_i222.SimpleData, double) namedSubRecord,
                    })?
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          List<((int, String), {(_i222.SimpleData, double) namedSubRecord})?>?
        >()] = (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) =>
                    protocol.deserialize<
                      (
                        (int, String), {
                        (_i222.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1.getType<(int?, _i4.ProjectStreamingClass?)>()] = (data, protocol) =>
        (
          ((data as Map)['p'] as List)[0] == null
              ? null
              : protocol.deserialize<int>(data['p'][0]),
          ((data)['p'] as List)[1] == null
              ? null
              : protocol.deserialize<_i4.ProjectStreamingClass>(data['p'][1]),
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
    map[Set<_i220.ByteData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData>(e))
        .toSet();
    map[Set<_i220.ByteData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i220.ByteData?>(e))
        .toSet();
    map[Set<_i222.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData?>(e))
        .toSet();
    map[Set<Duration>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration>(e)).toSet();
    map[Set<Duration?>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<Duration?>(e)).toSet();
    map[List<_i225.Types>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i225.Types>(e))
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
          (String, (Map<String, int>, {bool flag, _i222.SimpleData simpleData}))
        >()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<
        (Map<String, int>, {bool flag, _i222.SimpleData simpleData})
      >(data['p'][1]),
    );
    map[_i1
        .getType<
          (Map<String, int>, {bool flag, _i222.SimpleData simpleData})
        >()] = (data, protocol) => (
      protocol.deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
      flag: protocol.deserialize<bool>(data['n']['flag']),
      simpleData: protocol.deserialize<_i222.SimpleData>(
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
            (Map<String, int>, {bool flag, _i222.SimpleData simpleData}),
          )?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<
              (Map<String, int>, {bool flag, _i222.SimpleData simpleData})
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
    map[_i1.getType<(_i4.ModuleClass,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i4.ModuleClass>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<(bool,)?>()] = (data, protocol) => (data == null)
        ? null
        : (protocol.deserialize<bool>(((data as Map)['p'] as List)[0]),);
    map[_i1.getType<(_i210.TestEnumStringified,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i210.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[List<(_i210.TestEnumStringified,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i210.TestEnumStringified,)>(e))
        .toList();
    map[_i1.getType<(_i210.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<List<(_i210.TestEnumStringified,)>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i210.TestEnumStringified,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i210.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i210.TestEnumStringified,)>()] = (data, protocol) => (
      protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[_i1.getType<(_i157.Nullability,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i157.Nullability>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i210.TestEnumStringified value})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            value: protocol.deserialize<_i210.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[List<({_i210.TestEnumStringified value})>] = (data, protocol) =>
        (data as List)
            .map(
              (e) =>
                  protocol.deserialize<({_i210.TestEnumStringified value})>(e),
            )
            .toList();
    map[_i1
        .getType<({_i210.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<List<({_i210.TestEnumStringified value})>?>()] =
        (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) => protocol
                    .deserialize<({_i210.TestEnumStringified value})>(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<({_i210.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1
        .getType<({_i210.TestEnumStringified value})>()] = (data, protocol) => (
      value: protocol.deserialize<_i210.TestEnumStringified>(
        ((data as Map)['n'] as Map)['value'],
      ),
    );
    map[_i1.getType<({_i4.ModuleClass value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i4.ModuleClass>(
              ((data as Map)['n'] as Map)['value'],
            ),
          );
    map[_i1.getType<({_i157.Nullability value})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            value: protocol.deserialize<_i157.Nullability>(
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
    map[List<(_i206.TestEnum,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i206.TestEnum,)>(e))
        .toList();
    map[_i1.getType<(_i206.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i206.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<List<(_i206.TestEnum,)>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<(_i206.TestEnum,)>(e))
              .toList()
        : null);
    map[_i1.getType<(_i206.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i206.TestEnum>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i206.TestEnum,)>()] = (data, protocol) => (
      protocol.deserialize<_i206.TestEnum>(((data as Map)['p'] as List)[0]),
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
    map[_i1.getType<(_i220.ByteData,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i220.ByteData>(
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
    map[_i1.getType<(_i206.TestEnum,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i206.TestEnum>(
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
    map[_i1.getType<(_i200.SimpleData,)?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
          );
    map[_i1.getType<({_i200.SimpleData namedModel})?>()] = (data, protocol) =>
        (data == null)
        ? null
        : (
            namedModel: protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['n'] as Map)['namedModel'],
            ),
          );
    map[_i1.getType<(_i200.SimpleData, {_i200.SimpleData namedModel})?>()] =
        (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<_i200.SimpleData>(
              ((data as Map)['p'] as List)[0],
            ),
            namedModel: protocol.deserialize<_i200.SimpleData>(
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
            (List<(_i200.SimpleData,)>,), {
            (_i200.SimpleData, Map<String, _i200.SimpleData>) namedNestedRecord,
          })?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(List<(_i200.SimpleData,)>,)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedNestedRecord: protocol
                .deserialize<(_i200.SimpleData, Map<String, _i200.SimpleData>)>(
                  data['n']['namedNestedRecord'],
                ),
          );
    map[_i1.getType<(List<(_i200.SimpleData,)>,)>()] = (data, protocol) => (
      protocol.deserialize<List<(_i200.SimpleData,)>>(
        ((data as Map)['p'] as List)[0],
      ),
    );
    map[List<(_i200.SimpleData,)>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<(_i200.SimpleData,)>(e))
        .toList();
    map[_i1.getType<(_i200.SimpleData,)>()] = (data, protocol) => (
      protocol.deserialize<_i200.SimpleData>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i200.SimpleData,)>()] = (data, protocol) => (
      protocol.deserialize<_i200.SimpleData>(((data as Map)['p'] as List)[0]),
    );
    map[_i1.getType<(_i200.SimpleData, Map<String, _i200.SimpleData>)>()] =
        (data, protocol) => (
          protocol.deserialize<_i200.SimpleData>(
            ((data as Map)['p'] as List)[0],
          ),
          protocol.deserialize<Map<String, _i200.SimpleData>>(data['p'][1]),
        );
    map[Map<String, _i200.SimpleData>] = (data, protocol) => (data as Map).map(
      (k, v) => MapEntry(
        protocol.deserialize<String>(k),
        protocol.deserialize<_i200.SimpleData>(v),
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
    map[_i221.CustomClass] = (data, protocol) =>
        _i221.CustomClass.fromJson(data);
    map[_i221.CustomClass2] = (data, protocol) =>
        _i221.CustomClass2.fromJson(data);
    map[_i221.CustomClassWithoutProtocolSerialization] = (data, protocol) =>
        _i221.CustomClassWithoutProtocolSerialization.fromJson(data);
    map[_i221.CustomClassWithProtocolSerialization] = (data, protocol) =>
        _i221.CustomClassWithProtocolSerialization.fromJson(data);
    map[_i221.CustomClassWithProtocolSerializationMethod] = (data, protocol) =>
        _i221.CustomClassWithProtocolSerializationMethod.fromJson(data);
    map[_i221.ProtocolCustomClass] = (data, protocol) =>
        _i221.ProtocolCustomClass.fromJson(data);
    map[_i221.ExternalCustomClass] = (data, protocol) =>
        _i221.ExternalCustomClass.fromJson(data);
    map[_i221.FreezedCustomClass] = (data, protocol) =>
        _i221.FreezedCustomClass.fromJson(data);
    map[_i1.getType<_i221.CustomClass?>()] = (data, protocol) =>
        (data != null ? _i221.CustomClass.fromJson(data) : null);
    map[_i1.getType<_i221.CustomClass2?>()] = (data, protocol) =>
        (data != null ? _i221.CustomClass2.fromJson(data) : null);
    map[_i1.getType<_i221.CustomClassWithoutProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithoutProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i221.CustomClassWithProtocolSerialization?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithProtocolSerialization.fromJson(data)
        : null);
    map[_i1.getType<_i221.CustomClassWithProtocolSerializationMethod?>()] =
        (data, protocol) => (data != null
        ? _i221.CustomClassWithProtocolSerializationMethod.fromJson(data)
        : null);
    map[_i1.getType<_i221.ProtocolCustomClass?>()] = (data, protocol) =>
        (data != null ? _i221.ProtocolCustomClass.fromJson(data) : null);
    map[_i1.getType<_i221.ExternalCustomClass?>()] = (data, protocol) =>
        (data != null ? _i221.ExternalCustomClass.fromJson(data) : null);
    map[_i1.getType<_i221.FreezedCustomClass?>()] = (data, protocol) =>
        (data != null ? _i221.FreezedCustomClass.fromJson(data) : null);
    map[List<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toList();
    map[List<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toList();
    map[List<_i3.UserInfo>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i3.UserInfo>(e))
        .toList();
    map[List<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toList();
    map[_i1.getType<List<_i222.SimpleData>?>()] = (data, protocol) =>
        (data != null
        ? (data as List)
              .map((e) => protocol.deserialize<_i222.SimpleData>(e))
              .toList()
        : null);
    map[List<_i222.SimpleData?>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData?>(e))
        .toList();
    map[Set<int>] = (data, protocol) =>
        (data as List).map((e) => protocol.deserialize<int>(e)).toSet();
    map[Set<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toSet();
    map[List<Set<_i222.SimpleData>>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<Set<_i222.SimpleData>>(e))
        .toList();
    map[Set<_i222.SimpleData>] = (data, protocol) => (data as List)
        .map((e) => protocol.deserialize<_i222.SimpleData>(e))
        .toSet();
    map[_i1.getType<(String, _i224.PolymorphicParent)>()] = (data, protocol) =>
        (
          protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
          protocol.deserialize<_i224.PolymorphicParent>(data['p'][1]),
        );
    map[_i1.getType<(int?,)?>()] = (data, protocol) => (data == null)
        ? null
        : (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : protocol.deserialize<int>(data['p'][0]),
          );
    map[List<((int, String), {(_i222.SimpleData, double) namedSubRecord})?>] =
        (data, protocol) => (data as List)
            .map(
              (e) =>
                  protocol.deserialize<
                    (
                      (int, String), {
                      (_i222.SimpleData, double) namedSubRecord,
                    })?
                  >(e),
            )
            .toList();
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1
        .getType<
          List<((int, String), {(_i222.SimpleData, double) namedSubRecord})?>?
        >()] = (data, protocol) => (data != null
        ? (data as List)
              .map(
                (e) =>
                    protocol.deserialize<
                      (
                        (int, String), {
                        (_i222.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
        : null);
    map[_i1
        .getType<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<(int, String)>(
              ((data as Map)['p'] as List)[0],
            ),
            namedSubRecord: protocol.deserialize<(_i222.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          );
    map[_i1.getType<(int?, _i4.ProjectStreamingClass?)>()] = (data, protocol) =>
        (
          ((data as Map)['p'] as List)[0] == null
              ? null
              : protocol.deserialize<int>(data['p'][0]),
          ((data)['p'] as List)[1] == null
              ? null
              : protocol.deserialize<_i4.ProjectStreamingClass>(data['p'][1]),
        );
    map[_i1
        .getType<
          (String, (Map<String, int>, {bool flag, _i222.SimpleData simpleData}))
        >()] = (data, protocol) => (
      protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
      protocol.deserialize<
        (Map<String, int>, {bool flag, _i222.SimpleData simpleData})
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
            (Map<String, int>, {bool flag, _i222.SimpleData simpleData}),
          )?
        >()] = (data, protocol) => (data == null)
        ? null
        : (
            protocol.deserialize<String>(((data as Map)['p'] as List)[0]),
            protocol.deserialize<
              (Map<String, int>, {bool flag, _i222.SimpleData simpleData})
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
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i221.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i221.CustomClass => 'CustomClass',
      _i221.CustomClass2 => 'CustomClass2',
      _i221.CustomClassWithoutProtocolSerialization =>
        'CustomClassWithoutProtocolSerialization',
      _i221.CustomClassWithProtocolSerialization =>
        'CustomClassWithProtocolSerialization',
      _i221.CustomClassWithProtocolSerializationMethod =>
        'CustomClassWithProtocolSerializationMethod',
      _i221.ProtocolCustomClass => 'ProtocolCustomClass',
      _i221.ExternalCustomClass => 'ExternalCustomClass',
      _i221.FreezedCustomClass => 'FreezedCustomClass',
      _i5.ByIndexEnumWithNameValue => 'ByIndexEnumWithNameValue',
      _i6.ByNameEnumWithNameValue => 'ByNameEnumWithNameValue',
      _i7.CourseUuid => 'CourseUuid',
      _i8.EnrollmentInt => 'EnrollmentInt',
      _i9.StudentUuid => 'StudentUuid',
      _i10.ArenaUuid => 'ArenaUuid',
      _i11.PlayerUuid => 'PlayerUuid',
      _i12.TeamInt => 'TeamInt',
      _i13.CommentInt => 'CommentInt',
      _i14.CustomerInt => 'CustomerInt',
      _i15.OrderUuid => 'OrderUuid',
      _i16.AddressUuid => 'AddressUuid',
      _i17.CitizenInt => 'CitizenInt',
      _i18.CompanyUuid => 'CompanyUuid',
      _i19.TownInt => 'TownInt',
      _i20.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _i21.ServerOnlyChangedIdFieldClass => 'ServerOnlyChangedIdFieldClass',
      _i22.BigIntDefault => 'BigIntDefault',
      _i23.BigIntDefaultMix => 'BigIntDefaultMix',
      _i24.BigIntDefaultModel => 'BigIntDefaultModel',
      _i25.BigIntDefaultPersist => 'BigIntDefaultPersist',
      _i26.BoolDefault => 'BoolDefault',
      _i27.BoolDefaultMix => 'BoolDefaultMix',
      _i28.BoolDefaultModel => 'BoolDefaultModel',
      _i29.BoolDefaultPersist => 'BoolDefaultPersist',
      _i30.DateTimeDefault => 'DateTimeDefault',
      _i31.DateTimeDefaultMix => 'DateTimeDefaultMix',
      _i32.DateTimeDefaultModel => 'DateTimeDefaultModel',
      _i33.DateTimeDefaultPersist => 'DateTimeDefaultPersist',
      _i34.DoubleDefault => 'DoubleDefault',
      _i35.DoubleDefaultMix => 'DoubleDefaultMix',
      _i36.DoubleDefaultModel => 'DoubleDefaultModel',
      _i37.DoubleDefaultPersist => 'DoubleDefaultPersist',
      _i38.DurationDefault => 'DurationDefault',
      _i39.DurationDefaultMix => 'DurationDefaultMix',
      _i40.DurationDefaultModel => 'DurationDefaultModel',
      _i41.DurationDefaultPersist => 'DurationDefaultPersist',
      _i42.EnumDefault => 'EnumDefault',
      _i43.EnumDefaultMix => 'EnumDefaultMix',
      _i44.EnumDefaultModel => 'EnumDefaultModel',
      _i45.EnumDefaultPersist => 'EnumDefaultPersist',
      _i46.ByIndexEnum => 'ByIndexEnum',
      _i47.ByNameEnum => 'ByNameEnum',
      _i48.DefaultValueEnum => 'DefaultValueEnum',
      _i49.DefaultException => 'DefaultException',
      _i50.IntDefault => 'IntDefault',
      _i51.IntDefaultMix => 'IntDefaultMix',
      _i52.IntDefaultModel => 'IntDefaultModel',
      _i53.IntDefaultPersist => 'IntDefaultPersist',
      _i54.StringDefault => 'StringDefault',
      _i55.StringDefaultMix => 'StringDefaultMix',
      _i56.StringDefaultModel => 'StringDefaultModel',
      _i57.StringDefaultPersist => 'StringDefaultPersist',
      _i58.UriDefault => 'UriDefault',
      _i59.UriDefaultMix => 'UriDefaultMix',
      _i60.UriDefaultModel => 'UriDefaultModel',
      _i61.UriDefaultPersist => 'UriDefaultPersist',
      _i62.UuidDefault => 'UuidDefault',
      _i63.UuidDefaultMix => 'UuidDefaultMix',
      _i64.UuidDefaultModel => 'UuidDefaultModel',
      _i65.UuidDefaultPersist => 'UuidDefaultPersist',
      _i66.EmptyModel => 'EmptyModel',
      _i67.EmptyModelRelationItem => 'EmptyModelRelationItem',
      _i68.EmptyModelWithTable => 'EmptyModelWithTable',
      _i69.RelationEmptyModel => 'RelationEmptyModel',
      _i70.ExceptionWithData => 'ExceptionWithData',
      _i71.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i72.NonTableParentClass => 'NonTableParentClass',
      _i73.ModifiedColumnName => 'ModifiedColumnName',
      _i74.Department => 'Department',
      _i75.Employee => 'Employee',
      _i76.Contractor => 'Contractor',
      _i77.Service => 'Service',
      _i78.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i79.TestGeneratedCallByeModel => 'TestGeneratedCallByeModel',
      _i80.TestGeneratedCallExecuteWithTriggerModel =>
        'TestGeneratedCallExecuteWithTriggerModel',
      _i81.TestGeneratedCallHelloModel => 'TestGeneratedCallHelloModel',
      _i82.ImmutableChildObject => 'ImmutableChildObject',
      _i83.ImmutableChildObjectWithNoAdditionalFields =>
        'ImmutableChildObjectWithNoAdditionalFields',
      _i84.ImmutableObject => 'ImmutableObject',
      _i85.ImmutableObjectWithImmutableObject =>
        'ImmutableObjectWithImmutableObject',
      _i86.ImmutableObjectWithList => 'ImmutableObjectWithList',
      _i87.ImmutableObjectWithMap => 'ImmutableObjectWithMap',
      _i88.ImmutableObjectWithMultipleFields =>
        'ImmutableObjectWithMultipleFields',
      _i89.ImmutableObjectWithNoFields => 'ImmutableObjectWithNoFields',
      _i90.ImmutableObjectWithRecord => 'ImmutableObjectWithRecord',
      _i91.ImmutableObjectWithTable => 'ImmutableObjectWithTable',
      _i92.ImmutableObjectWithTwentyFields => 'ImmutableObjectWithTwentyFields',
      _i93.ChildClass => 'ChildClass',
      _i94.ServerOnlyChildClass => 'ServerOnlyChildClass',
      _i95.ChildWithDefault => 'ChildWithDefault',
      _i96.ChildWithInheritedId => 'ChildWithInheritedId',
      _i97.ChildClassWithoutId => 'ChildClassWithoutId',
      _i98.ServerOnlyChildClassWithoutId => 'ServerOnlyChildClassWithoutId',
      _i99.ParentClass => 'ParentClass',
      _i100.GrandparentClass => 'GrandparentClass',
      _i101.ParentClassWithoutId => 'ParentClassWithoutId',
      _i102.GrandparentClassWithId => 'GrandparentClassWithId',
      _i103.ChildEntity => 'ChildEntity',
      _i104.BaseEntity => 'BaseEntity',
      _i105.ParentEntity => 'ParentEntity',
      _i106.NonServerOnlyParentClass => 'NonServerOnlyParentClass',
      _i107.ParentWithChangedId => 'ParentWithChangedId',
      _i108.ParentWithDefault => 'ParentWithDefault',
      _i109.PolymorphicGrandChild => 'PolymorphicGrandChild',
      _i110.PolymorphicChild => 'PolymorphicChild',
      _i111.PolymorphicChildContainer => 'PolymorphicChildContainer',
      _i112.ModulePolymorphicChildContainer =>
        'ModulePolymorphicChildContainer',
      _i113.SimilarButNotParent => 'SimilarButNotParent',
      _i114.PolymorphicParent => 'PolymorphicParent',
      _i115.UnrelatedToPolymorphism => 'UnrelatedToPolymorphism',
      _i116.SealedGrandChild => 'SealedGrandChild',
      _i116.SealedChild => 'SealedChild',
      _i117.SealedChildOnlyRequired => 'SealedChildOnlyRequired',
      _i116.SealedOtherChild => 'SealedOtherChild',
      _i118.CityWithLongTableName => 'CityWithLongTableName',
      _i119.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i120.PersonWithLongTableName => 'PersonWithLongTableName',
      _i121.MaxFieldName => 'MaxFieldName',
      _i122.LongImplicitIdField => 'LongImplicitIdField',
      _i123.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i124.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i125.UserNote => 'UserNote',
      _i126.UserNoteCollection => 'UserNoteCollection',
      _i127.UserNoteCollectionWithALongName =>
        'UserNoteCollectionWithALongName',
      _i128.UserNoteWithALongName => 'UserNoteWithALongName',
      _i129.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i130.City => 'City',
      _i131.Organization => 'Organization',
      _i132.Person => 'Person',
      _i133.Course => 'Course',
      _i134.Enrollment => 'Enrollment',
      _i135.Student => 'Student',
      _i136.ObjectUser => 'ObjectUser',
      _i137.ParentUser => 'ParentUser',
      _i138.Arena => 'Arena',
      _i139.Player => 'Player',
      _i140.Team => 'Team',
      _i141.Comment => 'Comment',
      _i142.Customer => 'Customer',
      _i143.Book => 'Book',
      _i144.Chapter => 'Chapter',
      _i145.Order => 'Order',
      _i146.Address => 'Address',
      _i147.Citizen => 'Citizen',
      _i148.Company => 'Company',
      _i149.Town => 'Town',
      _i150.Blocking => 'Blocking',
      _i151.Member => 'Member',
      _i152.Cat => 'Cat',
      _i153.Post => 'Post',
      _i154.ModuleDatatype => 'ModuleDatatype',
      _i155.MyFeatureModel => 'MyFeatureModel',
      _i156.MyTriggerType => 'MyTriggerType',
      _i157.Nullability => 'Nullability',
      _i158.ObjectFieldPersist => 'ObjectFieldPersist',
      _i159.ObjectFieldScopes => 'ObjectFieldScopes',
      _i160.ObjectWithBit => 'ObjectWithBit',
      _i161.ObjectWithByteData => 'ObjectWithByteData',
      _i162.ObjectWithCustomClass => 'ObjectWithCustomClass',
      _i163.ObjectWithDuration => 'ObjectWithDuration',
      _i164.ObjectWithDynamic => 'ObjectWithDynamic',
      _i165.ObjectWithEnum => 'ObjectWithEnum',
      _i166.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i167.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i168.ObjectWithIndex => 'ObjectWithIndex',
      _i169.ObjectWithJsonb => 'ObjectWithJsonb',
      _i170.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i171.ObjectWithMaps => 'ObjectWithMaps',
      _i172.ObjectWithNullableCustomClass => 'ObjectWithNullableCustomClass',
      _i173.ObjectWithObject => 'ObjectWithObject',
      _i174.ObjectWithParent => 'ObjectWithParent',
      _i175.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i176.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i177.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i178.ObjectWithUuid => 'ObjectWithUuid',
      _i179.ObjectWithVector => 'ObjectWithVector',
      _i180.Record => 'Record',
      _i181.RelatedUniqueData => 'RelatedUniqueData',
      _i182.ExceptionWithRequiredField => 'ExceptionWithRequiredField',
      _i183.ModelWithRequiredField => 'ModelWithRequiredField',
      _i184.ScopeNoneFields => 'ScopeNoneFields',
      _i185.ScopeServerOnlyFieldChild => 'ScopeServerOnlyFieldChild',
      _i186.ScopeServerOnlyField => 'ScopeServerOnlyField',
      _i187.Article => 'Article',
      _i188.ArticleList => 'ArticleList',
      _i189.DefaultServerOnlyClass => 'DefaultServerOnlyClass',
      _i190.DefaultServerOnlyEnum => 'DefaultServerOnlyEnum',
      _i191.NotServerOnlyClass => 'NotServerOnlyClass',
      _i192.NotServerOnlyEnum => 'NotServerOnlyEnum',
      _i193.ServerOnlyClass => 'ServerOnlyClass',
      _i194.ServerOnlyEnum => 'ServerOnlyEnum',
      _i195.ServerOnlyClassField => 'ServerOnlyClassField',
      _i196.ServerOnlyDefault => 'ServerOnlyDefault',
      _i197.SessionAuthInfo => 'SessionAuthInfo',
      _i198.SharedModelContainer => 'SharedModelContainer',
      _i199.SharedModelSubclass => 'SharedModelSubclass',
      _i200.SimpleData => 'SimpleData',
      _i201.SimpleDataList => 'SimpleDataList',
      _i202.SimpleDataMap => 'SimpleDataMap',
      _i203.SimpleDataObject => 'SimpleDataObject',
      _i204.SimpleDateTime => 'SimpleDateTime',
      _i205.ModelInSubfolder => 'ModelInSubfolder',
      _i206.TestEnum => 'TestEnum',
      _i207.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i208.TestEnumEnhanced => 'TestEnumEnhanced',
      _i209.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i210.TestEnumStringified => 'TestEnumStringified',
      _i211.Types => 'Types',
      _i212.TypesList => 'TypesList',
      _i213.TypesMap => 'TypesMap',
      _i214.TypesRecord => 'TypesRecord',
      _i215.TypesSet => 'TypesSet',
      _i216.TypesSetRequired => 'TypesSetRequired',
      _i217.UniqueData => 'UniqueData',
      _i218.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
      _i219.UpsertTestModel => 'UpsertTestModel',
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
      case _i221.CustomClass():
        return 'CustomClass';
      case _i221.CustomClass2():
        return 'CustomClass2';
      case _i221.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _i221.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _i221.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _i221.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _i221.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _i221.FreezedCustomClass():
        return 'FreezedCustomClass';
      case _i5.ByIndexEnumWithNameValue():
        return 'ByIndexEnumWithNameValue';
      case _i6.ByNameEnumWithNameValue():
        return 'ByNameEnumWithNameValue';
      case _i7.CourseUuid():
        return 'CourseUuid';
      case _i8.EnrollmentInt():
        return 'EnrollmentInt';
      case _i9.StudentUuid():
        return 'StudentUuid';
      case _i10.ArenaUuid():
        return 'ArenaUuid';
      case _i11.PlayerUuid():
        return 'PlayerUuid';
      case _i12.TeamInt():
        return 'TeamInt';
      case _i13.CommentInt():
        return 'CommentInt';
      case _i14.CustomerInt():
        return 'CustomerInt';
      case _i15.OrderUuid():
        return 'OrderUuid';
      case _i16.AddressUuid():
        return 'AddressUuid';
      case _i17.CitizenInt():
        return 'CitizenInt';
      case _i18.CompanyUuid():
        return 'CompanyUuid';
      case _i19.TownInt():
        return 'TownInt';
      case _i20.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _i21.ServerOnlyChangedIdFieldClass():
        return 'ServerOnlyChangedIdFieldClass';
      case _i22.BigIntDefault():
        return 'BigIntDefault';
      case _i23.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i24.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _i25.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _i26.BoolDefault():
        return 'BoolDefault';
      case _i27.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _i28.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i29.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _i30.DateTimeDefault():
        return 'DateTimeDefault';
      case _i31.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _i32.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _i33.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _i34.DoubleDefault():
        return 'DoubleDefault';
      case _i35.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i36.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _i37.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _i38.DurationDefault():
        return 'DurationDefault';
      case _i39.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i40.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _i41.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _i42.EnumDefault():
        return 'EnumDefault';
      case _i43.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _i44.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i45.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i46.ByIndexEnum():
        return 'ByIndexEnum';
      case _i47.ByNameEnum():
        return 'ByNameEnum';
      case _i48.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _i49.DefaultException():
        return 'DefaultException';
      case _i50.IntDefault():
        return 'IntDefault';
      case _i51.IntDefaultMix():
        return 'IntDefaultMix';
      case _i52.IntDefaultModel():
        return 'IntDefaultModel';
      case _i53.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i54.StringDefault():
        return 'StringDefault';
      case _i55.StringDefaultMix():
        return 'StringDefaultMix';
      case _i56.StringDefaultModel():
        return 'StringDefaultModel';
      case _i57.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i58.UriDefault():
        return 'UriDefault';
      case _i59.UriDefaultMix():
        return 'UriDefaultMix';
      case _i60.UriDefaultModel():
        return 'UriDefaultModel';
      case _i61.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _i62.UuidDefault():
        return 'UuidDefault';
      case _i63.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i64.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i65.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _i66.EmptyModel():
        return 'EmptyModel';
      case _i67.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _i68.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _i69.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _i70.ExceptionWithData():
        return 'ExceptionWithData';
      case _i71.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i72.NonTableParentClass():
        return 'NonTableParentClass';
      case _i73.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i74.Department():
        return 'Department';
      case _i75.Employee():
        return 'Employee';
      case _i76.Contractor():
        return 'Contractor';
      case _i77.Service():
        return 'Service';
      case _i78.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i79.TestGeneratedCallByeModel():
        return 'TestGeneratedCallByeModel';
      case _i80.TestGeneratedCallExecuteWithTriggerModel():
        return 'TestGeneratedCallExecuteWithTriggerModel';
      case _i81.TestGeneratedCallHelloModel():
        return 'TestGeneratedCallHelloModel';
      case _i82.ImmutableChildObject():
        return 'ImmutableChildObject';
      case _i83.ImmutableChildObjectWithNoAdditionalFields():
        return 'ImmutableChildObjectWithNoAdditionalFields';
      case _i84.ImmutableObject():
        return 'ImmutableObject';
      case _i85.ImmutableObjectWithImmutableObject():
        return 'ImmutableObjectWithImmutableObject';
      case _i86.ImmutableObjectWithList():
        return 'ImmutableObjectWithList';
      case _i87.ImmutableObjectWithMap():
        return 'ImmutableObjectWithMap';
      case _i88.ImmutableObjectWithMultipleFields():
        return 'ImmutableObjectWithMultipleFields';
      case _i89.ImmutableObjectWithNoFields():
        return 'ImmutableObjectWithNoFields';
      case _i90.ImmutableObjectWithRecord():
        return 'ImmutableObjectWithRecord';
      case _i91.ImmutableObjectWithTable():
        return 'ImmutableObjectWithTable';
      case _i92.ImmutableObjectWithTwentyFields():
        return 'ImmutableObjectWithTwentyFields';
      case _i93.ChildClass():
        return 'ChildClass';
      case _i94.ServerOnlyChildClass():
        return 'ServerOnlyChildClass';
      case _i95.ChildWithDefault():
        return 'ChildWithDefault';
      case _i96.ChildWithInheritedId():
        return 'ChildWithInheritedId';
      case _i97.ChildClassWithoutId():
        return 'ChildClassWithoutId';
      case _i98.ServerOnlyChildClassWithoutId():
        return 'ServerOnlyChildClassWithoutId';
      case _i99.ParentClass():
        return 'ParentClass';
      case _i100.GrandparentClass():
        return 'GrandparentClass';
      case _i101.ParentClassWithoutId():
        return 'ParentClassWithoutId';
      case _i102.GrandparentClassWithId():
        return 'GrandparentClassWithId';
      case _i103.ChildEntity():
        return 'ChildEntity';
      case _i104.BaseEntity():
        return 'BaseEntity';
      case _i105.ParentEntity():
        return 'ParentEntity';
      case _i106.NonServerOnlyParentClass():
        return 'NonServerOnlyParentClass';
      case _i107.ParentWithChangedId():
        return 'ParentWithChangedId';
      case _i108.ParentWithDefault():
        return 'ParentWithDefault';
      case _i109.PolymorphicGrandChild():
        return 'PolymorphicGrandChild';
      case _i110.PolymorphicChild():
        return 'PolymorphicChild';
      case _i111.PolymorphicChildContainer():
        return 'PolymorphicChildContainer';
      case _i112.ModulePolymorphicChildContainer():
        return 'ModulePolymorphicChildContainer';
      case _i113.SimilarButNotParent():
        return 'SimilarButNotParent';
      case _i114.PolymorphicParent():
        return 'PolymorphicParent';
      case _i115.UnrelatedToPolymorphism():
        return 'UnrelatedToPolymorphism';
      case _i116.SealedGrandChild():
        return 'SealedGrandChild';
      case _i116.SealedChild():
        return 'SealedChild';
      case _i117.SealedChildOnlyRequired():
        return 'SealedChildOnlyRequired';
      case _i116.SealedOtherChild():
        return 'SealedOtherChild';
      case _i118.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i119.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i120.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i121.MaxFieldName():
        return 'MaxFieldName';
      case _i122.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i123.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i124.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i125.UserNote():
        return 'UserNote';
      case _i126.UserNoteCollection():
        return 'UserNoteCollection';
      case _i127.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i128.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i129.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i130.City():
        return 'City';
      case _i131.Organization():
        return 'Organization';
      case _i132.Person():
        return 'Person';
      case _i133.Course():
        return 'Course';
      case _i134.Enrollment():
        return 'Enrollment';
      case _i135.Student():
        return 'Student';
      case _i136.ObjectUser():
        return 'ObjectUser';
      case _i137.ParentUser():
        return 'ParentUser';
      case _i138.Arena():
        return 'Arena';
      case _i139.Player():
        return 'Player';
      case _i140.Team():
        return 'Team';
      case _i141.Comment():
        return 'Comment';
      case _i142.Customer():
        return 'Customer';
      case _i143.Book():
        return 'Book';
      case _i144.Chapter():
        return 'Chapter';
      case _i145.Order():
        return 'Order';
      case _i146.Address():
        return 'Address';
      case _i147.Citizen():
        return 'Citizen';
      case _i148.Company():
        return 'Company';
      case _i149.Town():
        return 'Town';
      case _i150.Blocking():
        return 'Blocking';
      case _i151.Member():
        return 'Member';
      case _i152.Cat():
        return 'Cat';
      case _i153.Post():
        return 'Post';
      case _i154.ModuleDatatype():
        return 'ModuleDatatype';
      case _i155.MyFeatureModel():
        return 'MyFeatureModel';
      case _i156.MyTriggerType():
        return 'MyTriggerType';
      case _i157.Nullability():
        return 'Nullability';
      case _i158.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i159.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i160.ObjectWithBit():
        return 'ObjectWithBit';
      case _i161.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i162.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _i163.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i164.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _i165.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i166.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i167.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i168.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i169.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i170.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i171.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i172.ObjectWithNullableCustomClass():
        return 'ObjectWithNullableCustomClass';
      case _i173.ObjectWithObject():
        return 'ObjectWithObject';
      case _i174.ObjectWithParent():
        return 'ObjectWithParent';
      case _i175.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i176.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i177.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i178.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i179.ObjectWithVector():
        return 'ObjectWithVector';
      case _i180.Record():
        return 'Record';
      case _i181.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i182.ExceptionWithRequiredField():
        return 'ExceptionWithRequiredField';
      case _i183.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i184.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _i185.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _i186.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _i187.Article():
        return 'Article';
      case _i188.ArticleList():
        return 'ArticleList';
      case _i189.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i190.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _i191.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _i192.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _i193.ServerOnlyClass():
        return 'ServerOnlyClass';
      case _i194.ServerOnlyEnum():
        return 'ServerOnlyEnum';
      case _i195.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _i196.ServerOnlyDefault():
        return 'ServerOnlyDefault';
      case _i197.SessionAuthInfo():
        return 'SessionAuthInfo';
      case _i198.SharedModelContainer():
        return 'SharedModelContainer';
      case _i199.SharedModelSubclass():
        return 'SharedModelSubclass';
      case _i200.SimpleData():
        return 'SimpleData';
      case _i201.SimpleDataList():
        return 'SimpleDataList';
      case _i202.SimpleDataMap():
        return 'SimpleDataMap';
      case _i203.SimpleDataObject():
        return 'SimpleDataObject';
      case _i204.SimpleDateTime():
        return 'SimpleDateTime';
      case _i205.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _i206.TestEnum():
        return 'TestEnum';
      case _i207.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i208.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i209.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i210.TestEnumStringified():
        return 'TestEnumStringified';
      case _i211.Types():
        return 'Types';
      case _i212.TypesList():
        return 'TypesList';
      case _i213.TypesMap():
        return 'TypesMap';
      case _i214.TypesRecord():
        return 'TypesRecord';
      case _i215.TypesSet():
        return 'TypesSet';
      case _i216.TypesSetRequired():
        return 'TypesSetRequired';
      case _i217.UniqueData():
        return 'UniqueData';
      case _i218.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _i219.UpsertTestModel():
        return 'UpsertTestModel';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i222.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i3.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i222.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i222.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i222.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i222.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (String, _i224.PolymorphicParent)) {
      return '(String,PolymorphicParent)';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data
        is List<
          ((int, String), {(_i222.SimpleData, double) namedSubRecord})?
        >?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (int?, _i4.ProjectStreamingClass?)) {
      return '(int?,serverpod_test_module.ProjectStreamingClass?)';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i222.SimpleData simpleData}),
        )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i222.SimpleData simpleData}),
        )?) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?';
    }
    if (data is List<(String, int)>?) {
      return 'List<(String,int)>?';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_module.$className';
    }
    className = _i221.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_shared.$className';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod.$className';
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
      return deserialize<_i221.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i221.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i221.CustomClassWithoutProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i221.CustomClassWithProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i221.CustomClassWithProtocolSerializationMethod>(
        data['data'],
      );
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i221.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i221.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i221.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_i5.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_i6.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'CourseUuid') {
      return deserialize<_i7.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i8.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i9.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i10.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i11.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i12.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i13.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_i14.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_i15.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_i16.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_i17.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i18.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_i19.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_i20.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChangedIdFieldClass') {
      return deserialize<_i21.ServerOnlyChangedIdFieldClass>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i22.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i23.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i24.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i25.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i26.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i27.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i28.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i29.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i30.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i31.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i32.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i33.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i34.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i35.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i36.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i37.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i38.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i39.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i40.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i41.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i42.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i43.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i44.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i45.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i46.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i47.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_i48.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i49.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i50.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i51.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i52.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i53.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i54.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i55.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i56.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i57.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i58.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i59.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i60.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i61.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i62.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i63.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i64.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i65.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i66.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i67.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i68.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i69.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i70.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i71.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i72.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i73.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i74.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i75.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i76.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i77.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i78.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'TestGeneratedCallByeModel') {
      return deserialize<_i79.TestGeneratedCallByeModel>(data['data']);
    }
    if (dataClassName == 'TestGeneratedCallExecuteWithTriggerModel') {
      return deserialize<_i80.TestGeneratedCallExecuteWithTriggerModel>(
        data['data'],
      );
    }
    if (dataClassName == 'TestGeneratedCallHelloModel') {
      return deserialize<_i81.TestGeneratedCallHelloModel>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObject') {
      return deserialize<_i82.ImmutableChildObject>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObjectWithNoAdditionalFields') {
      return deserialize<_i83.ImmutableChildObjectWithNoAdditionalFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObject') {
      return deserialize<_i84.ImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithImmutableObject') {
      return deserialize<_i85.ImmutableObjectWithImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithList') {
      return deserialize<_i86.ImmutableObjectWithList>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMap') {
      return deserialize<_i87.ImmutableObjectWithMap>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMultipleFields') {
      return deserialize<_i88.ImmutableObjectWithMultipleFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithNoFields') {
      return deserialize<_i89.ImmutableObjectWithNoFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithRecord') {
      return deserialize<_i90.ImmutableObjectWithRecord>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTable') {
      return deserialize<_i91.ImmutableObjectWithTable>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTwentyFields') {
      return deserialize<_i92.ImmutableObjectWithTwentyFields>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i93.ChildClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClass') {
      return deserialize<_i94.ServerOnlyChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i95.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ChildWithInheritedId') {
      return deserialize<_i96.ChildWithInheritedId>(data['data']);
    }
    if (dataClassName == 'ChildClassWithoutId') {
      return deserialize<_i97.ChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClassWithoutId') {
      return deserialize<_i98.ServerOnlyChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i99.ParentClass>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i100.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClassWithoutId') {
      return deserialize<_i101.ParentClassWithoutId>(data['data']);
    }
    if (dataClassName == 'GrandparentClassWithId') {
      return deserialize<_i102.GrandparentClassWithId>(data['data']);
    }
    if (dataClassName == 'ChildEntity') {
      return deserialize<_i103.ChildEntity>(data['data']);
    }
    if (dataClassName == 'BaseEntity') {
      return deserialize<_i104.BaseEntity>(data['data']);
    }
    if (dataClassName == 'ParentEntity') {
      return deserialize<_i105.ParentEntity>(data['data']);
    }
    if (dataClassName == 'NonServerOnlyParentClass') {
      return deserialize<_i106.NonServerOnlyParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithChangedId') {
      return deserialize<_i107.ParentWithChangedId>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i108.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'PolymorphicGrandChild') {
      return deserialize<_i109.PolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChild') {
      return deserialize<_i110.PolymorphicChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChildContainer') {
      return deserialize<_i111.PolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChildContainer') {
      return deserialize<_i112.ModulePolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'SimilarButNotParent') {
      return deserialize<_i113.SimilarButNotParent>(data['data']);
    }
    if (dataClassName == 'PolymorphicParent') {
      return deserialize<_i114.PolymorphicParent>(data['data']);
    }
    if (dataClassName == 'UnrelatedToPolymorphism') {
      return deserialize<_i115.UnrelatedToPolymorphism>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i116.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i116.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedChildOnlyRequired') {
      return deserialize<_i117.SealedChildOnlyRequired>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i116.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i118.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i119.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i120.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i121.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i122.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i123.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i124.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i125.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i126.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i127.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i128.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i129.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i130.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i131.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i132.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i133.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i134.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i135.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i136.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i137.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i138.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i139.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i140.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i141.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i142.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i143.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i144.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i145.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i146.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i147.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i148.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i149.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i150.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i151.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i152.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i153.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i154.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i155.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'MyTriggerType') {
      return deserialize<_i156.MyTriggerType>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i157.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i158.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i159.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i160.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i161.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i162.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i163.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithDynamic') {
      return deserialize<_i164.ObjectWithDynamic>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i165.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i166.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i167.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i168.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_i169.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i170.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i171.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithNullableCustomClass') {
      return deserialize<_i172.ObjectWithNullableCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i173.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i174.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i175.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i176.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i177.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i178.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i179.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_i180.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i181.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ExceptionWithRequiredField') {
      return deserialize<_i182.ExceptionWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i183.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i184.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i185.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i186.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'Article') {
      return deserialize<_i187.Article>(data['data']);
    }
    if (dataClassName == 'ArticleList') {
      return deserialize<_i188.ArticleList>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i189.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i190.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i191.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i192.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClass') {
      return deserialize<_i193.ServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyEnum') {
      return deserialize<_i194.ServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i195.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'ServerOnlyDefault') {
      return deserialize<_i196.ServerOnlyDefault>(data['data']);
    }
    if (dataClassName == 'SessionAuthInfo') {
      return deserialize<_i197.SessionAuthInfo>(data['data']);
    }
    if (dataClassName == 'SharedModelContainer') {
      return deserialize<_i198.SharedModelContainer>(data['data']);
    }
    if (dataClassName == 'SharedModelSubclass') {
      return deserialize<_i199.SharedModelSubclass>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i200.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i201.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i202.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i203.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i204.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_i205.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i206.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i207.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i208.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i209.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i210.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i211.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i212.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i213.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_i214.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i215.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_i216.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i217.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i218.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_i219.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_shared.')) {
      data['className'] = dataClassName.substring(22);
      return _i221.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i222.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i3.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i222.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i222.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i222.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i222.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(String,PolymorphicParent)') {
      return deserialize<(String, _i224.PolymorphicParent)>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
        List<((int, String), {(_i222.SimpleData, double) namedSubRecord})?>?
      >(data['data']);
    }
    if (dataClassName ==
        '(int?,serverpod_test_module.ProjectStreamingClass?)') {
      return deserialize<(int?, _i4.ProjectStreamingClass?)>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i222.SimpleData simpleData}))
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i222.SimpleData simpleData}))?
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>?') {
      return deserialize<List<(String, int)>?>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i3.Protocol().registerHostProtocol('serverpod_test', this);
    _i4.Protocol().registerHostProtocol('serverpod_test', this);
    _i221.Protocol().registerHostProtocol('serverpod_test', this);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i3.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i4.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i7.CourseUuid:
        return _i7.CourseUuid.t;
      case _i8.EnrollmentInt:
        return _i8.EnrollmentInt.t;
      case _i9.StudentUuid:
        return _i9.StudentUuid.t;
      case _i10.ArenaUuid:
        return _i10.ArenaUuid.t;
      case _i11.PlayerUuid:
        return _i11.PlayerUuid.t;
      case _i12.TeamInt:
        return _i12.TeamInt.t;
      case _i13.CommentInt:
        return _i13.CommentInt.t;
      case _i14.CustomerInt:
        return _i14.CustomerInt.t;
      case _i15.OrderUuid:
        return _i15.OrderUuid.t;
      case _i16.AddressUuid:
        return _i16.AddressUuid.t;
      case _i17.CitizenInt:
        return _i17.CitizenInt.t;
      case _i18.CompanyUuid:
        return _i18.CompanyUuid.t;
      case _i19.TownInt:
        return _i19.TownInt.t;
      case _i20.ChangedIdTypeSelf:
        return _i20.ChangedIdTypeSelf.t;
      case _i21.ServerOnlyChangedIdFieldClass:
        return _i21.ServerOnlyChangedIdFieldClass.t;
      case _i22.BigIntDefault:
        return _i22.BigIntDefault.t;
      case _i23.BigIntDefaultMix:
        return _i23.BigIntDefaultMix.t;
      case _i24.BigIntDefaultModel:
        return _i24.BigIntDefaultModel.t;
      case _i25.BigIntDefaultPersist:
        return _i25.BigIntDefaultPersist.t;
      case _i26.BoolDefault:
        return _i26.BoolDefault.t;
      case _i27.BoolDefaultMix:
        return _i27.BoolDefaultMix.t;
      case _i28.BoolDefaultModel:
        return _i28.BoolDefaultModel.t;
      case _i29.BoolDefaultPersist:
        return _i29.BoolDefaultPersist.t;
      case _i30.DateTimeDefault:
        return _i30.DateTimeDefault.t;
      case _i31.DateTimeDefaultMix:
        return _i31.DateTimeDefaultMix.t;
      case _i32.DateTimeDefaultModel:
        return _i32.DateTimeDefaultModel.t;
      case _i33.DateTimeDefaultPersist:
        return _i33.DateTimeDefaultPersist.t;
      case _i34.DoubleDefault:
        return _i34.DoubleDefault.t;
      case _i35.DoubleDefaultMix:
        return _i35.DoubleDefaultMix.t;
      case _i36.DoubleDefaultModel:
        return _i36.DoubleDefaultModel.t;
      case _i37.DoubleDefaultPersist:
        return _i37.DoubleDefaultPersist.t;
      case _i38.DurationDefault:
        return _i38.DurationDefault.t;
      case _i39.DurationDefaultMix:
        return _i39.DurationDefaultMix.t;
      case _i40.DurationDefaultModel:
        return _i40.DurationDefaultModel.t;
      case _i41.DurationDefaultPersist:
        return _i41.DurationDefaultPersist.t;
      case _i42.EnumDefault:
        return _i42.EnumDefault.t;
      case _i43.EnumDefaultMix:
        return _i43.EnumDefaultMix.t;
      case _i44.EnumDefaultModel:
        return _i44.EnumDefaultModel.t;
      case _i45.EnumDefaultPersist:
        return _i45.EnumDefaultPersist.t;
      case _i50.IntDefault:
        return _i50.IntDefault.t;
      case _i51.IntDefaultMix:
        return _i51.IntDefaultMix.t;
      case _i52.IntDefaultModel:
        return _i52.IntDefaultModel.t;
      case _i53.IntDefaultPersist:
        return _i53.IntDefaultPersist.t;
      case _i54.StringDefault:
        return _i54.StringDefault.t;
      case _i55.StringDefaultMix:
        return _i55.StringDefaultMix.t;
      case _i56.StringDefaultModel:
        return _i56.StringDefaultModel.t;
      case _i57.StringDefaultPersist:
        return _i57.StringDefaultPersist.t;
      case _i58.UriDefault:
        return _i58.UriDefault.t;
      case _i59.UriDefaultMix:
        return _i59.UriDefaultMix.t;
      case _i60.UriDefaultModel:
        return _i60.UriDefaultModel.t;
      case _i61.UriDefaultPersist:
        return _i61.UriDefaultPersist.t;
      case _i62.UuidDefault:
        return _i62.UuidDefault.t;
      case _i63.UuidDefaultMix:
        return _i63.UuidDefaultMix.t;
      case _i64.UuidDefaultModel:
        return _i64.UuidDefaultModel.t;
      case _i65.UuidDefaultPersist:
        return _i65.UuidDefaultPersist.t;
      case _i67.EmptyModelRelationItem:
        return _i67.EmptyModelRelationItem.t;
      case _i68.EmptyModelWithTable:
        return _i68.EmptyModelWithTable.t;
      case _i69.RelationEmptyModel:
        return _i69.RelationEmptyModel.t;
      case _i71.ChildClassExplicitColumn:
        return _i71.ChildClassExplicitColumn.t;
      case _i73.ModifiedColumnName:
        return _i73.ModifiedColumnName.t;
      case _i74.Department:
        return _i74.Department.t;
      case _i75.Employee:
        return _i75.Employee.t;
      case _i76.Contractor:
        return _i76.Contractor.t;
      case _i77.Service:
        return _i77.Service.t;
      case _i78.TableWithExplicitColumnName:
        return _i78.TableWithExplicitColumnName.t;
      case _i91.ImmutableObjectWithTable:
        return _i91.ImmutableObjectWithTable.t;
      case _i96.ChildWithInheritedId:
        return _i96.ChildWithInheritedId.t;
      case _i97.ChildClassWithoutId:
        return _i97.ChildClassWithoutId.t;
      case _i99.ParentClass:
        return _i99.ParentClass.t;
      case _i103.ChildEntity:
        return _i103.ChildEntity.t;
      case _i105.ParentEntity:
        return _i105.ParentEntity.t;
      case _i118.CityWithLongTableName:
        return _i118.CityWithLongTableName.t;
      case _i119.OrganizationWithLongTableName:
        return _i119.OrganizationWithLongTableName.t;
      case _i120.PersonWithLongTableName:
        return _i120.PersonWithLongTableName.t;
      case _i121.MaxFieldName:
        return _i121.MaxFieldName.t;
      case _i122.LongImplicitIdField:
        return _i122.LongImplicitIdField.t;
      case _i123.LongImplicitIdFieldCollection:
        return _i123.LongImplicitIdFieldCollection.t;
      case _i124.RelationToMultipleMaxFieldName:
        return _i124.RelationToMultipleMaxFieldName.t;
      case _i125.UserNote:
        return _i125.UserNote.t;
      case _i126.UserNoteCollection:
        return _i126.UserNoteCollection.t;
      case _i127.UserNoteCollectionWithALongName:
        return _i127.UserNoteCollectionWithALongName.t;
      case _i128.UserNoteWithALongName:
        return _i128.UserNoteWithALongName.t;
      case _i129.MultipleMaxFieldName:
        return _i129.MultipleMaxFieldName.t;
      case _i130.City:
        return _i130.City.t;
      case _i131.Organization:
        return _i131.Organization.t;
      case _i132.Person:
        return _i132.Person.t;
      case _i133.Course:
        return _i133.Course.t;
      case _i134.Enrollment:
        return _i134.Enrollment.t;
      case _i135.Student:
        return _i135.Student.t;
      case _i136.ObjectUser:
        return _i136.ObjectUser.t;
      case _i137.ParentUser:
        return _i137.ParentUser.t;
      case _i138.Arena:
        return _i138.Arena.t;
      case _i139.Player:
        return _i139.Player.t;
      case _i140.Team:
        return _i140.Team.t;
      case _i141.Comment:
        return _i141.Comment.t;
      case _i142.Customer:
        return _i142.Customer.t;
      case _i143.Book:
        return _i143.Book.t;
      case _i144.Chapter:
        return _i144.Chapter.t;
      case _i145.Order:
        return _i145.Order.t;
      case _i146.Address:
        return _i146.Address.t;
      case _i147.Citizen:
        return _i147.Citizen.t;
      case _i148.Company:
        return _i148.Company.t;
      case _i149.Town:
        return _i149.Town.t;
      case _i150.Blocking:
        return _i150.Blocking.t;
      case _i151.Member:
        return _i151.Member.t;
      case _i152.Cat:
        return _i152.Cat.t;
      case _i153.Post:
        return _i153.Post.t;
      case _i158.ObjectFieldPersist:
        return _i158.ObjectFieldPersist.t;
      case _i159.ObjectFieldScopes:
        return _i159.ObjectFieldScopes.t;
      case _i160.ObjectWithBit:
        return _i160.ObjectWithBit.t;
      case _i161.ObjectWithByteData:
        return _i161.ObjectWithByteData.t;
      case _i163.ObjectWithDuration:
        return _i163.ObjectWithDuration.t;
      case _i164.ObjectWithDynamic:
        return _i164.ObjectWithDynamic.t;
      case _i165.ObjectWithEnum:
        return _i165.ObjectWithEnum.t;
      case _i166.ObjectWithEnumEnhanced:
        return _i166.ObjectWithEnumEnhanced.t;
      case _i167.ObjectWithHalfVector:
        return _i167.ObjectWithHalfVector.t;
      case _i168.ObjectWithIndex:
        return _i168.ObjectWithIndex.t;
      case _i169.ObjectWithJsonb:
        return _i169.ObjectWithJsonb.t;
      case _i170.ObjectWithJsonbClassLevel:
        return _i170.ObjectWithJsonbClassLevel.t;
      case _i173.ObjectWithObject:
        return _i173.ObjectWithObject.t;
      case _i174.ObjectWithParent:
        return _i174.ObjectWithParent.t;
      case _i176.ObjectWithSelfParent:
        return _i176.ObjectWithSelfParent.t;
      case _i177.ObjectWithSparseVector:
        return _i177.ObjectWithSparseVector.t;
      case _i178.ObjectWithUuid:
        return _i178.ObjectWithUuid.t;
      case _i179.ObjectWithVector:
        return _i179.ObjectWithVector.t;
      case _i181.RelatedUniqueData:
        return _i181.RelatedUniqueData.t;
      case _i183.ModelWithRequiredField:
        return _i183.ModelWithRequiredField.t;
      case _i184.ScopeNoneFields:
        return _i184.ScopeNoneFields.t;
      case _i198.SharedModelContainer:
        return _i198.SharedModelContainer.t;
      case _i200.SimpleData:
        return _i200.SimpleData.t;
      case _i204.SimpleDateTime:
        return _i204.SimpleDateTime.t;
      case _i211.Types:
        return _i211.Types.t;
      case _i217.UniqueData:
        return _i217.UniqueData.t;
      case _i218.UniqueDataWithNonPersist:
        return _i218.UniqueDataWithNonPersist.t;
      case _i219.UpsertTestModel:
        return _i219.UpsertTestModel.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test';

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
    if (record is (String, _i224.PolymorphicParent)) {
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
    if (record is (int, _i222.SimpleData)) {
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
    if (record is ({_i222.SimpleData data, int number})) {
      return {
        "n": {
          "data": record.data.toJson(),
          "number": record.number,
        },
      };
    }
    if (record is ({_i222.SimpleData? data, int? number})) {
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
    if (record is (int, {_i222.SimpleData data})) {
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
    if (record is ({(_i222.SimpleData, double) namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (_i222.SimpleData, double)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2,
        ],
      };
    }
    if (record is ({(_i222.SimpleData, double)? namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record
        is ((int, String), {(_i222.SimpleData, double) namedSubRecord})) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (int?, _i4.ProjectStreamingClass?)) {
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
          (Map<String, int>, {bool flag, _i222.SimpleData simpleData}),
        )) {
      return {
        "p": [
          record.$1,
          mapRecordToJson(record.$2),
        ],
      };
    }
    if (record
        is (Map<String, int>, {bool flag, _i222.SimpleData simpleData})) {
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
    if (record is (_i4.ModuleClass,)) {
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
    if (record is (_i210.TestEnumStringified,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i157.Nullability,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i210.TestEnumStringified value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i4.ModuleClass value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i157.Nullability value})) {
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
    if (record is (_i206.TestEnum,)) {
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
    if (record is (_i220.ByteData,)) {
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
    if (record is (_i200.SimpleData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i200.SimpleData namedModel})) {
      return {
        "n": {
          "namedModel": record.namedModel.toJson(),
        },
      };
    }
    if (record is (_i200.SimpleData, {_i200.SimpleData namedModel})) {
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
          (List<(_i200.SimpleData,)>,), {
          (_i200.SimpleData, Map<String, _i200.SimpleData>) namedNestedRecord,
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
    if (record is (List<(_i200.SimpleData,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (_i200.SimpleData, Map<String, _i200.SimpleData>)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2.toJson(),
        ],
      };
    }
    try {
      return _i3.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i4.Protocol().mapRecordToJson(record);
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
