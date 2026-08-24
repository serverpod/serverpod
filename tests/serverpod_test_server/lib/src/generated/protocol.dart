/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters
// ignore_for_file: invalid_use_of_internal_member
// ignore_for_file: dead_code, unnecessary_type_check

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:typed_data' as _idt;
import 'package:serverpod/protocol.dart' as _isp;
import 'package:serverpod/serverpod.dart' as _is;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i1n3uhu0;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _iom2gwyu;
import 'package:serverpod_test_server/src/generated/inheritance/polymorphism/parent.dart'
    as _ieub4zqi;
import 'package:serverpod_test_server/src/generated/simple_data.dart'
    as _i685tvwm;
import 'package:serverpod_test_server/src/generated/test_enum.dart'
    as _izdri23a;
import 'package:serverpod_test_server/src/generated/types.dart' as _iuch3ck4;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _ilwf0zl1;
import 'package:serverpod_test_shared_module_server/serverpod_test_shared_module_server.dart'
    as _iyx9etqn;
import 'by_index_enum_with_name_value.dart' as _ihs9bjzx;
import 'by_name_enum_with_name_value.dart' as _iwdug2n0;
import 'changed_id_type/many_to_many/course.dart' as _ik6ri27s;
import 'changed_id_type/many_to_many/enrollment.dart' as _icdgc05t;
import 'changed_id_type/many_to_many/student.dart' as _ibrjea6w;
import 'changed_id_type/nested_one_to_many/arena.dart' as _isj7c5mo;
import 'changed_id_type/nested_one_to_many/player.dart' as _ivdpnfmj;
import 'changed_id_type/nested_one_to_many/team.dart' as _ivehlt2f;
import 'changed_id_type/one_to_many/comment.dart' as _i3jtpxta;
import 'changed_id_type/one_to_many/customer.dart' as _iimgofmw;
import 'changed_id_type/one_to_many/order.dart' as _iywnby31;
import 'changed_id_type/one_to_one/address.dart' as _ifwqt4rb;
import 'changed_id_type/one_to_one/citizen.dart' as _idhvg1zk;
import 'changed_id_type/one_to_one/company.dart' as _i5vwm04a;
import 'changed_id_type/one_to_one/town.dart' as _iu7osokh;
import 'changed_id_type/self.dart' as _ixc9sah8;
import 'changed_id_type/server_only.dart' as _irw3jmaq;
import 'defaults/bigint/bigint_default.dart' as _icrmubzc;
import 'defaults/bigint/bigint_default_mix.dart' as _i1xsun18;
import 'defaults/bigint/bigint_default_model.dart' as _i332rqur;
import 'defaults/bigint/bigint_default_persist.dart' as _ia4nw21o;
import 'defaults/boolean/bool_default.dart' as _ilirabmz;
import 'defaults/boolean/bool_default_mix.dart' as _iwhzartq;
import 'defaults/boolean/bool_default_model.dart' as _izvr7tnf;
import 'defaults/boolean/bool_default_persist.dart' as _i135uugo;
import 'defaults/datetime/datetime_default.dart' as _iro0mlkq;
import 'defaults/datetime/datetime_default_mix.dart' as _igjm2894;
import 'defaults/datetime/datetime_default_model.dart' as _ivkcoq83;
import 'defaults/datetime/datetime_default_persist.dart' as _iaqar0o9;
import 'defaults/double/double_default.dart' as _izu05ym4;
import 'defaults/double/double_default_mix.dart' as _iou6kksr;
import 'defaults/double/double_default_model.dart' as _i9xv7g6i;
import 'defaults/double/double_default_persist.dart' as _iynhhcdw;
import 'defaults/duration/duration_default.dart' as _ixvw8l6s;
import 'defaults/duration/duration_default_mix.dart' as _ialx1ytx;
import 'defaults/duration/duration_default_model.dart' as _i5aouk9m;
import 'defaults/duration/duration_default_persist.dart' as _ij5e1q2b;
import 'defaults/enum/enum_default.dart' as _ihqxpva2;
import 'defaults/enum/enum_default_mix.dart' as _iyezrrxn;
import 'defaults/enum/enum_default_model.dart' as _iw4wb1ju;
import 'defaults/enum/enum_default_persist.dart' as _i0p9yn0v;
import 'defaults/enum/enums/by_index_enum.dart' as _i4ekvn16;
import 'defaults/enum/enums/by_name_enum.dart' as _ihrgmscf;
import 'defaults/enum/enums/default_value_enum.dart' as _iirkfcfb;
import 'defaults/exception/default_exception.dart' as _iv40kyzq;
import 'defaults/integer/int_default.dart' as _i8t3u1nx;
import 'defaults/integer/int_default_mix.dart' as _iummzlp0;
import 'defaults/integer/int_default_model.dart' as _i4rypx08;
import 'defaults/integer/int_default_persist.dart' as _imhmhhwa;
import 'defaults/string/string_default.dart' as _i4d8z6ds;
import 'defaults/string/string_default_mix.dart' as _iu6k5fkj;
import 'defaults/string/string_default_model.dart' as _ihmqo6od;
import 'defaults/string/string_default_persist.dart' as _ih6giyf6;
import 'defaults/uri/uri_default.dart' as _i2y701qf;
import 'defaults/uri/uri_default_mix.dart' as _iib8h1yl;
import 'defaults/uri/uri_default_model.dart' as _i1to0y5o;
import 'defaults/uri/uri_default_persist.dart' as _isi15w9f;
import 'defaults/uuid/uuid_default.dart' as _ihsadwhl;
import 'defaults/uuid/uuid_default_mix.dart' as _ignwr848;
import 'defaults/uuid/uuid_default_model.dart' as _i15gwzho;
import 'defaults/uuid/uuid_default_persist.dart' as _i2v866bf;
import 'deferrable/deferrable_relation_initially_deferred.dart' as _io8dlrxh;
import 'deferrable/deferrable_relation_initially_immediate.dart' as _inmfeda2;
import 'deferrable/deferrable_relation_parent.dart' as _izxfibiy;
import 'empty_model/empty_model.dart' as _i9l9xrkt;
import 'empty_model/empty_model_relation_item.dart' as _ikufh0vd;
import 'empty_model/empty_model_with_table.dart' as _iw4y4x6s;
import 'empty_model/relation_empy_model.dart' as _iy7bezig;
import 'exception_with_data.dart' as _is77lrdb;
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _ikh95zxc;
import 'explicit_column_name/inheritance/non_table_parent_class.dart'
    as _i1y2idkw;
import 'explicit_column_name/modified_column_name.dart' as _i7hqkfn7;
import 'explicit_column_name/relations/one_to_many/department.dart'
    as _ix2lcsu0;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _ixlcmx78;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _iw4adtsk;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i83a3u3u;
import 'explicit_column_name/table_with_explicit_column_names.dart'
    as _iox92era;
import 'future_calls_generated_models/test_generated_call_bye_model.dart'
    as _ip57k4t4;
import 'future_calls_generated_models/test_generated_call_execute_with_trigger_model.dart'
    as _ilmnz413;
import 'future_calls_generated_models/test_generated_call_hello_model.dart'
    as _ifspsmem;
import 'future_calls_generated_models/test_generated_call_invoke_model.dart'
    as _i3yv7lzj;
import 'immutable/immutable_child_object.dart' as _isas41s9;
import 'immutable/immutable_child_object_with_no_additional_fields.dart'
    as _i8ali8rk;
import 'immutable/immutable_object.dart' as _ib4436rb;
import 'immutable/immutable_object_with_immutable_object.dart' as _i5o8gk0d;
import 'immutable/immutable_object_with_list.dart' as _ifcovr71;
import 'immutable/immutable_object_with_map.dart' as _i7chvx7t;
import 'immutable/immutable_object_with_multiple_fields.dart' as _ijpel12b;
import 'immutable/immutable_object_with_no_fields.dart' as _im6ib46o;
import 'immutable/immutable_object_with_record.dart' as _iz0jdatm;
import 'immutable/immutable_object_with_table.dart' as _ij73d01s;
import 'immutable/immutable_object_with_twenty_fields.dart' as _i6bj8wy3;
import 'inheritance/child_class.dart' as _ix35kamj;
import 'inheritance/child_server_only.dart' as _inmco1xt;
import 'inheritance/child_with_default.dart' as _ibdvdtnv;
import 'inheritance/child_with_inherited_id.dart' as _ieeasgju;
import 'inheritance/child_without_id.dart' as _i57yjwwl;
import 'inheritance/child_without_id_server_only.dart' as _ihtrmue0;
import 'inheritance/exception/base_app_exception.dart' as _iw7pve41;
import 'inheritance/exception/extended_app_exception.dart' as _i4ydso50;
import 'inheritance/exception/sealed_app_exception.dart' as _iaxkp5y4;
import 'inheritance/grandparent_class.dart' as _i5sz4l10;
import 'inheritance/grandparent_with_id.dart' as _iolet7jc;
import 'inheritance/list_relation_of_child/base_entity.dart' as _i9odpwsh;
import 'inheritance/list_relation_of_child/child_entity.dart' as _i2aipqpt;
import 'inheritance/list_relation_of_child/parent_entity.dart' as _ir6jlp3k;
import 'inheritance/parent_class.dart' as _io7upog0;
import 'inheritance/parent_non_server_only.dart' as _igefthms;
import 'inheritance/parent_with_changed_id.dart' as _iauswj59;
import 'inheritance/parent_with_default.dart' as _iitvxe69;
import 'inheritance/parent_without_id.dart' as _ijexcijb;
import 'inheritance/polymorphism/child.dart' as _i11uofdz;
import 'inheritance/polymorphism/container.dart' as _iqb6eppn;
import 'inheritance/polymorphism/container_module.dart' as _iw07om20;
import 'inheritance/polymorphism/grandchild.dart' as _ipndfib1;
import 'inheritance/polymorphism/other.dart' as _icfkf6u0;
import 'inheritance/polymorphism/parent.dart' as _i5oq3fsk;
import 'inheritance/polymorphism/unrelated.dart' as _ih2dgm3r;
import 'inheritance/sealed_parent.dart' as _ij7m744x;
import 'inheritance/sealed_parent_nullable_field.dart' as _iwv9x21d;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart'
    as _iycanyn2;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _ifbzwpkm;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _iy2gklrg;
import 'long_identifiers/max_field_name.dart' as _i37b4f1x;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _ilm8ux21;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i5zyye9l;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _irdava0x;
import 'long_identifiers/models_with_relations/user_note.dart' as _i14q426c;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i0cmztzz;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _ivgcl1bh;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i7zqea9a;
import 'long_identifiers/multiple_max_field_name.dart' as _ify1vf7h;
import 'models_with_list_relations/city.dart' as _i0i33txy;
import 'models_with_list_relations/organization.dart' as _iffzpgud;
import 'models_with_list_relations/person.dart' as _i9x7ls0c;
import 'models_with_relations/column_alias_collision/bleed_child.dart'
    as _iepu1h7u;
import 'models_with_relations/column_alias_collision/bleed_root.dart'
    as _ipkncx5k;
import 'models_with_relations/generated_relation_field/generated_relation_company.dart'
    as _ilvqc6dx;
import 'models_with_relations/generated_relation_field/generated_relation_employee.dart'
    as _i3ralext;
import 'models_with_relations/generated_relation_field/generated_relation_office.dart'
    as _isfv2yco;
import 'models_with_relations/many_to_many/course.dart' as _iy2buo88;
import 'models_with_relations/many_to_many/enrollment.dart' as _i8v11x6h;
import 'models_with_relations/many_to_many/student.dart' as _ig5mtn0e;
import 'models_with_relations/module/object_user.dart' as _ian3gu05;
import 'models_with_relations/module/parent_user.dart' as _i1h6ufx7;
import 'models_with_relations/nested_one_to_many/arena.dart' as _ikwieien;
import 'models_with_relations/nested_one_to_many/player.dart' as _ip8wmh4s;
import 'models_with_relations/nested_one_to_many/team.dart' as _ifa5hwxy;
import 'models_with_relations/one_to_many/comment.dart' as _ii7cxuye;
import 'models_with_relations/one_to_many/customer.dart' as _i1nwi4iv;
import 'models_with_relations/one_to_many/implicit/book.dart' as _if51mnnb;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _itdsc4u0;
import 'models_with_relations/one_to_many/order.dart' as _is5jy3ez;
import 'models_with_relations/one_to_one/address.dart' as _i6uupgbr;
import 'models_with_relations/one_to_one/citizen.dart' as _igeuyxnu;
import 'models_with_relations/one_to_one/company.dart' as _if6srpch;
import 'models_with_relations/one_to_one/town.dart' as _igjnmbwc;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _ic5jbe8i;
import 'models_with_relations/self_relation/many_to_many/member.dart'
    as _ijj92mp1;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _ib9keugy;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _iyh1zt5l;
import 'module_datatype.dart' as _ikm3lhvl;
import 'my_feature/models/my_feature_model.dart' as _i6x889hl;
import 'my_trigger_type.dart' as _i47v6vne;
import 'nullability.dart' as _il5sr7xc;
import 'nulls_distinct_data.dart' as _iz2gvrid;
import 'object_field_persist.dart' as _i9ffbppf;
import 'object_field_scopes.dart' as _iahgl0he;
import 'object_with_bit.dart' as _ioxr67zo;
import 'object_with_bytedata.dart' as _iz58zhle;
import 'object_with_custom_class.dart' as _i6zp404a;
import 'object_with_duration.dart' as _ijtijns8;
import 'object_with_dynamic.dart' as _i9hzn3wb;
import 'object_with_enum.dart' as _ip2vqluy;
import 'object_with_enum_enhanced.dart' as _iwdrmoge;
import 'object_with_geography_geometry_collection.dart' as _io7bb4tk;
import 'object_with_geography_line_string.dart' as _icdfatkc;
import 'object_with_geography_point.dart' as _i2wdw9b4;
import 'object_with_geography_polygon.dart' as _ignhorhm;
import 'object_with_half_vector.dart' as _iy6ksgxz;
import 'object_with_index.dart' as _inemzov5;
import 'object_with_jsonb.dart' as _ihyvenpw;
import 'object_with_jsonb_class_level.dart' as _i4p0t2g0;
import 'object_with_maps.dart' as _i26q9u41;
import 'object_with_nullable_custom_class.dart' as _i2qtgitl;
import 'object_with_object.dart' as _i4hr2e9p;
import 'object_with_parent.dart' as _io0t3u2c;
import 'object_with_sealed_class.dart' as _im4j7lpz;
import 'object_with_sealed_exception.dart' as _itdevv9e;
import 'object_with_self_parent.dart' as _ihluvkmz;
import 'object_with_sparse_vector.dart' as _i8t20dyr;
import 'object_with_uuid.dart' as _iusk9w05;
import 'object_with_vector.dart' as _itmc4j9i;
import 'record.dart' as _ificmsie;
import 'related_unique_data.dart' as _i2aw39a6;
import 'required/exception_with_required_field.dart' as _iiggggl6;
import 'required/model_with_required_field.dart' as _iv7egjxb;
import 'scopes/scope_none_fields.dart' as _ixhyrkj6;
import 'scopes/scope_server_only_field.dart' as _it7f5mv0;
import 'scopes/scope_server_only_field_child.dart' as _igfnl8bc;
import 'scopes/server_only_class_field.dart' as _izzkyevr;
import 'scopes/serverOnly/article.dart' as _ilchwovc;
import 'scopes/serverOnly/article_list.dart' as _ip3v2qu9;
import 'scopes/serverOnly/default_server_only_class.dart' as _i8lxkh3j;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i96dkulb;
import 'scopes/serverOnly/not_server_only_class.dart' as _ilb1g1z5;
import 'scopes/serverOnly/not_server_only_enum.dart' as _ik117x9c;
import 'scopes/serverOnly/server_only_class.dart' as _ijh817kc;
import 'scopes/serverOnly/server_only_enum.dart' as _iuyjh56c;
import 'server_only_default.dart' as _iy81tiee;
import 'session_auth_info.dart' as _iz7kinop;
import 'shared_model_container.dart' as _icmi6q0i;
import 'shared_model_subclass.dart' as _iu5vt3uc;
import 'simple_data.dart' as _i0zisc0t;
import 'simple_data_list.dart' as _iyexv7xa;
import 'simple_data_map.dart' as _iu6b143l;
import 'simple_data_object.dart' as _ikkvbzqw;
import 'simple_date_time.dart' as _i1duz4kf;
import 'subfolder/model_in_subfolder.dart' as _il2trryf;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_default_serialization.dart' as _icplrpi3;
import 'test_enum_enhanced.dart' as _it39smib;
import 'test_enum_enhanced_by_name.dart' as _izw460bh;
import 'test_enum_stringified.dart' as _i7liykk2;
import 'types.dart' as _iwxwszsz;
import 'types_list.dart' as _irfb5ten;
import 'types_map.dart' as _i81vljk7;
import 'types_record.dart' as _irmygd7t;
import 'types_set.dart' as _iiutqksg;
import 'types_set_required.dart' as _ir494j8f;
import 'unique_data.dart' as _iufhyrjh;
import 'unique_data_with_non_persist.dart' as _ip8yzqii;
import 'upsert_test_model.dart' as _iwbeyn4p;
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
export 'deferrable/deferrable_relation_initially_deferred.dart';
export 'deferrable/deferrable_relation_initially_immediate.dart';
export 'deferrable/deferrable_relation_parent.dart';
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
export 'inheritance/exception/extended_app_exception.dart';
export 'inheritance/exception/base_app_exception.dart';
export 'inheritance/exception/sealed_app_exception.dart';
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
export 'models_with_relations/column_alias_collision/bleed_child.dart';
export 'models_with_relations/column_alias_collision/bleed_root.dart';
export 'models_with_relations/generated_relation_field/generated_relation_company.dart';
export 'models_with_relations/generated_relation_field/generated_relation_employee.dart';
export 'models_with_relations/generated_relation_field/generated_relation_office.dart';
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
export 'nulls_distinct_data.dart';
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bit.dart';
export 'object_with_bytedata.dart';
export 'object_with_custom_class.dart';
export 'object_with_duration.dart';
export 'object_with_dynamic.dart';
export 'object_with_enum.dart';
export 'object_with_enum_enhanced.dart';
export 'object_with_geography_geometry_collection.dart';
export 'object_with_geography_line_string.dart';
export 'object_with_geography_point.dart';
export 'object_with_geography_polygon.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
export 'object_with_jsonb.dart';
export 'object_with_jsonb_class_level.dart';
export 'object_with_maps.dart';
export 'object_with_nullable_custom_class.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_sealed_class.dart';
export 'object_with_sealed_exception.dart';
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

class Protocol extends _is.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isp.TableDefinition> get targetTableDefinitions => [
    _isp.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'street',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'address_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'inhabitant_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'address_uuid',
      dartName: 'AddressUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'street',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'address_uuid_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'inhabitant_uuid_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'arena',
      dartName: 'Arena',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'arena_uuid',
      dartName: 'ArenaUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bigint_default',
      dartName: 'BigIntDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bigintDefaultStr',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'',
        ),
        _isp.ColumnDefinition(
          name: 'bigintDefaultStrNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bigint_default_mix',
      dartName: 'BigIntDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'1\'',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'12345678901234567890\'',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
          columnDefault: '\'-1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bigint_default_model',
      dartName: 'BigIntDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultModelStr',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'BigInt',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultModelStrNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bigint_default_persist',
      dartName: 'BigIntDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bigIntDefaultPersistStr',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
          columnDefault: '\'1234567890123456789099999999\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bleed_child',
      dartName: 'BleedChild',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bleedingText',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bleed_root',
      dartName: 'BleedRoot',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'firstChildId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'secondChildId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'bleed_root_fk_0',
          columns: ['firstChildId'],
          referenceTable: 'bleed_child',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'bleed_root_fk_1',
          columns: ['secondChildId'],
          referenceTable: 'bleed_child',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'blocking',
      dartName: 'Blocking',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'blockedId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'blockedById',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'blocking_fk_0',
          columns: ['blockedId'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'blocking_fk_1',
          columns: ['blockedById'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'blocking_blocked_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'blockedId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'book',
      dartName: 'Book',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bool_default',
      dartName: 'BoolDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultTrue',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultFalse',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultNullFalse',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bool_default_mix',
      dartName: 'BoolDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultAndDefaultModel',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bool_default_model',
      dartName: 'BoolDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultModelTrue',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultModelFalse',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultModelNullFalse',
          columnType: _isp.ColumnType.boolean,
          isNullable: false,
          dartType: 'bool',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'bool_default_persist',
      dartName: 'BoolDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultPersistTrue',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'true',
        ),
        _isp.ColumnDefinition(
          name: 'boolDefaultPersistFalse',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
          columnDefault: 'false',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'cat',
      dartName: 'Cat',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'motherId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'cat_fk_0',
          columns: ['motherId'],
          referenceTable: 'cat',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'changed_id_type_self',
      dartName: 'ChangedIdTypeSelf',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nextId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'changed_id_type_self_fk_0',
          columns: ['nextId'],
          referenceTable: 'changed_id_type_self',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'changed_id_type_self_fk_1',
          columns: ['parentId'],
          referenceTable: 'changed_id_type_self',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'changed_id_type_self_next_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'chapter',
      dartName: 'Chapter',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'title',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: '_bookChaptersBookId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'chapter_fk_0',
          columns: ['_bookChaptersBookId'],
          referenceTable: 'book',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'child_entity',
      dartName: 'ChildEntity',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'sharedField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'localField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: '_parentEntityChildrenParentEntityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'child_entity_fk_0',
          columns: ['_parentEntityChildrenParentEntityId'],
          referenceTable: 'parent_entity',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'child_table_explicit_column',
      dartName: 'ChildClassExplicitColumn',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'non_table_parent_field',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'child_field',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'child_table_with_inherited_id',
      dartName: 'ChildClassWithoutId',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'grandParentField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'parentField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'childField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'child_table_with_inherited_id_base_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'child_with_inherited_id',
      dartName: 'ChildWithInheritedId',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'createdAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'updatedAt',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'child_with_inherited_id_fk_0',
          columns: ['parentId'],
          referenceTable: 'child_with_inherited_id',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'companyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'citizen_fk_0',
          columns: ['companyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'citizen_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'citizen_int',
      dartName: 'CitizenInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'companyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'citizen_int_fk_0',
          columns: ['companyId'],
          referenceTable: 'company_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'citizen_int_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'city',
      dartName: 'City',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'city_with_long_table_name_that_is_still_valid',
      dartName: 'CityWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'orderId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'comment_int',
      dartName: 'CommentInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'orderId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'comment_int_fk_0',
          columns: ['orderId'],
          referenceTable: 'order_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'company',
      dartName: 'Company',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'townId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'company_fk_0',
          columns: ['townId'],
          referenceTable: 'town',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'company_uuid',
      dartName: 'CompanyUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'townId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'company_uuid_fk_0',
          columns: ['townId'],
          referenceTable: 'town_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'contractor',
      dartName: 'Contractor',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'fk_contractor_service_id',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'contractor_fk_0',
          columns: ['fk_contractor_service_id'],
          referenceTable: 'service',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'contractor_service_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'course',
      dartName: 'Course',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'course_uuid',
      dartName: 'CourseUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'customer',
      dartName: 'Customer',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'customer_int',
      dartName: 'CustomerInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'datetime_default',
      dartName: 'DateTimeDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultNow',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultStr',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-24T22:00:00.000Z',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultStrNull',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '2024-05-24T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'datetime_default_mix',
      dartName: 'DateTimeDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultModel',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-01T22:00:00.000Z',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'datetime_default_model',
      dartName: 'DateTimeDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultModelNow',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultModelStr',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultModelStrNull',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'datetime_default_persist',
      dartName: 'DateTimeDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultPersistNow',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: 'now',
        ),
        _isp.ColumnDefinition(
          name: 'dateTimeDefaultPersistStr',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
          columnDefault: '2024-05-10T22:00:00.000Z',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'deferrable_relation_initially_deferred',
      dartName: 'DeferrableRelationInitiallyDeferred',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'deferrable_relation_initially_deferred_fk_0',
          columns: ['parentId'],
          referenceTable: 'deferrable_relation_parent',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
          deferrable: _isp.DeferrableConstraint.initiallyDeferred,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'deferrable_relation_initially_immediate',
      dartName: 'DeferrableRelationInitiallyImmediate',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'parentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'deferrable_relation_initially_immediate_fk_0',
          columns: ['parentId'],
          referenceTable: 'deferrable_relation_parent',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
          deferrable: _isp.DeferrableConstraint.initiallyImmediate,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'deferrable_relation_parent',
      dartName: 'DeferrableRelationParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'department',
      dartName: 'Department',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'double_default',
      dartName: 'DoubleDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefault',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '10.5',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultNull',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'double_default_mix',
      dartName: 'DoubleDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultAndDefaultModel',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '10.5',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '20.5',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'double_default_model',
      dartName: 'DoubleDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultModel',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultModelNull',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: false,
          dartType: 'double',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'double_default_persist',
      dartName: 'DoubleDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'doubleDefaultPersist',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
          columnDefault: '10.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duration_default',
      dartName: 'DurationDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefault',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '94230100',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
          columnDefault: '177640100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duration_default_mix',
      dartName: 'DurationDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultAndDefaultModel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '94230100',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '177640100',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
          columnDefault: '177640100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duration_default_model',
      dartName: 'DurationDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultModel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultModelNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'duration_default_persist',
      dartName: 'DurationDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'durationDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
          columnDefault: '94230100',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'employee',
      dartName: 'Employee',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'fk_employee_department_id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'employee_fk_0',
          columns: ['fk_employee_department_id'],
          referenceTable: 'department',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'empty_model_relation_item',
      dartName: 'EmptyModelRelationItem',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: '_relationEmptyModelItemsRelationEmptyModelId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'empty_model_relation_item_fk_0',
          columns: ['_relationEmptyModelItemsRelationEmptyModelId'],
          referenceTable: 'relation_empty_model',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'empty_model_with_table',
      dartName: 'EmptyModelWithTable',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'enrollment',
      dartName: 'Enrollment',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'studentId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_0',
          columns: ['studentId'],
          referenceTable: 'student',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_1',
          columns: ['courseId'],
          referenceTable: 'course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'enrollment_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'enrollment_int',
      dartName: 'EnrollmentInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'studentId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'courseId',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'enrollment_int_fk_0',
          columns: ['studentId'],
          referenceTable: 'student_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'enrollment_int_fk_1',
          columns: ['courseId'],
          referenceTable: 'course_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'enrollment_int_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'enum_default',
      dartName: 'EnumDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefault',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName2\'',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexEnumDefault',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:ByIndexEnum',
          columnDefault: '0',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexEnumDefaultNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
          columnDefault: '1',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'enum_default_mix',
      dartName: 'EnumDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName1\'',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
          columnDefault: '\'byName2\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'enum_default_model',
      dartName: 'EnumDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:ByNameEnum',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultModelNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexEnumDefaultModel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:ByIndexEnum',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexEnumDefaultModelNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'enum_default_persist',
      dartName: 'EnumDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byNameEnumDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:ByNameEnum?',
          columnDefault: '\'byName1\'',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexEnumDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:ByIndexEnum?',
          columnDefault: '0',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'generated_relation_company',
      dartName: 'GeneratedRelationCompany',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'generated_relation_employee',
      dartName: 'GeneratedRelationEmployee',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customCompanyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'customPreviousCompanyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'generated_relation_employee_fk_0',
          columns: ['customCompanyId'],
          referenceTable: 'generated_relation_company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'generated_relation_employee_fk_1',
          columns: ['customPreviousCompanyId'],
          referenceTable: 'generated_relation_company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'generated_relation_office',
      dartName: 'GeneratedRelationOffice',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'address',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customCompanyId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'generated_relation_office_fk_0',
          columns: ['customCompanyId'],
          referenceTable: 'generated_relation_company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'generated_relation_office_company_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'customCompanyId',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'immutable_object_with_table',
      dartName: 'ImmutableObjectWithTable',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'variable',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'int_default',
      dartName: 'IntDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'intDefault',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
          columnDefault: '20',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'int_default_mix',
      dartName: 'IntDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultAndDefaultModel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '10',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
          columnDefault: '20',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'int_default_model',
      dartName: 'IntDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultModel',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultModelNull',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'int_default_persist',
      dartName: 'IntDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'intDefaultPersist',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
          columnDefault: '10',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'long_implicit_id_field',
      dartName: 'LongImplicitIdField',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name:
              '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'long_implicit_id_field_fk_0',
          columns: [
            '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id',
          ],
          referenceTable: 'long_implicit_id_field_collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'long_implicit_id_field_collection',
      dartName: 'LongImplicitIdFieldCollection',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'max_field_name',
      dartName: 'MaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'member',
      dartName: 'Member',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'model_with_required_field',
      dartName: 'ModelWithRequiredField',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'phone',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'modified_column_name',
      dartName: 'ModifiedColumnName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'originalColumn',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'modified_column',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'multiple_max_field_name',
      dartName: 'MultipleMaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name:
              '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'multiple_max_field_name_fk_0',
          columns: [
            '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId',
          ],
          referenceTable: 'relation_to_multiple_max_field_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'nulls_distinct_data',
      dartName: 'NullsDistinctData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'tenantId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'archivedAt',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'deletedAt',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'nulls_distinct_data_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tenantId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'category',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'archivedAt',
            ),
          ],
          type: 'btree',
          isUnique: true,
          nullsDistinct: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'nulls_distinct_data_not_distinct_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'tenantId',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'category',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'deletedAt',
            ),
          ],
          type: 'btree',
          isUnique: true,
          nullsDistinct: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_field_persist',
      dartName: 'ObjectFieldPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'normal',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_field_scopes',
      dartName: 'ObjectFieldScopes',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'normal',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'database',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_user',
      dartName: 'ObjectUser',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'userInfoId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'object_user_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_bit',
      dartName: 'ObjectWithBit',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'bit',
          columnType: _isp.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'bitNullable',
          columnType: _isp.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(512)?',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'bitIndexedHnsw',
          columnType: _isp.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'bitIndexedHnswWithParams',
          columnType: _isp.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'bitIndexedIvfflat',
          columnType: _isp.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'bitIndexedIvfflatWithParams',
          columnType: _isp.ColumnType.bit,
          isNullable: false,
          dartType: 'Bit(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'bit_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bit',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.hamming,
          vectorColumnType: _isp.ColumnType.bit,
        ),
        _isp.IndexDefinition(
          indexName: 'bit_index_hnsw',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bitIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.hamming,
          vectorColumnType: _isp.ColumnType.bit,
        ),
        _isp.IndexDefinition(
          indexName: 'bit_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bitIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.jaccard,
          vectorColumnType: _isp.ColumnType.bit,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _isp.IndexDefinition(
          indexName: 'bit_index_ivfflat',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bitIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.hamming,
          vectorColumnType: _isp.ColumnType.bit,
        ),
        _isp.IndexDefinition(
          indexName: 'bit_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'bitIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.hamming,
          vectorColumnType: _isp.ColumnType.bit,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_bytedata',
      dartName: 'ObjectWithByteData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byteData',
          columnType: _isp.ColumnType.bytea,
          isNullable: false,
          dartType: 'dart:typed_data:ByteData',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_duration',
      dartName: 'ObjectWithDuration',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'duration',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'Duration',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_dynamic',
      dartName: 'ObjectWithDynamic',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'payload',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'dynamic',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbPayload',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'dynamic',
        ),
        _isp.ColumnDefinition(
          name: 'payloadList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<dynamic>',
        ),
        _isp.ColumnDefinition(
          name: 'payloadMap',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,dynamic>',
        ),
        _isp.ColumnDefinition(
          name: 'payloadSet',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Set<dynamic>',
        ),
        _isp.ColumnDefinition(
          name: 'payloadMapWithDynamicKeys',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'Map<dynamic,dynamic>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_enum',
      dartName: 'ObjectWithEnum',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'testEnum',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:TestEnum',
        ),
        _isp.ColumnDefinition(
          name: 'nullableEnum',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _isp.ColumnDefinition(
          name: 'enumList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum>',
        ),
        _isp.ColumnDefinition(
          name: 'nullableEnumList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnum?>',
        ),
        _isp.ColumnDefinition(
          name: 'enumListList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<List<protocol:TestEnum>>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_enum_enhanced',
      dartName: 'ObjectWithEnumEnhanced',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'byIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'protocol:TestEnumEnhanced',
        ),
        _isp.ColumnDefinition(
          name: 'nullableByIndex',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnumEnhanced?',
        ),
        _isp.ColumnDefinition(
          name: 'byIndexList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnumEnhanced>',
        ),
        _isp.ColumnDefinition(
          name: 'byName',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'protocol:TestEnumEnhancedByName',
        ),
        _isp.ColumnDefinition(
          name: 'nullableByName',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumEnhancedByName?',
        ),
        _isp.ColumnDefinition(
          name: 'byNameList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:TestEnumEnhancedByName>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_geography_geometry_collection',
      dartName: 'ObjectWithGeographyGeometryCollection',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'geometryCollection',
          columnType: _isp.ColumnType.geographyGeometryCollection,
          isNullable: false,
          dartType: 'GeographyGeometryCollection',
        ),
        _isp.ColumnDefinition(
          name: 'geometryCollectionIndexedGist',
          columnType: _isp.ColumnType.geographyGeometryCollection,
          isNullable: false,
          dartType: 'GeographyGeometryCollection',
        ),
        _isp.ColumnDefinition(
          name: 'geometryCollectionIndexedSpgist',
          columnType: _isp.ColumnType.geographyGeometryCollection,
          isNullable: false,
          dartType: 'GeographyGeometryCollection',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'geography_geometry_collection_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'geometryCollection',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_geometry_collection_index_gist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'geometryCollectionIndexedGist',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_geometry_collection_index_spgist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'geometryCollectionIndexedSpgist',
            ),
          ],
          type: 'spgist',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_geography_line_string',
      dartName: 'ObjectWithGeographyLineString',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'lineString',
          columnType: _isp.ColumnType.geographyLineString,
          isNullable: false,
          dartType: 'GeographyLineString',
        ),
        _isp.ColumnDefinition(
          name: 'lineStringIndexedGist',
          columnType: _isp.ColumnType.geographyLineString,
          isNullable: false,
          dartType: 'GeographyLineString',
        ),
        _isp.ColumnDefinition(
          name: 'lineStringIndexedSpgist',
          columnType: _isp.ColumnType.geographyLineString,
          isNullable: false,
          dartType: 'GeographyLineString',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'geography_line_string_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineString',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_line_string_index_gist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineStringIndexedGist',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_line_string_index_spgist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'lineStringIndexedSpgist',
            ),
          ],
          type: 'spgist',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_geography_point',
      dartName: 'ObjectWithGeographyPoint',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'point',
          columnType: _isp.ColumnType.geography,
          isNullable: false,
          dartType: 'GeographyPoint',
        ),
        _isp.ColumnDefinition(
          name: 'pointIndexedGist',
          columnType: _isp.ColumnType.geography,
          isNullable: false,
          dartType: 'GeographyPoint',
        ),
        _isp.ColumnDefinition(
          name: 'pointIndexedSpgist',
          columnType: _isp.ColumnType.geography,
          isNullable: false,
          dartType: 'GeographyPoint',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'geography_point_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'point',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_point_index_gist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'pointIndexedGist',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_point_index_spgist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'pointIndexedSpgist',
            ),
          ],
          type: 'spgist',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_geography_polygon',
      dartName: 'ObjectWithGeographyPolygon',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'polygon',
          columnType: _isp.ColumnType.geographyPolygon,
          isNullable: false,
          dartType: 'GeographyPolygon',
        ),
        _isp.ColumnDefinition(
          name: 'polygonIndexedGist',
          columnType: _isp.ColumnType.geographyPolygon,
          isNullable: false,
          dartType: 'GeographyPolygon',
        ),
        _isp.ColumnDefinition(
          name: 'polygonIndexedSpgist',
          columnType: _isp.ColumnType.geographyPolygon,
          isNullable: false,
          dartType: 'GeographyPolygon',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'geography_polygon_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'polygon',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_polygon_index_gist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'polygonIndexedGist',
            ),
          ],
          type: 'gist',
          isUnique: false,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'geography_polygon_index_spgist',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'polygonIndexedSpgist',
            ),
          ],
          type: 'spgist',
          isUnique: false,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_half_vector',
      dartName: 'ObjectWithHalfVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'halfVector',
          columnType: _isp.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'halfVectorNullable',
          columnType: _isp.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(512)?',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'halfVectorIndexedHnsw',
          columnType: _isp.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'halfVectorIndexedHnswWithParams',
          columnType: _isp.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'halfVectorIndexedIvfflat',
          columnType: _isp.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'halfVectorIndexedIvfflatWithParams',
          columnType: _isp.ColumnType.halfvec,
          isNullable: false,
          dartType: 'HalfVector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'half_vector_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'halfVector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.halfvec,
        ),
        _isp.IndexDefinition(
          indexName: 'half_vector_index_hnsw',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.halfvec,
        ),
        _isp.IndexDefinition(
          indexName: 'half_vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.halfvec,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _isp.IndexDefinition(
          indexName: 'half_vector_index_ivfflat',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.halfvec,
        ),
        _isp.IndexDefinition(
          indexName: 'half_vector_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'halfVectorIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.cosine,
          vectorColumnType: _isp.ColumnType.halfvec,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_index',
      dartName: 'ObjectWithIndex',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'indexed',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'indexed2',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'object_with_index_test_index',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'indexed',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'object_with_jsonb',
      dartName: 'ObjectWithJsonb',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'notJsonb',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonb',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbMap',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'Map<String,String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbObject',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'protocol:SimpleData',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbIndexed',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbIndexedGin',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbIndexedGinJsonbPath',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'jsonbIndexedImplicitGin',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'nullableJsonb',
          columnType: _isp.ColumnType.jsonb,
          isNullable: true,
          dartType: 'List<String>?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'jsonb_index_gin',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedGin',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _isp.GinOperatorClass.jsonbOps,
        ),
        _isp.IndexDefinition(
          indexName: 'jsonb_index_gin_with_operator_class',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedGinJsonbPath',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _isp.GinOperatorClass.jsonbPathOps,
        ),
        _isp.IndexDefinition(
          indexName: 'jsonb_index_implicit_gin',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'jsonbIndexedImplicitGin',
            ),
          ],
          type: 'gin',
          isUnique: false,
          isPrimary: false,
          ginOperatorClass: _isp.GinOperatorClass.jsonbOps,
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_jsonb_class_level',
      dartName: 'ObjectWithJsonbClassLevel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'implicitJsonb',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'explicitJsonb',
          columnType: _isp.ColumnType.jsonb,
          isNullable: false,
          dartType: 'List<String>',
        ),
        _isp.ColumnDefinition(
          name: 'json',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<String>',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_object',
      dartName: 'ObjectWithObject',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'data',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:SimpleData',
        ),
        _isp.ColumnDefinition(
          name: 'nullableData',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SimpleData?',
        ),
        _isp.ColumnDefinition(
          name: 'dataList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData>',
        ),
        _isp.ColumnDefinition(
          name: 'nullableDataList',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData>?',
        ),
        _isp.ColumnDefinition(
          name: 'listWithNullableData',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<protocol:SimpleData?>',
        ),
        _isp.ColumnDefinition(
          name: 'nullableListWithNullableData',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<protocol:SimpleData?>?',
        ),
        _isp.ColumnDefinition(
          name: 'nestedDataList',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<List<protocol:SimpleData>>?',
        ),
        _isp.ColumnDefinition(
          name: 'nestedDataListInMap',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,List<List<Map<int,protocol:SimpleData>>?>>?',
        ),
        _isp.ColumnDefinition(
          name: 'nestedDataMap',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,Map<int,protocol:SimpleData>>?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_parent',
      dartName: 'ObjectWithParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'other',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'object_with_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_field_scopes',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_self_parent',
      dartName: 'ObjectWithSelfParent',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'other',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'object_with_self_parent_fk_0',
          columns: ['other'],
          referenceTable: 'object_with_self_parent',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_sparse_vector',
      dartName: 'ObjectWithSparseVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'sparseVector',
          columnType: _isp.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'sparseVectorNullable',
          columnType: _isp.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(512)?',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'sparseVectorIndexedHnsw',
          columnType: _isp.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'sparseVectorIndexedHnswWithParams',
          columnType: _isp.ColumnType.sparsevec,
          isNullable: false,
          dartType: 'SparseVector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'sparse_vector_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sparseVector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.sparsevec,
        ),
        _isp.IndexDefinition(
          indexName: 'sparse_vector_index_hnsw',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sparseVectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.sparsevec,
        ),
        _isp.IndexDefinition(
          indexName: 'sparse_vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'sparseVectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l1,
          vectorColumnType: _isp.ColumnType.sparsevec,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_uuid',
      dartName: 'ObjectWithUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuid',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'uuidNullable',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'object_with_vector',
      dartName: 'ObjectWithVector',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'vector',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'vectorNullable',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(512)?',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'vectorIndexedHnsw',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'vectorIndexedHnswWithParams',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'vectorIndexedIvfflat',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
        _isp.ColumnDefinition(
          name: 'vectorIndexedIvfflatWithParams',
          columnType: _isp.ColumnType.vector,
          isNullable: false,
          dartType: 'Vector(512)',
          vectorDimension: 512,
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'vector_index_default',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'vector',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.vector,
        ),
        _isp.IndexDefinition(
          indexName: 'vector_index_hnsw',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'vectorIndexedHnsw',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.vector,
        ),
        _isp.IndexDefinition(
          indexName: 'vector_index_hnsw_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'vectorIndexedHnswWithParams',
            ),
          ],
          type: 'hnsw',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.cosine,
          vectorColumnType: _isp.ColumnType.vector,
          parameters: {
            'm': '64',
            'ef_construction': '200',
          },
        ),
        _isp.IndexDefinition(
          indexName: 'vector_index_ivfflat',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'vectorIndexedIvfflat',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.l2,
          vectorColumnType: _isp.ColumnType.vector,
        ),
        _isp.IndexDefinition(
          indexName: 'vector_index_ivfflat_with_params',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'vectorIndexedIvfflatWithParams',
            ),
          ],
          type: 'ivfflat',
          isUnique: false,
          isPrimary: false,
          vectorDistanceFunction: _isp.VectorDistanceFunction.innerProduct,
          vectorColumnType: _isp.ColumnType.vector,
          parameters: {'lists': '300'},
        ),
      ],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'order',
      dartName: 'Order',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'order_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'order_uuid',
      dartName: 'OrderUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'customerId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'order_uuid_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'organization',
      dartName: 'Organization',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'cityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'organization_fk_0',
          columns: ['cityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'organization_with_long_table_name_that_is_still_valid',
      dartName: 'OrganizationWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'cityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName:
              'organization_with_long_table_name_that_is_still_valid_fk_0',
          columns: ['cityId'],
          referenceTable: 'city_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'parent_class_table',
      dartName: 'ParentClass',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'grandParentField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'parentField',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'parent_entity',
      dartName: 'ParentEntity',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'parent_user',
      dartName: 'ParentUser',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'userInfoId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'parent_user_fk_0',
          columns: ['userInfoId'],
          referenceTable: 'serverpod_user_info',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'organizationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: '_cityCitizensCityId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'person_fk_0',
          columns: ['organizationId'],
          referenceTable: 'organization',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName: 'person_fk_1',
          columns: ['_cityCitizensCityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'person_with_long_table_name_that_is_still_valid',
      dartName: 'PersonWithLongTableName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'organizationId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name:
              '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName:
              'person_with_long_table_name_that_is_still_valid_fk_0',
          columns: ['organizationId'],
          referenceTable:
              'organization_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isp.ForeignKeyDefinition(
          constraintName:
              'person_with_long_table_name_that_is_still_valid_fk_1',
          columns: [
            '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id',
          ],
          referenceTable: 'city_with_long_table_name_that_is_still_valid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'player',
      dartName: 'Player',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'teamId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'player_fk_0',
          columns: ['teamId'],
          referenceTable: 'team',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'player_uuid',
      dartName: 'PlayerUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'teamId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'player_uuid_fk_0',
          columns: ['teamId'],
          referenceTable: 'team_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'post',
      dartName: 'Post',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'content',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'nextId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['nextId'],
          referenceTable: 'post',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'next_unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'related_unique_data',
      dartName: 'RelatedUniqueData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uniqueDataId',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'related_unique_data_fk_0',
          columns: ['uniqueDataId'],
          referenceTable: 'unique_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'relation_empty_model',
      dartName: 'RelationEmptyModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'relation_to_multiple_max_field_name',
      dartName: 'RelationToMultipleMaxFieldName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'scope_none_fields',
      dartName: 'ScopeNoneFields',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'object',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SimpleData?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'server_only_changed_id_field_class',
      dartName: 'ServerOnlyChangedIdFieldClass',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'service',
      dartName: 'Service',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'shared_model_container',
      dartName: 'SharedModelContainer',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModel',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedModel',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelWithModuleAlias',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedModel',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedModel?',
        ),
        _isp.ColumnDefinition(
          name: 'serverOnlySharedModel',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedModel?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSubclass',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedSubclass',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSubclassNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedSubclass?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedEnum',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedEnum',
        ),
        _isp.ColumnDefinition(
          name: 'sharedEnumNullable',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedEnum?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSealedParent',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedSealedParent',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSealedParentNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedSealedParent?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSealedChild',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'serverpod_test_shared:SharedSealedChild',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSealedChildNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'serverpod_test_shared:SharedSealedChild?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelSubclass',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'protocol:SharedModelSubclass',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelSubclassNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'protocol:SharedModelSubclass?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<serverpod_test_shared:SharedModel>',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelNullableList',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'List<serverpod_test_shared:SharedModel?>',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelListNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<serverpod_test_shared:SharedModel>?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelMap',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,serverpod_test_shared:SharedModel>',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelMapNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Map<String,serverpod_test_shared:SharedModel>?',
        ),
        _isp.ColumnDefinition(
          name: 'sharedSubclassMap',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Map<String,serverpod_test_shared:SharedSubclass>',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelSet',
          columnType: _isp.ColumnType.json,
          isNullable: false,
          dartType: 'Set<serverpod_test_shared:SharedModel>',
        ),
        _isp.ColumnDefinition(
          name: 'sharedModelSetNullable',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Set<serverpod_test_shared:SharedModel>?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'num',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'simple_date_time',
      dartName: 'SimpleDateTime',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'dateTime',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'string_default',
      dartName: 'StringDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefault',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default null value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'string_default_mix',
      dartName: 'StringDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultAndDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
          columnDefault: '\'This is a default persist value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'string_default_model',
      dartName: 'StringDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultModelNull',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'string_default_persist',
      dartName: 'StringDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithOneDoubleQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistSingleQuoteWithTwoDoubleQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a "default" persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithOneSingleQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default persist value\'',
        ),
        _isp.ColumnDefinition(
          name: 'stringDefaultPersistDoubleQuoteWithTwoSingleQuote',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'This is a \'\'default\'\' persist value\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'student',
      dartName: 'Student',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'student_uuid',
      dartName: 'StudentUuid',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'table_with_explicit_column_names',
      dartName: 'TableWithExplicitColumnName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'user_name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'user_description',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
          columnDefault: '\'Just some information\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'team',
      dartName: 'Team',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'arenaId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'team_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'arena_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'team_int',
      dartName: 'TeamInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'arenaId',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'team_int_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena_uuid',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'arena_uuid_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'town',
      dartName: 'Town',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'mayorId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'town_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'town_int',
      dartName: 'TownInt',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'mayorId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'town_int_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen_int',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'types',
      dartName: 'Types',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'anInt',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isp.ColumnDefinition(
          name: 'aBool',
          columnType: _isp.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isp.ColumnDefinition(
          name: 'aDouble',
          columnType: _isp.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isp.ColumnDefinition(
          name: 'aDateTime',
          columnType: _isp.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isp.ColumnDefinition(
          name: 'aString',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isp.ColumnDefinition(
          name: 'aByteData',
          columnType: _isp.ColumnType.bytea,
          isNullable: true,
          dartType: 'dart:typed_data:ByteData?',
        ),
        _isp.ColumnDefinition(
          name: 'aDuration',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _isp.ColumnDefinition(
          name: 'aUuid',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'aUri',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
        _isp.ColumnDefinition(
          name: 'aBigInt',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
        _isp.ColumnDefinition(
          name: 'aVector',
          columnType: _isp.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(3)?',
          vectorDimension: 3,
        ),
        _isp.ColumnDefinition(
          name: 'aHalfVector',
          columnType: _isp.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(3)?',
          vectorDimension: 3,
        ),
        _isp.ColumnDefinition(
          name: 'aSparseVector',
          columnType: _isp.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(3)?',
          vectorDimension: 3,
        ),
        _isp.ColumnDefinition(
          name: 'aBit',
          columnType: _isp.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(3)?',
          vectorDimension: 3,
        ),
        _isp.ColumnDefinition(
          name: 'aGeographyPoint',
          columnType: _isp.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _isp.ColumnDefinition(
          name: 'aGeographyLineString',
          columnType: _isp.ColumnType.geographyLineString,
          isNullable: true,
          dartType: 'GeographyLineString?',
        ),
        _isp.ColumnDefinition(
          name: 'aGeographyPolygon',
          columnType: _isp.ColumnType.geographyPolygon,
          isNullable: true,
          dartType: 'GeographyPolygon?',
        ),
        _isp.ColumnDefinition(
          name: 'aGeographyGeometryCollection',
          columnType: _isp.ColumnType.geographyGeometryCollection,
          isNullable: true,
          dartType: 'GeographyGeometryCollection?',
        ),
        _isp.ColumnDefinition(
          name: 'anEnum',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _isp.ColumnDefinition(
          name: 'aStringifiedEnum',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumStringified?',
        ),
        _isp.ColumnDefinition(
          name: 'aList',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _isp.ColumnDefinition(
          name: 'aMap',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Map<int,int>?',
        ),
        _isp.ColumnDefinition(
          name: 'aSet',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: 'Set<int>?',
        ),
        _isp.ColumnDefinition(
          name: 'aRecord',
          columnType: _isp.ColumnType.json,
          isNullable: true,
          dartType: '(String, {Uri? optionalUri})?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'unique_data',
      dartName: 'UniqueData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'email_index_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'unique_data_with_non_persist',
      dartName: 'UniqueDataWithNonPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'number',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isp.ColumnDefinition(
          name: 'email',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'unique_email_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'upsert_test_model',
      dartName: 'UpsertTestModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'code',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'category',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name: 'value',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isp.IndexDefinition(
          indexName: 'upsert_test_model__code__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'code',
            ),
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
        ),
        _isp.IndexDefinition(
          indexName: 'upsert_test_model__category__value__unique_idx',
          tableSpace: null,
          elements: [
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
              definition: 'category',
            ),
            _isp.IndexElementDefinition(
              type: _isp.IndexElementDefinitionType.column,
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
    _isp.TableDefinition(
      name: 'uri_default',
      dartName: 'UriDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefault',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uri_default_mix',
      dartName: 'UriDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultAndDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/default\'',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
          columnDefault: '\'https://serverpod.dev/defaultPersist\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uri_default_model',
      dartName: 'UriDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultModel',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'Uri',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultModelNull',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uri_default_persist',
      dartName: 'UriDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uriDefaultPersist',
          columnType: _isp.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
          columnDefault: '\'https://serverpod.dev/\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_note',
      dartName: 'UserNote',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name:
              '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'user_note_fk_0',
          columns: [
            '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId',
          ],
          referenceTable: 'user_note_collections',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_note_collection_with_a_long_name',
      dartName: 'UserNoteCollectionWithALongName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_note_collections',
      dartName: 'UserNoteCollection',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'user_note_with_a_long_name',
      dartName: 'UserNoteWithALongName',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'name',
          columnType: _isp.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isp.ColumnDefinition(
          name:
              '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
          columnType: _isp.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isp.ForeignKeyDefinition(
          constraintName: 'user_note_with_a_long_name_fk_0',
          columns: [
            '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId',
          ],
          referenceTable: 'user_note_collection_with_a_long_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isp.ForeignKeyAction.noAction,
          onDelete: _isp.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uuid_default',
      dartName: 'UuidDefault',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultRandom',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultRandomV7',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultRandomNull',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultStr',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultStrNull',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uuid_default_mix',
      dartName: 'UuidDefaultMix',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultAndDefaultModel',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'3f2504e0-4f89-11d3-9a0c-0305e82c3301\'',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultAndDefaultPersist',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'9e107d9d-372b-4d97-9b27-2f0907d0b1d4\'',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelAndDefaultPersist',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
          columnDefault: '\'f47ac10b-58cc-4372-a567-0e02b2c3d479\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uuid_default_model',
      dartName: 'UuidDefaultModel',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelRandom',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelRandomV7',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelRandomNull',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelStr',
          columnType: _isp.ColumnType.uuid,
          isNullable: false,
          dartType: 'UuidValue',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultModelStrNull',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isp.TableDefinition(
      name: 'uuid_default_persist',
      dartName: 'UuidDefaultPersist',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _isp.ColumnDefinition(
          name: 'id',
          columnType: _isp.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultPersistRandom',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultPersistRandomV7',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: 'random_v7',
        ),
        _isp.ColumnDefinition(
          name: 'uuidDefaultPersistStr',
          columnType: _isp.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
          columnDefault: '\'550e8400-e29b-41d4-a716-446655440000\'',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    ..._i1n3uhu0.Protocol.targetTableDefinitions,
    ..._iom2gwyu.Protocol.targetTableDefinitions,
    ..._iyx9etqn.Protocol.targetTableDefinitions,
    ..._ilwf0zl1.Protocol() is _is.DatabaseSerializationManager
        ? (_ilwf0zl1.Protocol() as _is.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._isp.Protocol.targetTableDefinitions,
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

    if (t == _ihs9bjzx.ByIndexEnumWithNameValue) {
      return _ihs9bjzx.ByIndexEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _iwdug2n0.ByNameEnumWithNameValue) {
      return _iwdug2n0.ByNameEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _ik6ri27s.CourseUuid) {
      return _ik6ri27s.CourseUuid.fromJson(data) as T;
    }
    if (t == _icdgc05t.EnrollmentInt) {
      return _icdgc05t.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _ibrjea6w.StudentUuid) {
      return _ibrjea6w.StudentUuid.fromJson(data) as T;
    }
    if (t == _isj7c5mo.ArenaUuid) {
      return _isj7c5mo.ArenaUuid.fromJson(data) as T;
    }
    if (t == _ivdpnfmj.PlayerUuid) {
      return _ivdpnfmj.PlayerUuid.fromJson(data) as T;
    }
    if (t == _ivehlt2f.TeamInt) {
      return _ivehlt2f.TeamInt.fromJson(data) as T;
    }
    if (t == _i3jtpxta.CommentInt) {
      return _i3jtpxta.CommentInt.fromJson(data) as T;
    }
    if (t == _iimgofmw.CustomerInt) {
      return _iimgofmw.CustomerInt.fromJson(data) as T;
    }
    if (t == _iywnby31.OrderUuid) {
      return _iywnby31.OrderUuid.fromJson(data) as T;
    }
    if (t == _ifwqt4rb.AddressUuid) {
      return _ifwqt4rb.AddressUuid.fromJson(data) as T;
    }
    if (t == _idhvg1zk.CitizenInt) {
      return _idhvg1zk.CitizenInt.fromJson(data) as T;
    }
    if (t == _i5vwm04a.CompanyUuid) {
      return _i5vwm04a.CompanyUuid.fromJson(data) as T;
    }
    if (t == _iu7osokh.TownInt) {
      return _iu7osokh.TownInt.fromJson(data) as T;
    }
    if (t == _ixc9sah8.ChangedIdTypeSelf) {
      return _ixc9sah8.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _irw3jmaq.ServerOnlyChangedIdFieldClass) {
      return _irw3jmaq.ServerOnlyChangedIdFieldClass.fromJson(data) as T;
    }
    if (t == _icrmubzc.BigIntDefault) {
      return _icrmubzc.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i1xsun18.BigIntDefaultMix) {
      return _i1xsun18.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i332rqur.BigIntDefaultModel) {
      return _i332rqur.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _ia4nw21o.BigIntDefaultPersist) {
      return _ia4nw21o.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _ilirabmz.BoolDefault) {
      return _ilirabmz.BoolDefault.fromJson(data) as T;
    }
    if (t == _iwhzartq.BoolDefaultMix) {
      return _iwhzartq.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _izvr7tnf.BoolDefaultModel) {
      return _izvr7tnf.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i135uugo.BoolDefaultPersist) {
      return _i135uugo.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _iro0mlkq.DateTimeDefault) {
      return _iro0mlkq.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _igjm2894.DateTimeDefaultMix) {
      return _igjm2894.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _ivkcoq83.DateTimeDefaultModel) {
      return _ivkcoq83.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _iaqar0o9.DateTimeDefaultPersist) {
      return _iaqar0o9.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _izu05ym4.DoubleDefault) {
      return _izu05ym4.DoubleDefault.fromJson(data) as T;
    }
    if (t == _iou6kksr.DoubleDefaultMix) {
      return _iou6kksr.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i9xv7g6i.DoubleDefaultModel) {
      return _i9xv7g6i.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _iynhhcdw.DoubleDefaultPersist) {
      return _iynhhcdw.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _ixvw8l6s.DurationDefault) {
      return _ixvw8l6s.DurationDefault.fromJson(data) as T;
    }
    if (t == _ialx1ytx.DurationDefaultMix) {
      return _ialx1ytx.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i5aouk9m.DurationDefaultModel) {
      return _i5aouk9m.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _ij5e1q2b.DurationDefaultPersist) {
      return _ij5e1q2b.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _ihqxpva2.EnumDefault) {
      return _ihqxpva2.EnumDefault.fromJson(data) as T;
    }
    if (t == _iyezrrxn.EnumDefaultMix) {
      return _iyezrrxn.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _iw4wb1ju.EnumDefaultModel) {
      return _iw4wb1ju.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i0p9yn0v.EnumDefaultPersist) {
      return _i0p9yn0v.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i4ekvn16.ByIndexEnum) {
      return _i4ekvn16.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _ihrgmscf.ByNameEnum) {
      return _ihrgmscf.ByNameEnum.fromJson(data) as T;
    }
    if (t == _iirkfcfb.DefaultValueEnum) {
      return _iirkfcfb.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _iv40kyzq.DefaultException) {
      return _iv40kyzq.DefaultException.fromJson(data) as T;
    }
    if (t == _i8t3u1nx.IntDefault) {
      return _i8t3u1nx.IntDefault.fromJson(data) as T;
    }
    if (t == _iummzlp0.IntDefaultMix) {
      return _iummzlp0.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i4rypx08.IntDefaultModel) {
      return _i4rypx08.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _imhmhhwa.IntDefaultPersist) {
      return _imhmhhwa.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i4d8z6ds.StringDefault) {
      return _i4d8z6ds.StringDefault.fromJson(data) as T;
    }
    if (t == _iu6k5fkj.StringDefaultMix) {
      return _iu6k5fkj.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _ihmqo6od.StringDefaultModel) {
      return _ihmqo6od.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _ih6giyf6.StringDefaultPersist) {
      return _ih6giyf6.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i2y701qf.UriDefault) {
      return _i2y701qf.UriDefault.fromJson(data) as T;
    }
    if (t == _iib8h1yl.UriDefaultMix) {
      return _iib8h1yl.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i1to0y5o.UriDefaultModel) {
      return _i1to0y5o.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _isi15w9f.UriDefaultPersist) {
      return _isi15w9f.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _ihsadwhl.UuidDefault) {
      return _ihsadwhl.UuidDefault.fromJson(data) as T;
    }
    if (t == _ignwr848.UuidDefaultMix) {
      return _ignwr848.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i15gwzho.UuidDefaultModel) {
      return _i15gwzho.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i2v866bf.UuidDefaultPersist) {
      return _i2v866bf.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _io8dlrxh.DeferrableRelationInitiallyDeferred) {
      return _io8dlrxh.DeferrableRelationInitiallyDeferred.fromJson(data) as T;
    }
    if (t == _inmfeda2.DeferrableRelationInitiallyImmediate) {
      return _inmfeda2.DeferrableRelationInitiallyImmediate.fromJson(data) as T;
    }
    if (t == _izxfibiy.DeferrableRelationParent) {
      return _izxfibiy.DeferrableRelationParent.fromJson(data) as T;
    }
    if (t == _i9l9xrkt.EmptyModel) {
      return _i9l9xrkt.EmptyModel.fromJson(data) as T;
    }
    if (t == _ikufh0vd.EmptyModelRelationItem) {
      return _ikufh0vd.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _iw4y4x6s.EmptyModelWithTable) {
      return _iw4y4x6s.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _iy7bezig.RelationEmptyModel) {
      return _iy7bezig.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _is77lrdb.ExceptionWithData) {
      return _is77lrdb.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _ikh95zxc.ChildClassExplicitColumn) {
      return _ikh95zxc.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i1y2idkw.NonTableParentClass) {
      return _i1y2idkw.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i7hqkfn7.ModifiedColumnName) {
      return _i7hqkfn7.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _ix2lcsu0.Department) {
      return _ix2lcsu0.Department.fromJson(data) as T;
    }
    if (t == _ixlcmx78.Employee) {
      return _ixlcmx78.Employee.fromJson(data) as T;
    }
    if (t == _iw4adtsk.Contractor) {
      return _iw4adtsk.Contractor.fromJson(data) as T;
    }
    if (t == _i83a3u3u.Service) {
      return _i83a3u3u.Service.fromJson(data) as T;
    }
    if (t == _iox92era.TableWithExplicitColumnName) {
      return _iox92era.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _ip57k4t4.TestGeneratedCallByeModel) {
      return _ip57k4t4.TestGeneratedCallByeModel.fromJson(data) as T;
    }
    if (t == _ilmnz413.TestGeneratedCallExecuteWithTriggerModel) {
      return _ilmnz413.TestGeneratedCallExecuteWithTriggerModel.fromJson(data)
          as T;
    }
    if (t == _ifspsmem.TestGeneratedCallHelloModel) {
      return _ifspsmem.TestGeneratedCallHelloModel.fromJson(data) as T;
    }
    if (t == _i3yv7lzj.TestGeneratedCallInvokeModel) {
      return _i3yv7lzj.TestGeneratedCallInvokeModel.fromJson(data) as T;
    }
    if (t == _isas41s9.ImmutableChildObject) {
      return _isas41s9.ImmutableChildObject.fromJson(data) as T;
    }
    if (t == _i8ali8rk.ImmutableChildObjectWithNoAdditionalFields) {
      return _i8ali8rk.ImmutableChildObjectWithNoAdditionalFields.fromJson(data)
          as T;
    }
    if (t == _ib4436rb.ImmutableObject) {
      return _ib4436rb.ImmutableObject.fromJson(data) as T;
    }
    if (t == _i5o8gk0d.ImmutableObjectWithImmutableObject) {
      return _i5o8gk0d.ImmutableObjectWithImmutableObject.fromJson(data) as T;
    }
    if (t == _ifcovr71.ImmutableObjectWithList) {
      return _ifcovr71.ImmutableObjectWithList.fromJson(data) as T;
    }
    if (t == _i7chvx7t.ImmutableObjectWithMap) {
      return _i7chvx7t.ImmutableObjectWithMap.fromJson(data) as T;
    }
    if (t == _ijpel12b.ImmutableObjectWithMultipleFields) {
      return _ijpel12b.ImmutableObjectWithMultipleFields.fromJson(data) as T;
    }
    if (t == _im6ib46o.ImmutableObjectWithNoFields) {
      return _im6ib46o.ImmutableObjectWithNoFields.fromJson(data) as T;
    }
    if (t == _iz0jdatm.ImmutableObjectWithRecord) {
      return _iz0jdatm.ImmutableObjectWithRecord.fromJson(data) as T;
    }
    if (t == _ij73d01s.ImmutableObjectWithTable) {
      return _ij73d01s.ImmutableObjectWithTable.fromJson(data) as T;
    }
    if (t == _i6bj8wy3.ImmutableObjectWithTwentyFields) {
      return _i6bj8wy3.ImmutableObjectWithTwentyFields.fromJson(data) as T;
    }
    if (t == _ix35kamj.ChildClass) {
      return _ix35kamj.ChildClass.fromJson(data) as T;
    }
    if (t == _inmco1xt.ServerOnlyChildClass) {
      return _inmco1xt.ServerOnlyChildClass.fromJson(data) as T;
    }
    if (t == _ibdvdtnv.ChildWithDefault) {
      return _ibdvdtnv.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _ieeasgju.ChildWithInheritedId) {
      return _ieeasgju.ChildWithInheritedId.fromJson(data) as T;
    }
    if (t == _i57yjwwl.ChildClassWithoutId) {
      return _i57yjwwl.ChildClassWithoutId.fromJson(data) as T;
    }
    if (t == _ihtrmue0.ServerOnlyChildClassWithoutId) {
      return _ihtrmue0.ServerOnlyChildClassWithoutId.fromJson(data) as T;
    }
    if (t == _i4ydso50.ExtendedAppException) {
      return _i4ydso50.ExtendedAppException.fromJson(data) as T;
    }
    if (t == _iw7pve41.BaseAppException) {
      return _iw7pve41.BaseAppException.fromJson(data) as T;
    }
    if (t == _iaxkp5y4.NotFoundException) {
      return _iaxkp5y4.NotFoundException.fromJson(data) as T;
    }
    if (t == _iaxkp5y4.ValidationException) {
      return _iaxkp5y4.ValidationException.fromJson(data) as T;
    }
    if (t == _io7upog0.ParentClass) {
      return _io7upog0.ParentClass.fromJson(data) as T;
    }
    if (t == _i5sz4l10.GrandparentClass) {
      return _i5sz4l10.GrandparentClass.fromJson(data) as T;
    }
    if (t == _ijexcijb.ParentClassWithoutId) {
      return _ijexcijb.ParentClassWithoutId.fromJson(data) as T;
    }
    if (t == _iolet7jc.GrandparentClassWithId) {
      return _iolet7jc.GrandparentClassWithId.fromJson(data) as T;
    }
    if (t == _i2aipqpt.ChildEntity) {
      return _i2aipqpt.ChildEntity.fromJson(data) as T;
    }
    if (t == _i9odpwsh.BaseEntity) {
      return _i9odpwsh.BaseEntity.fromJson(data) as T;
    }
    if (t == _ir6jlp3k.ParentEntity) {
      return _ir6jlp3k.ParentEntity.fromJson(data) as T;
    }
    if (t == _igefthms.NonServerOnlyParentClass) {
      return _igefthms.NonServerOnlyParentClass.fromJson(data) as T;
    }
    if (t == _iauswj59.ParentWithChangedId) {
      return _iauswj59.ParentWithChangedId.fromJson(data) as T;
    }
    if (t == _iitvxe69.ParentWithDefault) {
      return _iitvxe69.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _ipndfib1.PolymorphicGrandChild) {
      return _ipndfib1.PolymorphicGrandChild.fromJson(data) as T;
    }
    if (t == _i11uofdz.PolymorphicChild) {
      return _i11uofdz.PolymorphicChild.fromJson(data) as T;
    }
    if (t == _iqb6eppn.PolymorphicChildContainer) {
      return _iqb6eppn.PolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _iw07om20.ModulePolymorphicChildContainer) {
      return _iw07om20.ModulePolymorphicChildContainer.fromJson(data) as T;
    }
    if (t == _icfkf6u0.SimilarButNotParent) {
      return _icfkf6u0.SimilarButNotParent.fromJson(data) as T;
    }
    if (t == _i5oq3fsk.PolymorphicParent) {
      return _i5oq3fsk.PolymorphicParent.fromJson(data) as T;
    }
    if (t == _ih2dgm3r.UnrelatedToPolymorphism) {
      return _ih2dgm3r.UnrelatedToPolymorphism.fromJson(data) as T;
    }
    if (t == _ij7m744x.SealedGrandChild) {
      return _ij7m744x.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _ij7m744x.SealedChild) {
      return _ij7m744x.SealedChild.fromJson(data) as T;
    }
    if (t == _iwv9x21d.SealedChildOnlyRequired) {
      return _iwv9x21d.SealedChildOnlyRequired.fromJson(data) as T;
    }
    if (t == _ij7m744x.SealedOtherChild) {
      return _ij7m744x.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _iycanyn2.CityWithLongTableName) {
      return _iycanyn2.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _ifbzwpkm.OrganizationWithLongTableName) {
      return _ifbzwpkm.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _iy2gklrg.PersonWithLongTableName) {
      return _iy2gklrg.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i37b4f1x.MaxFieldName) {
      return _i37b4f1x.MaxFieldName.fromJson(data) as T;
    }
    if (t == _ilm8ux21.LongImplicitIdField) {
      return _ilm8ux21.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i5zyye9l.LongImplicitIdFieldCollection) {
      return _i5zyye9l.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _irdava0x.RelationToMultipleMaxFieldName) {
      return _irdava0x.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i14q426c.UserNote) {
      return _i14q426c.UserNote.fromJson(data) as T;
    }
    if (t == _i0cmztzz.UserNoteCollection) {
      return _i0cmztzz.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _ivgcl1bh.UserNoteCollectionWithALongName) {
      return _ivgcl1bh.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i7zqea9a.UserNoteWithALongName) {
      return _i7zqea9a.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _ify1vf7h.MultipleMaxFieldName) {
      return _ify1vf7h.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i0i33txy.City) {
      return _i0i33txy.City.fromJson(data) as T;
    }
    if (t == _iffzpgud.Organization) {
      return _iffzpgud.Organization.fromJson(data) as T;
    }
    if (t == _i9x7ls0c.Person) {
      return _i9x7ls0c.Person.fromJson(data) as T;
    }
    if (t == _iepu1h7u.BleedChild) {
      return _iepu1h7u.BleedChild.fromJson(data) as T;
    }
    if (t == _ipkncx5k.BleedRoot) {
      return _ipkncx5k.BleedRoot.fromJson(data) as T;
    }
    if (t == _ilvqc6dx.GeneratedRelationCompany) {
      return _ilvqc6dx.GeneratedRelationCompany.fromJson(data) as T;
    }
    if (t == _i3ralext.GeneratedRelationEmployee) {
      return _i3ralext.GeneratedRelationEmployee.fromJson(data) as T;
    }
    if (t == _isfv2yco.GeneratedRelationOffice) {
      return _isfv2yco.GeneratedRelationOffice.fromJson(data) as T;
    }
    if (t == _iy2buo88.Course) {
      return _iy2buo88.Course.fromJson(data) as T;
    }
    if (t == _i8v11x6h.Enrollment) {
      return _i8v11x6h.Enrollment.fromJson(data) as T;
    }
    if (t == _ig5mtn0e.Student) {
      return _ig5mtn0e.Student.fromJson(data) as T;
    }
    if (t == _ian3gu05.ObjectUser) {
      return _ian3gu05.ObjectUser.fromJson(data) as T;
    }
    if (t == _i1h6ufx7.ParentUser) {
      return _i1h6ufx7.ParentUser.fromJson(data) as T;
    }
    if (t == _ikwieien.Arena) {
      return _ikwieien.Arena.fromJson(data) as T;
    }
    if (t == _ip8wmh4s.Player) {
      return _ip8wmh4s.Player.fromJson(data) as T;
    }
    if (t == _ifa5hwxy.Team) {
      return _ifa5hwxy.Team.fromJson(data) as T;
    }
    if (t == _ii7cxuye.Comment) {
      return _ii7cxuye.Comment.fromJson(data) as T;
    }
    if (t == _i1nwi4iv.Customer) {
      return _i1nwi4iv.Customer.fromJson(data) as T;
    }
    if (t == _if51mnnb.Book) {
      return _if51mnnb.Book.fromJson(data) as T;
    }
    if (t == _itdsc4u0.Chapter) {
      return _itdsc4u0.Chapter.fromJson(data) as T;
    }
    if (t == _is5jy3ez.Order) {
      return _is5jy3ez.Order.fromJson(data) as T;
    }
    if (t == _i6uupgbr.Address) {
      return _i6uupgbr.Address.fromJson(data) as T;
    }
    if (t == _igeuyxnu.Citizen) {
      return _igeuyxnu.Citizen.fromJson(data) as T;
    }
    if (t == _if6srpch.Company) {
      return _if6srpch.Company.fromJson(data) as T;
    }
    if (t == _igjnmbwc.Town) {
      return _igjnmbwc.Town.fromJson(data) as T;
    }
    if (t == _ic5jbe8i.Blocking) {
      return _ic5jbe8i.Blocking.fromJson(data) as T;
    }
    if (t == _ijj92mp1.Member) {
      return _ijj92mp1.Member.fromJson(data) as T;
    }
    if (t == _ib9keugy.Cat) {
      return _ib9keugy.Cat.fromJson(data) as T;
    }
    if (t == _iyh1zt5l.Post) {
      return _iyh1zt5l.Post.fromJson(data) as T;
    }
    if (t == _ikm3lhvl.ModuleDatatype) {
      return _ikm3lhvl.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i6x889hl.MyFeatureModel) {
      return _i6x889hl.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i47v6vne.MyTriggerType) {
      return _i47v6vne.MyTriggerType.fromJson(data) as T;
    }
    if (t == _il5sr7xc.Nullability) {
      return _il5sr7xc.Nullability.fromJson(data) as T;
    }
    if (t == _iz2gvrid.NullsDistinctData) {
      return _iz2gvrid.NullsDistinctData.fromJson(data) as T;
    }
    if (t == _i9ffbppf.ObjectFieldPersist) {
      return _i9ffbppf.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _iahgl0he.ObjectFieldScopes) {
      return _iahgl0he.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _ioxr67zo.ObjectWithBit) {
      return _ioxr67zo.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _iz58zhle.ObjectWithByteData) {
      return _iz58zhle.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i6zp404a.ObjectWithCustomClass) {
      return _i6zp404a.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _ijtijns8.ObjectWithDuration) {
      return _ijtijns8.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i9hzn3wb.ObjectWithDynamic) {
      return _i9hzn3wb.ObjectWithDynamic.fromJson(data) as T;
    }
    if (t == _ip2vqluy.ObjectWithEnum) {
      return _ip2vqluy.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _iwdrmoge.ObjectWithEnumEnhanced) {
      return _iwdrmoge.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _io7bb4tk.ObjectWithGeographyGeometryCollection) {
      return _io7bb4tk.ObjectWithGeographyGeometryCollection.fromJson(data)
          as T;
    }
    if (t == _icdfatkc.ObjectWithGeographyLineString) {
      return _icdfatkc.ObjectWithGeographyLineString.fromJson(data) as T;
    }
    if (t == _i2wdw9b4.ObjectWithGeographyPoint) {
      return _i2wdw9b4.ObjectWithGeographyPoint.fromJson(data) as T;
    }
    if (t == _ignhorhm.ObjectWithGeographyPolygon) {
      return _ignhorhm.ObjectWithGeographyPolygon.fromJson(data) as T;
    }
    if (t == _iy6ksgxz.ObjectWithHalfVector) {
      return _iy6ksgxz.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _inemzov5.ObjectWithIndex) {
      return _inemzov5.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _ihyvenpw.ObjectWithJsonb) {
      return _ihyvenpw.ObjectWithJsonb.fromJson(data) as T;
    }
    if (t == _i4p0t2g0.ObjectWithJsonbClassLevel) {
      return _i4p0t2g0.ObjectWithJsonbClassLevel.fromJson(data) as T;
    }
    if (t == _i26q9u41.ObjectWithMaps) {
      return _i26q9u41.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i2qtgitl.ObjectWithNullableCustomClass) {
      return _i2qtgitl.ObjectWithNullableCustomClass.fromJson(data) as T;
    }
    if (t == _i4hr2e9p.ObjectWithObject) {
      return _i4hr2e9p.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _io0t3u2c.ObjectWithParent) {
      return _io0t3u2c.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _im4j7lpz.ObjectWithSealedClass) {
      return _im4j7lpz.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _itdevv9e.ObjectWithSealedException) {
      return _itdevv9e.ObjectWithSealedException.fromJson(data) as T;
    }
    if (t == _ihluvkmz.ObjectWithSelfParent) {
      return _ihluvkmz.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i8t20dyr.ObjectWithSparseVector) {
      return _i8t20dyr.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _iusk9w05.ObjectWithUuid) {
      return _iusk9w05.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _itmc4j9i.ObjectWithVector) {
      return _itmc4j9i.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _ificmsie.Record) {
      return _ificmsie.Record.fromJson(data) as T;
    }
    if (t == _i2aw39a6.RelatedUniqueData) {
      return _i2aw39a6.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _iiggggl6.ExceptionWithRequiredField) {
      return _iiggggl6.ExceptionWithRequiredField.fromJson(data) as T;
    }
    if (t == _iv7egjxb.ModelWithRequiredField) {
      return _iv7egjxb.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _ixhyrkj6.ScopeNoneFields) {
      return _ixhyrkj6.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _igfnl8bc.ScopeServerOnlyFieldChild) {
      return _igfnl8bc.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _it7f5mv0.ScopeServerOnlyField) {
      return _it7f5mv0.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _ilchwovc.Article) {
      return _ilchwovc.Article.fromJson(data) as T;
    }
    if (t == _ip3v2qu9.ArticleList) {
      return _ip3v2qu9.ArticleList.fromJson(data) as T;
    }
    if (t == _i8lxkh3j.DefaultServerOnlyClass) {
      return _i8lxkh3j.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i96dkulb.DefaultServerOnlyEnum) {
      return _i96dkulb.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _ilb1g1z5.NotServerOnlyClass) {
      return _ilb1g1z5.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _ik117x9c.NotServerOnlyEnum) {
      return _ik117x9c.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _ijh817kc.ServerOnlyClass) {
      return _ijh817kc.ServerOnlyClass.fromJson(data) as T;
    }
    if (t == _iuyjh56c.ServerOnlyEnum) {
      return _iuyjh56c.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _izzkyevr.ServerOnlyClassField) {
      return _izzkyevr.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _iy81tiee.ServerOnlyDefault) {
      return _iy81tiee.ServerOnlyDefault.fromJson(data) as T;
    }
    if (t == _iz7kinop.SessionAuthInfo) {
      return _iz7kinop.SessionAuthInfo.fromJson(data) as T;
    }
    if (t == _icmi6q0i.SharedModelContainer) {
      return _icmi6q0i.SharedModelContainer.fromJson(data) as T;
    }
    if (t == _iu5vt3uc.SharedModelSubclass) {
      return _iu5vt3uc.SharedModelSubclass.fromJson(data) as T;
    }
    if (t == _i0zisc0t.SimpleData) {
      return _i0zisc0t.SimpleData.fromJson(data) as T;
    }
    if (t == _iyexv7xa.SimpleDataList) {
      return _iyexv7xa.SimpleDataList.fromJson(data) as T;
    }
    if (t == _iu6b143l.SimpleDataMap) {
      return _iu6b143l.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _ikkvbzqw.SimpleDataObject) {
      return _ikkvbzqw.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i1duz4kf.SimpleDateTime) {
      return _i1duz4kf.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _il2trryf.ModelInSubfolder) {
      return _il2trryf.ModelInSubfolder.fromJson(data) as T;
    }
    if (t == _ionapfu9.TestEnum) {
      return _ionapfu9.TestEnum.fromJson(data) as T;
    }
    if (t == _icplrpi3.TestEnumDefaultSerialization) {
      return _icplrpi3.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _it39smib.TestEnumEnhanced) {
      return _it39smib.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _izw460bh.TestEnumEnhancedByName) {
      return _izw460bh.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i7liykk2.TestEnumStringified) {
      return _i7liykk2.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _iwxwszsz.Types) {
      return _iwxwszsz.Types.fromJson(data) as T;
    }
    if (t == _irfb5ten.TypesList) {
      return _irfb5ten.TypesList.fromJson(data) as T;
    }
    if (t == _i81vljk7.TypesMap) {
      return _i81vljk7.TypesMap.fromJson(data) as T;
    }
    if (t == _irmygd7t.TypesRecord) {
      return _irmygd7t.TypesRecord.fromJson(data) as T;
    }
    if (t == _iiutqksg.TypesSet) {
      return _iiutqksg.TypesSet.fromJson(data) as T;
    }
    if (t == _ir494j8f.TypesSetRequired) {
      return _ir494j8f.TypesSetRequired.fromJson(data) as T;
    }
    if (t == _iufhyrjh.UniqueData) {
      return _iufhyrjh.UniqueData.fromJson(data) as T;
    }
    if (t == _ip8yzqii.UniqueDataWithNonPersist) {
      return _ip8yzqii.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _iwbeyn4p.UpsertTestModel) {
      return _iwbeyn4p.UpsertTestModel.fromJson(data) as T;
    }
    if (t == _is.getType<_ihs9bjzx.ByIndexEnumWithNameValue?>()) {
      return (data != null
              ? _ihs9bjzx.ByIndexEnumWithNameValue.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwdug2n0.ByNameEnumWithNameValue?>()) {
      return (data != null
              ? _iwdug2n0.ByNameEnumWithNameValue.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ik6ri27s.CourseUuid?>()) {
      return (data != null ? _ik6ri27s.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icdgc05t.EnrollmentInt?>()) {
      return (data != null ? _icdgc05t.EnrollmentInt.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ibrjea6w.StudentUuid?>()) {
      return (data != null ? _ibrjea6w.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_isj7c5mo.ArenaUuid?>()) {
      return (data != null ? _isj7c5mo.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivdpnfmj.PlayerUuid?>()) {
      return (data != null ? _ivdpnfmj.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ivehlt2f.TeamInt?>()) {
      return (data != null ? _ivehlt2f.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i3jtpxta.CommentInt?>()) {
      return (data != null ? _i3jtpxta.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iimgofmw.CustomerInt?>()) {
      return (data != null ? _iimgofmw.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iywnby31.OrderUuid?>()) {
      return (data != null ? _iywnby31.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifwqt4rb.AddressUuid?>()) {
      return (data != null ? _ifwqt4rb.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_idhvg1zk.CitizenInt?>()) {
      return (data != null ? _idhvg1zk.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5vwm04a.CompanyUuid?>()) {
      return (data != null ? _i5vwm04a.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iu7osokh.TownInt?>()) {
      return (data != null ? _iu7osokh.TownInt.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixc9sah8.ChangedIdTypeSelf?>()) {
      return (data != null ? _ixc9sah8.ChangedIdTypeSelf.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_irw3jmaq.ServerOnlyChangedIdFieldClass?>()) {
      return (data != null
              ? _irw3jmaq.ServerOnlyChangedIdFieldClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_icrmubzc.BigIntDefault?>()) {
      return (data != null ? _icrmubzc.BigIntDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1xsun18.BigIntDefaultMix?>()) {
      return (data != null ? _i1xsun18.BigIntDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i332rqur.BigIntDefaultModel?>()) {
      return (data != null ? _i332rqur.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ia4nw21o.BigIntDefaultPersist?>()) {
      return (data != null
              ? _ia4nw21o.BigIntDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilirabmz.BoolDefault?>()) {
      return (data != null ? _ilirabmz.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwhzartq.BoolDefaultMix?>()) {
      return (data != null ? _iwhzartq.BoolDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izvr7tnf.BoolDefaultModel?>()) {
      return (data != null ? _izvr7tnf.BoolDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i135uugo.BoolDefaultPersist?>()) {
      return (data != null ? _i135uugo.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iro0mlkq.DateTimeDefault?>()) {
      return (data != null ? _iro0mlkq.DateTimeDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igjm2894.DateTimeDefaultMix?>()) {
      return (data != null ? _igjm2894.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivkcoq83.DateTimeDefaultModel?>()) {
      return (data != null
              ? _ivkcoq83.DateTimeDefaultModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iaqar0o9.DateTimeDefaultPersist?>()) {
      return (data != null
              ? _iaqar0o9.DateTimeDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izu05ym4.DoubleDefault?>()) {
      return (data != null ? _izu05ym4.DoubleDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iou6kksr.DoubleDefaultMix?>()) {
      return (data != null ? _iou6kksr.DoubleDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9xv7g6i.DoubleDefaultModel?>()) {
      return (data != null ? _i9xv7g6i.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iynhhcdw.DoubleDefaultPersist?>()) {
      return (data != null
              ? _iynhhcdw.DoubleDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ixvw8l6s.DurationDefault?>()) {
      return (data != null ? _ixvw8l6s.DurationDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ialx1ytx.DurationDefaultMix?>()) {
      return (data != null ? _ialx1ytx.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5aouk9m.DurationDefaultModel?>()) {
      return (data != null
              ? _i5aouk9m.DurationDefaultModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij5e1q2b.DurationDefaultPersist?>()) {
      return (data != null
              ? _ij5e1q2b.DurationDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihqxpva2.EnumDefault?>()) {
      return (data != null ? _ihqxpva2.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyezrrxn.EnumDefaultMix?>()) {
      return (data != null ? _iyezrrxn.EnumDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iw4wb1ju.EnumDefaultModel?>()) {
      return (data != null ? _iw4wb1ju.EnumDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i0p9yn0v.EnumDefaultPersist?>()) {
      return (data != null ? _i0p9yn0v.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4ekvn16.ByIndexEnum?>()) {
      return (data != null ? _i4ekvn16.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ihrgmscf.ByNameEnum?>()) {
      return (data != null ? _ihrgmscf.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iirkfcfb.DefaultValueEnum?>()) {
      return (data != null ? _iirkfcfb.DefaultValueEnum.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iv40kyzq.DefaultException?>()) {
      return (data != null ? _iv40kyzq.DefaultException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i8t3u1nx.IntDefault?>()) {
      return (data != null ? _i8t3u1nx.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iummzlp0.IntDefaultMix?>()) {
      return (data != null ? _iummzlp0.IntDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4rypx08.IntDefaultModel?>()) {
      return (data != null ? _i4rypx08.IntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_imhmhhwa.IntDefaultPersist?>()) {
      return (data != null ? _imhmhhwa.IntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4d8z6ds.StringDefault?>()) {
      return (data != null ? _i4d8z6ds.StringDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu6k5fkj.StringDefaultMix?>()) {
      return (data != null ? _iu6k5fkj.StringDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihmqo6od.StringDefaultModel?>()) {
      return (data != null ? _ihmqo6od.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ih6giyf6.StringDefaultPersist?>()) {
      return (data != null
              ? _ih6giyf6.StringDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2y701qf.UriDefault?>()) {
      return (data != null ? _i2y701qf.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iib8h1yl.UriDefaultMix?>()) {
      return (data != null ? _iib8h1yl.UriDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1to0y5o.UriDefaultModel?>()) {
      return (data != null ? _i1to0y5o.UriDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_isi15w9f.UriDefaultPersist?>()) {
      return (data != null ? _isi15w9f.UriDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihsadwhl.UuidDefault?>()) {
      return (data != null ? _ihsadwhl.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ignwr848.UuidDefaultMix?>()) {
      return (data != null ? _ignwr848.UuidDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i15gwzho.UuidDefaultModel?>()) {
      return (data != null ? _i15gwzho.UuidDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2v866bf.UuidDefaultPersist?>()) {
      return (data != null ? _i2v866bf.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_io8dlrxh.DeferrableRelationInitiallyDeferred?>()) {
      return (data != null
              ? _io8dlrxh.DeferrableRelationInitiallyDeferred.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inmfeda2.DeferrableRelationInitiallyImmediate?>()) {
      return (data != null
              ? _inmfeda2.DeferrableRelationInitiallyImmediate.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_izxfibiy.DeferrableRelationParent?>()) {
      return (data != null
              ? _izxfibiy.DeferrableRelationParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i9l9xrkt.EmptyModel?>()) {
      return (data != null ? _i9l9xrkt.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikufh0vd.EmptyModelRelationItem?>()) {
      return (data != null
              ? _ikufh0vd.EmptyModelRelationItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iw4y4x6s.EmptyModelWithTable?>()) {
      return (data != null
              ? _iw4y4x6s.EmptyModelWithTable.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy7bezig.RelationEmptyModel?>()) {
      return (data != null ? _iy7bezig.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_is77lrdb.ExceptionWithData?>()) {
      return (data != null ? _is77lrdb.ExceptionWithData.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikh95zxc.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _ikh95zxc.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i1y2idkw.NonTableParentClass?>()) {
      return (data != null
              ? _i1y2idkw.NonTableParentClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7hqkfn7.ModifiedColumnName?>()) {
      return (data != null ? _i7hqkfn7.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ix2lcsu0.Department?>()) {
      return (data != null ? _ix2lcsu0.Department.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ixlcmx78.Employee?>()) {
      return (data != null ? _ixlcmx78.Employee.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iw4adtsk.Contractor?>()) {
      return (data != null ? _iw4adtsk.Contractor.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i83a3u3u.Service?>()) {
      return (data != null ? _i83a3u3u.Service.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iox92era.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _iox92era.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ip57k4t4.TestGeneratedCallByeModel?>()) {
      return (data != null
              ? _ip57k4t4.TestGeneratedCallByeModel.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_ilmnz413.TestGeneratedCallExecuteWithTriggerModel?>()) {
      return (data != null
              ? _ilmnz413.TestGeneratedCallExecuteWithTriggerModel.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_ifspsmem.TestGeneratedCallHelloModel?>()) {
      return (data != null
              ? _ifspsmem.TestGeneratedCallHelloModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3yv7lzj.TestGeneratedCallInvokeModel?>()) {
      return (data != null
              ? _i3yv7lzj.TestGeneratedCallInvokeModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isas41s9.ImmutableChildObject?>()) {
      return (data != null
              ? _isas41s9.ImmutableChildObject.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_i8ali8rk.ImmutableChildObjectWithNoAdditionalFields?>()) {
      return (data != null
              ? _i8ali8rk.ImmutableChildObjectWithNoAdditionalFields.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_ib4436rb.ImmutableObject?>()) {
      return (data != null ? _ib4436rb.ImmutableObject.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i5o8gk0d.ImmutableObjectWithImmutableObject?>()) {
      return (data != null
              ? _i5o8gk0d.ImmutableObjectWithImmutableObject.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifcovr71.ImmutableObjectWithList?>()) {
      return (data != null
              ? _ifcovr71.ImmutableObjectWithList.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7chvx7t.ImmutableObjectWithMap?>()) {
      return (data != null
              ? _i7chvx7t.ImmutableObjectWithMap.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijpel12b.ImmutableObjectWithMultipleFields?>()) {
      return (data != null
              ? _ijpel12b.ImmutableObjectWithMultipleFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_im6ib46o.ImmutableObjectWithNoFields?>()) {
      return (data != null
              ? _im6ib46o.ImmutableObjectWithNoFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iz0jdatm.ImmutableObjectWithRecord?>()) {
      return (data != null
              ? _iz0jdatm.ImmutableObjectWithRecord.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij73d01s.ImmutableObjectWithTable?>()) {
      return (data != null
              ? _ij73d01s.ImmutableObjectWithTable.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i6bj8wy3.ImmutableObjectWithTwentyFields?>()) {
      return (data != null
              ? _i6bj8wy3.ImmutableObjectWithTwentyFields.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ix35kamj.ChildClass?>()) {
      return (data != null ? _ix35kamj.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_inmco1xt.ServerOnlyChildClass?>()) {
      return (data != null
              ? _inmco1xt.ServerOnlyChildClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ibdvdtnv.ChildWithDefault?>()) {
      return (data != null ? _ibdvdtnv.ChildWithDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ieeasgju.ChildWithInheritedId?>()) {
      return (data != null
              ? _ieeasgju.ChildWithInheritedId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i57yjwwl.ChildClassWithoutId?>()) {
      return (data != null
              ? _i57yjwwl.ChildClassWithoutId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihtrmue0.ServerOnlyChildClassWithoutId?>()) {
      return (data != null
              ? _ihtrmue0.ServerOnlyChildClassWithoutId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i4ydso50.ExtendedAppException?>()) {
      return (data != null
              ? _i4ydso50.ExtendedAppException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iw7pve41.BaseAppException?>()) {
      return (data != null ? _iw7pve41.BaseAppException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iaxkp5y4.NotFoundException?>()) {
      return (data != null ? _iaxkp5y4.NotFoundException.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iaxkp5y4.ValidationException?>()) {
      return (data != null
              ? _iaxkp5y4.ValidationException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_io7upog0.ParentClass?>()) {
      return (data != null ? _io7upog0.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i5sz4l10.GrandparentClass?>()) {
      return (data != null ? _i5sz4l10.GrandparentClass.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijexcijb.ParentClassWithoutId?>()) {
      return (data != null
              ? _ijexcijb.ParentClassWithoutId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iolet7jc.GrandparentClassWithId?>()) {
      return (data != null
              ? _iolet7jc.GrandparentClassWithId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2aipqpt.ChildEntity?>()) {
      return (data != null ? _i2aipqpt.ChildEntity.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9odpwsh.BaseEntity?>()) {
      return (data != null ? _i9odpwsh.BaseEntity.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ir6jlp3k.ParentEntity?>()) {
      return (data != null ? _ir6jlp3k.ParentEntity.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igefthms.NonServerOnlyParentClass?>()) {
      return (data != null
              ? _igefthms.NonServerOnlyParentClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iauswj59.ParentWithChangedId?>()) {
      return (data != null
              ? _iauswj59.ParentWithChangedId.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iitvxe69.ParentWithDefault?>()) {
      return (data != null ? _iitvxe69.ParentWithDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ipndfib1.PolymorphicGrandChild?>()) {
      return (data != null
              ? _ipndfib1.PolymorphicGrandChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i11uofdz.PolymorphicChild?>()) {
      return (data != null ? _i11uofdz.PolymorphicChild.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iqb6eppn.PolymorphicChildContainer?>()) {
      return (data != null
              ? _iqb6eppn.PolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iw07om20.ModulePolymorphicChildContainer?>()) {
      return (data != null
              ? _iw07om20.ModulePolymorphicChildContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_icfkf6u0.SimilarButNotParent?>()) {
      return (data != null
              ? _icfkf6u0.SimilarButNotParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5oq3fsk.PolymorphicParent?>()) {
      return (data != null ? _i5oq3fsk.PolymorphicParent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ih2dgm3r.UnrelatedToPolymorphism?>()) {
      return (data != null
              ? _ih2dgm3r.UnrelatedToPolymorphism.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij7m744x.SealedGrandChild?>()) {
      return (data != null ? _ij7m744x.SealedGrandChild.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ij7m744x.SealedChild?>()) {
      return (data != null ? _ij7m744x.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iwv9x21d.SealedChildOnlyRequired?>()) {
      return (data != null
              ? _iwv9x21d.SealedChildOnlyRequired.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ij7m744x.SealedOtherChild?>()) {
      return (data != null ? _ij7m744x.SealedOtherChild.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iycanyn2.CityWithLongTableName?>()) {
      return (data != null
              ? _iycanyn2.CityWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ifbzwpkm.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _ifbzwpkm.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy2gklrg.PersonWithLongTableName?>()) {
      return (data != null
              ? _iy2gklrg.PersonWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i37b4f1x.MaxFieldName?>()) {
      return (data != null ? _i37b4f1x.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilm8ux21.LongImplicitIdField?>()) {
      return (data != null
              ? _ilm8ux21.LongImplicitIdField.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i5zyye9l.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i5zyye9l.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_irdava0x.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _irdava0x.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i14q426c.UserNote?>()) {
      return (data != null ? _i14q426c.UserNote.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i0cmztzz.UserNoteCollection?>()) {
      return (data != null ? _i0cmztzz.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ivgcl1bh.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _ivgcl1bh.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7zqea9a.UserNoteWithALongName?>()) {
      return (data != null
              ? _i7zqea9a.UserNoteWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ify1vf7h.MultipleMaxFieldName?>()) {
      return (data != null
              ? _ify1vf7h.MultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i0i33txy.City?>()) {
      return (data != null ? _i0i33txy.City.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iffzpgud.Organization?>()) {
      return (data != null ? _iffzpgud.Organization.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i9x7ls0c.Person?>()) {
      return (data != null ? _i9x7ls0c.Person.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iepu1h7u.BleedChild?>()) {
      return (data != null ? _iepu1h7u.BleedChild.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ipkncx5k.BleedRoot?>()) {
      return (data != null ? _ipkncx5k.BleedRoot.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilvqc6dx.GeneratedRelationCompany?>()) {
      return (data != null
              ? _ilvqc6dx.GeneratedRelationCompany.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i3ralext.GeneratedRelationEmployee?>()) {
      return (data != null
              ? _i3ralext.GeneratedRelationEmployee.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_isfv2yco.GeneratedRelationOffice?>()) {
      return (data != null
              ? _isfv2yco.GeneratedRelationOffice.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy2buo88.Course?>()) {
      return (data != null ? _iy2buo88.Course.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8v11x6h.Enrollment?>()) {
      return (data != null ? _i8v11x6h.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ig5mtn0e.Student?>()) {
      return (data != null ? _ig5mtn0e.Student.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ian3gu05.ObjectUser?>()) {
      return (data != null ? _ian3gu05.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1h6ufx7.ParentUser?>()) {
      return (data != null ? _i1h6ufx7.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikwieien.Arena?>()) {
      return (data != null ? _ikwieien.Arena.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip8wmh4s.Player?>()) {
      return (data != null ? _ip8wmh4s.Player.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ifa5hwxy.Team?>()) {
      return (data != null ? _ifa5hwxy.Team.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ii7cxuye.Comment?>()) {
      return (data != null ? _ii7cxuye.Comment.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i1nwi4iv.Customer?>()) {
      return (data != null ? _i1nwi4iv.Customer.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_if51mnnb.Book?>()) {
      return (data != null ? _if51mnnb.Book.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_itdsc4u0.Chapter?>()) {
      return (data != null ? _itdsc4u0.Chapter.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_is5jy3ez.Order?>()) {
      return (data != null ? _is5jy3ez.Order.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i6uupgbr.Address?>()) {
      return (data != null ? _i6uupgbr.Address.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igeuyxnu.Citizen?>()) {
      return (data != null ? _igeuyxnu.Citizen.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_if6srpch.Company?>()) {
      return (data != null ? _if6srpch.Company.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_igjnmbwc.Town?>()) {
      return (data != null ? _igjnmbwc.Town.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ic5jbe8i.Blocking?>()) {
      return (data != null ? _ic5jbe8i.Blocking.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ijj92mp1.Member?>()) {
      return (data != null ? _ijj92mp1.Member.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ib9keugy.Cat?>()) {
      return (data != null ? _ib9keugy.Cat.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyh1zt5l.Post?>()) {
      return (data != null ? _iyh1zt5l.Post.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ikm3lhvl.ModuleDatatype?>()) {
      return (data != null ? _ikm3lhvl.ModuleDatatype.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6x889hl.MyFeatureModel?>()) {
      return (data != null ? _i6x889hl.MyFeatureModel.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i47v6vne.MyTriggerType?>()) {
      return (data != null ? _i47v6vne.MyTriggerType.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il5sr7xc.Nullability?>()) {
      return (data != null ? _il5sr7xc.Nullability.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iz2gvrid.NullsDistinctData?>()) {
      return (data != null ? _iz2gvrid.NullsDistinctData.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9ffbppf.ObjectFieldPersist?>()) {
      return (data != null ? _i9ffbppf.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iahgl0he.ObjectFieldScopes?>()) {
      return (data != null ? _iahgl0he.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ioxr67zo.ObjectWithBit?>()) {
      return (data != null ? _ioxr67zo.ObjectWithBit.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iz58zhle.ObjectWithByteData?>()) {
      return (data != null ? _iz58zhle.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i6zp404a.ObjectWithCustomClass?>()) {
      return (data != null
              ? _i6zp404a.ObjectWithCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ijtijns8.ObjectWithDuration?>()) {
      return (data != null ? _ijtijns8.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i9hzn3wb.ObjectWithDynamic?>()) {
      return (data != null ? _i9hzn3wb.ObjectWithDynamic.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ip2vqluy.ObjectWithEnum?>()) {
      return (data != null ? _ip2vqluy.ObjectWithEnum.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iwdrmoge.ObjectWithEnumEnhanced?>()) {
      return (data != null
              ? _iwdrmoge.ObjectWithEnumEnhanced.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_io7bb4tk.ObjectWithGeographyGeometryCollection?>()) {
      return (data != null
              ? _io7bb4tk.ObjectWithGeographyGeometryCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_icdfatkc.ObjectWithGeographyLineString?>()) {
      return (data != null
              ? _icdfatkc.ObjectWithGeographyLineString.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i2wdw9b4.ObjectWithGeographyPoint?>()) {
      return (data != null
              ? _i2wdw9b4.ObjectWithGeographyPoint.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ignhorhm.ObjectWithGeographyPolygon?>()) {
      return (data != null
              ? _ignhorhm.ObjectWithGeographyPolygon.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy6ksgxz.ObjectWithHalfVector?>()) {
      return (data != null
              ? _iy6ksgxz.ObjectWithHalfVector.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_inemzov5.ObjectWithIndex?>()) {
      return (data != null ? _inemzov5.ObjectWithIndex.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ihyvenpw.ObjectWithJsonb?>()) {
      return (data != null ? _ihyvenpw.ObjectWithJsonb.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i4p0t2g0.ObjectWithJsonbClassLevel?>()) {
      return (data != null
              ? _i4p0t2g0.ObjectWithJsonbClassLevel.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i26q9u41.ObjectWithMaps?>()) {
      return (data != null ? _i26q9u41.ObjectWithMaps.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i2qtgitl.ObjectWithNullableCustomClass?>()) {
      return (data != null
              ? _i2qtgitl.ObjectWithNullableCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i4hr2e9p.ObjectWithObject?>()) {
      return (data != null ? _i4hr2e9p.ObjectWithObject.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_io0t3u2c.ObjectWithParent?>()) {
      return (data != null ? _io0t3u2c.ObjectWithParent.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_im4j7lpz.ObjectWithSealedClass?>()) {
      return (data != null
              ? _im4j7lpz.ObjectWithSealedClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_itdevv9e.ObjectWithSealedException?>()) {
      return (data != null
              ? _itdevv9e.ObjectWithSealedException.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ihluvkmz.ObjectWithSelfParent?>()) {
      return (data != null
              ? _ihluvkmz.ObjectWithSelfParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i8t20dyr.ObjectWithSparseVector?>()) {
      return (data != null
              ? _i8t20dyr.ObjectWithSparseVector.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iusk9w05.ObjectWithUuid?>()) {
      return (data != null ? _iusk9w05.ObjectWithUuid.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_itmc4j9i.ObjectWithVector?>()) {
      return (data != null ? _itmc4j9i.ObjectWithVector.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ificmsie.Record?>()) {
      return (data != null ? _ificmsie.Record.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i2aw39a6.RelatedUniqueData?>()) {
      return (data != null ? _i2aw39a6.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iiggggl6.ExceptionWithRequiredField?>()) {
      return (data != null
              ? _iiggggl6.ExceptionWithRequiredField.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iv7egjxb.ModelWithRequiredField?>()) {
      return (data != null
              ? _iv7egjxb.ModelWithRequiredField.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ixhyrkj6.ScopeNoneFields?>()) {
      return (data != null ? _ixhyrkj6.ScopeNoneFields.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_igfnl8bc.ScopeServerOnlyFieldChild?>()) {
      return (data != null
              ? _igfnl8bc.ScopeServerOnlyFieldChild.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it7f5mv0.ScopeServerOnlyField?>()) {
      return (data != null
              ? _it7f5mv0.ScopeServerOnlyField.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilchwovc.Article?>()) {
      return (data != null ? _ilchwovc.Article.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip3v2qu9.ArticleList?>()) {
      return (data != null ? _ip3v2qu9.ArticleList.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i8lxkh3j.DefaultServerOnlyClass?>()) {
      return (data != null
              ? _i8lxkh3j.DefaultServerOnlyClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i96dkulb.DefaultServerOnlyEnum?>()) {
      return (data != null
              ? _i96dkulb.DefaultServerOnlyEnum.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilb1g1z5.NotServerOnlyClass?>()) {
      return (data != null ? _ilb1g1z5.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ik117x9c.NotServerOnlyEnum?>()) {
      return (data != null ? _ik117x9c.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ijh817kc.ServerOnlyClass?>()) {
      return (data != null ? _ijh817kc.ServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iuyjh56c.ServerOnlyEnum?>()) {
      return (data != null ? _iuyjh56c.ServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izzkyevr.ServerOnlyClassField?>()) {
      return (data != null
              ? _izzkyevr.ServerOnlyClassField.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iy81tiee.ServerOnlyDefault?>()) {
      return (data != null ? _iy81tiee.ServerOnlyDefault.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iz7kinop.SessionAuthInfo?>()) {
      return (data != null ? _iz7kinop.SessionAuthInfo.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_icmi6q0i.SharedModelContainer?>()) {
      return (data != null
              ? _icmi6q0i.SharedModelContainer.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iu5vt3uc.SharedModelSubclass?>()) {
      return (data != null
              ? _iu5vt3uc.SharedModelSubclass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i0zisc0t.SimpleData?>()) {
      return (data != null ? _i0zisc0t.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iyexv7xa.SimpleDataList?>()) {
      return (data != null ? _iyexv7xa.SimpleDataList.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iu6b143l.SimpleDataMap?>()) {
      return (data != null ? _iu6b143l.SimpleDataMap.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ikkvbzqw.SimpleDataObject?>()) {
      return (data != null ? _ikkvbzqw.SimpleDataObject.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_i1duz4kf.SimpleDateTime?>()) {
      return (data != null ? _i1duz4kf.SimpleDateTime.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_il2trryf.ModelInSubfolder?>()) {
      return (data != null ? _il2trryf.ModelInSubfolder.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_ionapfu9.TestEnum?>()) {
      return (data != null ? _ionapfu9.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_icplrpi3.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _icplrpi3.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_it39smib.TestEnumEnhanced?>()) {
      return (data != null ? _it39smib.TestEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_izw460bh.TestEnumEnhancedByName?>()) {
      return (data != null
              ? _izw460bh.TestEnumEnhancedByName.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_i7liykk2.TestEnumStringified?>()) {
      return (data != null
              ? _i7liykk2.TestEnumStringified.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwxwszsz.Types?>()) {
      return (data != null ? _iwxwszsz.Types.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irfb5ten.TypesList?>()) {
      return (data != null ? _irfb5ten.TypesList.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_i81vljk7.TypesMap?>()) {
      return (data != null ? _i81vljk7.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_irmygd7t.TypesRecord?>()) {
      return (data != null ? _irmygd7t.TypesRecord.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_iiutqksg.TypesSet?>()) {
      return (data != null ? _iiutqksg.TypesSet.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ir494j8f.TypesSetRequired?>()) {
      return (data != null ? _ir494j8f.TypesSetRequired.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<_iufhyrjh.UniqueData?>()) {
      return (data != null ? _iufhyrjh.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ip8yzqii.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _ip8yzqii.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_iwbeyn4p.UpsertTestModel?>()) {
      return (data != null ? _iwbeyn4p.UpsertTestModel.fromJson(data) : null)
          as T;
    }
    if (t == List<_icdgc05t.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_icdgc05t.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_icdgc05t.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_icdgc05t.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ivdpnfmj.PlayerUuid>) {
      return (data as List)
              .map((e) => deserialize<_ivdpnfmj.PlayerUuid>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ivdpnfmj.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ivdpnfmj.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iywnby31.OrderUuid>) {
      return (data as List)
              .map((e) => deserialize<_iywnby31.OrderUuid>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_iywnby31.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iywnby31.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i3jtpxta.CommentInt>) {
      return (data as List)
              .map((e) => deserialize<_i3jtpxta.CommentInt>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i3jtpxta.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i3jtpxta.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ixc9sah8.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_ixc9sah8.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ixc9sah8.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ixc9sah8.ChangedIdTypeSelf>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ikufh0vd.EmptyModelRelationItem>) {
      return (data as List)
              .map((e) => deserialize<_ikufh0vd.EmptyModelRelationItem>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ikufh0vd.EmptyModelRelationItem>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_ikufh0vd.EmptyModelRelationItem>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ixlcmx78.Employee>) {
      return (data as List)
              .map((e) => deserialize<_ixlcmx78.Employee>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ixlcmx78.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ixlcmx78.Employee>(e))
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
    if (t == _is.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == List<_i2aipqpt.ChildEntity>) {
      return (data as List)
              .map((e) => deserialize<_i2aipqpt.ChildEntity>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i2aipqpt.ChildEntity>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i2aipqpt.ChildEntity>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i11uofdz.PolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_i11uofdz.PolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == List<_i11uofdz.PolymorphicChild?>) {
      return (data as List)
              .map((e) => deserialize<_i11uofdz.PolymorphicChild?>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i11uofdz.PolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i11uofdz.PolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i11uofdz.PolymorphicChild?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i11uofdz.PolymorphicChild?>(v),
            ),
          )
          as T;
    }
    if (t == List<_iom2gwyu.ModulePolymorphicChild>) {
      return (data as List)
              .map((e) => deserialize<_iom2gwyu.ModulePolymorphicChild>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _iom2gwyu.ModulePolymorphicChild>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_iom2gwyu.ModulePolymorphicChild>(v),
            ),
          )
          as T;
    }
    if (t == List<_iy2gklrg.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_iy2gklrg.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_iy2gklrg.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_iy2gklrg.PersonWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ifbzwpkm.OrganizationWithLongTableName>) {
      return (data as List)
              .map(
                (e) => deserialize<_ifbzwpkm.OrganizationWithLongTableName>(e),
              )
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ifbzwpkm.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<_ifbzwpkm.OrganizationWithLongTableName>(
                            e,
                          ),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ilm8ux21.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_ilm8ux21.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ilm8ux21.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ilm8ux21.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ify1vf7h.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_ify1vf7h.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ify1vf7h.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ify1vf7h.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i14q426c.UserNote>) {
      return (data as List)
              .map((e) => deserialize<_i14q426c.UserNote>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i14q426c.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i14q426c.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i7zqea9a.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i7zqea9a.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i7zqea9a.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7zqea9a.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i9x7ls0c.Person>) {
      return (data as List)
              .map((e) => deserialize<_i9x7ls0c.Person>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i9x7ls0c.Person>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9x7ls0c.Person>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iffzpgud.Organization>) {
      return (data as List)
              .map((e) => deserialize<_iffzpgud.Organization>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_iffzpgud.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iffzpgud.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i3ralext.GeneratedRelationEmployee>) {
      return (data as List)
              .map((e) => deserialize<_i3ralext.GeneratedRelationEmployee>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i3ralext.GeneratedRelationEmployee>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<_i3ralext.GeneratedRelationEmployee>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8v11x6h.Enrollment>) {
      return (data as List)
              .map((e) => deserialize<_i8v11x6h.Enrollment>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i8v11x6h.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8v11x6h.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ip8wmh4s.Player>) {
      return (data as List)
              .map((e) => deserialize<_ip8wmh4s.Player>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ip8wmh4s.Player>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ip8wmh4s.Player>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_is5jy3ez.Order>) {
      return (data as List).map((e) => deserialize<_is5jy3ez.Order>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_is5jy3ez.Order>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is5jy3ez.Order>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_itdsc4u0.Chapter>) {
      return (data as List)
              .map((e) => deserialize<_itdsc4u0.Chapter>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_itdsc4u0.Chapter>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_itdsc4u0.Chapter>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ii7cxuye.Comment>) {
      return (data as List)
              .map((e) => deserialize<_ii7cxuye.Comment>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ii7cxuye.Comment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ii7cxuye.Comment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ic5jbe8i.Blocking>) {
      return (data as List)
              .map((e) => deserialize<_ic5jbe8i.Blocking>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ic5jbe8i.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ic5jbe8i.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_ib9keugy.Cat>) {
      return (data as List).map((e) => deserialize<_ib9keugy.Cat>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_ib9keugy.Cat>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ib9keugy.Cat>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iom2gwyu.ModuleClass>) {
      return (data as List)
              .map((e) => deserialize<_iom2gwyu.ModuleClass>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _iom2gwyu.ModuleClass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_iom2gwyu.ModuleClass>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<(_iom2gwyu.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_iom2gwyu.ModuleClass>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _is.getType<List<int?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i0zisc0t.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i0zisc0t.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i0zisc0t.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i0zisc0t.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i0zisc0t.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i0zisc0t.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i0zisc0t.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i0zisc0t.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList() as T;
    }
    if (t == _is.getType<List<DateTime>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime>(e)).toList()
              : null)
          as T;
    }
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList() as T;
    }
    if (t == _is.getType<List<DateTime?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_idt.ByteData>) {
      return (data as List).map((e) => deserialize<_idt.ByteData>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_idt.ByteData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_idt.ByteData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_idt.ByteData?>) {
      return (data as List).map((e) => deserialize<_idt.ByteData?>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_idt.ByteData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_idt.ByteData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList() as T;
    }
    if (t == _is.getType<List<Duration>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toList() as T;
    }
    if (t == _is.getType<List<Duration?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration?>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_is.UuidValue>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is.UuidValue>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_is.UuidValue?>) {
      return (data as List).map((e) => deserialize<_is.UuidValue?>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_is.UuidValue?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_is.UuidValue?>(e))
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
    if (t == _is.getType<Map<String, int>?>()) {
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
    if (t == _is.getType<Map<String, int?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<int?>(v)),
                )
              : null)
          as T;
    }
    if (t == _ilwf0zl1.CustomClassWithoutProtocolSerialization) {
      return _ilwf0zl1.CustomClassWithoutProtocolSerialization.fromJson(data)
          as T;
    }
    if (t == _ilwf0zl1.CustomClassWithProtocolSerialization) {
      return _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _ilwf0zl1.CustomClassWithProtocolSerializationMethod) {
      return _ilwf0zl1.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == dynamic) {
      return deserializeDynamicFieldValue(data) as T;
    }
    if (t == List<dynamic>) {
      return (data as List).map((e) => deserialize<dynamic>(e)).toList() as T;
    }
    if (t == Map<String, dynamic>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<dynamic>(v)),
          )
          as T;
    }
    if (t == Set<dynamic>) {
      return (data as List).map((e) => deserialize<dynamic>(e)).toSet() as T;
    }
    if (t == Map<dynamic, dynamic>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<dynamic>(e['k']),
                deserialize<dynamic>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == List<_ionapfu9.TestEnum>) {
      return (data as List)
              .map((e) => deserialize<_ionapfu9.TestEnum>(e))
              .toList()
          as T;
    }
    if (t == List<_ionapfu9.TestEnum?>) {
      return (data as List)
              .map((e) => deserialize<_ionapfu9.TestEnum?>(e))
              .toList()
          as T;
    }
    if (t == List<List<_ionapfu9.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_ionapfu9.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_it39smib.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_it39smib.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_izw460bh.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_izw460bh.TestEnumEnhancedByName>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, _i0zisc0t.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i0zisc0t.SimpleData>(v),
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
    if (t == Map<String, _idt.ByteData>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_idt.ByteData>(v)),
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
    if (t == Map<String, _is.UuidValue>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_is.UuidValue>(v)),
          )
          as T;
    }
    if (t == Map<String, _i0zisc0t.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i0zisc0t.SimpleData?>(v),
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
    if (t == Map<String, _idt.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_idt.ByteData?>(v),
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
    if (t == Map<String, _is.UuidValue?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_is.UuidValue?>(v),
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
    if (t ==
        _is.getType<_ilwf0zl1.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilwf0zl1.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_ilwf0zl1.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithProtocolSerializationMethod.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == List<List<_i0zisc0t.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i0zisc0t.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<List<_i0zisc0t.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i0zisc0t.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i0zisc0t.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i0zisc0t.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i0zisc0t.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i0zisc0t.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i0zisc0t.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i0zisc0t.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i0zisc0t.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<List<Map<int, _i0zisc0t.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i0zisc0t.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _is
            .getType<
              Map<String, List<List<Map<int, _i0zisc0t.SimpleData>>?>>?
            >()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i0zisc0t.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _is.getType<List<Map<int, _i0zisc0t.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i0zisc0t.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i0zisc0t.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i0zisc0t.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, Map<int, _i0zisc0t.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i0zisc0t.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_ij7m744x.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_ij7m744x.SealedParent>(e))
              .toList()
          as T;
    }
    if (t == List<_iaxkp5y4.SealedAppException>) {
      return (data as List)
              .map((e) => deserialize<_iaxkp5y4.SealedAppException>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<_ilchwovc.Article>) {
      return (data as List)
              .map((e) => deserialize<_ilchwovc.Article>(e))
              .toList()
          as T;
    }
    if (t == List<_ijh817kc.ServerOnlyClass>) {
      return (data as List)
              .map((e) => deserialize<_ijh817kc.ServerOnlyClass>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ijh817kc.ServerOnlyClass>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ijh817kc.ServerOnlyClass>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _ijh817kc.ServerOnlyClass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_ijh817kc.ServerOnlyClass>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, _ijh817kc.ServerOnlyClass>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_ijh817kc.ServerOnlyClass>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_ilwf0zl1.SharedModel>) {
      return (data as List)
              .map((e) => deserialize<_ilwf0zl1.SharedModel>(e))
              .toList()
          as T;
    }
    if (t == List<_ilwf0zl1.SharedModel?>) {
      return (data as List)
              .map((e) => deserialize<_ilwf0zl1.SharedModel?>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_ilwf0zl1.SharedModel>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ilwf0zl1.SharedModel>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, _ilwf0zl1.SharedModel>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_ilwf0zl1.SharedModel>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, _ilwf0zl1.SharedModel>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_ilwf0zl1.SharedModel>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, _ilwf0zl1.SharedSubclass>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_ilwf0zl1.SharedSubclass>(v),
            ),
          )
          as T;
    }
    if (t == Set<_ilwf0zl1.SharedModel>) {
      return (data as List)
              .map((e) => deserialize<_ilwf0zl1.SharedModel>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<Set<_ilwf0zl1.SharedModel>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ilwf0zl1.SharedModel>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == List<_i7liykk2.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i7liykk2.TestEnumStringified>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i7liykk2.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7liykk2.TestEnumStringified>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i7liykk2.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == List<(_i7liykk2.TestEnumStringified,)>) {
      return (data as List)
              .map((e) => deserialize<(_i7liykk2.TestEnumStringified,)>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)>()) {
      return (
            deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<List<(_i7liykk2.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<(_i7liykk2.TestEnumStringified,)>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)>()) {
      return (
            deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<(_il5sr7xc.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_il5sr7xc.Nullability>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i7liykk2.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == List<({_i7liykk2.TestEnumStringified value})>) {
      return (data as List)
              .map(
                (e) => deserialize<({_i7liykk2.TestEnumStringified value})>(e),
              )
              .toList()
          as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _is.getType<List<({_i7liykk2.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i7liykk2.TestEnumStringified value})>(
                            e,
                          ),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _is.getType<({_iom2gwyu.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_iom2gwyu.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_il5sr7xc.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_il5sr7xc.Nullability>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<Map<int, int>?>()) {
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
    if (t == _is.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(String, {Uri? optionalUri})?>()) {
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
    if (t == _is.getType<List<bool>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<bool>(e)).toList()
              : null)
          as T;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList() as T;
    }
    if (t == _is.getType<List<double>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<double>(e)).toList()
              : null)
          as T;
    }
    if (t == List<Uri>) {
      return (data as List).map((e) => deserialize<Uri>(e)).toList() as T;
    }
    if (t == _is.getType<List<Uri>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Uri>(e)).toList()
              : null)
          as T;
    }
    if (t == List<BigInt>) {
      return (data as List).map((e) => deserialize<BigInt>(e)).toList() as T;
    }
    if (t == _is.getType<List<BigInt>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<BigInt>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<List<_ionapfu9.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ionapfu9.TestEnum>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iwxwszsz.Types>) {
      return (data as List).map((e) => deserialize<_iwxwszsz.Types>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<_iwxwszsz.Types>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iwxwszsz.Types>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<Map<String, _iwxwszsz.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _iwxwszsz.Types>>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _iwxwszsz.Types>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_iwxwszsz.Types>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<List<Map<String, _iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _iwxwszsz.Types>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_iwxwszsz.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_iwxwszsz.Types>>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<List<_iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_iwxwszsz.Types>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toList() as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<List<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<(int,)?>) {
      return (data as List).map((e) => deserialize<(int,)?>(e)).toList() as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<List<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<(_ionapfu9.TestEnum,)>) {
      return (data as List)
              .map((e) => deserialize<(_ionapfu9.TestEnum,)>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)>()) {
      return (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<List<(_ionapfu9.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_ionapfu9.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)>()) {
      return (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == _is.getType<Map<int, String>?>()) {
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
    if (t == _is.getType<Map<bool, String>?>()) {
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
    if (t == _is.getType<Map<double, String>?>()) {
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
    if (t == _is.getType<Map<DateTime, String>?>()) {
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
    if (t == _is.getType<Map<String, String>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<String>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<_idt.ByteData, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_idt.ByteData>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<_idt.ByteData, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_idt.ByteData>(e['k']),
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
    if (t == _is.getType<Map<Duration, String>?>()) {
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
    if (t == Map<_is.UuidValue, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_is.UuidValue>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<_is.UuidValue, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_is.UuidValue>(e['k']),
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
    if (t == _is.getType<Map<Uri, String>?>()) {
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
    if (t == _is.getType<Map<BigInt, String>?>()) {
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
    if (t == Map<_ionapfu9.TestEnum, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_ionapfu9.TestEnum>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<_ionapfu9.TestEnum, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_ionapfu9.TestEnum>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_i7liykk2.TestEnumStringified, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_i7liykk2.TestEnumStringified>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<_i7liykk2.TestEnumStringified, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_i7liykk2.TestEnumStringified>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<_iwxwszsz.Types, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_iwxwszsz.Types>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<_iwxwszsz.Types, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<_iwxwszsz.Types>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<Map<_iwxwszsz.Types, String>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<Map<_iwxwszsz.Types, String>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<Map<_iwxwszsz.Types, String>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<Map<_iwxwszsz.Types, String>>(e['k']),
                      deserialize<String>(e['v']),
                    ),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<List<_iwxwszsz.Types>, String>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<List<_iwxwszsz.Types>>(e['k']),
                deserialize<String>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<List<_iwxwszsz.Types>, String>?>()) {
      return (data != null
              ? Map.fromEntries(
                  (data as List).map(
                    (e) => MapEntry(
                      deserialize<List<_iwxwszsz.Types>>(e['k']),
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<(String,), String>?>()) {
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Map<String, bool>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<bool>(v)),
          )
          as T;
    }
    if (t == _is.getType<Map<String, bool>?>()) {
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
    if (t == _is.getType<Map<String, double>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<double>(v)),
                )
              : null)
          as T;
    }
    if (t == _is.getType<Map<String, DateTime>?>()) {
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
    if (t == _is.getType<Map<String, _idt.ByteData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_idt.ByteData>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _is.getType<Map<String, Duration>?>()) {
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
    if (t == _is.getType<Map<String, _is.UuidValue>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_is.UuidValue>(v),
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
    if (t == _is.getType<Map<String, Uri>?>()) {
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
    if (t == _is.getType<Map<String, BigInt>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) =>
                      MapEntry(deserialize<String>(k), deserialize<BigInt>(v)),
                )
              : null)
          as T;
    }
    if (t == Map<String, _ionapfu9.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_ionapfu9.TestEnum>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, _ionapfu9.TestEnum>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_ionapfu9.TestEnum>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, _i7liykk2.TestEnumStringified>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i7liykk2.TestEnumStringified>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, _i7liykk2.TestEnumStringified>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i7liykk2.TestEnumStringified>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _is.getType<Map<String, _iwxwszsz.Types>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_iwxwszsz.Types>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, Map<String, _iwxwszsz.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<String, _iwxwszsz.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, Map<String, _iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<String, _iwxwszsz.Types>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == Map<String, List<_iwxwszsz.Types>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<_iwxwszsz.Types>>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, List<_iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<_iwxwszsz.Types>>(v),
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<String, (String,)>?>()) {
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Map<String, (String,)?>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<(String,)?>(v)),
          )
          as T;
    }
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<String, (String,)?>?>()) {
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
    if (t == _is.getType<(String,)?>()) {
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
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<(String,)?, String>?>()) {
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
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(double,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<double>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(DateTime,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<DateTime>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_idt.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_idt.ByteData>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Duration,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Duration>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_is.UuidValue,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_is.UuidValue>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Uri,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Uri>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(BigInt,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<BigInt>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _is.getType<(List<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<List<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Map<int, int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Set<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Set<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_i0zisc0t.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_i0zisc0t.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i0zisc0t.SimpleData>(
                    data['n']['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _is.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
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
        _is
            .getType<
              (
                (List<(_i0zisc0t.SimpleData,)>,), {
                (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i0zisc0t.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (
                          _i0zisc0t.SimpleData,
                          Map<String, _i0zisc0t.SimpleData>,
                        )
                      >(data['n']['namedNestedRecord']),
                )
                as T;
    }
    if (t == Set<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<bool>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<bool>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<double>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<double>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<DateTime>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<DateTime>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_idt.ByteData>) {
      return (data as List).map((e) => deserialize<_idt.ByteData>(e)).toSet()
          as T;
    }
    if (t == _is.getType<Set<_idt.ByteData>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_idt.ByteData>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<Duration>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Duration>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_is.UuidValue>) {
      return (data as List).map((e) => deserialize<_is.UuidValue>(e)).toSet()
          as T;
    }
    if (t == _is.getType<Set<_is.UuidValue>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_is.UuidValue>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<BigInt>) {
      return (data as List).map((e) => deserialize<BigInt>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<BigInt>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<BigInt>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<_ionapfu9.TestEnum>) {
      return (data as List)
              .map((e) => deserialize<_ionapfu9.TestEnum>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<Set<_ionapfu9.TestEnum>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ionapfu9.TestEnum>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_i7liykk2.TestEnumStringified>) {
      return (data as List)
              .map((e) => deserialize<_i7liykk2.TestEnumStringified>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<Set<_i7liykk2.TestEnumStringified>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7liykk2.TestEnumStringified>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<_iwxwszsz.Types>) {
      return (data as List).map((e) => deserialize<_iwxwszsz.Types>(e)).toSet()
          as T;
    }
    if (t == _is.getType<Set<_iwxwszsz.Types>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iwxwszsz.Types>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<Map<String, _iwxwszsz.Types>>) {
      return (data as List)
              .map((e) => deserialize<Map<String, _iwxwszsz.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<Set<Map<String, _iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<String, _iwxwszsz.Types>>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<List<_iwxwszsz.Types>>) {
      return (data as List)
              .map((e) => deserialize<List<_iwxwszsz.Types>>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<Set<List<_iwxwszsz.Types>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_iwxwszsz.Types>>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == Set<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toSet() as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Set<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<(int,)?>) {
      return (data as List).map((e) => deserialize<(int,)?>(e)).toSet() as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Set<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _is.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i685tvwm.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i685tvwm.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == List<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toList() as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == List<List<int>?>) {
      return (data as List).map((e) => deserialize<List<int>?>(e)).toList()
          as T;
    }
    if (t == _is.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<List<List<int>>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<List<int>>(e)).toList()
              : null)
          as T;
    }
    if (t == List<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toList() as T;
    }
    if (t == _is.getType<List<int?>?>()) {
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
    if (t == List<_idt.ByteData>) {
      return (data as List).map((e) => deserialize<_idt.ByteData>(e)).toList()
          as T;
    }
    if (t == List<_idt.ByteData?>) {
      return (data as List).map((e) => deserialize<_idt.ByteData?>(e)).toList()
          as T;
    }
    if (t == List<_i685tvwm.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i685tvwm.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<List<_i685tvwm.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i685tvwm.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<List<_i685tvwm.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i685tvwm.SimpleData?>(e))
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
    if (t == _is.getType<Map<String, int>?>()) {
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
    if (t == _is.getType<Map<String, int?>?>()) {
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
    if (t == Map<_izdri23a.TestEnum, int>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<_izdri23a.TestEnum>(e['k']),
                deserialize<int>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == Map<String, _izdri23a.TestEnum>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_izdri23a.TestEnum>(v),
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
    if (t == Map<String, _idt.ByteData>) {
      return (data as Map).map(
            (k, v) =>
                MapEntry(deserialize<String>(k), deserialize<_idt.ByteData>(v)),
          )
          as T;
    }
    if (t == Map<String, _idt.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_idt.ByteData?>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i685tvwm.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i685tvwm.SimpleData>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i685tvwm.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i685tvwm.SimpleData?>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<Map<String, _i685tvwm.SimpleData>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i685tvwm.SimpleData>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _is.getType<Map<String, _i685tvwm.SimpleData?>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<_i685tvwm.SimpleData?>(v),
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
    if (t == _is.getType<(Map<int, String>, String)>()) {
      return (
            deserialize<Map<int, String>>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(Map<int, String>, String)>()) {
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
    if (t == _is.getType<(Map<int, int>,)>()) {
      return (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<(Map<int, int>,)>()) {
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
    if (t == _is.getType<Map<DateTime, bool>?>()) {
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
    if (t == _is.getType<Map<int, String>?>()) {
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
    if (t == List<_i1n3uhu0.UserInfo>) {
      return (data as List)
              .map((e) => deserialize<_i1n3uhu0.UserInfo>(e))
              .toList()
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == Set<_i685tvwm.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i685tvwm.SimpleData>(e))
              .toSet()
          as T;
    }
    if (t == List<Set<_i685tvwm.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Set<_i685tvwm.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(int, BigInt)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<BigInt>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(String, _ieub4zqi.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_ieub4zqi.PolymorphicParent>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int?,)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
          )
          as T;
    }
    if (t == _is.getType<(int?,)?>()) {
      return (data == null)
          ? null as T
          : (
                  ((data as Map)['p'] as List)[0] == null
                      ? null
                      : deserialize<int>(data['p'][0]),
                )
                as T;
    }
    if (t == _is.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int, String)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<String>(data['p'][1]),
                )
                as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i685tvwm.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == _is.getType<(Map<String, int>,)>()) {
      return (deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<(Set<(int,)>,)>()) {
      return (deserialize<Set<(int,)>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<(int,)>) {
      return (data as List).map((e) => deserialize<(int,)>(e)).toSet() as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<({int number, String text})>()) {
      return (
            number: deserialize<int>(((data as Map)['n'] as Map)['number']),
            text: deserialize<String>(data['n']['text']),
          )
          as T;
    }
    if (t == _is.getType<({int number, String text})?>()) {
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
    if (t == _is.getType<({_i685tvwm.SimpleData data, int number})>()) {
      return (
            data: deserialize<_i685tvwm.SimpleData>(
              ((data as Map)['n'] as Map)['data'],
            ),
            number: deserialize<int>(data['n']['number']),
          )
          as T;
    }
    if (t == _is.getType<({_i685tvwm.SimpleData data, int number})?>()) {
      return (data == null)
          ? null as T
          : (
                  data: deserialize<_i685tvwm.SimpleData>(
                    ((data as Map)['n'] as Map)['data'],
                  ),
                  number: deserialize<int>(data['n']['number']),
                )
                as T;
    }
    if (t == _is.getType<({_i685tvwm.SimpleData? data, int? number})>()) {
      return (
            data: ((data as Map)['n'] as Map)['data'] == null
                ? null
                : deserialize<_i685tvwm.SimpleData>(data['n']['data']),
            number: ((data)['n'] as Map)['number'] == null
                ? null
                : deserialize<int>(data['n']['number']),
          )
          as T;
    }
    if (t == _is.getType<({Map<int, int> intIntMap})>()) {
      return (
            intIntMap: deserialize<Map<int, int>>(
              ((data as Map)['n'] as Map)['intIntMap'],
            ),
          )
          as T;
    }
    if (t == _is.getType<({Set<(bool,)> boolSet})>()) {
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
    if (t == _is.getType<(bool,)>()) {
      return (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(bool,)>()) {
      return (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Map<(Map<int, String>, String), String>,)>()) {
      return (
            deserialize<Map<(Map<int, String>, String), String>>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<(int, {_i685tvwm.SimpleData data})>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            data: deserialize<_i685tvwm.SimpleData>(data['n']['data']),
          )
          as T;
    }
    if (t == _is.getType<(int, {_i685tvwm.SimpleData data})?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  data: deserialize<_i685tvwm.SimpleData>(data['n']['data']),
                )
                as T;
    }
    if (t == List<(int, _i685tvwm.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i685tvwm.SimpleData)>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == List<(int, _i685tvwm.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i685tvwm.SimpleData)?>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i685tvwm.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Set<(int, _i685tvwm.SimpleData)>) {
      return (data as List)
              .map((e) => deserialize<(int, _i685tvwm.SimpleData)>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Set<(int, _i685tvwm.SimpleData)?>) {
      return (data as List)
              .map((e) => deserialize<(int, _i685tvwm.SimpleData)?>(e))
              .toSet()
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i685tvwm.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<Set<(int, _i685tvwm.SimpleData)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(int, _i685tvwm.SimpleData)>(e))
                    .toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i685tvwm.SimpleData)>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i685tvwm.SimpleData)>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == Map<String, (int, _i685tvwm.SimpleData)?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<(int, _i685tvwm.SimpleData)?>(v),
            ),
          )
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<int>(((data as Map)['p'] as List)[0]),
                  deserialize<_i685tvwm.SimpleData>(data['p'][1]),
                )
                as T;
    }
    if (t == Map<(String, int), (int, _i685tvwm.SimpleData)>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<(String, int)>(e['k']),
                deserialize<(int, _i685tvwm.SimpleData)>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int, _i685tvwm.SimpleData)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<_i685tvwm.SimpleData>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
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
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)>()) {
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
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<({(_i685tvwm.SimpleData, double) namedSubRecord})>()) {
      return (
            namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
              ((data as Map)['n'] as Map)['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t == _is.getType<(_i685tvwm.SimpleData, double)>()) {
      return (
            deserialize<_i685tvwm.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<double>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is.getType<({(_i685tvwm.SimpleData, double)? namedSubRecord})>()) {
      return (
            namedSubRecord:
                ((data as Map)['n'] as Map)['namedSubRecord'] == null
                ? null
                : deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
          )
          as T;
    }
    if (t == _is.getType<(_i685tvwm.SimpleData, double)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i685tvwm.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  deserialize<double>(data['p'][1]),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<
          ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})
        >) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i685tvwm.SimpleData, double) namedSubRecord,
                      })
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})
            >()) {
      return (
            deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
            namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
              data['n']['namedSubRecord'],
            ),
          )
          as T;
    }
    if (t ==
        List<
          ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
        >) {
      return (data as List)
              .map(
                (e) =>
                    deserialize<
                      (
                        (int, String), {
                        (_i685tvwm.SimpleData, double) namedSubRecord,
                      })?
                    >(e),
              )
              .toList()
          as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              List<
                (
                  (int, String), {
                  (_i685tvwm.SimpleData, double) namedSubRecord,
                })?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i685tvwm.SimpleData, double) namedSubRecord,
                            })?
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<(int?, _iom2gwyu.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_iom2gwyu.ProjectStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t == Set<Set<int>>) {
      return (data as List).map((e) => deserialize<Set<int>>(e)).toSet() as T;
    }
    if (t == Set<List<int>>) {
      return (data as List).map((e) => deserialize<List<int>>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<Set<int>?>) {
      return (data as List).map((e) => deserialize<Set<int>?>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<Set<Set<int>>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<Set<int>>(e)).toSet()
              : null)
          as T;
    }
    if (t == Set<int?>) {
      return (data as List).map((e) => deserialize<int?>(e)).toSet() as T;
    }
    if (t == _is.getType<Set<int?>?>()) {
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
    if (t == Set<_idt.ByteData>) {
      return (data as List).map((e) => deserialize<_idt.ByteData>(e)).toSet()
          as T;
    }
    if (t == Set<_idt.ByteData?>) {
      return (data as List).map((e) => deserialize<_idt.ByteData?>(e)).toSet()
          as T;
    }
    if (t == Set<_i685tvwm.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i685tvwm.SimpleData?>(e))
              .toSet()
          as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == Set<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toSet() as T;
    }
    if (t == List<_iuch3ck4.Types>) {
      return (data as List).map((e) => deserialize<_iuch3ck4.Types>(e)).toList()
          as T;
    }
    if (t == _is.getType<(String, (int, bool))>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<(int, bool)>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int, bool)>()) {
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
    if (t == _is.getType<(String, (int, bool))>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<(int, bool)>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (
                String,
                (
                  Map<String, int>, {
                  bool flag,
                  _i685tvwm.SimpleData simpleData,
                }),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData})
            >(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData})
            >()) {
      return (
            deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
            flag: deserialize<bool>(data['n']['flag']),
            simpleData: deserialize<_i685tvwm.SimpleData>(
              data['n']['simpleData'],
            ),
          )
          as T;
    }
    if (t == List<(String, int)>) {
      return (data as List).map((e) => deserialize<(String, int)>(e)).toList()
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (
                String,
                (
                  Map<String, int>, {
                  bool flag,
                  _i685tvwm.SimpleData simpleData,
                }),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (
                      Map<String, int>, {
                      bool flag,
                      _i685tvwm.SimpleData simpleData,
                    })
                  >(data['p'][1]),
                )
                as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<List<(String, int)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(String, int)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int, String)>()) {
      return (
            deserialize<int>(((data as Map)['p'] as List)[0]),
            deserialize<String>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(_iom2gwyu.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_iom2gwyu.ModuleClass>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i7liykk2.TestEnumStringified>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)>()) {
      return (
            deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<List<(_i7liykk2.TestEnumStringified,)>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<(_i7liykk2.TestEnumStringified,)>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)>()) {
      return (
            deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<(_i7liykk2.TestEnumStringified,)>()) {
      return (
            deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == _is.getType<(_il5sr7xc.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_il5sr7xc.Nullability>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_i7liykk2.TestEnumStringified>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _is.getType<List<({_i7liykk2.TestEnumStringified value})>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<({_i7liykk2.TestEnumStringified value})>(
                            e,
                          ),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _is.getType<({_i7liykk2.TestEnumStringified value})>()) {
      return (
            value: deserialize<_i7liykk2.TestEnumStringified>(
              ((data as Map)['n'] as Map)['value'],
            ),
          )
          as T;
    }
    if (t == _is.getType<({_iom2gwyu.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_iom2gwyu.ModuleClass>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_il5sr7xc.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
                  value: deserialize<_il5sr7xc.Nullability>(
                    ((data as Map)['n'] as Map)['value'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<(String, {Uri? optionalUri})?>()) {
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
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<List<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<List<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)>()) {
      return (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<List<(_ionapfu9.TestEnum,)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(_ionapfu9.TestEnum,)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)>()) {
      return (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)>()) {
      return (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<(String,), String>?>()) {
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<String, (String,)>?>()) {
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
    if (t == _is.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<String, (String,)?>?>()) {
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
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Map<(String,)?, String>?>()) {
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
    if (t == _is.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(double,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<double>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(DateTime,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<DateTime>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_idt.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_idt.ByteData>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Duration,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Duration>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_is.UuidValue,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_is.UuidValue>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Uri,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Uri>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(BigInt,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<BigInt>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_ionapfu9.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_ionapfu9.TestEnum>(((data as Map)['p'] as List)[0]),)
                as T;
    }
    if (t == _is.getType<(List<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<List<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Map<int, int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Map<int, int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(Set<int>,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<Set<int>>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(_i0zisc0t.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                )
                as T;
    }
    if (t == _is.getType<({_i0zisc0t.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
                  namedModel: deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['n'] as Map)['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<_i0zisc0t.SimpleData>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedModel: deserialize<_i0zisc0t.SimpleData>(
                    data['n']['namedModel'],
                  ),
                )
                as T;
    }
    if (t ==
        _is.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
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
        _is
            .getType<
              (
                (List<(_i0zisc0t.SimpleData,)>,), {
                (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
                namedNestedRecord,
              })?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(List<(_i0zisc0t.SimpleData,)>,)>(
                    ((data as Map)['p'] as List)[0],
                  ),
                  namedNestedRecord:
                      deserialize<
                        (
                          _i0zisc0t.SimpleData,
                          Map<String, _i0zisc0t.SimpleData>,
                        )
                      >(data['n']['namedNestedRecord']),
                )
                as T;
    }
    if (t == _is.getType<(List<(_i0zisc0t.SimpleData,)>,)>()) {
      return (
            deserialize<List<(_i0zisc0t.SimpleData,)>>(
              ((data as Map)['p'] as List)[0],
            ),
          )
          as T;
    }
    if (t == List<(_i0zisc0t.SimpleData,)>) {
      return (data as List)
              .map((e) => deserialize<(_i0zisc0t.SimpleData,)>(e))
              .toList()
          as T;
    }
    if (t == _is.getType<(_i0zisc0t.SimpleData,)>()) {
      return (
            deserialize<_i0zisc0t.SimpleData>(((data as Map)['p'] as List)[0]),
          )
          as T;
    }
    if (t == _is.getType<(_i0zisc0t.SimpleData,)>()) {
      return (
            deserialize<_i0zisc0t.SimpleData>(((data as Map)['p'] as List)[0]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
            >()) {
      return (
            deserialize<_i0zisc0t.SimpleData>(((data as Map)['p'] as List)[0]),
            deserialize<Map<String, _i0zisc0t.SimpleData>>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Set<(int,)>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _is.getType<Set<(int,)?>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
              : null)
          as T;
    }
    if (t == _is.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _ilwf0zl1.CustomClass) {
      return _ilwf0zl1.CustomClass.fromJson(data) as T;
    }
    if (t == _ilwf0zl1.CustomClass2) {
      return _ilwf0zl1.CustomClass2.fromJson(data) as T;
    }
    if (t == _ilwf0zl1.ProtocolCustomClass) {
      return _ilwf0zl1.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _ilwf0zl1.ExternalCustomClass) {
      return _ilwf0zl1.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _ilwf0zl1.FreezedCustomClass) {
      return _ilwf0zl1.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _is.getType<_ilwf0zl1.CustomClass?>()) {
      return (data != null ? _ilwf0zl1.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _is.getType<_ilwf0zl1.CustomClass2?>()) {
      return (data != null ? _ilwf0zl1.CustomClass2.fromJson(data) : null) as T;
    }
    if (t ==
        _is.getType<_ilwf0zl1.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithoutProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilwf0zl1.CustomClassWithProtocolSerialization?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithProtocolSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t ==
        _is.getType<_ilwf0zl1.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
              ? _ilwf0zl1.CustomClassWithProtocolSerializationMethod.fromJson(
                  data,
                )
              : null)
          as T;
    }
    if (t == _is.getType<_ilwf0zl1.ProtocolCustomClass?>()) {
      return (data != null
              ? _ilwf0zl1.ProtocolCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilwf0zl1.ExternalCustomClass?>()) {
      return (data != null
              ? _ilwf0zl1.ExternalCustomClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _is.getType<_ilwf0zl1.FreezedCustomClass?>()) {
      return (data != null ? _ilwf0zl1.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _is.getType<List<_i685tvwm.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i685tvwm.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(String, _ieub4zqi.PolymorphicParent)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<_ieub4zqi.PolymorphicParent>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(int?,)?>()) {
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
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t ==
        _is
            .getType<
              List<
                (
                  (int, String), {
                  (_i685tvwm.SimpleData, double) namedSubRecord,
                })?
              >?
            >()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) =>
                          deserialize<
                            (
                              (int, String), {
                              (_i685tvwm.SimpleData, double) namedSubRecord,
                            })?
                          >(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _is
            .getType<
              ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
                  namedSubRecord: deserialize<(_i685tvwm.SimpleData, double)>(
                    data['n']['namedSubRecord'],
                  ),
                )
                as T;
    }
    if (t == _is.getType<(int?, _iom2gwyu.ProjectStreamingClass?)>()) {
      return (
            ((data as Map)['p'] as List)[0] == null
                ? null
                : deserialize<int>(data['p'][0]),
            ((data)['p'] as List)[1] == null
                ? null
                : deserialize<_iom2gwyu.ProjectStreamingClass>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (
                String,
                (
                  Map<String, int>, {
                  bool flag,
                  _i685tvwm.SimpleData simpleData,
                }),
              )
            >()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<
              (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData})
            >(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t ==
        _is
            .getType<
              (
                String,
                (
                  Map<String, int>, {
                  bool flag,
                  _i685tvwm.SimpleData simpleData,
                }),
              )?
            >()) {
      return (data == null)
          ? null as T
          : (
                  deserialize<String>(((data as Map)['p'] as List)[0]),
                  deserialize<
                    (
                      Map<String, int>, {
                      bool flag,
                      _i685tvwm.SimpleData simpleData,
                    })
                  >(data['p'][1]),
                )
                as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    if (t == _is.getType<List<(String, int)>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<(String, int)>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == _is.getType<(String, int)>()) {
      return (
            deserialize<String>(((data as Map)['p'] as List)[0]),
            deserialize<int>(data['p'][1]),
          )
          as T;
    }
    try {
      return _i1n3uhu0.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iom2gwyu.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iyx9etqn.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _ilwf0zl1.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _isp.Protocol().deserialize<T>(data, t);
    } on _is.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _ilwf0zl1.CustomClass => 'CustomClass',
      _ilwf0zl1.CustomClass2 => 'CustomClass2',
      _ilwf0zl1.CustomClassWithoutProtocolSerialization =>
        'CustomClassWithoutProtocolSerialization',
      _ilwf0zl1.CustomClassWithProtocolSerialization =>
        'CustomClassWithProtocolSerialization',
      _ilwf0zl1.CustomClassWithProtocolSerializationMethod =>
        'CustomClassWithProtocolSerializationMethod',
      _ilwf0zl1.ProtocolCustomClass => 'ProtocolCustomClass',
      _ilwf0zl1.ExternalCustomClass => 'ExternalCustomClass',
      _ilwf0zl1.FreezedCustomClass => 'FreezedCustomClass',
      _ihs9bjzx.ByIndexEnumWithNameValue => 'ByIndexEnumWithNameValue',
      _iwdug2n0.ByNameEnumWithNameValue => 'ByNameEnumWithNameValue',
      _ik6ri27s.CourseUuid => 'CourseUuid',
      _icdgc05t.EnrollmentInt => 'EnrollmentInt',
      _ibrjea6w.StudentUuid => 'StudentUuid',
      _isj7c5mo.ArenaUuid => 'ArenaUuid',
      _ivdpnfmj.PlayerUuid => 'PlayerUuid',
      _ivehlt2f.TeamInt => 'TeamInt',
      _i3jtpxta.CommentInt => 'CommentInt',
      _iimgofmw.CustomerInt => 'CustomerInt',
      _iywnby31.OrderUuid => 'OrderUuid',
      _ifwqt4rb.AddressUuid => 'AddressUuid',
      _idhvg1zk.CitizenInt => 'CitizenInt',
      _i5vwm04a.CompanyUuid => 'CompanyUuid',
      _iu7osokh.TownInt => 'TownInt',
      _ixc9sah8.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _irw3jmaq.ServerOnlyChangedIdFieldClass =>
        'ServerOnlyChangedIdFieldClass',
      _icrmubzc.BigIntDefault => 'BigIntDefault',
      _i1xsun18.BigIntDefaultMix => 'BigIntDefaultMix',
      _i332rqur.BigIntDefaultModel => 'BigIntDefaultModel',
      _ia4nw21o.BigIntDefaultPersist => 'BigIntDefaultPersist',
      _ilirabmz.BoolDefault => 'BoolDefault',
      _iwhzartq.BoolDefaultMix => 'BoolDefaultMix',
      _izvr7tnf.BoolDefaultModel => 'BoolDefaultModel',
      _i135uugo.BoolDefaultPersist => 'BoolDefaultPersist',
      _iro0mlkq.DateTimeDefault => 'DateTimeDefault',
      _igjm2894.DateTimeDefaultMix => 'DateTimeDefaultMix',
      _ivkcoq83.DateTimeDefaultModel => 'DateTimeDefaultModel',
      _iaqar0o9.DateTimeDefaultPersist => 'DateTimeDefaultPersist',
      _izu05ym4.DoubleDefault => 'DoubleDefault',
      _iou6kksr.DoubleDefaultMix => 'DoubleDefaultMix',
      _i9xv7g6i.DoubleDefaultModel => 'DoubleDefaultModel',
      _iynhhcdw.DoubleDefaultPersist => 'DoubleDefaultPersist',
      _ixvw8l6s.DurationDefault => 'DurationDefault',
      _ialx1ytx.DurationDefaultMix => 'DurationDefaultMix',
      _i5aouk9m.DurationDefaultModel => 'DurationDefaultModel',
      _ij5e1q2b.DurationDefaultPersist => 'DurationDefaultPersist',
      _ihqxpva2.EnumDefault => 'EnumDefault',
      _iyezrrxn.EnumDefaultMix => 'EnumDefaultMix',
      _iw4wb1ju.EnumDefaultModel => 'EnumDefaultModel',
      _i0p9yn0v.EnumDefaultPersist => 'EnumDefaultPersist',
      _i4ekvn16.ByIndexEnum => 'ByIndexEnum',
      _ihrgmscf.ByNameEnum => 'ByNameEnum',
      _iirkfcfb.DefaultValueEnum => 'DefaultValueEnum',
      _iv40kyzq.DefaultException => 'DefaultException',
      _i8t3u1nx.IntDefault => 'IntDefault',
      _iummzlp0.IntDefaultMix => 'IntDefaultMix',
      _i4rypx08.IntDefaultModel => 'IntDefaultModel',
      _imhmhhwa.IntDefaultPersist => 'IntDefaultPersist',
      _i4d8z6ds.StringDefault => 'StringDefault',
      _iu6k5fkj.StringDefaultMix => 'StringDefaultMix',
      _ihmqo6od.StringDefaultModel => 'StringDefaultModel',
      _ih6giyf6.StringDefaultPersist => 'StringDefaultPersist',
      _i2y701qf.UriDefault => 'UriDefault',
      _iib8h1yl.UriDefaultMix => 'UriDefaultMix',
      _i1to0y5o.UriDefaultModel => 'UriDefaultModel',
      _isi15w9f.UriDefaultPersist => 'UriDefaultPersist',
      _ihsadwhl.UuidDefault => 'UuidDefault',
      _ignwr848.UuidDefaultMix => 'UuidDefaultMix',
      _i15gwzho.UuidDefaultModel => 'UuidDefaultModel',
      _i2v866bf.UuidDefaultPersist => 'UuidDefaultPersist',
      _io8dlrxh.DeferrableRelationInitiallyDeferred =>
        'DeferrableRelationInitiallyDeferred',
      _inmfeda2.DeferrableRelationInitiallyImmediate =>
        'DeferrableRelationInitiallyImmediate',
      _izxfibiy.DeferrableRelationParent => 'DeferrableRelationParent',
      _i9l9xrkt.EmptyModel => 'EmptyModel',
      _ikufh0vd.EmptyModelRelationItem => 'EmptyModelRelationItem',
      _iw4y4x6s.EmptyModelWithTable => 'EmptyModelWithTable',
      _iy7bezig.RelationEmptyModel => 'RelationEmptyModel',
      _is77lrdb.ExceptionWithData => 'ExceptionWithData',
      _ikh95zxc.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i1y2idkw.NonTableParentClass => 'NonTableParentClass',
      _i7hqkfn7.ModifiedColumnName => 'ModifiedColumnName',
      _ix2lcsu0.Department => 'Department',
      _ixlcmx78.Employee => 'Employee',
      _iw4adtsk.Contractor => 'Contractor',
      _i83a3u3u.Service => 'Service',
      _iox92era.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _ip57k4t4.TestGeneratedCallByeModel => 'TestGeneratedCallByeModel',
      _ilmnz413.TestGeneratedCallExecuteWithTriggerModel =>
        'TestGeneratedCallExecuteWithTriggerModel',
      _ifspsmem.TestGeneratedCallHelloModel => 'TestGeneratedCallHelloModel',
      _i3yv7lzj.TestGeneratedCallInvokeModel => 'TestGeneratedCallInvokeModel',
      _isas41s9.ImmutableChildObject => 'ImmutableChildObject',
      _i8ali8rk.ImmutableChildObjectWithNoAdditionalFields =>
        'ImmutableChildObjectWithNoAdditionalFields',
      _ib4436rb.ImmutableObject => 'ImmutableObject',
      _i5o8gk0d.ImmutableObjectWithImmutableObject =>
        'ImmutableObjectWithImmutableObject',
      _ifcovr71.ImmutableObjectWithList => 'ImmutableObjectWithList',
      _i7chvx7t.ImmutableObjectWithMap => 'ImmutableObjectWithMap',
      _ijpel12b.ImmutableObjectWithMultipleFields =>
        'ImmutableObjectWithMultipleFields',
      _im6ib46o.ImmutableObjectWithNoFields => 'ImmutableObjectWithNoFields',
      _iz0jdatm.ImmutableObjectWithRecord => 'ImmutableObjectWithRecord',
      _ij73d01s.ImmutableObjectWithTable => 'ImmutableObjectWithTable',
      _i6bj8wy3.ImmutableObjectWithTwentyFields =>
        'ImmutableObjectWithTwentyFields',
      _ix35kamj.ChildClass => 'ChildClass',
      _inmco1xt.ServerOnlyChildClass => 'ServerOnlyChildClass',
      _ibdvdtnv.ChildWithDefault => 'ChildWithDefault',
      _ieeasgju.ChildWithInheritedId => 'ChildWithInheritedId',
      _i57yjwwl.ChildClassWithoutId => 'ChildClassWithoutId',
      _ihtrmue0.ServerOnlyChildClassWithoutId =>
        'ServerOnlyChildClassWithoutId',
      _i4ydso50.ExtendedAppException => 'ExtendedAppException',
      _iw7pve41.BaseAppException => 'BaseAppException',
      _iaxkp5y4.NotFoundException => 'NotFoundException',
      _iaxkp5y4.ValidationException => 'ValidationException',
      _io7upog0.ParentClass => 'ParentClass',
      _i5sz4l10.GrandparentClass => 'GrandparentClass',
      _ijexcijb.ParentClassWithoutId => 'ParentClassWithoutId',
      _iolet7jc.GrandparentClassWithId => 'GrandparentClassWithId',
      _i2aipqpt.ChildEntity => 'ChildEntity',
      _i9odpwsh.BaseEntity => 'BaseEntity',
      _ir6jlp3k.ParentEntity => 'ParentEntity',
      _igefthms.NonServerOnlyParentClass => 'NonServerOnlyParentClass',
      _iauswj59.ParentWithChangedId => 'ParentWithChangedId',
      _iitvxe69.ParentWithDefault => 'ParentWithDefault',
      _ipndfib1.PolymorphicGrandChild => 'PolymorphicGrandChild',
      _i11uofdz.PolymorphicChild => 'PolymorphicChild',
      _iqb6eppn.PolymorphicChildContainer => 'PolymorphicChildContainer',
      _iw07om20.ModulePolymorphicChildContainer =>
        'ModulePolymorphicChildContainer',
      _icfkf6u0.SimilarButNotParent => 'SimilarButNotParent',
      _i5oq3fsk.PolymorphicParent => 'PolymorphicParent',
      _ih2dgm3r.UnrelatedToPolymorphism => 'UnrelatedToPolymorphism',
      _ij7m744x.SealedGrandChild => 'SealedGrandChild',
      _ij7m744x.SealedChild => 'SealedChild',
      _iwv9x21d.SealedChildOnlyRequired => 'SealedChildOnlyRequired',
      _ij7m744x.SealedOtherChild => 'SealedOtherChild',
      _iycanyn2.CityWithLongTableName => 'CityWithLongTableName',
      _ifbzwpkm.OrganizationWithLongTableName =>
        'OrganizationWithLongTableName',
      _iy2gklrg.PersonWithLongTableName => 'PersonWithLongTableName',
      _i37b4f1x.MaxFieldName => 'MaxFieldName',
      _ilm8ux21.LongImplicitIdField => 'LongImplicitIdField',
      _i5zyye9l.LongImplicitIdFieldCollection =>
        'LongImplicitIdFieldCollection',
      _irdava0x.RelationToMultipleMaxFieldName =>
        'RelationToMultipleMaxFieldName',
      _i14q426c.UserNote => 'UserNote',
      _i0cmztzz.UserNoteCollection => 'UserNoteCollection',
      _ivgcl1bh.UserNoteCollectionWithALongName =>
        'UserNoteCollectionWithALongName',
      _i7zqea9a.UserNoteWithALongName => 'UserNoteWithALongName',
      _ify1vf7h.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i0i33txy.City => 'City',
      _iffzpgud.Organization => 'Organization',
      _i9x7ls0c.Person => 'Person',
      _iepu1h7u.BleedChild => 'BleedChild',
      _ipkncx5k.BleedRoot => 'BleedRoot',
      _ilvqc6dx.GeneratedRelationCompany => 'GeneratedRelationCompany',
      _i3ralext.GeneratedRelationEmployee => 'GeneratedRelationEmployee',
      _isfv2yco.GeneratedRelationOffice => 'GeneratedRelationOffice',
      _iy2buo88.Course => 'Course',
      _i8v11x6h.Enrollment => 'Enrollment',
      _ig5mtn0e.Student => 'Student',
      _ian3gu05.ObjectUser => 'ObjectUser',
      _i1h6ufx7.ParentUser => 'ParentUser',
      _ikwieien.Arena => 'Arena',
      _ip8wmh4s.Player => 'Player',
      _ifa5hwxy.Team => 'Team',
      _ii7cxuye.Comment => 'Comment',
      _i1nwi4iv.Customer => 'Customer',
      _if51mnnb.Book => 'Book',
      _itdsc4u0.Chapter => 'Chapter',
      _is5jy3ez.Order => 'Order',
      _i6uupgbr.Address => 'Address',
      _igeuyxnu.Citizen => 'Citizen',
      _if6srpch.Company => 'Company',
      _igjnmbwc.Town => 'Town',
      _ic5jbe8i.Blocking => 'Blocking',
      _ijj92mp1.Member => 'Member',
      _ib9keugy.Cat => 'Cat',
      _iyh1zt5l.Post => 'Post',
      _ikm3lhvl.ModuleDatatype => 'ModuleDatatype',
      _i6x889hl.MyFeatureModel => 'MyFeatureModel',
      _i47v6vne.MyTriggerType => 'MyTriggerType',
      _il5sr7xc.Nullability => 'Nullability',
      _iz2gvrid.NullsDistinctData => 'NullsDistinctData',
      _i9ffbppf.ObjectFieldPersist => 'ObjectFieldPersist',
      _iahgl0he.ObjectFieldScopes => 'ObjectFieldScopes',
      _ioxr67zo.ObjectWithBit => 'ObjectWithBit',
      _iz58zhle.ObjectWithByteData => 'ObjectWithByteData',
      _i6zp404a.ObjectWithCustomClass => 'ObjectWithCustomClass',
      _ijtijns8.ObjectWithDuration => 'ObjectWithDuration',
      _i9hzn3wb.ObjectWithDynamic => 'ObjectWithDynamic',
      _ip2vqluy.ObjectWithEnum => 'ObjectWithEnum',
      _iwdrmoge.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _io7bb4tk.ObjectWithGeographyGeometryCollection =>
        'ObjectWithGeographyGeometryCollection',
      _icdfatkc.ObjectWithGeographyLineString =>
        'ObjectWithGeographyLineString',
      _i2wdw9b4.ObjectWithGeographyPoint => 'ObjectWithGeographyPoint',
      _ignhorhm.ObjectWithGeographyPolygon => 'ObjectWithGeographyPolygon',
      _iy6ksgxz.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _inemzov5.ObjectWithIndex => 'ObjectWithIndex',
      _ihyvenpw.ObjectWithJsonb => 'ObjectWithJsonb',
      _i4p0t2g0.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i26q9u41.ObjectWithMaps => 'ObjectWithMaps',
      _i2qtgitl.ObjectWithNullableCustomClass =>
        'ObjectWithNullableCustomClass',
      _i4hr2e9p.ObjectWithObject => 'ObjectWithObject',
      _io0t3u2c.ObjectWithParent => 'ObjectWithParent',
      _im4j7lpz.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _itdevv9e.ObjectWithSealedException => 'ObjectWithSealedException',
      _ihluvkmz.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i8t20dyr.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _iusk9w05.ObjectWithUuid => 'ObjectWithUuid',
      _itmc4j9i.ObjectWithVector => 'ObjectWithVector',
      _ificmsie.Record => 'Record',
      _i2aw39a6.RelatedUniqueData => 'RelatedUniqueData',
      _iiggggl6.ExceptionWithRequiredField => 'ExceptionWithRequiredField',
      _iv7egjxb.ModelWithRequiredField => 'ModelWithRequiredField',
      _ixhyrkj6.ScopeNoneFields => 'ScopeNoneFields',
      _igfnl8bc.ScopeServerOnlyFieldChild => 'ScopeServerOnlyFieldChild',
      _it7f5mv0.ScopeServerOnlyField => 'ScopeServerOnlyField',
      _ilchwovc.Article => 'Article',
      _ip3v2qu9.ArticleList => 'ArticleList',
      _i8lxkh3j.DefaultServerOnlyClass => 'DefaultServerOnlyClass',
      _i96dkulb.DefaultServerOnlyEnum => 'DefaultServerOnlyEnum',
      _ilb1g1z5.NotServerOnlyClass => 'NotServerOnlyClass',
      _ik117x9c.NotServerOnlyEnum => 'NotServerOnlyEnum',
      _ijh817kc.ServerOnlyClass => 'ServerOnlyClass',
      _iuyjh56c.ServerOnlyEnum => 'ServerOnlyEnum',
      _izzkyevr.ServerOnlyClassField => 'ServerOnlyClassField',
      _iy81tiee.ServerOnlyDefault => 'ServerOnlyDefault',
      _iz7kinop.SessionAuthInfo => 'SessionAuthInfo',
      _icmi6q0i.SharedModelContainer => 'SharedModelContainer',
      _iu5vt3uc.SharedModelSubclass => 'SharedModelSubclass',
      _i0zisc0t.SimpleData => 'SimpleData',
      _iyexv7xa.SimpleDataList => 'SimpleDataList',
      _iu6b143l.SimpleDataMap => 'SimpleDataMap',
      _ikkvbzqw.SimpleDataObject => 'SimpleDataObject',
      _i1duz4kf.SimpleDateTime => 'SimpleDateTime',
      _il2trryf.ModelInSubfolder => 'ModelInSubfolder',
      _ionapfu9.TestEnum => 'TestEnum',
      _icplrpi3.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _it39smib.TestEnumEnhanced => 'TestEnumEnhanced',
      _izw460bh.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i7liykk2.TestEnumStringified => 'TestEnumStringified',
      _iwxwszsz.Types => 'Types',
      _irfb5ten.TypesList => 'TypesList',
      _i81vljk7.TypesMap => 'TypesMap',
      _irmygd7t.TypesRecord => 'TypesRecord',
      _iiutqksg.TypesSet => 'TypesSet',
      _ir494j8f.TypesSetRequired => 'TypesSetRequired',
      _iufhyrjh.UniqueData => 'UniqueData',
      _ip8yzqii.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
      _iwbeyn4p.UpsertTestModel => 'UpsertTestModel',
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
      case _ilwf0zl1.CustomClass():
        return 'CustomClass';
      case _ilwf0zl1.CustomClass2():
        return 'CustomClass2';
      case _ilwf0zl1.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _ilwf0zl1.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _ilwf0zl1.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _ilwf0zl1.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _ilwf0zl1.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _ilwf0zl1.FreezedCustomClass():
        return 'FreezedCustomClass';
      case _ihs9bjzx.ByIndexEnumWithNameValue():
        return 'ByIndexEnumWithNameValue';
      case _iwdug2n0.ByNameEnumWithNameValue():
        return 'ByNameEnumWithNameValue';
      case _ik6ri27s.CourseUuid():
        return 'CourseUuid';
      case _icdgc05t.EnrollmentInt():
        return 'EnrollmentInt';
      case _ibrjea6w.StudentUuid():
        return 'StudentUuid';
      case _isj7c5mo.ArenaUuid():
        return 'ArenaUuid';
      case _ivdpnfmj.PlayerUuid():
        return 'PlayerUuid';
      case _ivehlt2f.TeamInt():
        return 'TeamInt';
      case _i3jtpxta.CommentInt():
        return 'CommentInt';
      case _iimgofmw.CustomerInt():
        return 'CustomerInt';
      case _iywnby31.OrderUuid():
        return 'OrderUuid';
      case _ifwqt4rb.AddressUuid():
        return 'AddressUuid';
      case _idhvg1zk.CitizenInt():
        return 'CitizenInt';
      case _i5vwm04a.CompanyUuid():
        return 'CompanyUuid';
      case _iu7osokh.TownInt():
        return 'TownInt';
      case _ixc9sah8.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _irw3jmaq.ServerOnlyChangedIdFieldClass():
        return 'ServerOnlyChangedIdFieldClass';
      case _icrmubzc.BigIntDefault():
        return 'BigIntDefault';
      case _i1xsun18.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i332rqur.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _ia4nw21o.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _ilirabmz.BoolDefault():
        return 'BoolDefault';
      case _iwhzartq.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _izvr7tnf.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i135uugo.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _iro0mlkq.DateTimeDefault():
        return 'DateTimeDefault';
      case _igjm2894.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _ivkcoq83.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _iaqar0o9.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _izu05ym4.DoubleDefault():
        return 'DoubleDefault';
      case _iou6kksr.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i9xv7g6i.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _iynhhcdw.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _ixvw8l6s.DurationDefault():
        return 'DurationDefault';
      case _ialx1ytx.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i5aouk9m.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _ij5e1q2b.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _ihqxpva2.EnumDefault():
        return 'EnumDefault';
      case _iyezrrxn.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _iw4wb1ju.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i0p9yn0v.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i4ekvn16.ByIndexEnum():
        return 'ByIndexEnum';
      case _ihrgmscf.ByNameEnum():
        return 'ByNameEnum';
      case _iirkfcfb.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _iv40kyzq.DefaultException():
        return 'DefaultException';
      case _i8t3u1nx.IntDefault():
        return 'IntDefault';
      case _iummzlp0.IntDefaultMix():
        return 'IntDefaultMix';
      case _i4rypx08.IntDefaultModel():
        return 'IntDefaultModel';
      case _imhmhhwa.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i4d8z6ds.StringDefault():
        return 'StringDefault';
      case _iu6k5fkj.StringDefaultMix():
        return 'StringDefaultMix';
      case _ihmqo6od.StringDefaultModel():
        return 'StringDefaultModel';
      case _ih6giyf6.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i2y701qf.UriDefault():
        return 'UriDefault';
      case _iib8h1yl.UriDefaultMix():
        return 'UriDefaultMix';
      case _i1to0y5o.UriDefaultModel():
        return 'UriDefaultModel';
      case _isi15w9f.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _ihsadwhl.UuidDefault():
        return 'UuidDefault';
      case _ignwr848.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i15gwzho.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i2v866bf.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _io8dlrxh.DeferrableRelationInitiallyDeferred():
        return 'DeferrableRelationInitiallyDeferred';
      case _inmfeda2.DeferrableRelationInitiallyImmediate():
        return 'DeferrableRelationInitiallyImmediate';
      case _izxfibiy.DeferrableRelationParent():
        return 'DeferrableRelationParent';
      case _i9l9xrkt.EmptyModel():
        return 'EmptyModel';
      case _ikufh0vd.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _iw4y4x6s.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _iy7bezig.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _is77lrdb.ExceptionWithData():
        return 'ExceptionWithData';
      case _ikh95zxc.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i1y2idkw.NonTableParentClass():
        return 'NonTableParentClass';
      case _i7hqkfn7.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _ix2lcsu0.Department():
        return 'Department';
      case _ixlcmx78.Employee():
        return 'Employee';
      case _iw4adtsk.Contractor():
        return 'Contractor';
      case _i83a3u3u.Service():
        return 'Service';
      case _iox92era.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _ip57k4t4.TestGeneratedCallByeModel():
        return 'TestGeneratedCallByeModel';
      case _ilmnz413.TestGeneratedCallExecuteWithTriggerModel():
        return 'TestGeneratedCallExecuteWithTriggerModel';
      case _ifspsmem.TestGeneratedCallHelloModel():
        return 'TestGeneratedCallHelloModel';
      case _i3yv7lzj.TestGeneratedCallInvokeModel():
        return 'TestGeneratedCallInvokeModel';
      case _isas41s9.ImmutableChildObject():
        return 'ImmutableChildObject';
      case _i8ali8rk.ImmutableChildObjectWithNoAdditionalFields():
        return 'ImmutableChildObjectWithNoAdditionalFields';
      case _ib4436rb.ImmutableObject():
        return 'ImmutableObject';
      case _i5o8gk0d.ImmutableObjectWithImmutableObject():
        return 'ImmutableObjectWithImmutableObject';
      case _ifcovr71.ImmutableObjectWithList():
        return 'ImmutableObjectWithList';
      case _i7chvx7t.ImmutableObjectWithMap():
        return 'ImmutableObjectWithMap';
      case _ijpel12b.ImmutableObjectWithMultipleFields():
        return 'ImmutableObjectWithMultipleFields';
      case _im6ib46o.ImmutableObjectWithNoFields():
        return 'ImmutableObjectWithNoFields';
      case _iz0jdatm.ImmutableObjectWithRecord():
        return 'ImmutableObjectWithRecord';
      case _ij73d01s.ImmutableObjectWithTable():
        return 'ImmutableObjectWithTable';
      case _i6bj8wy3.ImmutableObjectWithTwentyFields():
        return 'ImmutableObjectWithTwentyFields';
      case _ix35kamj.ChildClass():
        return 'ChildClass';
      case _inmco1xt.ServerOnlyChildClass():
        return 'ServerOnlyChildClass';
      case _ibdvdtnv.ChildWithDefault():
        return 'ChildWithDefault';
      case _ieeasgju.ChildWithInheritedId():
        return 'ChildWithInheritedId';
      case _i57yjwwl.ChildClassWithoutId():
        return 'ChildClassWithoutId';
      case _ihtrmue0.ServerOnlyChildClassWithoutId():
        return 'ServerOnlyChildClassWithoutId';
      case _i4ydso50.ExtendedAppException():
        return 'ExtendedAppException';
      case _iw7pve41.BaseAppException():
        return 'BaseAppException';
      case _iaxkp5y4.NotFoundException():
        return 'NotFoundException';
      case _iaxkp5y4.ValidationException():
        return 'ValidationException';
      case _io7upog0.ParentClass():
        return 'ParentClass';
      case _i5sz4l10.GrandparentClass():
        return 'GrandparentClass';
      case _ijexcijb.ParentClassWithoutId():
        return 'ParentClassWithoutId';
      case _iolet7jc.GrandparentClassWithId():
        return 'GrandparentClassWithId';
      case _i2aipqpt.ChildEntity():
        return 'ChildEntity';
      case _i9odpwsh.BaseEntity():
        return 'BaseEntity';
      case _ir6jlp3k.ParentEntity():
        return 'ParentEntity';
      case _igefthms.NonServerOnlyParentClass():
        return 'NonServerOnlyParentClass';
      case _iauswj59.ParentWithChangedId():
        return 'ParentWithChangedId';
      case _iitvxe69.ParentWithDefault():
        return 'ParentWithDefault';
      case _ipndfib1.PolymorphicGrandChild():
        return 'PolymorphicGrandChild';
      case _i11uofdz.PolymorphicChild():
        return 'PolymorphicChild';
      case _iqb6eppn.PolymorphicChildContainer():
        return 'PolymorphicChildContainer';
      case _iw07om20.ModulePolymorphicChildContainer():
        return 'ModulePolymorphicChildContainer';
      case _icfkf6u0.SimilarButNotParent():
        return 'SimilarButNotParent';
      case _i5oq3fsk.PolymorphicParent():
        return 'PolymorphicParent';
      case _ih2dgm3r.UnrelatedToPolymorphism():
        return 'UnrelatedToPolymorphism';
      case _ij7m744x.SealedGrandChild():
        return 'SealedGrandChild';
      case _ij7m744x.SealedChild():
        return 'SealedChild';
      case _iwv9x21d.SealedChildOnlyRequired():
        return 'SealedChildOnlyRequired';
      case _ij7m744x.SealedOtherChild():
        return 'SealedOtherChild';
      case _iycanyn2.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _ifbzwpkm.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _iy2gklrg.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i37b4f1x.MaxFieldName():
        return 'MaxFieldName';
      case _ilm8ux21.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i5zyye9l.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _irdava0x.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i14q426c.UserNote():
        return 'UserNote';
      case _i0cmztzz.UserNoteCollection():
        return 'UserNoteCollection';
      case _ivgcl1bh.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i7zqea9a.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _ify1vf7h.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i0i33txy.City():
        return 'City';
      case _iffzpgud.Organization():
        return 'Organization';
      case _i9x7ls0c.Person():
        return 'Person';
      case _iepu1h7u.BleedChild():
        return 'BleedChild';
      case _ipkncx5k.BleedRoot():
        return 'BleedRoot';
      case _ilvqc6dx.GeneratedRelationCompany():
        return 'GeneratedRelationCompany';
      case _i3ralext.GeneratedRelationEmployee():
        return 'GeneratedRelationEmployee';
      case _isfv2yco.GeneratedRelationOffice():
        return 'GeneratedRelationOffice';
      case _iy2buo88.Course():
        return 'Course';
      case _i8v11x6h.Enrollment():
        return 'Enrollment';
      case _ig5mtn0e.Student():
        return 'Student';
      case _ian3gu05.ObjectUser():
        return 'ObjectUser';
      case _i1h6ufx7.ParentUser():
        return 'ParentUser';
      case _ikwieien.Arena():
        return 'Arena';
      case _ip8wmh4s.Player():
        return 'Player';
      case _ifa5hwxy.Team():
        return 'Team';
      case _ii7cxuye.Comment():
        return 'Comment';
      case _i1nwi4iv.Customer():
        return 'Customer';
      case _if51mnnb.Book():
        return 'Book';
      case _itdsc4u0.Chapter():
        return 'Chapter';
      case _is5jy3ez.Order():
        return 'Order';
      case _i6uupgbr.Address():
        return 'Address';
      case _igeuyxnu.Citizen():
        return 'Citizen';
      case _if6srpch.Company():
        return 'Company';
      case _igjnmbwc.Town():
        return 'Town';
      case _ic5jbe8i.Blocking():
        return 'Blocking';
      case _ijj92mp1.Member():
        return 'Member';
      case _ib9keugy.Cat():
        return 'Cat';
      case _iyh1zt5l.Post():
        return 'Post';
      case _ikm3lhvl.ModuleDatatype():
        return 'ModuleDatatype';
      case _i6x889hl.MyFeatureModel():
        return 'MyFeatureModel';
      case _i47v6vne.MyTriggerType():
        return 'MyTriggerType';
      case _il5sr7xc.Nullability():
        return 'Nullability';
      case _iz2gvrid.NullsDistinctData():
        return 'NullsDistinctData';
      case _i9ffbppf.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _iahgl0he.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _ioxr67zo.ObjectWithBit():
        return 'ObjectWithBit';
      case _iz58zhle.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i6zp404a.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _ijtijns8.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i9hzn3wb.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _ip2vqluy.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _iwdrmoge.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _io7bb4tk.ObjectWithGeographyGeometryCollection():
        return 'ObjectWithGeographyGeometryCollection';
      case _icdfatkc.ObjectWithGeographyLineString():
        return 'ObjectWithGeographyLineString';
      case _i2wdw9b4.ObjectWithGeographyPoint():
        return 'ObjectWithGeographyPoint';
      case _ignhorhm.ObjectWithGeographyPolygon():
        return 'ObjectWithGeographyPolygon';
      case _iy6ksgxz.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _inemzov5.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _ihyvenpw.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i4p0t2g0.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i26q9u41.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i2qtgitl.ObjectWithNullableCustomClass():
        return 'ObjectWithNullableCustomClass';
      case _i4hr2e9p.ObjectWithObject():
        return 'ObjectWithObject';
      case _io0t3u2c.ObjectWithParent():
        return 'ObjectWithParent';
      case _im4j7lpz.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _itdevv9e.ObjectWithSealedException():
        return 'ObjectWithSealedException';
      case _ihluvkmz.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i8t20dyr.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _iusk9w05.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _itmc4j9i.ObjectWithVector():
        return 'ObjectWithVector';
      case _ificmsie.Record():
        return 'Record';
      case _i2aw39a6.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _iiggggl6.ExceptionWithRequiredField():
        return 'ExceptionWithRequiredField';
      case _iv7egjxb.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _ixhyrkj6.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _igfnl8bc.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _it7f5mv0.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _ilchwovc.Article():
        return 'Article';
      case _ip3v2qu9.ArticleList():
        return 'ArticleList';
      case _i8lxkh3j.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i96dkulb.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _ilb1g1z5.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _ik117x9c.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _ijh817kc.ServerOnlyClass():
        return 'ServerOnlyClass';
      case _iuyjh56c.ServerOnlyEnum():
        return 'ServerOnlyEnum';
      case _izzkyevr.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _iy81tiee.ServerOnlyDefault():
        return 'ServerOnlyDefault';
      case _iz7kinop.SessionAuthInfo():
        return 'SessionAuthInfo';
      case _icmi6q0i.SharedModelContainer():
        return 'SharedModelContainer';
      case _iu5vt3uc.SharedModelSubclass():
        return 'SharedModelSubclass';
      case _i0zisc0t.SimpleData():
        return 'SimpleData';
      case _iyexv7xa.SimpleDataList():
        return 'SimpleDataList';
      case _iu6b143l.SimpleDataMap():
        return 'SimpleDataMap';
      case _ikkvbzqw.SimpleDataObject():
        return 'SimpleDataObject';
      case _i1duz4kf.SimpleDateTime():
        return 'SimpleDateTime';
      case _il2trryf.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _ionapfu9.TestEnum():
        return 'TestEnum';
      case _icplrpi3.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _it39smib.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _izw460bh.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i7liykk2.TestEnumStringified():
        return 'TestEnumStringified';
      case _iwxwszsz.Types():
        return 'Types';
      case _irfb5ten.TypesList():
        return 'TypesList';
      case _i81vljk7.TypesMap():
        return 'TypesMap';
      case _irmygd7t.TypesRecord():
        return 'TypesRecord';
      case _iiutqksg.TypesSet():
        return 'TypesSet';
      case _ir494j8f.TypesSetRequired():
        return 'TypesSetRequired';
      case _iufhyrjh.UniqueData():
        return 'UniqueData';
      case _ip8yzqii.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _iwbeyn4p.UpsertTestModel():
        return 'UpsertTestModel';
    }
    if (data is List<int>) {
      return 'List<int>';
    }
    if (data is List<_i685tvwm.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i1n3uhu0.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i685tvwm.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i685tvwm.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i685tvwm.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i685tvwm.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (String, _ieub4zqi.PolymorphicParent)) {
      return '(String,PolymorphicParent)';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data
        is List<
          ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?
        >?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (int?, _iom2gwyu.ProjectStreamingClass?)) {
      return '(int?,serverpod_test_module.ProjectStreamingClass?)';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
        )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data
        is (
          String,
          (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
        )?) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?';
    }
    if (data is List<(String, int)>?) {
      return 'List<(String,int)>?';
    }
    className = _i1n3uhu0.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.') ? className : 'serverpod_auth.$className';
    }
    className = _iom2gwyu.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_module.$className';
    }
    className = _iyx9etqn.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_shared_module.$className';
    }
    className = _ilwf0zl1.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_shared.$className';
    }
    className = _isp.Protocol().getClassNameForObject(data);
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
      return deserialize<_ilwf0zl1.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_ilwf0zl1.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_ilwf0zl1.CustomClassWithoutProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_ilwf0zl1.CustomClassWithProtocolSerialization>(
        data['data'],
      );
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_ilwf0zl1.CustomClassWithProtocolSerializationMethod>(
        data['data'],
      );
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_ilwf0zl1.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_ilwf0zl1.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_ilwf0zl1.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_ihs9bjzx.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_iwdug2n0.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'CourseUuid') {
      return deserialize<_ik6ri27s.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_icdgc05t.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_ibrjea6w.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_isj7c5mo.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_ivdpnfmj.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_ivehlt2f.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i3jtpxta.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_iimgofmw.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_iywnby31.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_ifwqt4rb.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_idhvg1zk.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i5vwm04a.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_iu7osokh.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_ixc9sah8.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChangedIdFieldClass') {
      return deserialize<_irw3jmaq.ServerOnlyChangedIdFieldClass>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_icrmubzc.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i1xsun18.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i332rqur.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_ia4nw21o.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_ilirabmz.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_iwhzartq.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_izvr7tnf.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i135uugo.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_iro0mlkq.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_igjm2894.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_ivkcoq83.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_iaqar0o9.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_izu05ym4.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_iou6kksr.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i9xv7g6i.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_iynhhcdw.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_ixvw8l6s.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_ialx1ytx.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i5aouk9m.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_ij5e1q2b.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_ihqxpva2.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_iyezrrxn.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_iw4wb1ju.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i0p9yn0v.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i4ekvn16.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_ihrgmscf.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_iirkfcfb.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_iv40kyzq.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i8t3u1nx.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_iummzlp0.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i4rypx08.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_imhmhhwa.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i4d8z6ds.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_iu6k5fkj.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_ihmqo6od.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_ih6giyf6.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i2y701qf.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_iib8h1yl.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i1to0y5o.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_isi15w9f.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_ihsadwhl.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_ignwr848.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i15gwzho.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i2v866bf.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DeferrableRelationInitiallyDeferred') {
      return deserialize<_io8dlrxh.DeferrableRelationInitiallyDeferred>(
        data['data'],
      );
    }
    if (dataClassName == 'DeferrableRelationInitiallyImmediate') {
      return deserialize<_inmfeda2.DeferrableRelationInitiallyImmediate>(
        data['data'],
      );
    }
    if (dataClassName == 'DeferrableRelationParent') {
      return deserialize<_izxfibiy.DeferrableRelationParent>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i9l9xrkt.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_ikufh0vd.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_iw4y4x6s.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_iy7bezig.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_is77lrdb.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_ikh95zxc.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i1y2idkw.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i7hqkfn7.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_ix2lcsu0.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_ixlcmx78.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_iw4adtsk.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i83a3u3u.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_iox92era.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'TestGeneratedCallByeModel') {
      return deserialize<_ip57k4t4.TestGeneratedCallByeModel>(data['data']);
    }
    if (dataClassName == 'TestGeneratedCallExecuteWithTriggerModel') {
      return deserialize<_ilmnz413.TestGeneratedCallExecuteWithTriggerModel>(
        data['data'],
      );
    }
    if (dataClassName == 'TestGeneratedCallHelloModel') {
      return deserialize<_ifspsmem.TestGeneratedCallHelloModel>(data['data']);
    }
    if (dataClassName == 'TestGeneratedCallInvokeModel') {
      return deserialize<_i3yv7lzj.TestGeneratedCallInvokeModel>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObject') {
      return deserialize<_isas41s9.ImmutableChildObject>(data['data']);
    }
    if (dataClassName == 'ImmutableChildObjectWithNoAdditionalFields') {
      return deserialize<_i8ali8rk.ImmutableChildObjectWithNoAdditionalFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObject') {
      return deserialize<_ib4436rb.ImmutableObject>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithImmutableObject') {
      return deserialize<_i5o8gk0d.ImmutableObjectWithImmutableObject>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObjectWithList') {
      return deserialize<_ifcovr71.ImmutableObjectWithList>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMap') {
      return deserialize<_i7chvx7t.ImmutableObjectWithMap>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithMultipleFields') {
      return deserialize<_ijpel12b.ImmutableObjectWithMultipleFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ImmutableObjectWithNoFields') {
      return deserialize<_im6ib46o.ImmutableObjectWithNoFields>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithRecord') {
      return deserialize<_iz0jdatm.ImmutableObjectWithRecord>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTable') {
      return deserialize<_ij73d01s.ImmutableObjectWithTable>(data['data']);
    }
    if (dataClassName == 'ImmutableObjectWithTwentyFields') {
      return deserialize<_i6bj8wy3.ImmutableObjectWithTwentyFields>(
        data['data'],
      );
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_ix35kamj.ChildClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClass') {
      return deserialize<_inmco1xt.ServerOnlyChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_ibdvdtnv.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ChildWithInheritedId') {
      return deserialize<_ieeasgju.ChildWithInheritedId>(data['data']);
    }
    if (dataClassName == 'ChildClassWithoutId') {
      return deserialize<_i57yjwwl.ChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChildClassWithoutId') {
      return deserialize<_ihtrmue0.ServerOnlyChildClassWithoutId>(data['data']);
    }
    if (dataClassName == 'ExtendedAppException') {
      return deserialize<_i4ydso50.ExtendedAppException>(data['data']);
    }
    if (dataClassName == 'BaseAppException') {
      return deserialize<_iw7pve41.BaseAppException>(data['data']);
    }
    if (dataClassName == 'NotFoundException') {
      return deserialize<_iaxkp5y4.NotFoundException>(data['data']);
    }
    if (dataClassName == 'ValidationException') {
      return deserialize<_iaxkp5y4.ValidationException>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_io7upog0.ParentClass>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i5sz4l10.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClassWithoutId') {
      return deserialize<_ijexcijb.ParentClassWithoutId>(data['data']);
    }
    if (dataClassName == 'GrandparentClassWithId') {
      return deserialize<_iolet7jc.GrandparentClassWithId>(data['data']);
    }
    if (dataClassName == 'ChildEntity') {
      return deserialize<_i2aipqpt.ChildEntity>(data['data']);
    }
    if (dataClassName == 'BaseEntity') {
      return deserialize<_i9odpwsh.BaseEntity>(data['data']);
    }
    if (dataClassName == 'ParentEntity') {
      return deserialize<_ir6jlp3k.ParentEntity>(data['data']);
    }
    if (dataClassName == 'NonServerOnlyParentClass') {
      return deserialize<_igefthms.NonServerOnlyParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithChangedId') {
      return deserialize<_iauswj59.ParentWithChangedId>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_iitvxe69.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'PolymorphicGrandChild') {
      return deserialize<_ipndfib1.PolymorphicGrandChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChild') {
      return deserialize<_i11uofdz.PolymorphicChild>(data['data']);
    }
    if (dataClassName == 'PolymorphicChildContainer') {
      return deserialize<_iqb6eppn.PolymorphicChildContainer>(data['data']);
    }
    if (dataClassName == 'ModulePolymorphicChildContainer') {
      return deserialize<_iw07om20.ModulePolymorphicChildContainer>(
        data['data'],
      );
    }
    if (dataClassName == 'SimilarButNotParent') {
      return deserialize<_icfkf6u0.SimilarButNotParent>(data['data']);
    }
    if (dataClassName == 'PolymorphicParent') {
      return deserialize<_i5oq3fsk.PolymorphicParent>(data['data']);
    }
    if (dataClassName == 'UnrelatedToPolymorphism') {
      return deserialize<_ih2dgm3r.UnrelatedToPolymorphism>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_ij7m744x.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_ij7m744x.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedChildOnlyRequired') {
      return deserialize<_iwv9x21d.SealedChildOnlyRequired>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_ij7m744x.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_iycanyn2.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_ifbzwpkm.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_iy2gklrg.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i37b4f1x.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_ilm8ux21.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i5zyye9l.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_irdava0x.RelationToMultipleMaxFieldName>(
        data['data'],
      );
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i14q426c.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i0cmztzz.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_ivgcl1bh.UserNoteCollectionWithALongName>(
        data['data'],
      );
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i7zqea9a.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_ify1vf7h.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i0i33txy.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_iffzpgud.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i9x7ls0c.Person>(data['data']);
    }
    if (dataClassName == 'BleedChild') {
      return deserialize<_iepu1h7u.BleedChild>(data['data']);
    }
    if (dataClassName == 'BleedRoot') {
      return deserialize<_ipkncx5k.BleedRoot>(data['data']);
    }
    if (dataClassName == 'GeneratedRelationCompany') {
      return deserialize<_ilvqc6dx.GeneratedRelationCompany>(data['data']);
    }
    if (dataClassName == 'GeneratedRelationEmployee') {
      return deserialize<_i3ralext.GeneratedRelationEmployee>(data['data']);
    }
    if (dataClassName == 'GeneratedRelationOffice') {
      return deserialize<_isfv2yco.GeneratedRelationOffice>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_iy2buo88.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i8v11x6h.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_ig5mtn0e.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_ian3gu05.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i1h6ufx7.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_ikwieien.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_ip8wmh4s.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_ifa5hwxy.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_ii7cxuye.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i1nwi4iv.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_if51mnnb.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_itdsc4u0.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_is5jy3ez.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i6uupgbr.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_igeuyxnu.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_if6srpch.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_igjnmbwc.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_ic5jbe8i.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_ijj92mp1.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_ib9keugy.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_iyh1zt5l.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_ikm3lhvl.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i6x889hl.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'MyTriggerType') {
      return deserialize<_i47v6vne.MyTriggerType>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_il5sr7xc.Nullability>(data['data']);
    }
    if (dataClassName == 'NullsDistinctData') {
      return deserialize<_iz2gvrid.NullsDistinctData>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i9ffbppf.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_iahgl0he.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_ioxr67zo.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_iz58zhle.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i6zp404a.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_ijtijns8.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithDynamic') {
      return deserialize<_i9hzn3wb.ObjectWithDynamic>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_ip2vqluy.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_iwdrmoge.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithGeographyGeometryCollection') {
      return deserialize<_io7bb4tk.ObjectWithGeographyGeometryCollection>(
        data['data'],
      );
    }
    if (dataClassName == 'ObjectWithGeographyLineString') {
      return deserialize<_icdfatkc.ObjectWithGeographyLineString>(data['data']);
    }
    if (dataClassName == 'ObjectWithGeographyPoint') {
      return deserialize<_i2wdw9b4.ObjectWithGeographyPoint>(data['data']);
    }
    if (dataClassName == 'ObjectWithGeographyPolygon') {
      return deserialize<_ignhorhm.ObjectWithGeographyPolygon>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_iy6ksgxz.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_inemzov5.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_ihyvenpw.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i4p0t2g0.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i26q9u41.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithNullableCustomClass') {
      return deserialize<_i2qtgitl.ObjectWithNullableCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i4hr2e9p.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_io0t3u2c.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_im4j7lpz.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedException') {
      return deserialize<_itdevv9e.ObjectWithSealedException>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_ihluvkmz.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i8t20dyr.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_iusk9w05.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_itmc4j9i.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_ificmsie.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i2aw39a6.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ExceptionWithRequiredField') {
      return deserialize<_iiggggl6.ExceptionWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_iv7egjxb.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_ixhyrkj6.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_igfnl8bc.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_it7f5mv0.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'Article') {
      return deserialize<_ilchwovc.Article>(data['data']);
    }
    if (dataClassName == 'ArticleList') {
      return deserialize<_ip3v2qu9.ArticleList>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i8lxkh3j.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i96dkulb.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_ilb1g1z5.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_ik117x9c.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClass') {
      return deserialize<_ijh817kc.ServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyEnum') {
      return deserialize<_iuyjh56c.ServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_izzkyevr.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'ServerOnlyDefault') {
      return deserialize<_iy81tiee.ServerOnlyDefault>(data['data']);
    }
    if (dataClassName == 'SessionAuthInfo') {
      return deserialize<_iz7kinop.SessionAuthInfo>(data['data']);
    }
    if (dataClassName == 'SharedModelContainer') {
      return deserialize<_icmi6q0i.SharedModelContainer>(data['data']);
    }
    if (dataClassName == 'SharedModelSubclass') {
      return deserialize<_iu5vt3uc.SharedModelSubclass>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i0zisc0t.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_iyexv7xa.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_iu6b143l.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_ikkvbzqw.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i1duz4kf.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_il2trryf.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_ionapfu9.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_icplrpi3.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_it39smib.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_izw460bh.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i7liykk2.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_iwxwszsz.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_irfb5ten.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i81vljk7.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_irmygd7t.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_iiutqksg.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_ir494j8f.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_iufhyrjh.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_ip8yzqii.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_iwbeyn4p.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth.')) {
      data['className'] = dataClassName.substring(15);
      return _i1n3uhu0.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_module.')) {
      data['className'] = dataClassName.substring(22);
      return _iom2gwyu.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_shared_module.')) {
      data['className'] = dataClassName.substring(29);
      return _iyx9etqn.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_shared.')) {
      data['className'] = dataClassName.substring(22);
      return _ilwf0zl1.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _isp.Protocol().deserializeByClassName(data);
    }
    if (dataClassName == 'List<int>') {
      return deserialize<List<int>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>') {
      return deserialize<List<_i685tvwm.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i1n3uhu0.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i685tvwm.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i685tvwm.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i685tvwm.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i685tvwm.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(String,PolymorphicParent)') {
      return deserialize<(String, _ieub4zqi.PolymorphicParent)>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
        List<((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})?>?
      >(data['data']);
    }
    if (dataClassName ==
        '(int?,serverpod_test_module.ProjectStreamingClass?)') {
      return deserialize<(int?, _iom2gwyu.ProjectStreamingClass?)>(
        data['data'],
      );
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
        (
          String,
          (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
        )
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
        (
          String,
          (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
        )?
      >(data['data']);
    }
    if (dataClassName == 'List<(String,int)>?') {
      return deserialize<List<(String, int)>?>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i1n3uhu0.Protocol().registerHostProtocol('serverpod_test', this);
    _iom2gwyu.Protocol().registerHostProtocol('serverpod_test', this);
    _iyx9etqn.Protocol().registerHostProtocol('serverpod_test', this);
    _ilwf0zl1.Protocol().registerHostProtocol('serverpod_test', this);
  }

  @override
  _is.Table? getTableForType(Type t) {
    {
      var table = _i1n3uhu0.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iom2gwyu.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var table = _iyx9etqn.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _ilwf0zl1.Protocol();
      var table = protocol is _is.DatabaseSerializationManager
          ? (protocol as _is.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var table = _isp.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ik6ri27s.CourseUuid:
        return _ik6ri27s.CourseUuid.t;
      case _icdgc05t.EnrollmentInt:
        return _icdgc05t.EnrollmentInt.t;
      case _ibrjea6w.StudentUuid:
        return _ibrjea6w.StudentUuid.t;
      case _isj7c5mo.ArenaUuid:
        return _isj7c5mo.ArenaUuid.t;
      case _ivdpnfmj.PlayerUuid:
        return _ivdpnfmj.PlayerUuid.t;
      case _ivehlt2f.TeamInt:
        return _ivehlt2f.TeamInt.t;
      case _i3jtpxta.CommentInt:
        return _i3jtpxta.CommentInt.t;
      case _iimgofmw.CustomerInt:
        return _iimgofmw.CustomerInt.t;
      case _iywnby31.OrderUuid:
        return _iywnby31.OrderUuid.t;
      case _ifwqt4rb.AddressUuid:
        return _ifwqt4rb.AddressUuid.t;
      case _idhvg1zk.CitizenInt:
        return _idhvg1zk.CitizenInt.t;
      case _i5vwm04a.CompanyUuid:
        return _i5vwm04a.CompanyUuid.t;
      case _iu7osokh.TownInt:
        return _iu7osokh.TownInt.t;
      case _ixc9sah8.ChangedIdTypeSelf:
        return _ixc9sah8.ChangedIdTypeSelf.t;
      case _irw3jmaq.ServerOnlyChangedIdFieldClass:
        return _irw3jmaq.ServerOnlyChangedIdFieldClass.t;
      case _icrmubzc.BigIntDefault:
        return _icrmubzc.BigIntDefault.t;
      case _i1xsun18.BigIntDefaultMix:
        return _i1xsun18.BigIntDefaultMix.t;
      case _i332rqur.BigIntDefaultModel:
        return _i332rqur.BigIntDefaultModel.t;
      case _ia4nw21o.BigIntDefaultPersist:
        return _ia4nw21o.BigIntDefaultPersist.t;
      case _ilirabmz.BoolDefault:
        return _ilirabmz.BoolDefault.t;
      case _iwhzartq.BoolDefaultMix:
        return _iwhzartq.BoolDefaultMix.t;
      case _izvr7tnf.BoolDefaultModel:
        return _izvr7tnf.BoolDefaultModel.t;
      case _i135uugo.BoolDefaultPersist:
        return _i135uugo.BoolDefaultPersist.t;
      case _iro0mlkq.DateTimeDefault:
        return _iro0mlkq.DateTimeDefault.t;
      case _igjm2894.DateTimeDefaultMix:
        return _igjm2894.DateTimeDefaultMix.t;
      case _ivkcoq83.DateTimeDefaultModel:
        return _ivkcoq83.DateTimeDefaultModel.t;
      case _iaqar0o9.DateTimeDefaultPersist:
        return _iaqar0o9.DateTimeDefaultPersist.t;
      case _izu05ym4.DoubleDefault:
        return _izu05ym4.DoubleDefault.t;
      case _iou6kksr.DoubleDefaultMix:
        return _iou6kksr.DoubleDefaultMix.t;
      case _i9xv7g6i.DoubleDefaultModel:
        return _i9xv7g6i.DoubleDefaultModel.t;
      case _iynhhcdw.DoubleDefaultPersist:
        return _iynhhcdw.DoubleDefaultPersist.t;
      case _ixvw8l6s.DurationDefault:
        return _ixvw8l6s.DurationDefault.t;
      case _ialx1ytx.DurationDefaultMix:
        return _ialx1ytx.DurationDefaultMix.t;
      case _i5aouk9m.DurationDefaultModel:
        return _i5aouk9m.DurationDefaultModel.t;
      case _ij5e1q2b.DurationDefaultPersist:
        return _ij5e1q2b.DurationDefaultPersist.t;
      case _ihqxpva2.EnumDefault:
        return _ihqxpva2.EnumDefault.t;
      case _iyezrrxn.EnumDefaultMix:
        return _iyezrrxn.EnumDefaultMix.t;
      case _iw4wb1ju.EnumDefaultModel:
        return _iw4wb1ju.EnumDefaultModel.t;
      case _i0p9yn0v.EnumDefaultPersist:
        return _i0p9yn0v.EnumDefaultPersist.t;
      case _i8t3u1nx.IntDefault:
        return _i8t3u1nx.IntDefault.t;
      case _iummzlp0.IntDefaultMix:
        return _iummzlp0.IntDefaultMix.t;
      case _i4rypx08.IntDefaultModel:
        return _i4rypx08.IntDefaultModel.t;
      case _imhmhhwa.IntDefaultPersist:
        return _imhmhhwa.IntDefaultPersist.t;
      case _i4d8z6ds.StringDefault:
        return _i4d8z6ds.StringDefault.t;
      case _iu6k5fkj.StringDefaultMix:
        return _iu6k5fkj.StringDefaultMix.t;
      case _ihmqo6od.StringDefaultModel:
        return _ihmqo6od.StringDefaultModel.t;
      case _ih6giyf6.StringDefaultPersist:
        return _ih6giyf6.StringDefaultPersist.t;
      case _i2y701qf.UriDefault:
        return _i2y701qf.UriDefault.t;
      case _iib8h1yl.UriDefaultMix:
        return _iib8h1yl.UriDefaultMix.t;
      case _i1to0y5o.UriDefaultModel:
        return _i1to0y5o.UriDefaultModel.t;
      case _isi15w9f.UriDefaultPersist:
        return _isi15w9f.UriDefaultPersist.t;
      case _ihsadwhl.UuidDefault:
        return _ihsadwhl.UuidDefault.t;
      case _ignwr848.UuidDefaultMix:
        return _ignwr848.UuidDefaultMix.t;
      case _i15gwzho.UuidDefaultModel:
        return _i15gwzho.UuidDefaultModel.t;
      case _i2v866bf.UuidDefaultPersist:
        return _i2v866bf.UuidDefaultPersist.t;
      case _io8dlrxh.DeferrableRelationInitiallyDeferred:
        return _io8dlrxh.DeferrableRelationInitiallyDeferred.t;
      case _inmfeda2.DeferrableRelationInitiallyImmediate:
        return _inmfeda2.DeferrableRelationInitiallyImmediate.t;
      case _izxfibiy.DeferrableRelationParent:
        return _izxfibiy.DeferrableRelationParent.t;
      case _ikufh0vd.EmptyModelRelationItem:
        return _ikufh0vd.EmptyModelRelationItem.t;
      case _iw4y4x6s.EmptyModelWithTable:
        return _iw4y4x6s.EmptyModelWithTable.t;
      case _iy7bezig.RelationEmptyModel:
        return _iy7bezig.RelationEmptyModel.t;
      case _ikh95zxc.ChildClassExplicitColumn:
        return _ikh95zxc.ChildClassExplicitColumn.t;
      case _i7hqkfn7.ModifiedColumnName:
        return _i7hqkfn7.ModifiedColumnName.t;
      case _ix2lcsu0.Department:
        return _ix2lcsu0.Department.t;
      case _ixlcmx78.Employee:
        return _ixlcmx78.Employee.t;
      case _iw4adtsk.Contractor:
        return _iw4adtsk.Contractor.t;
      case _i83a3u3u.Service:
        return _i83a3u3u.Service.t;
      case _iox92era.TableWithExplicitColumnName:
        return _iox92era.TableWithExplicitColumnName.t;
      case _ij73d01s.ImmutableObjectWithTable:
        return _ij73d01s.ImmutableObjectWithTable.t;
      case _ieeasgju.ChildWithInheritedId:
        return _ieeasgju.ChildWithInheritedId.t;
      case _i57yjwwl.ChildClassWithoutId:
        return _i57yjwwl.ChildClassWithoutId.t;
      case _io7upog0.ParentClass:
        return _io7upog0.ParentClass.t;
      case _i2aipqpt.ChildEntity:
        return _i2aipqpt.ChildEntity.t;
      case _ir6jlp3k.ParentEntity:
        return _ir6jlp3k.ParentEntity.t;
      case _iycanyn2.CityWithLongTableName:
        return _iycanyn2.CityWithLongTableName.t;
      case _ifbzwpkm.OrganizationWithLongTableName:
        return _ifbzwpkm.OrganizationWithLongTableName.t;
      case _iy2gklrg.PersonWithLongTableName:
        return _iy2gklrg.PersonWithLongTableName.t;
      case _i37b4f1x.MaxFieldName:
        return _i37b4f1x.MaxFieldName.t;
      case _ilm8ux21.LongImplicitIdField:
        return _ilm8ux21.LongImplicitIdField.t;
      case _i5zyye9l.LongImplicitIdFieldCollection:
        return _i5zyye9l.LongImplicitIdFieldCollection.t;
      case _irdava0x.RelationToMultipleMaxFieldName:
        return _irdava0x.RelationToMultipleMaxFieldName.t;
      case _i14q426c.UserNote:
        return _i14q426c.UserNote.t;
      case _i0cmztzz.UserNoteCollection:
        return _i0cmztzz.UserNoteCollection.t;
      case _ivgcl1bh.UserNoteCollectionWithALongName:
        return _ivgcl1bh.UserNoteCollectionWithALongName.t;
      case _i7zqea9a.UserNoteWithALongName:
        return _i7zqea9a.UserNoteWithALongName.t;
      case _ify1vf7h.MultipleMaxFieldName:
        return _ify1vf7h.MultipleMaxFieldName.t;
      case _i0i33txy.City:
        return _i0i33txy.City.t;
      case _iffzpgud.Organization:
        return _iffzpgud.Organization.t;
      case _i9x7ls0c.Person:
        return _i9x7ls0c.Person.t;
      case _iepu1h7u.BleedChild:
        return _iepu1h7u.BleedChild.t;
      case _ipkncx5k.BleedRoot:
        return _ipkncx5k.BleedRoot.t;
      case _ilvqc6dx.GeneratedRelationCompany:
        return _ilvqc6dx.GeneratedRelationCompany.t;
      case _i3ralext.GeneratedRelationEmployee:
        return _i3ralext.GeneratedRelationEmployee.t;
      case _isfv2yco.GeneratedRelationOffice:
        return _isfv2yco.GeneratedRelationOffice.t;
      case _iy2buo88.Course:
        return _iy2buo88.Course.t;
      case _i8v11x6h.Enrollment:
        return _i8v11x6h.Enrollment.t;
      case _ig5mtn0e.Student:
        return _ig5mtn0e.Student.t;
      case _ian3gu05.ObjectUser:
        return _ian3gu05.ObjectUser.t;
      case _i1h6ufx7.ParentUser:
        return _i1h6ufx7.ParentUser.t;
      case _ikwieien.Arena:
        return _ikwieien.Arena.t;
      case _ip8wmh4s.Player:
        return _ip8wmh4s.Player.t;
      case _ifa5hwxy.Team:
        return _ifa5hwxy.Team.t;
      case _ii7cxuye.Comment:
        return _ii7cxuye.Comment.t;
      case _i1nwi4iv.Customer:
        return _i1nwi4iv.Customer.t;
      case _if51mnnb.Book:
        return _if51mnnb.Book.t;
      case _itdsc4u0.Chapter:
        return _itdsc4u0.Chapter.t;
      case _is5jy3ez.Order:
        return _is5jy3ez.Order.t;
      case _i6uupgbr.Address:
        return _i6uupgbr.Address.t;
      case _igeuyxnu.Citizen:
        return _igeuyxnu.Citizen.t;
      case _if6srpch.Company:
        return _if6srpch.Company.t;
      case _igjnmbwc.Town:
        return _igjnmbwc.Town.t;
      case _ic5jbe8i.Blocking:
        return _ic5jbe8i.Blocking.t;
      case _ijj92mp1.Member:
        return _ijj92mp1.Member.t;
      case _ib9keugy.Cat:
        return _ib9keugy.Cat.t;
      case _iyh1zt5l.Post:
        return _iyh1zt5l.Post.t;
      case _iz2gvrid.NullsDistinctData:
        return _iz2gvrid.NullsDistinctData.t;
      case _i9ffbppf.ObjectFieldPersist:
        return _i9ffbppf.ObjectFieldPersist.t;
      case _iahgl0he.ObjectFieldScopes:
        return _iahgl0he.ObjectFieldScopes.t;
      case _ioxr67zo.ObjectWithBit:
        return _ioxr67zo.ObjectWithBit.t;
      case _iz58zhle.ObjectWithByteData:
        return _iz58zhle.ObjectWithByteData.t;
      case _ijtijns8.ObjectWithDuration:
        return _ijtijns8.ObjectWithDuration.t;
      case _i9hzn3wb.ObjectWithDynamic:
        return _i9hzn3wb.ObjectWithDynamic.t;
      case _ip2vqluy.ObjectWithEnum:
        return _ip2vqluy.ObjectWithEnum.t;
      case _iwdrmoge.ObjectWithEnumEnhanced:
        return _iwdrmoge.ObjectWithEnumEnhanced.t;
      case _io7bb4tk.ObjectWithGeographyGeometryCollection:
        return _io7bb4tk.ObjectWithGeographyGeometryCollection.t;
      case _icdfatkc.ObjectWithGeographyLineString:
        return _icdfatkc.ObjectWithGeographyLineString.t;
      case _i2wdw9b4.ObjectWithGeographyPoint:
        return _i2wdw9b4.ObjectWithGeographyPoint.t;
      case _ignhorhm.ObjectWithGeographyPolygon:
        return _ignhorhm.ObjectWithGeographyPolygon.t;
      case _iy6ksgxz.ObjectWithHalfVector:
        return _iy6ksgxz.ObjectWithHalfVector.t;
      case _inemzov5.ObjectWithIndex:
        return _inemzov5.ObjectWithIndex.t;
      case _ihyvenpw.ObjectWithJsonb:
        return _ihyvenpw.ObjectWithJsonb.t;
      case _i4p0t2g0.ObjectWithJsonbClassLevel:
        return _i4p0t2g0.ObjectWithJsonbClassLevel.t;
      case _i4hr2e9p.ObjectWithObject:
        return _i4hr2e9p.ObjectWithObject.t;
      case _io0t3u2c.ObjectWithParent:
        return _io0t3u2c.ObjectWithParent.t;
      case _ihluvkmz.ObjectWithSelfParent:
        return _ihluvkmz.ObjectWithSelfParent.t;
      case _i8t20dyr.ObjectWithSparseVector:
        return _i8t20dyr.ObjectWithSparseVector.t;
      case _iusk9w05.ObjectWithUuid:
        return _iusk9w05.ObjectWithUuid.t;
      case _itmc4j9i.ObjectWithVector:
        return _itmc4j9i.ObjectWithVector.t;
      case _i2aw39a6.RelatedUniqueData:
        return _i2aw39a6.RelatedUniqueData.t;
      case _iv7egjxb.ModelWithRequiredField:
        return _iv7egjxb.ModelWithRequiredField.t;
      case _ixhyrkj6.ScopeNoneFields:
        return _ixhyrkj6.ScopeNoneFields.t;
      case _icmi6q0i.SharedModelContainer:
        return _icmi6q0i.SharedModelContainer.t;
      case _i0zisc0t.SimpleData:
        return _i0zisc0t.SimpleData.t;
      case _i1duz4kf.SimpleDateTime:
        return _i1duz4kf.SimpleDateTime.t;
      case _iwxwszsz.Types:
        return _iwxwszsz.Types.t;
      case _iufhyrjh.UniqueData:
        return _iufhyrjh.UniqueData.t;
      case _ip8yzqii.UniqueDataWithNonPersist:
        return _ip8yzqii.UniqueDataWithNonPersist.t;
      case _iwbeyn4p.UpsertTestModel:
        return _iwbeyn4p.UpsertTestModel.t;
    }
    return null;
  }

  @override
  List<_isp.TableDefinition> getTargetTableDefinitions() =>
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
    if (record is (String, _ieub4zqi.PolymorphicParent)) {
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
    if (record is (int, _i685tvwm.SimpleData)) {
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
    if (record is ({_i685tvwm.SimpleData data, int number})) {
      return {
        "n": {
          "data": record.data.toJson(),
          "number": record.number,
        },
      };
    }
    if (record is ({_i685tvwm.SimpleData? data, int? number})) {
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
    if (record is (int, {_i685tvwm.SimpleData data})) {
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
    if (record is ({(_i685tvwm.SimpleData, double) namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (_i685tvwm.SimpleData, double)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2,
        ],
      };
    }
    if (record is ({(_i685tvwm.SimpleData, double)? namedSubRecord})) {
      return {
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record
        is ((int, String), {(_i685tvwm.SimpleData, double) namedSubRecord})) {
      return {
        "p": [
          mapRecordToJson(record.$1),
        ],
        "n": {
          "namedSubRecord": mapRecordToJson(record.namedSubRecord),
        },
      };
    }
    if (record is (int?, _iom2gwyu.ProjectStreamingClass?)) {
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
          (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData}),
        )) {
      return {
        "p": [
          record.$1,
          mapRecordToJson(record.$2),
        ],
      };
    }
    if (record
        is (Map<String, int>, {bool flag, _i685tvwm.SimpleData simpleData})) {
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
    if (record is (_iom2gwyu.ModuleClass,)) {
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
    if (record is (_i7liykk2.TestEnumStringified,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is (_il5sr7xc.Nullability,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i7liykk2.TestEnumStringified value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_iom2gwyu.ModuleClass value})) {
      return {
        "n": {
          "value": record.value.toJson(),
        },
      };
    }
    if (record is ({_il5sr7xc.Nullability value})) {
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
    if (record is (_ionapfu9.TestEnum,)) {
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
    if (record is (_idt.ByteData,)) {
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
    if (record is (_is.UuidValue,)) {
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
    if (record is (_i0zisc0t.SimpleData,)) {
      return {
        "p": [
          record.$1.toJson(),
        ],
      };
    }
    if (record is ({_i0zisc0t.SimpleData namedModel})) {
      return {
        "n": {
          "namedModel": record.namedModel.toJson(),
        },
      };
    }
    if (record is (_i0zisc0t.SimpleData, {_i0zisc0t.SimpleData namedModel})) {
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
          (List<(_i0zisc0t.SimpleData,)>,), {
          (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)
          namedNestedRecord,
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
    if (record is (List<(_i0zisc0t.SimpleData,)>,)) {
      return {
        "p": [
          mapContainerToJson(record.$1),
        ],
      };
    }
    if (record is (_i0zisc0t.SimpleData, Map<String, _i0zisc0t.SimpleData>)) {
      return {
        "p": [
          record.$1.toJson(),
          record.$2.toJson(),
        ],
      };
    }
    try {
      return _i1n3uhu0.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iom2gwyu.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iyx9etqn.Protocol().mapRecordToJson(record);
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
