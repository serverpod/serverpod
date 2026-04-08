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
import 'defaults/decimal/decimal_default.dart' as _i30;
import 'defaults/decimal/decimal_default_mix.dart' as _i31;
import 'defaults/decimal/decimal_default_model.dart' as _i32;
import 'defaults/decimal/decimal_default_persist.dart' as _i33;
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
import 'immutable/immutable_child_object.dart' as _i79;
import 'immutable/immutable_child_object_with_no_additional_fields.dart'
    as _i80;
import 'immutable/immutable_object.dart' as _i81;
import 'immutable/immutable_object_with_immutable_object.dart' as _i82;
import 'immutable/immutable_object_with_list.dart' as _i83;
import 'immutable/immutable_object_with_map.dart' as _i84;
import 'immutable/immutable_object_with_multiple_fields.dart' as _i85;
import 'immutable/immutable_object_with_no_fields.dart' as _i86;
import 'immutable/immutable_object_with_record.dart' as _i87;
import 'immutable/immutable_object_with_table.dart' as _i88;
import 'immutable/immutable_object_with_twenty_fields.dart' as _i89;
import 'inheritance/child_class.dart' as _i90;
import 'inheritance/child_with_default.dart' as _i91;
import 'inheritance/child_without_id.dart' as _i92;
import 'inheritance/parent_class.dart' as _i93;
import 'inheritance/grandparent_class.dart' as _i94;
import 'inheritance/parent_without_id.dart' as _i95;
import 'inheritance/grandparent_with_id.dart' as _i96;
import 'inheritance/list_relation_of_child/child_entity.dart' as _i97;
import 'inheritance/list_relation_of_child/base_entity.dart' as _i98;
import 'inheritance/list_relation_of_child/parent_entity.dart' as _i99;
import 'inheritance/parent_non_server_only.dart' as _i100;
import 'inheritance/parent_with_default.dart' as _i101;
import 'inheritance/polymorphism/grandchild.dart' as _i102;
import 'inheritance/polymorphism/child.dart' as _i103;
import 'inheritance/polymorphism/container.dart' as _i104;
import 'inheritance/polymorphism/container_module.dart' as _i105;
import 'inheritance/polymorphism/other.dart' as _i106;
import 'inheritance/polymorphism/parent.dart' as _i107;
import 'inheritance/polymorphism/unrelated.dart' as _i108;
import 'inheritance/sealed_parent.dart' as _i109;
import 'inheritance/sealed_parent_nullable_field.dart' as _i110;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i111;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i112;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i113;
import 'long_identifiers/max_field_name.dart' as _i114;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i115;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i116;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i117;
import 'long_identifiers/models_with_relations/user_note.dart' as _i118;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i119;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i120;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i121;
import 'long_identifiers/multiple_max_field_name.dart' as _i122;
import 'models_with_list_relations/city.dart' as _i123;
import 'models_with_list_relations/organization.dart' as _i124;
import 'models_with_list_relations/person.dart' as _i125;
import 'models_with_relations/many_to_many/course.dart' as _i126;
import 'models_with_relations/many_to_many/enrollment.dart' as _i127;
import 'models_with_relations/many_to_many/student.dart' as _i128;
import 'models_with_relations/module/object_user.dart' as _i129;
import 'models_with_relations/module/parent_user.dart' as _i130;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i131;
import 'models_with_relations/nested_one_to_many/player.dart' as _i132;
import 'models_with_relations/nested_one_to_many/team.dart' as _i133;
import 'models_with_relations/one_to_many/comment.dart' as _i134;
import 'models_with_relations/one_to_many/customer.dart' as _i135;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i136;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i137;
import 'models_with_relations/one_to_many/order.dart' as _i138;
import 'models_with_relations/one_to_one/address.dart' as _i139;
import 'models_with_relations/one_to_one/citizen.dart' as _i140;
import 'models_with_relations/one_to_one/company.dart' as _i141;
import 'models_with_relations/one_to_one/town.dart' as _i142;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i143;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i144;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i145;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i146;
import 'module_datatype.dart' as _i147;
import 'my_feature/models/my_feature_model.dart' as _i148;
import 'my_trigger_type.dart' as _i149;
import 'nullability.dart' as _i150;
import 'object_field_persist.dart' as _i151;
import 'object_field_scopes.dart' as _i152;
import 'object_with_bit.dart' as _i153;
import 'object_with_bytedata.dart' as _i154;
import 'object_with_custom_class.dart' as _i155;
import 'object_with_decimal.dart' as _i156;
import 'object_with_decimal_precision.dart' as _i157;
import 'object_with_duration.dart' as _i158;
import 'object_with_enum.dart' as _i159;
import 'object_with_enum_enhanced.dart' as _i160;
import 'object_with_half_vector.dart' as _i161;
import 'object_with_index.dart' as _i162;
import 'object_with_maps.dart' as _i163;
import 'object_with_nullable_custom_class.dart' as _i164;
import 'object_with_object.dart' as _i165;
import 'object_with_parent.dart' as _i166;
import 'object_with_sealed_class.dart' as _i167;
import 'object_with_self_parent.dart' as _i168;
import 'object_with_sparse_vector.dart' as _i169;
import 'object_with_uuid.dart' as _i170;
import 'object_with_vector.dart' as _i171;
import 'record.dart' as _i172;
import 'related_unique_data.dart' as _i173;
import 'required/exception_with_required_field.dart' as _i174;
import 'required/model_with_required_field.dart' as _i175;
import 'scopes/scope_none_fields.dart' as _i176;
import 'scopes/scope_server_only_field_child.dart' as _i177;
import 'scopes/scope_server_only_field.dart' as _i178;
import 'scopes/serverOnly/default_server_only_class.dart' as _i179;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i180;
import 'scopes/serverOnly/not_server_only_class.dart' as _i181;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i182;
import 'scopes/server_only_class_field.dart' as _i183;
import 'server_only_default.dart' as _i184;
import 'session_auth_info.dart' as _i185;
import 'shared_model_container.dart' as _i186;
import 'shared_model_subclass.dart' as _i187;
import 'simple_data.dart' as _i188;
import 'simple_data_list.dart' as _i189;
import 'simple_data_map.dart' as _i190;
import 'simple_data_object.dart' as _i191;
import 'simple_date_time.dart' as _i192;
import 'subfolder/model_in_subfolder.dart' as _i193;
import 'test_enum.dart' as _i194;
import 'test_enum_default_serialization.dart' as _i195;
import 'test_enum_enhanced.dart' as _i196;
import 'test_enum_enhanced_by_name.dart' as _i197;
import 'test_enum_stringified.dart' as _i198;
import 'types.dart' as _i199;
import 'types_list.dart' as _i200;
import 'types_map.dart' as _i201;
import 'types_record.dart' as _i202;
import 'types_set.dart' as _i203;
import 'types_set_required.dart' as _i204;
import 'unique_data.dart' as _i205;
import 'unique_data_with_non_persist.dart' as _i206;
import 'package:serverpod_test_module_client/serverpod_test_module_client.dart'
    as _i207;
import 'dart:typed_data' as _i208;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i209;
import 'package:serverpod_test_client/src/protocol/simple_data.dart' as _i210;
import 'package:serverpod_test_client/src/protocol/test_enum.dart' as _i211;
import 'package:serverpod_auth_client/serverpod_auth_client.dart' as _i212;
import 'package:serverpod_test_client/src/protocol/inheritance/polymorphism/parent.dart'
    as _i213;
import 'package:serverpod_test_client/src/protocol/types.dart' as _i214;
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
export 'defaults/decimal/decimal_default.dart';
export 'defaults/decimal/decimal_default_mix.dart';
export 'defaults/decimal/decimal_default_model.dart';
export 'defaults/decimal/decimal_default_persist.dart';
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
export 'object_with_decimal.dart';
export 'object_with_decimal_precision.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_enum_enhanced.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
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
export 'client.dart';

class Protocol extends _i1.SerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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
    if (t == _i30.DecimalDefault) {
      return _i30.DecimalDefault.fromJson(data) as T;
    }
    if (t == _i31.DecimalDefaultMix) {
      return _i31.DecimalDefaultMix.fromJson(data) as T;
    }
    if (t == _i32.DecimalDefaultModel) {
      return _i32.DecimalDefaultModel.fromJson(data) as T;
    }
    if (t == _i33.DecimalDefaultPersist) {
      return _i33.DecimalDefaultPersist.fromJson(data) as T;
    }
    if (t == _i34.DoubleDefault) {
      return _i34.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i35.DoubleDefaultMix) {
      return _i35.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i36.DoubleDefaultModel) {
      return _i36.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i37.DoubleDefaultPersist) {
      return _i37.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i38.DurationDefault) {
      return _i38.DurationDefault.fromJson(data) as T;
    }
    if (t == _i39.DurationDefaultMix) {
      return _i39.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i40.DurationDefaultModel) {
      return _i40.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i41.DurationDefaultPersist) {
      return _i41.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i42.EnumDefault) {
      return _i42.EnumDefault.fromJson(data) as T;
    }
    if (t == _i43.EnumDefaultMix) {
      return _i43.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i44.EnumDefaultModel) {
      return _i44.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i45.EnumDefaultPersist) {
      return _i45.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i46.ByIndexEnum) {
      return _i46.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i47.ByNameEnum) {
      return _i47.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i48.DefaultValueEnum) {
      return _i48.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _i49.DefaultException) {
      return _i49.DefaultException.fromJson(data) as T;
    }
    if (t == _i50.IntDefault) {
      return _i50.IntDefault.fromJson(data) as T;
    }
    if (t == _i51.IntDefaultMix) {
      return _i51.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i52.IntDefaultModel) {
      return _i52.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i53.IntDefaultPersist) {
      return _i53.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i54.StringDefault) {
      return _i54.StringDefault.fromJson(data) as T;
    }
    if (t == _i55.StringDefaultMix) {
      return _i55.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i56.StringDefaultModel) {
      return _i56.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i57.StringDefaultPersist) {
      return _i57.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i58.UriDefault) {
      return _i58.UriDefault.fromJson(data) as T;
    }
    if (t == _i59.UriDefaultMix) {
      return _i59.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i60.UriDefaultModel) {
      return _i60.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i61.UriDefaultPersist) {
      return _i61.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i62.UuidDefault) {
      return _i62.UuidDefault.fromJson(data) as T;
    }
    if (t == _i63.UuidDefaultMix) {
      return _i63.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i64.UuidDefaultModel) {
      return _i64.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i65.UuidDefaultPersist) {
      return _i65.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i66.EmptyModel) {
      return _i66.EmptyModel.fromJson(data) as T;
    }
    if (t == _i67.EmptyModelRelationItem) {
      return _i67.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i68.EmptyModelWithTable) {
      return _i68.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i69.RelationEmptyModel) {
      return _i69.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i70.ExceptionWithData) {
      return _i70.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i71.ChildClassExplicitColumn) {
      return _i71.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i72.NonTableParentClass) {
      return _i72.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i73.ModifiedColumnName) {
      return _i73.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _i74.Department) {
      return _i74.Department.fromJson(data) as T;
    }
    if (t == _i75.Employee) {
      return _i75.Employee.fromJson(data) as T;
    }
    if (t == _i76.Contractor) {
      return _i76.Contractor.fromJson(data) as T;
    }
    if (t == _i77.Service) {
      return _i77.Service.fromJson(data) as T;
    }
    if (t == _i78.TableWithExplicitColumnName) {
      return _i78.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _i79.ImmutableChildObject) {
      return _i79.ImmutableChildObject.fromJson(data) as T;
    }
    if (t == _i80.ImmutableChildObjectWithNoAdditionalFields) {
      return _i80.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
          as T;
    }
    if (t == _i81.ImmutableObject) {
      return _i81.ImmutableObject.fromJson(data) as T;
    }
    if (t == _i82.ImmutableObjectWithImmutableObject) {
      return _i82.ImmutableObjectWithImmutableObject.fromJson(data) as T;
    }
    if (t == _i83.ImmutableObjectWithList) {
      return _i83.ImmutableObjectWithList.fromJson(data) as T;
    }
    if (t == _i84.ImmutableObjectWithMap) {
      return _i84.ImmutableObjectWithMap.fromJson(data) as T;
    }
    if (t == _i85.ImmutableObjectWithMultipleFields) {
      return _i85.ImmutableObjectWithMultipleFields.fromJson(data) as T;
    }
    if (t == _i86.ImmutableObjectWithNoFields) {
      return _i86.ImmutableObjectWithNoFields.fromJson(data) as T;
    }
    if (t == _i87.ImmutableObjectWithRecord) {
      return _i87.ImmutableObjectWithRecord.fromJson(data) as T;
    }
    if (t == _i88.ImmutableObjectWithTable) {
      return _i88.ImmutableObjectWithTable.fromJson(data) as T;
    }
    if (t == _i89.ImmutableObjectWithTwentyFields) {
      return _i89.ImmutableObjectWithTwentyFields.fromJson(data) as T;
    }
    if (t == _i90.ChildClass) {
      return _i90.ChildClass.fromJson(data) as T;
    }
    if (t == _i91.ChildWithDefault) {
      return _i91.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i92.ChildClassWithoutId) {
      return _i92.ChildClassWithoutId.fromJson(data) as T;
    }
    if (t == _i93.ParentClass) {
      return _i93.ParentClass.fromJson(data) as T;
    }
    if (t == _i94.GrandparentClass) {
      return _i94.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i95.ParentClassWithoutId) {
      return _i95.ParentClassWithoutId.fromJson(data) as T;
    }
    if (t == _i96.GrandparentClassWithId) {
      return _i96.GrandparentClassWithId.fromJson(data) as T;
    }
    if (t == _i97.ChildEntity) {
      return _i97.ChildEntity.fromJson(data) as T;
    }
    if (t == _i98.BaseEntity) {
      return _i98.BaseEntity.fromJson(data) as T;
    }
    if (t == _i99.ParentEntity) {
      return _i99.ParentEntity.fromJson(data) as T;
    }
    if (t == _i100.NonServerOnlyParentClass) {
      return _i100.NonServerOnlyParentClass.fromJson(data) as T;
    }
    if (t == _i101.ParentWithDefault) {
      return _i101.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i102.PolymorphicGrandChild) {
      return _i102.PolymorphicGrandChild.fromJson(data) as T;
    }
    if (t == _i103.PolymorphicChild) {
      return _i103.PolymorphicChild.fromJson(data) as T;
    }
    if (t == _i104.PolymorphicChildContainer) {
      return _i104.PolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _i105.ModulePolymorphicChildContainer) {
      return _i105.ModulePolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _i106.SimilarButNotParent) {
      return _i106.SimilarButNotParent.fromJson(data) as T;
    }
    if (t == _i107.PolymorphicParent) {
      return _i107.PolymorphicParent.fromJson(data) as T;
    }
    if (t == _i108.UnrelatedToPolymorphism) {
      return _i108.UnrelatedToPolymorphism.fromJson(data) as T;
    }
    if (t == _i109.SealedGrandChild) {
      return _i109.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i109.SealedChild) {
      return _i109.SealedChild.fromJson(data) as T;
    }
    if (t == _i110.SealedChildOnlyRequired) {
      return _i110.SealedChildOnlyRequired.fromJson(data) as T;
    }
    if (t == _i109.SealedOtherChild) {
      return _i109.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i111.CityWithLongTableName) {
      return _i111.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i112.OrganizationWithLongTableName) {
      return _i112.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i113.PersonWithLongTableName) {
      return _i113.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i114.MaxFieldName) {
      return _i114.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i115.LongImplicitIdField) {
      return _i115.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i116.LongImplicitIdFieldCollection) {
      return _i116.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i117.RelationToMultipleMaxFieldName) {
      return _i117.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i118.UserNote) {
      return _i118.UserNote.fromJson(data) as T;
    }
    if (t == _i119.UserNoteCollection) {
      return _i119.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i120.UserNoteCollectionWithALongName) {
      return _i120.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i121.UserNoteWithALongName) {
      return _i121.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i122.MultipleMaxFieldName) {
      return _i122.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i123.City) {
      return _i123.City.fromJson(data) as T;
    }
    if (t == _i124.Organization) {
      return _i124.Organization.fromJson(data) as T;
    }
    if (t == _i125.Person) {
      return _i125.Person.fromJson(data) as T;
    }
    if (t == _i126.Course) {
      return _i126.Course.fromJson(data) as T;
    }
    if (t == _i127.Enrollment) {
      return _i127.Enrollment.fromJson(data) as T;
    }
    if (t == _i128.Student) {
      return _i128.Student.fromJson(data) as T;
    }
    if (t == _i129.ObjectUser) {
      return _i129.ObjectUser.fromJson(data) as T;
    }
    if (t == _i130.ParentUser) {
      return _i130.ParentUser.fromJson(data) as T;
    }
    if (t == _i131.Arena) {
      return _i131.Arena.fromJson(data) as T;
    }
    if (t == _i132.Player) {
      return _i132.Player.fromJson(data) as T;
    }
    if (t == _i133.Team) {
      return _i133.Team.fromJson(data) as T;
    }
    if (t == _i134.Comment) {
      return _i134.Comment.fromJson(data) as T;
    }
    if (t == _i135.Customer) {
      return _i135.Customer.fromJson(data) as T;
    }
    if (t == _i136.Book) {
      return _i136.Book.fromJson(data) as T;
    }
    if (t == _i137.Chapter) {
      return _i137.Chapter.fromJson(data) as T;
    }
    if (t == _i138.Order) {
      return _i138.Order.fromJson(data) as T;
    }
    if (t == _i139.Address) {
      return _i139.Address.fromJson(data) as T;
    }
    if (t == _i140.Citizen) {
      return _i140.Citizen.fromJson(data) as T;
    }
    if (t == _i141.Company) {
      return _i141.Company.fromJson(data) as T;
    }
    if (t == _i142.Town) {
      return _i142.Town.fromJson(data) as T;
    }
    if (t == _i143.Blocking) {
      return _i143.Blocking.fromJson(data) as T;
    }
    if (t == _i144.Member) {
      return _i144.Member.fromJson(data) as T;
    }
    if (t == _i145.Cat) {
      return _i145.Cat.fromJson(data) as T;
    }
    if (t == _i146.Post) {
      return _i146.Post.fromJson(data) as T;
    }
    if (t == _i147.ModuleDatatype) {
      return _i147.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i148.MyFeatureModel) {
      return _i148.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i149.MyTriggerType) {
      return _i149.MyTriggerType.fromJson(data) as T;
    }
    if (t == _i150.Nullability) {
      return _i150.Nullability.fromJson(data) as T;
    }
    if (t == _i151.ObjectFieldPersist) {
      return _i151.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i152.ObjectFieldScopes) {
      return _i152.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i153.ObjectWithBit) {
      return _i153.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i154.ObjectWithByteData) {
      return _i154.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i155.ObjectWithCustomClass) {
      return _i155.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i156.ObjectWithDecimal) {
      return _i156.ObjectWithDecimal.fromJson(data) as T;
    }
    if (t == _i157.ObjectWithDecimalPrecision) {
      return _i157.ObjectWithDecimalPrecision.fromJson(data) as T;
    }
    if (t == _i158.ObjectWithDuration) {
      return _i158.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i159.ObjectWithEnum) {
      return _i159.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i160.ObjectWithEnumEnhanced) {
      return _i160.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i161.ObjectWithHalfVector) {
      return _i161.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i162.ObjectWithIndex) {
      return _i162.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i163.ObjectWithMaps) {
      return _i163.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i164.ObjectWithNullableCustomClass) {
      return _i164.ObjectWithNullableCustomClass.fromJson(data) as T;
    }
    if (t == _i165.ObjectWithObject) {
      return _i165.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i166.ObjectWithParent) {
      return _i166.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i167.ObjectWithSealedClass) {
      return _i167.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i168.ObjectWithSelfParent) {
      return _i168.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i169.ObjectWithSparseVector) {
      return _i169.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i170.ObjectWithUuid) {
      return _i170.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i171.ObjectWithVector) {
      return _i171.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i172.Record) {
      return _i172.Record.fromJson(data) as T;
    }
    if (t == _i173.RelatedUniqueData) {
      return _i173.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i174.ExceptionWithRequiredField) {
      return _i174.ExceptionWithRequiredField.fromJson(data) as T;
    }
    if (t == _i175.ModelWithRequiredField) {
      return _i175.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i176.ScopeNoneFields) {
      return _i176.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i177.ScopeServerOnlyFieldChild) {
      return _i177.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i178.ScopeServerOnlyField) {
      return _i178.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i179.DefaultServerOnlyClass) {
      return _i179.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i180.DefaultServerOnlyEnum) {
      return _i180.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i181.NotServerOnlyClass) {
      return _i181.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i182.NotServerOnlyEnum) {
      return _i182.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i183.ServerOnlyClassField) {
      return _i183.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i184.ServerOnlyDefault) {
      return _i184.ServerOnlyDefault.fromJson(data) as T;
    }
    if (t == _i185.SessionAuthInfo) {
      return _i185.SessionAuthInfo.fromJson(data) as T;
    }
    if (t == _i186.SharedModelContainer) {
      return _i186.SharedModelContainer.fromJson(data) as T;
    }
    if (t == _i187.SharedModelSubclass) {
      return _i187.SharedModelSubclass.fromJson(data) as T;
    }
    if (t == _i188.SimpleData) {
      return _i188.SimpleData.fromJson(data) as T;
    }
    if (t == _i189.SimpleDataList) {
      return _i189.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i190.SimpleDataMap) {
      return _i190.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i191.SimpleDataObject) {
      return _i191.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i192.SimpleDateTime) {
      return _i192.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i193.ModelInSubfolder) {
      return _i193.ModelInSubfolder.fromJson(data) as T;
    }
    if (t == _i194.TestEnum) {
      return _i194.TestEnum.fromJson(data) as T;
    }
    if (t == _i195.TestEnumDefaultSerialization) {
      return _i195.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i196.TestEnumEnhanced) {
      return _i196.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i197.TestEnumEnhancedByName) {
      return _i197.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i198.TestEnumStringified) {
      return _i198.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i199.Types) {
      return _i199.Types.fromJson(data) as T;
    }
    if (t == _i200.TypesList) {
      return _i200.TypesList.fromJson(data) as T;
    }
    if (t == _i201.TypesMap) {
      return _i201.TypesMap.fromJson(data) as T;
    }
    if (t == _i202.TypesRecord) {
      return _i202.TypesRecord.fromJson(data) as T;
    }
    if (t == _i203.TypesSet) {
      return _i203.TypesSet.fromJson(data) as T;
    }
    if (t == _i204.TypesSetRequired) {
      return _i204.TypesSetRequired.fromJson(data) as T;
    }
    if (t == _i205.UniqueData) {
      return _i205.UniqueData.fromJson(data) as T;
    }
    if (t == _i206.UniqueDataWithNonPersist) {
      return _i206.UniqueDataWithNonPersist.fromJson(data) as T;
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
    if (t == _i1.getType<_i30.DecimalDefault?>()) {
      return (data != null ? _i30.DecimalDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.DecimalDefaultMix?>()) {
      return (data != null ? _i31.DecimalDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.DecimalDefaultModel?>()) {
      return (data != null ? _i32.DecimalDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.DecimalDefaultPersist?>()) {
      return (data != null ? _i33.DecimalDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.DoubleDefault?>()) {
      return (data != null ? _i34.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.DoubleDefaultMix?>()) {
      return (data != null ? _i35.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.DoubleDefaultModel?>()) {
      return (data != null ? _i36.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.DoubleDefaultPersist?>()) {
      return (data != null ? _i37.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.DurationDefault?>()) {
      return (data != null ? _i38.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.DurationDefaultMix?>()) {
      return (data != null ? _i39.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.DurationDefaultModel?>()) {
      return (data != null ? _i40.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.DurationDefaultPersist?>()) {
      return (data != null ? _i41.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.EnumDefault?>()) {
      return (data != null ? _i42.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.EnumDefaultMix?>()) {
      return (data != null ? _i43.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.EnumDefaultModel?>()) {
      return (data != null ? _i44.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.EnumDefaultPersist?>()) {
      return (data != null ? _i45.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.ByIndexEnum?>()) {
      return (data != null ? _i46.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ByNameEnum?>()) {
      return (data != null ? _i47.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.DefaultValueEnum?>()) {
      return (data != null ? _i48.DefaultValueEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.DefaultException?>()) {
      return (data != null ? _i49.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.IntDefault?>()) {
      return (data != null ? _i50.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.IntDefaultMix?>()) {
      return (data != null ? _i51.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.IntDefaultModel?>()) {
      return (data != null ? _i52.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.IntDefaultPersist?>()) {
      return (data != null ? _i53.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.StringDefault?>()) {
      return (data != null ? _i54.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.StringDefaultMix?>()) {
      return (data != null ? _i55.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.StringDefaultModel?>()) {
      return (data != null ? _i56.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.StringDefaultPersist?>()) {
      return (data != null ? _i57.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.UriDefault?>()) {
      return (data != null ? _i58.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.UriDefaultMix?>()) {
      return (data != null ? _i59.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.UriDefaultModel?>()) {
      return (data != null ? _i60.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.UriDefaultPersist?>()) {
      return (data != null ? _i61.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.UuidDefault?>()) {
      return (data != null ? _i62.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.UuidDefaultMix?>()) {
      return (data != null ? _i63.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.UuidDefaultModel?>()) {
      return (data != null ? _i64.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.UuidDefaultPersist?>()) {
      return (data != null ? _i65.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.EmptyModel?>()) {
      return (data != null ? _i66.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.EmptyModelRelationItem?>()) {
      return (data != null ? _i67.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.EmptyModelWithTable?>()) {
      return (data != null ? _i68.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.RelationEmptyModel?>()) {
      return (data != null ? _i69.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.ExceptionWithData?>()) {
      return (data != null ? _i70.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _i71.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i72.NonTableParentClass?>()) {
      return (data != null ? _i72.NonTableParentClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.ModifiedColumnName?>()) {
      return (data != null ? _i73.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i74.Department?>()) {
      return (data != null ? _i74.Department.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.Employee?>()) {
      return (data != null ? _i75.Employee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.Contractor?>()) {
      return (data != null ? _i76.Contractor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.Service?>()) {
      return (data != null ? _i77.Service.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _i78.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i79.ImmutableChildObject?>()) {
      return (data != null ? _i79.ImmutableChildObject.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.ImmutableChildObjectWithNoAdditionalFields?>()) {
      return (data != null
              ? _i80.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i81.ImmutableObject?>()) {
      return (data != null ? _i81.ImmutableObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i82.ImmutableObjectWithImmutableObject?>()) {
      return (data != null
              ? _i82.ImmutableObjectWithImmutableObject.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i83.ImmutableObjectWithList?>()) {
      return (data != null ? _i83.ImmutableObjectWithList.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.ImmutableObjectWithMap?>()) {
      return (data != null ? _i84.ImmutableObjectWithMap.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i85.ImmutableObjectWithMultipleFields?>()) {
      return (data != null
              ? _i85.ImmutableObjectWithMultipleFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i86.ImmutableObjectWithNoFields?>()) {
      return (data != null
              ? _i86.ImmutableObjectWithNoFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i87.ImmutableObjectWithRecord?>()) {
      return (data != null
              ? _i87.ImmutableObjectWithRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i88.ImmutableObjectWithTable?>()) {
      return (data != null
              ? _i88.ImmutableObjectWithTable.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i89.ImmutableObjectWithTwentyFields?>()) {
      return (data != null
              ? _i89.ImmutableObjectWithTwentyFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i90.ChildClass?>()) {
      return (data != null ? _i90.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.ChildWithDefault?>()) {
      return (data != null ? _i91.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.ChildClassWithoutId?>()) {
      return (data != null ? _i92.ChildClassWithoutId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i93.ParentClass?>()) {
      return (data != null ? _i93.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.GrandparentClass?>()) {
      return (data != null ? _i94.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.ParentClassWithoutId?>()) {
      return (data != null ? _i95.ParentClassWithoutId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.GrandparentClassWithId?>()) {
      return (data != null ? _i96.GrandparentClassWithId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.ChildEntity?>()) {
      return (data != null ? _i97.ChildEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.BaseEntity?>()) {
      return (data != null ? _i98.BaseEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.ParentEntity?>()) {
      return (data != null ? _i99.ParentEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.NonServerOnlyParentClass?>()) {
      return (data != null
              ? _i100.NonServerOnlyParentClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i101.ParentWithDefault?>()) {
      return (data != null ? _i101.ParentWithDefault.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i102.PolymorphicGrandChild?>()) {
      return (data != null ? _i102.PolymorphicGrandChild.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i103.PolymorphicChild?>()) {
      return (data != null ? _i103.PolymorphicChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.PolymorphicChildContainer?>()) {
      return (data != null
              ? _i104.PolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i105.ModulePolymorphicChildContainer?>()) {
      return (data != null
              ? _i105.ModulePolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i106.SimilarButNotParent?>()) {
      return (data != null ? _i106.SimilarButNotParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.PolymorphicParent?>()) {
      return (data != null ? _i107.PolymorphicParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i108.UnrelatedToPolymorphism?>()) {
      return (data != null
              ? _i108.UnrelatedToPolymorphism.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i109.SealedGrandChild?>()) {
      return (data != null ? _i109.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.SealedChild?>()) {
      return (data != null ? _i109.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.SealedChildOnlyRequired?>()) {
      return (data != null
              ? _i110.SealedChildOnlyRequired.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i109.SealedOtherChild?>()) {
      return (data != null ? _i109.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.CityWithLongTableName?>()) {
      return (data != null ? _i111.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i112.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i112.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i113.PersonWithLongTableName?>()) {
      return (data != null
              ? _i113.PersonWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i114.MaxFieldName?>()) {
      return (data != null ? _i114.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.LongImplicitIdField?>()) {
      return (data != null ? _i115.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i116.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i116.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i117.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i117.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i118.UserNote?>()) {
      return (data != null ? _i118.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i119.UserNoteCollection?>()) {
      return (data != null ? _i119.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i120.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i120.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i121.UserNoteWithALongName?>()) {
      return (data != null ? _i121.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i122.MultipleMaxFieldName?>()) {
      return (data != null ? _i122.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i123.City?>()) {
      return (data != null ? _i123.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.Organization?>()) {
      return (data != null ? _i124.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i125.Person?>()) {
      return (data != null ? _i125.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i126.Course?>()) {
      return (data != null ? _i126.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i127.Enrollment?>()) {
      return (data != null ? _i127.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i128.Student?>()) {
      return (data != null ? _i128.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.ObjectUser?>()) {
      return (data != null ? _i129.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i130.ParentUser?>()) {
      return (data != null ? _i130.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.Arena?>()) {
      return (data != null ? _i131.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i132.Player?>()) {
      return (data != null ? _i132.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i133.Team?>()) {
      return (data != null ? _i133.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i134.Comment?>()) {
      return (data != null ? _i134.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.Customer?>()) {
      return (data != null ? _i135.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i136.Book?>()) {
      return (data != null ? _i136.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i137.Chapter?>()) {
      return (data != null ? _i137.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i138.Order?>()) {
      return (data != null ? _i138.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i139.Address?>()) {
      return (data != null ? _i139.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i140.Citizen?>()) {
      return (data != null ? _i140.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i141.Company?>()) {
      return (data != null ? _i141.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i142.Town?>()) {
      return (data != null ? _i142.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i143.Blocking?>()) {
      return (data != null ? _i143.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i144.Member?>()) {
      return (data != null ? _i144.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i145.Cat?>()) {
      return (data != null ? _i145.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i146.Post?>()) {
      return (data != null ? _i146.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i147.ModuleDatatype?>()) {
      return (data != null ? _i147.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i148.MyFeatureModel?>()) {
      return (data != null ? _i148.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i149.MyTriggerType?>()) {
      return (data != null ? _i149.MyTriggerType.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i150.Nullability?>()) {
      return (data != null ? _i150.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i151.ObjectFieldPersist?>()) {
      return (data != null ? _i151.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i152.ObjectFieldScopes?>()) {
      return (data != null ? _i152.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i153.ObjectWithBit?>()) {
      return (data != null ? _i153.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i154.ObjectWithByteData?>()) {
      return (data != null ? _i154.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i155.ObjectWithCustomClass?>()) {
      return (data != null ? _i155.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i156.ObjectWithDecimal?>()) {
      return (data != null ? _i156.ObjectWithDecimal.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i157.ObjectWithDecimalPrecision?>()) {
      return (data != null
              ? _i157.ObjectWithDecimalPrecision.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i158.ObjectWithDuration?>()) {
      return (data != null ? _i158.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i159.ObjectWithEnum?>()) {
      return (data != null ? _i159.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i160.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i160.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i161.ObjectWithHalfVector?>()) {
      return (data != null ? _i161.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i162.ObjectWithIndex?>()) {
      return (data != null ? _i162.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i163.ObjectWithMaps?>()) {
      return (data != null ? _i163.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i164.ObjectWithNullableCustomClass?>()) {
      return (data != null
              ? _i164.ObjectWithNullableCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i165.ObjectWithObject?>()) {
      return (data != null ? _i165.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i166.ObjectWithParent?>()) {
      return (data != null ? _i166.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i167.ObjectWithSealedClass?>()) {
      return (data != null ? _i167.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i168.ObjectWithSelfParent?>()) {
      return (data != null ? _i168.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i169.ObjectWithSparseVector?>()) {
      return (data != null ? _i169.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i170.ObjectWithUuid?>()) {
      return (data != null ? _i170.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i171.ObjectWithVector?>()) {
      return (data != null ? _i171.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i172.Record?>()) {
      return (data != null ? _i172.Record.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i173.RelatedUniqueData?>()) {
      return (data != null ? _i173.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i174.ExceptionWithRequiredField?>()) {
      return (data != null
              ? _i174.ExceptionWithRequiredField.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i175.ModelWithRequiredField?>()) {
      return (data != null ? _i175.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i176.ScopeNoneFields?>()) {
      return (data != null ? _i176.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i177.ScopeServerOnlyFieldChild?>()) {
      return (data != null
              ? _i177.ScopeServerOnlyFieldChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i178.ScopeServerOnlyField?>()) {
      return (data != null ? _i178.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i179.DefaultServerOnlyClass?>()) {
      return (data != null ? _i179.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i180.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i180.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i181.NotServerOnlyClass?>()) {
      return (data != null ? _i181.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i182.NotServerOnlyEnum?>()) {
      return (data != null ? _i182.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i183.ServerOnlyClassField?>()) {
      return (data != null ? _i183.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i184.ServerOnlyDefault?>()) {
      return (data != null ? _i184.ServerOnlyDefault.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i185.SessionAuthInfo?>()) {
      return (data != null ? _i185.SessionAuthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i186.SharedModelContainer?>()) {
      return (data != null ? _i186.SharedModelContainer.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i187.SharedModelSubclass?>()) {
      return (data != null ? _i187.SharedModelSubclass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i188.SimpleData?>()) {
      return (data != null ? _i188.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i189.SimpleDataList?>()) {
      return (data != null ? _i189.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i190.SimpleDataMap?>()) {
      return (data != null ? _i190.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i191.SimpleDataObject?>()) {
      return (data != null ? _i191.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i192.SimpleDateTime?>()) {
      return (data != null ? _i192.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i193.ModelInSubfolder?>()) {
      return (data != null ? _i193.ModelInSubfolder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i194.TestEnum?>()) {
      return (data != null ? _i194.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i195.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i195.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i196.TestEnumEnhanced?>()) {
      return (data != null ? _i196.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i197.TestEnumEnhancedByName?>()) {
      return (data != null ? _i197.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i198.TestEnumStringified?>()) {
      return (data != null ? _i198.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i199.Types?>()) {
      return (data != null ? _i199.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i200.TypesList?>()) {
      return (data != null ? _i200.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i201.TypesMap?>()) {
      return (data != null ? _i201.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i202.TypesRecord?>()) {
      return (data != null ? _i202.TypesRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i203.TypesSet?>()) {
      return (data != null ? _i203.TypesSet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i204.TypesSetRequired?>()) {
      return (data != null ? _i204.TypesSetRequired.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i205.UniqueData?>()) {
      return (data != null ? _i205.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i206.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i206.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_i5.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i5.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i5.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i5.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8.PlayerUuid>) {
      return (data as List).map((e) => deserialize<_i8.PlayerUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i12.OrderUuid>) {
      return (data as List).map((e) => deserialize<_i12.OrderUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i12.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i12.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i10.CommentInt>) {
      return (data as List).map((e) => deserialize<_i10.CommentInt>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i10.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i10.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i17.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_i17.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i17.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.ChangedIdTypeSelf>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i67.EmptyModelRelationItem>) {
      return (data as List)
              .map((e) => deserialize<_i67.EmptyModelRelationItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i67.EmptyModelRelationItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i67.EmptyModelRelationItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i75.Employee>) {
      return (data as List).map((e) => deserialize<_i75.Employee>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i75.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i75.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _i1.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == List<_i97.ChildEntity>) {
      return (data as List)
              .map((e) => deserialize<_i97.ChildEntity>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i97.ChildEntity>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i97.ChildEntity>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i103.PolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_i103.PolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == List<_i103.PolymorphicChild?>) {
      return (data as List)
              .map((e) => deserialize<_i103.PolymorphicChild?>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i103.PolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i103.PolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i103.PolymorphicChild?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i103.PolymorphicChild?>(v),
            ),
          )
          as T;
    }
    if (t == List<_i207.ModulePolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_i207.ModulePolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i207.ModulePolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i207.ModulePolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == List<_i113.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i113.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i113.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i113.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i112.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i112.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i112.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<_i112.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i115.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i115.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i115.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i115.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i122.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i122.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i122.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i122.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i118.UserNote>) {
      return (data as List).map((e) => deserialize<_i118.UserNote>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i118.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i118.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i121.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i121.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i121.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i121.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i125.Person>) {
      return (data as List).map((e) => deserialize<_i125.Person>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i125.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i125.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i124.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i124.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i124.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i124.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i127.Enrollment>) {
      return (data as List)
              .map((e) => deserialize<_i127.Enrollment>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i127.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i127.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i132.Player>) {
      return (data as List).map((e) => deserialize<_i132.Player>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i132.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i132.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i138.Order>) {
      return (data as List).map((e) => deserialize<_i138.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i138.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i138.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i137.Chapter>) {
      return (data as List).map((e) => deserialize<_i137.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i137.Chapter>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i137.Chapter>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i134.Comment>) {
      return (data as List).map((e) => deserialize<_i134.Comment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i134.Comment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i134.Comment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i143.Blocking>) {
      return (data as List).map((e) => deserialize<_i143.Blocking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i143.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i143.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i145.Cat>) {
      return (data as List).map((e) => deserialize<_i145.Cat>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i145.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i145.Cat>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i207.ModuleClass>) {
      return (data as List)
              .map((e) => deserialize<_i207.ModuleClass>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i207.ModuleClass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i207.ModuleClass>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i207.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i207.ModuleClass>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i188.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i188.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i188.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i188.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i188.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i188.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i188.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i188.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == _i1.getType<List<DateTime>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
              : null)
          as T;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<DateTime?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i208.ByteData>) {
      return (data as List).map((e) => deserialize<_i208.ByteData>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i208.ByteData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i208.ByteData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i208.ByteData?>) {
      return (data as List).map((e) => deserialize<_i208.ByteData?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i208.ByteData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i208.ByteData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList() as T;
    }
    if (t == _i1.getType<List<Duration>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<Duration?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i1.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i1.UuidValue>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i1.UuidValue?>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i1.UuidValue?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i1.UuidValue?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<int>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<int?>(v)),
                )
              : null)
          as T;
    }
    if (t == _i209.CustomClassWithoutProtocolSerialization) {
      return _i209.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i209.CustomClassWithProtocolSerialization) {
      return _i209.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i209.CustomClassWithProtocolSerializationMethod) {
      return _i209.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i194.TestEnum>) {
      return (data as List).map((e) => deserialize<_i194.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i194.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i194.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i194.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i194.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i196.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i196.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i197.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i197.TestEnumEnhancedByName>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i188.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i188.SimpleData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<DateTime>(v)),
          )
          as T;
    }
    if (t == Map<String, _i208.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i208.ByteData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<Duration>(v)),
          )
          as T;
    }
    if (t == Map<String, _i1.UuidValue>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_i1.UuidValue>(v)),
          )
          as T;
    }
    if (t == Map<String, _i188.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i188.SimpleData?>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)),
          )
          as T;
    }
    if (t == Map<String, _i208.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i208.ByteData?>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<Duration?>(v)),
          )
          as T;
    }
    if (t == Map<String, _i1.UuidValue?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i1.UuidValue?>(v),
            ),
          )
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _i209.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _i209.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _i209.CustomClassWithProtocolSerializationMethod.fromJson(data)
              : null)
          as T;
    }
    if (t == List<List<_i188.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i188.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i188.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i188.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i188.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i188.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i188.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i188.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i188.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i188.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i188.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i188.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i188.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i188.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i188.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i188.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i188.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i188.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i188.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i188.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i188.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i188.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i109.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i109.SealedParent>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<_i209.SharedModel>) {
      return (data as List)
              .map((e) => deserialize<_i209.SharedModel>(e))
              .toList()
          as T;
    }
    if (t == List<_i209.SharedModel?>) {
      return (data as List)
              .map((e) => deserialize<_i209.SharedModel?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i209.SharedModel>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i209.SharedModel>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _i209.SharedModel>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i209.SharedModel>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i209.SharedModel>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i209.SharedModel>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, _i209.SharedSubclass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i209.SharedSubclass>(v),
            ),
          )
          as T;
    }
    if (t == Set<_i209.SharedModel>) {
      return (data as List)
              .map((e) => deserialize<_i209.SharedModel>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i209.SharedModel>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i209.SharedModel>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == List<_i198.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i198.TestEnumStringified>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i198.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i198.TestEnumStringified>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i198.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == List<(_i198.TestEnumStringified,)>) {
      return (data as List)
              .map((e) => deserialize<(_i198.TestEnumStringified,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)>()) {
      return (
            deserialize<_i198.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<(_i198.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i198.TestEnumStringified,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)>()) {
      return (
            deserialize<_i198.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i150.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i150.Nullability>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i198.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == List<({_i198.TestEnumStringified value})>) {
      return (data as List)
              .map((e) => deserialize<({_i198.TestEnumStringified value})>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i198.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<({_i198.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i198.TestEnumStringified value})>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i198.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i207.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i207.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i150.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i150.Nullability>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<Map<int, int>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<int>(e['k']),
                      deserialize<int>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(String, {Uri? optionalUri})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                      ? null
                      : deserialize<Uri>(data['n']['optionalUri']),
                )
                as T;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList() as T;
    }
    if (t == _i1.getType<List<bool>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<bool>(e)).toList()
              : null)
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == _i1.getType<List<double>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<double>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Uri>) {
      return (data as List).map((e) => deserialize<Uri>(e)).toList() as T;
    }
    if (t == _i1.getType<List<Uri>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Uri>(e)).toList()
              : null)
          as T;
    }
    if (t == List<BigInt>) {
      return (data as List).map((e) => deserialize<BigInt>(e)).toList() as T;
    }
    if (t == _i1.getType<List<BigInt>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<BigInt>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<List<_i194.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i194.TestEnum>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i199.Types>) {
      return (data as List).map((e) => deserialize<_i199.Types>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i199.Types>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i199.Types>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Map<String, _i199.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _i199.Types>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i199.Types>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_i199.Types>(v)),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<String, _i199.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _i199.Types>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i199.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_i199.Types>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i199.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i199.Types>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toList() as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<(int,)?>) {
      return (data as List).map((e) => deserialize<(int,)?>(e)).toList() as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<(_i194.TestEnum,)>) {
      return (data as List)
              .map((e) => deserialize<(_i194.TestEnum,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)>()) {
      return (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<List<(_i194.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i194.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)>()) {
      return (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == Map<int, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<int, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<int>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<bool, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<bool>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<bool, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<bool>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<double, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<double>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<double, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<double>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<DateTime, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<DateTime>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<DateTime, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<DateTime>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<_i208.ByteData, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i208.ByteData>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i208.ByteData, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i208.ByteData>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<Duration, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<Duration>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<Duration, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<Duration>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i1.UuidValue, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i1.UuidValue>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i1.UuidValue, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i1.UuidValue>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<Uri, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<Uri>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<Uri, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<Uri>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<BigInt, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<BigInt>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<BigInt, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<BigInt>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i194.TestEnum, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i194.TestEnum>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i194.TestEnum, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i194.TestEnum>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i198.TestEnumStringified, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i198.TestEnumStringified>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i198.TestEnumStringified, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i198.TestEnumStringified>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i199.Types, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i199.Types>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i199.Types, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i199.Types>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<Map<_i199.Types, String>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<Map<_i199.Types, String>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<Map<_i199.Types, String>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<Map<_i199.Types, String>>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<List<_i199.Types>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<List<_i199.Types>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<List<_i199.Types>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<List<_i199.Types>>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<(String,), String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(String,)>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<(String,), String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<(String,)>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, bool>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<bool>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, double>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<double>(v)),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, DateTime>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<DateTime>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i208.ByteData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i208.ByteData>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, Duration>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Duration>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i1.UuidValue>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i1.UuidValue>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, Uri>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<Uri>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Uri>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<Uri>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, BigInt>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<BigInt>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, BigInt>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<BigInt>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, _i194.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i194.TestEnum>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i194.TestEnum>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i194.TestEnum>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, _i198.TestEnumStringified>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i198.TestEnumStringified>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i198.TestEnumStringified>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i198.TestEnumStringified>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i199.Types>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i199.Types>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, Map<String, _i199.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<String, _i199.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<String, _i199.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<String, _i199.Types>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, List<_i199.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<_i199.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, List<_i199.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<_i199.Types>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, (String,)>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<(String,)>(v)),
          )
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<(String,)>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Map<String, (String,)?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<(String,)?>(v)),
          )
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<(String,)?>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Map<(String,)?, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(String,)?>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<(String,)?, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<(String,)?>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(double,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<double>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(DateTime,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<DateTime>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i208.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i208.ByteData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(Duration,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Duration>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i1.UuidValue,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i1.UuidValue>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Uri,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Uri>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(BigInt,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<BigInt>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(List<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<List<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Map<int, int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Set<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Set<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i188.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i188.SimpleData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i188.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i188.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<(_i188.SimpleData, {_i188.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i188.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i188.SimpleData>(
                    data['n']['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedNestedRecord: deserialize<(int, String)>(
                    data['n']['namedNestedRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              (
                (List<(_i188.SimpleData,)>,), {
                (_i188.SimpleData, Map<String, _i188.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i188.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (_i188.SimpleData, Map<String, _i188.SimpleData>)
                      >(data['n']['namedNestedRecord']),
                )
                as T;
    }
    if (t == Set<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<bool>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<bool>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<double>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<double>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<DateTime>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_i208.ByteData>) {
      return (data as List).map((e) => deserialize<_i208.ByteData>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i208.ByteData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i208.ByteData>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<Duration>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_i1.UuidValue>) {
      return (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i1.UuidValue>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i1.UuidValue>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<BigInt>) {
      return (data as List).map((e) => deserialize<BigInt>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<BigInt>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<BigInt>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_i194.TestEnum>) {
      return (data as List).map((e) => deserialize<_i194.TestEnum>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i194.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i194.TestEnum>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_i198.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i198.TestEnumStringified>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i198.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i198.TestEnumStringified>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_i199.Types>) {
      return (data as List).map((e) => deserialize<_i199.Types>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i199.Types>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i199.Types>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<Map<String, _i199.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _i199.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<Map<String, _i199.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _i199.Types>>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<List<_i199.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_i199.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<List<_i199.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i199.Types>>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toSet() as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<(int,)?>) {
      return (data as List).map((e) => deserialize<(int,)?>(e)).toSet() as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i210.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i210.SimpleData>(e))
              .toList()
          as T;
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
              : null)
          as T;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<List<List<int>>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _i1.getType<List<int?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int?>(e)).toList()
              : null)
          as T;
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
    if (t == List<_i208.ByteData>) {
      return (data as List).map((e) => deserialize<_i208.ByteData>(e)).toList()
          as T;
    }
    if (t == List<_i208.ByteData?>) {
      return (data as List).map((e) => deserialize<_i208.ByteData?>(e)).toList()
          as T;
    }
    if (t == List<_i210.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i210.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i210.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i210.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<List<_i210.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i210.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList() as T;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList() as T;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<int>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, Map<String, int>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<String, int>>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<int?>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<int, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) =>
                  MapEntry(deserialize<int>(e['k']), deserialize<int>(e['v'])),
            ),
          )
          as T;
    }
    if (t == Map<String, Map<int, int>>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<Map<int, int>>(v)),
          )
          as T;
    }
    if (t == Map<_i211.TestEnum, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i211.TestEnum>(e['k']),
                deserialize<int>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == Map<String, _i211.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i211.TestEnum>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, double>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double>(v)),
          )
          as T;
    }
    if (t == Map<String, double?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<double?>(v)),
          )
          as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == Map<String, bool?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool?>(v)),
          )
          as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String?>(v)),
          )
          as T;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<DateTime>(v)),
          )
          as T;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<DateTime?>(v)),
          )
          as T;
    }
    if (t == Map<String, _i208.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i208.ByteData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i208.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i208.ByteData?>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i210.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i210.SimpleData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i210.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i210.SimpleData?>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i210.SimpleData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i210.SimpleData>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i210.SimpleData?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i210.SimpleData?>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, Duration>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<Duration>(v)),
          )
          as T;
    }
    if (t == Map<String, Duration?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<Duration?>(v)),
          )
          as T;
    }
    if (t == Map<(Map<int, String>, String), String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(Map<int, String>, String)>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(Map<int, String>, String)>()) {
      return (
            deserialize<Map<int, String>>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(Map<int, String>, String)>()) {
      return (
            deserialize<Map<int, String>>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<int, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == Map<String, (Map<int, int>,)>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(Map<int, int>,)>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(Map<int, int>,)>()) {
      return (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(Map<int, int>,)>()) {
      return (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == Map<DateTime, bool>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<DateTime>(e['k']),
                deserialize<bool>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<DateTime, bool>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<DateTime>(e['k']),
                      deserialize<bool>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<int, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<int>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i212.UserInfo>) {
      return (data as List).map((e) => deserialize<_i212.UserInfo>(e)).toList()
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == Set<_i210.SimpleData>) {
      return (data as List).map((e) => deserialize<_i210.SimpleData>(e)).toSet()
          as T;
    }
    if (t == List<Set<_i210.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Set<_i210.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(int, BigInt)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<BigInt>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(String, _i213.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_i213.PolymorphicParent>(data['p'][1]),
          )
          as T;
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
          )
          as T;
    }
    if (t == _i1.getType<(int?,)?>()) {
      return (data == null)
          ? null as T
          : (
                  ((data as Map)['p'] as List)[0] == null
                      ? null
                      : deserialize<int>(data['p'][0]),
                )
                as T;
    }
    if (t == _i1.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, String)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<String>(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i210.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(Map<String, int>,)>()) {
      return (deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(Set<(int,)>,)>()) {
      return (deserialize<Set<(int,)>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toSet() as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<({int number, String text})>()) {
      return (
            number: deserialize<int>(((data as Map)['n'] as Map)['number']),
            text: deserialize<String>(data['n']['text']),
          )
          as T;
    }
    if (t == _i1.getType<({int number, String text})?>()) {
      return (data == null)
          ? null as T
          : (
                  number: deserialize<int>(
                    ((data as Map)['n'] as Map)['number'],
                  ),
                  text: deserialize<String>(data['n']['text']),
                )
                as T;
    }
    if (t == _i1.getType<({_i210.SimpleData data, int number})>()) {
      return (
            data: deserialize<_i210.SimpleData>(
              ((data as Map)['n'] as Map)['data'],
            ),
            number: deserialize<int>(data['n']['number']),
          )
          as T;
    }
    if (t == _i1.getType<({_i210.SimpleData data, int number})?>()) {
      return (data == null)
          ? null as T
          : (
                  data: deserialize<_i210.SimpleData>(
                    ((data as Map)['n'] as Map)['data'],
                  ),
                  number: deserialize<int>(data['n']['number']),
                )
                as T;
    }
    if (t == _i1.getType<({_i210.SimpleData? data, int? number})>()) {
      return (
            data: ((data as Map)['n'] as Map)['data'] == null
                ? null
                : deserialize<_i210.SimpleData>(data['n']['data']),
            number: ((data)['n'] as Map)['number'] == null
                ? null
                : deserialize<int>(data['n']['number']),
          )
          as T;
    }
    if (t == _i1.getType<({Map<int, int> intIntMap})>()) {
      return (
            intIntMap: deserialize<Map<int, int>>(
              ((data as Map)['n'] as Map)['intIntMap'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({Set<(bool,)> boolSet})>()) {
      return (
            boolSet: deserialize<Set<(bool,)>>(
              ((data as Map)['n'] as Map)['boolSet'],
            ),
          )
          as T;
    }
    if (t == Set<(bool,)>) {
      return (data as List).map((e) => deserialize<(bool,)>(e)).toSet() as T;
    }
    if (t == _i1.getType<(bool,)>()) {
      return (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(bool,)>()) {
      return (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Map<(Map<int, String>, String), String>,)>()) {
      return (
            deserialize<Map<(Map<int, String>, String), String>>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(int, {_i210.SimpleData data})>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            data: deserialize<_i210.SimpleData>(data['n']['data']),
          )
          as T;
    }
    if (t == _i1.getType<(int, {_i210.SimpleData data})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  data: deserialize<_i210.SimpleData>(data['n']['data']),
                )
                as T;
    }
    if (t == List<(int, _i210.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i210.SimpleData)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == List<(int, _i210.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i210.SimpleData)?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i210.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Set<(int, _i210.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i210.SimpleData)>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Set<(int, _i210.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i210.SimpleData)?>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i210.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<Set<(int, _i210.SimpleData)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(int, _i210.SimpleData)>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i210.SimpleData)>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i210.SimpleData)>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i210.SimpleData)?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i210.SimpleData)?>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i210.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Map<(String, int), (int, _i210.SimpleData)>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(String, int)>(e['k']),
                deserialize<(int, _i210.SimpleData)>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i210.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i210.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, List<Set<(int,)>>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<Set<(int,)>>>(v),
            ),
          )
          as T;
    }
    if (t == List<Set<(int,)>>) {
      return (data as List).map((e) => deserialize<Set<(int,)>>(e)).toList()
          as T;
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
              .toSet()
          as T;
    }
    if (t == List<Map<String, (int,)>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, (int,)>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, (int,)>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<(int,)>(v)),
          )
          as T;
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
    if (t == _i1.getType<({(_i210.SimpleData, double) namedSubRecord})>()) {
      return (
            namedSubRecord: deserialize<(_i210.SimpleData, double)>(
              ((data as Map)['n'] as Map)['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i210.SimpleData, double)>()) {
      return (
            deserialize<_i210.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<double>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<({(_i210.SimpleData, double)? namedSubRecord})>()) {
      return (
            namedSubRecord:
                ((data as Map)['n'] as Map)['namedSubRecord'] == null
                ? null
                : deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
          )
          as T;
    }
    if (t == _i1.getType<(_i210.SimpleData, double)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i210.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  deserialize<double>(data['p'][1]),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i210.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<((int, String), {(_i210.SimpleData, double) namedSubRecord})>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i210.SimpleData, double) namedSubRecord,
                      })
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i210.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<((int, String), {(_i210.SimpleData, double) namedSubRecord})?>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i210.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              List<
                ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i210.SimpleData, double) namedSubRecord,
                            })?
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(int?, _i207.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i207.ProjectStreamingClass>(data['p'][1]),
          )
          as T;
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
              : null)
          as T;
    }
    if (t == Set<Set<int>?>) {
      return (data as List).map((e) => deserialize<Set<int>?>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<Set<Set<int>>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Set<int>>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toSet() as T;
    }
    if (t == _i1.getType<Set<int?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int?>(e)).toSet()
              : null)
          as T;
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
    if (t == Set<_i208.ByteData>) {
      return (data as List).map((e) => deserialize<_i208.ByteData>(e)).toSet()
          as T;
    }
    if (t == Set<_i208.ByteData?>) {
      return (data as List).map((e) => deserialize<_i208.ByteData?>(e)).toSet()
          as T;
    }
    if (t == Set<_i210.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i210.SimpleData?>(e))
              .toSet()
          as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == Set<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toSet() as T;
    }
    if (t == List<_i214.Types>) {
      return (data as List).map((e) => deserialize<_i214.Types>(e)).toList()
          as T;
    }
    if (t == _i1.getType<(String, (int, bool))>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<(int, bool)>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, bool)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<bool>(data['p'][1]),
          )
          as T;
    }
    if (t == List<(String, (int, bool))>) {
      return (data as List)
              .map((e) => deserialize<(String, (int, bool))>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(String, (int, bool))>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<(int, bool)>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (
                String,
                (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i210.SimpleData simpleData})
            >(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (Map<String, int>, {bool flag, _i210.SimpleData simpleData})
            >()) {
      return (
            deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
            flag: deserialize<bool>(data['n']['flag']),
            simpleData: deserialize<_i210.SimpleData>(data['n']['simpleData']),
          )
          as T;
    }
    if (t == List<(String, int)>) {
      return (data as List).map((e) => deserialize<(String, int)>(e)).toList()
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (
                String,
                (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (Map<String, int>, {bool flag, _i210.SimpleData simpleData})
                  >(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<List<(String, int)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(String, int)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(_i207.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i207.ModuleClass>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i198.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)>()) {
      return (
            deserialize<_i198.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<(_i198.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i198.TestEnumStringified,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)>()) {
      return (
            deserialize<_i198.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i198.TestEnumStringified,)>()) {
      return (
            deserialize<_i198.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i150.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i150.Nullability>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i198.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i198.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<({_i198.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i198.TestEnumStringified value})>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i198.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i198.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i198.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i207.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i207.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i150.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i150.Nullability>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(String, {Uri? optionalUri})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                      ? null
                      : deserialize<Uri>(data['n']['optionalUri']),
                )
                as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)>()) {
      return (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<List<(_i194.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i194.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)>()) {
      return (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)>()) {
      return (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<(String,), String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<(String,)>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<(String,)>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<(String,)?>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<(String,)?, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<(String,)?>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(double,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<double>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(DateTime,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<DateTime>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i208.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i208.ByteData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(Duration,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Duration>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i1.UuidValue,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i1.UuidValue>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Uri,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Uri>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(BigInt,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<BigInt>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i194.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i194.TestEnum>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(List<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<List<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Map<int, int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(Set<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Set<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i188.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i188.SimpleData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i188.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i188.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<(_i188.SimpleData, {_i188.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i188.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i188.SimpleData>(
                    data['n']['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedNestedRecord: deserialize<(int, String)>(
                    data['n']['namedNestedRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              (
                (List<(_i188.SimpleData,)>,), {
                (_i188.SimpleData, Map<String, _i188.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i188.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (_i188.SimpleData, Map<String, _i188.SimpleData>)
                      >(data['n']['namedNestedRecord']),
                )
                as T;
    }
    if (t == _i1.getType<(List<(_i188.SimpleData,)>,)>()) {
      return (
            deserialize<List<(_i188.SimpleData,)>>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == List<(_i188.SimpleData,)>) {
      return (data as List)
              .map((e) => deserialize<(_i188.SimpleData,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i188.SimpleData,)>()) {
      return (deserialize<_i188.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i188.SimpleData,)>()) {
      return (deserialize<_i188.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i188.SimpleData, Map<String, _i188.SimpleData>)>()) {
      return (
            deserialize<_i188.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<Map<String, _i188.SimpleData>>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i209.CustomClass) {
      return _i209.CustomClass.fromJson(data) as T;
    }
    if (t == _i209.CustomClass2) {
      return _i209.CustomClass2.fromJson(data) as T;
    }
    if (t == _i209.ProtocolCustomClass) {
      return _i209.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i209.ExternalCustomClass) {
      return _i209.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i209.FreezedCustomClass) {
      return _i209.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i209.CustomClass?>()) {
      return (data != null ? _i209.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i209.CustomClass2?>()) {
      return (data != null ? _i209.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _i209.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _i209.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i209.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _i209.CustomClassWithProtocolSerializationMethod.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i209.ProtocolCustomClass?>()) {
      return (data != null ? _i209.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i209.ExternalCustomClass?>()) {
      return (data != null ? _i209.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i209.FreezedCustomClass?>()) {
      return (data != null ? _i209.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i210.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i210.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(String, _i213.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_i213.PolymorphicParent>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int?,)?>()) {
      return (data == null)
          ? null as T
          : (
                  ((data as Map)['p'] as List)[0] == null
                      ? null
                      : deserialize<int>(data['p'][0]),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              List<
                ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i210.SimpleData, double) namedSubRecord,
                            })?
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i210.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(int?, _i207.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i207.ProjectStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (
                String,
                (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i210.SimpleData simpleData})
            >(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (
                String,
                (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (Map<String, int>, {bool flag, _i210.SimpleData simpleData})
                  >(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<List<(String, int)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(String, int)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    try {
      return _i212.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i207.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i209.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i209.CustomClass => 'CustomClass',
      _i209.CustomClass2 => 'CustomClass2',
      _i209.CustomClassWithoutProtocolSerialization =>
        'CustomClassWithoutProtocolSerialization',
      _i209.CustomClassWithProtocolSerialization =>
        'CustomClassWithProtocolSerialization',
      _i209.CustomClassWithProtocolSerializationMethod =>
        'CustomClassWithProtocolSerializationMethod',
      _i209.ProtocolCustomClass => 'ProtocolCustomClass',
      _i209.ExternalCustomClass => 'ExternalCustomClass',
      _i209.FreezedCustomClass => 'FreezedCustomClass',
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
      _i30.DecimalDefault => 'DecimalDefault',
      _i31.DecimalDefaultMix => 'DecimalDefaultMix',
      _i32.DecimalDefaultModel => 'DecimalDefaultModel',
      _i33.DecimalDefaultPersist => 'DecimalDefaultPersist',
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
      _i79.ImmutableChildObject => 'ImmutableChildObject',
      _i80.ImmutableChildObjectWithNoAdditionalFields =>
        'ImmutableChildObjectWithNoAdditionalFields',
      _i81.ImmutableObject => 'ImmutableObject',
      _i82.ImmutableObjectWithImmutableObject =>
        'ImmutableObjectWithImmutableObject',
      _i83.ImmutableObjectWithList => 'ImmutableObjectWithList',
      _i84.ImmutableObjectWithMap => 'ImmutableObjectWithMap',
      _i85.ImmutableObjectWithMultipleFields =>
        'ImmutableObjectWithMultipleFields',
      _i86.ImmutableObjectWithNoFields => 'ImmutableObjectWithNoFields',
      _i87.ImmutableObjectWithRecord => 'ImmutableObjectWithRecord',
      _i88.ImmutableObjectWithTable => 'ImmutableObjectWithTable',
      _i89.ImmutableObjectWithTwentyFields => 'ImmutableObjectWithTwentyFields',
      _i90.ChildClass => 'ChildClass',
      _i91.ChildWithDefault => 'ChildWithDefault',
      _i92.ChildClassWithoutId => 'ChildClassWithoutId',
      _i93.ParentClass => 'ParentClass',
      _i94.GrandparentClass => 'GrandparentClass',
      _i95.ParentClassWithoutId => 'ParentClassWithoutId',
      _i96.GrandparentClassWithId => 'GrandparentClassWithId',
      _i97.ChildEntity => 'ChildEntity',
      _i98.BaseEntity => 'BaseEntity',
      _i99.ParentEntity => 'ParentEntity',
      _i100.NonServerOnlyParentClass => 'NonServerOnlyParentClass',
      _i101.ParentWithDefault => 'ParentWithDefault',
      _i102.PolymorphicGrandChild => 'PolymorphicGrandChild',
      _i103.PolymorphicChild => 'PolymorphicChild',
      _i104.PolymorphicChildContainer => 'PolymorphicChildContainer',
      _i105.ModulePolymorphicChildContainer =>
        'ModulePolymorphicChildContainer',
      _i106.SimilarButNotParent => 'SimilarButNotParent',
      _i107.PolymorphicParent => 'PolymorphicParent',
      _i108.UnrelatedToPolymorphism => 'UnrelatedToPolymorphism',
      _i109.SealedGrandChild => 'SealedGrandChild',
      _i109.SealedChild => 'SealedChild',
      _i110.SealedChildOnlyRequired => 'SealedChildOnlyRequired',
      _i109.SealedOtherChild => 'SealedOtherChild',
      _i111.CityWithLongTableName => 'CityWithLongTableName',
      _i112.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i113.PersonWithLongTableName => 'PersonWithLongTableName',
      _i114.MaxFieldName => 'MaxFieldName',
      _i115.LongImplicitIdField => 'LongImplicitIdField',
      _i116.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i117.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i118.UserNote => 'UserNote',
      _i119.UserNoteCollection => 'UserNoteCollection',
      _i120.UserNoteCollectionWithALongName =>
        'UserNoteCollectionWithALongName',
      _i121.UserNoteWithALongName => 'UserNoteWithALongName',
      _i122.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i123.City => 'City',
      _i124.Organization => 'Organization',
      _i125.Person => 'Person',
      _i126.Course => 'Course',
      _i127.Enrollment => 'Enrollment',
      _i128.Student => 'Student',
      _i129.ObjectUser => 'ObjectUser',
      _i130.ParentUser => 'ParentUser',
      _i131.Arena => 'Arena',
      _i132.Player => 'Player',
      _i133.Team => 'Team',
      _i134.Comment => 'Comment',
      _i135.Customer => 'Customer',
      _i136.Book => 'Book',
      _i137.Chapter => 'Chapter',
      _i138.Order => 'Order',
      _i139.Address => 'Address',
      _i140.Citizen => 'Citizen',
      _i141.Company => 'Company',
      _i142.Town => 'Town',
      _i143.Blocking => 'Blocking',
      _i144.Member => 'Member',
      _i145.Cat => 'Cat',
      _i146.Post => 'Post',
      _i147.ModuleDatatype => 'ModuleDatatype',
      _i148.MyFeatureModel => 'MyFeatureModel',
      _i149.MyTriggerType => 'MyTriggerType',
      _i150.Nullability => 'Nullability',
      _i151.ObjectFieldPersist => 'ObjectFieldPersist',
      _i152.ObjectFieldScopes => 'ObjectFieldScopes',
      _i153.ObjectWithBit => 'ObjectWithBit',
      _i154.ObjectWithByteData => 'ObjectWithByteData',
      _i155.ObjectWithCustomClass => 'ObjectWithCustomClass',
      _i156.ObjectWithDecimal => 'ObjectWithDecimal',
      _i157.ObjectWithDecimalPrecision => 'ObjectWithDecimalPrecision',
      _i158.ObjectWithDuration => 'ObjectWithDuration',
      _i159.ObjectWithEnum => 'ObjectWithEnum',
      _i160.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i161.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i162.ObjectWithIndex => 'ObjectWithIndex',
      _i163.ObjectWithMaps => 'ObjectWithMaps',
      _i164.ObjectWithNullableCustomClass => 'ObjectWithNullableCustomClass',
      _i165.ObjectWithObject => 'ObjectWithObject',
      _i166.ObjectWithParent => 'ObjectWithParent',
      _i167.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i168.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i169.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i170.ObjectWithUuid => 'ObjectWithUuid',
      _i171.ObjectWithVector => 'ObjectWithVector',
      _i172.Record => 'Record',
      _i173.RelatedUniqueData => 'RelatedUniqueData',
      _i174.ExceptionWithRequiredField => 'ExceptionWithRequiredField',
      _i175.ModelWithRequiredField => 'ModelWithRequiredField',
      _i176.ScopeNoneFields => 'ScopeNoneFields',
      _i177.ScopeServerOnlyFieldChild => 'ScopeServerOnlyFieldChild',
      _i178.ScopeServerOnlyField => 'ScopeServerOnlyField',
      _i179.DefaultServerOnlyClass => 'DefaultServerOnlyClass',
      _i180.DefaultServerOnlyEnum => 'DefaultServerOnlyEnum',
      _i181.NotServerOnlyClass => 'NotServerOnlyClass',
      _i182.NotServerOnlyEnum => 'NotServerOnlyEnum',
      _i183.ServerOnlyClassField => 'ServerOnlyClassField',
      _i184.ServerOnlyDefault => 'ServerOnlyDefault',
      _i185.SessionAuthInfo => 'SessionAuthInfo',
      _i186.SharedModelContainer => 'SharedModelContainer',
      _i187.SharedModelSubclass => 'SharedModelSubclass',
      _i188.SimpleData => 'SimpleData',
      _i189.SimpleDataList => 'SimpleDataList',
      _i190.SimpleDataMap => 'SimpleDataMap',
      _i191.SimpleDataObject => 'SimpleDataObject',
      _i192.SimpleDateTime => 'SimpleDateTime',
      _i193.ModelInSubfolder => 'ModelInSubfolder',
      _i194.TestEnum => 'TestEnum',
      _i195.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i196.TestEnumEnhanced => 'TestEnumEnhanced',
      _i197.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i198.TestEnumStringified => 'TestEnumStringified',
      _i199.Types => 'Types',
      _i200.TypesList => 'TypesList',
      _i201.TypesMap => 'TypesMap',
      _i202.TypesRecord => 'TypesRecord',
      _i203.TypesSet => 'TypesSet',
      _i204.TypesSetRequired => 'TypesSetRequired',
      _i205.UniqueData => 'UniqueData',
      _i206.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
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
      case _i209.CustomClass():
        return 'CustomClass';
      case _i209.CustomClass2():
        return 'CustomClass2';
      case _i209.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _i209.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _i209.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _i209.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _i209.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _i209.FreezedCustomClass():
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
      case _i30.DecimalDefault():
        return 'DecimalDefault';
      case _i31.DecimalDefaultMix():
        return 'DecimalDefaultMix';
      case _i32.DecimalDefaultModel():
        return 'DecimalDefaultModel';
      case _i33.DecimalDefaultPersist():
        return 'DecimalDefaultPersist';
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
      case _i79.ImmutableChildObject():
        return 'ImmutableChildObject';
      case _i80.ImmutableChildObjectWithNoAdditionalFields():
        return 'ImmutableChildObjectWithNoAdditionalFields';
      case _i81.ImmutableObject():
        return 'ImmutableObject';
      case _i82.ImmutableObjectWithImmutableObject():
        return 'ImmutableObjectWithImmutableObject';
      case _i83.ImmutableObjectWithList():
        return 'ImmutableObjectWithList';
      case _i84.ImmutableObjectWithMap():
        return 'ImmutableObjectWithMap';
      case _i85.ImmutableObjectWithMultipleFields():
        return 'ImmutableObjectWithMultipleFields';
      case _i86.ImmutableObjectWithNoFields():
        return 'ImmutableObjectWithNoFields';
      case _i87.ImmutableObjectWithRecord():
        return 'ImmutableObjectWithRecord';
      case _i88.ImmutableObjectWithTable():
        return 'ImmutableObjectWithTable';
      case _i89.ImmutableObjectWithTwentyFields():
        return 'ImmutableObjectWithTwentyFields';
      case _i90.ChildClass():
        return 'ChildClass';
      case _i91.ChildWithDefault():
        return 'ChildWithDefault';
      case _i92.ChildClassWithoutId():
        return 'ChildClassWithoutId';
      case _i93.ParentClass():
        return 'ParentClass';
      case _i94.GrandparentClass():
        return 'GrandparentClass';
      case _i95.ParentClassWithoutId():
        return 'ParentClassWithoutId';
      case _i96.GrandparentClassWithId():
        return 'GrandparentClassWithId';
      case _i97.ChildEntity():
        return 'ChildEntity';
      case _i98.BaseEntity():
        return 'BaseEntity';
      case _i99.ParentEntity():
        return 'ParentEntity';
      case _i100.NonServerOnlyParentClass():
        return 'NonServerOnlyParentClass';
      case _i101.ParentWithDefault():
        return 'ParentWithDefault';
      case _i102.PolymorphicGrandChild():
        return 'PolymorphicGrandChild';
      case _i103.PolymorphicChild():
        return 'PolymorphicChild';
      case _i104.PolymorphicChildContainer():
        return 'PolymorphicChildContainer';
      case _i105.ModulePolymorphicChildContainer():
        return 'ModulePolymorphicChildContainer';
      case _i106.SimilarButNotParent():
        return 'SimilarButNotParent';
      case _i107.PolymorphicParent():
        return 'PolymorphicParent';
      case _i108.UnrelatedToPolymorphism():
        return 'UnrelatedToPolymorphism';
      case _i109.SealedGrandChild():
        return 'SealedGrandChild';
      case _i109.SealedChild():
        return 'SealedChild';
      case _i110.SealedChildOnlyRequired():
        return 'SealedChildOnlyRequired';
      case _i109.SealedOtherChild():
        return 'SealedOtherChild';
      case _i111.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i112.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i113.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i114.MaxFieldName():
        return 'MaxFieldName';
      case _i115.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i116.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i117.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i118.UserNote():
        return 'UserNote';
      case _i119.UserNoteCollection():
        return 'UserNoteCollection';
      case _i120.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i121.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i122.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i123.City():
        return 'City';
      case _i124.Organization():
        return 'Organization';
      case _i125.Person():
        return 'Person';
      case _i126.Course():
        return 'Course';
      case _i127.Enrollment():
        return 'Enrollment';
      case _i128.Student():
        return 'Student';
      case _i129.ObjectUser():
        return 'ObjectUser';
      case _i130.ParentUser():
        return 'ParentUser';
      case _i131.Arena():
        return 'Arena';
      case _i132.Player():
        return 'Player';
      case _i133.Team():
        return 'Team';
      case _i134.Comment():
        return 'Comment';
      case _i135.Customer():
        return 'Customer';
      case _i136.Book():
        return 'Book';
      case _i137.Chapter():
        return 'Chapter';
      case _i138.Order():
        return 'Order';
      case _i139.Address():
        return 'Address';
      case _i140.Citizen():
        return 'Citizen';
      case _i141.Company():
        return 'Company';
      case _i142.Town():
        return 'Town';
      case _i143.Blocking():
        return 'Blocking';
      case _i144.Member():
        return 'Member';
      case _i145.Cat():
        return 'Cat';
      case _i146.Post():
        return 'Post';
      case _i147.ModuleDatatype():
        return 'ModuleDatatype';
      case _i148.MyFeatureModel():
        return 'MyFeatureModel';
      case _i149.MyTriggerType():
        return 'MyTriggerType';
      case _i150.Nullability():
        return 'Nullability';
      case _i151.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i152.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i153.ObjectWithBit():
        return 'ObjectWithBit';
      case _i154.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i155.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _i156.ObjectWithDecimal():
        return 'ObjectWithDecimal';
      case _i157.ObjectWithDecimalPrecision():
        return 'ObjectWithDecimalPrecision';
      case _i158.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i159.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i160.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i161.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i162.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i163.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i164.ObjectWithNullableCustomClass():
        return 'ObjectWithNullableCustomClass';
      case _i165.ObjectWithObject():
        return 'ObjectWithObject';
      case _i166.ObjectWithParent():
        return 'ObjectWithParent';
      case _i167.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i168.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i169.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i170.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i171.ObjectWithVector():
        return 'ObjectWithVector';
      case _i172.Record():
        return 'Record';
      case _i173.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i174.ExceptionWithRequiredField():
        return 'ExceptionWithRequiredField';
      case _i175.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i176.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _i177.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _i178.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _i179.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i180.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _i181.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _i182.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _i183.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _i184.ServerOnlyDefault():
        return 'ServerOnlyDefault';
      case _i185.SessionAuthInfo():
        return 'SessionAuthInfo';
      case _i186.SharedModelContainer():
        return 'SharedModelContainer';
      case _i187.SharedModelSubclass():
        return 'SharedModelSubclass';
      case _i188.SimpleData():
        return 'SimpleData';
      case _i189.SimpleDataList():
        return 'SimpleDataList';
      case _i190.SimpleDataMap():
        return 'SimpleDataMap';
      case _i191.SimpleDataObject():
        return 'SimpleDataObject';
      case _i192.SimpleDateTime():
        return 'SimpleDateTime';
      case _i193.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _i194.TestEnum():
        return 'TestEnum';
      case _i195.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i196.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i197.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i198.TestEnumStringified():
        return 'TestEnumStringified';
      case _i199.Types():
        return 'Types';
      case _i200.TypesList():
        return 'TypesList';
      case _i201.TypesMap():
        return 'TypesMap';
      case _i202.TypesRecord():
        return 'TypesRecord';
      case _i203.TypesSet():
        return 'TypesSet';
      case _i204.TypesSetRequired():
        return 'TypesSetRequired';
      case _i205.UniqueData():
        return 'UniqueData';
      case _i206.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
    }
    className = _i212.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i207.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i210.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i212.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i210.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i210.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i210.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i210.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (String, _i213.PolymorphicParent)) {
      return '(String,PolymorphicParent)';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data
        is List<
          ((int, String), {(_i210.SimpleData, double) namedSubRecord})?
        >?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (int?, _i207.ProjectStreamingClass?)) {
      return '(int?,serverpod_test_module.ProjectStreamingClass?)';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
        )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
        )?) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?';
    }
    if (data is List<(String, int)>?) {
      return 'List<(String,int)>?';
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
      return deserialize<_i209.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i209.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i209.CustomClassWithoutProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i209.CustomClassWithProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i209.CustomClassWithProtocolSerializationMethod>(
        data['data'],
      );
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i209.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i209.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i209.FreezedCustomClass>(data['data']);
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
    if (dataClassName == 'DecimalDefault') {
      return deserialize<_i30.DecimalDefault>(data['data']);
    }
    if (dataClassName == 'DecimalDefaultMix') {
      return deserialize<_i31.DecimalDefaultMix>(data['data']);
    }
    if (dataClassName == 'DecimalDefaultModel') {
      return deserialize<_i32.DecimalDefaultModel>(data['data']);
    }
    if (dataClassName == 'DecimalDefaultPersist') {
      return deserialize<_i33.DecimalDefaultPersist>(data['data']);
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
    if (dataClassName == 'ImmutableChildObject') {
      return deserialize<_i79.ImmutableChildObject>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObjectWithNoAdditionalFields') {
      return deserialize<_i80.ImmutableChildObjectWithNoAdditionalFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObject') {
      return deserialize<_i81.ImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithImmutableObject') {
      return deserialize<_i82.ImmutableObjectWithImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithList') {
      return deserialize<_i83.ImmutableObjectWithList>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMap') {
      return deserialize<_i84.ImmutableObjectWithMap>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMultipleFields') {
      return deserialize<_i85.ImmutableObjectWithMultipleFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithNoFields') {
      return deserialize<_i86.ImmutableObjectWithNoFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithRecord') {
      return deserialize<_i87.ImmutableObjectWithRecord>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTable') {
      return deserialize<_i88.ImmutableObjectWithTable>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTwentyFields') {
      return deserialize<_i89.ImmutableObjectWithTwentyFields>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i90.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i91.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ChildClassWithoutId') {
      return deserialize<_i92.ChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i93.ParentClass>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i94.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClassWithoutId') {
      return deserialize<_i95.ParentClassWithoutId>(data['data']);
    }
    if (dataClassName == 'GrandparentClassWithId') {
      return deserialize<_i96.GrandparentClassWithId>(data['data']);
    }
    if (dataClassName == 'ChildEntity') {
      return deserialize<_i97.ChildEntity>(data['data']);
    }
    if (dataClassName == 'BaseEntity') {
      return deserialize<_i98.BaseEntity>(data['data']);
    }
    if (dataClassName == 'ParentEntity') {
      return deserialize<_i99.ParentEntity>(data['data']);
    }
    if (dataClassName == 'NonServerOnlyParentClass') {
      return deserialize<_i100.NonServerOnlyParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i101.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'PolymorphicGrandChild') {
      return deserialize<_i102.PolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChild') {
      return deserialize<_i103.PolymorphicChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChildContainer') {
      return deserialize<_i104.PolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChildContainer') {
      return deserialize<_i105.ModulePolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'SimilarButNotParent') {
      return deserialize<_i106.SimilarButNotParent>(data['data']);
    }
    if (dataClassName == 'PolymorphicParent') {
      return deserialize<_i107.PolymorphicParent>(data['data']);
    }
    if (dataClassName == 'UnrelatedToPolymorphism') {
      return deserialize<_i108.UnrelatedToPolymorphism>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i109.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i109.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedChildOnlyRequired') {
      return deserialize<_i110.SealedChildOnlyRequired>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i109.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i111.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i112.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i113.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i114.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i115.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i116.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i117.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i118.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i119.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i120.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i121.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i122.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i123.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i124.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i125.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i126.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i127.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i128.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i129.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i130.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i131.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i132.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i133.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i134.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i135.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i136.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i137.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i138.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i139.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i140.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i141.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i142.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i143.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i144.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i145.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i146.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i147.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i148.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'MyTriggerType') {
      return deserialize<_i149.MyTriggerType>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i150.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i151.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i152.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i153.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i154.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i155.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDecimal') {
      return deserialize<_i156.ObjectWithDecimal>(data['data']);
    }
    if (dataClassName == 'ObjectWithDecimalPrecision') {
      return deserialize<_i157.ObjectWithDecimalPrecision>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i158.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i159.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i160.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i161.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i162.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i163.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithNullableCustomClass') {
      return deserialize<_i164.ObjectWithNullableCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i165.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i166.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i167.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i168.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i169.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i170.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i171.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_i172.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i173.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ExceptionWithRequiredField') {
      return deserialize<_i174.ExceptionWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i175.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i176.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i177.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i178.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i179.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i180.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i181.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i182.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i183.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'ServerOnlyDefault') {
      return deserialize<_i184.ServerOnlyDefault>(data['data']);
    }
    if (dataClassName == 'SessionAuthInfo') {
      return deserialize<_i185.SessionAuthInfo>(data['data']);
    }
    if (dataClassName == 'SharedModelContainer') {
      return deserialize<_i186.SharedModelContainer>(data['data']);
    }
    if (dataClassName == 'SharedModelSubclass') {
      return deserialize<_i187.SharedModelSubclass>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i188.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i189.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i190.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i191.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i192.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_i193.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i194.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i195.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i196.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i197.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i198.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i199.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i200.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i201.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_i202.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i203.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_i204.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i205.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i206.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i212.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i207.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i210.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i212.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i210.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i210.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i210.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i210.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(String,PolymorphicParent)') {
      return deserialize<(String, _i213.PolymorphicParent)>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
        List<((int, String), {(_i210.SimpleData, double) namedSubRecord})?>?
      >(data['data']);
    }
    if (dataClassName ==
        '(int?,serverpod_test_module.ProjectStreamingClass?)') {
      return deserialize<(int?, _i207.ProjectStreamingClass?)>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i210.SimpleData simpleData}))
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i210.SimpleData simpleData}))?
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>?') {
      return deserialize<List<(String, int)>?>(data['data']);
    }
    return super.deserializeByClassName(data);
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
    if (record is (String, _i213.PolymorphicParent)) {
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
    if (record is (int, _i210.SimpleData)) {
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
    if (record is ({_i210.SimpleData data, int number})) {
      return {
        "n": {
          "data": record.data.toJson(),
          "number": record.number,
        },
      };
    }
    if (record is ({_i210.SimpleData? data, int? number})) {
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
    if (record is (int, {_i210.SimpleData data})) {
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
    if (record is ({(_i210.SimpleData, double) namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (_i210.SimpleData, double)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2,
        ],
      };
    }
    if (record is ({(_i210.SimpleData, double)? namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record
        is ((int, String), {(_i210.SimpleData, double) namedSubRecord})) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (int?, _i207.ProjectStreamingClass?)) {
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
          (Map<String, int>, {bool flag, _i210.SimpleData simpleData}),
        )) {
      return {
        "p": [
          record.$1,
          mapRecordToJson(record.$2),
        ],
      };
    }
    if (record
        is (Map<String, int>, {bool flag, _i210.SimpleData simpleData})) {
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
    if (record is (_i207.ModuleClass,)) {
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
    if (record is (_i198.TestEnumStringified,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i150.Nullability,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i198.TestEnumStringified value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i207.ModuleClass value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_i150.Nullability value})) {
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
    if (record is (_i194.TestEnum,)) {
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
    if (record is (_i208.ByteData,)) {
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
    if (record is (_i188.SimpleData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i188.SimpleData namedModel})) {
      return {
        "n": {
          "namedModel": record.namedModel.toJson(),
        },
      };
    }
    if (record is (_i188.SimpleData, {_i188.SimpleData namedModel})) {
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
          (List<(_i188.SimpleData,)>,), {
          (_i188.SimpleData, Map<String, _i188.SimpleData>) namedNestedRecord,
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
    if (record is (List<(_i188.SimpleData,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (_i188.SimpleData, Map<String, _i188.SimpleData>)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2.toJson(),
        ],
      };
    }
    try {
      return _i212.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _i207.Protocol().mapRecordToJson(record);
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
