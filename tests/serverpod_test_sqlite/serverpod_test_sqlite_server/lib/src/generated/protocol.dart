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
import 'changed_id_type/many_to_many/course.dart' as _i3;
import 'changed_id_type/many_to_many/enrollment.dart' as _i4;
import 'changed_id_type/many_to_many/student.dart' as _i5;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i6;
import 'changed_id_type/nested_one_to_many/player.dart' as _i7;
import 'changed_id_type/nested_one_to_many/team.dart' as _i8;
import 'changed_id_type/one_to_many/comment.dart' as _i9;
import 'changed_id_type/one_to_many/customer.dart' as _i10;
import 'changed_id_type/one_to_many/order.dart' as _i11;
import 'changed_id_type/one_to_one/address.dart' as _i12;
import 'changed_id_type/one_to_one/citizen.dart' as _i13;
import 'changed_id_type/one_to_one/company.dart' as _i14;
import 'changed_id_type/one_to_one/town.dart' as _i15;
import 'changed_id_type/self.dart' as _i16;
import 'changed_id_type/server_only.dart' as _i17;
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
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i70;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i71;
import 'explicit_column_name/modified_column_name.dart' as _i72;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i73;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i74;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i75;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i76;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i77;
import 'inheritance/sealed_parent.dart' as _i78;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i79;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i80;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i81;
import 'long_identifiers/max_field_name.dart' as _i82;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i83;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i84;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i85;
import 'long_identifiers/models_with_relations/user_note.dart' as _i86;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i87;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i88;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i89;
import 'long_identifiers/multiple_max_field_name.dart' as _i90;
import 'models_with_list_relations/city.dart' as _i91;
import 'models_with_list_relations/organization.dart' as _i92;
import 'models_with_list_relations/person.dart' as _i93;
import 'models_with_relations/many_to_many/course.dart' as _i94;
import 'models_with_relations/many_to_many/enrollment.dart' as _i95;
import 'models_with_relations/many_to_many/student.dart' as _i96;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i97;
import 'models_with_relations/nested_one_to_many/player.dart' as _i98;
import 'models_with_relations/nested_one_to_many/team.dart' as _i99;
import 'models_with_relations/one_to_many/comment.dart' as _i100;
import 'models_with_relations/one_to_many/customer.dart' as _i101;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i102;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i103;
import 'models_with_relations/one_to_many/order.dart' as _i104;
import 'models_with_relations/one_to_one/address.dart' as _i105;
import 'models_with_relations/one_to_one/citizen.dart' as _i106;
import 'models_with_relations/one_to_one/company.dart' as _i107;
import 'models_with_relations/one_to_one/town.dart' as _i108;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i109;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i110;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i111;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i112;
import 'object_field_persist.dart' as _i113;
import 'object_field_scopes.dart' as _i114;
import 'object_with_bit.dart' as _i115;
import 'object_with_bytedata.dart' as _i116;
import 'object_with_decimal.dart' as _i117;
import 'object_with_decimal_precision.dart' as _i118;
import 'object_with_duration.dart' as _i119;
import 'object_with_enum.dart' as _i120;
import 'object_with_enum_enhanced.dart' as _i121;
import 'object_with_half_vector.dart' as _i122;
import 'object_with_index.dart' as _i123;
import 'object_with_maps.dart' as _i124;
import 'object_with_object.dart' as _i125;
import 'object_with_parent.dart' as _i126;
import 'object_with_sealed_class.dart' as _i127;
import 'object_with_self_parent.dart' as _i128;
import 'object_with_sparse_vector.dart' as _i129;
import 'object_with_uuid.dart' as _i130;
import 'object_with_vector.dart' as _i131;
import 'related_unique_data.dart' as _i132;
import 'required/model_with_required_field.dart' as _i133;
import 'simple_data.dart' as _i134;
import 'simple_date_time.dart' as _i135;
import 'test_enum.dart' as _i136;
import 'test_enum_default_serialization.dart' as _i137;
import 'test_enum_enhanced.dart' as _i138;
import 'test_enum_enhanced_by_name.dart' as _i139;
import 'test_enum_stringified.dart' as _i140;
import 'types.dart' as _i141;
import 'unique_data.dart' as _i142;
import 'unique_data_with_non_persist.dart' as _i143;
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
export 'object_with_decimal.dart';
export 'object_with_decimal_precision.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_enum_enhanced.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
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

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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
      name: 'decimal_default',
      dartName: 'DecimalDefault',
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
          name: 'decimalDefault',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
          columnDefault: '10.5',
        ),
        _i2.ColumnDefinition(
          name: 'decimalDefaultNull',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal?',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'decimal_default_mix',
      dartName: 'DecimalDefaultMix',
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
          name: 'decimalDefaultAndDefaultModel',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
          columnDefault: '10.5',
        ),
        _i2.ColumnDefinition(
          name: 'decimalDefaultAndDefaultPersist',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
          columnDefault: '20.5',
        ),
        _i2.ColumnDefinition(
          name: 'decimalDefaultModelAndDefaultPersist',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
          columnDefault: '20.5',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'decimal_default_model',
      dartName: 'DecimalDefaultModel',
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
          name: 'decimalDefaultModelStr',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
        ),
        _i2.ColumnDefinition(
          name: 'decimalDefaultModelStrNull',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'decimal_default_persist',
      dartName: 'DecimalDefaultPersist',
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
          name: 'decimalDefaultPersist',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal?',
          columnDefault: '10.5',
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
      name: 'object_with_decimal',
      dartName: 'ObjectWithDecimal',
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
          name: 'decimalValue',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
        ),
        _i2.ColumnDefinition(
          name: 'decimalValueNull',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i2.TableDefinition(
      name: 'object_with_decimal_precision',
      dartName: 'ObjectWithDecimalPrecision',
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
          name: 'price',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(10,2)',
          decimalPrecision: 10,
          decimalScale: 2,
        ),
        _i2.ColumnDefinition(
          name: 'priceNullable',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal(10,2)?',
          decimalPrecision: 10,
          decimalScale: 2,
        ),
        _i2.ColumnDefinition(
          name: 'quantity',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(19,4)',
          decimalPrecision: 19,
          decimalScale: 4,
        ),
        _i2.ColumnDefinition(
          name: 'unbounded',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal',
        ),
        _i2.ColumnDefinition(
          name: 'priceWithDefault',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(10,2)',
          columnDefault: '9.99',
          decimalPrecision: 10,
          decimalScale: 2,
        ),
        _i2.ColumnDefinition(
          name: 'priceWithDefaultNullable',
          columnType: _i2.ColumnType.decimal,
          isNullable: true,
          dartType: 'Decimal(10,2)?',
          columnDefault: '1.23',
          decimalPrecision: 10,
          decimalScale: 2,
        ),
        _i2.ColumnDefinition(
          name: 'quantityWithDefault',
          columnType: _i2.ColumnType.decimal,
          isNullable: false,
          dartType: 'Decimal(19,4)',
          columnDefault: '100.0000',
          decimalPrecision: 19,
          decimalScale: 4,
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

    if (t == _i3.CourseUuid) {
      return _i3.CourseUuid.fromJson(data) as T;
    }
    if (t == _i4.EnrollmentInt) {
      return _i4.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i5.StudentUuid) {
      return _i5.StudentUuid.fromJson(data) as T;
    }
    if (t == _i6.ArenaUuid) {
      return _i6.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i7.PlayerUuid) {
      return _i7.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i8.TeamInt) {
      return _i8.TeamInt.fromJson(data) as T;
    }
    if (t == _i9.CommentInt) {
      return _i9.CommentInt.fromJson(data) as T;
    }
    if (t == _i10.CustomerInt) {
      return _i10.CustomerInt.fromJson(data) as T;
    }
    if (t == _i11.OrderUuid) {
      return _i11.OrderUuid.fromJson(data) as T;
    }
    if (t == _i12.AddressUuid) {
      return _i12.AddressUuid.fromJson(data) as T;
    }
    if (t == _i13.CitizenInt) {
      return _i13.CitizenInt.fromJson(data) as T;
    }
    if (t == _i14.CompanyUuid) {
      return _i14.CompanyUuid.fromJson(data) as T;
    }
    if (t == _i15.TownInt) {
      return _i15.TownInt.fromJson(data) as T;
    }
    if (t == _i16.ChangedIdTypeSelf) {
      return _i16.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _i17.ServerOnlyChangedIdFieldClass) {
      return _i17.ServerOnlyChangedIdFieldClass.fromJson(data) as T;
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
    if (t == _i70.ChildClassExplicitColumn) {
      return _i70.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i71.NonTableParentClass) {
      return _i71.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i72.ModifiedColumnName) {
      return _i72.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _i73.Department) {
      return _i73.Department.fromJson(data) as T;
    }
    if (t == _i74.Employee) {
      return _i74.Employee.fromJson(data) as T;
    }
    if (t == _i75.Contractor) {
      return _i75.Contractor.fromJson(data) as T;
    }
    if (t == _i76.Service) {
      return _i76.Service.fromJson(data) as T;
    }
    if (t == _i77.TableWithExplicitColumnName) {
      return _i77.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _i78.SealedGrandChild) {
      return _i78.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i78.SealedChild) {
      return _i78.SealedChild.fromJson(data) as T;
    }
    if (t == _i78.SealedOtherChild) {
      return _i78.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i79.CityWithLongTableName) {
      return _i79.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i80.OrganizationWithLongTableName) {
      return _i80.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i81.PersonWithLongTableName) {
      return _i81.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i82.MaxFieldName) {
      return _i82.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i83.LongImplicitIdField) {
      return _i83.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i84.LongImplicitIdFieldCollection) {
      return _i84.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i85.RelationToMultipleMaxFieldName) {
      return _i85.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i86.UserNote) {
      return _i86.UserNote.fromJson(data) as T;
    }
    if (t == _i87.UserNoteCollection) {
      return _i87.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i88.UserNoteCollectionWithALongName) {
      return _i88.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i89.UserNoteWithALongName) {
      return _i89.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i90.MultipleMaxFieldName) {
      return _i90.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i91.City) {
      return _i91.City.fromJson(data) as T;
    }
    if (t == _i92.Organization) {
      return _i92.Organization.fromJson(data) as T;
    }
    if (t == _i93.Person) {
      return _i93.Person.fromJson(data) as T;
    }
    if (t == _i94.Course) {
      return _i94.Course.fromJson(data) as T;
    }
    if (t == _i95.Enrollment) {
      return _i95.Enrollment.fromJson(data) as T;
    }
    if (t == _i96.Student) {
      return _i96.Student.fromJson(data) as T;
    }
    if (t == _i97.Arena) {
      return _i97.Arena.fromJson(data) as T;
    }
    if (t == _i98.Player) {
      return _i98.Player.fromJson(data) as T;
    }
    if (t == _i99.Team) {
      return _i99.Team.fromJson(data) as T;
    }
    if (t == _i100.Comment) {
      return _i100.Comment.fromJson(data) as T;
    }
    if (t == _i101.Customer) {
      return _i101.Customer.fromJson(data) as T;
    }
    if (t == _i102.Book) {
      return _i102.Book.fromJson(data) as T;
    }
    if (t == _i103.Chapter) {
      return _i103.Chapter.fromJson(data) as T;
    }
    if (t == _i104.Order) {
      return _i104.Order.fromJson(data) as T;
    }
    if (t == _i105.Address) {
      return _i105.Address.fromJson(data) as T;
    }
    if (t == _i106.Citizen) {
      return _i106.Citizen.fromJson(data) as T;
    }
    if (t == _i107.Company) {
      return _i107.Company.fromJson(data) as T;
    }
    if (t == _i108.Town) {
      return _i108.Town.fromJson(data) as T;
    }
    if (t == _i109.Blocking) {
      return _i109.Blocking.fromJson(data) as T;
    }
    if (t == _i110.Member) {
      return _i110.Member.fromJson(data) as T;
    }
    if (t == _i111.Cat) {
      return _i111.Cat.fromJson(data) as T;
    }
    if (t == _i112.Post) {
      return _i112.Post.fromJson(data) as T;
    }
    if (t == _i113.ObjectFieldPersist) {
      return _i113.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i114.ObjectFieldScopes) {
      return _i114.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i115.ObjectWithBit) {
      return _i115.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithByteData) {
      return _i116.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithDecimal) {
      return _i117.ObjectWithDecimal.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithDecimalPrecision) {
      return _i118.ObjectWithDecimalPrecision.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithDuration) {
      return _i119.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i120.ObjectWithEnum) {
      return _i120.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i121.ObjectWithEnumEnhanced) {
      return _i121.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i122.ObjectWithHalfVector) {
      return _i122.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i123.ObjectWithIndex) {
      return _i123.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i124.ObjectWithMaps) {
      return _i124.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i125.ObjectWithObject) {
      return _i125.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i126.ObjectWithParent) {
      return _i126.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i127.ObjectWithSealedClass) {
      return _i127.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i128.ObjectWithSelfParent) {
      return _i128.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i129.ObjectWithSparseVector) {
      return _i129.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i130.ObjectWithUuid) {
      return _i130.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i131.ObjectWithVector) {
      return _i131.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i132.RelatedUniqueData) {
      return _i132.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i133.ModelWithRequiredField) {
      return _i133.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i134.SimpleData) {
      return _i134.SimpleData.fromJson(data) as T;
    }
    if (t == _i135.SimpleDateTime) {
      return _i135.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i136.TestEnum) {
      return _i136.TestEnum.fromJson(data) as T;
    }
    if (t == _i137.TestEnumDefaultSerialization) {
      return _i137.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i138.TestEnumEnhanced) {
      return _i138.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i139.TestEnumEnhancedByName) {
      return _i139.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i140.TestEnumStringified) {
      return _i140.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i141.Types) {
      return _i141.Types.fromJson(data) as T;
    }
    if (t == _i142.UniqueData) {
      return _i142.UniqueData.fromJson(data) as T;
    }
    if (t == _i143.UniqueDataWithNonPersist) {
      return _i143.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _i1.getType<_i3.CourseUuid?>()) {
      return (data != null ? _i3.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i4.EnrollmentInt?>()) {
      return (data != null ? _i4.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i5.StudentUuid?>()) {
      return (data != null ? _i5.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.ArenaUuid?>()) {
      return (data != null ? _i6.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.PlayerUuid?>()) {
      return (data != null ? _i7.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.TeamInt?>()) {
      return (data != null ? _i8.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.CommentInt?>()) {
      return (data != null ? _i9.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.CustomerInt?>()) {
      return (data != null ? _i10.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i11.OrderUuid?>()) {
      return (data != null ? _i11.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.AddressUuid?>()) {
      return (data != null ? _i12.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.CitizenInt?>()) {
      return (data != null ? _i13.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.CompanyUuid?>()) {
      return (data != null ? _i14.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i15.TownInt?>()) {
      return (data != null ? _i15.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.ChangedIdTypeSelf?>()) {
      return (data != null ? _i16.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i17.ServerOnlyChangedIdFieldClass?>()) {
      return (data != null
              ? _i17.ServerOnlyChangedIdFieldClass.fromJson(data)
              : null)
          as T;
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
    if (t == _i1.getType<_i70.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _i70.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i71.NonTableParentClass?>()) {
      return (data != null ? _i71.NonTableParentClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i72.ModifiedColumnName?>()) {
      return (data != null ? _i72.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i73.Department?>()) {
      return (data != null ? _i73.Department.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.Employee?>()) {
      return (data != null ? _i74.Employee.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.Contractor?>()) {
      return (data != null ? _i75.Contractor.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.Service?>()) {
      return (data != null ? _i76.Service.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _i77.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i78.SealedGrandChild?>()) {
      return (data != null ? _i78.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.SealedChild?>()) {
      return (data != null ? _i78.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.SealedOtherChild?>()) {
      return (data != null ? _i78.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.CityWithLongTableName?>()) {
      return (data != null ? _i79.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i80.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i80.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i81.PersonWithLongTableName?>()) {
      return (data != null ? _i81.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i82.MaxFieldName?>()) {
      return (data != null ? _i82.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.LongImplicitIdField?>()) {
      return (data != null ? _i83.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i84.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i84.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i85.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i85.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i86.UserNote?>()) {
      return (data != null ? _i86.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.UserNoteCollection?>()) {
      return (data != null ? _i87.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i88.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i89.UserNoteWithALongName?>()) {
      return (data != null ? _i89.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i90.MultipleMaxFieldName?>()) {
      return (data != null ? _i90.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i91.City?>()) {
      return (data != null ? _i91.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.Organization?>()) {
      return (data != null ? _i92.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.Person?>()) {
      return (data != null ? _i93.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.Course?>()) {
      return (data != null ? _i94.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.Enrollment?>()) {
      return (data != null ? _i95.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.Student?>()) {
      return (data != null ? _i96.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.Arena?>()) {
      return (data != null ? _i97.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.Player?>()) {
      return (data != null ? _i98.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.Team?>()) {
      return (data != null ? _i99.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Comment?>()) {
      return (data != null ? _i100.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.Customer?>()) {
      return (data != null ? _i101.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.Book?>()) {
      return (data != null ? _i102.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.Chapter?>()) {
      return (data != null ? _i103.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.Order?>()) {
      return (data != null ? _i104.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.Address?>()) {
      return (data != null ? _i105.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i106.Citizen?>()) {
      return (data != null ? _i106.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i107.Company?>()) {
      return (data != null ? _i107.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.Town?>()) {
      return (data != null ? _i108.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.Blocking?>()) {
      return (data != null ? _i109.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.Member?>()) {
      return (data != null ? _i110.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.Cat?>()) {
      return (data != null ? _i111.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i112.Post?>()) {
      return (data != null ? _i112.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i113.ObjectFieldPersist?>()) {
      return (data != null ? _i113.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i114.ObjectFieldScopes?>()) {
      return (data != null ? _i114.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i115.ObjectWithBit?>()) {
      return (data != null ? _i115.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i116.ObjectWithByteData?>()) {
      return (data != null ? _i116.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i117.ObjectWithDecimal?>()) {
      return (data != null ? _i117.ObjectWithDecimal.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i118.ObjectWithDecimalPrecision?>()) {
      return (data != null
              ? _i118.ObjectWithDecimalPrecision.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i119.ObjectWithDuration?>()) {
      return (data != null ? _i119.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i120.ObjectWithEnum?>()) {
      return (data != null ? _i120.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i121.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i122.ObjectWithHalfVector?>()) {
      return (data != null ? _i122.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i123.ObjectWithIndex?>()) {
      return (data != null ? _i123.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.ObjectWithMaps?>()) {
      return (data != null ? _i124.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i125.ObjectWithObject?>()) {
      return (data != null ? _i125.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i126.ObjectWithParent?>()) {
      return (data != null ? _i126.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i127.ObjectWithSealedClass?>()) {
      return (data != null ? _i127.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i128.ObjectWithSelfParent?>()) {
      return (data != null ? _i128.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i129.ObjectWithSparseVector?>()) {
      return (data != null ? _i129.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i130.ObjectWithUuid?>()) {
      return (data != null ? _i130.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.ObjectWithVector?>()) {
      return (data != null ? _i131.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i132.RelatedUniqueData?>()) {
      return (data != null ? _i132.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i133.ModelWithRequiredField?>()) {
      return (data != null ? _i133.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i134.SimpleData?>()) {
      return (data != null ? _i134.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.SimpleDateTime?>()) {
      return (data != null ? _i135.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i136.TestEnum?>()) {
      return (data != null ? _i136.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i137.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i137.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i1.getType<_i138.TestEnumEnhanced?>()) {
      return (data != null ? _i138.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i139.TestEnumEnhancedByName?>()) {
      return (data != null ? _i139.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i140.TestEnumStringified?>()) {
      return (data != null ? _i140.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i141.Types?>()) {
      return (data != null ? _i141.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i142.UniqueData?>()) {
      return (data != null ? _i142.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i143.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i143.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_i4.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i4.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i4.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i4.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i7.PlayerUuid>) {
      return (data as List).map((e) => deserialize<_i7.PlayerUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i7.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i7.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i11.OrderUuid>) {
      return (data as List).map((e) => deserialize<_i11.OrderUuid>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i11.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i11.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i9.CommentInt>) {
      return (data as List).map((e) => deserialize<_i9.CommentInt>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i9.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i9.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i16.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_i16.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i16.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i16.ChangedIdTypeSelf>(e))
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
    if (t == List<_i74.Employee>) {
      return (data as List).map((e) => deserialize<_i74.Employee>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i74.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i74.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i81.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i81.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i81.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i81.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i80.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i80.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i80.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i80.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i83.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i83.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i83.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i83.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i90.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i90.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i90.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i90.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i86.UserNote>) {
      return (data as List).map((e) => deserialize<_i86.UserNote>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i86.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i86.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i89.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i89.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i89.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i89.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i93.Person>) {
      return (data as List).map((e) => deserialize<_i93.Person>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i93.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i93.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i92.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i92.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i92.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i92.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i95.Enrollment>) {
      return (data as List).map((e) => deserialize<_i95.Enrollment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i95.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i95.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i98.Player>) {
      return (data as List).map((e) => deserialize<_i98.Player>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i98.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i98.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i104.Order>) {
      return (data as List).map((e) => deserialize<_i104.Order>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i104.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i104.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i103.Chapter>) {
      return (data as List).map((e) => deserialize<_i103.Chapter>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i103.Chapter>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i103.Chapter>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i100.Comment>) {
      return (data as List).map((e) => deserialize<_i100.Comment>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i100.Comment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i100.Comment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i109.Blocking>) {
      return (data as List).map((e) => deserialize<_i109.Blocking>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i109.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i109.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i111.Cat>) {
      return (data as List).map((e) => deserialize<_i111.Cat>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i111.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i111.Cat>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i136.TestEnum>) {
      return (data as List).map((e) => deserialize<_i136.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i136.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i136.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i136.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i136.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i138.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i138.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i139.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i139.TestEnumEnhancedByName>(e))
              .toList()
          as T;
    }
    if (t == Map<String, _i134.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i134.SimpleData>(v),
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
    if (t == Map<String, String>) {
      return (data as Map).map(
            (k, v) => MapEntry(deserialize<String>(k), deserialize<String>(v)),
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
    if (t == Map<String, _i134.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i134.SimpleData?>(v),
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
    if (t == List<_i134.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i134.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i134.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i134.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i134.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i134.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<_i134.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i134.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i134.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i134.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i1.getType<List<List<_i134.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i134.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i134.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i134.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i134.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i134.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i134.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i134.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i134.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i134.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i134.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i134.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i134.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i134.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i1.getType<List<Map<int, _i134.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i134.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i134.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i134.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i134.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i134.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i78.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i78.SealedParent>(e))
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
      return _i2.Protocol().deserialize<T>(data, t);
    } on _i1.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i3.CourseUuid => 'CourseUuid',
      _i4.EnrollmentInt => 'EnrollmentInt',
      _i5.StudentUuid => 'StudentUuid',
      _i6.ArenaUuid => 'ArenaUuid',
      _i7.PlayerUuid => 'PlayerUuid',
      _i8.TeamInt => 'TeamInt',
      _i9.CommentInt => 'CommentInt',
      _i10.CustomerInt => 'CustomerInt',
      _i11.OrderUuid => 'OrderUuid',
      _i12.AddressUuid => 'AddressUuid',
      _i13.CitizenInt => 'CitizenInt',
      _i14.CompanyUuid => 'CompanyUuid',
      _i15.TownInt => 'TownInt',
      _i16.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _i17.ServerOnlyChangedIdFieldClass => 'ServerOnlyChangedIdFieldClass',
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
      _i70.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i71.NonTableParentClass => 'NonTableParentClass',
      _i72.ModifiedColumnName => 'ModifiedColumnName',
      _i73.Department => 'Department',
      _i74.Employee => 'Employee',
      _i75.Contractor => 'Contractor',
      _i76.Service => 'Service',
      _i77.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i78.SealedGrandChild => 'SealedGrandChild',
      _i78.SealedChild => 'SealedChild',
      _i78.SealedOtherChild => 'SealedOtherChild',
      _i79.CityWithLongTableName => 'CityWithLongTableName',
      _i80.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i81.PersonWithLongTableName => 'PersonWithLongTableName',
      _i82.MaxFieldName => 'MaxFieldName',
      _i83.LongImplicitIdField => 'LongImplicitIdField',
      _i84.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i85.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i86.UserNote => 'UserNote',
      _i87.UserNoteCollection => 'UserNoteCollection',
      _i88.UserNoteCollectionWithALongName => 'UserNoteCollectionWithALongName',
      _i89.UserNoteWithALongName => 'UserNoteWithALongName',
      _i90.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i91.City => 'City',
      _i92.Organization => 'Organization',
      _i93.Person => 'Person',
      _i94.Course => 'Course',
      _i95.Enrollment => 'Enrollment',
      _i96.Student => 'Student',
      _i97.Arena => 'Arena',
      _i98.Player => 'Player',
      _i99.Team => 'Team',
      _i100.Comment => 'Comment',
      _i101.Customer => 'Customer',
      _i102.Book => 'Book',
      _i103.Chapter => 'Chapter',
      _i104.Order => 'Order',
      _i105.Address => 'Address',
      _i106.Citizen => 'Citizen',
      _i107.Company => 'Company',
      _i108.Town => 'Town',
      _i109.Blocking => 'Blocking',
      _i110.Member => 'Member',
      _i111.Cat => 'Cat',
      _i112.Post => 'Post',
      _i113.ObjectFieldPersist => 'ObjectFieldPersist',
      _i114.ObjectFieldScopes => 'ObjectFieldScopes',
      _i115.ObjectWithBit => 'ObjectWithBit',
      _i116.ObjectWithByteData => 'ObjectWithByteData',
      _i117.ObjectWithDecimal => 'ObjectWithDecimal',
      _i118.ObjectWithDecimalPrecision => 'ObjectWithDecimalPrecision',
      _i119.ObjectWithDuration => 'ObjectWithDuration',
      _i120.ObjectWithEnum => 'ObjectWithEnum',
      _i121.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i122.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i123.ObjectWithIndex => 'ObjectWithIndex',
      _i124.ObjectWithMaps => 'ObjectWithMaps',
      _i125.ObjectWithObject => 'ObjectWithObject',
      _i126.ObjectWithParent => 'ObjectWithParent',
      _i127.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i128.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i129.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i130.ObjectWithUuid => 'ObjectWithUuid',
      _i131.ObjectWithVector => 'ObjectWithVector',
      _i132.RelatedUniqueData => 'RelatedUniqueData',
      _i133.ModelWithRequiredField => 'ModelWithRequiredField',
      _i134.SimpleData => 'SimpleData',
      _i135.SimpleDateTime => 'SimpleDateTime',
      _i136.TestEnum => 'TestEnum',
      _i137.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i138.TestEnumEnhanced => 'TestEnumEnhanced',
      _i139.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i140.TestEnumStringified => 'TestEnumStringified',
      _i141.Types => 'Types',
      _i142.UniqueData => 'UniqueData',
      _i143.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
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
      case _i3.CourseUuid():
        return 'CourseUuid';
      case _i4.EnrollmentInt():
        return 'EnrollmentInt';
      case _i5.StudentUuid():
        return 'StudentUuid';
      case _i6.ArenaUuid():
        return 'ArenaUuid';
      case _i7.PlayerUuid():
        return 'PlayerUuid';
      case _i8.TeamInt():
        return 'TeamInt';
      case _i9.CommentInt():
        return 'CommentInt';
      case _i10.CustomerInt():
        return 'CustomerInt';
      case _i11.OrderUuid():
        return 'OrderUuid';
      case _i12.AddressUuid():
        return 'AddressUuid';
      case _i13.CitizenInt():
        return 'CitizenInt';
      case _i14.CompanyUuid():
        return 'CompanyUuid';
      case _i15.TownInt():
        return 'TownInt';
      case _i16.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _i17.ServerOnlyChangedIdFieldClass():
        return 'ServerOnlyChangedIdFieldClass';
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
      case _i70.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i71.NonTableParentClass():
        return 'NonTableParentClass';
      case _i72.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i73.Department():
        return 'Department';
      case _i74.Employee():
        return 'Employee';
      case _i75.Contractor():
        return 'Contractor';
      case _i76.Service():
        return 'Service';
      case _i77.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i78.SealedGrandChild():
        return 'SealedGrandChild';
      case _i78.SealedChild():
        return 'SealedChild';
      case _i78.SealedOtherChild():
        return 'SealedOtherChild';
      case _i79.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i80.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i81.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i82.MaxFieldName():
        return 'MaxFieldName';
      case _i83.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i84.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i85.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i86.UserNote():
        return 'UserNote';
      case _i87.UserNoteCollection():
        return 'UserNoteCollection';
      case _i88.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i89.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i90.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i91.City():
        return 'City';
      case _i92.Organization():
        return 'Organization';
      case _i93.Person():
        return 'Person';
      case _i94.Course():
        return 'Course';
      case _i95.Enrollment():
        return 'Enrollment';
      case _i96.Student():
        return 'Student';
      case _i97.Arena():
        return 'Arena';
      case _i98.Player():
        return 'Player';
      case _i99.Team():
        return 'Team';
      case _i100.Comment():
        return 'Comment';
      case _i101.Customer():
        return 'Customer';
      case _i102.Book():
        return 'Book';
      case _i103.Chapter():
        return 'Chapter';
      case _i104.Order():
        return 'Order';
      case _i105.Address():
        return 'Address';
      case _i106.Citizen():
        return 'Citizen';
      case _i107.Company():
        return 'Company';
      case _i108.Town():
        return 'Town';
      case _i109.Blocking():
        return 'Blocking';
      case _i110.Member():
        return 'Member';
      case _i111.Cat():
        return 'Cat';
      case _i112.Post():
        return 'Post';
      case _i113.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i114.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i115.ObjectWithBit():
        return 'ObjectWithBit';
      case _i116.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i117.ObjectWithDecimal():
        return 'ObjectWithDecimal';
      case _i118.ObjectWithDecimalPrecision():
        return 'ObjectWithDecimalPrecision';
      case _i119.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i120.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i121.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i122.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i123.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i124.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i125.ObjectWithObject():
        return 'ObjectWithObject';
      case _i126.ObjectWithParent():
        return 'ObjectWithParent';
      case _i127.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i128.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i129.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i130.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i131.ObjectWithVector():
        return 'ObjectWithVector';
      case _i132.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i133.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i134.SimpleData():
        return 'SimpleData';
      case _i135.SimpleDateTime():
        return 'SimpleDateTime';
      case _i136.TestEnum():
        return 'TestEnum';
      case _i137.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i138.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i139.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i140.TestEnumStringified():
        return 'TestEnumStringified';
      case _i141.Types():
        return 'Types';
      case _i142.UniqueData():
        return 'UniqueData';
      case _i143.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod.$className';
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
      return deserialize<_i3.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i4.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i5.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i6.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i7.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i8.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i9.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_i10.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_i11.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_i12.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_i13.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i14.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_i15.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_i16.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'ServerOnlyChangedIdFieldClass') {
      return deserialize<_i17.ServerOnlyChangedIdFieldClass>(data['data']);
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
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i70.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i71.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i72.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i73.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i74.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i75.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i76.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i77.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i78.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i78.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i78.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i79.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i80.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i81.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i82.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i83.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i84.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i85.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i86.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i87.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i88.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i89.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i90.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i91.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i92.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i93.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i94.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i95.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i96.Student>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i97.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i98.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i99.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i100.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i101.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i102.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i103.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i104.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i105.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i106.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i107.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i108.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i109.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i110.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i111.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i112.Post>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i113.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i114.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i115.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i116.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithDecimal') {
      return deserialize<_i117.ObjectWithDecimal>(data['data']);
    }
    if (dataClassName == 'ObjectWithDecimalPrecision') {
      return deserialize<_i118.ObjectWithDecimalPrecision>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i119.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i120.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i121.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i122.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i123.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i124.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i125.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i126.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i127.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i128.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i129.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i130.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i131.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i132.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i133.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i134.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i135.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i136.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i137.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i138.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i139.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i140.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i141.Types>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i142.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i143.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName.startsWith('serverpod.')) {
      data['className'] = dataClassName.substring(10);
      return _i2.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var table = _i2.Protocol().getTableForType(t);
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i3.CourseUuid:
        return _i3.CourseUuid.t;
      case _i4.EnrollmentInt:
        return _i4.EnrollmentInt.t;
      case _i5.StudentUuid:
        return _i5.StudentUuid.t;
      case _i6.ArenaUuid:
        return _i6.ArenaUuid.t;
      case _i7.PlayerUuid:
        return _i7.PlayerUuid.t;
      case _i8.TeamInt:
        return _i8.TeamInt.t;
      case _i9.CommentInt:
        return _i9.CommentInt.t;
      case _i10.CustomerInt:
        return _i10.CustomerInt.t;
      case _i11.OrderUuid:
        return _i11.OrderUuid.t;
      case _i12.AddressUuid:
        return _i12.AddressUuid.t;
      case _i13.CitizenInt:
        return _i13.CitizenInt.t;
      case _i14.CompanyUuid:
        return _i14.CompanyUuid.t;
      case _i15.TownInt:
        return _i15.TownInt.t;
      case _i16.ChangedIdTypeSelf:
        return _i16.ChangedIdTypeSelf.t;
      case _i17.ServerOnlyChangedIdFieldClass:
        return _i17.ServerOnlyChangedIdFieldClass.t;
      case _i18.BigIntDefault:
        return _i18.BigIntDefault.t;
      case _i19.BigIntDefaultMix:
        return _i19.BigIntDefaultMix.t;
      case _i20.BigIntDefaultModel:
        return _i20.BigIntDefaultModel.t;
      case _i21.BigIntDefaultPersist:
        return _i21.BigIntDefaultPersist.t;
      case _i22.BoolDefault:
        return _i22.BoolDefault.t;
      case _i23.BoolDefaultMix:
        return _i23.BoolDefaultMix.t;
      case _i24.BoolDefaultModel:
        return _i24.BoolDefaultModel.t;
      case _i25.BoolDefaultPersist:
        return _i25.BoolDefaultPersist.t;
      case _i26.DateTimeDefault:
        return _i26.DateTimeDefault.t;
      case _i27.DateTimeDefaultMix:
        return _i27.DateTimeDefaultMix.t;
      case _i28.DateTimeDefaultModel:
        return _i28.DateTimeDefaultModel.t;
      case _i29.DateTimeDefaultPersist:
        return _i29.DateTimeDefaultPersist.t;
      case _i30.DecimalDefault:
        return _i30.DecimalDefault.t;
      case _i31.DecimalDefaultMix:
        return _i31.DecimalDefaultMix.t;
      case _i32.DecimalDefaultModel:
        return _i32.DecimalDefaultModel.t;
      case _i33.DecimalDefaultPersist:
        return _i33.DecimalDefaultPersist.t;
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
      case _i70.ChildClassExplicitColumn:
        return _i70.ChildClassExplicitColumn.t;
      case _i72.ModifiedColumnName:
        return _i72.ModifiedColumnName.t;
      case _i73.Department:
        return _i73.Department.t;
      case _i74.Employee:
        return _i74.Employee.t;
      case _i75.Contractor:
        return _i75.Contractor.t;
      case _i76.Service:
        return _i76.Service.t;
      case _i77.TableWithExplicitColumnName:
        return _i77.TableWithExplicitColumnName.t;
      case _i79.CityWithLongTableName:
        return _i79.CityWithLongTableName.t;
      case _i80.OrganizationWithLongTableName:
        return _i80.OrganizationWithLongTableName.t;
      case _i81.PersonWithLongTableName:
        return _i81.PersonWithLongTableName.t;
      case _i82.MaxFieldName:
        return _i82.MaxFieldName.t;
      case _i83.LongImplicitIdField:
        return _i83.LongImplicitIdField.t;
      case _i84.LongImplicitIdFieldCollection:
        return _i84.LongImplicitIdFieldCollection.t;
      case _i85.RelationToMultipleMaxFieldName:
        return _i85.RelationToMultipleMaxFieldName.t;
      case _i86.UserNote:
        return _i86.UserNote.t;
      case _i87.UserNoteCollection:
        return _i87.UserNoteCollection.t;
      case _i88.UserNoteCollectionWithALongName:
        return _i88.UserNoteCollectionWithALongName.t;
      case _i89.UserNoteWithALongName:
        return _i89.UserNoteWithALongName.t;
      case _i90.MultipleMaxFieldName:
        return _i90.MultipleMaxFieldName.t;
      case _i91.City:
        return _i91.City.t;
      case _i92.Organization:
        return _i92.Organization.t;
      case _i93.Person:
        return _i93.Person.t;
      case _i94.Course:
        return _i94.Course.t;
      case _i95.Enrollment:
        return _i95.Enrollment.t;
      case _i96.Student:
        return _i96.Student.t;
      case _i97.Arena:
        return _i97.Arena.t;
      case _i98.Player:
        return _i98.Player.t;
      case _i99.Team:
        return _i99.Team.t;
      case _i100.Comment:
        return _i100.Comment.t;
      case _i101.Customer:
        return _i101.Customer.t;
      case _i102.Book:
        return _i102.Book.t;
      case _i103.Chapter:
        return _i103.Chapter.t;
      case _i104.Order:
        return _i104.Order.t;
      case _i105.Address:
        return _i105.Address.t;
      case _i106.Citizen:
        return _i106.Citizen.t;
      case _i107.Company:
        return _i107.Company.t;
      case _i108.Town:
        return _i108.Town.t;
      case _i109.Blocking:
        return _i109.Blocking.t;
      case _i110.Member:
        return _i110.Member.t;
      case _i111.Cat:
        return _i111.Cat.t;
      case _i112.Post:
        return _i112.Post.t;
      case _i113.ObjectFieldPersist:
        return _i113.ObjectFieldPersist.t;
      case _i114.ObjectFieldScopes:
        return _i114.ObjectFieldScopes.t;
      case _i115.ObjectWithBit:
        return _i115.ObjectWithBit.t;
      case _i116.ObjectWithByteData:
        return _i116.ObjectWithByteData.t;
      case _i117.ObjectWithDecimal:
        return _i117.ObjectWithDecimal.t;
      case _i118.ObjectWithDecimalPrecision:
        return _i118.ObjectWithDecimalPrecision.t;
      case _i119.ObjectWithDuration:
        return _i119.ObjectWithDuration.t;
      case _i120.ObjectWithEnum:
        return _i120.ObjectWithEnum.t;
      case _i121.ObjectWithEnumEnhanced:
        return _i121.ObjectWithEnumEnhanced.t;
      case _i122.ObjectWithHalfVector:
        return _i122.ObjectWithHalfVector.t;
      case _i123.ObjectWithIndex:
        return _i123.ObjectWithIndex.t;
      case _i125.ObjectWithObject:
        return _i125.ObjectWithObject.t;
      case _i126.ObjectWithParent:
        return _i126.ObjectWithParent.t;
      case _i128.ObjectWithSelfParent:
        return _i128.ObjectWithSelfParent.t;
      case _i129.ObjectWithSparseVector:
        return _i129.ObjectWithSparseVector.t;
      case _i130.ObjectWithUuid:
        return _i130.ObjectWithUuid.t;
      case _i131.ObjectWithVector:
        return _i131.ObjectWithVector.t;
      case _i132.RelatedUniqueData:
        return _i132.RelatedUniqueData.t;
      case _i133.ModelWithRequiredField:
        return _i133.ModelWithRequiredField.t;
      case _i134.SimpleData:
        return _i134.SimpleData.t;
      case _i135.SimpleDateTime:
        return _i135.SimpleDateTime.t;
      case _i141.Types:
        return _i141.Types.t;
      case _i142.UniqueData:
        return _i142.UniqueData.t;
      case _i143.UniqueDataWithNonPersist:
        return _i143.UniqueDataWithNonPersist.t;
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
      return _i2.Protocol().mapRecordToJson(record);
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
