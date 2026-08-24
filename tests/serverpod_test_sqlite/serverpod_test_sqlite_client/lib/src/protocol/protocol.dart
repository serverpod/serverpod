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
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _iacc;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _iaic;
import 'package:serverpod_client/serverpod_client.dart' as _isc;
import 'package:serverpod_database/serverpod_database.dart' as _isd;
import 'package:serverpod_service_client/serverpod_service_client.dart'
    as _issc;
import 'package:serverpod_test_shared_module_client/serverpod_test_shared_module_client.dart'
    as _iyerxm0e;
import 'package:serverpod_test_sqlite_client/src/protocol/simple_data.dart'
    as _ilnisupq;
import 'package:serverpod_test_sqlite_shared/serverpod_test_sqlite_shared.dart'
    as _iqfgygbv;
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
import 'inheritance/sealed_parent.dart' as _ij7m744x;
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
import 'models_with_relations/many_to_many/course.dart' as _iy2buo88;
import 'models_with_relations/many_to_many/enrollment.dart' as _i8v11x6h;
import 'models_with_relations/many_to_many/student.dart' as _ig5mtn0e;
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
import 'nulls_distinct_data.dart' as _iz2gvrid;
import 'object_field_persist.dart' as _i9ffbppf;
import 'object_field_scopes.dart' as _iahgl0he;
import 'object_with_bit.dart' as _ioxr67zo;
import 'object_with_bytedata.dart' as _iz58zhle;
import 'object_with_duration.dart' as _ijtijns8;
import 'object_with_dynamic.dart' as _i9hzn3wb;
import 'object_with_enum.dart' as _ip2vqluy;
import 'object_with_enum_enhanced.dart' as _iwdrmoge;
import 'object_with_half_vector.dart' as _iy6ksgxz;
import 'object_with_index.dart' as _inemzov5;
import 'object_with_jsonb.dart' as _ihyvenpw;
import 'object_with_jsonb_class_level.dart' as _i4p0t2g0;
import 'object_with_maps.dart' as _i26q9u41;
import 'object_with_object.dart' as _i4hr2e9p;
import 'object_with_parent.dart' as _io0t3u2c;
import 'object_with_sealed_class.dart' as _im4j7lpz;
import 'object_with_self_parent.dart' as _ihluvkmz;
import 'object_with_sparse_vector.dart' as _i8t20dyr;
import 'object_with_uuid.dart' as _iusk9w05;
import 'object_with_vector.dart' as _itmc4j9i;
import 'related_unique_data.dart' as _i2aw39a6;
import 'required/model_with_required_field.dart' as _iv7egjxb;
import 'simple_data.dart' as _i0zisc0t;
import 'simple_date_time.dart' as _i1duz4kf;
import 'test_enum.dart' as _ionapfu9;
import 'test_enum_default_serialization.dart' as _icplrpi3;
import 'test_enum_enhanced.dart' as _it39smib;
import 'test_enum_enhanced_by_name.dart' as _izw460bh;
import 'test_enum_stringified.dart' as _i7liykk2;
import 'types.dart' as _iwxwszsz;
import 'unique_data.dart' as _iufhyrjh;
import 'unique_data_with_non_persist.dart' as _ip8yzqii;
import 'upsert_test_model.dart' as _iwbeyn4p;
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
export 'deferrable/deferrable_relation_initially_deferred.dart';
export 'deferrable/deferrable_relation_initially_immediate.dart';
export 'deferrable/deferrable_relation_parent.dart';
export 'empty_model/empty_model.dart';
export 'empty_model/empty_model_relation_item.dart';
export 'empty_model/empty_model_with_table.dart';
export 'empty_model/relation_empy_model.dart';
export 'explicit_column_name/inheritance/child_class_explicit_column.dart';
export 'explicit_column_name/inheritance/non_table_parent_class.dart';
export 'explicit_column_name/modified_column_name.dart';
export 'explicit_column_name/relations/one_to_many/department.dart';
export 'explicit_column_name/relations/one_to_many/employee.dart';
export 'explicit_column_name/relations/one_to_one/contractor.dart';
export 'explicit_column_name/relations/one_to_one/service.dart';
export 'explicit_column_name/table_with_explicit_column_names.dart';
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
export 'nulls_distinct_data.dart';
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bit.dart';
export 'object_with_bytedata.dart';
export 'object_with_duration.dart';
export 'object_with_dynamic.dart';
export 'object_with_enum.dart';
export 'object_with_enum_enhanced.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
export 'object_with_jsonb.dart';
export 'object_with_jsonb_class_level.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_sealed_class.dart';
export 'object_with_self_parent.dart';
export 'object_with_sparse_vector.dart';
export 'object_with_uuid.dart';
export 'object_with_vector.dart';
export 'related_unique_data.dart';
export 'required/model_with_required_field.dart';
export 'simple_data.dart';
export 'simple_date_time.dart';
export 'test_enum.dart';
export 'test_enum_default_serialization.dart';
export 'test_enum_enhanced.dart';
export 'test_enum_enhanced_by_name.dart';
export 'test_enum_stringified.dart';
export 'types.dart';
export 'unique_data.dart';
export 'unique_data_with_non_persist.dart';
export 'upsert_test_model.dart';
export 'client.dart';

class Protocol extends _isd.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static List<_isd.TableDefinition> get targetTableDefinitions => [
    _isd.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'street',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'address_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'inhabitant_index_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'arena',
      dartName: 'Arena',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'blocking',
      dartName: 'Blocking',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'blockedId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'blockedById',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'blocking_fk_0',
          columns: ['blockedId'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isd.ForeignKeyDefinition(
          constraintName: 'blocking_fk_1',
          columns: ['blockedById'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'blocking_blocked_unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'blockedId',
            ),
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'book',
      dartName: 'Book',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'title',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'cat',
      dartName: 'Cat',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'motherId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'cat_fk_0',
          columns: ['motherId'],
          referenceTable: 'cat',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'chapter',
      dartName: 'Chapter',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'title',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: '_bookChaptersBookId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'chapter_fk_0',
          columns: ['_bookChaptersBookId'],
          referenceTable: 'book',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'companyId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'citizen_fk_0',
          columns: ['companyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isd.ForeignKeyDefinition(
          constraintName: 'citizen_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'city',
      dartName: 'City',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'description',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'orderId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'company',
      dartName: 'Company',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'townId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'company_fk_0',
          columns: ['townId'],
          referenceTable: 'town',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'course',
      dartName: 'Course',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'customer',
      dartName: 'Customer',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'empty_model_relation_item',
      dartName: 'EmptyModelRelationItem',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: '_relationEmptyModelItemsRelationEmptyModelId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'empty_model_relation_item_fk_0',
          columns: ['_relationEmptyModelItemsRelationEmptyModelId'],
          referenceTable: 'relation_empty_model',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'empty_model_with_table',
      dartName: 'EmptyModelWithTable',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'enrollment',
      dartName: 'Enrollment',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'studentId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'courseId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_0',
          columns: ['studentId'],
          referenceTable: 'student',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _isd.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_1',
          columns: ['courseId'],
          referenceTable: 'course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'enrollment_index_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'member',
      dartName: 'Member',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'model_with_required_field',
      dartName: 'ModelWithRequiredField',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'email',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'phone',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'nulls_distinct_data',
      dartName: 'NullsDistinctData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'tenantId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'category',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'archivedAt',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'nulls_distinct_data_unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'tenantId',
            ),
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'category',
            ),
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
              definition: 'archivedAt',
            ),
          ],
          type: 'btree',
          isUnique: true,
          nullsDistinct: true,
          isPrimary: false,
        ),
      ],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'object_field_persist',
      dartName: 'ObjectFieldPersist',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'normal',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'order',
      dartName: 'Order',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'description',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'customerId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'order_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'organization',
      dartName: 'Organization',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'cityId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'organization_fk_0',
          columns: ['cityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'organizationId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isd.ColumnDefinition(
          name: '_cityCitizensCityId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'person_fk_0',
          columns: ['organizationId'],
          referenceTable: 'organization',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _isd.ForeignKeyDefinition(
          constraintName: 'person_fk_1',
          columns: ['_cityCitizensCityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'player',
      dartName: 'Player',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'teamId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'player_fk_0',
          columns: ['teamId'],
          referenceTable: 'team',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'post',
      dartName: 'Post',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'content',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'nextId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['nextId'],
          referenceTable: 'post',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'next_unique_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'related_unique_data',
      dartName: 'RelatedUniqueData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'uniqueDataId',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'number',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'related_unique_data_fk_0',
          columns: ['uniqueDataId'],
          referenceTable: 'unique_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'relation_empty_model',
      dartName: 'RelationEmptyModel',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'num',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'simple_date_time',
      dartName: 'SimpleDateTime',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'dateTime',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'student',
      dartName: 'Student',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'team',
      dartName: 'Team',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'arenaId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'team_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'arena_index_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'town',
      dartName: 'Town',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'name',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _isd.ColumnDefinition(
          name: 'mayorId',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _isd.ForeignKeyDefinition(
          constraintName: 'town_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _isd.ForeignKeyAction.noAction,
          onDelete: _isd.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'types',
      dartName: 'Types',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'anInt',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _isd.ColumnDefinition(
          name: 'aBool',
          columnType: _isd.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _isd.ColumnDefinition(
          name: 'aDouble',
          columnType: _isd.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _isd.ColumnDefinition(
          name: 'aDateTime',
          columnType: _isd.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _isd.ColumnDefinition(
          name: 'aString',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _isd.ColumnDefinition(
          name: 'aByteData',
          columnType: _isd.ColumnType.bytea,
          isNullable: true,
          dartType: 'dart:typed_data:ByteData?',
        ),
        _isd.ColumnDefinition(
          name: 'aDuration',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _isd.ColumnDefinition(
          name: 'aUuid',
          columnType: _isd.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _isd.ColumnDefinition(
          name: 'aUri',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
        _isd.ColumnDefinition(
          name: 'aBigInt',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
        _isd.ColumnDefinition(
          name: 'aVector',
          columnType: _isd.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(3)?',
          vectorDimension: 3,
        ),
        _isd.ColumnDefinition(
          name: 'aHalfVector',
          columnType: _isd.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(3)?',
          vectorDimension: 3,
        ),
        _isd.ColumnDefinition(
          name: 'aSparseVector',
          columnType: _isd.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(3)?',
          vectorDimension: 3,
        ),
        _isd.ColumnDefinition(
          name: 'aBit',
          columnType: _isd.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(3)?',
          vectorDimension: 3,
        ),
        _isd.ColumnDefinition(
          name: 'aGeographyPoint',
          columnType: _isd.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _isd.ColumnDefinition(
          name: 'aGeographyLineString',
          columnType: _isd.ColumnType.geographyLineString,
          isNullable: true,
          dartType: 'GeographyLineString?',
        ),
        _isd.ColumnDefinition(
          name: 'aGeographyPolygon',
          columnType: _isd.ColumnType.geographyPolygon,
          isNullable: true,
          dartType: 'GeographyPolygon?',
        ),
        _isd.ColumnDefinition(
          name: 'aGeographyGeometryCollection',
          columnType: _isd.ColumnType.geographyGeometryCollection,
          isNullable: true,
          dartType: 'GeographyGeometryCollection?',
        ),
        _isd.ColumnDefinition(
          name: 'anEnum',
          columnType: _isd.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _isd.ColumnDefinition(
          name: 'aStringifiedEnum',
          columnType: _isd.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumStringified?',
        ),
        _isd.ColumnDefinition(
          name: 'aList',
          columnType: _isd.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _isd.ColumnDefinition(
          name: 'aMap',
          columnType: _isd.ColumnType.json,
          isNullable: true,
          dartType: 'Map<int,int>?',
        ),
        _isd.ColumnDefinition(
          name: 'aSet',
          columnType: _isd.ColumnType.json,
          isNullable: true,
          dartType: 'Set<int>?',
        ),
        _isd.ColumnDefinition(
          name: 'aRecord',
          columnType: _isd.ColumnType.json,
          isNullable: true,
          dartType: '(String, {Uri? optionalUri})?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _isd.TableDefinition(
      name: 'unique_data',
      dartName: 'UniqueData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'number',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'email',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'email_index_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    _isd.TableDefinition(
      name: 'unique_data_with_non_persist',
      dartName: 'UniqueDataWithNonPersist',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _isd.ColumnDefinition(
          name: 'id',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _isd.ColumnDefinition(
          name: 'number',
          columnType: _isd.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _isd.ColumnDefinition(
          name: 'email',
          columnType: _isd.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _isd.IndexDefinition(
          indexName: 'unique_email_idx',
          tableSpace: null,
          elements: [
            _isd.IndexElementDefinition(
              type: _isd.IndexElementDefinitionType.column,
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
    ..._iacc.Protocol() is _isd.DatabaseSerializationManager
        ? (_iacc.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iaic.Protocol() is _isd.DatabaseSerializationManager
        ? (_iaic.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iyerxm0e.Protocol() is _isd.DatabaseSerializationManager
        ? (_iyerxm0e.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._iqfgygbv.Protocol() is _isd.DatabaseSerializationManager
        ? (_iqfgygbv.Protocol() as _isd.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
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
    if (t == _ij7m744x.SealedGrandChild) {
      return _ij7m744x.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _ij7m744x.SealedChild) {
      return _ij7m744x.SealedChild.fromJson(data) as T;
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
    if (t == _iy2buo88.Course) {
      return _iy2buo88.Course.fromJson(data) as T;
    }
    if (t == _i8v11x6h.Enrollment) {
      return _i8v11x6h.Enrollment.fromJson(data) as T;
    }
    if (t == _ig5mtn0e.Student) {
      return _ig5mtn0e.Student.fromJson(data) as T;
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
    if (t == _i4hr2e9p.ObjectWithObject) {
      return _i4hr2e9p.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _io0t3u2c.ObjectWithParent) {
      return _io0t3u2c.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _im4j7lpz.ObjectWithSealedClass) {
      return _im4j7lpz.ObjectWithSealedClass.fromJson(data) as T;
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
    if (t == _i2aw39a6.RelatedUniqueData) {
      return _i2aw39a6.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _iv7egjxb.ModelWithRequiredField) {
      return _iv7egjxb.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i0zisc0t.SimpleData) {
      return _i0zisc0t.SimpleData.fromJson(data) as T;
    }
    if (t == _i1duz4kf.SimpleDateTime) {
      return _i1duz4kf.SimpleDateTime.fromJson(data) as T;
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
    if (t == _iufhyrjh.UniqueData) {
      return _iufhyrjh.UniqueData.fromJson(data) as T;
    }
    if (t == _ip8yzqii.UniqueDataWithNonPersist) {
      return _ip8yzqii.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _iwbeyn4p.UpsertTestModel) {
      return _iwbeyn4p.UpsertTestModel.fromJson(data) as T;
    }
    if (t == _isc.getType<_ik6ri27s.CourseUuid?>()) {
      return (data != null ? _ik6ri27s.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icdgc05t.EnrollmentInt?>()) {
      return (data != null ? _icdgc05t.EnrollmentInt.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ibrjea6w.StudentUuid?>()) {
      return (data != null ? _ibrjea6w.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_isj7c5mo.ArenaUuid?>()) {
      return (data != null ? _isj7c5mo.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivdpnfmj.PlayerUuid?>()) {
      return (data != null ? _ivdpnfmj.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ivehlt2f.TeamInt?>()) {
      return (data != null ? _ivehlt2f.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i3jtpxta.CommentInt?>()) {
      return (data != null ? _i3jtpxta.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iimgofmw.CustomerInt?>()) {
      return (data != null ? _iimgofmw.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iywnby31.OrderUuid?>()) {
      return (data != null ? _iywnby31.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifwqt4rb.AddressUuid?>()) {
      return (data != null ? _ifwqt4rb.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_idhvg1zk.CitizenInt?>()) {
      return (data != null ? _idhvg1zk.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i5vwm04a.CompanyUuid?>()) {
      return (data != null ? _i5vwm04a.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iu7osokh.TownInt?>()) {
      return (data != null ? _iu7osokh.TownInt.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixc9sah8.ChangedIdTypeSelf?>()) {
      return (data != null ? _ixc9sah8.ChangedIdTypeSelf.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_icrmubzc.BigIntDefault?>()) {
      return (data != null ? _icrmubzc.BigIntDefault.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1xsun18.BigIntDefaultMix?>()) {
      return (data != null ? _i1xsun18.BigIntDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i332rqur.BigIntDefaultModel?>()) {
      return (data != null ? _i332rqur.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ia4nw21o.BigIntDefaultPersist?>()) {
      return (data != null
              ? _ia4nw21o.BigIntDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ilirabmz.BoolDefault?>()) {
      return (data != null ? _ilirabmz.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iwhzartq.BoolDefaultMix?>()) {
      return (data != null ? _iwhzartq.BoolDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izvr7tnf.BoolDefaultModel?>()) {
      return (data != null ? _izvr7tnf.BoolDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i135uugo.BoolDefaultPersist?>()) {
      return (data != null ? _i135uugo.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iro0mlkq.DateTimeDefault?>()) {
      return (data != null ? _iro0mlkq.DateTimeDefault.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_igjm2894.DateTimeDefaultMix?>()) {
      return (data != null ? _igjm2894.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivkcoq83.DateTimeDefaultModel?>()) {
      return (data != null
              ? _ivkcoq83.DateTimeDefaultModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iaqar0o9.DateTimeDefaultPersist?>()) {
      return (data != null
              ? _iaqar0o9.DateTimeDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izu05ym4.DoubleDefault?>()) {
      return (data != null ? _izu05ym4.DoubleDefault.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iou6kksr.DoubleDefaultMix?>()) {
      return (data != null ? _iou6kksr.DoubleDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9xv7g6i.DoubleDefaultModel?>()) {
      return (data != null ? _i9xv7g6i.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iynhhcdw.DoubleDefaultPersist?>()) {
      return (data != null
              ? _iynhhcdw.DoubleDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ixvw8l6s.DurationDefault?>()) {
      return (data != null ? _ixvw8l6s.DurationDefault.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ialx1ytx.DurationDefaultMix?>()) {
      return (data != null ? _ialx1ytx.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i5aouk9m.DurationDefaultModel?>()) {
      return (data != null
              ? _i5aouk9m.DurationDefaultModel.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ij5e1q2b.DurationDefaultPersist?>()) {
      return (data != null
              ? _ij5e1q2b.DurationDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihqxpva2.EnumDefault?>()) {
      return (data != null ? _ihqxpva2.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyezrrxn.EnumDefaultMix?>()) {
      return (data != null ? _iyezrrxn.EnumDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iw4wb1ju.EnumDefaultModel?>()) {
      return (data != null ? _iw4wb1ju.EnumDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i0p9yn0v.EnumDefaultPersist?>()) {
      return (data != null ? _i0p9yn0v.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4ekvn16.ByIndexEnum?>()) {
      return (data != null ? _i4ekvn16.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ihrgmscf.ByNameEnum?>()) {
      return (data != null ? _ihrgmscf.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iirkfcfb.DefaultValueEnum?>()) {
      return (data != null ? _iirkfcfb.DefaultValueEnum.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv40kyzq.DefaultException?>()) {
      return (data != null ? _iv40kyzq.DefaultException.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i8t3u1nx.IntDefault?>()) {
      return (data != null ? _i8t3u1nx.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iummzlp0.IntDefaultMix?>()) {
      return (data != null ? _iummzlp0.IntDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4rypx08.IntDefaultModel?>()) {
      return (data != null ? _i4rypx08.IntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_imhmhhwa.IntDefaultPersist?>()) {
      return (data != null ? _imhmhhwa.IntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4d8z6ds.StringDefault?>()) {
      return (data != null ? _i4d8z6ds.StringDefault.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iu6k5fkj.StringDefaultMix?>()) {
      return (data != null ? _iu6k5fkj.StringDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihmqo6od.StringDefaultModel?>()) {
      return (data != null ? _ihmqo6od.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ih6giyf6.StringDefaultPersist?>()) {
      return (data != null
              ? _ih6giyf6.StringDefaultPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i2y701qf.UriDefault?>()) {
      return (data != null ? _i2y701qf.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iib8h1yl.UriDefaultMix?>()) {
      return (data != null ? _iib8h1yl.UriDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i1to0y5o.UriDefaultModel?>()) {
      return (data != null ? _i1to0y5o.UriDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_isi15w9f.UriDefaultPersist?>()) {
      return (data != null ? _isi15w9f.UriDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihsadwhl.UuidDefault?>()) {
      return (data != null ? _ihsadwhl.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ignwr848.UuidDefaultMix?>()) {
      return (data != null ? _ignwr848.UuidDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i15gwzho.UuidDefaultModel?>()) {
      return (data != null ? _i15gwzho.UuidDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2v866bf.UuidDefaultPersist?>()) {
      return (data != null ? _i2v866bf.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_io8dlrxh.DeferrableRelationInitiallyDeferred?>()) {
      return (data != null
              ? _io8dlrxh.DeferrableRelationInitiallyDeferred.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_inmfeda2.DeferrableRelationInitiallyImmediate?>()) {
      return (data != null
              ? _inmfeda2.DeferrableRelationInitiallyImmediate.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_izxfibiy.DeferrableRelationParent?>()) {
      return (data != null
              ? _izxfibiy.DeferrableRelationParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i9l9xrkt.EmptyModel?>()) {
      return (data != null ? _i9l9xrkt.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikufh0vd.EmptyModelRelationItem?>()) {
      return (data != null
              ? _ikufh0vd.EmptyModelRelationItem.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iw4y4x6s.EmptyModelWithTable?>()) {
      return (data != null
              ? _iw4y4x6s.EmptyModelWithTable.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iy7bezig.RelationEmptyModel?>()) {
      return (data != null ? _iy7bezig.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ikh95zxc.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _ikh95zxc.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i1y2idkw.NonTableParentClass?>()) {
      return (data != null
              ? _i1y2idkw.NonTableParentClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7hqkfn7.ModifiedColumnName?>()) {
      return (data != null ? _i7hqkfn7.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ix2lcsu0.Department?>()) {
      return (data != null ? _ix2lcsu0.Department.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ixlcmx78.Employee?>()) {
      return (data != null ? _ixlcmx78.Employee.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iw4adtsk.Contractor?>()) {
      return (data != null ? _iw4adtsk.Contractor.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i83a3u3u.Service?>()) {
      return (data != null ? _i83a3u3u.Service.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iox92era.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _iox92era.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ij7m744x.SealedGrandChild?>()) {
      return (data != null ? _ij7m744x.SealedGrandChild.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ij7m744x.SealedChild?>()) {
      return (data != null ? _ij7m744x.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ij7m744x.SealedOtherChild?>()) {
      return (data != null ? _ij7m744x.SealedOtherChild.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iycanyn2.CityWithLongTableName?>()) {
      return (data != null
              ? _iycanyn2.CityWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ifbzwpkm.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _ifbzwpkm.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iy2gklrg.PersonWithLongTableName?>()) {
      return (data != null
              ? _iy2gklrg.PersonWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i37b4f1x.MaxFieldName?>()) {
      return (data != null ? _i37b4f1x.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ilm8ux21.LongImplicitIdField?>()) {
      return (data != null
              ? _ilm8ux21.LongImplicitIdField.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i5zyye9l.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i5zyye9l.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_irdava0x.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _irdava0x.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i14q426c.UserNote?>()) {
      return (data != null ? _i14q426c.UserNote.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i0cmztzz.UserNoteCollection?>()) {
      return (data != null ? _i0cmztzz.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ivgcl1bh.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _ivgcl1bh.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7zqea9a.UserNoteWithALongName?>()) {
      return (data != null
              ? _i7zqea9a.UserNoteWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ify1vf7h.MultipleMaxFieldName?>()) {
      return (data != null
              ? _ify1vf7h.MultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i0i33txy.City?>()) {
      return (data != null ? _i0i33txy.City.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iffzpgud.Organization?>()) {
      return (data != null ? _iffzpgud.Organization.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i9x7ls0c.Person?>()) {
      return (data != null ? _i9x7ls0c.Person.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iy2buo88.Course?>()) {
      return (data != null ? _iy2buo88.Course.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i8v11x6h.Enrollment?>()) {
      return (data != null ? _i8v11x6h.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ig5mtn0e.Student?>()) {
      return (data != null ? _ig5mtn0e.Student.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ikwieien.Arena?>()) {
      return (data != null ? _ikwieien.Arena.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip8wmh4s.Player?>()) {
      return (data != null ? _ip8wmh4s.Player.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ifa5hwxy.Team?>()) {
      return (data != null ? _ifa5hwxy.Team.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ii7cxuye.Comment?>()) {
      return (data != null ? _ii7cxuye.Comment.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1nwi4iv.Customer?>()) {
      return (data != null ? _i1nwi4iv.Customer.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if51mnnb.Book?>()) {
      return (data != null ? _if51mnnb.Book.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_itdsc4u0.Chapter?>()) {
      return (data != null ? _itdsc4u0.Chapter.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_is5jy3ez.Order?>()) {
      return (data != null ? _is5jy3ez.Order.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i6uupgbr.Address?>()) {
      return (data != null ? _i6uupgbr.Address.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igeuyxnu.Citizen?>()) {
      return (data != null ? _igeuyxnu.Citizen.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_if6srpch.Company?>()) {
      return (data != null ? _if6srpch.Company.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_igjnmbwc.Town?>()) {
      return (data != null ? _igjnmbwc.Town.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ic5jbe8i.Blocking?>()) {
      return (data != null ? _ic5jbe8i.Blocking.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ijj92mp1.Member?>()) {
      return (data != null ? _ijj92mp1.Member.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ib9keugy.Cat?>()) {
      return (data != null ? _ib9keugy.Cat.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iyh1zt5l.Post?>()) {
      return (data != null ? _iyh1zt5l.Post.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iz2gvrid.NullsDistinctData?>()) {
      return (data != null ? _iz2gvrid.NullsDistinctData.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9ffbppf.ObjectFieldPersist?>()) {
      return (data != null ? _i9ffbppf.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iahgl0he.ObjectFieldScopes?>()) {
      return (data != null ? _iahgl0he.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ioxr67zo.ObjectWithBit?>()) {
      return (data != null ? _ioxr67zo.ObjectWithBit.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iz58zhle.ObjectWithByteData?>()) {
      return (data != null ? _iz58zhle.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ijtijns8.ObjectWithDuration?>()) {
      return (data != null ? _ijtijns8.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i9hzn3wb.ObjectWithDynamic?>()) {
      return (data != null ? _i9hzn3wb.ObjectWithDynamic.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ip2vqluy.ObjectWithEnum?>()) {
      return (data != null ? _ip2vqluy.ObjectWithEnum.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iwdrmoge.ObjectWithEnumEnhanced?>()) {
      return (data != null
              ? _iwdrmoge.ObjectWithEnumEnhanced.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iy6ksgxz.ObjectWithHalfVector?>()) {
      return (data != null
              ? _iy6ksgxz.ObjectWithHalfVector.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_inemzov5.ObjectWithIndex?>()) {
      return (data != null ? _inemzov5.ObjectWithIndex.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ihyvenpw.ObjectWithJsonb?>()) {
      return (data != null ? _ihyvenpw.ObjectWithJsonb.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4p0t2g0.ObjectWithJsonbClassLevel?>()) {
      return (data != null
              ? _i4p0t2g0.ObjectWithJsonbClassLevel.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i26q9u41.ObjectWithMaps?>()) {
      return (data != null ? _i26q9u41.ObjectWithMaps.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i4hr2e9p.ObjectWithObject?>()) {
      return (data != null ? _i4hr2e9p.ObjectWithObject.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_io0t3u2c.ObjectWithParent?>()) {
      return (data != null ? _io0t3u2c.ObjectWithParent.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_im4j7lpz.ObjectWithSealedClass?>()) {
      return (data != null
              ? _im4j7lpz.ObjectWithSealedClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_ihluvkmz.ObjectWithSelfParent?>()) {
      return (data != null
              ? _ihluvkmz.ObjectWithSelfParent.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i8t20dyr.ObjectWithSparseVector?>()) {
      return (data != null
              ? _i8t20dyr.ObjectWithSparseVector.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iusk9w05.ObjectWithUuid?>()) {
      return (data != null ? _iusk9w05.ObjectWithUuid.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_itmc4j9i.ObjectWithVector?>()) {
      return (data != null ? _itmc4j9i.ObjectWithVector.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_i2aw39a6.RelatedUniqueData?>()) {
      return (data != null ? _i2aw39a6.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_iv7egjxb.ModelWithRequiredField?>()) {
      return (data != null
              ? _iv7egjxb.ModelWithRequiredField.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i0zisc0t.SimpleData?>()) {
      return (data != null ? _i0zisc0t.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_i1duz4kf.SimpleDateTime?>()) {
      return (data != null ? _i1duz4kf.SimpleDateTime.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_ionapfu9.TestEnum?>()) {
      return (data != null ? _ionapfu9.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_icplrpi3.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _icplrpi3.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_it39smib.TestEnumEnhanced?>()) {
      return (data != null ? _it39smib.TestEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _isc.getType<_izw460bh.TestEnumEnhancedByName?>()) {
      return (data != null
              ? _izw460bh.TestEnumEnhancedByName.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_i7liykk2.TestEnumStringified?>()) {
      return (data != null
              ? _i7liykk2.TestEnumStringified.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwxwszsz.Types?>()) {
      return (data != null ? _iwxwszsz.Types.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_iufhyrjh.UniqueData?>()) {
      return (data != null ? _iufhyrjh.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _isc.getType<_ip8yzqii.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _ip8yzqii.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _isc.getType<_iwbeyn4p.UpsertTestModel?>()) {
      return (data != null ? _iwbeyn4p.UpsertTestModel.fromJson(data) : null)
          as T;
    }
    if (t == List<_icdgc05t.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_icdgc05t.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_icdgc05t.EnrollmentInt>?>()) {
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
    if (t == _isc.getType<List<_ivdpnfmj.PlayerUuid>?>()) {
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
    if (t == _isc.getType<List<_iywnby31.OrderUuid>?>()) {
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
    if (t == _isc.getType<List<_i3jtpxta.CommentInt>?>()) {
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
    if (t == _isc.getType<List<_ixc9sah8.ChangedIdTypeSelf>?>()) {
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
    if (t == _isc.getType<List<_ikufh0vd.EmptyModelRelationItem>?>()) {
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
    if (t == _isc.getType<List<_ixlcmx78.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ixlcmx78.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_iy2gklrg.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_iy2gklrg.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_iy2gklrg.PersonWithLongTableName>?>()) {
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
    if (t == _isc.getType<List<_ifbzwpkm.OrganizationWithLongTableName>?>()) {
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
    if (t == _isc.getType<List<_ilm8ux21.LongImplicitIdField>?>()) {
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
    if (t == _isc.getType<List<_ify1vf7h.MultipleMaxFieldName>?>()) {
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
    if (t == _isc.getType<List<_i14q426c.UserNote>?>()) {
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
    if (t == _isc.getType<List<_i7zqea9a.UserNoteWithALongName>?>()) {
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
    if (t == _isc.getType<List<_i9x7ls0c.Person>?>()) {
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
    if (t == _isc.getType<List<_iffzpgud.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_iffzpgud.Organization>(e))
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
    if (t == _isc.getType<List<_i8v11x6h.Enrollment>?>()) {
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
    if (t == _isc.getType<List<_ip8wmh4s.Player>?>()) {
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
    if (t == _isc.getType<List<_is5jy3ez.Order>?>()) {
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
    if (t == _isc.getType<List<_itdsc4u0.Chapter>?>()) {
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
    if (t == _isc.getType<List<_ii7cxuye.Comment>?>()) {
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
    if (t == _isc.getType<List<_ic5jbe8i.Blocking>?>()) {
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
    if (t == _isc.getType<List<_ib9keugy.Cat>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_ib9keugy.Cat>(e))
                    .toList()
              : null)
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
          )
          as T;
    }
    if (t == _isc.getType<List<String>?>()) {
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
    if (t == Map<String, int>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)),
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
    if (t == Map<String, _isc.UuidValue>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_isc.UuidValue>(v),
            ),
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
    if (t == Map<String, int?>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)),
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
    if (t == Map<String, _isc.UuidValue?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_isc.UuidValue?>(v),
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
    if (t == List<_i0zisc0t.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i0zisc0t.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<_i0zisc0t.SimpleData>?>()) {
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
    if (t == _isc.getType<List<_i0zisc0t.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i0zisc0t.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i0zisc0t.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i0zisc0t.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<List<List<_i0zisc0t.SimpleData>>?>()) {
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
    if (t == _isc.getType<List<Map<int, _i0zisc0t.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i0zisc0t.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _isc
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
    if (t == _isc.getType<List<Map<int, _i0zisc0t.SimpleData>>?>()) {
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
    if (t == _isc.getType<Map<String, Map<int, _i0zisc0t.SimpleData>>?>()) {
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
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _isc.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == _isc.getType<Map<int, int>?>()) {
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
    if (t == _isc.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _isc.getType<(String, {Uri? optionalUri})?>()) {
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
    if (t == List<_ilnisupq.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_ilnisupq.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _isc.getType<(String, {Uri? optionalUri})?>()) {
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
    try {
      return _iacc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iaic.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iyerxm0e.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _iqfgygbv.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _issc.Protocol().deserialize<T>(data, t);
    } on _isc.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
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
      _ikh95zxc.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i1y2idkw.NonTableParentClass => 'NonTableParentClass',
      _i7hqkfn7.ModifiedColumnName => 'ModifiedColumnName',
      _ix2lcsu0.Department => 'Department',
      _ixlcmx78.Employee => 'Employee',
      _iw4adtsk.Contractor => 'Contractor',
      _i83a3u3u.Service => 'Service',
      _iox92era.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _ij7m744x.SealedGrandChild => 'SealedGrandChild',
      _ij7m744x.SealedChild => 'SealedChild',
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
      _iy2buo88.Course => 'Course',
      _i8v11x6h.Enrollment => 'Enrollment',
      _ig5mtn0e.Student => 'Student',
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
      _iz2gvrid.NullsDistinctData => 'NullsDistinctData',
      _i9ffbppf.ObjectFieldPersist => 'ObjectFieldPersist',
      _iahgl0he.ObjectFieldScopes => 'ObjectFieldScopes',
      _ioxr67zo.ObjectWithBit => 'ObjectWithBit',
      _iz58zhle.ObjectWithByteData => 'ObjectWithByteData',
      _ijtijns8.ObjectWithDuration => 'ObjectWithDuration',
      _i9hzn3wb.ObjectWithDynamic => 'ObjectWithDynamic',
      _ip2vqluy.ObjectWithEnum => 'ObjectWithEnum',
      _iwdrmoge.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _iy6ksgxz.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _inemzov5.ObjectWithIndex => 'ObjectWithIndex',
      _ihyvenpw.ObjectWithJsonb => 'ObjectWithJsonb',
      _i4p0t2g0.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i26q9u41.ObjectWithMaps => 'ObjectWithMaps',
      _i4hr2e9p.ObjectWithObject => 'ObjectWithObject',
      _io0t3u2c.ObjectWithParent => 'ObjectWithParent',
      _im4j7lpz.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _ihluvkmz.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i8t20dyr.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _iusk9w05.ObjectWithUuid => 'ObjectWithUuid',
      _itmc4j9i.ObjectWithVector => 'ObjectWithVector',
      _i2aw39a6.RelatedUniqueData => 'RelatedUniqueData',
      _iv7egjxb.ModelWithRequiredField => 'ModelWithRequiredField',
      _i0zisc0t.SimpleData => 'SimpleData',
      _i1duz4kf.SimpleDateTime => 'SimpleDateTime',
      _ionapfu9.TestEnum => 'TestEnum',
      _icplrpi3.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _it39smib.TestEnumEnhanced => 'TestEnumEnhanced',
      _izw460bh.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i7liykk2.TestEnumStringified => 'TestEnumStringified',
      _iwxwszsz.Types => 'Types',
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
        'serverpod_test_sqlite.',
        '',
      );
    }

    switch (data) {
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
      case _ij7m744x.SealedGrandChild():
        return 'SealedGrandChild';
      case _ij7m744x.SealedChild():
        return 'SealedChild';
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
      case _iy2buo88.Course():
        return 'Course';
      case _i8v11x6h.Enrollment():
        return 'Enrollment';
      case _ig5mtn0e.Student():
        return 'Student';
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
      case _ijtijns8.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i9hzn3wb.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _ip2vqluy.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _iwdrmoge.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
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
      case _i4hr2e9p.ObjectWithObject():
        return 'ObjectWithObject';
      case _io0t3u2c.ObjectWithParent():
        return 'ObjectWithParent';
      case _im4j7lpz.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _ihluvkmz.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i8t20dyr.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _iusk9w05.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _itmc4j9i.ObjectWithVector():
        return 'ObjectWithVector';
      case _i2aw39a6.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _iv7egjxb.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i0zisc0t.SimpleData():
        return 'SimpleData';
      case _i1duz4kf.SimpleDateTime():
        return 'SimpleDateTime';
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
      case _iufhyrjh.UniqueData():
        return 'UniqueData';
      case _ip8yzqii.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _iwbeyn4p.UpsertTestModel():
        return 'UpsertTestModel';
    }
    className = _iacc.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _iaic.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
    }
    className = _iyerxm0e.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_shared_module.$className';
    }
    className = _iqfgygbv.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_test_sqlite_shared.$className';
    }
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
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
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_ij7m744x.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_ij7m744x.SealedChild>(data['data']);
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
    if (dataClassName == 'Course') {
      return deserialize<_iy2buo88.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i8v11x6h.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_ig5mtn0e.Student>(data['data']);
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
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i4hr2e9p.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_io0t3u2c.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_im4j7lpz.ObjectWithSealedClass>(data['data']);
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
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i2aw39a6.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_iv7egjxb.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i0zisc0t.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i1duz4kf.SimpleDateTime>(data['data']);
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
    if (dataClassName == 'UniqueData') {
      return deserialize<_iufhyrjh.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_ip8yzqii.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_iwbeyn4p.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _iacc.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _iaic.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_shared_module.')) {
      data['className'] = dataClassName.substring(29);
      return _iyerxm0e.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_test_sqlite_shared.')) {
      data['className'] = dataClassName.substring(29);
      return _iqfgygbv.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _iacc.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
    _iaic.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
    _iyerxm0e.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
    _iqfgygbv.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
  }

  @override
  _isd.Table? getTableForType(Type t) {
    {
      var protocol = _iacc.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iaic.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iyerxm0e.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _iqfgygbv.Protocol();
      var table = protocol is _isd.DatabaseSerializationManager
          ? (protocol as _isd.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _ikufh0vd.EmptyModelRelationItem:
        return _ikufh0vd.EmptyModelRelationItem.t;
      case _iw4y4x6s.EmptyModelWithTable:
        return _iw4y4x6s.EmptyModelWithTable.t;
      case _iy7bezig.RelationEmptyModel:
        return _iy7bezig.RelationEmptyModel.t;
      case _i0i33txy.City:
        return _i0i33txy.City.t;
      case _iffzpgud.Organization:
        return _iffzpgud.Organization.t;
      case _i9x7ls0c.Person:
        return _i9x7ls0c.Person.t;
      case _iy2buo88.Course:
        return _iy2buo88.Course.t;
      case _i8v11x6h.Enrollment:
        return _i8v11x6h.Enrollment.t;
      case _ig5mtn0e.Student:
        return _ig5mtn0e.Student.t;
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
      case _i2aw39a6.RelatedUniqueData:
        return _i2aw39a6.RelatedUniqueData.t;
      case _iv7egjxb.ModelWithRequiredField:
        return _iv7egjxb.ModelWithRequiredField.t;
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
    }
    return null;
  }

  @override
  List<_isd.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test_sqlite';

  /// Maps any `Record`s known to this [Protocol] to their JSON representation
  ///
  /// Throws in case the record type is not known.
  ///
  /// This method will return `null` (only) for `null` inputs.
  Map<String, dynamic>? mapRecordToJson(Record? record) {
    if (record == null) {
      return null;
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
    try {
      return _iacc.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iaic.Protocol().mapRecordToJson(record);
    } catch (_) {}
    try {
      return _iyerxm0e.Protocol().mapRecordToJson(record);
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
