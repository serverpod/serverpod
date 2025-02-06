/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: implementation_imports
// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: public_member_api_docs
// ignore_for_file: type_literal_in_constant_pattern
// ignore_for_file: use_super_parameters

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i4;
import 'by_index_enum_with_name_value.dart' as _i5;
import 'by_name_enum_with_name_value.dart' as _i6;
import 'defaults/bigint/bigint_default.dart' as _i7;
import 'defaults/bigint/bigint_default_mix.dart' as _i8;
import 'defaults/bigint/bigint_default_model.dart' as _i9;
import 'defaults/bigint/bigint_default_persist.dart' as _i10;
import 'defaults/boolean/bool_default.dart' as _i11;
import 'defaults/boolean/bool_default_mix.dart' as _i12;
import 'defaults/boolean/bool_default_model.dart' as _i13;
import 'defaults/boolean/bool_default_persist.dart' as _i14;
import 'defaults/datetime/datetime_default.dart' as _i15;
import 'defaults/datetime/datetime_default_mix.dart' as _i16;
import 'defaults/datetime/datetime_default_model.dart' as _i17;
import 'defaults/datetime/datetime_default_persist.dart' as _i18;
import 'defaults/double/double_default.dart' as _i19;
import 'defaults/double/double_default_mix.dart' as _i20;
import 'defaults/double/double_default_model.dart' as _i21;
import 'defaults/double/double_default_persist.dart' as _i22;
import 'defaults/duration/duration_default.dart' as _i23;
import 'defaults/duration/duration_default_mix.dart' as _i24;
import 'defaults/duration/duration_default_model.dart' as _i25;
import 'defaults/duration/duration_default_persist.dart' as _i26;
import 'defaults/enum/enum_default.dart' as _i27;
import 'defaults/enum/enum_default_mix.dart' as _i28;
import 'defaults/enum/enum_default_model.dart' as _i29;
import 'defaults/enum/enum_default_persist.dart' as _i30;
import 'defaults/enum/enums/by_index_enum.dart' as _i31;
import 'defaults/enum/enums/by_name_enum.dart' as _i32;
import 'defaults/exception/default_exception.dart' as _i33;
import 'defaults/integer/int_default.dart' as _i34;
import 'defaults/integer/int_default_mix.dart' as _i35;
import 'defaults/integer/int_default_model.dart' as _i36;
import 'defaults/integer/int_default_persist.dart' as _i37;
import 'defaults/string/string_default.dart' as _i38;
import 'defaults/string/string_default_mix.dart' as _i39;
import 'defaults/string/string_default_model.dart' as _i40;
import 'defaults/string/string_default_persist.dart' as _i41;
import 'defaults/uuid/uuid_default.dart' as _i42;
import 'defaults/uuid/uuid_default_mix.dart' as _i43;
import 'defaults/uuid/uuid_default_model.dart' as _i44;
import 'defaults/uuid/uuid_default_persist.dart' as _i45;
import 'empty_model/empty_model.dart' as _i46;
import 'empty_model/empty_model_relation_item.dart' as _i47;
import 'empty_model/empty_model_with_table.dart' as _i48;
import 'empty_model/relation_empy_model.dart' as _i49;
import 'exception_with_data.dart' as _i50;
import 'inheritance/child_class.dart' as _i51;
import 'inheritance/child_with_default.dart' as _i52;
import 'inheritance/grandparent_class.dart' as _i53;
import 'inheritance/parent_class.dart' as _i54;
import 'inheritance/parent_with_default.dart' as _i55;
import 'inheritance/sealed_parent.dart' as _i56;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i57;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i58;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i59;
import 'long_identifiers/max_field_name.dart' as _i60;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i61;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i62;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i63;
import 'long_identifiers/models_with_relations/user_note.dart' as _i64;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i65;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i66;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i67;
import 'long_identifiers/multiple_max_field_name.dart' as _i68;
import 'models_with_list_relations/city.dart' as _i69;
import 'models_with_list_relations/organization.dart' as _i70;
import 'models_with_list_relations/person.dart' as _i71;
import 'models_with_relations/many_to_many/course.dart' as _i72;
import 'models_with_relations/many_to_many/enrollment.dart' as _i73;
import 'models_with_relations/many_to_many/student.dart' as _i74;
import 'models_with_relations/module/object_user.dart' as _i75;
import 'models_with_relations/module/parent_user.dart' as _i76;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i77;
import 'models_with_relations/nested_one_to_many/player.dart' as _i78;
import 'models_with_relations/nested_one_to_many/team.dart' as _i79;
import 'models_with_relations/one_to_many/comment.dart' as _i80;
import 'models_with_relations/one_to_many/customer.dart' as _i81;
import 'models_with_relations/one_to_many/order.dart' as _i82;
import 'models_with_relations/one_to_one/address.dart' as _i83;
import 'models_with_relations/one_to_one/citizen.dart' as _i84;
import 'models_with_relations/one_to_one/company.dart' as _i85;
import 'models_with_relations/one_to_one/town.dart' as _i86;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i87;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i88;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i89;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i90;
import 'module_datatype.dart' as _i91;
import 'nullability.dart' as _i92;
import 'object_field_persist.dart' as _i93;
import 'object_field_scopes.dart' as _i94;
import 'object_with_bytedata.dart' as _i95;
import 'object_with_custom_class.dart' as _i96;
import 'object_with_duration.dart' as _i97;
import 'object_with_enum.dart' as _i98;
import 'object_with_index.dart' as _i99;
import 'object_with_maps.dart' as _i100;
import 'object_with_object.dart' as _i101;
import 'object_with_parent.dart' as _i102;
import 'object_with_self_parent.dart' as _i103;
import 'object_with_uuid.dart' as _i104;
import 'related_unique_data.dart' as _i105;
import 'scopes/scope_none_fields.dart' as _i106;
import 'scopes/scope_server_only_field.dart' as _i107;
import 'scopes/scope_server_only_field_child.dart' as _i108;
import 'scopes/serverOnly/default_server_only_class.dart' as _i109;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i110;
import 'scopes/serverOnly/not_server_only_class.dart' as _i111;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i112;
import 'scopes/serverOnly/server_only_class.dart' as _i113;
import 'scopes/serverOnly/server_only_enum.dart' as _i114;
import 'scopes/server_only_class_field.dart' as _i115;
import 'simple_data.dart' as _i116;
import 'simple_data_list.dart' as _i117;
import 'simple_data_map.dart' as _i118;
import 'simple_data_object.dart' as _i119;
import 'simple_date_time.dart' as _i120;
import 'test_enum.dart' as _i121;
import 'test_enum_stringified.dart' as _i122;
import 'types.dart' as _i123;
import 'types_list.dart' as _i124;
import 'types_map.dart' as _i125;
import 'unique_data.dart' as _i126;
import 'my_feature/models/my_feature_model.dart' as _i127;
import 'dart:typed_data' as _i128;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i129;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i130;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i131;
export 'by_index_enum_with_name_value.dart';
export 'by_name_enum_with_name_value.dart';
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
export 'scopes/serverOnly/server_only_class.dart';
export 'scopes/serverOnly/server_only_enum.dart';
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'address_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'cat_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'company_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'empty_model_relation_item_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id'
          ],
          referenceTable: 'long_implicit_id_field_collection',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'long_implicit_id_field_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId'
          ],
          referenceTable: 'relation_to_multiple_max_field_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'multiple_max_field_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_parent_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'object_with_self_parent_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'organization_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'parent_user_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id'
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'player_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'post_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'related_unique_data_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'team_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
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
            )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'town_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
          name: 'aBigInt',
          columnType: _i2.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: false,
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
            '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId'
          ],
          referenceTable: 'user_note_collections',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId'
          ],
          referenceTable: 'user_note_collection_with_a_long_name',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i2.ForeignKeyAction.noAction,
          onDelete: _i2.ForeignKeyAction.noAction,
          matchType: null,
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'user_note_with_a_long_name_pkey',
          tableSpace: null,
          elements: [
            _i2.IndexElementDefinition(
              type: _i2.IndexElementDefinitionType.column,
              definition: 'id',
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
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
            )
          ],
          type: 'btree',
          isUnique: true,
          isPrimary: true,
        )
      ],
      managed: true,
    ),
    ..._i3.Protocol.targetTableDefinitions,
    ..._i4.Protocol.targetTableDefinitions,
    ..._i2.Protocol.targetTableDefinitions,
  ];

  @override
  T deserialize<T>(
    dynamic data, [
    Type? t,
  ]) {
    t ??= T;
    if (t == _i5.ByIndexEnumWithNameValue) {
      return _i5.ByIndexEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i6.ByNameEnumWithNameValue) {
      return _i6.ByNameEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i7.BigIntDefault) {
      return _i7.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i8.BigIntDefaultMix) {
      return _i8.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i9.BigIntDefaultModel) {
      return _i9.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i10.BigIntDefaultPersist) {
      return _i10.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i11.BoolDefault) {
      return _i11.BoolDefault.fromJson(data) as T;
    }
    if (t == _i12.BoolDefaultMix) {
      return _i12.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i13.BoolDefaultModel) {
      return _i13.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i14.BoolDefaultPersist) {
      return _i14.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i15.DateTimeDefault) {
      return _i15.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i16.DateTimeDefaultMix) {
      return _i16.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i17.DateTimeDefaultModel) {
      return _i17.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i18.DateTimeDefaultPersist) {
      return _i18.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i19.DoubleDefault) {
      return _i19.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i20.DoubleDefaultMix) {
      return _i20.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i21.DoubleDefaultModel) {
      return _i21.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i22.DoubleDefaultPersist) {
      return _i22.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i23.DurationDefault) {
      return _i23.DurationDefault.fromJson(data) as T;
    }
    if (t == _i24.DurationDefaultMix) {
      return _i24.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i25.DurationDefaultModel) {
      return _i25.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i26.DurationDefaultPersist) {
      return _i26.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i27.EnumDefault) {
      return _i27.EnumDefault.fromJson(data) as T;
    }
    if (t == _i28.EnumDefaultMix) {
      return _i28.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i29.EnumDefaultModel) {
      return _i29.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i30.EnumDefaultPersist) {
      return _i30.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i31.ByIndexEnum) {
      return _i31.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i32.ByNameEnum) {
      return _i32.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i33.DefaultException) {
      return _i33.DefaultException.fromJson(data) as T;
    }
    if (t == _i34.IntDefault) {
      return _i34.IntDefault.fromJson(data) as T;
    }
    if (t == _i35.IntDefaultMix) {
      return _i35.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i36.IntDefaultModel) {
      return _i36.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i37.IntDefaultPersist) {
      return _i37.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i38.StringDefault) {
      return _i38.StringDefault.fromJson(data) as T;
    }
    if (t == _i39.StringDefaultMix) {
      return _i39.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i40.StringDefaultModel) {
      return _i40.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i41.StringDefaultPersist) {
      return _i41.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i42.UuidDefault) {
      return _i42.UuidDefault.fromJson(data) as T;
    }
    if (t == _i43.UuidDefaultMix) {
      return _i43.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i44.UuidDefaultModel) {
      return _i44.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i45.UuidDefaultPersist) {
      return _i45.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i46.EmptyModel) {
      return _i46.EmptyModel.fromJson(data) as T;
    }
    if (t == _i47.EmptyModelRelationItem) {
      return _i47.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i48.EmptyModelWithTable) {
      return _i48.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i49.RelationEmptyModel) {
      return _i49.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i50.ExceptionWithData) {
      return _i50.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i51.ChildClass) {
      return _i51.ChildClass.fromJson(data) as T;
    }
    if (t == _i52.ChildWithDefault) {
      return _i52.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i53.GrandparentClass) {
      return _i53.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i54.ParentClass) {
      return _i54.ParentClass.fromJson(data) as T;
    }
    if (t == _i55.ParentWithDefault) {
      return _i55.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i56.SealedChild) {
      return _i56.SealedChild.fromJson(data) as T;
    }
    if (t == _i56.SealedGrandChild) {
      return _i56.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i56.SealedOtherChild) {
      return _i56.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i57.CityWithLongTableName) {
      return _i57.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i58.OrganizationWithLongTableName) {
      return _i58.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i59.PersonWithLongTableName) {
      return _i59.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i60.MaxFieldName) {
      return _i60.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i61.LongImplicitIdField) {
      return _i61.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i62.LongImplicitIdFieldCollection) {
      return _i62.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i63.RelationToMultipleMaxFieldName) {
      return _i63.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i64.UserNote) {
      return _i64.UserNote.fromJson(data) as T;
    }
    if (t == _i65.UserNoteCollection) {
      return _i65.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i66.UserNoteCollectionWithALongName) {
      return _i66.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i67.UserNoteWithALongName) {
      return _i67.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i68.MultipleMaxFieldName) {
      return _i68.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i69.City) {
      return _i69.City.fromJson(data) as T;
    }
    if (t == _i70.Organization) {
      return _i70.Organization.fromJson(data) as T;
    }
    if (t == _i71.Person) {
      return _i71.Person.fromJson(data) as T;
    }
    if (t == _i72.Course) {
      return _i72.Course.fromJson(data) as T;
    }
    if (t == _i73.Enrollment) {
      return _i73.Enrollment.fromJson(data) as T;
    }
    if (t == _i74.Student) {
      return _i74.Student.fromJson(data) as T;
    }
    if (t == _i75.ObjectUser) {
      return _i75.ObjectUser.fromJson(data) as T;
    }
    if (t == _i76.ParentUser) {
      return _i76.ParentUser.fromJson(data) as T;
    }
    if (t == _i77.Arena) {
      return _i77.Arena.fromJson(data) as T;
    }
    if (t == _i78.Player) {
      return _i78.Player.fromJson(data) as T;
    }
    if (t == _i79.Team) {
      return _i79.Team.fromJson(data) as T;
    }
    if (t == _i80.Comment) {
      return _i80.Comment.fromJson(data) as T;
    }
    if (t == _i81.Customer) {
      return _i81.Customer.fromJson(data) as T;
    }
    if (t == _i82.Order) {
      return _i82.Order.fromJson(data) as T;
    }
    if (t == _i83.Address) {
      return _i83.Address.fromJson(data) as T;
    }
    if (t == _i84.Citizen) {
      return _i84.Citizen.fromJson(data) as T;
    }
    if (t == _i85.Company) {
      return _i85.Company.fromJson(data) as T;
    }
    if (t == _i86.Town) {
      return _i86.Town.fromJson(data) as T;
    }
    if (t == _i87.Blocking) {
      return _i87.Blocking.fromJson(data) as T;
    }
    if (t == _i88.Member) {
      return _i88.Member.fromJson(data) as T;
    }
    if (t == _i89.Cat) {
      return _i89.Cat.fromJson(data) as T;
    }
    if (t == _i90.Post) {
      return _i90.Post.fromJson(data) as T;
    }
    if (t == _i91.ModuleDatatype) {
      return _i91.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i92.Nullability) {
      return _i92.Nullability.fromJson(data) as T;
    }
    if (t == _i93.ObjectFieldPersist) {
      return _i93.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i94.ObjectFieldScopes) {
      return _i94.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i95.ObjectWithByteData) {
      return _i95.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i96.ObjectWithCustomClass) {
      return _i96.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i97.ObjectWithDuration) {
      return _i97.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i98.ObjectWithEnum) {
      return _i98.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i99.ObjectWithIndex) {
      return _i99.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i100.ObjectWithMaps) {
      return _i100.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i101.ObjectWithObject) {
      return _i101.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i102.ObjectWithParent) {
      return _i102.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i103.ObjectWithSelfParent) {
      return _i103.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i104.ObjectWithUuid) {
      return _i104.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i105.RelatedUniqueData) {
      return _i105.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i106.ScopeNoneFields) {
      return _i106.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i107.ScopeServerOnlyField) {
      return _i107.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i108.ScopeServerOnlyFieldChild) {
      return _i108.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i109.DefaultServerOnlyClass) {
      return _i109.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i110.DefaultServerOnlyEnum) {
      return _i110.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i111.NotServerOnlyClass) {
      return _i111.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i112.NotServerOnlyEnum) {
      return _i112.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i113.ServerOnlyClass) {
      return _i113.ServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i114.ServerOnlyEnum) {
      return _i114.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i115.ServerOnlyClassField) {
      return _i115.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i116.SimpleData) {
      return _i116.SimpleData.fromJson(data) as T;
    }
    if (t == _i117.SimpleDataList) {
      return _i117.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i118.SimpleDataMap) {
      return _i118.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i119.SimpleDataObject) {
      return _i119.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i120.SimpleDateTime) {
      return _i120.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i121.TestEnum) {
      return _i121.TestEnum.fromJson(data) as T;
    }
    if (t == _i122.TestEnumStringified) {
      return _i122.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i123.Types) {
      return _i123.Types.fromJson(data) as T;
    }
    if (t == _i124.TypesList) {
      return _i124.TypesList.fromJson(data) as T;
    }
    if (t == _i125.TypesMap) {
      return _i125.TypesMap.fromJson(data) as T;
    }
    if (t == _i126.UniqueData) {
      return _i126.UniqueData.fromJson(data) as T;
    }
    if (t == _i127.MyFeatureModel) {
      return _i127.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ByIndexEnumWithNameValue?>()) {
      return (data != null ? _i5.ByIndexEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i6.ByNameEnumWithNameValue?>()) {
      return (data != null ? _i6.ByNameEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.BigIntDefault?>()) {
      return (data != null ? _i7.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.BigIntDefaultMix?>()) {
      return (data != null ? _i8.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.BigIntDefaultModel?>()) {
      return (data != null ? _i9.BigIntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.BigIntDefaultPersist?>()) {
      return (data != null ? _i10.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.BoolDefault?>()) {
      return (data != null ? _i11.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i12.BoolDefaultMix?>()) {
      return (data != null ? _i12.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i13.BoolDefaultModel?>()) {
      return (data != null ? _i13.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.BoolDefaultPersist?>()) {
      return (data != null ? _i14.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.DateTimeDefault?>()) {
      return (data != null ? _i15.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i16.DateTimeDefaultMix?>()) {
      return (data != null ? _i16.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.DateTimeDefaultModel?>()) {
      return (data != null ? _i17.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.DateTimeDefaultPersist?>()) {
      return (data != null ? _i18.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i19.DoubleDefault?>()) {
      return (data != null ? _i19.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.DoubleDefaultMix?>()) {
      return (data != null ? _i20.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.DoubleDefaultModel?>()) {
      return (data != null ? _i21.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.DoubleDefaultPersist?>()) {
      return (data != null ? _i22.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.DurationDefault?>()) {
      return (data != null ? _i23.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.DurationDefaultMix?>()) {
      return (data != null ? _i24.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i25.DurationDefaultModel?>()) {
      return (data != null ? _i25.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i26.DurationDefaultPersist?>()) {
      return (data != null ? _i26.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.EnumDefault?>()) {
      return (data != null ? _i27.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.EnumDefaultMix?>()) {
      return (data != null ? _i28.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.EnumDefaultModel?>()) {
      return (data != null ? _i29.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.EnumDefaultPersist?>()) {
      return (data != null ? _i30.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.ByIndexEnum?>()) {
      return (data != null ? _i31.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.ByNameEnum?>()) {
      return (data != null ? _i32.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.DefaultException?>()) {
      return (data != null ? _i33.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.IntDefault?>()) {
      return (data != null ? _i34.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.IntDefaultMix?>()) {
      return (data != null ? _i35.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.IntDefaultModel?>()) {
      return (data != null ? _i36.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.IntDefaultPersist?>()) {
      return (data != null ? _i37.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.StringDefault?>()) {
      return (data != null ? _i38.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.StringDefaultMix?>()) {
      return (data != null ? _i39.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.StringDefaultModel?>()) {
      return (data != null ? _i40.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i41.StringDefaultPersist?>()) {
      return (data != null ? _i41.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i42.UuidDefault?>()) {
      return (data != null ? _i42.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.UuidDefaultMix?>()) {
      return (data != null ? _i43.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.UuidDefaultModel?>()) {
      return (data != null ? _i44.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.UuidDefaultPersist?>()) {
      return (data != null ? _i45.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i46.EmptyModel?>()) {
      return (data != null ? _i46.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.EmptyModelRelationItem?>()) {
      return (data != null ? _i47.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i48.EmptyModelWithTable?>()) {
      return (data != null ? _i48.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i49.RelationEmptyModel?>()) {
      return (data != null ? _i49.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i50.ExceptionWithData?>()) {
      return (data != null ? _i50.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.ChildClass?>()) {
      return (data != null ? _i51.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.ChildWithDefault?>()) {
      return (data != null ? _i52.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.GrandparentClass?>()) {
      return (data != null ? _i53.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.ParentClass?>()) {
      return (data != null ? _i54.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i55.ParentWithDefault?>()) {
      return (data != null ? _i55.ParentWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.SealedChild?>()) {
      return (data != null ? _i56.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.SealedGrandChild?>()) {
      return (data != null ? _i56.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i56.SealedOtherChild?>()) {
      return (data != null ? _i56.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.CityWithLongTableName?>()) {
      return (data != null ? _i57.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i58.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i59.PersonWithLongTableName?>()) {
      return (data != null ? _i59.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i60.MaxFieldName?>()) {
      return (data != null ? _i60.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.LongImplicitIdField?>()) {
      return (data != null ? _i61.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i62.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i63.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i63.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i64.UserNote?>()) {
      return (data != null ? _i64.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.UserNoteCollection?>()) {
      return (data != null ? _i65.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i66.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i67.UserNoteWithALongName?>()) {
      return (data != null ? _i67.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i68.MultipleMaxFieldName?>()) {
      return (data != null ? _i68.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.City?>()) {
      return (data != null ? _i69.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.Organization?>()) {
      return (data != null ? _i70.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.Person?>()) {
      return (data != null ? _i71.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.Course?>()) {
      return (data != null ? _i72.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.Enrollment?>()) {
      return (data != null ? _i73.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.Student?>()) {
      return (data != null ? _i74.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.ObjectUser?>()) {
      return (data != null ? _i75.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.ParentUser?>()) {
      return (data != null ? _i76.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i77.Arena?>()) {
      return (data != null ? _i77.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i78.Player?>()) {
      return (data != null ? _i78.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i79.Team?>()) {
      return (data != null ? _i79.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.Comment?>()) {
      return (data != null ? _i80.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i81.Customer?>()) {
      return (data != null ? _i81.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i82.Order?>()) {
      return (data != null ? _i82.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i83.Address?>()) {
      return (data != null ? _i83.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i84.Citizen?>()) {
      return (data != null ? _i84.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i85.Company?>()) {
      return (data != null ? _i85.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i86.Town?>()) {
      return (data != null ? _i86.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.Blocking?>()) {
      return (data != null ? _i87.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.Member?>()) {
      return (data != null ? _i88.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.Cat?>()) {
      return (data != null ? _i89.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.Post?>()) {
      return (data != null ? _i90.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.ModuleDatatype?>()) {
      return (data != null ? _i91.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.Nullability?>()) {
      return (data != null ? _i92.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.ObjectFieldPersist?>()) {
      return (data != null ? _i93.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i94.ObjectFieldScopes?>()) {
      return (data != null ? _i94.ObjectFieldScopes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.ObjectWithByteData?>()) {
      return (data != null ? _i95.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i96.ObjectWithCustomClass?>()) {
      return (data != null ? _i96.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i97.ObjectWithDuration?>()) {
      return (data != null ? _i97.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i98.ObjectWithEnum?>()) {
      return (data != null ? _i98.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.ObjectWithIndex?>()) {
      return (data != null ? _i99.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.ObjectWithMaps?>()) {
      return (data != null ? _i100.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.ObjectWithObject?>()) {
      return (data != null ? _i101.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.ObjectWithParent?>()) {
      return (data != null ? _i102.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.ObjectWithSelfParent?>()) {
      return (data != null ? _i103.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i104.ObjectWithUuid?>()) {
      return (data != null ? _i104.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.RelatedUniqueData?>()) {
      return (data != null ? _i105.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i106.ScopeNoneFields?>()) {
      return (data != null ? _i106.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i107.ScopeServerOnlyField?>()) {
      return (data != null ? _i107.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i108.ScopeServerOnlyFieldChild?>()) {
      return (data != null
          ? _i108.ScopeServerOnlyFieldChild.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i109.DefaultServerOnlyClass?>()) {
      return (data != null ? _i109.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i110.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i110.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i111.NotServerOnlyClass?>()) {
      return (data != null ? _i111.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i112.NotServerOnlyEnum?>()) {
      return (data != null ? _i112.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i113.ServerOnlyClass?>()) {
      return (data != null ? _i113.ServerOnlyClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.ServerOnlyEnum?>()) {
      return (data != null ? _i114.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i115.ServerOnlyClassField?>()) {
      return (data != null ? _i115.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i116.SimpleData?>()) {
      return (data != null ? _i116.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.SimpleDataList?>()) {
      return (data != null ? _i117.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i118.SimpleDataMap?>()) {
      return (data != null ? _i118.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i119.SimpleDataObject?>()) {
      return (data != null ? _i119.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i120.SimpleDateTime?>()) {
      return (data != null ? _i120.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.TestEnum?>()) {
      return (data != null ? _i121.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i122.TestEnumStringified?>()) {
      return (data != null ? _i122.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i123.Types?>()) {
      return (data != null ? _i123.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i124.TypesList?>()) {
      return (data != null ? _i124.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i125.TypesMap?>()) {
      return (data != null ? _i125.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i126.UniqueData?>()) {
      return (data != null ? _i126.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i127.MyFeatureModel?>()) {
      return (data != null ? _i127.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i47.EmptyModelRelationItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i47.EmptyModelRelationItem>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i59.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i59.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i58.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i58.OrganizationWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i59.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i59.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i61.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i61.LongImplicitIdField>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i68.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i68.MultipleMaxFieldName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i64.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i64.UserNote>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i67.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i67.UserNoteWithALongName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i71.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i71.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i70.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i70.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i71.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i71.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i78.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i78.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i82.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i82.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i80.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i80.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i87.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i87.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i87.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i87.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i89.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i89.Cat>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i4.ModuleClass>) {
      return (data as List).map((e) => deserialize<_i4.ModuleClass>(e)).toList()
          as dynamic;
    }
    if (t == Map<String, _i4.ModuleClass>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i4.ModuleClass>(v)))
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
    if (t == List<_i116.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i116.SimpleData>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i116.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i116.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i116.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i116.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i116.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i116.SimpleData?>(e))
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
    if (t == List<_i128.ByteData>) {
      return (data as List).map((e) => deserialize<_i128.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i128.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i128.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i128.ByteData?>) {
      return (data as List).map((e) => deserialize<_i128.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i128.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i128.ByteData?>(e)).toList()
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
    if (t == _i129.CustomClassWithoutProtocolSerialization) {
      return _i129.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i129.CustomClassWithProtocolSerialization) {
      return _i129.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i129.CustomClassWithProtocolSerializationMethod) {
      return _i129.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i121.TestEnum>) {
      return (data as List).map((e) => deserialize<_i121.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i121.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i121.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i121.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i121.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i116.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i116.SimpleData>(v))) as dynamic;
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
    if (t == Map<String, _i128.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i128.ByteData>(v)))
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
    if (t == Map<String, _i116.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i116.SimpleData?>(v)))
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
    if (t == Map<String, _i128.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i128.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i116.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i116.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i116.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i116.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<List<_i116.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i116.SimpleData>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i116.SimpleData>>?>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<List<List<Map<int, _i116.SimpleData>>?>>(v)))
          : null) as dynamic;
    }
    if (t == List<List<Map<int, _i116.SimpleData>>?>) {
      return (data as List)
          .map((e) => deserialize<List<Map<int, _i116.SimpleData>>?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<Map<int, _i116.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<int, _i116.SimpleData>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<int, _i116.SimpleData>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<int>(e['k']), deserialize<_i116.SimpleData>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<int, _i116.SimpleData>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<Map<int, _i116.SimpleData>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i113.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i113.ServerOnlyClass>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i113.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i113.ServerOnlyClass>(v)))
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
    if (t == _i1.getType<List<_i128.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i128.ByteData>(e)).toList()
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
    if (t == _i1.getType<List<BigInt>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<BigInt>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i121.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i121.TestEnum>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i122.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i122.TestEnumStringified>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i123.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i123.Types>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Map<String, _i123.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i123.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, _i123.Types>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i123.Types>(v)))
          as dynamic;
    }
    if (t == _i1.getType<List<List<_i123.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i123.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i123.Types>) {
      return (data as List).map((e) => deserialize<_i123.Types>(e)).toList()
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
    if (t == _i1.getType<Map<_i128.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i128.ByteData>(e['k']),
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
    if (t == _i1.getType<Map<BigInt, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<BigInt>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i121.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i121.TestEnum>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i122.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i122.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i123.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i123.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Map<_i123.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i123.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == Map<_i123.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i123.Types>(e['k']), deserialize<String>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<List<_i123.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i123.Types>>(e['k']),
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
    if (t == _i1.getType<Map<String, _i128.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i128.ByteData>(v)))
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
    if (t == _i1.getType<Map<String, BigInt>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<BigInt>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i121.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i121.TestEnum>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i122.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<_i122.TestEnumStringified>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i123.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i123.Types>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<String, _i123.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i123.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, List<_i123.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i123.Types>>(v)))
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
    if (t == List<_i130.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i130.SimpleData>(e))
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
    if (t == List<_i128.ByteData>) {
      return (data as List).map((e) => deserialize<_i128.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i128.ByteData?>) {
      return (data as List).map((e) => deserialize<_i128.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i130.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i130.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i130.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i130.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i130.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i130.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i130.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i130.SimpleData?>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i130.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i130.SimpleData?>(e))
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
    if (t == Map<_i131.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i131.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i131.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i131.TestEnum>(v)))
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
    if (t == Map<String, _i128.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i128.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i128.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i128.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i130.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i130.SimpleData>(v))) as dynamic;
    }
    if (t == Map<String, _i130.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i130.SimpleData?>(v)))
          as dynamic;
    }
    if (t == _i1.getType<Map<String, _i130.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i130.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i130.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i130.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i130.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i130.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i130.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i130.SimpleData?>(v)))
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
    if (t == _i129.CustomClass) {
      return _i129.CustomClass.fromJson(data) as T;
    }
    if (t == _i129.CustomClass2) {
      return _i129.CustomClass2.fromJson(data) as T;
    }
    if (t == _i129.ProtocolCustomClass) {
      return _i129.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i129.ExternalCustomClass) {
      return _i129.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i129.FreezedCustomClass) {
      return _i129.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i129.CustomClass?>()) {
      return (data != null ? _i129.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.CustomClass2?>()) {
      return (data != null ? _i129.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
          ? _i129.CustomClassWithoutProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i129.CustomClassWithProtocolSerialization?>()) {
      return (data != null
          ? _i129.CustomClassWithProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i129.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
          ? _i129.CustomClassWithProtocolSerializationMethod.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i129.ProtocolCustomClass?>()) {
      return (data != null ? _i129.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i129.ExternalCustomClass?>()) {
      return (data != null ? _i129.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i129.FreezedCustomClass?>()) {
      return (data != null ? _i129.FreezedCustomClass.fromJson(data) : null)
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

  @override
  String? getClassNameForObject(Object? data) {
    String? className = super.getClassNameForObject(data);
    if (className != null) return className;
    if (data is _i129.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i129.CustomClass2) {
      return 'CustomClass2';
    }
    if (data is _i129.CustomClassWithoutProtocolSerialization) {
      return 'CustomClassWithoutProtocolSerialization';
    }
    if (data is _i129.CustomClassWithProtocolSerialization) {
      return 'CustomClassWithProtocolSerialization';
    }
    if (data is _i129.CustomClassWithProtocolSerializationMethod) {
      return 'CustomClassWithProtocolSerializationMethod';
    }
    if (data is _i129.ProtocolCustomClass) {
      return 'ProtocolCustomClass';
    }
    if (data is _i129.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i129.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i5.ByIndexEnumWithNameValue) {
      return 'ByIndexEnumWithNameValue';
    }
    if (data is _i6.ByNameEnumWithNameValue) {
      return 'ByNameEnumWithNameValue';
    }
    if (data is _i7.BigIntDefault) {
      return 'BigIntDefault';
    }
    if (data is _i8.BigIntDefaultMix) {
      return 'BigIntDefaultMix';
    }
    if (data is _i9.BigIntDefaultModel) {
      return 'BigIntDefaultModel';
    }
    if (data is _i10.BigIntDefaultPersist) {
      return 'BigIntDefaultPersist';
    }
    if (data is _i11.BoolDefault) {
      return 'BoolDefault';
    }
    if (data is _i12.BoolDefaultMix) {
      return 'BoolDefaultMix';
    }
    if (data is _i13.BoolDefaultModel) {
      return 'BoolDefaultModel';
    }
    if (data is _i14.BoolDefaultPersist) {
      return 'BoolDefaultPersist';
    }
    if (data is _i15.DateTimeDefault) {
      return 'DateTimeDefault';
    }
    if (data is _i16.DateTimeDefaultMix) {
      return 'DateTimeDefaultMix';
    }
    if (data is _i17.DateTimeDefaultModel) {
      return 'DateTimeDefaultModel';
    }
    if (data is _i18.DateTimeDefaultPersist) {
      return 'DateTimeDefaultPersist';
    }
    if (data is _i19.DoubleDefault) {
      return 'DoubleDefault';
    }
    if (data is _i20.DoubleDefaultMix) {
      return 'DoubleDefaultMix';
    }
    if (data is _i21.DoubleDefaultModel) {
      return 'DoubleDefaultModel';
    }
    if (data is _i22.DoubleDefaultPersist) {
      return 'DoubleDefaultPersist';
    }
    if (data is _i23.DurationDefault) {
      return 'DurationDefault';
    }
    if (data is _i24.DurationDefaultMix) {
      return 'DurationDefaultMix';
    }
    if (data is _i25.DurationDefaultModel) {
      return 'DurationDefaultModel';
    }
    if (data is _i26.DurationDefaultPersist) {
      return 'DurationDefaultPersist';
    }
    if (data is _i27.EnumDefault) {
      return 'EnumDefault';
    }
    if (data is _i28.EnumDefaultMix) {
      return 'EnumDefaultMix';
    }
    if (data is _i29.EnumDefaultModel) {
      return 'EnumDefaultModel';
    }
    if (data is _i30.EnumDefaultPersist) {
      return 'EnumDefaultPersist';
    }
    if (data is _i31.ByIndexEnum) {
      return 'ByIndexEnum';
    }
    if (data is _i32.ByNameEnum) {
      return 'ByNameEnum';
    }
    if (data is _i33.DefaultException) {
      return 'DefaultException';
    }
    if (data is _i34.IntDefault) {
      return 'IntDefault';
    }
    if (data is _i35.IntDefaultMix) {
      return 'IntDefaultMix';
    }
    if (data is _i36.IntDefaultModel) {
      return 'IntDefaultModel';
    }
    if (data is _i37.IntDefaultPersist) {
      return 'IntDefaultPersist';
    }
    if (data is _i38.StringDefault) {
      return 'StringDefault';
    }
    if (data is _i39.StringDefaultMix) {
      return 'StringDefaultMix';
    }
    if (data is _i40.StringDefaultModel) {
      return 'StringDefaultModel';
    }
    if (data is _i41.StringDefaultPersist) {
      return 'StringDefaultPersist';
    }
    if (data is _i42.UuidDefault) {
      return 'UuidDefault';
    }
    if (data is _i43.UuidDefaultMix) {
      return 'UuidDefaultMix';
    }
    if (data is _i44.UuidDefaultModel) {
      return 'UuidDefaultModel';
    }
    if (data is _i45.UuidDefaultPersist) {
      return 'UuidDefaultPersist';
    }
    if (data is _i46.EmptyModel) {
      return 'EmptyModel';
    }
    if (data is _i47.EmptyModelRelationItem) {
      return 'EmptyModelRelationItem';
    }
    if (data is _i48.EmptyModelWithTable) {
      return 'EmptyModelWithTable';
    }
    if (data is _i49.RelationEmptyModel) {
      return 'RelationEmptyModel';
    }
    if (data is _i50.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i51.ChildClass) {
      return 'ChildClass';
    }
    if (data is _i52.ChildWithDefault) {
      return 'ChildWithDefault';
    }
    if (data is _i53.GrandparentClass) {
      return 'GrandparentClass';
    }
    if (data is _i54.ParentClass) {
      return 'ParentClass';
    }
    if (data is _i55.ParentWithDefault) {
      return 'ParentWithDefault';
    }
    if (data is _i56.SealedChild) {
      return 'SealedChild';
    }
    if (data is _i56.SealedGrandChild) {
      return 'SealedGrandChild';
    }
    if (data is _i56.SealedOtherChild) {
      return 'SealedOtherChild';
    }
    if (data is _i57.CityWithLongTableName) {
      return 'CityWithLongTableName';
    }
    if (data is _i58.OrganizationWithLongTableName) {
      return 'OrganizationWithLongTableName';
    }
    if (data is _i59.PersonWithLongTableName) {
      return 'PersonWithLongTableName';
    }
    if (data is _i60.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i61.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i62.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i63.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i64.UserNote) {
      return 'UserNote';
    }
    if (data is _i65.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i66.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i67.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i68.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i69.City) {
      return 'City';
    }
    if (data is _i70.Organization) {
      return 'Organization';
    }
    if (data is _i71.Person) {
      return 'Person';
    }
    if (data is _i72.Course) {
      return 'Course';
    }
    if (data is _i73.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i74.Student) {
      return 'Student';
    }
    if (data is _i75.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i76.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i77.Arena) {
      return 'Arena';
    }
    if (data is _i78.Player) {
      return 'Player';
    }
    if (data is _i79.Team) {
      return 'Team';
    }
    if (data is _i80.Comment) {
      return 'Comment';
    }
    if (data is _i81.Customer) {
      return 'Customer';
    }
    if (data is _i82.Order) {
      return 'Order';
    }
    if (data is _i83.Address) {
      return 'Address';
    }
    if (data is _i84.Citizen) {
      return 'Citizen';
    }
    if (data is _i85.Company) {
      return 'Company';
    }
    if (data is _i86.Town) {
      return 'Town';
    }
    if (data is _i87.Blocking) {
      return 'Blocking';
    }
    if (data is _i88.Member) {
      return 'Member';
    }
    if (data is _i89.Cat) {
      return 'Cat';
    }
    if (data is _i90.Post) {
      return 'Post';
    }
    if (data is _i91.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i92.Nullability) {
      return 'Nullability';
    }
    if (data is _i93.ObjectFieldPersist) {
      return 'ObjectFieldPersist';
    }
    if (data is _i94.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i95.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i96.ObjectWithCustomClass) {
      return 'ObjectWithCustomClass';
    }
    if (data is _i97.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i98.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i99.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i100.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i101.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i102.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i103.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i104.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i105.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i106.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i107.ScopeServerOnlyField) {
      return 'ScopeServerOnlyField';
    }
    if (data is _i108.ScopeServerOnlyFieldChild) {
      return 'ScopeServerOnlyFieldChild';
    }
    if (data is _i109.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i110.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i111.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i112.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i113.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i114.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i115.ServerOnlyClassField) {
      return 'ServerOnlyClassField';
    }
    if (data is _i116.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i117.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i118.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i119.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i120.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i121.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i122.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i123.Types) {
      return 'Types';
    }
    if (data is _i124.TypesList) {
      return 'TypesList';
    }
    if (data is _i125.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i126.UniqueData) {
      return 'UniqueData';
    }
    if (data is _i127.MyFeatureModel) {
      return 'MyFeatureModel';
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
    return null;
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    var dataClassName = data['className'];
    if (dataClassName is! String) {
      return super.deserializeByClassName(data);
    }
    if (dataClassName == 'CustomClass') {
      return deserialize<_i129.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i129.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i129.CustomClassWithoutProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i129.CustomClassWithProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i129.CustomClassWithProtocolSerializationMethod>(
          data['data']);
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i129.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i129.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i129.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_i5.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_i6.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i7.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i8.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i9.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i10.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i11.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i12.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i13.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i14.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i15.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i16.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i17.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i18.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i19.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i20.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i21.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i22.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i23.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i24.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i25.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i26.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i27.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i28.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i29.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i30.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i31.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i32.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i33.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i34.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i35.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i36.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i37.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i38.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i39.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i40.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i41.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i42.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i43.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i44.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i45.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i46.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i47.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i48.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i49.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i50.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i51.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i52.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i53.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i54.ParentClass>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i55.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i56.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i56.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i56.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i57.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i58.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i59.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i60.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i61.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i62.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i63.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i64.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i65.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i66.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i67.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i68.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i69.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i70.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i71.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i72.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i73.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i74.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i75.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i76.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i77.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i78.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i79.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i80.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i81.Customer>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i82.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i83.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i84.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i85.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i86.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i87.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i88.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i89.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i90.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i91.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i92.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i93.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i94.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i95.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i96.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i97.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i98.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i99.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i100.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i101.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i102.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i103.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i104.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i105.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i106.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i107.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i108.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i109.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i110.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i111.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i112.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClass') {
      return deserialize<_i113.ServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyEnum') {
      return deserialize<_i114.ServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i115.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i116.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i117.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i118.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i119.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i120.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i121.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i122.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i123.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i124.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i125.TypesMap>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i126.UniqueData>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i127.MyFeatureModel>(data['data']);
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
      case _i7.BigIntDefault:
        return _i7.BigIntDefault.t;
      case _i8.BigIntDefaultMix:
        return _i8.BigIntDefaultMix.t;
      case _i9.BigIntDefaultModel:
        return _i9.BigIntDefaultModel.t;
      case _i10.BigIntDefaultPersist:
        return _i10.BigIntDefaultPersist.t;
      case _i11.BoolDefault:
        return _i11.BoolDefault.t;
      case _i12.BoolDefaultMix:
        return _i12.BoolDefaultMix.t;
      case _i13.BoolDefaultModel:
        return _i13.BoolDefaultModel.t;
      case _i14.BoolDefaultPersist:
        return _i14.BoolDefaultPersist.t;
      case _i15.DateTimeDefault:
        return _i15.DateTimeDefault.t;
      case _i16.DateTimeDefaultMix:
        return _i16.DateTimeDefaultMix.t;
      case _i17.DateTimeDefaultModel:
        return _i17.DateTimeDefaultModel.t;
      case _i18.DateTimeDefaultPersist:
        return _i18.DateTimeDefaultPersist.t;
      case _i19.DoubleDefault:
        return _i19.DoubleDefault.t;
      case _i20.DoubleDefaultMix:
        return _i20.DoubleDefaultMix.t;
      case _i21.DoubleDefaultModel:
        return _i21.DoubleDefaultModel.t;
      case _i22.DoubleDefaultPersist:
        return _i22.DoubleDefaultPersist.t;
      case _i23.DurationDefault:
        return _i23.DurationDefault.t;
      case _i24.DurationDefaultMix:
        return _i24.DurationDefaultMix.t;
      case _i25.DurationDefaultModel:
        return _i25.DurationDefaultModel.t;
      case _i26.DurationDefaultPersist:
        return _i26.DurationDefaultPersist.t;
      case _i27.EnumDefault:
        return _i27.EnumDefault.t;
      case _i28.EnumDefaultMix:
        return _i28.EnumDefaultMix.t;
      case _i29.EnumDefaultModel:
        return _i29.EnumDefaultModel.t;
      case _i30.EnumDefaultPersist:
        return _i30.EnumDefaultPersist.t;
      case _i34.IntDefault:
        return _i34.IntDefault.t;
      case _i35.IntDefaultMix:
        return _i35.IntDefaultMix.t;
      case _i36.IntDefaultModel:
        return _i36.IntDefaultModel.t;
      case _i37.IntDefaultPersist:
        return _i37.IntDefaultPersist.t;
      case _i38.StringDefault:
        return _i38.StringDefault.t;
      case _i39.StringDefaultMix:
        return _i39.StringDefaultMix.t;
      case _i40.StringDefaultModel:
        return _i40.StringDefaultModel.t;
      case _i41.StringDefaultPersist:
        return _i41.StringDefaultPersist.t;
      case _i42.UuidDefault:
        return _i42.UuidDefault.t;
      case _i43.UuidDefaultMix:
        return _i43.UuidDefaultMix.t;
      case _i44.UuidDefaultModel:
        return _i44.UuidDefaultModel.t;
      case _i45.UuidDefaultPersist:
        return _i45.UuidDefaultPersist.t;
      case _i47.EmptyModelRelationItem:
        return _i47.EmptyModelRelationItem.t;
      case _i48.EmptyModelWithTable:
        return _i48.EmptyModelWithTable.t;
      case _i49.RelationEmptyModel:
        return _i49.RelationEmptyModel.t;
      case _i54.ParentClass:
        return _i54.ParentClass.t;
      case _i57.CityWithLongTableName:
        return _i57.CityWithLongTableName.t;
      case _i58.OrganizationWithLongTableName:
        return _i58.OrganizationWithLongTableName.t;
      case _i59.PersonWithLongTableName:
        return _i59.PersonWithLongTableName.t;
      case _i60.MaxFieldName:
        return _i60.MaxFieldName.t;
      case _i61.LongImplicitIdField:
        return _i61.LongImplicitIdField.t;
      case _i62.LongImplicitIdFieldCollection:
        return _i62.LongImplicitIdFieldCollection.t;
      case _i63.RelationToMultipleMaxFieldName:
        return _i63.RelationToMultipleMaxFieldName.t;
      case _i64.UserNote:
        return _i64.UserNote.t;
      case _i65.UserNoteCollection:
        return _i65.UserNoteCollection.t;
      case _i66.UserNoteCollectionWithALongName:
        return _i66.UserNoteCollectionWithALongName.t;
      case _i67.UserNoteWithALongName:
        return _i67.UserNoteWithALongName.t;
      case _i68.MultipleMaxFieldName:
        return _i68.MultipleMaxFieldName.t;
      case _i69.City:
        return _i69.City.t;
      case _i70.Organization:
        return _i70.Organization.t;
      case _i71.Person:
        return _i71.Person.t;
      case _i72.Course:
        return _i72.Course.t;
      case _i73.Enrollment:
        return _i73.Enrollment.t;
      case _i74.Student:
        return _i74.Student.t;
      case _i75.ObjectUser:
        return _i75.ObjectUser.t;
      case _i76.ParentUser:
        return _i76.ParentUser.t;
      case _i77.Arena:
        return _i77.Arena.t;
      case _i78.Player:
        return _i78.Player.t;
      case _i79.Team:
        return _i79.Team.t;
      case _i80.Comment:
        return _i80.Comment.t;
      case _i81.Customer:
        return _i81.Customer.t;
      case _i82.Order:
        return _i82.Order.t;
      case _i83.Address:
        return _i83.Address.t;
      case _i84.Citizen:
        return _i84.Citizen.t;
      case _i85.Company:
        return _i85.Company.t;
      case _i86.Town:
        return _i86.Town.t;
      case _i87.Blocking:
        return _i87.Blocking.t;
      case _i88.Member:
        return _i88.Member.t;
      case _i89.Cat:
        return _i89.Cat.t;
      case _i90.Post:
        return _i90.Post.t;
      case _i93.ObjectFieldPersist:
        return _i93.ObjectFieldPersist.t;
      case _i94.ObjectFieldScopes:
        return _i94.ObjectFieldScopes.t;
      case _i95.ObjectWithByteData:
        return _i95.ObjectWithByteData.t;
      case _i97.ObjectWithDuration:
        return _i97.ObjectWithDuration.t;
      case _i98.ObjectWithEnum:
        return _i98.ObjectWithEnum.t;
      case _i99.ObjectWithIndex:
        return _i99.ObjectWithIndex.t;
      case _i101.ObjectWithObject:
        return _i101.ObjectWithObject.t;
      case _i102.ObjectWithParent:
        return _i102.ObjectWithParent.t;
      case _i103.ObjectWithSelfParent:
        return _i103.ObjectWithSelfParent.t;
      case _i104.ObjectWithUuid:
        return _i104.ObjectWithUuid.t;
      case _i105.RelatedUniqueData:
        return _i105.RelatedUniqueData.t;
      case _i106.ScopeNoneFields:
        return _i106.ScopeNoneFields.t;
      case _i116.SimpleData:
        return _i116.SimpleData.t;
      case _i120.SimpleDateTime:
        return _i120.SimpleDateTime.t;
      case _i123.Types:
        return _i123.Types.t;
      case _i126.UniqueData:
        return _i126.UniqueData.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test';
}
