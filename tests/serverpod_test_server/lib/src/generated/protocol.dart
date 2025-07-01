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
import 'scopes/scope_server_only_field_child.dart' as _i5;
import 'inheritance/child_class.dart' as _i6;
import 'inheritance/child_with_default.dart' as _i7;
import 'inheritance/parent_class.dart' as _i8;
import 'inheritance/sealed_parent.dart' as _i9;
import 'defaults/uri/uri_default.dart' as _i10;
import 'changed_id_type/one_to_many/comment.dart' as _i11;
import 'changed_id_type/one_to_many/customer.dart' as _i12;
import 'changed_id_type/one_to_many/order.dart' as _i13;
import 'changed_id_type/one_to_one/address.dart' as _i14;
import 'changed_id_type/one_to_one/citizen.dart' as _i15;
import 'changed_id_type/one_to_one/company.dart' as _i16;
import 'changed_id_type/one_to_one/town.dart' as _i17;
import 'changed_id_type/self.dart' as _i18;
import 'defaults/bigint/bigint_default.dart' as _i19;
import 'defaults/bigint/bigint_default_mix.dart' as _i20;
import 'defaults/bigint/bigint_default_model.dart' as _i21;
import 'defaults/bigint/bigint_default_persist.dart' as _i22;
import 'defaults/boolean/bool_default.dart' as _i23;
import 'defaults/boolean/bool_default_mix.dart' as _i24;
import 'defaults/boolean/bool_default_model.dart' as _i25;
import 'defaults/boolean/bool_default_persist.dart' as _i26;
import 'defaults/datetime/datetime_default.dart' as _i27;
import 'defaults/datetime/datetime_default_mix.dart' as _i28;
import 'defaults/datetime/datetime_default_model.dart' as _i29;
import 'defaults/datetime/datetime_default_persist.dart' as _i30;
import 'defaults/double/double_default.dart' as _i31;
import 'defaults/double/double_default_mix.dart' as _i32;
import 'defaults/double/double_default_model.dart' as _i33;
import 'defaults/double/double_default_persist.dart' as _i34;
import 'defaults/duration/duration_default.dart' as _i35;
import 'defaults/duration/duration_default_mix.dart' as _i36;
import 'defaults/duration/duration_default_model.dart' as _i37;
import 'defaults/duration/duration_default_persist.dart' as _i38;
import 'defaults/enum/enum_default.dart' as _i39;
import 'defaults/enum/enum_default_mix.dart' as _i40;
import 'defaults/enum/enum_default_model.dart' as _i41;
import 'defaults/enum/enum_default_persist.dart' as _i42;
import 'defaults/enum/enums/by_index_enum.dart' as _i43;
import 'defaults/enum/enums/by_name_enum.dart' as _i44;
import 'defaults/enum/enums/default_value_enum.dart' as _i45;
import 'defaults/exception/default_exception.dart' as _i46;
import 'defaults/integer/int_default.dart' as _i47;
import 'defaults/integer/int_default_mix.dart' as _i48;
import 'defaults/integer/int_default_model.dart' as _i49;
import 'defaults/integer/int_default_persist.dart' as _i50;
import 'defaults/string/string_default.dart' as _i51;
import 'defaults/string/string_default_mix.dart' as _i52;
import 'defaults/string/string_default_model.dart' as _i53;
import 'defaults/string/string_default_persist.dart' as _i54;
import 'by_index_enum_with_name_value.dart' as _i55;
import 'defaults/uri/uri_default_mix.dart' as _i56;
import 'defaults/uri/uri_default_model.dart' as _i57;
import 'defaults/uri/uri_default_persist.dart' as _i58;
import 'defaults/uuid/uuid_default.dart' as _i59;
import 'defaults/uuid/uuid_default_mix.dart' as _i60;
import 'defaults/uuid/uuid_default_model.dart' as _i61;
import 'defaults/uuid/uuid_default_persist.dart' as _i62;
import 'empty_model/empty_model.dart' as _i63;
import 'empty_model/empty_model_relation_item.dart' as _i64;
import 'empty_model/empty_model_with_table.dart' as _i65;
import 'empty_model/relation_empy_model.dart' as _i66;
import 'exception_with_data.dart' as _i67;
import 'by_name_enum_with_name_value.dart' as _i68;
import 'changed_id_type/many_to_many/course.dart' as _i69;
import 'inheritance/grandparent_class.dart' as _i70;
import 'changed_id_type/many_to_many/enrollment.dart' as _i71;
import 'inheritance/parent_with_default.dart' as _i72;
import 'changed_id_type/many_to_many/student.dart' as _i73;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i74;
import 'changed_id_type/nested_one_to_many/player.dart' as _i75;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i76;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i77;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i78;
import 'long_identifiers/max_field_name.dart' as _i79;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i80;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i81;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i82;
import 'long_identifiers/models_with_relations/user_note.dart' as _i83;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i84;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i85;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i86;
import 'long_identifiers/multiple_max_field_name.dart' as _i87;
import 'models_with_list_relations/city.dart' as _i88;
import 'models_with_list_relations/organization.dart' as _i89;
import 'models_with_list_relations/person.dart' as _i90;
import 'models_with_relations/many_to_many/course.dart' as _i91;
import 'models_with_relations/many_to_many/enrollment.dart' as _i92;
import 'models_with_relations/many_to_many/student.dart' as _i93;
import 'models_with_relations/module/object_user.dart' as _i94;
import 'models_with_relations/module/parent_user.dart' as _i95;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i96;
import 'models_with_relations/nested_one_to_many/player.dart' as _i97;
import 'models_with_relations/nested_one_to_many/team.dart' as _i98;
import 'models_with_relations/one_to_many/comment.dart' as _i99;
import 'models_with_relations/one_to_many/customer.dart' as _i100;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i101;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i102;
import 'models_with_relations/one_to_many/order.dart' as _i103;
import 'models_with_relations/one_to_one/address.dart' as _i104;
import 'my_feature/models/my_feature_model.dart' as _i105;
import 'models_with_relations/one_to_one/company.dart' as _i106;
import 'models_with_relations/one_to_one/town.dart' as _i107;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i108;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i109;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i110;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i111;
import 'module_datatype.dart' as _i112;
import 'nullability.dart' as _i113;
import 'object_field_persist.dart' as _i114;
import 'object_field_scopes.dart' as _i115;
import 'object_with_bit.dart' as _i116;
import 'object_with_bytedata.dart' as _i117;
import 'object_with_custom_class.dart' as _i118;
import 'object_with_duration.dart' as _i119;
import 'object_with_enum.dart' as _i120;
import 'object_with_half_vector.dart' as _i121;
import 'object_with_index.dart' as _i122;
import 'object_with_maps.dart' as _i123;
import 'object_with_object.dart' as _i124;
import 'object_with_parent.dart' as _i125;
import 'object_with_self_parent.dart' as _i126;
import 'object_with_sparse_vector.dart' as _i127;
import 'object_with_uuid.dart' as _i128;
import 'object_with_vector.dart' as _i129;
import 'record.dart' as _i130;
import 'related_unique_data.dart' as _i131;
import 'scopes/scope_none_fields.dart' as _i132;
import 'scopes/scope_server_only_field.dart' as _i133;
import 'changed_id_type/nested_one_to_many/team.dart' as _i134;
import 'scopes/serverOnly/default_server_only_class.dart' as _i135;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i136;
import 'scopes/serverOnly/not_server_only_class.dart' as _i137;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i138;
import 'scopes/serverOnly/server_only_class.dart' as _i139;
import 'scopes/serverOnly/server_only_enum.dart' as _i140;
import 'scopes/server_only_class_field.dart' as _i141;
import 'simple_data.dart' as _i142;
import 'simple_data_list.dart' as _i143;
import 'simple_data_map.dart' as _i144;
import 'simple_data_object.dart' as _i145;
import 'simple_date_time.dart' as _i146;
import 'subfolder/model_in_subfolder.dart' as _i147;
import 'test_enum.dart' as _i148;
import 'test_enum_stringified.dart' as _i149;
import 'types.dart' as _i150;
import 'types_list.dart' as _i151;
import 'types_map.dart' as _i152;
import 'types_record.dart' as _i153;
import 'types_set.dart' as _i154;
import 'types_set_required.dart' as _i155;
import 'unique_data.dart' as _i156;
import 'models_with_relations/one_to_one/citizen.dart' as _i157;
import 'dart:typed_data' as _i158;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i159;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i160;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i161;
import 'package:serverpod_test_server/src/generated/types.dart' as _i162;
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
export 'nullability.dart';
export 'object_field_persist.dart';
export 'object_field_scopes.dart';
export 'object_with_bit.dart';
export 'object_with_bytedata.dart';
export 'object_with_custom_class.dart';
export 'object_with_duration.dart';
export 'object_with_enum.dart';
export 'object_with_half_vector.dart';
export 'object_with_index.dart';
export 'object_with_maps.dart';
export 'object_with_object.dart';
export 'object_with_parent.dart';
export 'object_with_self_parent.dart';
export 'object_with_sparse_vector.dart';
export 'object_with_uuid.dart';
export 'object_with_vector.dart';
export 'record.dart';
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
export 'subfolder/model_in_subfolder.dart';
export 'test_enum.dart';
export 'test_enum_stringified.dart';
export 'types.dart';
export 'types_list.dart';
export 'types_map.dart';
export 'types_record.dart';
export 'types_set.dart';
export 'types_set_required.dart';
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'address_uuid_pkey',
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
          indexName: 'inhabitant_uuid_index_idx',
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
            )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'chapter_pkey',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'comment_int_pkey',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'company_uuid_pkey',
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
            )
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'order_uuid_pkey',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'player_uuid_pkey',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'team_int_pkey',
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
          indexName: 'arena_uuid_index_idx',
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
        )
      ],
      indexes: [
        _i2.IndexDefinition(
          indexName: 'town_int_pkey',
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
    if (t == _i5.ScopeServerOnlyFieldChild) {
      return _i5.ScopeServerOnlyFieldChild.fromJson(data) as T;
    }
    if (t == _i6.ChildClass) {
      return _i6.ChildClass.fromJson(data) as T;
    }
    if (t == _i7.ChildWithDefault) {
      return _i7.ChildWithDefault.fromJson(data) as T;
    }
    if (t == _i8.ParentClass) {
      return _i8.ParentClass.fromJson(data) as T;
    }
    if (t == _i9.SealedGrandChild) {
      return _i9.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i9.SealedChild) {
      return _i9.SealedChild.fromJson(data) as T;
    }
    if (t == _i9.SealedOtherChild) {
      return _i9.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i10.UriDefault) {
      return _i10.UriDefault.fromJson(data) as T;
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
    if (t == _i19.BigIntDefault) {
      return _i19.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i20.BigIntDefaultMix) {
      return _i20.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i21.BigIntDefaultModel) {
      return _i21.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i22.BigIntDefaultPersist) {
      return _i22.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i23.BoolDefault) {
      return _i23.BoolDefault.fromJson(data) as T;
    }
    if (t == _i24.BoolDefaultMix) {
      return _i24.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i25.BoolDefaultModel) {
      return _i25.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i26.BoolDefaultPersist) {
      return _i26.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i27.DateTimeDefault) {
      return _i27.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i28.DateTimeDefaultMix) {
      return _i28.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i29.DateTimeDefaultModel) {
      return _i29.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i30.DateTimeDefaultPersist) {
      return _i30.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i31.DoubleDefault) {
      return _i31.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i32.DoubleDefaultMix) {
      return _i32.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i33.DoubleDefaultModel) {
      return _i33.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i34.DoubleDefaultPersist) {
      return _i34.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i35.DurationDefault) {
      return _i35.DurationDefault.fromJson(data) as T;
    }
    if (t == _i36.DurationDefaultMix) {
      return _i36.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i37.DurationDefaultModel) {
      return _i37.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i38.DurationDefaultPersist) {
      return _i38.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i39.EnumDefault) {
      return _i39.EnumDefault.fromJson(data) as T;
    }
    if (t == _i40.EnumDefaultMix) {
      return _i40.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i41.EnumDefaultModel) {
      return _i41.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i42.EnumDefaultPersist) {
      return _i42.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i43.ByIndexEnum) {
      return _i43.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i44.ByNameEnum) {
      return _i44.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i45.DefaultValueEnum) {
      return _i45.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _i46.DefaultException) {
      return _i46.DefaultException.fromJson(data) as T;
    }
    if (t == _i47.IntDefault) {
      return _i47.IntDefault.fromJson(data) as T;
    }
    if (t == _i48.IntDefaultMix) {
      return _i48.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i49.IntDefaultModel) {
      return _i49.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i50.IntDefaultPersist) {
      return _i50.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i51.StringDefault) {
      return _i51.StringDefault.fromJson(data) as T;
    }
    if (t == _i52.StringDefaultMix) {
      return _i52.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i53.StringDefaultModel) {
      return _i53.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i54.StringDefaultPersist) {
      return _i54.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i55.ByIndexEnumWithNameValue) {
      return _i55.ByIndexEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i56.UriDefaultMix) {
      return _i56.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i57.UriDefaultModel) {
      return _i57.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i58.UriDefaultPersist) {
      return _i58.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i59.UuidDefault) {
      return _i59.UuidDefault.fromJson(data) as T;
    }
    if (t == _i60.UuidDefaultMix) {
      return _i60.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i61.UuidDefaultModel) {
      return _i61.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i62.UuidDefaultPersist) {
      return _i62.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i63.EmptyModel) {
      return _i63.EmptyModel.fromJson(data) as T;
    }
    if (t == _i64.EmptyModelRelationItem) {
      return _i64.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i65.EmptyModelWithTable) {
      return _i65.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i66.RelationEmptyModel) {
      return _i66.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i67.ExceptionWithData) {
      return _i67.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i68.ByNameEnumWithNameValue) {
      return _i68.ByNameEnumWithNameValue.fromJson(data) as T;
    }
    if (t == _i69.CourseUuid) {
      return _i69.CourseUuid.fromJson(data) as T;
    }
    if (t == _i70.GrandparentClass) {
      return _i70.GrandparentClass.fromJson(data) as T;
    }
    if (t == _i71.EnrollmentInt) {
      return _i71.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i72.ParentWithDefault) {
      return _i72.ParentWithDefault.fromJson(data) as T;
    }
    if (t == _i73.StudentUuid) {
      return _i73.StudentUuid.fromJson(data) as T;
    }
    if (t == _i74.ArenaUuid) {
      return _i74.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i75.PlayerUuid) {
      return _i75.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i76.CityWithLongTableName) {
      return _i76.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i77.OrganizationWithLongTableName) {
      return _i77.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i78.PersonWithLongTableName) {
      return _i78.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i79.MaxFieldName) {
      return _i79.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i80.LongImplicitIdField) {
      return _i80.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i81.LongImplicitIdFieldCollection) {
      return _i81.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i82.RelationToMultipleMaxFieldName) {
      return _i82.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i83.UserNote) {
      return _i83.UserNote.fromJson(data) as T;
    }
    if (t == _i84.UserNoteCollection) {
      return _i84.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i85.UserNoteCollectionWithALongName) {
      return _i85.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i86.UserNoteWithALongName) {
      return _i86.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i87.MultipleMaxFieldName) {
      return _i87.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i88.City) {
      return _i88.City.fromJson(data) as T;
    }
    if (t == _i89.Organization) {
      return _i89.Organization.fromJson(data) as T;
    }
    if (t == _i90.Person) {
      return _i90.Person.fromJson(data) as T;
    }
    if (t == _i91.Course) {
      return _i91.Course.fromJson(data) as T;
    }
    if (t == _i92.Enrollment) {
      return _i92.Enrollment.fromJson(data) as T;
    }
    if (t == _i93.Student) {
      return _i93.Student.fromJson(data) as T;
    }
    if (t == _i94.ObjectUser) {
      return _i94.ObjectUser.fromJson(data) as T;
    }
    if (t == _i95.ParentUser) {
      return _i95.ParentUser.fromJson(data) as T;
    }
    if (t == _i96.Arena) {
      return _i96.Arena.fromJson(data) as T;
    }
    if (t == _i97.Player) {
      return _i97.Player.fromJson(data) as T;
    }
    if (t == _i98.Team) {
      return _i98.Team.fromJson(data) as T;
    }
    if (t == _i99.Comment) {
      return _i99.Comment.fromJson(data) as T;
    }
    if (t == _i100.Customer) {
      return _i100.Customer.fromJson(data) as T;
    }
    if (t == _i101.Book) {
      return _i101.Book.fromJson(data) as T;
    }
    if (t == _i102.Chapter) {
      return _i102.Chapter.fromJson(data) as T;
    }
    if (t == _i103.Order) {
      return _i103.Order.fromJson(data) as T;
    }
    if (t == _i104.Address) {
      return _i104.Address.fromJson(data) as T;
    }
    if (t == _i105.MyFeatureModel) {
      return _i105.MyFeatureModel.fromJson(data) as T;
    }
    if (t == _i106.Company) {
      return _i106.Company.fromJson(data) as T;
    }
    if (t == _i107.Town) {
      return _i107.Town.fromJson(data) as T;
    }
    if (t == _i108.Blocking) {
      return _i108.Blocking.fromJson(data) as T;
    }
    if (t == _i109.Member) {
      return _i109.Member.fromJson(data) as T;
    }
    if (t == _i110.Cat) {
      return _i110.Cat.fromJson(data) as T;
    }
    if (t == _i111.Post) {
      return _i111.Post.fromJson(data) as T;
    }
    if (t == _i112.ModuleDatatype) {
      return _i112.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i113.Nullability) {
      return _i113.Nullability.fromJson(data) as T;
    }
    if (t == _i114.ObjectFieldPersist) {
      return _i114.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i115.ObjectFieldScopes) {
      return _i115.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithBit) {
      return _i116.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithByteData) {
      return _i117.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithCustomClass) {
      return _i118.ObjectWithCustomClass.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithDuration) {
      return _i119.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i120.ObjectWithEnum) {
      return _i120.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i121.ObjectWithHalfVector) {
      return _i121.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i122.ObjectWithIndex) {
      return _i122.ObjectWithIndex.fromJson(data) as T;
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
    if (t == _i126.ObjectWithSelfParent) {
      return _i126.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i127.ObjectWithSparseVector) {
      return _i127.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i128.ObjectWithUuid) {
      return _i128.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i129.ObjectWithVector) {
      return _i129.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i130.Record) {
      return _i130.Record.fromJson(data) as T;
    }
    if (t == _i131.RelatedUniqueData) {
      return _i131.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i132.ScopeNoneFields) {
      return _i132.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i133.ScopeServerOnlyField) {
      return _i133.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i134.TeamInt) {
      return _i134.TeamInt.fromJson(data) as T;
    }
    if (t == _i135.DefaultServerOnlyClass) {
      return _i135.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i136.DefaultServerOnlyEnum) {
      return _i136.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i137.NotServerOnlyClass) {
      return _i137.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i138.NotServerOnlyEnum) {
      return _i138.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i139.ServerOnlyClass) {
      return _i139.ServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i140.ServerOnlyEnum) {
      return _i140.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i141.ServerOnlyClassField) {
      return _i141.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i142.SimpleData) {
      return _i142.SimpleData.fromJson(data) as T;
    }
    if (t == _i143.SimpleDataList) {
      return _i143.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i144.SimpleDataMap) {
      return _i144.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i145.SimpleDataObject) {
      return _i145.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i146.SimpleDateTime) {
      return _i146.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i147.ModelInSubfolder) {
      return _i147.ModelInSubfolder.fromJson(data) as T;
    }
    if (t == _i148.TestEnum) {
      return _i148.TestEnum.fromJson(data) as T;
    }
    if (t == _i149.TestEnumStringified) {
      return _i149.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i150.Types) {
      return _i150.Types.fromJson(data) as T;
    }
    if (t == _i151.TypesList) {
      return _i151.TypesList.fromJson(data) as T;
    }
    if (t == _i152.TypesMap) {
      return _i152.TypesMap.fromJson(data) as T;
    }
    if (t == _i153.TypesRecord) {
      return _i153.TypesRecord.fromJson(data) as T;
    }
    if (t == _i154.TypesSet) {
      return _i154.TypesSet.fromJson(data) as T;
    }
    if (t == _i155.TypesSetRequired) {
      return _i155.TypesSetRequired.fromJson(data) as T;
    }
    if (t == _i156.UniqueData) {
      return _i156.UniqueData.fromJson(data) as T;
    }
    if (t == _i157.Citizen) {
      return _i157.Citizen.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ScopeServerOnlyFieldChild?>()) {
      return (data != null
          ? _i5.ScopeServerOnlyFieldChild.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i6.ChildClass?>()) {
      return (data != null ? _i6.ChildClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i7.ChildWithDefault?>()) {
      return (data != null ? _i7.ChildWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i8.ParentClass?>()) {
      return (data != null ? _i8.ParentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SealedGrandChild?>()) {
      return (data != null ? _i9.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SealedChild?>()) {
      return (data != null ? _i9.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i9.SealedOtherChild?>()) {
      return (data != null ? _i9.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.UriDefault?>()) {
      return (data != null ? _i10.UriDefault.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i19.BigIntDefault?>()) {
      return (data != null ? _i19.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.BigIntDefaultMix?>()) {
      return (data != null ? _i20.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.BigIntDefaultModel?>()) {
      return (data != null ? _i21.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i22.BigIntDefaultPersist?>()) {
      return (data != null ? _i22.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i23.BoolDefault?>()) {
      return (data != null ? _i23.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.BoolDefaultMix?>()) {
      return (data != null ? _i24.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.BoolDefaultModel?>()) {
      return (data != null ? _i25.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.BoolDefaultPersist?>()) {
      return (data != null ? _i26.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i27.DateTimeDefault?>()) {
      return (data != null ? _i27.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.DateTimeDefaultMix?>()) {
      return (data != null ? _i28.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i29.DateTimeDefaultModel?>()) {
      return (data != null ? _i29.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i30.DateTimeDefaultPersist?>()) {
      return (data != null ? _i30.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i31.DoubleDefault?>()) {
      return (data != null ? _i31.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.DoubleDefaultMix?>()) {
      return (data != null ? _i32.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.DoubleDefaultModel?>()) {
      return (data != null ? _i33.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i34.DoubleDefaultPersist?>()) {
      return (data != null ? _i34.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i35.DurationDefault?>()) {
      return (data != null ? _i35.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.DurationDefaultMix?>()) {
      return (data != null ? _i36.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i37.DurationDefaultModel?>()) {
      return (data != null ? _i37.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.DurationDefaultPersist?>()) {
      return (data != null ? _i38.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i39.EnumDefault?>()) {
      return (data != null ? _i39.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.EnumDefaultMix?>()) {
      return (data != null ? _i40.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.EnumDefaultModel?>()) {
      return (data != null ? _i41.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.EnumDefaultPersist?>()) {
      return (data != null ? _i42.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.ByIndexEnum?>()) {
      return (data != null ? _i43.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i44.ByNameEnum?>()) {
      return (data != null ? _i44.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.DefaultValueEnum?>()) {
      return (data != null ? _i45.DefaultValueEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.DefaultException?>()) {
      return (data != null ? _i46.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.IntDefault?>()) {
      return (data != null ? _i47.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.IntDefaultMix?>()) {
      return (data != null ? _i48.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.IntDefaultModel?>()) {
      return (data != null ? _i49.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.IntDefaultPersist?>()) {
      return (data != null ? _i50.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i51.StringDefault?>()) {
      return (data != null ? _i51.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.StringDefaultMix?>()) {
      return (data != null ? _i52.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.StringDefaultModel?>()) {
      return (data != null ? _i53.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i54.StringDefaultPersist?>()) {
      return (data != null ? _i54.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.ByIndexEnumWithNameValue?>()) {
      return (data != null
          ? _i55.ByIndexEnumWithNameValue.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i56.UriDefaultMix?>()) {
      return (data != null ? _i56.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i57.UriDefaultModel?>()) {
      return (data != null ? _i57.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i58.UriDefaultPersist?>()) {
      return (data != null ? _i58.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.UuidDefault?>()) {
      return (data != null ? _i59.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.UuidDefaultMix?>()) {
      return (data != null ? _i60.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.UuidDefaultModel?>()) {
      return (data != null ? _i61.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i62.UuidDefaultPersist?>()) {
      return (data != null ? _i62.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i63.EmptyModel?>()) {
      return (data != null ? _i63.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.EmptyModelRelationItem?>()) {
      return (data != null ? _i64.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i65.EmptyModelWithTable?>()) {
      return (data != null ? _i65.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i66.RelationEmptyModel?>()) {
      return (data != null ? _i66.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i67.ExceptionWithData?>()) {
      return (data != null ? _i67.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.ByNameEnumWithNameValue?>()) {
      return (data != null ? _i68.ByNameEnumWithNameValue.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.CourseUuid?>()) {
      return (data != null ? _i69.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.GrandparentClass?>()) {
      return (data != null ? _i70.GrandparentClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.EnrollmentInt?>()) {
      return (data != null ? _i71.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.ParentWithDefault?>()) {
      return (data != null ? _i72.ParentWithDefault.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i73.StudentUuid?>()) {
      return (data != null ? _i73.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i74.ArenaUuid?>()) {
      return (data != null ? _i74.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i75.PlayerUuid?>()) {
      return (data != null ? _i75.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i76.CityWithLongTableName?>()) {
      return (data != null ? _i76.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i77.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i77.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i78.PersonWithLongTableName?>()) {
      return (data != null ? _i78.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i79.MaxFieldName?>()) {
      return (data != null ? _i79.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i80.LongImplicitIdField?>()) {
      return (data != null ? _i80.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i81.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i81.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i82.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i82.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i83.UserNote?>()) {
      return (data != null ? _i83.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i84.UserNoteCollection?>()) {
      return (data != null ? _i84.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i85.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i85.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i86.UserNoteWithALongName?>()) {
      return (data != null ? _i86.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i87.MultipleMaxFieldName?>()) {
      return (data != null ? _i87.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i88.City?>()) {
      return (data != null ? _i88.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i89.Organization?>()) {
      return (data != null ? _i89.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i90.Person?>()) {
      return (data != null ? _i90.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i91.Course?>()) {
      return (data != null ? _i91.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i92.Enrollment?>()) {
      return (data != null ? _i92.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i93.Student?>()) {
      return (data != null ? _i93.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i94.ObjectUser?>()) {
      return (data != null ? _i94.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i95.ParentUser?>()) {
      return (data != null ? _i95.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i96.Arena?>()) {
      return (data != null ? _i96.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i97.Player?>()) {
      return (data != null ? _i97.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i98.Team?>()) {
      return (data != null ? _i98.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i99.Comment?>()) {
      return (data != null ? _i99.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i100.Customer?>()) {
      return (data != null ? _i100.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i101.Book?>()) {
      return (data != null ? _i101.Book.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i102.Chapter?>()) {
      return (data != null ? _i102.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i103.Order?>()) {
      return (data != null ? _i103.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i104.Address?>()) {
      return (data != null ? _i104.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i105.MyFeatureModel?>()) {
      return (data != null ? _i105.MyFeatureModel.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i106.Company?>()) {
      return (data != null ? _i106.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i107.Town?>()) {
      return (data != null ? _i107.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i108.Blocking?>()) {
      return (data != null ? _i108.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i109.Member?>()) {
      return (data != null ? _i109.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i110.Cat?>()) {
      return (data != null ? _i110.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i111.Post?>()) {
      return (data != null ? _i111.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i112.ModuleDatatype?>()) {
      return (data != null ? _i112.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i113.Nullability?>()) {
      return (data != null ? _i113.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i114.ObjectFieldPersist?>()) {
      return (data != null ? _i114.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i115.ObjectFieldScopes?>()) {
      return (data != null ? _i115.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i116.ObjectWithBit?>()) {
      return (data != null ? _i116.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i117.ObjectWithByteData?>()) {
      return (data != null ? _i117.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i118.ObjectWithCustomClass?>()) {
      return (data != null ? _i118.ObjectWithCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i119.ObjectWithDuration?>()) {
      return (data != null ? _i119.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i120.ObjectWithEnum?>()) {
      return (data != null ? _i120.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i121.ObjectWithHalfVector?>()) {
      return (data != null ? _i121.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i122.ObjectWithIndex?>()) {
      return (data != null ? _i122.ObjectWithIndex.fromJson(data) : null) as T;
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
    if (t == _i1.getType<_i126.ObjectWithSelfParent?>()) {
      return (data != null ? _i126.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i127.ObjectWithSparseVector?>()) {
      return (data != null ? _i127.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i128.ObjectWithUuid?>()) {
      return (data != null ? _i128.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i129.ObjectWithVector?>()) {
      return (data != null ? _i129.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i130.Record?>()) {
      return (data != null ? _i130.Record.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i131.RelatedUniqueData?>()) {
      return (data != null ? _i131.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i132.ScopeNoneFields?>()) {
      return (data != null ? _i132.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i133.ScopeServerOnlyField?>()) {
      return (data != null ? _i133.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i134.TeamInt?>()) {
      return (data != null ? _i134.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i135.DefaultServerOnlyClass?>()) {
      return (data != null ? _i135.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i136.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i136.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i137.NotServerOnlyClass?>()) {
      return (data != null ? _i137.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i138.NotServerOnlyEnum?>()) {
      return (data != null ? _i138.NotServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i139.ServerOnlyClass?>()) {
      return (data != null ? _i139.ServerOnlyClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i140.ServerOnlyEnum?>()) {
      return (data != null ? _i140.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i141.ServerOnlyClassField?>()) {
      return (data != null ? _i141.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i142.SimpleData?>()) {
      return (data != null ? _i142.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i143.SimpleDataList?>()) {
      return (data != null ? _i143.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i144.SimpleDataMap?>()) {
      return (data != null ? _i144.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i145.SimpleDataObject?>()) {
      return (data != null ? _i145.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i146.SimpleDateTime?>()) {
      return (data != null ? _i146.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i147.ModelInSubfolder?>()) {
      return (data != null ? _i147.ModelInSubfolder.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i148.TestEnum?>()) {
      return (data != null ? _i148.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i149.TestEnumStringified?>()) {
      return (data != null ? _i149.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i150.Types?>()) {
      return (data != null ? _i150.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i151.TypesList?>()) {
      return (data != null ? _i151.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i152.TypesMap?>()) {
      return (data != null ? _i152.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i153.TypesRecord?>()) {
      return (data != null ? _i153.TypesRecord.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i154.TypesSet?>()) {
      return (data != null ? _i154.TypesSet.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i155.TypesSetRequired?>()) {
      return (data != null ? _i155.TypesSetRequired.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i156.UniqueData?>()) {
      return (data != null ? _i156.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i157.Citizen?>()) {
      return (data != null ? _i157.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<List<_i13.OrderUuid>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i13.OrderUuid>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i11.CommentInt>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i11.CommentInt>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i18.ChangedIdTypeSelf>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i18.ChangedIdTypeSelf>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i64.EmptyModelRelationItem>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i64.EmptyModelRelationItem>(e))
              .toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == _i1.getType<List<_i71.EnrollmentInt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i71.EnrollmentInt>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i71.EnrollmentInt>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i71.EnrollmentInt>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i78.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i78.PersonWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i77.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i77.OrganizationWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i78.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i78.PersonWithLongTableName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i80.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i80.LongImplicitIdField>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i87.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i87.MultipleMaxFieldName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i83.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i83.UserNote>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i86.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i86.UserNoteWithALongName>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i90.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i90.Person>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i89.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i89.Organization>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i90.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i90.Person>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i92.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i92.Enrollment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i92.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i92.Enrollment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i97.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i97.Player>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i103.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i103.Order>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i102.Chapter>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i102.Chapter>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i99.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i99.Comment>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i108.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i108.Blocking>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i108.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i108.Blocking>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i110.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i110.Cat>(e)).toList()
          : null) as T;
    }
    if (t == List<_i4.ModuleClass>) {
      return (data as List).map((e) => deserialize<_i4.ModuleClass>(e)).toList()
          as T;
    }
    if (t == Map<String, _i4.ModuleClass>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i4.ModuleClass>(v)))
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
    if (t == List<_i142.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i142.SimpleData>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i142.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i142.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == List<_i142.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i142.SimpleData?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i142.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i142.SimpleData?>(e))
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
    if (t == List<_i158.ByteData>) {
      return (data as List).map((e) => deserialize<_i158.ByteData>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i158.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i158.ByteData>(e)).toList()
          : null) as T;
    }
    if (t == List<_i158.ByteData?>) {
      return (data as List).map((e) => deserialize<_i158.ByteData?>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<_i158.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i158.ByteData?>(e)).toList()
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
    if (t == _i159.CustomClassWithoutProtocolSerialization) {
      return _i159.CustomClassWithoutProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i159.CustomClassWithProtocolSerialization) {
      return _i159.CustomClassWithProtocolSerialization.fromJson(data) as T;
    }
    if (t == _i159.CustomClassWithProtocolSerializationMethod) {
      return _i159.CustomClassWithProtocolSerializationMethod.fromJson(data)
          as T;
    }
    if (t == List<_i148.TestEnum>) {
      return (data as List).map((e) => deserialize<_i148.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i148.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i148.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i148.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i148.TestEnum>>(e))
          .toList() as T;
    }
    if (t == Map<String, _i142.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i142.SimpleData>(v))) as T;
    }
    if (t == Map<String, String>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String>(v))) as T;
    }
    if (t == Map<String, DateTime>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime>(v))) as T;
    }
    if (t == Map<String, _i158.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i158.ByteData>(v)))
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
    if (t == Map<String, _i142.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i142.SimpleData?>(v))) as T;
    }
    if (t == Map<String, String?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<String?>(v))) as T;
    }
    if (t == Map<String, DateTime?>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<DateTime?>(v))) as T;
    }
    if (t == Map<String, _i158.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i158.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i142.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i142.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i142.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i142.SimpleData?>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<List<_i142.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i142.SimpleData>>(e))
              .toList()
          : null) as T;
    }
    if (t ==
        _i1.getType<Map<String, List<List<Map<int, _i142.SimpleData>>?>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<List<List<Map<int, _i142.SimpleData>>?>>(v)))
          : null) as T;
    }
    if (t == List<List<Map<int, _i142.SimpleData>>?>) {
      return (data as List)
          .map((e) => deserialize<List<Map<int, _i142.SimpleData>>?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<Map<int, _i142.SimpleData>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<int, _i142.SimpleData>>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<int, _i142.SimpleData>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<int>(e['k']), deserialize<_i142.SimpleData>(e['v']))))
          as T;
    }
    if (t == _i1.getType<Map<String, Map<int, _i142.SimpleData>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<Map<int, _i142.SimpleData>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<_i75.PlayerUuid>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.PlayerUuid>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i139.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i139.ServerOnlyClass>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i139.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i139.ServerOnlyClass>(v)))
          : null) as T;
    }
    if (t == _i1.getType<List<_i149.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i149.TestEnumStringified>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i149.TestEnumStringified>(
                  ((data as Map)['p'] as List)[0]),
            ) as T;
    }
    if (t == _i1.getType<List<(_i149.TestEnumStringified,)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(_i149.TestEnumStringified,)>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)>()) {
      return (
        deserialize<_i149.TestEnumStringified>(((data as Map)['p'] as List)[0]),
      ) as T;
    }
    if (t == _i1.getType<(_i4.ModuleClass,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i4.ModuleClass>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<(_i113.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i113.Nullability>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<({_i149.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i149.TestEnumStringified>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
    }
    if (t == _i1.getType<List<({_i149.TestEnumStringified value})>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<({_i149.TestEnumStringified value})>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<({_i149.TestEnumStringified value})>()) {
      return (
        value: deserialize<_i149.TestEnumStringified>(
            ((data as Map)['n'] as Map)['value']),
      ) as T;
    }
    if (t == _i1.getType<({_i4.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i4.ModuleClass>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
    }
    if (t == _i1.getType<({_i113.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i113.Nullability>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
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
    if (t == _i1.getType<(String, {Uri? optionalUri})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<String>(((data as Map)['p'] as List)[0]),
              optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                  ? null
                  : deserialize<Uri>(data['n']['optionalUri']),
            ) as T;
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
    if (t == _i1.getType<List<_i158.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i158.ByteData>(e)).toList()
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
    if (t == _i1.getType<List<_i148.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i148.TestEnum>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i149.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i149.TestEnumStringified>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i150.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i150.Types>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<Map<String, _i150.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i150.Types>>(e))
              .toList()
          : null) as T;
    }
    if (t == Map<String, _i150.Types>) {
      return (data as Map).map((k, v) =>
          MapEntry(deserialize<String>(k), deserialize<_i150.Types>(v))) as T;
    }
    if (t == _i1.getType<List<List<_i150.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<List<_i150.Types>>(e))
              .toList()
          : null) as T;
    }
    if (t == List<_i150.Types>) {
      return (data as List).map((e) => deserialize<_i150.Types>(e)).toList()
          as T;
    }
    if (t == _i1.getType<List<(int,)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(_i148.TestEnum,)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(_i148.TestEnum,)>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i148.TestEnum,)>()) {
      return (deserialize<_i148.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<List<(_i149.TestEnumStringified,)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(_i149.TestEnumStringified,)>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)>()) {
      return (
        deserialize<_i149.TestEnumStringified>(((data as Map)['p'] as List)[0]),
      ) as T;
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
    if (t == _i1.getType<Map<_i158.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i158.ByteData>(e['k']),
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
    if (t == _i1.getType<Map<_i148.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i148.TestEnum>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i149.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i149.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<_i150.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i150.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<Map<_i150.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i150.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == Map<_i150.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i150.Types>(e['k']), deserialize<String>(e['v'])))) as T;
    }
    if (t == _i1.getType<Map<List<_i150.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i150.Types>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<Map<(String,), String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<(String,)>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
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
    if (t == _i1.getType<Map<String, _i158.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i158.ByteData>(v)))
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
    if (t == _i1.getType<Map<String, _i148.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i148.TestEnum>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i149.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(deserialize<String>(k),
              deserialize<_i149.TestEnumStringified>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i150.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i150.Types>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, Map<String, _i150.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i150.Types>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, List<_i150.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i150.Types>>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, (String,)>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<(String,)>(v)))
          : null) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<(String,)?>(v)))
          : null) as T;
    }
    if (t == _i1.getType<(String,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<(String,)?, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<(String,)?>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
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
    if (t == _i1.getType<(bool,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<bool>(((data as Map)['p'] as List)[0]),) as T;
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
    if (t == _i1.getType<(_i158.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i158.ByteData>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i148.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i148.TestEnum>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i149.TestEnumStringified>(
                  ((data as Map)['p'] as List)[0]),
            ) as T;
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
    if (t == _i1.getType<(_i142.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<({_i142.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
              namedModel: deserialize<_i142.SimpleData>(
                  ((data as Map)['n'] as Map)['namedModel']),
            ) as T;
    }
    if (t ==
        _i1.getType<(_i142.SimpleData, {_i142.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),
              namedModel:
                  deserialize<_i142.SimpleData>(data['n']['namedModel']),
            ) as T;
    }
    if (t ==
        _i1.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
              namedNestedRecord:
                  deserialize<(int, String)>(data['n']['namedNestedRecord']),
            ) as T;
    }
    if (t ==
        _i1.getType<
            (
              (List<(_i142.SimpleData,)>,), {
              (
                _i142.SimpleData,
                Map<String, _i142.SimpleData>
              ) namedNestedRecord
            })?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(List<(_i142.SimpleData,)>,)>(
                  ((data as Map)['p'] as List)[0]),
              namedNestedRecord: deserialize<
                  (
                    _i142.SimpleData,
                    Map<String, _i142.SimpleData>
                  )>(data['n']['namedNestedRecord']),
            ) as T;
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
    if (t == _i1.getType<Set<_i158.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i158.ByteData>(e)).toSet()
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
    if (t == _i1.getType<Set<_i148.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i148.TestEnum>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i149.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i149.TestEnumStringified>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<_i150.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i150.Types>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<Map<String, _i150.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i150.Types>>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<List<_i150.Types>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<_i150.Types>>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<Set<(int,)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList() as T;
    }
    if (t == List<_i160.SimpleData>) {
      return (data as List)
          .map((e) => deserialize<_i160.SimpleData>(e))
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
    if (t == List<_i158.ByteData>) {
      return (data as List).map((e) => deserialize<_i158.ByteData>(e)).toList()
          as T;
    }
    if (t == List<_i158.ByteData?>) {
      return (data as List).map((e) => deserialize<_i158.ByteData?>(e)).toList()
          as T;
    }
    if (t == List<_i160.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i160.SimpleData?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<List<_i160.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i160.SimpleData>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<List<_i160.SimpleData?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i160.SimpleData?>(e))
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
    if (t == Map<_i161.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<_i161.TestEnum>(e['k']), deserialize<int>(e['v'])))) as T;
    }
    if (t == Map<String, _i161.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i161.TestEnum>(v)))
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
    if (t == Map<String, _i158.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i158.ByteData>(v)))
          as T;
    }
    if (t == Map<String, _i158.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i158.ByteData?>(v)))
          as T;
    }
    if (t == Map<String, _i160.SimpleData>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i160.SimpleData>(v))) as T;
    }
    if (t == Map<String, _i160.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i160.SimpleData?>(v))) as T;
    }
    if (t == _i1.getType<Map<String, _i160.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i160.SimpleData>(v)))
          : null) as T;
    }
    if (t == _i1.getType<Map<String, _i160.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i160.SimpleData?>(v)))
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
    if (t == List<_i3.UserInfo>) {
      return (data as List).map((e) => deserialize<_i3.UserInfo>(e)).toList()
          as T;
    }
    if (t == Set<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toSet() as T;
    }
    if (t == Set<_i160.SimpleData>) {
      return (data as List).map((e) => deserialize<_i160.SimpleData>(e)).toSet()
          as T;
    }
    if (t == List<Set<_i160.SimpleData>>) {
      return (data as List)
          .map((e) => deserialize<Set<_i160.SimpleData>>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int, BigInt)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<BigInt>(data['p'][1]),
      ) as T;
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
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i160.SimpleData>(data['p'][1]),
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
    if (t == _i1.getType<({_i160.SimpleData data, int number})>()) {
      return (
        data:
            deserialize<_i160.SimpleData>(((data as Map)['n'] as Map)['data']),
        number: deserialize<int>(data['n']['number']),
      ) as T;
    }
    if (t == _i1.getType<({_i160.SimpleData data, int number})?>()) {
      return (data == null)
          ? null as T
          : (
              data: deserialize<_i160.SimpleData>(
                  ((data as Map)['n'] as Map)['data']),
              number: deserialize<int>(data['n']['number']),
            ) as T;
    }
    if (t == _i1.getType<({_i160.SimpleData? data, int? number})>()) {
      return (
        data: ((data as Map)['n'] as Map)['data'] == null
            ? null
            : deserialize<_i160.SimpleData>(data['n']['data']),
        number: ((data)['n'] as Map)['number'] == null
            ? null
            : deserialize<int>(data['n']['number']),
      ) as T;
    }
    if (t == _i1.getType<(int, {_i160.SimpleData data})>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        data: deserialize<_i160.SimpleData>(data['n']['data']),
      ) as T;
    }
    if (t == _i1.getType<(int, {_i160.SimpleData data})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              data: deserialize<_i160.SimpleData>(data['n']['data']),
            ) as T;
    }
    if (t == List<(int, _i160.SimpleData)>) {
      return (data as List)
          .map((e) => deserialize<(int, _i160.SimpleData)>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == List<(int, _i160.SimpleData)?>) {
      return (data as List)
          .map((e) => deserialize<(int, _i160.SimpleData)?>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i160.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == Set<(int, _i160.SimpleData)>) {
      return (data as List)
          .map((e) => deserialize<(int, _i160.SimpleData)>(e))
          .toSet() as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Set<(int, _i160.SimpleData)?>) {
      return (data as List)
          .map((e) => deserialize<(int, _i160.SimpleData)?>(e))
          .toSet() as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i160.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<Set<(int, _i160.SimpleData)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(int, _i160.SimpleData)>(e))
              .toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Map<String, (int, _i160.SimpleData)>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<(int, _i160.SimpleData)>(v)))
          as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
      ) as T;
    }
    if (t == Map<String, (int, _i160.SimpleData)?>) {
      return (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<(int, _i160.SimpleData)?>(v)))
          as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<int>(((data as Map)['p'] as List)[0]),
              deserialize<_i160.SimpleData>(data['p'][1]),
            ) as T;
    }
    if (t == Map<(String, int), (int, _i160.SimpleData)>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
          deserialize<(String, int)>(e['k']),
          deserialize<(int, _i160.SimpleData)>(e['v'])))) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(int, _i160.SimpleData)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<_i160.SimpleData>(data['p'][1]),
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
    if (t == _i1.getType<({(_i160.SimpleData, double) namedSubRecord})>()) {
      return (
        namedSubRecord: deserialize<(_i160.SimpleData, double)>(
            ((data as Map)['n'] as Map)['namedSubRecord']),
      ) as T;
    }
    if (t == _i1.getType<(_i160.SimpleData, double)>()) {
      return (
        deserialize<_i160.SimpleData>(((data as Map)['p'] as List)[0]),
        deserialize<double>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<({(_i160.SimpleData, double)? namedSubRecord})>()) {
      return (
        namedSubRecord: ((data as Map)['n'] as Map)['namedSubRecord'] == null
            ? null
            : deserialize<(_i160.SimpleData, double)>(
                data['n']['namedSubRecord']),
      ) as T;
    }
    if (t == _i1.getType<(_i160.SimpleData, double)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i160.SimpleData>(((data as Map)['p'] as List)[0]),
              deserialize<double>(data['p'][1]),
            ) as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i160.SimpleData, double) namedSubRecord})>()) {
      return (
        deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
        namedSubRecord: deserialize<(_i160.SimpleData, double)>(
            data['n']['namedSubRecord']),
      ) as T;
    }
    if (t ==
        List<((int, String), {(_i160.SimpleData, double) namedSubRecord})>) {
      return (data as List)
          .map((e) => deserialize<
              ((int, String), {(_i160.SimpleData, double) namedSubRecord})>(e))
          .toList() as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i160.SimpleData, double) namedSubRecord})>()) {
      return (
        deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
        namedSubRecord: deserialize<(_i160.SimpleData, double)>(
            data['n']['namedSubRecord']),
      ) as T;
    }
    if (t ==
        _i1.getType<
            List<
                (
                  (int, String), {
                  (_i160.SimpleData, double) namedSubRecord
                })?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<
                  (
                    (int, String), {
                    (_i160.SimpleData, double) namedSubRecord
                  })?>(e))
              .toList()
          : null) as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i160.SimpleData, double) namedSubRecord})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
              namedSubRecord: deserialize<(_i160.SimpleData, double)>(
                  data['n']['namedSubRecord']),
            ) as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i160.SimpleData, double) namedSubRecord})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
              namedSubRecord: deserialize<(_i160.SimpleData, double)>(
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
    if (t == Set<_i158.ByteData>) {
      return (data as List).map((e) => deserialize<_i158.ByteData>(e)).toSet()
          as T;
    }
    if (t == Set<_i158.ByteData?>) {
      return (data as List).map((e) => deserialize<_i158.ByteData?>(e)).toSet()
          as T;
    }
    if (t == Set<_i160.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i160.SimpleData?>(e))
          .toSet() as T;
    }
    if (t == Set<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toSet() as T;
    }
    if (t == Set<Duration?>) {
      return (data as List).map((e) => deserialize<Duration?>(e)).toSet() as T;
    }
    if (t == List<_i162.Types>) {
      return (data as List).map((e) => deserialize<_i162.Types>(e)).toList()
          as T;
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
    if (t ==
        _i1.getType<
            (
              String,
              (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
            )>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<
            (
              Map<String, int>, {
              bool flag,
              _i160.SimpleData simpleData
            })>(data['p'][1]),
      ) as T;
    }
    if (t ==
        _i1.getType<
            (Map<String, int>, {bool flag, _i160.SimpleData simpleData})>()) {
      return (
        deserialize<Map<String, int>>(((data as Map)['p'] as List)[0]),
        flag: deserialize<bool>(data['n']['flag']),
        simpleData: deserialize<_i160.SimpleData>(data['n']['simpleData']),
      ) as T;
    }
    if (t == List<(String, int)>) {
      return (data as List).map((e) => deserialize<(String, int)>(e)).toList()
          as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t ==
        _i1.getType<
            (
              String,
              (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
            )?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<String>(((data as Map)['p'] as List)[0]),
              deserialize<
                  (
                    Map<String, int>, {
                    bool flag,
                    _i160.SimpleData simpleData
                  })>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<List<(String, int)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(String, int)>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
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
    if (t == _i1.getType<(_i149.TestEnumStringified,)?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i149.TestEnumStringified>(
                  ((data as Map)['p'] as List)[0]),
            ) as T;
    }
    if (t == _i1.getType<List<(_i149.TestEnumStringified,)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(_i149.TestEnumStringified,)>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)>()) {
      return (
        deserialize<_i149.TestEnumStringified>(((data as Map)['p'] as List)[0]),
      ) as T;
    }
    if (t == _i1.getType<(_i149.TestEnumStringified,)>()) {
      return (
        deserialize<_i149.TestEnumStringified>(((data as Map)['p'] as List)[0]),
      ) as T;
    }
    if (t == _i1.getType<(_i113.Nullability,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i113.Nullability>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<({_i149.TestEnumStringified value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i149.TestEnumStringified>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
    }
    if (t == _i1.getType<List<({_i149.TestEnumStringified value})>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<({_i149.TestEnumStringified value})>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<({_i149.TestEnumStringified value})>()) {
      return (
        value: deserialize<_i149.TestEnumStringified>(
            ((data as Map)['n'] as Map)['value']),
      ) as T;
    }
    if (t == _i1.getType<({_i149.TestEnumStringified value})>()) {
      return (
        value: deserialize<_i149.TestEnumStringified>(
            ((data as Map)['n'] as Map)['value']),
      ) as T;
    }
    if (t == _i1.getType<({_i4.ModuleClass value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i4.ModuleClass>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
    }
    if (t == _i1.getType<({_i113.Nullability value})?>()) {
      return (data == null)
          ? null as T
          : (
              value: deserialize<_i113.Nullability>(
                  ((data as Map)['n'] as Map)['value']),
            ) as T;
    }
    if (t == _i1.getType<(String, {Uri? optionalUri})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<String>(((data as Map)['p'] as List)[0]),
              optionalUri: ((data)['n'] as Map)['optionalUri'] == null
                  ? null
                  : deserialize<Uri>(data['n']['optionalUri']),
            ) as T;
    }
    if (t == _i1.getType<List<(int,)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(int,)?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)?>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<List<(_i148.TestEnum,)>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<(_i148.TestEnum,)>(e))
              .toList()
          : null) as T;
    }
    if (t == _i1.getType<(_i148.TestEnum,)>()) {
      return (deserialize<_i148.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i148.TestEnum,)>()) {
      return (deserialize<_i148.TestEnum>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<Map<(String,), String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<(String,)>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<(String,)>(v)))
          : null) as T;
    }
    if (t == _i1.getType<(String,)>()) {
      return (deserialize<String>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Map<String, (String,)?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<(String,)?>(v)))
          : null) as T;
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
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<(String,)?>(e['k']), deserialize<String>(e['v']))))
          : null) as T;
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
    if (t == _i1.getType<(_i158.ByteData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i158.ByteData>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i148.TestEnum,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i148.TestEnum>(((data as Map)['p'] as List)[0]),)
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
    if (t == _i1.getType<(_i142.SimpleData,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),)
              as T;
    }
    if (t == _i1.getType<({_i142.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
              namedModel: deserialize<_i142.SimpleData>(
                  ((data as Map)['n'] as Map)['namedModel']),
            ) as T;
    }
    if (t ==
        _i1.getType<(_i142.SimpleData, {_i142.SimpleData namedModel})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),
              namedModel:
                  deserialize<_i142.SimpleData>(data['n']['namedModel']),
            ) as T;
    }
    if (t ==
        _i1.getType<((int, String), {(int, String) namedNestedRecord})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
              namedNestedRecord:
                  deserialize<(int, String)>(data['n']['namedNestedRecord']),
            ) as T;
    }
    if (t == _i1.getType<(int, String)>()) {
      return (
        deserialize<int>(((data as Map)['p'] as List)[0]),
        deserialize<String>(data['p'][1]),
      ) as T;
    }
    if (t ==
        _i1.getType<
            (
              (List<(_i142.SimpleData,)>,), {
              (
                _i142.SimpleData,
                Map<String, _i142.SimpleData>
              ) namedNestedRecord
            })?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(List<(_i142.SimpleData,)>,)>(
                  ((data as Map)['p'] as List)[0]),
              namedNestedRecord: deserialize<
                  (
                    _i142.SimpleData,
                    Map<String, _i142.SimpleData>
                  )>(data['n']['namedNestedRecord']),
            ) as T;
    }
    if (t == _i1.getType<(List<(_i142.SimpleData,)>,)>()) {
      return (
        deserialize<List<(_i142.SimpleData,)>>(((data as Map)['p'] as List)[0]),
      ) as T;
    }
    if (t == List<(_i142.SimpleData,)>) {
      return (data as List)
          .map((e) => deserialize<(_i142.SimpleData,)>(e))
          .toList() as T;
    }
    if (t == _i1.getType<(_i142.SimpleData,)>()) {
      return (deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i142.SimpleData,)>()) {
      return (deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),)
          as T;
    }
    if (t == _i1.getType<(_i142.SimpleData, Map<String, _i142.SimpleData>)>()) {
      return (
        deserialize<_i142.SimpleData>(((data as Map)['p'] as List)[0]),
        deserialize<Map<String, _i142.SimpleData>>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<Set<(int,)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int,)>()) {
      return (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i1.getType<Set<(int,)?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(int,)?>(e)).toSet()
          : null) as T;
    }
    if (t == _i1.getType<(int,)?>()) {
      return (data == null)
          ? null as T
          : (deserialize<int>(((data as Map)['p'] as List)[0]),) as T;
    }
    if (t == _i159.CustomClass) {
      return _i159.CustomClass.fromJson(data) as T;
    }
    if (t == _i159.CustomClass2) {
      return _i159.CustomClass2.fromJson(data) as T;
    }
    if (t == _i159.ProtocolCustomClass) {
      return _i159.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i159.ExternalCustomClass) {
      return _i159.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i159.FreezedCustomClass) {
      return _i159.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i159.CustomClass?>()) {
      return (data != null ? _i159.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i159.CustomClass2?>()) {
      return (data != null ? _i159.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i159.CustomClassWithoutProtocolSerialization?>()) {
      return (data != null
          ? _i159.CustomClassWithoutProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i159.CustomClassWithProtocolSerialization?>()) {
      return (data != null
          ? _i159.CustomClassWithProtocolSerialization.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i159.CustomClassWithProtocolSerializationMethod?>()) {
      return (data != null
          ? _i159.CustomClassWithProtocolSerializationMethod.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i159.ProtocolCustomClass?>()) {
      return (data != null ? _i159.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i159.ExternalCustomClass?>()) {
      return (data != null ? _i159.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i159.FreezedCustomClass?>()) {
      return (data != null ? _i159.FreezedCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<List<_i160.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i160.SimpleData>(e)).toList()
          : null) as T;
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
    if (t ==
        _i1.getType<
            List<
                (
                  (int, String), {
                  (_i160.SimpleData, double) namedSubRecord
                })?>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<
                  (
                    (int, String), {
                    (_i160.SimpleData, double) namedSubRecord
                  })?>(e))
              .toList()
          : null) as T;
    }
    if (t ==
        _i1.getType<
            ((int, String), {(_i160.SimpleData, double) namedSubRecord})?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<(int, String)>(((data as Map)['p'] as List)[0]),
              namedSubRecord: deserialize<(_i160.SimpleData, double)>(
                  data['n']['namedSubRecord']),
            ) as T;
    }
    if (t ==
        _i1.getType<
            (
              String,
              (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
            )>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<
            (
              Map<String, int>, {
              bool flag,
              _i160.SimpleData simpleData
            })>(data['p'][1]),
      ) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
    }
    if (t ==
        _i1.getType<
            (
              String,
              (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
            )?>()) {
      return (data == null)
          ? null as T
          : (
              deserialize<String>(((data as Map)['p'] as List)[0]),
              deserialize<
                  (
                    Map<String, int>, {
                    bool flag,
                    _i160.SimpleData simpleData
                  })>(data['p'][1]),
            ) as T;
    }
    if (t == _i1.getType<List<(String, int)>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<(String, int)>(e)).toList()
          : null) as T;
    }
    if (t == _i1.getType<(String, int)>()) {
      return (
        deserialize<String>(((data as Map)['p'] as List)[0]),
        deserialize<int>(data['p'][1]),
      ) as T;
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
    switch (data) {
      case _i159.CustomClass():
        return 'CustomClass';
      case _i159.CustomClass2():
        return 'CustomClass2';
      case _i159.CustomClassWithoutProtocolSerialization():
        return 'CustomClassWithoutProtocolSerialization';
      case _i159.CustomClassWithProtocolSerialization():
        return 'CustomClassWithProtocolSerialization';
      case _i159.CustomClassWithProtocolSerializationMethod():
        return 'CustomClassWithProtocolSerializationMethod';
      case _i159.ProtocolCustomClass():
        return 'ProtocolCustomClass';
      case _i159.ExternalCustomClass():
        return 'ExternalCustomClass';
      case _i159.FreezedCustomClass():
        return 'FreezedCustomClass';
      case _i5.ScopeServerOnlyFieldChild():
        return 'ScopeServerOnlyFieldChild';
      case _i6.ChildClass():
        return 'ChildClass';
      case _i7.ChildWithDefault():
        return 'ChildWithDefault';
      case _i8.ParentClass():
        return 'ParentClass';
      case _i9.SealedGrandChild():
        return 'SealedGrandChild';
      case _i9.SealedChild():
        return 'SealedChild';
      case _i9.SealedOtherChild():
        return 'SealedOtherChild';
      case _i10.UriDefault():
        return 'UriDefault';
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
      case _i19.BigIntDefault():
        return 'BigIntDefault';
      case _i20.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i21.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _i22.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _i23.BoolDefault():
        return 'BoolDefault';
      case _i24.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _i25.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i26.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _i27.DateTimeDefault():
        return 'DateTimeDefault';
      case _i28.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _i29.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _i30.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _i31.DoubleDefault():
        return 'DoubleDefault';
      case _i32.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i33.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _i34.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _i35.DurationDefault():
        return 'DurationDefault';
      case _i36.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i37.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _i38.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _i39.EnumDefault():
        return 'EnumDefault';
      case _i40.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _i41.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i42.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i43.ByIndexEnum():
        return 'ByIndexEnum';
      case _i44.ByNameEnum():
        return 'ByNameEnum';
      case _i45.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _i46.DefaultException():
        return 'DefaultException';
      case _i47.IntDefault():
        return 'IntDefault';
      case _i48.IntDefaultMix():
        return 'IntDefaultMix';
      case _i49.IntDefaultModel():
        return 'IntDefaultModel';
      case _i50.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i51.StringDefault():
        return 'StringDefault';
      case _i52.StringDefaultMix():
        return 'StringDefaultMix';
      case _i53.StringDefaultModel():
        return 'StringDefaultModel';
      case _i54.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i55.ByIndexEnumWithNameValue():
        return 'ByIndexEnumWithNameValue';
      case _i56.UriDefaultMix():
        return 'UriDefaultMix';
      case _i57.UriDefaultModel():
        return 'UriDefaultModel';
      case _i58.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _i59.UuidDefault():
        return 'UuidDefault';
      case _i60.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i61.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i62.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _i63.EmptyModel():
        return 'EmptyModel';
      case _i64.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _i65.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _i66.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _i67.ExceptionWithData():
        return 'ExceptionWithData';
      case _i68.ByNameEnumWithNameValue():
        return 'ByNameEnumWithNameValue';
      case _i69.CourseUuid():
        return 'CourseUuid';
      case _i70.GrandparentClass():
        return 'GrandparentClass';
      case _i71.EnrollmentInt():
        return 'EnrollmentInt';
      case _i72.ParentWithDefault():
        return 'ParentWithDefault';
      case _i73.StudentUuid():
        return 'StudentUuid';
      case _i74.ArenaUuid():
        return 'ArenaUuid';
      case _i75.PlayerUuid():
        return 'PlayerUuid';
      case _i76.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i77.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i78.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i79.MaxFieldName():
        return 'MaxFieldName';
      case _i80.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i81.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i82.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i83.UserNote():
        return 'UserNote';
      case _i84.UserNoteCollection():
        return 'UserNoteCollection';
      case _i85.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i86.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i87.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i88.City():
        return 'City';
      case _i89.Organization():
        return 'Organization';
      case _i90.Person():
        return 'Person';
      case _i91.Course():
        return 'Course';
      case _i92.Enrollment():
        return 'Enrollment';
      case _i93.Student():
        return 'Student';
      case _i94.ObjectUser():
        return 'ObjectUser';
      case _i95.ParentUser():
        return 'ParentUser';
      case _i96.Arena():
        return 'Arena';
      case _i97.Player():
        return 'Player';
      case _i98.Team():
        return 'Team';
      case _i99.Comment():
        return 'Comment';
      case _i100.Customer():
        return 'Customer';
      case _i101.Book():
        return 'Book';
      case _i102.Chapter():
        return 'Chapter';
      case _i103.Order():
        return 'Order';
      case _i104.Address():
        return 'Address';
      case _i105.MyFeatureModel():
        return 'MyFeatureModel';
      case _i106.Company():
        return 'Company';
      case _i107.Town():
        return 'Town';
      case _i108.Blocking():
        return 'Blocking';
      case _i109.Member():
        return 'Member';
      case _i110.Cat():
        return 'Cat';
      case _i111.Post():
        return 'Post';
      case _i112.ModuleDatatype():
        return 'ModuleDatatype';
      case _i113.Nullability():
        return 'Nullability';
      case _i114.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i115.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i116.ObjectWithBit():
        return 'ObjectWithBit';
      case _i117.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i118.ObjectWithCustomClass():
        return 'ObjectWithCustomClass';
      case _i119.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i120.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i121.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i122.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i123.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i124.ObjectWithObject():
        return 'ObjectWithObject';
      case _i125.ObjectWithParent():
        return 'ObjectWithParent';
      case _i126.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i127.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i128.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i129.ObjectWithVector():
        return 'ObjectWithVector';
      case _i130.Record():
        return 'Record';
      case _i131.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i132.ScopeNoneFields():
        return 'ScopeNoneFields';
      case _i133.ScopeServerOnlyField():
        return 'ScopeServerOnlyField';
      case _i134.TeamInt():
        return 'TeamInt';
      case _i135.DefaultServerOnlyClass():
        return 'DefaultServerOnlyClass';
      case _i136.DefaultServerOnlyEnum():
        return 'DefaultServerOnlyEnum';
      case _i137.NotServerOnlyClass():
        return 'NotServerOnlyClass';
      case _i138.NotServerOnlyEnum():
        return 'NotServerOnlyEnum';
      case _i139.ServerOnlyClass():
        return 'ServerOnlyClass';
      case _i140.ServerOnlyEnum():
        return 'ServerOnlyEnum';
      case _i141.ServerOnlyClassField():
        return 'ServerOnlyClassField';
      case _i142.SimpleData():
        return 'SimpleData';
      case _i143.SimpleDataList():
        return 'SimpleDataList';
      case _i144.SimpleDataMap():
        return 'SimpleDataMap';
      case _i145.SimpleDataObject():
        return 'SimpleDataObject';
      case _i146.SimpleDateTime():
        return 'SimpleDateTime';
      case _i147.ModelInSubfolder():
        return 'ModelInSubfolder';
      case _i148.TestEnum():
        return 'TestEnum';
      case _i149.TestEnumStringified():
        return 'TestEnumStringified';
      case _i150.Types():
        return 'Types';
      case _i151.TypesList():
        return 'TypesList';
      case _i152.TypesMap():
        return 'TypesMap';
      case _i153.TypesRecord():
        return 'TypesRecord';
      case _i154.TypesSet():
        return 'TypesSet';
      case _i155.TypesSetRequired():
        return 'TypesSetRequired';
      case _i156.UniqueData():
        return 'UniqueData';
      case _i157.Citizen():
        return 'Citizen';
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
    if (data is List<_i160.SimpleData>) {
      return 'List<SimpleData>';
    }
    if (data is List<_i3.UserInfo>) {
      return 'List<serverpod_auth.UserInfo>';
    }
    if (data is List<_i160.SimpleData>?) {
      return 'List<SimpleData>?';
    }
    if (data is List<_i160.SimpleData?>) {
      return 'List<SimpleData?>';
    }
    if (data is Set<int>) {
      return 'Set<int>';
    }
    if (data is Set<_i160.SimpleData>) {
      return 'Set<SimpleData>';
    }
    if (data is List<Set<_i160.SimpleData>>) {
      return 'List<Set<SimpleData>>';
    }
    if (data is (int?,)?) {
      return '(int?,)?';
    }
    if (data is List<
        ((int, String), {(_i160.SimpleData, double) namedSubRecord})?>?) {
      return 'List<((int,String),{(SimpleData,double) namedSubRecord})?>?';
    }
    if (data is (
      String,
      (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
    )) {
      return '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))';
    }
    if (data is List<(String, int)>) {
      return 'List<(String,int)>';
    }
    if (data is (
      String,
      (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
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
      return deserialize<_i159.CustomClass>(data['data']);
    }
    if (dataClassName == 'CustomClass2') {
      return deserialize<_i159.CustomClass2>(data['data']);
    }
    if (dataClassName == 'CustomClassWithoutProtocolSerialization') {
      return deserialize<_i159.CustomClassWithoutProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerialization') {
      return deserialize<_i159.CustomClassWithProtocolSerialization>(
          data['data']);
    }
    if (dataClassName == 'CustomClassWithProtocolSerializationMethod') {
      return deserialize<_i159.CustomClassWithProtocolSerializationMethod>(
          data['data']);
    }
    if (dataClassName == 'ProtocolCustomClass') {
      return deserialize<_i159.ProtocolCustomClass>(data['data']);
    }
    if (dataClassName == 'ExternalCustomClass') {
      return deserialize<_i159.ExternalCustomClass>(data['data']);
    }
    if (dataClassName == 'FreezedCustomClass') {
      return deserialize<_i159.FreezedCustomClass>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyFieldChild') {
      return deserialize<_i5.ScopeServerOnlyFieldChild>(data['data']);
    }
    if (dataClassName == 'ChildClass') {
      return deserialize<_i6.ChildClass>(data['data']);
    }
    if (dataClassName == 'ChildWithDefault') {
      return deserialize<_i7.ChildWithDefault>(data['data']);
    }
    if (dataClassName == 'ParentClass') {
      return deserialize<_i8.ParentClass>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i9.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i9.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i9.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i10.UriDefault>(data['data']);
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
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i19.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i20.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i21.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i22.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i23.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i24.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i25.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i26.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i27.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i28.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i29.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i30.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i31.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i32.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i33.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i34.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i35.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i36.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i37.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i38.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i39.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i40.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i41.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i42.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i43.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i44.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_i45.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i46.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i47.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i48.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i49.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i50.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i51.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i52.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i53.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i54.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnumWithNameValue') {
      return deserialize<_i55.ByIndexEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i56.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i57.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i58.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i59.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i60.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i61.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i62.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i63.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i64.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i65.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i66.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ExceptionWithData') {
      return deserialize<_i67.ExceptionWithData>(data['data']);
    }
    if (dataClassName == 'ByNameEnumWithNameValue') {
      return deserialize<_i68.ByNameEnumWithNameValue>(data['data']);
    }
    if (dataClassName == 'CourseUuid') {
      return deserialize<_i69.CourseUuid>(data['data']);
    }
    if (dataClassName == 'GrandparentClass') {
      return deserialize<_i70.GrandparentClass>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i71.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'ParentWithDefault') {
      return deserialize<_i72.ParentWithDefault>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i73.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i74.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i75.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i76.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i77.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i78.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i79.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i80.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i81.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i82.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i83.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i84.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i85.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i86.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i87.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i88.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i89.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i90.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i91.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i92.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i93.Student>(data['data']);
    }
    if (dataClassName == 'ObjectUser') {
      return deserialize<_i94.ObjectUser>(data['data']);
    }
    if (dataClassName == 'ParentUser') {
      return deserialize<_i95.ParentUser>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i96.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i97.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i98.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i99.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i100.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i101.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i102.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i103.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i104.Address>(data['data']);
    }
    if (dataClassName == 'MyFeatureModel') {
      return deserialize<_i105.MyFeatureModel>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i106.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i107.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i108.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i109.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i110.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i111.Post>(data['data']);
    }
    if (dataClassName == 'ModuleDatatype') {
      return deserialize<_i112.ModuleDatatype>(data['data']);
    }
    if (dataClassName == 'Nullability') {
      return deserialize<_i113.Nullability>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i114.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i115.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i116.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i117.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithCustomClass') {
      return deserialize<_i118.ObjectWithCustomClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i119.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i120.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i121.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i122.ObjectWithIndex>(data['data']);
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
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i126.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i127.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i128.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i129.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'Record') {
      return deserialize<_i130.Record>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i131.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ScopeNoneFields') {
      return deserialize<_i132.ScopeNoneFields>(data['data']);
    }
    if (dataClassName == 'ScopeServerOnlyField') {
      return deserialize<_i133.ScopeServerOnlyField>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i134.TeamInt>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyClass') {
      return deserialize<_i135.DefaultServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'DefaultServerOnlyEnum') {
      return deserialize<_i136.DefaultServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyClass') {
      return deserialize<_i137.NotServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'NotServerOnlyEnum') {
      return deserialize<_i138.NotServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClass') {
      return deserialize<_i139.ServerOnlyClass>(data['data']);
    }
    if (dataClassName == 'ServerOnlyEnum') {
      return deserialize<_i140.ServerOnlyEnum>(data['data']);
    }
    if (dataClassName == 'ServerOnlyClassField') {
      return deserialize<_i141.ServerOnlyClassField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i142.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDataList') {
      return deserialize<_i143.SimpleDataList>(data['data']);
    }
    if (dataClassName == 'SimpleDataMap') {
      return deserialize<_i144.SimpleDataMap>(data['data']);
    }
    if (dataClassName == 'SimpleDataObject') {
      return deserialize<_i145.SimpleDataObject>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i146.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'ModelInSubfolder') {
      return deserialize<_i147.ModelInSubfolder>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i148.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i149.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i150.Types>(data['data']);
    }
    if (dataClassName == 'TypesList') {
      return deserialize<_i151.TypesList>(data['data']);
    }
    if (dataClassName == 'TypesMap') {
      return deserialize<_i152.TypesMap>(data['data']);
    }
    if (dataClassName == 'TypesRecord') {
      return deserialize<_i153.TypesRecord>(data['data']);
    }
    if (dataClassName == 'TypesSet') {
      return deserialize<_i154.TypesSet>(data['data']);
    }
    if (dataClassName == 'TypesSetRequired') {
      return deserialize<_i155.TypesSetRequired>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i156.UniqueData>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i157.Citizen>(data['data']);
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
      return deserialize<List<_i160.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<serverpod_auth.UserInfo>') {
      return deserialize<List<_i3.UserInfo>>(data['data']);
    }
    if (dataClassName == 'List<SimpleData>?') {
      return deserialize<List<_i160.SimpleData>?>(data['data']);
    }
    if (dataClassName == 'List<SimpleData?>') {
      return deserialize<List<_i160.SimpleData?>>(data['data']);
    }
    if (dataClassName == 'Set<int>') {
      return deserialize<Set<int>>(data['data']);
    }
    if (dataClassName == 'Set<SimpleData>') {
      return deserialize<Set<_i160.SimpleData>>(data['data']);
    }
    if (dataClassName == 'List<Set<SimpleData>>') {
      return deserialize<List<Set<_i160.SimpleData>>>(data['data']);
    }
    if (dataClassName == '(int?,)?') {
      return deserialize<(int?,)?>(data['data']);
    }
    if (dataClassName ==
        'List<((int,String),{(SimpleData,double) namedSubRecord})?>?') {
      return deserialize<
          List<
              (
                (int, String), {
                (_i160.SimpleData, double) namedSubRecord
              })?>?>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))') {
      return deserialize<
          (
            String,
            (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
          )>(data['data']);
    }
    if (dataClassName == 'List<(String,int)>') {
      return deserialize<List<(String, int)>>(data['data']);
    }
    if (dataClassName ==
        '(String,(Map<String,int>,{bool flag,SimpleData simpleData}))?') {
      return deserialize<
          (
            String,
            (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
          )?>(data['data']);
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
      case _i69.CourseUuid:
        return _i69.CourseUuid.t;
      case _i71.EnrollmentInt:
        return _i71.EnrollmentInt.t;
      case _i73.StudentUuid:
        return _i73.StudentUuid.t;
      case _i74.ArenaUuid:
        return _i74.ArenaUuid.t;
      case _i75.PlayerUuid:
        return _i75.PlayerUuid.t;
      case _i134.TeamInt:
        return _i134.TeamInt.t;
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
      case _i19.BigIntDefault:
        return _i19.BigIntDefault.t;
      case _i20.BigIntDefaultMix:
        return _i20.BigIntDefaultMix.t;
      case _i21.BigIntDefaultModel:
        return _i21.BigIntDefaultModel.t;
      case _i22.BigIntDefaultPersist:
        return _i22.BigIntDefaultPersist.t;
      case _i23.BoolDefault:
        return _i23.BoolDefault.t;
      case _i24.BoolDefaultMix:
        return _i24.BoolDefaultMix.t;
      case _i25.BoolDefaultModel:
        return _i25.BoolDefaultModel.t;
      case _i26.BoolDefaultPersist:
        return _i26.BoolDefaultPersist.t;
      case _i27.DateTimeDefault:
        return _i27.DateTimeDefault.t;
      case _i28.DateTimeDefaultMix:
        return _i28.DateTimeDefaultMix.t;
      case _i29.DateTimeDefaultModel:
        return _i29.DateTimeDefaultModel.t;
      case _i30.DateTimeDefaultPersist:
        return _i30.DateTimeDefaultPersist.t;
      case _i31.DoubleDefault:
        return _i31.DoubleDefault.t;
      case _i32.DoubleDefaultMix:
        return _i32.DoubleDefaultMix.t;
      case _i33.DoubleDefaultModel:
        return _i33.DoubleDefaultModel.t;
      case _i34.DoubleDefaultPersist:
        return _i34.DoubleDefaultPersist.t;
      case _i35.DurationDefault:
        return _i35.DurationDefault.t;
      case _i36.DurationDefaultMix:
        return _i36.DurationDefaultMix.t;
      case _i37.DurationDefaultModel:
        return _i37.DurationDefaultModel.t;
      case _i38.DurationDefaultPersist:
        return _i38.DurationDefaultPersist.t;
      case _i39.EnumDefault:
        return _i39.EnumDefault.t;
      case _i40.EnumDefaultMix:
        return _i40.EnumDefaultMix.t;
      case _i41.EnumDefaultModel:
        return _i41.EnumDefaultModel.t;
      case _i42.EnumDefaultPersist:
        return _i42.EnumDefaultPersist.t;
      case _i47.IntDefault:
        return _i47.IntDefault.t;
      case _i48.IntDefaultMix:
        return _i48.IntDefaultMix.t;
      case _i49.IntDefaultModel:
        return _i49.IntDefaultModel.t;
      case _i50.IntDefaultPersist:
        return _i50.IntDefaultPersist.t;
      case _i51.StringDefault:
        return _i51.StringDefault.t;
      case _i52.StringDefaultMix:
        return _i52.StringDefaultMix.t;
      case _i53.StringDefaultModel:
        return _i53.StringDefaultModel.t;
      case _i54.StringDefaultPersist:
        return _i54.StringDefaultPersist.t;
      case _i10.UriDefault:
        return _i10.UriDefault.t;
      case _i56.UriDefaultMix:
        return _i56.UriDefaultMix.t;
      case _i57.UriDefaultModel:
        return _i57.UriDefaultModel.t;
      case _i58.UriDefaultPersist:
        return _i58.UriDefaultPersist.t;
      case _i59.UuidDefault:
        return _i59.UuidDefault.t;
      case _i60.UuidDefaultMix:
        return _i60.UuidDefaultMix.t;
      case _i61.UuidDefaultModel:
        return _i61.UuidDefaultModel.t;
      case _i62.UuidDefaultPersist:
        return _i62.UuidDefaultPersist.t;
      case _i64.EmptyModelRelationItem:
        return _i64.EmptyModelRelationItem.t;
      case _i65.EmptyModelWithTable:
        return _i65.EmptyModelWithTable.t;
      case _i66.RelationEmptyModel:
        return _i66.RelationEmptyModel.t;
      case _i8.ParentClass:
        return _i8.ParentClass.t;
      case _i76.CityWithLongTableName:
        return _i76.CityWithLongTableName.t;
      case _i77.OrganizationWithLongTableName:
        return _i77.OrganizationWithLongTableName.t;
      case _i78.PersonWithLongTableName:
        return _i78.PersonWithLongTableName.t;
      case _i79.MaxFieldName:
        return _i79.MaxFieldName.t;
      case _i80.LongImplicitIdField:
        return _i80.LongImplicitIdField.t;
      case _i81.LongImplicitIdFieldCollection:
        return _i81.LongImplicitIdFieldCollection.t;
      case _i82.RelationToMultipleMaxFieldName:
        return _i82.RelationToMultipleMaxFieldName.t;
      case _i83.UserNote:
        return _i83.UserNote.t;
      case _i84.UserNoteCollection:
        return _i84.UserNoteCollection.t;
      case _i85.UserNoteCollectionWithALongName:
        return _i85.UserNoteCollectionWithALongName.t;
      case _i86.UserNoteWithALongName:
        return _i86.UserNoteWithALongName.t;
      case _i87.MultipleMaxFieldName:
        return _i87.MultipleMaxFieldName.t;
      case _i88.City:
        return _i88.City.t;
      case _i89.Organization:
        return _i89.Organization.t;
      case _i90.Person:
        return _i90.Person.t;
      case _i91.Course:
        return _i91.Course.t;
      case _i92.Enrollment:
        return _i92.Enrollment.t;
      case _i93.Student:
        return _i93.Student.t;
      case _i94.ObjectUser:
        return _i94.ObjectUser.t;
      case _i95.ParentUser:
        return _i95.ParentUser.t;
      case _i96.Arena:
        return _i96.Arena.t;
      case _i97.Player:
        return _i97.Player.t;
      case _i98.Team:
        return _i98.Team.t;
      case _i99.Comment:
        return _i99.Comment.t;
      case _i100.Customer:
        return _i100.Customer.t;
      case _i101.Book:
        return _i101.Book.t;
      case _i102.Chapter:
        return _i102.Chapter.t;
      case _i103.Order:
        return _i103.Order.t;
      case _i104.Address:
        return _i104.Address.t;
      case _i157.Citizen:
        return _i157.Citizen.t;
      case _i106.Company:
        return _i106.Company.t;
      case _i107.Town:
        return _i107.Town.t;
      case _i108.Blocking:
        return _i108.Blocking.t;
      case _i109.Member:
        return _i109.Member.t;
      case _i110.Cat:
        return _i110.Cat.t;
      case _i111.Post:
        return _i111.Post.t;
      case _i114.ObjectFieldPersist:
        return _i114.ObjectFieldPersist.t;
      case _i115.ObjectFieldScopes:
        return _i115.ObjectFieldScopes.t;
      case _i116.ObjectWithBit:
        return _i116.ObjectWithBit.t;
      case _i117.ObjectWithByteData:
        return _i117.ObjectWithByteData.t;
      case _i119.ObjectWithDuration:
        return _i119.ObjectWithDuration.t;
      case _i120.ObjectWithEnum:
        return _i120.ObjectWithEnum.t;
      case _i121.ObjectWithHalfVector:
        return _i121.ObjectWithHalfVector.t;
      case _i122.ObjectWithIndex:
        return _i122.ObjectWithIndex.t;
      case _i124.ObjectWithObject:
        return _i124.ObjectWithObject.t;
      case _i125.ObjectWithParent:
        return _i125.ObjectWithParent.t;
      case _i126.ObjectWithSelfParent:
        return _i126.ObjectWithSelfParent.t;
      case _i127.ObjectWithSparseVector:
        return _i127.ObjectWithSparseVector.t;
      case _i128.ObjectWithUuid:
        return _i128.ObjectWithUuid.t;
      case _i129.ObjectWithVector:
        return _i129.ObjectWithVector.t;
      case _i131.RelatedUniqueData:
        return _i131.RelatedUniqueData.t;
      case _i132.ScopeNoneFields:
        return _i132.ScopeNoneFields.t;
      case _i142.SimpleData:
        return _i142.SimpleData.t;
      case _i146.SimpleDateTime:
        return _i146.SimpleDateTime.t;
      case _i150.Types:
        return _i150.Types.t;
      case _i156.UniqueData:
        return _i156.UniqueData.t;
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
    /// In case the value (to be streamed) contains a record, we need to map it before it reaches the underlying JSON encode
    if (data is Iterable || data is Map) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordContainingContainerToJson(data!),
      };
    } else if (data is Record) {
      return {
        'className': getClassNameForObject(data)!,
        'data': mapRecordToJson(data),
      };
    }

    return super.wrapWithClassName(data);
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
  if (record is (int, BigInt)) {
    return {
      "p": [
        record.$1,
        record.$2,
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
  if (record is (int, _i160.SimpleData)) {
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
  if (record is ({_i160.SimpleData data, int number})) {
    return {
      "n": {
        "data": record.data,
        "number": record.number,
      },
    };
  }
  if (record is ({_i160.SimpleData? data, int? number})) {
    return {
      "n": {
        "data": record.data,
        "number": record.number,
      },
    };
  }
  if (record is (int, {_i160.SimpleData data})) {
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
  if (record is ({(_i160.SimpleData, double) namedSubRecord})) {
    return {
      "n": {
        "namedSubRecord": mapRecordToJson(record.namedSubRecord),
      },
    };
  }
  if (record is (_i160.SimpleData, double)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is ({(_i160.SimpleData, double)? namedSubRecord})) {
    return {
      "n": {
        "namedSubRecord": mapRecordToJson(record.namedSubRecord),
      },
    };
  }
  if (record is ((int, String), {(_i160.SimpleData, double) namedSubRecord})) {
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
  if (record is (
    String,
    (Map<String, int>, {bool flag, _i160.SimpleData simpleData})
  )) {
    return {
      "p": [
        record.$1,
        mapRecordToJson(record.$2),
      ],
    };
  }
  if (record is (Map<String, int>, {bool flag, _i160.SimpleData simpleData})) {
    return {
      "p": [
        record.$1,
      ],
      "n": {
        "flag": record.flag,
        "simpleData": record.simpleData,
      },
    };
  }
  if (record is (_i4.ModuleClass,)) {
    return {
      "p": [
        record.$1,
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
  if (record is (_i149.TestEnumStringified,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (_i113.Nullability,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is ({_i149.TestEnumStringified value})) {
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
  if (record is ({_i113.Nullability value})) {
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
  if (record is (_i148.TestEnum,)) {
    return {
      "p": [
        record.$1,
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
        record.$1,
      ],
    };
  }
  if (record is (_i158.ByteData,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (Duration,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (_i1.UuidValue,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (Uri,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (BigInt,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (List<int>,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (Map<int, int>,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (Set<int>,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (_i142.SimpleData,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is ({_i142.SimpleData namedModel})) {
    return {
      "n": {
        "namedModel": record.namedModel,
      },
    };
  }
  if (record is (_i142.SimpleData, {_i142.SimpleData namedModel})) {
    return {
      "p": [
        record.$1,
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
  if (record is (int, String)) {
    return {
      "p": [
        record.$1,
        record.$2,
      ],
    };
  }
  if (record is (
    (List<(_i142.SimpleData,)>,), {
    (_i142.SimpleData, Map<String, _i142.SimpleData>) namedNestedRecord
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
  if (record is (List<(_i142.SimpleData,)>,)) {
    return {
      "p": [
        record.$1,
      ],
    };
  }
  if (record is (_i142.SimpleData, Map<String, _i142.SimpleData>)) {
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
