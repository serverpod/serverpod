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
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _i80;
import 'immutable/immutable_child_object.dart' as _i81;
import 'immutable/immutable_child_object_with_no_additional_fields.dart'
    as _i82;
import 'immutable/immutable_object.dart' as _i83;
import 'immutable/immutable_object_with_immutable_object.dart' as _i84;
import 'immutable/immutable_object_with_list.dart' as _i85;
import 'immutable/immutable_object_with_map.dart' as _i86;
import 'immutable/immutable_object_with_multiple_fields.dart' as _i87;
import 'immutable/immutable_object_with_no_fields.dart' as _i88;
import 'immutable/immutable_object_with_record.dart' as _i89;
import 'immutable/immutable_object_with_table.dart' as _i90;
import 'immutable/immutable_object_with_twenty_fields.dart' as _i91;
import 'inheritance/child_class.dart' as _i92;
import 'inheritance/child_server_only.dart' as _i93;
import 'inheritance/child_with_default.dart' as _i94;
import 'inheritance/child_with_inherited_id.dart' as _i95;
import 'inheritance/child_without_id.dart' as _i96;
import 'inheritance/child_without_id_server_only.dart' as _i97;
import 'inheritance/parent_class.dart' as _i98;
import 'inheritance/grandparent_class.dart' as _i99;
import 'inheritance/parent_without_id.dart' as _i100;
import 'inheritance/grandparent_with_id.dart' as _i101;
import 'inheritance/list_relation_of_child/child_entity.dart' as _i102;
import 'inheritance/list_relation_of_child/base_entity.dart' as _i103;
import 'inheritance/list_relation_of_child/parent_entity.dart' as _i104;
import 'inheritance/parent_non_server_only.dart' as _i105;
import 'inheritance/parent_with_changed_id.dart' as _i106;
import 'inheritance/parent_with_default.dart' as _i107;
import 'inheritance/polymorphism/grandchild.dart' as _i108;
import 'inheritance/polymorphism/child.dart' as _i109;
import 'inheritance/polymorphism/container.dart' as _i110;
import 'inheritance/polymorphism/container_module.dart' as _i111;
import 'inheritance/polymorphism/other.dart' as _i112;
import 'inheritance/polymorphism/parent.dart' as _i113;
import 'inheritance/polymorphism/unrelated.dart' as _i114;
import 'inheritance/sealed_parent.dart' as _i115;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i116;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i117;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i118;
import 'long_identifiers/max_field_name.dart' as _i119;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i120;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i121;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i122;
import 'long_identifiers/models_with_relations/user_note.dart' as _i123;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i124;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i125;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i126;
import 'long_identifiers/multiple_max_field_name.dart' as _i127;
import 'models_with_list_relations/city.dart' as _i128;
import 'models_with_list_relations/organization.dart' as _i129;
import 'models_with_list_relations/person.dart' as _i130;
import 'models_with_relations/many_to_many/course.dart' as _i131;
import 'models_with_relations/many_to_many/enrollment.dart' as _i132;
import 'models_with_relations/many_to_many/student.dart' as _i133;
import 'models_with_relations/module/object_user.dart' as _i134;
import 'models_with_relations/module/parent_user.dart' as _i135;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i136;
import 'models_with_relations/nested_one_to_many/player.dart' as _i137;
import 'models_with_relations/nested_one_to_many/team.dart' as _i138;
import 'models_with_relations/one_to_many/comment.dart' as _i139;
import 'models_with_relations/one_to_many/customer.dart' as _i140;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i141;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i142;
import 'models_with_relations/one_to_many/order.dart' as _i143;
import 'models_with_relations/one_to_one/address.dart' as _i144;
import 'models_with_relations/one_to_one/citizen.dart' as _i145;
import 'models_with_relations/one_to_one/company.dart' as _i146;
import 'models_with_relations/one_to_one/town.dart' as _i147;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i148;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i149;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i150;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i151;
import 'module_datatype.dart' as _i152;
import 'my_feature/models/my_feature_model.dart' as _i153;
import 'nullability.dart' as _i154;
import 'object_field_persist.dart' as _i155;
import 'object_field_scopes.dart' as _i156;
import 'object_with_bit.dart' as _i157;
import 'object_with_bytedata.dart' as _i158;
import 'object_with_custom_class.dart' as _i159;
import 'object_with_duration.dart' as _i160;
import 'object_with_enum.dart' as _i161;
import 'object_with_enum_enhanced.dart' as _i162;
import 'object_with_half_vector.dart' as _i163;
import 'object_with_index.dart' as _i164;
import 'object_with_maps.dart' as _i165;
import 'object_with_nullable_custom_class.dart' as _i166;
import 'object_with_object.dart' as _i167;
import 'object_with_parent.dart' as _i168;
import 'object_with_sealed_class.dart' as _i169;
import 'object_with_self_parent.dart' as _i170;
import 'object_with_sparse_vector.dart' as _i171;
import 'object_with_uuid.dart' as _i172;
import 'object_with_vector.dart' as _i173;
import 'record.dart' as _i174;
import 'related_unique_data.dart' as _i175;
import 'required/exception_with_required_field.dart' as _i176;
import 'required/model_with_required_field.dart' as _i177;
import 'scopes/scope_none_fields.dart' as _i178;
import 'scopes/scope_server_only_field_child.dart' as _i179;
import 'scopes/scope_server_only_field.dart' as _i180;
import 'scopes/serverOnly/article.dart' as _i181;
import 'scopes/serverOnly/article_list.dart' as _i182;
import 'scopes/serverOnly/default_server_only_class.dart' as _i183;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i184;
import 'scopes/serverOnly/not_server_only_class.dart' as _i185;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i186;
import 'scopes/serverOnly/server_only_class.dart' as _i187;
import 'scopes/serverOnly/server_only_enum.dart' as _i188;
import 'scopes/server_only_class_field.dart' as _i189;
import 'server_only_default.dart' as _i190;
import 'session_auth_info.dart' as _i191;
import 'shared_model_subclass.dart' as _i192;
import 'simple_data.dart' as _i193;
import 'simple_data_list.dart' as _i194;
import 'simple_data_map.dart' as _i195;
import 'simple_data_object.dart' as _i196;
import 'simple_date_time.dart' as _i197;
import 'subfolder/model_in_subfolder.dart' as _i198;
import 'test_enum.dart' as _i199;
import 'test_enum_default_serialization.dart' as _i200;
import 'test_enum_enhanced.dart' as _i201;
import 'test_enum_enhanced_by_name.dart' as _i202;
import 'test_enum_stringified.dart' as _i203;
import 'types.dart' as _i204;
import 'types_list.dart' as _i205;
import 'types_map.dart' as _i206;
import 'types_record.dart' as _i207;
import 'types_set.dart' as _i208;
import 'types_set_required.dart' as _i209;
import 'unique_data.dart' as _i210;
import 'unique_data_with_non_persist.dart' as _i211;
import 'dart:typed_data' as _i212;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i213;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i214;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i215;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _i216;
import 'package:serverpod_test_server/src/generated/types.dart' as _i217;
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
export 'nullability.dart';
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bit.dart';
export 'object_with_bytedata.dart';
export 'object_with_custom_class.dart';
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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
          columnDefault: 'nextval(\'address_id_seq\'::regclass)',
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
          indexName: 'address_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'gen_random_uuid()',
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
          indexName: 'address_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'arena_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'arena_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'arena_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bigint_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'bigintDefaultStr',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'bigintDefaultStrNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bigint_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bigint_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'1\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'12345678901234567890\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bigint_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bigint_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bigint_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bigint_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'bigIntDefaultPersistStr',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bigint_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'blocking_id_seq\'::regclass)',
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
          indexName: 'blocking_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'book_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'title',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'book_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bool_default_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bool_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bool_default_mix_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bool_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bool_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bool_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'bool_default_persist_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'bool_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'cat_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cat_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid()',
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
          indexName: 'changed_id_type_self_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'chapter_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chapter_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'child_entity_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'child_entity_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'child_table_explicit_column_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'child_table_explicit_column_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid()',
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
          indexName: 'child_table_with_inherited_id_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'gen_random_uuid_v7()',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'child_with_inherited_id_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'citizen_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'citizen_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'citizen_int_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'citizen_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'city_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'city_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'city_with_long_table_name_that_is_still_valid_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'city_with_long_table_name_that_is_still_valid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'comment_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'comment_int_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'company_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'company_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid_v7()',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'company_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'contractor_id_seq\'::regclass)',
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
          indexName: 'contractor_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'course_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'course_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'course_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'customer_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'customer_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'customer_int_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'customer_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'datetime_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultNow',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultStr',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '\'2024-05-24 22:00:00\'::timestamp without time zone',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultStrNull',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '\'2024-05-24 22:00:00\'::timestamp without time zone',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'datetime_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'datetime_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultModel',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '\'2024-05-01 22:00:00\'::timestamp without time zone',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '\'2024-05-10 22:00:00\'::timestamp without time zone',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '\'2024-05-10 22:00:00\'::timestamp without time zone',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'datetime_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'datetime_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'datetime_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'datetime_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultPersistNow',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: 'CURRENT_TIMESTAMP',
        ),
        _i2.ColumnDefinition(
          name: 'dateTimeDefaultPersistStr',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '\'2024-05-10 22:00:00\'::timestamp without time zone',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'datetime_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'department_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'department_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'double_default_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'double_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'double_default_mix_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'double_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'double_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'double_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'double_default_persist_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'double_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'duration_default_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'duration_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'duration_default_mix_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'duration_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'duration_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'duration_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'duration_default_persist_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'duration_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'employee_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'employee_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'empty_model_relation_item_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'empty_model_relation_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'empty_model_with_table_id_seq\'::regclass)',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'empty_model_with_table_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'enrollment_id_seq\'::regclass)',
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
          indexName: 'enrollment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'enrollment_int_id_seq\'::regclass)',
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
          indexName: 'enrollment_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'enum_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName2\'::text',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enum_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'enum_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enum_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'enum_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enum_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'enum_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'byNameEnumDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName1\'::text',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'enum_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'immutable_object_with_table_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'variable',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'immutable_object_with_table_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'int_default_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'int_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'int_default_mix_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'int_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'int_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'int_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'int_default_persist_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'int_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'long_implicit_id_field_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'long_implicit_id_field_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'long_implicit_id_field_collection_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'long_implicit_id_field_collection_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'max_field_name_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'max_field_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'member_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'member_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'model_with_required_field_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'model_with_required_field_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'modified_column_name_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'modified_column_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'multiple_max_field_name_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'multiple_max_field_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_field_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'normal',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_field_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_field_scopes_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_field_scopes_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_user_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_with_bit_id_seq\'::regclass)',
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
          indexName: 'object_with_bit_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'object_with_bytedata_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'byteData',
          columnType: _i2.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_bytedata_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_with_duration_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'duration',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_duration_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_with_enum_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_enum_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'object_with_enum_enhanced_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_enum_enhanced_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'object_with_half_vector_id_seq\'::regclass)',
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
          indexName: 'object_with_half_vector_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'object_with_index_id_seq\'::regclass)',
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
          indexName: 'object_with_index_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'object_with_object_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_object_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_with_parent_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_parent_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'object_with_self_parent_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_self_parent_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'object_with_sparse_vector_id_seq\'::regclass)',
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
          indexName: 'object_with_sparse_vector_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'object_with_uuid_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'object_with_vector_id_seq\'::regclass)',
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
          indexName: 'object_with_vector_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'order_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid_v7()',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'organization_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'organization_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'organization_with_long_table_name_that_is_still_valid_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName:
              'organization_with_long_table_name_that_is_still_valid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'parent_class_table_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'parent_class_table_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'parent_entity_id_seq\'::regclass)',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'parent_entity_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'parent_user_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'parent_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'person_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'person_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'person_with_long_table_name_that_is_still_valid_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'person_with_long_table_name_that_is_still_valid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'player_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'player_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid()',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'player_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'post_id_seq\'::regclass)',
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
          indexName: 'post_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'related_unique_data_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'related_unique_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'relation_empty_model_id_seq\'::regclass)',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'relation_empty_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'relation_to_multiple_max_field_name_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'relation_to_multiple_max_field_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'scope_none_fields_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'scope_none_fields_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid()',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'server_only_changed_id_field_class_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'service_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'service_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'simple_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'num',
          columnType: _i2.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'simple_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'simple_date_time_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'dateTime',
          columnType: _i2.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'simple_date_time_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'string_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default null value\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'string_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'string_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'string_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'string_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'string_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'string_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneDoubleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoDoubleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneSingleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoSingleQuote',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'string_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'student_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'student_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'student_uuid_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'table_with_explicit_column_names_id_seq\'::regclass)',
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
          columnDefault: '\'Just some information\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'table_with_explicit_column_names_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'team_id_seq\'::regclass)',
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
          indexName: 'team_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'team_int_id_seq\'::regclass)',
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
          indexName: 'team_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'town_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'town_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'town_int_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'town_int_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'types_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'types_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'unique_data_id_seq\'::regclass)',
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
          indexName: 'unique_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault:
              'nextval(\'unique_data_with_non_persist_id_seq\'::regclass)',
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
          indexName: 'unique_data_with_non_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
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
          columnDefault: 'nextval(\'uri_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefault',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultNull',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/default\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uri_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uri_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultAndDefaultModel',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'::text',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uri_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uri_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uri_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uri_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uriDefaultPersist',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/\'::text',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uri_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'user_note_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'user_note_collection_with_a_long_name_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_collection_with_a_long_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'user_note_collections_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'name',
          columnType: _i2.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_collections_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault:
              'nextval(\'user_note_with_a_long_name_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_with_a_long_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uuid_default_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandom',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandomV7',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultRandomNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultStr',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'::uuid',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultStrNull',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'::uuid',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uuid_default_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uuid_default_mix_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultAndDefaultModel',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'::uuid',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'9e107d9d-372b-4d97-9b27-2f0907d0b1d4\'::uuid',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'f47ac10b-58cc-4372-a567-0e02b2c3d479\'::uuid',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uuid_default_mix_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uuid_default_model_id_seq\'::regclass)',
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
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uuid_default_model_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
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
          columnDefault: 'nextval(\'uuid_default_persist_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistRandom',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid()',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistRandomV7',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'gen_random_uuid_v7()',
        ),
        _i2.ColumnDefinition(
          name: 'uuidDefaultPersistStr',
          columnType: _i2.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'::uuid',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'uuid_default_persist_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        ),
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

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

    if (t == _i5.ByIndexEnumWithNameValue) {
      return _i5.ByIndexEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i6.ByNameEnumWithNameValue) {
      return _i6.ByNameEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i7.CourseUuid) {
      return _i7.CourseUuid.fromJson(data) as T;
    }
    if (t == _i8.EnrollmentInt) {
      return _i8.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i9.StudentUuid) {
      return _i9.StudentUuid.fromJson(data) as T;
    }
    if (t == _i10.ArenaUuid) {
      return _i10.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i11.PlayerUuid) {
      return _i11.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i12.TeamInt) {
      return _i12.TeamInt.fromJson(data) as T;
    }
    if (t == _i13.CommentInt) {
      return _i13.CommentInt.fromJson(data) as T;
    }
    if (t == _i14.CustomerInt) {
      return _i14.CustomerInt.fromJson(data) as T;
    }
    if (t == _i15.OrderUuid) {
      return _i15.OrderUuid.fromJson(data) as T;
    }
    if (t == _i16.AddressUuid) {
      return _i16.AddressUuid.fromJson(data) as T;
    }
    if (t == _i17.CitizenInt) {
      return _i17.CitizenInt.fromJson(data) as T;
    }
    if (t == _i18.CompanyUuid) {
      return _i18.CompanyUuid.fromJson(data) as T;
    }
    if (t == _i19.TownInt) {
      return _i19.TownInt.fromJson(data) as T;
    }
    if (t == _i20.ChangedIdTypeSelf) {
      return _i20.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _i21.ServerOnlyChangedIdFieldClass) {
      return _i21.ServerOnlyChangedIdFieldClass.fromJson(data) as T;
    }
    if (t == _i22.BigIntDefault) {
      return _i22.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i23.BigIntDefaultMix) {
      return _i23.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i24.BigIntDefaultModel) {
      return _i24.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i25.BigIntDefaultPersist) {
      return _i25.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i26.BoolDefault) {
      return _i26.BoolDefault.fromJson(data) as T;
    }
    if (t == _i27.BoolDefaultMix) {
      return _i27.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i28.BoolDefaultModel) {
      return _i28.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i29.BoolDefaultPersist) {
      return _i29.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i30.DateTimeDefault) {
      return _i30.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i31.DateTimeDefaultMix) {
      return _i31.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i32.DateTimeDefaultModel) {
      return _i32.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i33.DateTimeDefaultPersist) {
      return _i33.DateTimeDefaultPersist.fromJson(data) as T;
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
    if (t == _i79.TestGeneratedCallByeModel) {
      return _i79.TestGeneratedCallByeModel.fromJson(data) as T;
    }
    if (t == _i80.TestGeneratedCallHelloModel) {
      return _i80.TestGeneratedCallHelloModel.fromJson(data) as T;
    }
    if (t == _i81.ImmutableChildObject) {
      return _i81.ImmutableChildObject.fromJson(data) as T;
    }
    if (t == _i82.ImmutableChildObjectWithNoAdditionalFields) {
      return _i82.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
          as T;
    }
    if (t == _i83.ImmutableObject) {
      return _i83.ImmutableObject.fromJson(data) as T;
    }
    if (t == _i84.ImmutableObjectWithImmutableObject) {
      return _i84.ImmutableObjectWithImmutableObject.fromJson(data) as T;
    }
    if (t == _i85.ImmutableObjectWithList) {
      return _i85.ImmutableObjectWithList.fromJson(data) as T;
    }
    if (t == _i86.ImmutableObjectWithMap) {
      return _i86.ImmutableObjectWithMap.fromJson(data) as T;
    }
    if (t == _i87.ImmutableObjectWithMultipleFields) {
      return _i87.ImmutableObjectWithMultipleFields.fromJson(data) as T;
    }
    if (t == _i88.ImmutableObjectWithNoFields) {
      return _i88.ImmutableObjectWithNoFields.fromJson(data) as T;
    }
    if (t == _i89.ImmutableObjectWithRecord) {
      return _i89.ImmutableObjectWithRecord.fromJson(data) as T;
    }
    if (t == _i90.ImmutableObjectWithTable) {
      return _i90.ImmutableObjectWithTable.fromJson(data) as T;
    }
    if (t == _i91.ImmutableObjectWithTwentyFields) {
      return _i91.ImmutableObjectWithTwentyFields.fromJson(data) as T;
    }
    if (t == _i92.ChildClass) {
      return _i92.ChildClass.fromJson(data) as T;
    }
    if (t == _i93.ServerOnlyChildClass) {
      return _i93.ServerOnlyChildClass.fromJson(data) as T;
    }
    if (t == _i94.ChildWithDefault) {
      return _i94.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i95.ChildWithInheritedId) {
      return _i95.ChildWithInheritedId.fromJson(data) as T;
    }
    if (t == _i96.ChildClassWithoutId) {
      return _i96.ChildClassWithoutId.fromJson(data) as T;
    }
    if (t == _i97.ServerOnlyChildClassWithoutId) {
      return _i97.ServerOnlyChildClassWithoutId.fromJson(data) as T;
    }
    if (t == _i98.ParentClass) {
      return _i98.ParentClass.fromJson(data) as T;
    }
    if (t == _i99.GrandparentClass) {
      return _i99.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i100.ParentClassWithoutId) {
      return _i100.ParentClassWithoutId.fromJson(data) as T;
    }
    if (t == _i101.GrandparentClassWithId) {
      return _i101.GrandparentClassWithId.fromJson(data) as T;
    }
    if (t == _i102.ChildEntity) {
      return _i102.ChildEntity.fromJson(data) as T;
    }
    if (t == _i103.BaseEntity) {
      return _i103.BaseEntity.fromJson(data) as T;
    }
    if (t == _i104.ParentEntity) {
      return _i104.ParentEntity.fromJson(data) as T;
    }
    if (t == _i105.NonServerOnlyParentClass) {
      return _i105.NonServerOnlyParentClass.fromJson(data) as T;
    }
    if (t == _i106.ParentWithChangedId) {
      return _i106.ParentWithChangedId.fromJson(data) as T;
    }
    if (t == _i107.ParentWithDefault) {
      return _i107.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i108.PolymorphicGrandChild) {
      return _i108.PolymorphicGrandChild.fromJson(data) as T;
    }
    if (t == _i109.PolymorphicChild) {
      return _i109.PolymorphicChild.fromJson(data) as T;
    }
    if (t == _i110.PolymorphicChildContainer) {
      return _i110.PolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _i111.ModulePolymorphicChildContainer) {
      return _i111.ModulePolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _i112.SimilarButNotParent) {
      return _i112.SimilarButNotParent.fromJson(data) as T;
    }
    if (t == _i113.PolymorphicParent) {
      return _i113.PolymorphicParent.fromJson(data) as T;
    }
    if (t == _i114.UnrelatedToPolymorphism) {
      return _i114.UnrelatedToPolymorphism.fromJson(data) as T;
    }
    if (t == _i115.SealedGrandChild) {
      return _i115.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i115.SealedChild) {
      return _i115.SealedChild.fromJson(data) as T;
    }
    if (t == _i115.SealedOtherChild) {
      return _i115.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i116.CityWithLongTableName) {
      return _i116.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i117.OrganizationWithLongTableName) {
      return _i117.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i118.PersonWithLongTableName) {
      return _i118.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i119.MaxFieldName) {
      return _i119.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i120.LongImplicitIdField) {
      return _i120.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i121.LongImplicitIdFieldCollection) {
      return _i121.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i122.RelationToMultipleMaxFieldName) {
      return _i122.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i123.UserNote) {
      return _i123.UserNote.fromJson(data) as T;
    }
    if (t == _i124.UserNoteCollection) {
      return _i124.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i125.UserNoteCollectionWithALongName) {
      return _i125.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i126.UserNoteWithALongName) {
      return _i126.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i127.MultipleMaxFieldName) {
      return _i127.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i128.City) {
      return _i128.City.fromJson(data) as T;
    }
    if (t == _i129.Organization) {
      return _i129.Organization.fromJson(data) as T;
    }
    if (t == _i130.Person) {
      return _i130.Person.fromJson(data) as T;
    }
    if (t == _i131.Course) {
      return _i131.Course.fromJson(data) as T;
    }
    if (t == _i132.Enrollment) {
      return _i132.Enrollment.fromJson(data) as T;
    }
    if (t == _i133.Student) {
      return _i133.Student.fromJson(data) as T;
    }
    if (t == _i134.ObjectUser) {
      return _i134.ObjectUser.fromJson(data) as T;
    }
    if (t == _i135.ParentUser) {
      return _i135.ParentUser.fromJson(data) as T;
    }
    if (t == _i136.Arena) {
      return _i136.Arena.fromJson(data) as T;
    }
    if (t == _i137.Player) {
      return _i137.Player.fromJson(data) as T;
    }
    if (t == _i138.Team) {
      return _i138.Team.fromJson(data) as T;
    }
    if (t == _i139.Comment) {
      return _i139.Comment.fromJson(data) as T;
    }
    if (t == _i140.Customer) {
      return _i140.Customer.fromJson(data) as T;
    }
    if (t == _i141.Book) {
      return _i141.Book.fromJson(data) as T;
    }
    if (t == _i142.Chapter) {
      return _i142.Chapter.fromJson(data) as T;
    }
    if (t == _i143.Order) {
      return _i143.Order.fromJson(data) as T;
    }
    if (t == _i144.Address) {
      return _i144.Address.fromJson(data) as T;
    }
    if (t == _i145.Citizen) {
      return _i145.Citizen.fromJson(data) as T;
    }
    if (t == _i146.Company) {
      return _i146.Company.fromJson(data) as T;
    }
    if (t == _i147.Town) {
      return _i147.Town.fromJson(data) as T;
    }
    if (t == _i148.Blocking) {
      return _i148.Blocking.fromJson(data) as T;
    }
    if (t == _i149.Member) {
      return _i149.Member.fromJson(data) as T;
    }
    if (t == _i150.Cat) {
      return _i150.Cat.fromJson(data) as T;
    }
    if (t == _i151.Post) {
      return _i151.Post.fromJson(data) as T;
    }
    if (t == _i152.ModuleDatatype) {
      return _i152.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i153.MyFeatureModel) {
      return _i153.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i154.Nullability) {
      return _i154.Nullability.fromJson(data) as T;
    }
    if (t == _i155.ObjectFieldPersist) {
      return _i155.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i156.ObjectFieldScopes) {
      return _i156.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i157.ObjectWithBit) {
      return _i157.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i158.ObjectWithByteData) {
      return _i158.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i159.ObjectWithCustomClass) {
      return _i159.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i160.ObjectWithDuration) {
      return _i160.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i161.ObjectWithEnum) {
      return _i161.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i162.ObjectWithEnumEnhanced) {
      return _i162.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i163.ObjectWithHalfVector) {
      return _i163.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i164.ObjectWithIndex) {
      return _i164.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i165.ObjectWithMaps) {
      return _i165.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i166.ObjectWithNullableCustomClass) {
      return _i166.ObjectWithNullableCustomClass.fromJson(data) as T;
    }
    if (t == _i167.ObjectWithObject) {
      return _i167.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i168.ObjectWithParent) {
      return _i168.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i169.ObjectWithSealedClass) {
      return _i169.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i170.ObjectWithSelfParent) {
      return _i170.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i171.ObjectWithSparseVector) {
      return _i171.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i172.ObjectWithUuid) {
      return _i172.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i173.ObjectWithVector) {
      return _i173.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i174.Record) {
      return _i174.Record.fromJson(data) as T;
    }
    if (t == _i175.RelatedUniqueData) {
      return _i175.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i176.ExceptionWithRequiredField) {
      return _i176.ExceptionWithRequiredField.fromJson(data) as T;
    }
    if (t == _i177.ModelWithRequiredField) {
      return _i177.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i178.ScopeNoneFields) {
      return _i178.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i179.ScopeServerOnlyFieldChild) {
      return _i179.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i180.ScopeServerOnlyField) {
      return _i180.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i181.Article) {
      return _i181.Article.fromJson(data) as T;
    }
    if (t == _i182.ArticleList) {
      return _i182.ArticleList.fromJson(data) as T;
    }
    if (t == _i183.DefaultServerOnlyClass) {
      return _i183.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i184.DefaultServerOnlyEnum) {
      return _i184.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i185.NotServerOnlyClass) {
      return _i185.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i186.NotServerOnlyEnum) {
      return _i186.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i187.ServerOnlyClass) {
      return _i187.ServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i188.ServerOnlyEnum) {
      return _i188.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i189.ServerOnlyClassField) {
      return _i189.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i190.ServerOnlyDefault) {
      return _i190.ServerOnlyDefault.fromJson(data) as T;
    }
    if (t == _i191.SessionAuthInfo) {
      return _i191.SessionAuthInfo.fromJson(data) as T;
    }
    if (t == _i192.SharedModelSubclass) {
      return _i192.SharedModelSubclass.fromJson(data) as T;
    }
    if (t == _i193.SimpleData) {
      return _i193.SimpleData.fromJson(data) as T;
    }
    if (t == _i194.SimpleDataList) {
      return _i194.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i195.SimpleDataMap) {
      return _i195.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i196.SimpleDataObject) {
      return _i196.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i197.SimpleDateTime) {
      return _i197.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i198.ModelInSubfolder) {
      return _i198.ModelInSubfolder.fromJson(data) as T;
    }
    if (t == _i199.TestEnum) {
      return _i199.TestEnum.fromJson(data) as T;
    }
    if (t == _i200.TestEnumDefaultSerialization) {
      return _i200.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i201.TestEnumEnhanced) {
      return _i201.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i202.TestEnumEnhancedByName) {
      return _i202.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i203.TestEnumStringified) {
      return _i203.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i204.Types) {
      return _i204.Types.fromJson(data) as T;
    }
    if (t == _i205.TypesList) {
      return _i205.TypesList.fromJson(data) as T;
    }
    if (t == _i206.TypesMap) {
      return _i206.TypesMap.fromJson(data) as T;
    }
    if (t == _i207.TypesRecord) {
      return _i207.TypesRecord.fromJson(data) as T;
    }
    if (t == _i208.TypesSet) {
      return _i208.TypesSet.fromJson(data) as T;
    }
    if (t == _i209.TypesSetRequired) {
      return _i209.TypesSetRequired.fromJson(data) as T;
    }
    if (t == _i210.UniqueData) {
      return _i210.UniqueData.fromJson(data) as T;
    }
    if (t == _i211.UniqueDataWithNonPersist) {
      return _i211.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ByIndexEnumWithNameValue?>()) {
      return (data != null ? _i5.ByIndexEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ByNameEnumWithNameValue?>()) {
      return (data != null ? _i6.ByNameEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.CourseUuid?>()) {
      return (data != null ? _i7.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.EnrollmentInt?>()) {
      return (data != null ? _i8.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.StudentUuid?>()) {
      return (data != null ? _i9.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ArenaUuid?>()) {
      return (data != null ? _i10.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.PlayerUuid?>()) {
      return (data != null ? _i11.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.TeamInt?>()) {
      return (data != null ? _i12.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CommentInt?>()) {
      return (data != null ? _i13.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CustomerInt?>()) {
      return (data != null ? _i14.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.OrderUuid?>()) {
      return (data != null ? _i15.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.AddressUuid?>()) {
      return (data != null ? _i16.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.CitizenInt?>()) {
      return (data != null ? _i17.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.CompanyUuid?>()) {
      return (data != null ? _i18.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.TownInt?>()) {
      return (data != null ? _i19.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.ChangedIdTypeSelf?>()) {
      return (data != null ? _i20.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.ServerOnlyChangedIdFieldClass?>()) {
      return (data != null
              ? _i21.ServerOnlyChangedIdFieldClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i22.BigIntDefault?>()) {
      return (data != null ? _i22.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.BigIntDefaultMix?>()) {
      return (data != null ? _i23.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BigIntDefaultModel?>()) {
      return (data != null ? _i24.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.BigIntDefaultPersist?>()) {
      return (data != null ? _i25.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.BoolDefault?>()) {
      return (data != null ? _i26.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.BoolDefaultMix?>()) {
      return (data != null ? _i27.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.BoolDefaultModel?>()) {
      return (data != null ? _i28.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.BoolDefaultPersist?>()) {
      return (data != null ? _i29.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.DateTimeDefault?>()) {
      return (data != null ? _i30.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.DateTimeDefaultMix?>()) {
      return (data != null ? _i31.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.DateTimeDefaultModel?>()) {
      return (data != null ? _i32.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i33.DateTimeDefaultPersist?>()) {
      return (data != null ? _i33.DateTimeDefaultPersist.fromJson(data) : null)
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
    if (t == _i1.getType<_i79.TestGeneratedCallByeModel?>()) {
      return (data != null
              ? _i79.TestGeneratedCallByeModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i80.TestGeneratedCallHelloModel?>()) {
      return (data != null
              ? _i80.TestGeneratedCallHelloModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i81.ImmutableChildObject?>()) {
      return (data != null ? _i81.ImmutableChildObject.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.ImmutableChildObjectWithNoAdditionalFields?>()) {
      return (data != null
              ? _i82.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i83.ImmutableObject?>()) {
      return (data != null ? _i83.ImmutableObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i84.ImmutableObjectWithImmutableObject?>()) {
      return (data != null
              ? _i84.ImmutableObjectWithImmutableObject.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i85.ImmutableObjectWithList?>()) {
      return (data != null ? _i85.ImmutableObjectWithList.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i86.ImmutableObjectWithMap?>()) {
      return (data != null ? _i86.ImmutableObjectWithMap.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.ImmutableObjectWithMultipleFields?>()) {
      return (data != null
              ? _i87.ImmutableObjectWithMultipleFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i88.ImmutableObjectWithNoFields?>()) {
      return (data != null
              ? _i88.ImmutableObjectWithNoFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i89.ImmutableObjectWithRecord?>()) {
      return (data != null
              ? _i89.ImmutableObjectWithRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i90.ImmutableObjectWithTable?>()) {
      return (data != null
              ? _i90.ImmutableObjectWithTable.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i91.ImmutableObjectWithTwentyFields?>()) {
      return (data != null
              ? _i91.ImmutableObjectWithTwentyFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i92.ChildClass?>()) {
      return (data != null ? _i92.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.ServerOnlyChildClass?>()) {
      return (data != null ? _i93.ServerOnlyChildClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i94.ChildWithDefault?>()) {
      return (data != null ? _i94.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.ChildWithInheritedId?>()) {
      return (data != null ? _i95.ChildWithInheritedId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.ChildClassWithoutId?>()) {
      return (data != null ? _i96.ChildClassWithoutId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.ServerOnlyChildClassWithoutId?>()) {
      return (data != null
              ? _i97.ServerOnlyChildClassWithoutId.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i98.ParentClass?>()) {
      return (data != null ? _i98.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.GrandparentClass?>()) {
      return (data != null ? _i99.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.ParentClassWithoutId?>()) {
      return (data != null ? _i100.ParentClassWithoutId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i101.GrandparentClassWithId?>()) {
      return (data != null ? _i101.GrandparentClassWithId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i102.ChildEntity?>()) {
      return (data != null ? _i102.ChildEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.BaseEntity?>()) {
      return (data != null ? _i103.BaseEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.ParentEntity?>()) {
      return (data != null ? _i104.ParentEntity.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.NonServerOnlyParentClass?>()) {
      return (data != null
              ? _i105.NonServerOnlyParentClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i106.ParentWithChangedId?>()) {
      return (data != null ? _i106.ParentWithChangedId.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i107.ParentWithDefault?>()) {
      return (data != null ? _i107.ParentWithDefault.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i108.PolymorphicGrandChild?>()) {
      return (data != null ? _i108.PolymorphicGrandChild.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i109.PolymorphicChild?>()) {
      return (data != null ? _i109.PolymorphicChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.PolymorphicChildContainer?>()) {
      return (data != null
              ? _i110.PolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i111.ModulePolymorphicChildContainer?>()) {
      return (data != null
              ? _i111.ModulePolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i112.SimilarButNotParent?>()) {
      return (data != null ? _i112.SimilarButNotParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i113.PolymorphicParent?>()) {
      return (data != null ? _i113.PolymorphicParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i114.UnrelatedToPolymorphism?>()) {
      return (data != null
              ? _i114.UnrelatedToPolymorphism.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i115.SealedGrandChild?>()) {
      return (data != null ? _i115.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.SealedChild?>()) {
      return (data != null ? _i115.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.SealedOtherChild?>()) {
      return (data != null ? _i115.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i116.CityWithLongTableName?>()) {
      return (data != null ? _i116.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i117.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i117.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i118.PersonWithLongTableName?>()) {
      return (data != null
              ? _i118.PersonWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i119.MaxFieldName?>()) {
      return (data != null ? _i119.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i120.LongImplicitIdField?>()) {
      return (data != null ? _i120.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i121.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i121.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i122.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i122.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i123.UserNote?>()) {
      return (data != null ? _i123.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.UserNoteCollection?>()) {
      return (data != null ? _i124.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i125.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i125.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i126.UserNoteWithALongName?>()) {
      return (data != null ? _i126.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i127.MultipleMaxFieldName?>()) {
      return (data != null ? _i127.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i128.City?>()) {
      return (data != null ? _i128.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.Organization?>()) {
      return (data != null ? _i129.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i130.Person?>()) {
      return (data != null ? _i130.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.Course?>()) {
      return (data != null ? _i131.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i132.Enrollment?>()) {
      return (data != null ? _i132.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i133.Student?>()) {
      return (data != null ? _i133.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i134.ObjectUser?>()) {
      return (data != null ? _i134.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.ParentUser?>()) {
      return (data != null ? _i135.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i136.Arena?>()) {
      return (data != null ? _i136.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i137.Player?>()) {
      return (data != null ? _i137.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i138.Team?>()) {
      return (data != null ? _i138.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i139.Comment?>()) {
      return (data != null ? _i139.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i140.Customer?>()) {
      return (data != null ? _i140.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i141.Book?>()) {
      return (data != null ? _i141.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i142.Chapter?>()) {
      return (data != null ? _i142.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i143.Order?>()) {
      return (data != null ? _i143.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i144.Address?>()) {
      return (data != null ? _i144.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i145.Citizen?>()) {
      return (data != null ? _i145.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i146.Company?>()) {
      return (data != null ? _i146.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i147.Town?>()) {
      return (data != null ? _i147.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i148.Blocking?>()) {
      return (data != null ? _i148.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i149.Member?>()) {
      return (data != null ? _i149.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i150.Cat?>()) {
      return (data != null ? _i150.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i151.Post?>()) {
      return (data != null ? _i151.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i152.ModuleDatatype?>()) {
      return (data != null ? _i152.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i153.MyFeatureModel?>()) {
      return (data != null ? _i153.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i154.Nullability?>()) {
      return (data != null ? _i154.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i155.ObjectFieldPersist?>()) {
      return (data != null ? _i155.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i156.ObjectFieldScopes?>()) {
      return (data != null ? _i156.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i157.ObjectWithBit?>()) {
      return (data != null ? _i157.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i158.ObjectWithByteData?>()) {
      return (data != null ? _i158.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i159.ObjectWithCustomClass?>()) {
      return (data != null ? _i159.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i160.ObjectWithDuration?>()) {
      return (data != null ? _i160.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i161.ObjectWithEnum?>()) {
      return (data != null ? _i161.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i162.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i162.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i163.ObjectWithHalfVector?>()) {
      return (data != null ? _i163.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i164.ObjectWithIndex?>()) {
      return (data != null ? _i164.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i165.ObjectWithMaps?>()) {
      return (data != null ? _i165.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i166.ObjectWithNullableCustomClass?>()) {
      return (data != null
              ? _i166.ObjectWithNullableCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i167.ObjectWithObject?>()) {
      return (data != null ? _i167.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i168.ObjectWithParent?>()) {
      return (data != null ? _i168.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i169.ObjectWithSealedClass?>()) {
      return (data != null ? _i169.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i170.ObjectWithSelfParent?>()) {
      return (data != null ? _i170.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i171.ObjectWithSparseVector?>()) {
      return (data != null ? _i171.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i172.ObjectWithUuid?>()) {
      return (data != null ? _i172.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i173.ObjectWithVector?>()) {
      return (data != null ? _i173.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i174.Record?>()) {
      return (data != null ? _i174.Record.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i175.RelatedUniqueData?>()) {
      return (data != null ? _i175.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i176.ExceptionWithRequiredField?>()) {
      return (data != null
              ? _i176.ExceptionWithRequiredField.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i177.ModelWithRequiredField?>()) {
      return (data != null ? _i177.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i178.ScopeNoneFields?>()) {
      return (data != null ? _i178.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i179.ScopeServerOnlyFieldChild?>()) {
      return (data != null
              ? _i179.ScopeServerOnlyFieldChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i180.ScopeServerOnlyField?>()) {
      return (data != null ? _i180.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i181.Article?>()) {
      return (data != null ? _i181.Article.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i182.ArticleList?>()) {
      return (data != null ? _i182.ArticleList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i183.DefaultServerOnlyClass?>()) {
      return (data != null ? _i183.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i184.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i184.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i185.NotServerOnlyClass?>()) {
      return (data != null ? _i185.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i186.NotServerOnlyEnum?>()) {
      return (data != null ? _i186.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i187.ServerOnlyClass?>()) {
      return (data != null ? _i187.ServerOnlyClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i188.ServerOnlyEnum?>()) {
      return (data != null ? _i188.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i189.ServerOnlyClassField?>()) {
      return (data != null ? _i189.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i190.ServerOnlyDefault?>()) {
      return (data != null ? _i190.ServerOnlyDefault.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i191.SessionAuthInfo?>()) {
      return (data != null ? _i191.SessionAuthInfo.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i192.SharedModelSubclass?>()) {
      return (data != null ? _i192.SharedModelSubclass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i193.SimpleData?>()) {
      return (data != null ? _i193.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i194.SimpleDataList?>()) {
      return (data != null ? _i194.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i195.SimpleDataMap?>()) {
      return (data != null ? _i195.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i196.SimpleDataObject?>()) {
      return (data != null ? _i196.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i197.SimpleDateTime?>()) {
      return (data != null ? _i197.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i198.ModelInSubfolder?>()) {
      return (data != null ? _i198.ModelInSubfolder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i199.TestEnum?>()) {
      return (data != null ? _i199.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i200.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i200.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i201.TestEnumEnhanced?>()) {
      return (data != null ? _i201.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i202.TestEnumEnhancedByName?>()) {
      return (data != null ? _i202.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i203.TestEnumStringified?>()) {
      return (data != null ? _i203.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i204.Types?>()) {
      return (data != null ? _i204.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i205.TypesList?>()) {
      return (data != null ? _i205.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i206.TypesMap?>()) {
      return (data != null ? _i206.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i207.TypesRecord?>()) {
      return (data != null ? _i207.TypesRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i208.TypesSet?>()) {
      return (data != null ? _i208.TypesSet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i209.TypesSetRequired?>()) {
      return (data != null ? _i209.TypesSetRequired.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i210.UniqueData?>()) {
      return (data != null ? _i210.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i211.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i211.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_i8.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i8.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i8.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i11.PlayerUuid>) {
      return (data as List).map((e) => deserialize<_i11.PlayerUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i15.OrderUuid>) {
      return (data as List).map((e) => deserialize<_i15.OrderUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i15.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i15.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.CommentInt>) {
      return (data as List).map((e) => deserialize<_i13.CommentInt>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i20.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_i20.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i20.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i20.ChangedIdTypeSelf>(e))
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
    if (t == List<_i102.ChildEntity>) {
      return (data as List)
              .map((e) => deserialize<_i102.ChildEntity>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i102.ChildEntity>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i102.ChildEntity>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i109.PolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_i109.PolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == List<_i109.PolymorphicChild?>) {
      return (data as List)
              .map((e) => deserialize<_i109.PolymorphicChild?>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i109.PolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i109.PolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i109.PolymorphicChild?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i109.PolymorphicChild?>(v),
            ),
          )
          as T;
    }
    if (t == List<_i4.ModulePolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_i4.ModulePolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i4.ModulePolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i4.ModulePolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == List<_i118.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i118.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i118.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i118.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i117.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i117.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i117.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<_i117.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i120.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i120.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i120.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i120.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i127.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i127.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i127.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i127.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i123.UserNote>) {
      return (data as List).map((e) => deserialize<_i123.UserNote>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i123.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i123.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i126.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i126.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i126.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i126.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i130.Person>) {
      return (data as List).map((e) => deserialize<_i130.Person>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i130.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i130.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i129.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i129.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i129.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i129.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i132.Enrollment>) {
      return (data as List)
              .map((e) => deserialize<_i132.Enrollment>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i132.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i132.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i137.Player>) {
      return (data as List).map((e) => deserialize<_i137.Player>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i137.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i137.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i143.Order>) {
      return (data as List).map((e) => deserialize<_i143.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i143.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i143.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i142.Chapter>) {
      return (data as List).map((e) => deserialize<_i142.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i142.Chapter>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i142.Chapter>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i139.Comment>) {
      return (data as List).map((e) => deserialize<_i139.Comment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i139.Comment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i139.Comment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i148.Blocking>) {
      return (data as List).map((e) => deserialize<_i148.Blocking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i148.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i148.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i150.Cat>) {
      return (data as List).map((e) => deserialize<_i150.Cat>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i150.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i150.Cat>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i4.ModuleClass>) {
      return (data as List).map((e) => deserialize<_i4.ModuleClass>(e)).toList()
          as T;
    }
    if (t == Map<String, _i4.ModuleClass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i4.ModuleClass>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i4.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i4.ModuleClass>(((data as Map)['p'] as List)[0]),)
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
    if (t == List<_i193.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i193.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i193.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i193.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i193.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i193.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i193.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i193.SimpleData?>(e))
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
    if (t == List<_i212.ByteData>) {
      return (data as List).map((e) => deserialize<_i212.ByteData>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i212.ByteData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i212.ByteData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i212.ByteData?>) {
      return (data as List).map((e) => deserialize<_i212.ByteData?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i212.ByteData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i212.ByteData?>(e))
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
    if (t == _i213.CustomClassWithoutProtocolSerialization) {
      return _i213.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i213.CustomClassWithProtocolSerialization) {
      return _i213.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i213.CustomClassWithProtocolSerializationMethod) {
      return _i213.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i199.TestEnum>) {
      return (data as List).map((e) => deserialize<_i199.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i199.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i199.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i199.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i199.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i201.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i201.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i202.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i202.TestEnumEnhancedByName>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i193.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i193.SimpleData>(v),
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
    if (t == Map<String, _i212.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i212.ByteData>(v),
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
    if (t == Map<String, _i193.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i193.SimpleData?>(v),
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
    if (t == Map<String, _i212.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i212.ByteData?>(v),
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
    if (t == _i1.getType<_i213.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _i213.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i213.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _i213.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i213.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _i213.CustomClassWithProtocolSerializationMethod.fromJson(data)
              : null)
          as T;
    }
    if (t == List<List<_i193.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i193.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i193.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i193.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i193.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i193.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i193.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i193.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i193.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i193.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i193.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i193.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i193.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i193.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i193.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i193.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i193.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i193.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i193.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i193.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i193.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i193.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i115.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i115.SealedParent>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<_i181.Article>) {
      return (data as List).map((e) => deserialize<_i181.Article>(e)).toList()
          as T;
    }
    if (t == List<_i187.ServerOnlyClass>) {
      return (data as List)
              .map((e) => deserialize<_i187.ServerOnlyClass>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i187.ServerOnlyClass>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i187.ServerOnlyClass>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _i187.ServerOnlyClass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i187.ServerOnlyClass>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i187.ServerOnlyClass>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i187.ServerOnlyClass>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i203.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i203.TestEnumStringified>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i203.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i203.TestEnumStringified>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i203.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == List<(_i203.TestEnumStringified,)>) {
      return (data as List)
              .map((e) => deserialize<(_i203.TestEnumStringified,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)>()) {
      return (
            deserialize<_i203.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<(_i203.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i203.TestEnumStringified,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)>()) {
      return (
            deserialize<_i203.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i154.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i154.Nullability>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i203.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == List<({_i203.TestEnumStringified value})>) {
      return (data as List)
              .map((e) => deserialize<({_i203.TestEnumStringified value})>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i203.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<({_i203.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i203.TestEnumStringified value})>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i203.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i4.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i4.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i154.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i154.Nullability>(
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
    if (t == _i1.getType<List<_i199.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i199.TestEnum>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i204.Types>) {
      return (data as List).map((e) => deserialize<_i204.Types>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i204.Types>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i204.Types>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Map<String, _i204.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _i204.Types>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i204.Types>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_i204.Types>(v)),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<String, _i204.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _i204.Types>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i204.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_i204.Types>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i204.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i204.Types>>(e))
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
    if (t == List<(_i199.TestEnum,)>) {
      return (data as List)
              .map((e) => deserialize<(_i199.TestEnum,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i199.TestEnum,)>()) {
      return (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<List<(_i199.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i199.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i199.TestEnum,)>()) {
      return (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == Map<_i212.ByteData, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i212.ByteData>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i212.ByteData, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i212.ByteData>(e['k']),
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
    if (t == Map<_i199.TestEnum, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i199.TestEnum>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i199.TestEnum, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i199.TestEnum>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i203.TestEnumStringified, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i203.TestEnumStringified>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i203.TestEnumStringified, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i203.TestEnumStringified>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i204.Types, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i204.Types>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<_i204.Types, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i204.Types>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<Map<_i204.Types, String>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<Map<_i204.Types, String>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<Map<_i204.Types, String>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<Map<_i204.Types, String>>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<List<_i204.Types>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<List<_i204.Types>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<List<_i204.Types>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<List<_i204.Types>>(e['k']),
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
    if (t == _i1.getType<Map<String, _i212.ByteData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i212.ByteData>(v),
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
    if (t == Map<String, _i199.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i199.TestEnum>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i199.TestEnum>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i199.TestEnum>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, _i203.TestEnumStringified>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i203.TestEnumStringified>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i203.TestEnumStringified>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i203.TestEnumStringified>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i204.Types>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i204.Types>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, Map<String, _i204.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<String, _i204.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<String, _i204.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<String, _i204.Types>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, List<_i204.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<_i204.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, List<_i204.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<_i204.Types>>(v),
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
    if (t == _i1.getType<(_i212.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i212.ByteData>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i199.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i193.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i193.SimpleData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i193.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i193.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<(_i193.SimpleData, {_i193.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i193.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i193.SimpleData>(
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
                (List<(_i193.SimpleData,)>,), {
                (_i193.SimpleData, Map<String, _i193.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i193.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (_i193.SimpleData, Map<String, _i193.SimpleData>)
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
    if (t == Set<_i212.ByteData>) {
      return (data as List).map((e) => deserialize<_i212.ByteData>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i212.ByteData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i212.ByteData>(e))
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
    if (t == Set<_i199.TestEnum>) {
      return (data as List).map((e) => deserialize<_i199.TestEnum>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i199.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i199.TestEnum>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_i203.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i203.TestEnumStringified>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i203.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i203.TestEnumStringified>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_i204.Types>) {
      return (data as List).map((e) => deserialize<_i204.Types>(e)).toSet()
          as T;
    }
    if (t == _i1.getType<Set<_i204.Types>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i204.Types>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<Map<String, _i204.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _i204.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<Map<String, _i204.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _i204.Types>>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<List<_i204.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_i204.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<Set<List<_i204.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i204.Types>>(e))
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
    if (t == List<_i214.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i214.SimpleData>(e))
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
    if (t == List<_i212.ByteData>) {
      return (data as List).map((e) => deserialize<_i212.ByteData>(e)).toList()
          as T;
    }
    if (t == List<_i212.ByteData?>) {
      return (data as List).map((e) => deserialize<_i212.ByteData?>(e)).toList()
          as T;
    }
    if (t == List<_i214.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i214.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i214.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i214.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<List<_i214.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i214.SimpleData?>(e))
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
    if (t == Map<_i215.TestEnum, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i215.TestEnum>(e['k']),
                deserialize<int>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == Map<String, _i215.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i215.TestEnum>(v),
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
    if (t == Map<String, _i212.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i212.ByteData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i212.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i212.ByteData?>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i214.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i214.SimpleData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i214.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i214.SimpleData?>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, _i214.SimpleData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i214.SimpleData>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<Map<String, _i214.SimpleData?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i214.SimpleData?>(v),
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
    if (t == List<_i3.UserInfo>) {
      return (data as List).map((e) => deserialize<_i3.UserInfo>(e)).toList()
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == Set<_i214.SimpleData>) {
      return (data as List).map((e) => deserialize<_i214.SimpleData>(e)).toSet()
          as T;
    }
    if (t == List<Set<_i214.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Set<_i214.SimpleData>>(e))
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
    if (t == _i1.getType<(String, _i216.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_i216.PolymorphicParent>(data['p'][1]),
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
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i214.SimpleData>(data['p'][1]),
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
    if (t == _i1.getType<({_i214.SimpleData data, int number})>()) {
      return (
            data: deserialize<_i214.SimpleData>(
              ((data as Map)['n'] as Map)['data'],
            ),
            number: deserialize<int>(data['n']['number']),
          )
          as T;
    }
    if (t == _i1.getType<({_i214.SimpleData data, int number})?>()) {
      return (data == null)
          ? null as T
          : (
                  data: deserialize<_i214.SimpleData>(
                    ((data as Map)['n'] as Map)['data'],
                  ),
                  number: deserialize<int>(data['n']['number']),
                )
                as T;
    }
    if (t == _i1.getType<({_i214.SimpleData? data, int? number})>()) {
      return (
            data: ((data as Map)['n'] as Map)['data'] == null
                ? null
                : deserialize<_i214.SimpleData>(data['n']['data']),
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
    if (t == _i1.getType<(int, {_i214.SimpleData data})>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            data: deserialize<_i214.SimpleData>(data['n']['data']),
          )
          as T;
    }
    if (t == _i1.getType<(int, {_i214.SimpleData data})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  data: deserialize<_i214.SimpleData>(data['n']['data']),
                )
                as T;
    }
    if (t == List<(int, _i214.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i214.SimpleData)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == List<(int, _i214.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i214.SimpleData)?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i214.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Set<(int, _i214.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i214.SimpleData)>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Set<(int, _i214.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i214.SimpleData)?>(e))
              .toSet()
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i214.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<Set<(int, _i214.SimpleData)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(int, _i214.SimpleData)>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i214.SimpleData)>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i214.SimpleData)>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i214.SimpleData)?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i214.SimpleData)?>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<(int, _i214.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i214.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Map<(String, int), (int, _i214.SimpleData)>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(String, int)>(e['k']),
                deserialize<(int, _i214.SimpleData)>(e['v']),
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
    if (t == _i1.getType<(int, _i214.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i214.SimpleData>(data['p'][1]),
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
    if (t == _i1.getType<({(_i214.SimpleData, double) namedSubRecord})>()) {
      return (
            namedSubRecord: deserialize<(_i214.SimpleData, double)>(
              ((data as Map)['n'] as Map)['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i214.SimpleData, double)>()) {
      return (
            deserialize<_i214.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<double>(data['p'][1]),
          )
          as T;
    }
    if (t == _i1.getType<({(_i214.SimpleData, double)? namedSubRecord})>()) {
      return (
            namedSubRecord:
                ((data as Map)['n'] as Map)['namedSubRecord'] == null
                ? null
                : deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
          )
          as T;
    }
    if (t == _i1.getType<(_i214.SimpleData, double)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i214.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  deserialize<double>(data['p'][1]),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i214.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<((int, String), {(_i214.SimpleData, double) namedSubRecord})>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i214.SimpleData, double) namedSubRecord,
                      })
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i214.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<((int, String), {(_i214.SimpleData, double) namedSubRecord})?>) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i214.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              List<
                ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i214.SimpleData, double) namedSubRecord,
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
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(int?, _i4.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i4.ProjectStreamingClass>(data['p'][1]),
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
    if (t == Set<_i212.ByteData>) {
      return (data as List).map((e) => deserialize<_i212.ByteData>(e)).toSet()
          as T;
    }
    if (t == Set<_i212.ByteData?>) {
      return (data as List).map((e) => deserialize<_i212.ByteData?>(e)).toSet()
          as T;
    }
    if (t == Set<_i214.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i214.SimpleData?>(e))
              .toSet()
          as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == Set<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toSet() as T;
    }
    if (t == List<_i217.Types>) {
      return (data as List).map((e) => deserialize<_i217.Types>(e)).toList()
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
                (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i214.SimpleData simpleData})
            >(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (Map<String, int>, {bool flag, _i214.SimpleData simpleData})
            >()) {
      return (
            deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
            flag: deserialize<bool>(data['n']['flag']),
            simpleData: deserialize<_i214.SimpleData>(data['n']['simpleData']),
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
                (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (Map<String, int>, {bool flag, _i214.SimpleData simpleData})
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
    if (t == _i1.getType<(_i4.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i4.ModuleClass>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i203.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)>()) {
      return (
            deserialize<_i203.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<(_i203.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i203.TestEnumStringified,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)>()) {
      return (
            deserialize<_i203.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i203.TestEnumStringified,)>()) {
      return (
            deserialize<_i203.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _i1.getType<(_i154.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i154.Nullability>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i203.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i203.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<({_i203.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i203.TestEnumStringified value})>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i203.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i203.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i203.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _i1.getType<({_i4.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i4.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<({_i154.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i154.Nullability>(
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
    if (t == _i1.getType<(_i199.TestEnum,)>()) {
      return (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<List<(_i199.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_i199.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(_i199.TestEnum,)>()) {
      return (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i199.TestEnum,)>()) {
      return (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i212.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i212.ByteData>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i199.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i199.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i193.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i193.SimpleData>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _i1.getType<({_i193.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i193.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1.getType<(_i193.SimpleData, {_i193.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i193.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i193.SimpleData>(
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
                (List<(_i193.SimpleData,)>,), {
                (_i193.SimpleData, Map<String, _i193.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i193.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (_i193.SimpleData, Map<String, _i193.SimpleData>)
                      >(data['n']['namedNestedRecord']),
                )
                as T;
    }
    if (t == _i1.getType<(List<(_i193.SimpleData,)>,)>()) {
      return (
            deserialize<List<(_i193.SimpleData,)>>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == List<(_i193.SimpleData,)>) {
      return (data as List)
              .map((e) => deserialize<(_i193.SimpleData,)>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<(_i193.SimpleData,)>()) {
      return (deserialize<_i193.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i193.SimpleData,)>()) {
      return (deserialize<_i193.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i193.SimpleData, Map<String, _i193.SimpleData>)>()) {
      return (
            deserialize<_i193.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<Map<String, _i193.SimpleData>>(data['p'][1]),
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
    if (t == _i213.CustomClass) {
      return _i213.CustomClass.fromJson(data) as T;
    }
    if (t == _i213.CustomClass2) {
      return _i213.CustomClass2.fromJson(data) as T;
    }
    if (t == _i213.ProtocolCustomClass) {
      return _i213.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i213.ExternalCustomClass) {
      return _i213.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i213.FreezedCustomClass) {
      return _i213.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i213.CustomClass?>()) {
      return (data != null ? _i213.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i213.CustomClass2?>()) {
      return (data != null ? _i213.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i213.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _i213.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i213.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _i213.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i213.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _i213.CustomClassWithProtocolSerializationMethod.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i213.ProtocolCustomClass?>()) {
      return (data != null ? _i213.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i213.ExternalCustomClass?>()) {
      return (data != null ? _i213.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i213.FreezedCustomClass?>()) {
      return (data != null ? _i213.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i214.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i214.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _i1.getType<(String, _i216.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_i216.PolymorphicParent>(data['p'][1]),
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
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _i1
            .getType<
              List<
                ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i214.SimpleData, double) namedSubRecord,
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
              ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i214.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _i1.getType<(int?, _i4.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_i4.ProjectStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _i1
            .getType<
              (
                String,
                (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i214.SimpleData simpleData})
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
                (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (Map<String, int>, {bool flag, _i214.SimpleData simpleData})
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
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i213.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i213.CustomClass => 'CustomClass',
      _i213.CustomClass2 => 'CustomClass2',
      _i213.CustomClassWithoutProtocolSerialization =>
        'CustomClassWithoutProtocolSerialization',
      _i213.CustomClassWithProtocolSerialization =>
        'CustomClassWithProtocolSerialization',
      _i213.CustomClassWithProtocolSerializationMethod =>
        'CustomClassWithProtocolSerializationMethod',
      _i213.ProtocolCustomClass => 'ProtocolCustomClass',
      _i213.ExternalCustomClass => 'ExternalCustomClass',
      _i213.FreezedCustomClass => 'FreezedCustomClass',
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
      _i80.TestGeneratedCallHelloModel => 'TestGeneratedCallHelloModel',
      _i81.ImmutableChildObject => 'ImmutableChildObject',
      _i82.ImmutableChildObjectWithNoAdditionalFields =>
        'ImmutableChildObjectWithNoAdditionalFields',
      _i83.ImmutableObject => 'ImmutableObject',
      _i84.ImmutableObjectWithImmutableObject =>
        'ImmutableObjectWithImmutableObject',
      _i85.ImmutableObjectWithList => 'ImmutableObjectWithList',
      _i86.ImmutableObjectWithMap => 'ImmutableObjectWithMap',
      _i87.ImmutableObjectWithMultipleFields =>
        'ImmutableObjectWithMultipleFields',
      _i88.ImmutableObjectWithNoFields => 'ImmutableObjectWithNoFields',
      _i89.ImmutableObjectWithRecord => 'ImmutableObjectWithRecord',
      _i90.ImmutableObjectWithTable => 'ImmutableObjectWithTable',
      _i91.ImmutableObjectWithTwentyFields => 'ImmutableObjectWithTwentyFields',
      _i92.ChildClass => 'ChildClass',
      _i93.ServerOnlyChildClass => 'ServerOnlyChildClass',
      _i94.ChildWithDefault => 'ChildWithDefault',
      _i95.ChildWithInheritedId => 'ChildWithInheritedId',
      _i96.ChildClassWithoutId => 'ChildClassWithoutId',
      _i97.ServerOnlyChildClassWithoutId => 'ServerOnlyChildClassWithoutId',
      _i98.ParentClass => 'ParentClass',
      _i99.GrandparentClass => 'GrandparentClass',
      _i100.ParentClassWithoutId => 'ParentClassWithoutId',
      _i101.GrandparentClassWithId => 'GrandparentClassWithId',
      _i102.ChildEntity => 'ChildEntity',
      _i103.BaseEntity => 'BaseEntity',
      _i104.ParentEntity => 'ParentEntity',
      _i105.NonServerOnlyParentClass => 'NonServerOnlyParentClass',
      _i106.ParentWithChangedId => 'ParentWithChangedId',
      _i107.ParentWithDefault => 'ParentWithDefault',
      _i108.PolymorphicGrandChild => 'PolymorphicGrandChild',
      _i109.PolymorphicChild => 'PolymorphicChild',
      _i110.PolymorphicChildContainer => 'PolymorphicChildContainer',
      _i111.ModulePolymorphicChildContainer =>
        'ModulePolymorphicChildContainer',
      _i112.SimilarButNotParent => 'SimilarButNotParent',
      _i113.PolymorphicParent => 'PolymorphicParent',
      _i114.UnrelatedToPolymorphism => 'UnrelatedToPolymorphism',
      _i115.SealedGrandChild => 'SealedGrandChild',
      _i115.SealedChild => 'SealedChild',
      _i115.SealedOtherChild => 'SealedOtherChild',
      _i116.CityWithLongTableName => 'CityWithLongTableName',
      _i117.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i118.PersonWithLongTableName => 'PersonWithLongTableName',
      _i119.MaxFieldName => 'MaxFieldName',
      _i120.LongImplicitIdField => 'LongImplicitIdField',
      _i121.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i122.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i123.UserNote => 'UserNote',
      _i124.UserNoteCollection => 'UserNoteCollection',
      _i125.UserNoteCollectionWithALongName =>
        'UserNoteCollectionWithALongName',
      _i126.UserNoteWithALongName => 'UserNoteWithALongName',
      _i127.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i128.City => 'City',
      _i129.Organization => 'Organization',
      _i130.Person => 'Person',
      _i131.Course => 'Course',
      _i132.Enrollment => 'Enrollment',
      _i133.Student => 'Student',
      _i134.ObjectUser => 'ObjectUser',
      _i135.ParentUser => 'ParentUser',
      _i136.Arena => 'Arena',
      _i137.Player => 'Player',
      _i138.Team => 'Team',
      _i139.Comment => 'Comment',
      _i140.Customer => 'Customer',
      _i141.Book => 'Book',
      _i142.Chapter => 'Chapter',
      _i143.Order => 'Order',
      _i144.Address => 'Address',
      _i145.Citizen => 'Citizen',
      _i146.Company => 'Company',
      _i147.Town => 'Town',
      _i148.Blocking => 'Blocking',
      _i149.Member => 'Member',
      _i150.Cat => 'Cat',
      _i151.Post => 'Post',
      _i152.ModuleDatatype => 'ModuleDatatype',
      _i153.MyFeatureModel => 'MyFeatureModel',
      _i154.Nullability => 'Nullability',
      _i155.ObjectFieldPersist => 'ObjectFieldPersist',
      _i156.ObjectFieldScopes => 'ObjectFieldScopes',
      _i157.ObjectWithBit => 'ObjectWithBit',
      _i158.ObjectWithByteData => 'ObjectWithByteData',
      _i159.ObjectWithCustomClass => 'ObjectWithCustomClass',
      _i160.ObjectWithDuration => 'ObjectWithDuration',
      _i161.ObjectWithEnum => 'ObjectWithEnum',
      _i162.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i163.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i164.ObjectWithIndex => 'ObjectWithIndex',
      _i165.ObjectWithMaps => 'ObjectWithMaps',
      _i166.ObjectWithNullableCustomClass => 'ObjectWithNullableCustomClass',
      _i167.ObjectWithObject => 'ObjectWithObject',
      _i168.ObjectWithParent => 'ObjectWithParent',
      _i169.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i170.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i171.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i172.ObjectWithUuid => 'ObjectWithUuid',
      _i173.ObjectWithVector => 'ObjectWithVector',
      _i174.Record => 'Record',
      _i175.RelatedUniqueData => 'RelatedUniqueData',
      _i176.ExceptionWithRequiredField => 'ExceptionWithRequiredField',
      _i177.ModelWithRequiredField => 'ModelWithRequiredField',
      _i178.ScopeNoneFields => 'ScopeNoneFields',
      _i179.ScopeServerOnlyFieldChild => 'ScopeServerOnlyFieldChild',
      _i180.ScopeServerOnlyField => 'ScopeServerOnlyField',
      _i181.Article => 'Article',
      _i182.ArticleList => 'ArticleList',
      _i183.DefaultServerOnlyClass => 'DefaultServerOnlyClass',
      _i184.DefaultServerOnlyEnum => 'DefaultServerOnlyEnum',
      _i185.NotServerOnlyClass => 'NotServerOnlyClass',
      _i186.NotServerOnlyEnum => 'NotServerOnlyEnum',
      _i187.ServerOnlyClass => 'ServerOnlyClass',
      _i188.ServerOnlyEnum => 'ServerOnlyEnum',
      _i189.ServerOnlyClassField => 'ServerOnlyClassField',
      _i190.ServerOnlyDefault => 'ServerOnlyDefault',
      _i191.SessionAuthInfo => 'SessionAuthInfo',
      _i192.SharedModelSubclass => 'SharedModelSubclass',
      _i193.SimpleData => 'SimpleData',
      _i194.SimpleDataList => 'SimpleDataList',
      _i195.SimpleDataMap => 'SimpleDataMap',
      _i196.SimpleDataObject => 'SimpleDataObject',
      _i197.SimpleDateTime => 'SimpleDateTime',
      _i198.ModelInSubfolder => 'ModelInSubfolder',
      _i199.TestEnum => 'TestEnum',
      _i200.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i201.TestEnumEnhanced => 'TestEnumEnhanced',
      _i202.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i203.TestEnumStringified => 'TestEnumStringified',
      _i204.Types => 'Types',
      _i205.TypesList => 'TypesList',
      _i206.TypesMap => 'TypesMap',
      _i207.TypesRecord => 'TypesRecord',
      _i208.TypesSet => 'TypesSet',
      _i209.TypesSetRequired => 'TypesSetRequired',
      _i210.UniqueData => 'UniqueData',
      _i211.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
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
      case _i213.CustomClass():
        return 'CustomClass';
      case _i213.CustomClass2():
        return 'CustomClass2';
      case _i213.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _i213.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _i213.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _i213.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _i213.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _i213.FreezedCustomClass():
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
      case _i80.TestGeneratedCallHelloModel():
        return 'TestGeneratedCallHelloModel';
      case _i81.ImmutableChildObject():
        return 'ImmutableChildObject';
      case _i82.ImmutableChildObjectWithNoAdditionalFields():
        return 'ImmutableChildObjectWithNoAdditionalFields';
      case _i83.ImmutableObject():
        return 'ImmutableObject';
      case _i84.ImmutableObjectWithImmutableObject():
        return 'ImmutableObjectWithImmutableObject';
      case _i85.ImmutableObjectWithList():
        return 'ImmutableObjectWithList';
      case _i86.ImmutableObjectWithMap():
        return 'ImmutableObjectWithMap';
      case _i87.ImmutableObjectWithMultipleFields():
        return 'ImmutableObjectWithMultipleFields';
      case _i88.ImmutableObjectWithNoFields():
        return 'ImmutableObjectWithNoFields';
      case _i89.ImmutableObjectWithRecord():
        return 'ImmutableObjectWithRecord';
      case _i90.ImmutableObjectWithTable():
        return 'ImmutableObjectWithTable';
      case _i91.ImmutableObjectWithTwentyFields():
        return 'ImmutableObjectWithTwentyFields';
      case _i92.ChildClass():
        return 'ChildClass';
      case _i93.ServerOnlyChildClass():
        return 'ServerOnlyChildClass';
      case _i94.ChildWithDefault():
        return 'ChildWithDefault';
      case _i95.ChildWithInheritedId():
        return 'ChildWithInheritedId';
      case _i96.ChildClassWithoutId():
        return 'ChildClassWithoutId';
      case _i97.ServerOnlyChildClassWithoutId():
        return 'ServerOnlyChildClassWithoutId';
      case _i98.ParentClass():
        return 'ParentClass';
      case _i99.GrandparentClass():
        return 'GrandparentClass';
      case _i100.ParentClassWithoutId():
        return 'ParentClassWithoutId';
      case _i101.GrandparentClassWithId():
        return 'GrandparentClassWithId';
      case _i102.ChildEntity():
        return 'ChildEntity';
      case _i103.BaseEntity():
        return 'BaseEntity';
      case _i104.ParentEntity():
        return 'ParentEntity';
      case _i105.NonServerOnlyParentClass():
        return 'NonServerOnlyParentClass';
      case _i106.ParentWithChangedId():
        return 'ParentWithChangedId';
      case _i107.ParentWithDefault():
        return 'ParentWithDefault';
      case _i108.PolymorphicGrandChild():
        return 'PolymorphicGrandChild';
      case _i109.PolymorphicChild():
        return 'PolymorphicChild';
      case _i110.PolymorphicChildContainer():
        return 'PolymorphicChildContainer';
      case _i111.ModulePolymorphicChildContainer():
        return 'ModulePolymorphicChildContainer';
      case _i112.SimilarButNotParent():
        return 'SimilarButNotParent';
      case _i113.PolymorphicParent():
        return 'PolymorphicParent';
      case _i114.UnrelatedToPolymorphism():
        return 'UnrelatedToPolymorphism';
      case _i115.SealedGrandChild():
        return 'SealedGrandChild';
      case _i115.SealedChild():
        return 'SealedChild';
      case _i115.SealedOtherChild():
        return 'SealedOtherChild';
      case _i116.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i117.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i118.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i119.MaxFieldName():
        return 'MaxFieldName';
      case _i120.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i121.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i122.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i123.UserNote():
        return 'UserNote';
      case _i124.UserNoteCollection():
        return 'UserNoteCollection';
      case _i125.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i126.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i127.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i128.City():
        return 'City';
      case _i129.Organization():
        return 'Organization';
      case _i130.Person():
        return 'Person';
      case _i131.Course():
        return 'Course';
      case _i132.Enrollment():
        return 'Enrollment';
      case _i133.Student():
        return 'Student';
      case _i134.ObjectUser():
        return 'ObjectUser';
      case _i135.ParentUser():
        return 'ParentUser';
      case _i136.Arena():
        return 'Arena';
      case _i137.Player():
        return 'Player';
      case _i138.Team():
        return 'Team';
      case _i139.Comment():
        return 'Comment';
      case _i140.Customer():
        return 'Customer';
      case _i141.Book():
        return 'Book';
      case _i142.Chapter():
        return 'Chapter';
      case _i143.Order():
        return 'Order';
      case _i144.Address():
        return 'Address';
      case _i145.Citizen():
        return 'Citizen';
      case _i146.Company():
        return 'Company';
      case _i147.Town():
        return 'Town';
      case _i148.Blocking():
        return 'Blocking';
      case _i149.Member():
        return 'Member';
      case _i150.Cat():
        return 'Cat';
      case _i151.Post():
        return 'Post';
      case _i152.ModuleDatatype():
        return 'ModuleDatatype';
      case _i153.MyFeatureModel():
        return 'MyFeatureModel';
      case _i154.Nullability():
        return 'Nullability';
      case _i155.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i156.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i157.ObjectWithBit():
        return 'ObjectWithBit';
      case _i158.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i159.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _i160.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i161.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i162.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i163.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i164.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i165.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i166.ObjectWithNullableCustomClass():
        return 'ObjectWithNullableCustomClass';
      case _i167.ObjectWithObject():
        return 'ObjectWithObject';
      case _i168.ObjectWithParent():
        return 'ObjectWithParent';
      case _i169.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i170.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i171.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i172.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i173.ObjectWithVector():
        return 'ObjectWithVector';
      case _i174.Record():
        return 'Record';
      case _i175.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i176.ExceptionWithRequiredField():
        return 'ExceptionWithRequiredField';
      case _i177.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i178.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _i179.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _i180.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _i181.Article():
        return 'Article';
      case _i182.ArticleList():
        return 'ArticleList';
      case _i183.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i184.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _i185.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _i186.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _i187.ServerOnlyClass():
        return 'ServerOnlyClass';
      case _i188.ServerOnlyEnum():
        return 'ServerOnlyEnum';
      case _i189.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _i190.ServerOnlyDefault():
        return 'ServerOnlyDefault';
      case _i191.SessionAuthInfo():
        return 'SessionAuthInfo';
      case _i192.SharedModelSubclass():
        return 'SharedModelSubclass';
      case _i193.SimpleData():
        return 'SimpleData';
      case _i194.SimpleDataList():
        return 'SimpleDataList';
      case _i195.SimpleDataMap():
        return 'SimpleDataMap';
      case _i196.SimpleDataObject():
        return 'SimpleDataObject';
      case _i197.SimpleDateTime():
        return 'SimpleDateTime';
      case _i198.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _i199.TestEnum():
        return 'TestEnum';
      case _i200.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i201.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i202.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i203.TestEnumStringified():
        return 'TestEnumStringified';
      case _i204.Types():
        return 'Types';
      case _i205.TypesList():
        return 'TypesList';
      case _i206.TypesMap():
        return 'TypesMap';
      case _i207.TypesRecord():
        return 'TypesRecord';
      case _i208.TypesSet():
        return 'TypesSet';
      case _i209.TypesSetRequired():
        return 'TypesSetRequired';
      case _i210.UniqueData():
        return 'UniqueData';
      case _i211.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i214.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i3.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i214.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i214.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i214.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i214.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (String, _i216.PolymorphicParent)) {
      return '(String,PolymorphicParent)';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data
        is List<
          ((int, String), {(_i214.SimpleData, double) namedSubRecord})?
        >?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (int?, _i4.ProjectStreamingClass?)) {
      return '(int?,serverpod_test_module.ProjectStreamingClass?)';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
        )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
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
      return deserialize<_i213.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i213.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i213.CustomClassWithoutProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i213.CustomClassWithProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i213.CustomClassWithProtocolSerializationMethod>(
        data['data'],
      );
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i213.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i213.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i213.FreezedCustomClass>(data['data']);
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
    if (dataClassName == 'TestGeneratedCallHelloModel') {
      return deserialize<_i80.TestGeneratedCallHelloModel>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObject') {
      return deserialize<_i81.ImmutableChildObject>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObjectWithNoAdditionalFields') {
      return deserialize<_i82.ImmutableChildObjectWithNoAdditionalFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObject') {
      return deserialize<_i83.ImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithImmutableObject') {
      return deserialize<_i84.ImmutableObjectWithImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithList') {
      return deserialize<_i85.ImmutableObjectWithList>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMap') {
      return deserialize<_i86.ImmutableObjectWithMap>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMultipleFields') {
      return deserialize<_i87.ImmutableObjectWithMultipleFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithNoFields') {
      return deserialize<_i88.ImmutableObjectWithNoFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithRecord') {
      return deserialize<_i89.ImmutableObjectWithRecord>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTable') {
      return deserialize<_i90.ImmutableObjectWithTable>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTwentyFields') {
      return deserialize<_i91.ImmutableObjectWithTwentyFields>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i92.ChildClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClass') {
      return deserialize<_i93.ServerOnlyChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i94.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ChildWithInheritedId') {
      return deserialize<_i95.ChildWithInheritedId>(data['data']);
    }
    if (dataClassName == 'ChildClassWithoutId') {
      return deserialize<_i96.ChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClassWithoutId') {
      return deserialize<_i97.ServerOnlyChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i98.ParentClass>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i99.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClassWithoutId') {
      return deserialize<_i100.ParentClassWithoutId>(data['data']);
    }
    if (dataClassName == 'GrandparentClassWithId') {
      return deserialize<_i101.GrandparentClassWithId>(data['data']);
    }
    if (dataClassName == 'ChildEntity') {
      return deserialize<_i102.ChildEntity>(data['data']);
    }
    if (dataClassName == 'BaseEntity') {
      return deserialize<_i103.BaseEntity>(data['data']);
    }
    if (dataClassName == 'ParentEntity') {
      return deserialize<_i104.ParentEntity>(data['data']);
    }
    if (dataClassName == 'NonServerOnlyParentClass') {
      return deserialize<_i105.NonServerOnlyParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithChangedId') {
      return deserialize<_i106.ParentWithChangedId>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i107.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'PolymorphicGrandChild') {
      return deserialize<_i108.PolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChild') {
      return deserialize<_i109.PolymorphicChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChildContainer') {
      return deserialize<_i110.PolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChildContainer') {
      return deserialize<_i111.ModulePolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'SimilarButNotParent') {
      return deserialize<_i112.SimilarButNotParent>(data['data']);
    }
    if (dataClassName == 'PolymorphicParent') {
      return deserialize<_i113.PolymorphicParent>(data['data']);
    }
    if (dataClassName == 'UnrelatedToPolymorphism') {
      return deserialize<_i114.UnrelatedToPolymorphism>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i115.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i115.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i115.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i116.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i117.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i118.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i119.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i120.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i121.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i122.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i123.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i124.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i125.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i126.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i127.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i128.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i129.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i130.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i131.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i132.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i133.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i134.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i135.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i136.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i137.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i138.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i139.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i140.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i141.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i142.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i143.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i144.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i145.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i146.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i147.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i148.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i149.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i150.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i151.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i152.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i153.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i154.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i155.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i156.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i157.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i158.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i159.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i160.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i161.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i162.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i163.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i164.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i165.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithNullableCustomClass') {
      return deserialize<_i166.ObjectWithNullableCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i167.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i168.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i169.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i170.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i171.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i172.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i173.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_i174.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i175.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ExceptionWithRequiredField') {
      return deserialize<_i176.ExceptionWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i177.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i178.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i179.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i180.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'Article') {
      return deserialize<_i181.Article>(data['data']);
    }
    if (dataClassName == 'ArticleList') {
      return deserialize<_i182.ArticleList>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i183.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i184.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i185.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i186.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClass') {
      return deserialize<_i187.ServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyEnum') {
      return deserialize<_i188.ServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i189.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'ServerOnlyDefault') {
      return deserialize<_i190.ServerOnlyDefault>(data['data']);
    }
    if (dataClassName == 'SessionAuthInfo') {
      return deserialize<_i191.SessionAuthInfo>(data['data']);
    }
    if (dataClassName == 'SharedModelSubclass') {
      return deserialize<_i192.SharedModelSubclass>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i193.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i194.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i195.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i196.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i197.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_i198.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i199.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i200.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i201.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i202.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i203.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i204.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i205.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i206.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_i207.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i208.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_i209.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i210.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i211.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i214.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i3.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i214.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i214.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i214.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i214.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(String,PolymorphicParent)') {
      return deserialize<(String, _i216.PolymorphicParent)>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
        List<((int, String), {(_i214.SimpleData, double) namedSubRecord})?>?
      >(data['data']);
    }
    if (dataClassName ==
        '(int?,serverpod_test_module.ProjectStreamingClass?)') {
      return deserialize<(int?, _i4.ProjectStreamingClass?)>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i214.SimpleData simpleData}))
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
        (String, (Map<String, int>, {bool flag, _i214.SimpleData simpleData}))?
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>?') {
      return deserialize<List<(String, int)>?>(data['data']);
    }
    return super.deserializeByClassName(data);
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
      case _i90.ImmutableObjectWithTable:
        return _i90.ImmutableObjectWithTable.t;
      case _i95.ChildWithInheritedId:
        return _i95.ChildWithInheritedId.t;
      case _i96.ChildClassWithoutId:
        return _i96.ChildClassWithoutId.t;
      case _i98.ParentClass:
        return _i98.ParentClass.t;
      case _i102.ChildEntity:
        return _i102.ChildEntity.t;
      case _i104.ParentEntity:
        return _i104.ParentEntity.t;
      case _i116.CityWithLongTableName:
        return _i116.CityWithLongTableName.t;
      case _i117.OrganizationWithLongTableName:
        return _i117.OrganizationWithLongTableName.t;
      case _i118.PersonWithLongTableName:
        return _i118.PersonWithLongTableName.t;
      case _i119.MaxFieldName:
        return _i119.MaxFieldName.t;
      case _i120.LongImplicitIdField:
        return _i120.LongImplicitIdField.t;
      case _i121.LongImplicitIdFieldCollection:
        return _i121.LongImplicitIdFieldCollection.t;
      case _i122.RelationToMultipleMaxFieldName:
        return _i122.RelationToMultipleMaxFieldName.t;
      case _i123.UserNote:
        return _i123.UserNote.t;
      case _i124.UserNoteCollection:
        return _i124.UserNoteCollection.t;
      case _i125.UserNoteCollectionWithALongName:
        return _i125.UserNoteCollectionWithALongName.t;
      case _i126.UserNoteWithALongName:
        return _i126.UserNoteWithALongName.t;
      case _i127.MultipleMaxFieldName:
        return _i127.MultipleMaxFieldName.t;
      case _i128.City:
        return _i128.City.t;
      case _i129.Organization:
        return _i129.Organization.t;
      case _i130.Person:
        return _i130.Person.t;
      case _i131.Course:
        return _i131.Course.t;
      case _i132.Enrollment:
        return _i132.Enrollment.t;
      case _i133.Student:
        return _i133.Student.t;
      case _i134.ObjectUser:
        return _i134.ObjectUser.t;
      case _i135.ParentUser:
        return _i135.ParentUser.t;
      case _i136.Arena:
        return _i136.Arena.t;
      case _i137.Player:
        return _i137.Player.t;
      case _i138.Team:
        return _i138.Team.t;
      case _i139.Comment:
        return _i139.Comment.t;
      case _i140.Customer:
        return _i140.Customer.t;
      case _i141.Book:
        return _i141.Book.t;
      case _i142.Chapter:
        return _i142.Chapter.t;
      case _i143.Order:
        return _i143.Order.t;
      case _i144.Address:
        return _i144.Address.t;
      case _i145.Citizen:
        return _i145.Citizen.t;
      case _i146.Company:
        return _i146.Company.t;
      case _i147.Town:
        return _i147.Town.t;
      case _i148.Blocking:
        return _i148.Blocking.t;
      case _i149.Member:
        return _i149.Member.t;
      case _i150.Cat:
        return _i150.Cat.t;
      case _i151.Post:
        return _i151.Post.t;
      case _i155.ObjectFieldPersist:
        return _i155.ObjectFieldPersist.t;
      case _i156.ObjectFieldScopes:
        return _i156.ObjectFieldScopes.t;
      case _i157.ObjectWithBit:
        return _i157.ObjectWithBit.t;
      case _i158.ObjectWithByteData:
        return _i158.ObjectWithByteData.t;
      case _i160.ObjectWithDuration:
        return _i160.ObjectWithDuration.t;
      case _i161.ObjectWithEnum:
        return _i161.ObjectWithEnum.t;
      case _i162.ObjectWithEnumEnhanced:
        return _i162.ObjectWithEnumEnhanced.t;
      case _i163.ObjectWithHalfVector:
        return _i163.ObjectWithHalfVector.t;
      case _i164.ObjectWithIndex:
        return _i164.ObjectWithIndex.t;
      case _i167.ObjectWithObject:
        return _i167.ObjectWithObject.t;
      case _i168.ObjectWithParent:
        return _i168.ObjectWithParent.t;
      case _i170.ObjectWithSelfParent:
        return _i170.ObjectWithSelfParent.t;
      case _i171.ObjectWithSparseVector:
        return _i171.ObjectWithSparseVector.t;
      case _i172.ObjectWithUuid:
        return _i172.ObjectWithUuid.t;
      case _i173.ObjectWithVector:
        return _i173.ObjectWithVector.t;
      case _i175.RelatedUniqueData:
        return _i175.RelatedUniqueData.t;
      case _i177.ModelWithRequiredField:
        return _i177.ModelWithRequiredField.t;
      case _i178.ScopeNoneFields:
        return _i178.ScopeNoneFields.t;
      case _i193.SimpleData:
        return _i193.SimpleData.t;
      case _i197.SimpleDateTime:
        return _i197.SimpleDateTime.t;
      case _i204.Types:
        return _i204.Types.t;
      case _i210.UniqueData:
        return _i210.UniqueData.t;
      case _i211.UniqueDataWithNonPersist:
        return _i211.UniqueDataWithNonPersist.t;
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
    if (record is (String, _i216.PolymorphicParent)) {
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
    if (record is (int, _i214.SimpleData)) {
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
    if (record is ({_i214.SimpleData data, int number})) {
      return {
        "n": {
          "data": record.data,
          "number": record.number,
        },
      };
    }
    if (record is ({_i214.SimpleData? data, int? number})) {
      return {
        "n": {
          "data": record.data,
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
    if (record is (int, {_i214.SimpleData data})) {
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
    if (record is ({(_i214.SimpleData, double) namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (_i214.SimpleData, double)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2,
        ],
      };
    }
    if (record is ({(_i214.SimpleData, double)? namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record
        is ((int, String), {(_i214.SimpleData, double) namedSubRecord})) {
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
          (Map<String, int>, {bool flag, _i214.SimpleData simpleData}),
        )) {
      return {
        "p": [
          record.$1,
          mapRecordToJson(record.$2),
        ],
      };
    }
    if (record
        is (Map<String, int>, {bool flag, _i214.SimpleData simpleData})) {
      return {
        "p": [
          record.$1.toJson(),
        ],
        "n": {
          "flag": record.flag,
          "simpleData": record.simpleData,
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
    if (record is (_i203.TestEnumStringified,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_i154.Nullability,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i203.TestEnumStringified value})) {
      return {
        "n": {
          "value": record.value,
        },
      };
    }
    if (record is ({_i4.ModuleClass value})) {
      return {
        "n": {
          "value": record.value,
        },
      };
    }
    if (record is ({_i154.Nullability value})) {
      return {
        "n": {
          "value": record.value,
        },
      };
    }
    if (record is (String, {Uri? optionalUri})) {
      return {
        "p": [
          record.$1,
        ],
        "n": {
          "optionalUri": record.optionalUri,
        },
      };
    }
    if (record is (_i199.TestEnum,)) {
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
    if (record is (_i212.ByteData,)) {
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
    if (record is (_i193.SimpleData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i193.SimpleData namedModel})) {
      return {
        "n": {
          "namedModel": record.namedModel,
        },
      };
    }
    if (record is (_i193.SimpleData, {_i193.SimpleData namedModel})) {
      return {
        "p": [
          record.$1.toJson(),
        ],
        "n": {
          "namedModel": record.namedModel,
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
          (List<(_i193.SimpleData,)>,), {
          (_i193.SimpleData, Map<String, _i193.SimpleData>) namedNestedRecord,
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
    if (record is (List<(_i193.SimpleData,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (_i193.SimpleData, Map<String, _i193.SimpleData>)) {
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
