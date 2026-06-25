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
import 'package:serverpod_auth_core_server/serverpod_auth_core_server.dart'
    as _i3;
import 'package:serverpod_auth_idp_server/serverpod_auth_idp_server.dart'
    as _i4;
import 'changed_id_type/many_to_many/course.dart' as _i5;
import 'changed_id_type/many_to_many/enrollment.dart' as _i6;
import 'changed_id_type/many_to_many/student.dart' as _i7;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i8;
import 'changed_id_type/nested_one_to_many/player.dart' as _i9;
import 'changed_id_type/nested_one_to_many/team.dart' as _i10;
import 'changed_id_type/one_to_many/comment.dart' as _i11;
import 'changed_id_type/one_to_many/customer.dart' as _i12;
import 'changed_id_type/one_to_many/order.dart' as _i13;
import 'changed_id_type/one_to_one/address.dart' as _i14;
import 'changed_id_type/one_to_one/citizen.dart' as _i15;
import 'changed_id_type/one_to_one/company.dart' as _i16;
import 'changed_id_type/one_to_one/town.dart' as _i17;
import 'changed_id_type/self.dart' as _i18;
import 'changed_id_type/server_only.dart' as _i19;
import 'defaults/bigint/bigint_default.dart' as _i20;
import 'defaults/bigint/bigint_default_mix.dart' as _i21;
import 'defaults/bigint/bigint_default_model.dart' as _i22;
import 'defaults/bigint/bigint_default_persist.dart' as _i23;
import 'defaults/boolean/bool_default.dart' as _i24;
import 'defaults/boolean/bool_default_mix.dart' as _i25;
import 'defaults/boolean/bool_default_model.dart' as _i26;
import 'defaults/boolean/bool_default_persist.dart' as _i27;
import 'defaults/datetime/datetime_default.dart' as _i28;
import 'defaults/datetime/datetime_default_mix.dart' as _i29;
import 'defaults/datetime/datetime_default_model.dart' as _i30;
import 'defaults/datetime/datetime_default_persist.dart' as _i31;
import 'defaults/double/double_default.dart' as _i32;
import 'defaults/double/double_default_mix.dart' as _i33;
import 'defaults/double/double_default_model.dart' as _i34;
import 'defaults/double/double_default_persist.dart' as _i35;
import 'defaults/duration/duration_default.dart' as _i36;
import 'defaults/duration/duration_default_mix.dart' as _i37;
import 'defaults/duration/duration_default_model.dart' as _i38;
import 'defaults/duration/duration_default_persist.dart' as _i39;
import 'defaults/enum/enum_default.dart' as _i40;
import 'defaults/enum/enum_default_mix.dart' as _i41;
import 'defaults/enum/enum_default_model.dart' as _i42;
import 'defaults/enum/enum_default_persist.dart' as _i43;
import 'defaults/enum/enums/by_index_enum.dart' as _i44;
import 'defaults/enum/enums/by_name_enum.dart' as _i45;
import 'defaults/enum/enums/default_value_enum.dart' as _i46;
import 'defaults/exception/default_exception.dart' as _i47;
import 'defaults/integer/int_default.dart' as _i48;
import 'defaults/integer/int_default_mix.dart' as _i49;
import 'defaults/integer/int_default_model.dart' as _i50;
import 'defaults/integer/int_default_persist.dart' as _i51;
import 'defaults/string/string_default.dart' as _i52;
import 'defaults/string/string_default_mix.dart' as _i53;
import 'defaults/string/string_default_model.dart' as _i54;
import 'defaults/string/string_default_persist.dart' as _i55;
import 'defaults/uri/uri_default.dart' as _i56;
import 'defaults/uri/uri_default_mix.dart' as _i57;
import 'defaults/uri/uri_default_model.dart' as _i58;
import 'defaults/uri/uri_default_persist.dart' as _i59;
import 'defaults/uuid/uuid_default.dart' as _i60;
import 'defaults/uuid/uuid_default_mix.dart' as _i61;
import 'defaults/uuid/uuid_default_model.dart' as _i62;
import 'defaults/uuid/uuid_default_persist.dart' as _i63;
import 'empty_model/empty_model.dart' as _i64;
import 'empty_model/empty_model_relation_item.dart' as _i65;
import 'empty_model/empty_model_with_table.dart' as _i66;
import 'empty_model/relation_empy_model.dart' as _i67;
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i68;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i69;
import 'explicit_column_name/modified_column_name.dart' as _i70;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i71;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i72;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i73;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i74;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i75;
import 'inheritance/sealed_parent.dart' as _i76;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i77;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i78;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i79;
import 'long_identifiers/max_field_name.dart' as _i80;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i81;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i82;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i83;
import 'long_identifiers/models_with_relations/user_note.dart' as _i84;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i85;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i86;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i87;
import 'long_identifiers/multiple_max_field_name.dart' as _i88;
import 'models_with_list_relations/city.dart' as _i89;
import 'models_with_list_relations/organization.dart' as _i90;
import 'models_with_list_relations/person.dart' as _i91;
import 'models_with_relations/many_to_many/course.dart' as _i92;
import 'models_with_relations/many_to_many/enrollment.dart' as _i93;
import 'models_with_relations/many_to_many/student.dart' as _i94;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i95;
import 'models_with_relations/nested_one_to_many/player.dart' as _i96;
import 'models_with_relations/nested_one_to_many/team.dart' as _i97;
import 'models_with_relations/one_to_many/comment.dart' as _i98;
import 'models_with_relations/one_to_many/customer.dart' as _i99;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i100;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i101;
import 'models_with_relations/one_to_many/order.dart' as _i102;
import 'models_with_relations/one_to_one/address.dart' as _i103;
import 'models_with_relations/one_to_one/citizen.dart' as _i104;
import 'models_with_relations/one_to_one/company.dart' as _i105;
import 'models_with_relations/one_to_one/town.dart' as _i106;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i107;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i108;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i109;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i110;
import 'object_field_persist.dart' as _i111;
import 'object_field_scopes.dart' as _i112;
import 'object_with_bit.dart' as _i113;
import 'object_with_bytedata.dart' as _i114;
import 'object_with_duration.dart' as _i115;
import 'object_with_dynamic.dart' as _i116;
import 'object_with_enum.dart' as _i117;
import 'object_with_enum_enhanced.dart' as _i118;
import 'object_with_half_vector.dart' as _i119;
import 'object_with_index.dart' as _i120;
import 'object_with_jsonb.dart' as _i121;
import 'object_with_jsonb_class_level.dart' as _i122;
import 'object_with_maps.dart' as _i123;
import 'object_with_object.dart' as _i124;
import 'object_with_parent.dart' as _i125;
import 'object_with_sealed_class.dart' as _i126;
import 'object_with_self_parent.dart' as _i127;
import 'object_with_sparse_vector.dart' as _i128;
import 'object_with_uuid.dart' as _i129;
import 'object_with_vector.dart' as _i130;
import 'related_unique_data.dart' as _i131;
import 'required/model_with_required_field.dart' as _i132;
import 'simple_data.dart' as _i133;
import 'simple_date_time.dart' as _i134;
import 'test_enum.dart' as _i135;
import 'test_enum_default_serialization.dart' as _i136;
import 'test_enum_enhanced.dart' as _i137;
import 'test_enum_enhanced_by_name.dart' as _i138;
import 'test_enum_stringified.dart' as _i139;
import 'types.dart' as _i140;
import 'unique_data.dart' as _i141;
import 'unique_data_with_non_persist.dart' as _i142;
import 'upsert_test_model.dart' as _i143;
import 'dart:typed_data' as _i144;
import 'package:serverpod_test_sqlite_server/src/generated/simple_data.dart'
    as _i145;
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

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static final List<_i2.TableDefinition> targetTableDefinitions = [
    _i2.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'child_table_explicit_column',
      dartName: 'ChildClassExplicitColumn',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'int_default',
      dartName: 'IntDefault',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'object_with_bit',
      dartName: 'ObjectWithBit',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'server_only_changed_id_field_class',
      dartName: 'ServerOnlyChangedIdFieldClass',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
          name: 'aGeographyPoint',
          columnType: _i2.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _i2.ColumnDefinition(
          name: 'aGeographyLineString',
          columnType: _i2.ColumnType.geographyLineString,
          isNullable: true,
          dartType: 'GeographyLineString?',
        ),
        _i2.ColumnDefinition(
          name: 'aGeographyPolygon',
          columnType: _i2.ColumnType.geographyPolygon,
          isNullable: true,
          dartType: 'GeographyPolygon?',
        ),
        _i2.ColumnDefinition(
          name: 'aGeographyGeometryCollection',
          columnType: _i2.ColumnType.geographyGeometryCollection,
          isNullable: true,
          dartType: 'GeographyGeometryCollection?',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
          indexName: 'upsert_test_model__code__unique_idx',
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
          indexName: 'upsert_test_model__category__value__unique_idx',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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
      module: 'serverpod_test_sqlite',
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

    if (t == _i5.CourseUuid) {
      return _i5.CourseUuid.fromJson(data) as T;
    }
    if (t == _i6.EnrollmentInt) {
      return _i6.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i7.StudentUuid) {
      return _i7.StudentUuid.fromJson(data) as T;
    }
    if (t == _i8.ArenaUuid) {
      return _i8.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i9.PlayerUuid) {
      return _i9.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i10.TeamInt) {
      return _i10.TeamInt.fromJson(data) as T;
    }
    if (t == _i11.CommentInt) {
      return _i11.CommentInt.fromJson(data) as T;
    }
    if (t == _i12.CustomerInt) {
      return _i12.CustomerInt.fromJson(data) as T;
    }
    if (t == _i13.OrderUuid) {
      return _i13.OrderUuid.fromJson(data) as T;
    }
    if (t == _i14.AddressUuid) {
      return _i14.AddressUuid.fromJson(data) as T;
    }
    if (t == _i15.CitizenInt) {
      return _i15.CitizenInt.fromJson(data) as T;
    }
    if (t == _i16.CompanyUuid) {
      return _i16.CompanyUuid.fromJson(data) as T;
    }
    if (t == _i17.TownInt) {
      return _i17.TownInt.fromJson(data) as T;
    }
    if (t == _i18.ChangedIdTypeSelf) {
      return _i18.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _i19.ServerOnlyChangedIdFieldClass) {
      return _i19.ServerOnlyChangedIdFieldClass.fromJson(data) as T;
    }
    if (t == _i20.BigIntDefault) {
      return _i20.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i21.BigIntDefaultMix) {
      return _i21.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i22.BigIntDefaultModel) {
      return _i22.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i23.BigIntDefaultPersist) {
      return _i23.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i24.BoolDefault) {
      return _i24.BoolDefault.fromJson(data) as T;
    }
    if (t == _i25.BoolDefaultMix) {
      return _i25.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i26.BoolDefaultModel) {
      return _i26.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i27.BoolDefaultPersist) {
      return _i27.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i28.DateTimeDefault) {
      return _i28.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i29.DateTimeDefaultMix) {
      return _i29.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i30.DateTimeDefaultModel) {
      return _i30.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i31.DateTimeDefaultPersist) {
      return _i31.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i32.DoubleDefault) {
      return _i32.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i33.DoubleDefaultMix) {
      return _i33.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i34.DoubleDefaultModel) {
      return _i34.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i35.DoubleDefaultPersist) {
      return _i35.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i36.DurationDefault) {
      return _i36.DurationDefault.fromJson(data) as T;
    }
    if (t == _i37.DurationDefaultMix) {
      return _i37.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i38.DurationDefaultModel) {
      return _i38.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i39.DurationDefaultPersist) {
      return _i39.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i40.EnumDefault) {
      return _i40.EnumDefault.fromJson(data) as T;
    }
    if (t == _i41.EnumDefaultMix) {
      return _i41.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i42.EnumDefaultModel) {
      return _i42.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i43.EnumDefaultPersist) {
      return _i43.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i44.ByIndexEnum) {
      return _i44.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i45.ByNameEnum) {
      return _i45.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i46.DefaultValueEnum) {
      return _i46.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _i47.DefaultException) {
      return _i47.DefaultException.fromJson(data) as T;
    }
    if (t == _i48.IntDefault) {
      return _i48.IntDefault.fromJson(data) as T;
    }
    if (t == _i49.IntDefaultMix) {
      return _i49.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i50.IntDefaultModel) {
      return _i50.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i51.IntDefaultPersist) {
      return _i51.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i52.StringDefault) {
      return _i52.StringDefault.fromJson(data) as T;
    }
    if (t == _i53.StringDefaultMix) {
      return _i53.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i54.StringDefaultModel) {
      return _i54.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i55.StringDefaultPersist) {
      return _i55.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i56.UriDefault) {
      return _i56.UriDefault.fromJson(data) as T;
    }
    if (t == _i57.UriDefaultMix) {
      return _i57.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i58.UriDefaultModel) {
      return _i58.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i59.UriDefaultPersist) {
      return _i59.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i60.UuidDefault) {
      return _i60.UuidDefault.fromJson(data) as T;
    }
    if (t == _i61.UuidDefaultMix) {
      return _i61.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i62.UuidDefaultModel) {
      return _i62.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i63.UuidDefaultPersist) {
      return _i63.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i64.EmptyModel) {
      return _i64.EmptyModel.fromJson(data) as T;
    }
    if (t == _i65.EmptyModelRelationItem) {
      return _i65.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i66.EmptyModelWithTable) {
      return _i66.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i67.RelationEmptyModel) {
      return _i67.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i68.ChildClassExplicitColumn) {
      return _i68.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i69.NonTableParentClass) {
      return _i69.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i70.ModifiedColumnName) {
      return _i70.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _i71.Department) {
      return _i71.Department.fromJson(data) as T;
    }
    if (t == _i72.Employee) {
      return _i72.Employee.fromJson(data) as T;
    }
    if (t == _i73.Contractor) {
      return _i73.Contractor.fromJson(data) as T;
    }
    if (t == _i74.Service) {
      return _i74.Service.fromJson(data) as T;
    }
    if (t == _i75.TableWithExplicitColumnName) {
      return _i75.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _i76.SealedGrandChild) {
      return _i76.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i76.SealedChild) {
      return _i76.SealedChild.fromJson(data) as T;
    }
    if (t == _i76.SealedOtherChild) {
      return _i76.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i77.CityWithLongTableName) {
      return _i77.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i78.OrganizationWithLongTableName) {
      return _i78.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i79.PersonWithLongTableName) {
      return _i79.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i80.MaxFieldName) {
      return _i80.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i81.LongImplicitIdField) {
      return _i81.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i82.LongImplicitIdFieldCollection) {
      return _i82.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i83.RelationToMultipleMaxFieldName) {
      return _i83.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i84.UserNote) {
      return _i84.UserNote.fromJson(data) as T;
    }
    if (t == _i85.UserNoteCollection) {
      return _i85.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i86.UserNoteCollectionWithALongName) {
      return _i86.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i87.UserNoteWithALongName) {
      return _i87.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i88.MultipleMaxFieldName) {
      return _i88.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i89.City) {
      return _i89.City.fromJson(data) as T;
    }
    if (t == _i90.Organization) {
      return _i90.Organization.fromJson(data) as T;
    }
    if (t == _i91.Person) {
      return _i91.Person.fromJson(data) as T;
    }
    if (t == _i92.Course) {
      return _i92.Course.fromJson(data) as T;
    }
    if (t == _i93.Enrollment) {
      return _i93.Enrollment.fromJson(data) as T;
    }
    if (t == _i94.Student) {
      return _i94.Student.fromJson(data) as T;
    }
    if (t == _i95.Arena) {
      return _i95.Arena.fromJson(data) as T;
    }
    if (t == _i96.Player) {
      return _i96.Player.fromJson(data) as T;
    }
    if (t == _i97.Team) {
      return _i97.Team.fromJson(data) as T;
    }
    if (t == _i98.Comment) {
      return _i98.Comment.fromJson(data) as T;
    }
    if (t == _i99.Customer) {
      return _i99.Customer.fromJson(data) as T;
    }
    if (t == _i100.Book) {
      return _i100.Book.fromJson(data) as T;
    }
    if (t == _i101.Chapter) {
      return _i101.Chapter.fromJson(data) as T;
    }
    if (t == _i102.Order) {
      return _i102.Order.fromJson(data) as T;
    }
    if (t == _i103.Address) {
      return _i103.Address.fromJson(data) as T;
    }
    if (t == _i104.Citizen) {
      return _i104.Citizen.fromJson(data) as T;
    }
    if (t == _i105.Company) {
      return _i105.Company.fromJson(data) as T;
    }
    if (t == _i106.Town) {
      return _i106.Town.fromJson(data) as T;
    }
    if (t == _i107.Blocking) {
      return _i107.Blocking.fromJson(data) as T;
    }
    if (t == _i108.Member) {
      return _i108.Member.fromJson(data) as T;
    }
    if (t == _i109.Cat) {
      return _i109.Cat.fromJson(data) as T;
    }
    if (t == _i110.Post) {
      return _i110.Post.fromJson(data) as T;
    }
    if (t == _i111.ObjectFieldPersist) {
      return _i111.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i112.ObjectFieldScopes) {
      return _i112.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i113.ObjectWithBit) {
      return _i113.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i114.ObjectWithByteData) {
      return _i114.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i115.ObjectWithDuration) {
      return _i115.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithDynamic) {
      return _i116.ObjectWithDynamic.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithEnum) {
      return _i117.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithEnumEnhanced) {
      return _i118.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithHalfVector) {
      return _i119.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i120.ObjectWithIndex) {
      return _i120.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i121.ObjectWithJsonb) {
      return _i121.ObjectWithJsonb.fromJson(data) as T;
    }
    if (t == _i122.ObjectWithJsonbClassLevel) {
      return _i122.ObjectWithJsonbClassLevel.fromJson(data) as T;
    }
    if (t == _i123.ObjectWithMaps) {
      return _i123.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i124.ObjectWithObject) {
      return _i124.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i125.ObjectWithParent) {
      return _i125.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i126.ObjectWithSealedClass) {
      return _i126.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i127.ObjectWithSelfParent) {
      return _i127.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i128.ObjectWithSparseVector) {
      return _i128.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i129.ObjectWithUuid) {
      return _i129.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i130.ObjectWithVector) {
      return _i130.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i131.RelatedUniqueData) {
      return _i131.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i132.ModelWithRequiredField) {
      return _i132.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i133.SimpleData) {
      return _i133.SimpleData.fromJson(data) as T;
    }
    if (t == _i134.SimpleDateTime) {
      return _i134.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i135.TestEnum) {
      return _i135.TestEnum.fromJson(data) as T;
    }
    if (t == _i136.TestEnumDefaultSerialization) {
      return _i136.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i137.TestEnumEnhanced) {
      return _i137.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i138.TestEnumEnhancedByName) {
      return _i138.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i139.TestEnumStringified) {
      return _i139.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i140.Types) {
      return _i140.Types.fromJson(data) as T;
    }
    if (t == _i141.UniqueData) {
      return _i141.UniqueData.fromJson(data) as T;
    }
    if (t == _i142.UniqueDataWithNonPersist) {
      return _i142.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _i143.UpsertTestModel) {
      return _i143.UpsertTestModel.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.CourseUuid?>()) {
      return (data != null ? _i5.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.EnrollmentInt?>()) {
      return (data != null ? _i6.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.StudentUuid?>()) {
      return (data != null ? _i7.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ArenaUuid?>()) {
      return (data != null ? _i8.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.PlayerUuid?>()) {
      return (data != null ? _i9.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.TeamInt?>()) {
      return (data != null ? _i10.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.CommentInt?>()) {
      return (data != null ? _i11.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.CustomerInt?>()) {
      return (data != null ? _i12.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.OrderUuid?>()) {
      return (data != null ? _i13.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.AddressUuid?>()) {
      return (data != null ? _i14.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.CitizenInt?>()) {
      return (data != null ? _i15.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.CompanyUuid?>()) {
      return (data != null ? _i16.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.TownInt?>()) {
      return (data != null ? _i17.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i18.ChangedIdTypeSelf?>()) {
      return (data != null ? _i18.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.ServerOnlyChangedIdFieldClass?>()) {
      return (data != null
              ? _i19.ServerOnlyChangedIdFieldClass.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i20.BigIntDefault?>()) {
      return (data != null ? _i20.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BigIntDefaultMix?>()) {
      return (data != null ? _i21.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.BigIntDefaultModel?>()) {
      return (data != null ? _i22.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.BigIntDefaultPersist?>()) {
      return (data != null ? _i23.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i24.BoolDefault?>()) {
      return (data != null ? _i24.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BoolDefaultMix?>()) {
      return (data != null ? _i25.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BoolDefaultModel?>()) {
      return (data != null ? _i26.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.BoolDefaultPersist?>()) {
      return (data != null ? _i27.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i28.DateTimeDefault?>()) {
      return (data != null ? _i28.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.DateTimeDefaultMix?>()) {
      return (data != null ? _i29.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.DateTimeDefaultModel?>()) {
      return (data != null ? _i30.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.DateTimeDefaultPersist?>()) {
      return (data != null ? _i31.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i32.DoubleDefault?>()) {
      return (data != null ? _i32.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.DoubleDefaultMix?>()) {
      return (data != null ? _i33.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.DoubleDefaultModel?>()) {
      return (data != null ? _i34.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.DoubleDefaultPersist?>()) {
      return (data != null ? _i35.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i36.DurationDefault?>()) {
      return (data != null ? _i36.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.DurationDefaultMix?>()) {
      return (data != null ? _i37.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.DurationDefaultModel?>()) {
      return (data != null ? _i38.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.DurationDefaultPersist?>()) {
      return (data != null ? _i39.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i40.EnumDefault?>()) {
      return (data != null ? _i40.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.EnumDefaultMix?>()) {
      return (data != null ? _i41.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.EnumDefaultModel?>()) {
      return (data != null ? _i42.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.EnumDefaultPersist?>()) {
      return (data != null ? _i43.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.ByIndexEnum?>()) {
      return (data != null ? _i44.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ByNameEnum?>()) {
      return (data != null ? _i45.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.DefaultValueEnum?>()) {
      return (data != null ? _i46.DefaultValueEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.DefaultException?>()) {
      return (data != null ? _i47.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.IntDefault?>()) {
      return (data != null ? _i48.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.IntDefaultMix?>()) {
      return (data != null ? _i49.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.IntDefaultModel?>()) {
      return (data != null ? _i50.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.IntDefaultPersist?>()) {
      return (data != null ? _i51.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.StringDefault?>()) {
      return (data != null ? _i52.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.StringDefaultMix?>()) {
      return (data != null ? _i53.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.StringDefaultModel?>()) {
      return (data != null ? _i54.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.StringDefaultPersist?>()) {
      return (data != null ? _i55.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.UriDefault?>()) {
      return (data != null ? _i56.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.UriDefaultMix?>()) {
      return (data != null ? _i57.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.UriDefaultModel?>()) {
      return (data != null ? _i58.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.UriDefaultPersist?>()) {
      return (data != null ? _i59.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.UuidDefault?>()) {
      return (data != null ? _i60.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.UuidDefaultMix?>()) {
      return (data != null ? _i61.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.UuidDefaultModel?>()) {
      return (data != null ? _i62.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.UuidDefaultPersist?>()) {
      return (data != null ? _i63.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i64.EmptyModel?>()) {
      return (data != null ? _i64.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.EmptyModelRelationItem?>()) {
      return (data != null ? _i65.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.EmptyModelWithTable?>()) {
      return (data != null ? _i66.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.RelationEmptyModel?>()) {
      return (data != null ? _i67.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _i68.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i69.NonTableParentClass?>()) {
      return (data != null ? _i69.NonTableParentClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i70.ModifiedColumnName?>()) {
      return (data != null ? _i70.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i71.Department?>()) {
      return (data != null ? _i71.Department.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.Employee?>()) {
      return (data != null ? _i72.Employee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.Contractor?>()) {
      return (data != null ? _i73.Contractor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.Service?>()) {
      return (data != null ? _i74.Service.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _i75.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i76.SealedGrandChild?>()) {
      return (data != null ? _i76.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.SealedChild?>()) {
      return (data != null ? _i76.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.SealedOtherChild?>()) {
      return (data != null ? _i76.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.CityWithLongTableName?>()) {
      return (data != null ? _i77.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i78.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i78.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i79.PersonWithLongTableName?>()) {
      return (data != null ? _i79.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.MaxFieldName?>()) {
      return (data != null ? _i80.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.LongImplicitIdField?>()) {
      return (data != null ? _i81.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i82.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i83.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i83.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i84.UserNote?>()) {
      return (data != null ? _i84.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.UserNoteCollection?>()) {
      return (data != null ? _i85.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i86.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i86.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i87.UserNoteWithALongName?>()) {
      return (data != null ? _i87.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.MultipleMaxFieldName?>()) {
      return (data != null ? _i88.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i89.City?>()) {
      return (data != null ? _i89.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.Organization?>()) {
      return (data != null ? _i90.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.Person?>()) {
      return (data != null ? _i91.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.Course?>()) {
      return (data != null ? _i92.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.Enrollment?>()) {
      return (data != null ? _i93.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.Student?>()) {
      return (data != null ? _i94.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.Arena?>()) {
      return (data != null ? _i95.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.Player?>()) {
      return (data != null ? _i96.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.Team?>()) {
      return (data != null ? _i97.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.Comment?>()) {
      return (data != null ? _i98.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.Customer?>()) {
      return (data != null ? _i99.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Book?>()) {
      return (data != null ? _i100.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.Chapter?>()) {
      return (data != null ? _i101.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.Order?>()) {
      return (data != null ? _i102.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.Address?>()) {
      return (data != null ? _i103.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.Citizen?>()) {
      return (data != null ? _i104.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.Company?>()) {
      return (data != null ? _i105.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i106.Town?>()) {
      return (data != null ? _i106.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i107.Blocking?>()) {
      return (data != null ? _i107.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.Member?>()) {
      return (data != null ? _i108.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.Cat?>()) {
      return (data != null ? _i109.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.Post?>()) {
      return (data != null ? _i110.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.ObjectFieldPersist?>()) {
      return (data != null ? _i111.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i112.ObjectFieldScopes?>()) {
      return (data != null ? _i112.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i113.ObjectWithBit?>()) {
      return (data != null ? _i113.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.ObjectWithByteData?>()) {
      return (data != null ? _i114.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i115.ObjectWithDuration?>()) {
      return (data != null ? _i115.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i116.ObjectWithDynamic?>()) {
      return (data != null ? _i116.ObjectWithDynamic.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i117.ObjectWithEnum?>()) {
      return (data != null ? _i117.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i118.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i118.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i119.ObjectWithHalfVector?>()) {
      return (data != null ? _i119.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i120.ObjectWithIndex?>()) {
      return (data != null ? _i120.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.ObjectWithJsonb?>()) {
      return (data != null ? _i121.ObjectWithJsonb.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i122.ObjectWithJsonbClassLevel?>()) {
      return (data != null
              ? _i122.ObjectWithJsonbClassLevel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i123.ObjectWithMaps?>()) {
      return (data != null ? _i123.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.ObjectWithObject?>()) {
      return (data != null ? _i124.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i125.ObjectWithParent?>()) {
      return (data != null ? _i125.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i126.ObjectWithSealedClass?>()) {
      return (data != null ? _i126.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i127.ObjectWithSelfParent?>()) {
      return (data != null ? _i127.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i128.ObjectWithSparseVector?>()) {
      return (data != null ? _i128.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i129.ObjectWithUuid?>()) {
      return (data != null ? _i129.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i130.ObjectWithVector?>()) {
      return (data != null ? _i130.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.RelatedUniqueData?>()) {
      return (data != null ? _i131.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i132.ModelWithRequiredField?>()) {
      return (data != null ? _i132.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i133.SimpleData?>()) {
      return (data != null ? _i133.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i134.SimpleDateTime?>()) {
      return (data != null ? _i134.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.TestEnum?>()) {
      return (data != null ? _i135.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i136.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i136.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i137.TestEnumEnhanced?>()) {
      return (data != null ? _i137.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i138.TestEnumEnhancedByName?>()) {
      return (data != null ? _i138.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i139.TestEnumStringified?>()) {
      return (data != null ? _i139.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i140.Types?>()) {
      return (data != null ? _i140.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i141.UniqueData?>()) {
      return (data != null ? _i141.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i142.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i142.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i143.UpsertTestModel?>()) {
      return (data != null ? _i143.UpsertTestModel.fromJson(data) : null) as T;
    }
    if (t == List<_i6.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i6.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i6.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i6.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i9.PlayerUuid>) {
      return (data as List).map((e) => deserialize<_i9.PlayerUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i13.OrderUuid>) {
      return (data as List).map((e) => deserialize<_i13.OrderUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i13.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i13.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i11.CommentInt>) {
      return (data as List).map((e) => deserialize<_i11.CommentInt>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i18.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_i18.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i18.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i18.ChangedIdTypeSelf>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i65.EmptyModelRelationItem>) {
      return (data as List)
              .map((e) => deserialize<_i65.EmptyModelRelationItem>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i65.EmptyModelRelationItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i65.EmptyModelRelationItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i72.Employee>) {
      return (data as List).map((e) => deserialize<_i72.Employee>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i72.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i72.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i79.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i79.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i79.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i79.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i78.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i78.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i78.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i78.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i81.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i81.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i81.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i81.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i88.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i88.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i88.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i88.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i84.UserNote>) {
      return (data as List).map((e) => deserialize<_i84.UserNote>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i84.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i84.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i87.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i87.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i87.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i87.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i91.Person>) {
      return (data as List).map((e) => deserialize<_i91.Person>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i91.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i91.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i90.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i90.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i90.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i90.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i93.Enrollment>) {
      return (data as List).map((e) => deserialize<_i93.Enrollment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i93.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i93.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i96.Player>) {
      return (data as List).map((e) => deserialize<_i96.Player>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i96.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i96.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i102.Order>) {
      return (data as List).map((e) => deserialize<_i102.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i102.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i102.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i101.Chapter>) {
      return (data as List).map((e) => deserialize<_i101.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i101.Chapter>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i101.Chapter>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i98.Comment>) {
      return (data as List).map((e) => deserialize<_i98.Comment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i98.Comment>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i98.Comment>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i107.Blocking>) {
      return (data as List).map((e) => deserialize<_i107.Blocking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i107.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i107.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i109.Cat>) {
      return (data as List).map((e) => deserialize<_i109.Cat>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i109.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i109.Cat>(e)).toList()
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
    if (t == List<_i135.TestEnum>) {
      return (data as List).map((e) => deserialize<_i135.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i135.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i135.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i135.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i135.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i137.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i137.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i138.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i138.TestEnumEnhancedByName>(e))
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
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, _i133.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i133.SimpleData>(v),
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
    if (t == Map<String, _i144.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i144.ByteData>(v),
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
    if (t == Map<String, _i133.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i133.SimpleData?>(v),
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
    if (t == Map<String, _i144.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i144.ByteData?>(v),
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
    if (t == List<_i133.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i133.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i133.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i133.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i133.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i133.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i133.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i133.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i133.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i133.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i133.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i133.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i133.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i133.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i133.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i133.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i133.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i133.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i133.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i133.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i133.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i133.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i133.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i133.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i133.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i133.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i133.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i133.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i133.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i133.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i76.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i76.SealedParent>(e))
              .toList()
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
    if (t == List<_i145.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i145.SimpleData>(e))
              .toList()
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
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i5.CourseUuid => 'CourseUuid',
      _i6.EnrollmentInt => 'EnrollmentInt',
      _i7.StudentUuid => 'StudentUuid',
      _i8.ArenaUuid => 'ArenaUuid',
      _i9.PlayerUuid => 'PlayerUuid',
      _i10.TeamInt => 'TeamInt',
      _i11.CommentInt => 'CommentInt',
      _i12.CustomerInt => 'CustomerInt',
      _i13.OrderUuid => 'OrderUuid',
      _i14.AddressUuid => 'AddressUuid',
      _i15.CitizenInt => 'CitizenInt',
      _i16.CompanyUuid => 'CompanyUuid',
      _i17.TownInt => 'TownInt',
      _i18.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _i19.ServerOnlyChangedIdFieldClass => 'ServerOnlyChangedIdFieldClass',
      _i20.BigIntDefault => 'BigIntDefault',
      _i21.BigIntDefaultMix => 'BigIntDefaultMix',
      _i22.BigIntDefaultModel => 'BigIntDefaultModel',
      _i23.BigIntDefaultPersist => 'BigIntDefaultPersist',
      _i24.BoolDefault => 'BoolDefault',
      _i25.BoolDefaultMix => 'BoolDefaultMix',
      _i26.BoolDefaultModel => 'BoolDefaultModel',
      _i27.BoolDefaultPersist => 'BoolDefaultPersist',
      _i28.DateTimeDefault => 'DateTimeDefault',
      _i29.DateTimeDefaultMix => 'DateTimeDefaultMix',
      _i30.DateTimeDefaultModel => 'DateTimeDefaultModel',
      _i31.DateTimeDefaultPersist => 'DateTimeDefaultPersist',
      _i32.DoubleDefault => 'DoubleDefault',
      _i33.DoubleDefaultMix => 'DoubleDefaultMix',
      _i34.DoubleDefaultModel => 'DoubleDefaultModel',
      _i35.DoubleDefaultPersist => 'DoubleDefaultPersist',
      _i36.DurationDefault => 'DurationDefault',
      _i37.DurationDefaultMix => 'DurationDefaultMix',
      _i38.DurationDefaultModel => 'DurationDefaultModel',
      _i39.DurationDefaultPersist => 'DurationDefaultPersist',
      _i40.EnumDefault => 'EnumDefault',
      _i41.EnumDefaultMix => 'EnumDefaultMix',
      _i42.EnumDefaultModel => 'EnumDefaultModel',
      _i43.EnumDefaultPersist => 'EnumDefaultPersist',
      _i44.ByIndexEnum => 'ByIndexEnum',
      _i45.ByNameEnum => 'ByNameEnum',
      _i46.DefaultValueEnum => 'DefaultValueEnum',
      _i47.DefaultException => 'DefaultException',
      _i48.IntDefault => 'IntDefault',
      _i49.IntDefaultMix => 'IntDefaultMix',
      _i50.IntDefaultModel => 'IntDefaultModel',
      _i51.IntDefaultPersist => 'IntDefaultPersist',
      _i52.StringDefault => 'StringDefault',
      _i53.StringDefaultMix => 'StringDefaultMix',
      _i54.StringDefaultModel => 'StringDefaultModel',
      _i55.StringDefaultPersist => 'StringDefaultPersist',
      _i56.UriDefault => 'UriDefault',
      _i57.UriDefaultMix => 'UriDefaultMix',
      _i58.UriDefaultModel => 'UriDefaultModel',
      _i59.UriDefaultPersist => 'UriDefaultPersist',
      _i60.UuidDefault => 'UuidDefault',
      _i61.UuidDefaultMix => 'UuidDefaultMix',
      _i62.UuidDefaultModel => 'UuidDefaultModel',
      _i63.UuidDefaultPersist => 'UuidDefaultPersist',
      _i64.EmptyModel => 'EmptyModel',
      _i65.EmptyModelRelationItem => 'EmptyModelRelationItem',
      _i66.EmptyModelWithTable => 'EmptyModelWithTable',
      _i67.RelationEmptyModel => 'RelationEmptyModel',
      _i68.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i69.NonTableParentClass => 'NonTableParentClass',
      _i70.ModifiedColumnName => 'ModifiedColumnName',
      _i71.Department => 'Department',
      _i72.Employee => 'Employee',
      _i73.Contractor => 'Contractor',
      _i74.Service => 'Service',
      _i75.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i76.SealedGrandChild => 'SealedGrandChild',
      _i76.SealedChild => 'SealedChild',
      _i76.SealedOtherChild => 'SealedOtherChild',
      _i77.CityWithLongTableName => 'CityWithLongTableName',
      _i78.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i79.PersonWithLongTableName => 'PersonWithLongTableName',
      _i80.MaxFieldName => 'MaxFieldName',
      _i81.LongImplicitIdField => 'LongImplicitIdField',
      _i82.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i83.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i84.UserNote => 'UserNote',
      _i85.UserNoteCollection => 'UserNoteCollection',
      _i86.UserNoteCollectionWithALongName => 'UserNoteCollectionWithALongName',
      _i87.UserNoteWithALongName => 'UserNoteWithALongName',
      _i88.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i89.City => 'City',
      _i90.Organization => 'Organization',
      _i91.Person => 'Person',
      _i92.Course => 'Course',
      _i93.Enrollment => 'Enrollment',
      _i94.Student => 'Student',
      _i95.Arena => 'Arena',
      _i96.Player => 'Player',
      _i97.Team => 'Team',
      _i98.Comment => 'Comment',
      _i99.Customer => 'Customer',
      _i100.Book => 'Book',
      _i101.Chapter => 'Chapter',
      _i102.Order => 'Order',
      _i103.Address => 'Address',
      _i104.Citizen => 'Citizen',
      _i105.Company => 'Company',
      _i106.Town => 'Town',
      _i107.Blocking => 'Blocking',
      _i108.Member => 'Member',
      _i109.Cat => 'Cat',
      _i110.Post => 'Post',
      _i111.ObjectFieldPersist => 'ObjectFieldPersist',
      _i112.ObjectFieldScopes => 'ObjectFieldScopes',
      _i113.ObjectWithBit => 'ObjectWithBit',
      _i114.ObjectWithByteData => 'ObjectWithByteData',
      _i115.ObjectWithDuration => 'ObjectWithDuration',
      _i116.ObjectWithDynamic => 'ObjectWithDynamic',
      _i117.ObjectWithEnum => 'ObjectWithEnum',
      _i118.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i119.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i120.ObjectWithIndex => 'ObjectWithIndex',
      _i121.ObjectWithJsonb => 'ObjectWithJsonb',
      _i122.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i123.ObjectWithMaps => 'ObjectWithMaps',
      _i124.ObjectWithObject => 'ObjectWithObject',
      _i125.ObjectWithParent => 'ObjectWithParent',
      _i126.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i127.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i128.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i129.ObjectWithUuid => 'ObjectWithUuid',
      _i130.ObjectWithVector => 'ObjectWithVector',
      _i131.RelatedUniqueData => 'RelatedUniqueData',
      _i132.ModelWithRequiredField => 'ModelWithRequiredField',
      _i133.SimpleData => 'SimpleData',
      _i134.SimpleDateTime => 'SimpleDateTime',
      _i135.TestEnum => 'TestEnum',
      _i136.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i137.TestEnumEnhanced => 'TestEnumEnhanced',
      _i138.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i139.TestEnumStringified => 'TestEnumStringified',
      _i140.Types => 'Types',
      _i141.UniqueData => 'UniqueData',
      _i142.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
      _i143.UpsertTestModel => 'UpsertTestModel',
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
      case _i5.CourseUuid():
        return 'CourseUuid';
      case _i6.EnrollmentInt():
        return 'EnrollmentInt';
      case _i7.StudentUuid():
        return 'StudentUuid';
      case _i8.ArenaUuid():
        return 'ArenaUuid';
      case _i9.PlayerUuid():
        return 'PlayerUuid';
      case _i10.TeamInt():
        return 'TeamInt';
      case _i11.CommentInt():
        return 'CommentInt';
      case _i12.CustomerInt():
        return 'CustomerInt';
      case _i13.OrderUuid():
        return 'OrderUuid';
      case _i14.AddressUuid():
        return 'AddressUuid';
      case _i15.CitizenInt():
        return 'CitizenInt';
      case _i16.CompanyUuid():
        return 'CompanyUuid';
      case _i17.TownInt():
        return 'TownInt';
      case _i18.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _i19.ServerOnlyChangedIdFieldClass():
        return 'ServerOnlyChangedIdFieldClass';
      case _i20.BigIntDefault():
        return 'BigIntDefault';
      case _i21.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i22.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _i23.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _i24.BoolDefault():
        return 'BoolDefault';
      case _i25.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _i26.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i27.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _i28.DateTimeDefault():
        return 'DateTimeDefault';
      case _i29.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _i30.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _i31.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _i32.DoubleDefault():
        return 'DoubleDefault';
      case _i33.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i34.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _i35.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _i36.DurationDefault():
        return 'DurationDefault';
      case _i37.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i38.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _i39.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _i40.EnumDefault():
        return 'EnumDefault';
      case _i41.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _i42.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i43.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i44.ByIndexEnum():
        return 'ByIndexEnum';
      case _i45.ByNameEnum():
        return 'ByNameEnum';
      case _i46.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _i47.DefaultException():
        return 'DefaultException';
      case _i48.IntDefault():
        return 'IntDefault';
      case _i49.IntDefaultMix():
        return 'IntDefaultMix';
      case _i50.IntDefaultModel():
        return 'IntDefaultModel';
      case _i51.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i52.StringDefault():
        return 'StringDefault';
      case _i53.StringDefaultMix():
        return 'StringDefaultMix';
      case _i54.StringDefaultModel():
        return 'StringDefaultModel';
      case _i55.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i56.UriDefault():
        return 'UriDefault';
      case _i57.UriDefaultMix():
        return 'UriDefaultMix';
      case _i58.UriDefaultModel():
        return 'UriDefaultModel';
      case _i59.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _i60.UuidDefault():
        return 'UuidDefault';
      case _i61.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i62.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i63.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _i64.EmptyModel():
        return 'EmptyModel';
      case _i65.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _i66.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _i67.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _i68.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i69.NonTableParentClass():
        return 'NonTableParentClass';
      case _i70.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i71.Department():
        return 'Department';
      case _i72.Employee():
        return 'Employee';
      case _i73.Contractor():
        return 'Contractor';
      case _i74.Service():
        return 'Service';
      case _i75.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i76.SealedGrandChild():
        return 'SealedGrandChild';
      case _i76.SealedChild():
        return 'SealedChild';
      case _i76.SealedOtherChild():
        return 'SealedOtherChild';
      case _i77.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i78.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i79.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i80.MaxFieldName():
        return 'MaxFieldName';
      case _i81.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i82.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i83.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i84.UserNote():
        return 'UserNote';
      case _i85.UserNoteCollection():
        return 'UserNoteCollection';
      case _i86.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i87.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i88.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i89.City():
        return 'City';
      case _i90.Organization():
        return 'Organization';
      case _i91.Person():
        return 'Person';
      case _i92.Course():
        return 'Course';
      case _i93.Enrollment():
        return 'Enrollment';
      case _i94.Student():
        return 'Student';
      case _i95.Arena():
        return 'Arena';
      case _i96.Player():
        return 'Player';
      case _i97.Team():
        return 'Team';
      case _i98.Comment():
        return 'Comment';
      case _i99.Customer():
        return 'Customer';
      case _i100.Book():
        return 'Book';
      case _i101.Chapter():
        return 'Chapter';
      case _i102.Order():
        return 'Order';
      case _i103.Address():
        return 'Address';
      case _i104.Citizen():
        return 'Citizen';
      case _i105.Company():
        return 'Company';
      case _i106.Town():
        return 'Town';
      case _i107.Blocking():
        return 'Blocking';
      case _i108.Member():
        return 'Member';
      case _i109.Cat():
        return 'Cat';
      case _i110.Post():
        return 'Post';
      case _i111.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i112.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i113.ObjectWithBit():
        return 'ObjectWithBit';
      case _i114.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i115.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i116.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _i117.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i118.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i119.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i120.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i121.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i122.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i123.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i124.ObjectWithObject():
        return 'ObjectWithObject';
      case _i125.ObjectWithParent():
        return 'ObjectWithParent';
      case _i126.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i127.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i128.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i129.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i130.ObjectWithVector():
        return 'ObjectWithVector';
      case _i131.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i132.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i133.SimpleData():
        return 'SimpleData';
      case _i134.SimpleDateTime():
        return 'SimpleDateTime';
      case _i135.TestEnum():
        return 'TestEnum';
      case _i136.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i137.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i138.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i139.TestEnumStringified():
        return 'TestEnumStringified';
      case _i140.Types():
        return 'Types';
      case _i141.UniqueData():
        return 'UniqueData';
      case _i142.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _i143.UpsertTestModel():
        return 'UpsertTestModel';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
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
    if (dataClassName == 'CourseUuid') {
      return deserialize<_i5.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i6.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i7.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i8.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i9.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i10.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i11.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_i12.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_i13.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_i14.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_i15.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i16.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_i17.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_i18.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChangedIdFieldClass') {
      return deserialize<_i19.ServerOnlyChangedIdFieldClass>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i20.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i21.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i22.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i23.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i24.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i25.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i26.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i27.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i28.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i29.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i30.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i31.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i32.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i33.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i34.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i35.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i36.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i37.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i38.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i39.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i40.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i41.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i42.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i43.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i44.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i45.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_i46.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i47.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i48.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i49.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i50.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i51.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i52.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i53.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i54.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i55.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i56.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i57.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i58.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i59.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i60.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i61.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i62.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i63.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i64.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i65.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i66.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i67.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i68.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i69.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i70.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i71.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i72.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i73.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i74.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i75.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i76.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i76.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i76.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i77.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i78.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i79.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i80.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i81.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i82.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i83.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i84.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i85.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i86.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i87.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i88.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i89.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i90.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i91.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i92.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i93.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i94.Student>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i95.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i96.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i97.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i98.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i99.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i100.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i101.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i102.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i103.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i104.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i105.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i106.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i107.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i108.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i109.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i110.Post>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i111.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i112.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i113.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i114.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i115.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithDynamic') {
      return deserialize<_i116.ObjectWithDynamic>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i117.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i118.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i119.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i120.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_i121.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i122.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i123.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i124.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i125.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i126.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i127.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i128.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i129.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i130.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i131.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i132.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i133.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i134.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i135.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i136.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i137.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i138.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i139.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i140.Types>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i141.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i142.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_i143.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i3.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
    _i4.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
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
      case _i5.CourseUuid:
        return _i5.CourseUuid.t;
      case _i6.EnrollmentInt:
        return _i6.EnrollmentInt.t;
      case _i7.StudentUuid:
        return _i7.StudentUuid.t;
      case _i8.ArenaUuid:
        return _i8.ArenaUuid.t;
      case _i9.PlayerUuid:
        return _i9.PlayerUuid.t;
      case _i10.TeamInt:
        return _i10.TeamInt.t;
      case _i11.CommentInt:
        return _i11.CommentInt.t;
      case _i12.CustomerInt:
        return _i12.CustomerInt.t;
      case _i13.OrderUuid:
        return _i13.OrderUuid.t;
      case _i14.AddressUuid:
        return _i14.AddressUuid.t;
      case _i15.CitizenInt:
        return _i15.CitizenInt.t;
      case _i16.CompanyUuid:
        return _i16.CompanyUuid.t;
      case _i17.TownInt:
        return _i17.TownInt.t;
      case _i18.ChangedIdTypeSelf:
        return _i18.ChangedIdTypeSelf.t;
      case _i19.ServerOnlyChangedIdFieldClass:
        return _i19.ServerOnlyChangedIdFieldClass.t;
      case _i20.BigIntDefault:
        return _i20.BigIntDefault.t;
      case _i21.BigIntDefaultMix:
        return _i21.BigIntDefaultMix.t;
      case _i22.BigIntDefaultModel:
        return _i22.BigIntDefaultModel.t;
      case _i23.BigIntDefaultPersist:
        return _i23.BigIntDefaultPersist.t;
      case _i24.BoolDefault:
        return _i24.BoolDefault.t;
      case _i25.BoolDefaultMix:
        return _i25.BoolDefaultMix.t;
      case _i26.BoolDefaultModel:
        return _i26.BoolDefaultModel.t;
      case _i27.BoolDefaultPersist:
        return _i27.BoolDefaultPersist.t;
      case _i28.DateTimeDefault:
        return _i28.DateTimeDefault.t;
      case _i29.DateTimeDefaultMix:
        return _i29.DateTimeDefaultMix.t;
      case _i30.DateTimeDefaultModel:
        return _i30.DateTimeDefaultModel.t;
      case _i31.DateTimeDefaultPersist:
        return _i31.DateTimeDefaultPersist.t;
      case _i32.DoubleDefault:
        return _i32.DoubleDefault.t;
      case _i33.DoubleDefaultMix:
        return _i33.DoubleDefaultMix.t;
      case _i34.DoubleDefaultModel:
        return _i34.DoubleDefaultModel.t;
      case _i35.DoubleDefaultPersist:
        return _i35.DoubleDefaultPersist.t;
      case _i36.DurationDefault:
        return _i36.DurationDefault.t;
      case _i37.DurationDefaultMix:
        return _i37.DurationDefaultMix.t;
      case _i38.DurationDefaultModel:
        return _i38.DurationDefaultModel.t;
      case _i39.DurationDefaultPersist:
        return _i39.DurationDefaultPersist.t;
      case _i40.EnumDefault:
        return _i40.EnumDefault.t;
      case _i41.EnumDefaultMix:
        return _i41.EnumDefaultMix.t;
      case _i42.EnumDefaultModel:
        return _i42.EnumDefaultModel.t;
      case _i43.EnumDefaultPersist:
        return _i43.EnumDefaultPersist.t;
      case _i48.IntDefault:
        return _i48.IntDefault.t;
      case _i49.IntDefaultMix:
        return _i49.IntDefaultMix.t;
      case _i50.IntDefaultModel:
        return _i50.IntDefaultModel.t;
      case _i51.IntDefaultPersist:
        return _i51.IntDefaultPersist.t;
      case _i52.StringDefault:
        return _i52.StringDefault.t;
      case _i53.StringDefaultMix:
        return _i53.StringDefaultMix.t;
      case _i54.StringDefaultModel:
        return _i54.StringDefaultModel.t;
      case _i55.StringDefaultPersist:
        return _i55.StringDefaultPersist.t;
      case _i56.UriDefault:
        return _i56.UriDefault.t;
      case _i57.UriDefaultMix:
        return _i57.UriDefaultMix.t;
      case _i58.UriDefaultModel:
        return _i58.UriDefaultModel.t;
      case _i59.UriDefaultPersist:
        return _i59.UriDefaultPersist.t;
      case _i60.UuidDefault:
        return _i60.UuidDefault.t;
      case _i61.UuidDefaultMix:
        return _i61.UuidDefaultMix.t;
      case _i62.UuidDefaultModel:
        return _i62.UuidDefaultModel.t;
      case _i63.UuidDefaultPersist:
        return _i63.UuidDefaultPersist.t;
      case _i65.EmptyModelRelationItem:
        return _i65.EmptyModelRelationItem.t;
      case _i66.EmptyModelWithTable:
        return _i66.EmptyModelWithTable.t;
      case _i67.RelationEmptyModel:
        return _i67.RelationEmptyModel.t;
      case _i68.ChildClassExplicitColumn:
        return _i68.ChildClassExplicitColumn.t;
      case _i70.ModifiedColumnName:
        return _i70.ModifiedColumnName.t;
      case _i71.Department:
        return _i71.Department.t;
      case _i72.Employee:
        return _i72.Employee.t;
      case _i73.Contractor:
        return _i73.Contractor.t;
      case _i74.Service:
        return _i74.Service.t;
      case _i75.TableWithExplicitColumnName:
        return _i75.TableWithExplicitColumnName.t;
      case _i77.CityWithLongTableName:
        return _i77.CityWithLongTableName.t;
      case _i78.OrganizationWithLongTableName:
        return _i78.OrganizationWithLongTableName.t;
      case _i79.PersonWithLongTableName:
        return _i79.PersonWithLongTableName.t;
      case _i80.MaxFieldName:
        return _i80.MaxFieldName.t;
      case _i81.LongImplicitIdField:
        return _i81.LongImplicitIdField.t;
      case _i82.LongImplicitIdFieldCollection:
        return _i82.LongImplicitIdFieldCollection.t;
      case _i83.RelationToMultipleMaxFieldName:
        return _i83.RelationToMultipleMaxFieldName.t;
      case _i84.UserNote:
        return _i84.UserNote.t;
      case _i85.UserNoteCollection:
        return _i85.UserNoteCollection.t;
      case _i86.UserNoteCollectionWithALongName:
        return _i86.UserNoteCollectionWithALongName.t;
      case _i87.UserNoteWithALongName:
        return _i87.UserNoteWithALongName.t;
      case _i88.MultipleMaxFieldName:
        return _i88.MultipleMaxFieldName.t;
      case _i89.City:
        return _i89.City.t;
      case _i90.Organization:
        return _i90.Organization.t;
      case _i91.Person:
        return _i91.Person.t;
      case _i92.Course:
        return _i92.Course.t;
      case _i93.Enrollment:
        return _i93.Enrollment.t;
      case _i94.Student:
        return _i94.Student.t;
      case _i95.Arena:
        return _i95.Arena.t;
      case _i96.Player:
        return _i96.Player.t;
      case _i97.Team:
        return _i97.Team.t;
      case _i98.Comment:
        return _i98.Comment.t;
      case _i99.Customer:
        return _i99.Customer.t;
      case _i100.Book:
        return _i100.Book.t;
      case _i101.Chapter:
        return _i101.Chapter.t;
      case _i102.Order:
        return _i102.Order.t;
      case _i103.Address:
        return _i103.Address.t;
      case _i104.Citizen:
        return _i104.Citizen.t;
      case _i105.Company:
        return _i105.Company.t;
      case _i106.Town:
        return _i106.Town.t;
      case _i107.Blocking:
        return _i107.Blocking.t;
      case _i108.Member:
        return _i108.Member.t;
      case _i109.Cat:
        return _i109.Cat.t;
      case _i110.Post:
        return _i110.Post.t;
      case _i111.ObjectFieldPersist:
        return _i111.ObjectFieldPersist.t;
      case _i112.ObjectFieldScopes:
        return _i112.ObjectFieldScopes.t;
      case _i113.ObjectWithBit:
        return _i113.ObjectWithBit.t;
      case _i114.ObjectWithByteData:
        return _i114.ObjectWithByteData.t;
      case _i115.ObjectWithDuration:
        return _i115.ObjectWithDuration.t;
      case _i116.ObjectWithDynamic:
        return _i116.ObjectWithDynamic.t;
      case _i117.ObjectWithEnum:
        return _i117.ObjectWithEnum.t;
      case _i118.ObjectWithEnumEnhanced:
        return _i118.ObjectWithEnumEnhanced.t;
      case _i119.ObjectWithHalfVector:
        return _i119.ObjectWithHalfVector.t;
      case _i120.ObjectWithIndex:
        return _i120.ObjectWithIndex.t;
      case _i121.ObjectWithJsonb:
        return _i121.ObjectWithJsonb.t;
      case _i122.ObjectWithJsonbClassLevel:
        return _i122.ObjectWithJsonbClassLevel.t;
      case _i124.ObjectWithObject:
        return _i124.ObjectWithObject.t;
      case _i125.ObjectWithParent:
        return _i125.ObjectWithParent.t;
      case _i127.ObjectWithSelfParent:
        return _i127.ObjectWithSelfParent.t;
      case _i128.ObjectWithSparseVector:
        return _i128.ObjectWithSparseVector.t;
      case _i129.ObjectWithUuid:
        return _i129.ObjectWithUuid.t;
      case _i130.ObjectWithVector:
        return _i130.ObjectWithVector.t;
      case _i131.RelatedUniqueData:
        return _i131.RelatedUniqueData.t;
      case _i132.ModelWithRequiredField:
        return _i132.ModelWithRequiredField.t;
      case _i133.SimpleData:
        return _i133.SimpleData.t;
      case _i134.SimpleDateTime:
        return _i134.SimpleDateTime.t;
      case _i140.Types:
        return _i140.Types.t;
      case _i141.UniqueData:
        return _i141.UniqueData.t;
      case _i142.UniqueDataWithNonPersist:
        return _i142.UniqueDataWithNonPersist.t;
      case _i143.UpsertTestModel:
        return _i143.UpsertTestModel.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
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
