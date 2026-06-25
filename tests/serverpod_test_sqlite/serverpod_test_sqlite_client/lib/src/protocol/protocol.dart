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
import 'package:serverpod_database/serverpod_database.dart' as _i1;
import 'package:serverpod_auth_core_client/serverpod_auth_core_client.dart'
    as _i2;
import 'package:serverpod_auth_idp_client/serverpod_auth_idp_client.dart'
    as _i3;
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
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i66;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i67;
import 'explicit_column_name/modified_column_name.dart' as _i68;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i69;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i70;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i71;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i72;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i73;
import 'inheritance/sealed_parent.dart' as _i74;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i75;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i76;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i77;
import 'long_identifiers/max_field_name.dart' as _i78;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i79;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i80;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i81;
import 'long_identifiers/models_with_relations/user_note.dart' as _i82;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i83;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i84;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i85;
import 'long_identifiers/multiple_max_field_name.dart' as _i86;
import 'models_with_list_relations/city.dart' as _i87;
import 'models_with_list_relations/organization.dart' as _i88;
import 'models_with_list_relations/person.dart' as _i89;
import 'models_with_relations/many_to_many/course.dart' as _i90;
import 'models_with_relations/many_to_many/enrollment.dart' as _i91;
import 'models_with_relations/many_to_many/student.dart' as _i92;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i93;
import 'models_with_relations/nested_one_to_many/player.dart' as _i94;
import 'models_with_relations/nested_one_to_many/team.dart' as _i95;
import 'models_with_relations/one_to_many/comment.dart' as _i96;
import 'models_with_relations/one_to_many/customer.dart' as _i97;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i98;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i99;
import 'models_with_relations/one_to_many/order.dart' as _i100;
import 'models_with_relations/one_to_one/address.dart' as _i101;
import 'models_with_relations/one_to_one/citizen.dart' as _i102;
import 'models_with_relations/one_to_one/company.dart' as _i103;
import 'models_with_relations/one_to_one/town.dart' as _i104;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i105;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i106;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i107;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i108;
import 'object_field_persist.dart' as _i109;
import 'object_field_scopes.dart' as _i110;
import 'object_with_bit.dart' as _i111;
import 'object_with_bytedata.dart' as _i112;
import 'object_with_duration.dart' as _i113;
import 'object_with_dynamic.dart' as _i114;
import 'object_with_enum.dart' as _i115;
import 'object_with_enum_enhanced.dart' as _i116;
import 'object_with_half_vector.dart' as _i117;
import 'object_with_index.dart' as _i118;
import 'object_with_jsonb.dart' as _i119;
import 'object_with_jsonb_class_level.dart' as _i120;
import 'object_with_maps.dart' as _i121;
import 'object_with_object.dart' as _i122;
import 'object_with_parent.dart' as _i123;
import 'object_with_sealed_class.dart' as _i124;
import 'object_with_self_parent.dart' as _i125;
import 'object_with_sparse_vector.dart' as _i126;
import 'object_with_uuid.dart' as _i127;
import 'object_with_vector.dart' as _i128;
import 'related_unique_data.dart' as _i129;
import 'required/model_with_required_field.dart' as _i130;
import 'simple_data.dart' as _i131;
import 'simple_date_time.dart' as _i132;
import 'test_enum.dart' as _i133;
import 'test_enum_default_serialization.dart' as _i134;
import 'test_enum_enhanced.dart' as _i135;
import 'test_enum_enhanced_by_name.dart' as _i136;
import 'test_enum_stringified.dart' as _i137;
import 'types.dart' as _i138;
import 'unique_data.dart' as _i139;
import 'unique_data_with_non_persist.dart' as _i140;
import 'upsert_test_model.dart' as _i141;
import 'package:serverpod_client/serverpod_client.dart' as _i142;
import 'dart:typed_data' as _i143;
import 'package:serverpod_test_sqlite_client/src/protocol/simple_data.dart'
    as _i144;
import 'package:serverpod_service_client/serverpod_service_client.dart'
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
export 'client.dart';

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._().._registerHostProtocols();

  static final List<_i1.TableDefinition> targetTableDefinitions = [
    _i1.TableDefinition(
      name: 'address',
      dartName: 'Address',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'street',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'inhabitantId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'address_fk_0',
          columns: ['inhabitantId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'inhabitant_index_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'arena',
      dartName: 'Arena',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'blocking',
      dartName: 'Blocking',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'blockedId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'blockedById',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'blocking_fk_0',
          columns: ['blockedId'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i1.ForeignKeyDefinition(
          constraintName: 'blocking_fk_1',
          columns: ['blockedById'],
          referenceTable: 'member',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'blocking_blocked_unique_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
              definition: 'blockedId',
            ),
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'book',
      dartName: 'Book',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'title',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'cat',
      dartName: 'Cat',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'motherId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'cat_fk_0',
          columns: ['motherId'],
          referenceTable: 'cat',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'chapter',
      dartName: 'Chapter',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'title',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: '_bookChaptersBookId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'chapter_fk_0',
          columns: ['_bookChaptersBookId'],
          referenceTable: 'book',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'citizen',
      dartName: 'Citizen',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'companyId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'citizen_fk_0',
          columns: ['companyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i1.ForeignKeyDefinition(
          constraintName: 'citizen_fk_1',
          columns: ['oldCompanyId'],
          referenceTable: 'company',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'city',
      dartName: 'City',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'description',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'orderId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'comment_fk_0',
          columns: ['orderId'],
          referenceTable: 'order',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'company',
      dartName: 'Company',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'townId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'company_fk_0',
          columns: ['townId'],
          referenceTable: 'town',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'course',
      dartName: 'Course',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'customer',
      dartName: 'Customer',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'empty_model_relation_item',
      dartName: 'EmptyModelRelationItem',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: '_relationEmptyModelItemsRelationEmptyModelId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'empty_model_relation_item_fk_0',
          columns: ['_relationEmptyModelItemsRelationEmptyModelId'],
          referenceTable: 'relation_empty_model',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'empty_model_with_table',
      dartName: 'EmptyModelWithTable',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'enrollment',
      dartName: 'Enrollment',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'studentId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'courseId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_0',
          columns: ['studentId'],
          referenceTable: 'student',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
        _i1.ForeignKeyDefinition(
          constraintName: 'enrollment_fk_1',
          columns: ['courseId'],
          referenceTable: 'course',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'enrollment_index_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
              definition: 'studentId',
            ),
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'member',
      dartName: 'Member',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'model_with_required_field',
      dartName: 'ModelWithRequiredField',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'email',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i1.ColumnDefinition(
          name: 'phone',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'object_field_persist',
      dartName: 'ObjectFieldPersist',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'normal',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'order',
      dartName: 'Order',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'description',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'customerId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'order_fk_0',
          columns: ['customerId'],
          referenceTable: 'customer',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.cascade,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'organization',
      dartName: 'Organization',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'cityId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'organization_fk_0',
          columns: ['cityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'person',
      dartName: 'Person',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'organizationId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i1.ColumnDefinition(
          name: '_cityCitizensCityId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'person_fk_0',
          columns: ['organizationId'],
          referenceTable: 'organization',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
        _i1.ForeignKeyDefinition(
          constraintName: 'person_fk_1',
          columns: ['_cityCitizensCityId'],
          referenceTable: 'city',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'player',
      dartName: 'Player',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'teamId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'player_fk_0',
          columns: ['teamId'],
          referenceTable: 'team',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'post',
      dartName: 'Post',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'content',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'nextId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'post_fk_0',
          columns: ['nextId'],
          referenceTable: 'post',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'next_unique_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'related_unique_data',
      dartName: 'RelatedUniqueData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'uniqueDataId',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'number',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'related_unique_data_fk_0',
          columns: ['uniqueDataId'],
          referenceTable: 'unique_data',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.restrict,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'relation_empty_model',
      dartName: 'RelationEmptyModel',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'num',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'simple_date_time',
      dartName: 'SimpleDateTime',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'dateTime',
          columnType: _i1.ColumnType.timestampWithoutTimeZone,
          isNullable: false,
          dartType: 'DateTime',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'student',
      dartName: 'Student',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'team',
      dartName: 'Team',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'arenaId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'team_fk_0',
          columns: ['arenaId'],
          referenceTable: 'arena',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.setNull,
          matchType: null,
        ),
      ],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'arena_index_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'town',
      dartName: 'Town',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'name',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
        _i1.ColumnDefinition(
          name: 'mayorId',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
      ],
      foreignKeys: [
        _i1.ForeignKeyDefinition(
          constraintName: 'town_fk_0',
          columns: ['mayorId'],
          referenceTable: 'citizen',
          referenceTableSchema: 'public',
          referenceColumns: ['id'],
          onUpdate: _i1.ForeignKeyAction.noAction,
          onDelete: _i1.ForeignKeyAction.noAction,
          matchType: null,
        ),
      ],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'types',
      dartName: 'Types',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'anInt',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'int?',
        ),
        _i1.ColumnDefinition(
          name: 'aBool',
          columnType: _i1.ColumnType.boolean,
          isNullable: true,
          dartType: 'bool?',
        ),
        _i1.ColumnDefinition(
          name: 'aDouble',
          columnType: _i1.ColumnType.doublePrecision,
          isNullable: true,
          dartType: 'double?',
        ),
        _i1.ColumnDefinition(
          name: 'aDateTime',
          columnType: _i1.ColumnType.timestampWithoutTimeZone,
          isNullable: true,
          dartType: 'DateTime?',
        ),
        _i1.ColumnDefinition(
          name: 'aString',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'String?',
        ),
        _i1.ColumnDefinition(
          name: 'aByteData',
          columnType: _i1.ColumnType.bytea,
          isNullable: true,
          dartType: 'dart:typed_data:ByteData?',
        ),
        _i1.ColumnDefinition(
          name: 'aDuration',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'Duration?',
        ),
        _i1.ColumnDefinition(
          name: 'aUuid',
          columnType: _i1.ColumnType.uuid,
          isNullable: true,
          dartType: 'UuidValue?',
        ),
        _i1.ColumnDefinition(
          name: 'aUri',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'Uri?',
        ),
        _i1.ColumnDefinition(
          name: 'aBigInt',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'BigInt?',
        ),
        _i1.ColumnDefinition(
          name: 'aVector',
          columnType: _i1.ColumnType.vector,
          isNullable: true,
          dartType: 'Vector(3)?',
          vectorDimension: 3,
        ),
        _i1.ColumnDefinition(
          name: 'aHalfVector',
          columnType: _i1.ColumnType.halfvec,
          isNullable: true,
          dartType: 'HalfVector(3)?',
          vectorDimension: 3,
        ),
        _i1.ColumnDefinition(
          name: 'aSparseVector',
          columnType: _i1.ColumnType.sparsevec,
          isNullable: true,
          dartType: 'SparseVector(3)?',
          vectorDimension: 3,
        ),
        _i1.ColumnDefinition(
          name: 'aBit',
          columnType: _i1.ColumnType.bit,
          isNullable: true,
          dartType: 'Bit(3)?',
          vectorDimension: 3,
        ),
        _i1.ColumnDefinition(
          name: 'aGeographyPoint',
          columnType: _i1.ColumnType.geography,
          isNullable: true,
          dartType: 'GeographyPoint?',
        ),
        _i1.ColumnDefinition(
          name: 'aGeographyLineString',
          columnType: _i1.ColumnType.geographyLineString,
          isNullable: true,
          dartType: 'GeographyLineString?',
        ),
        _i1.ColumnDefinition(
          name: 'aGeographyPolygon',
          columnType: _i1.ColumnType.geographyPolygon,
          isNullable: true,
          dartType: 'GeographyPolygon?',
        ),
        _i1.ColumnDefinition(
          name: 'aGeographyGeometryCollection',
          columnType: _i1.ColumnType.geographyGeometryCollection,
          isNullable: true,
          dartType: 'GeographyGeometryCollection?',
        ),
        _i1.ColumnDefinition(
          name: 'anEnum',
          columnType: _i1.ColumnType.bigint,
          isNullable: true,
          dartType: 'protocol:TestEnum?',
        ),
        _i1.ColumnDefinition(
          name: 'aStringifiedEnum',
          columnType: _i1.ColumnType.text,
          isNullable: true,
          dartType: 'protocol:TestEnumStringified?',
        ),
        _i1.ColumnDefinition(
          name: 'aList',
          columnType: _i1.ColumnType.json,
          isNullable: true,
          dartType: 'List<int>?',
        ),
        _i1.ColumnDefinition(
          name: 'aMap',
          columnType: _i1.ColumnType.json,
          isNullable: true,
          dartType: 'Map<int,int>?',
        ),
        _i1.ColumnDefinition(
          name: 'aSet',
          columnType: _i1.ColumnType.json,
          isNullable: true,
          dartType: 'Set<int>?',
        ),
        _i1.ColumnDefinition(
          name: 'aRecord',
          columnType: _i1.ColumnType.json,
          isNullable: true,
          dartType: '(String, {Uri? optionalUri})?',
        ),
      ],
      foreignKeys: [],
      indexes: [],
      managed: true,
    ),
    _i1.TableDefinition(
      name: 'unique_data',
      dartName: 'UniqueData',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'number',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'email',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'email_index_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    _i1.TableDefinition(
      name: 'unique_data_with_non_persist',
      dartName: 'UniqueDataWithNonPersist',
      schema: 'public',
      module: 'serverpod_test_sqlite',
      columns: [
        _i1.ColumnDefinition(
          name: 'id',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'serial',
        ),
        _i1.ColumnDefinition(
          name: 'number',
          columnType: _i1.ColumnType.bigint,
          isNullable: false,
          dartType: 'int',
        ),
        _i1.ColumnDefinition(
          name: 'email',
          columnType: _i1.ColumnType.text,
          isNullable: false,
          dartType: 'String',
        ),
      ],
      foreignKeys: [],
      indexes: [
        _i1.IndexDefinition(
          indexName: 'unique_email_idx',
          tableSpace: null,
          elements: [
            _i1.IndexElementDefinition(
              type: _i1.IndexElementDefinitionType.column,
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
    ..._i2.Protocol() is _i1.DatabaseSerializationManager
        ? (_i2.Protocol() as _i1.DatabaseSerializationManager)
              .getTargetTableDefinitions()
        : [],
    ..._i3.Protocol() is _i1.DatabaseSerializationManager
        ? (_i3.Protocol() as _i1.DatabaseSerializationManager)
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
    if (t == _i30.DoubleDefault) {
      return _i30.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i31.DoubleDefaultMix) {
      return _i31.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i32.DoubleDefaultModel) {
      return _i32.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i33.DoubleDefaultPersist) {
      return _i33.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i34.DurationDefault) {
      return _i34.DurationDefault.fromJson(data) as T;
    }
    if (t == _i35.DurationDefaultMix) {
      return _i35.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i36.DurationDefaultModel) {
      return _i36.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i37.DurationDefaultPersist) {
      return _i37.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i38.EnumDefault) {
      return _i38.EnumDefault.fromJson(data) as T;
    }
    if (t == _i39.EnumDefaultMix) {
      return _i39.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i40.EnumDefaultModel) {
      return _i40.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i41.EnumDefaultPersist) {
      return _i41.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i42.ByIndexEnum) {
      return _i42.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i43.ByNameEnum) {
      return _i43.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i44.DefaultValueEnum) {
      return _i44.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _i45.DefaultException) {
      return _i45.DefaultException.fromJson(data) as T;
    }
    if (t == _i46.IntDefault) {
      return _i46.IntDefault.fromJson(data) as T;
    }
    if (t == _i47.IntDefaultMix) {
      return _i47.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i48.IntDefaultModel) {
      return _i48.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i49.IntDefaultPersist) {
      return _i49.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i50.StringDefault) {
      return _i50.StringDefault.fromJson(data) as T;
    }
    if (t == _i51.StringDefaultMix) {
      return _i51.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i52.StringDefaultModel) {
      return _i52.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i53.StringDefaultPersist) {
      return _i53.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i54.UriDefault) {
      return _i54.UriDefault.fromJson(data) as T;
    }
    if (t == _i55.UriDefaultMix) {
      return _i55.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i56.UriDefaultModel) {
      return _i56.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i57.UriDefaultPersist) {
      return _i57.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i58.UuidDefault) {
      return _i58.UuidDefault.fromJson(data) as T;
    }
    if (t == _i59.UuidDefaultMix) {
      return _i59.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i60.UuidDefaultModel) {
      return _i60.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i61.UuidDefaultPersist) {
      return _i61.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i62.EmptyModel) {
      return _i62.EmptyModel.fromJson(data) as T;
    }
    if (t == _i63.EmptyModelRelationItem) {
      return _i63.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i64.EmptyModelWithTable) {
      return _i64.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i65.RelationEmptyModel) {
      return _i65.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i66.ChildClassExplicitColumn) {
      return _i66.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i67.NonTableParentClass) {
      return _i67.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i68.ModifiedColumnName) {
      return _i68.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _i69.Department) {
      return _i69.Department.fromJson(data) as T;
    }
    if (t == _i70.Employee) {
      return _i70.Employee.fromJson(data) as T;
    }
    if (t == _i71.Contractor) {
      return _i71.Contractor.fromJson(data) as T;
    }
    if (t == _i72.Service) {
      return _i72.Service.fromJson(data) as T;
    }
    if (t == _i73.TableWithExplicitColumnName) {
      return _i73.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _i74.SealedGrandChild) {
      return _i74.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i74.SealedChild) {
      return _i74.SealedChild.fromJson(data) as T;
    }
    if (t == _i74.SealedOtherChild) {
      return _i74.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i75.CityWithLongTableName) {
      return _i75.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i76.OrganizationWithLongTableName) {
      return _i76.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i77.PersonWithLongTableName) {
      return _i77.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i78.MaxFieldName) {
      return _i78.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i79.LongImplicitIdField) {
      return _i79.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i80.LongImplicitIdFieldCollection) {
      return _i80.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i81.RelationToMultipleMaxFieldName) {
      return _i81.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i82.UserNote) {
      return _i82.UserNote.fromJson(data) as T;
    }
    if (t == _i83.UserNoteCollection) {
      return _i83.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i84.UserNoteCollectionWithALongName) {
      return _i84.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i85.UserNoteWithALongName) {
      return _i85.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i86.MultipleMaxFieldName) {
      return _i86.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i87.City) {
      return _i87.City.fromJson(data) as T;
    }
    if (t == _i88.Organization) {
      return _i88.Organization.fromJson(data) as T;
    }
    if (t == _i89.Person) {
      return _i89.Person.fromJson(data) as T;
    }
    if (t == _i90.Course) {
      return _i90.Course.fromJson(data) as T;
    }
    if (t == _i91.Enrollment) {
      return _i91.Enrollment.fromJson(data) as T;
    }
    if (t == _i92.Student) {
      return _i92.Student.fromJson(data) as T;
    }
    if (t == _i93.Arena) {
      return _i93.Arena.fromJson(data) as T;
    }
    if (t == _i94.Player) {
      return _i94.Player.fromJson(data) as T;
    }
    if (t == _i95.Team) {
      return _i95.Team.fromJson(data) as T;
    }
    if (t == _i96.Comment) {
      return _i96.Comment.fromJson(data) as T;
    }
    if (t == _i97.Customer) {
      return _i97.Customer.fromJson(data) as T;
    }
    if (t == _i98.Book) {
      return _i98.Book.fromJson(data) as T;
    }
    if (t == _i99.Chapter) {
      return _i99.Chapter.fromJson(data) as T;
    }
    if (t == _i100.Order) {
      return _i100.Order.fromJson(data) as T;
    }
    if (t == _i101.Address) {
      return _i101.Address.fromJson(data) as T;
    }
    if (t == _i102.Citizen) {
      return _i102.Citizen.fromJson(data) as T;
    }
    if (t == _i103.Company) {
      return _i103.Company.fromJson(data) as T;
    }
    if (t == _i104.Town) {
      return _i104.Town.fromJson(data) as T;
    }
    if (t == _i105.Blocking) {
      return _i105.Blocking.fromJson(data) as T;
    }
    if (t == _i106.Member) {
      return _i106.Member.fromJson(data) as T;
    }
    if (t == _i107.Cat) {
      return _i107.Cat.fromJson(data) as T;
    }
    if (t == _i108.Post) {
      return _i108.Post.fromJson(data) as T;
    }
    if (t == _i109.ObjectFieldPersist) {
      return _i109.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i110.ObjectFieldScopes) {
      return _i110.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i111.ObjectWithBit) {
      return _i111.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i112.ObjectWithByteData) {
      return _i112.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i113.ObjectWithDuration) {
      return _i113.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i114.ObjectWithDynamic) {
      return _i114.ObjectWithDynamic.fromJson(data) as T;
    }
    if (t == _i115.ObjectWithEnum) {
      return _i115.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithEnumEnhanced) {
      return _i116.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithHalfVector) {
      return _i117.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithIndex) {
      return _i118.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithJsonb) {
      return _i119.ObjectWithJsonb.fromJson(data) as T;
    }
    if (t == _i120.ObjectWithJsonbClassLevel) {
      return _i120.ObjectWithJsonbClassLevel.fromJson(data) as T;
    }
    if (t == _i121.ObjectWithMaps) {
      return _i121.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i122.ObjectWithObject) {
      return _i122.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i123.ObjectWithParent) {
      return _i123.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i124.ObjectWithSealedClass) {
      return _i124.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i125.ObjectWithSelfParent) {
      return _i125.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i126.ObjectWithSparseVector) {
      return _i126.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i127.ObjectWithUuid) {
      return _i127.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i128.ObjectWithVector) {
      return _i128.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i129.RelatedUniqueData) {
      return _i129.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i130.ModelWithRequiredField) {
      return _i130.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i131.SimpleData) {
      return _i131.SimpleData.fromJson(data) as T;
    }
    if (t == _i132.SimpleDateTime) {
      return _i132.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i133.TestEnum) {
      return _i133.TestEnum.fromJson(data) as T;
    }
    if (t == _i134.TestEnumDefaultSerialization) {
      return _i134.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i135.TestEnumEnhanced) {
      return _i135.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i136.TestEnumEnhancedByName) {
      return _i136.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i137.TestEnumStringified) {
      return _i137.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i138.Types) {
      return _i138.Types.fromJson(data) as T;
    }
    if (t == _i139.UniqueData) {
      return _i139.UniqueData.fromJson(data) as T;
    }
    if (t == _i140.UniqueDataWithNonPersist) {
      return _i140.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _i141.UpsertTestModel) {
      return _i141.UpsertTestModel.fromJson(data) as T;
    }
    if (t == _i142.getType<_i4.CourseUuid?>()) {
      return (data != null ? _i4.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i5.EnrollmentInt?>()) {
      return (data != null ? _i5.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i6.StudentUuid?>()) {
      return (data != null ? _i6.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i7.ArenaUuid?>()) {
      return (data != null ? _i7.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i8.PlayerUuid?>()) {
      return (data != null ? _i8.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i9.TeamInt?>()) {
      return (data != null ? _i9.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i10.CommentInt?>()) {
      return (data != null ? _i10.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i11.CustomerInt?>()) {
      return (data != null ? _i11.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i12.OrderUuid?>()) {
      return (data != null ? _i12.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i13.AddressUuid?>()) {
      return (data != null ? _i13.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i14.CitizenInt?>()) {
      return (data != null ? _i14.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i15.CompanyUuid?>()) {
      return (data != null ? _i15.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i16.TownInt?>()) {
      return (data != null ? _i16.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i17.ChangedIdTypeSelf?>()) {
      return (data != null ? _i17.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i18.BigIntDefault?>()) {
      return (data != null ? _i18.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i19.BigIntDefaultMix?>()) {
      return (data != null ? _i19.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i20.BigIntDefaultModel?>()) {
      return (data != null ? _i20.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i21.BigIntDefaultPersist?>()) {
      return (data != null ? _i21.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i22.BoolDefault?>()) {
      return (data != null ? _i22.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i23.BoolDefaultMix?>()) {
      return (data != null ? _i23.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i24.BoolDefaultModel?>()) {
      return (data != null ? _i24.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i25.BoolDefaultPersist?>()) {
      return (data != null ? _i25.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i26.DateTimeDefault?>()) {
      return (data != null ? _i26.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i27.DateTimeDefaultMix?>()) {
      return (data != null ? _i27.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i28.DateTimeDefaultModel?>()) {
      return (data != null ? _i28.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i29.DateTimeDefaultPersist?>()) {
      return (data != null ? _i29.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i30.DoubleDefault?>()) {
      return (data != null ? _i30.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i31.DoubleDefaultMix?>()) {
      return (data != null ? _i31.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i32.DoubleDefaultModel?>()) {
      return (data != null ? _i32.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i33.DoubleDefaultPersist?>()) {
      return (data != null ? _i33.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i34.DurationDefault?>()) {
      return (data != null ? _i34.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i35.DurationDefaultMix?>()) {
      return (data != null ? _i35.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i36.DurationDefaultModel?>()) {
      return (data != null ? _i36.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i37.DurationDefaultPersist?>()) {
      return (data != null ? _i37.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i38.EnumDefault?>()) {
      return (data != null ? _i38.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i39.EnumDefaultMix?>()) {
      return (data != null ? _i39.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i40.EnumDefaultModel?>()) {
      return (data != null ? _i40.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i41.EnumDefaultPersist?>()) {
      return (data != null ? _i41.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i42.ByIndexEnum?>()) {
      return (data != null ? _i42.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i43.ByNameEnum?>()) {
      return (data != null ? _i43.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i44.DefaultValueEnum?>()) {
      return (data != null ? _i44.DefaultValueEnum.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i45.DefaultException?>()) {
      return (data != null ? _i45.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i46.IntDefault?>()) {
      return (data != null ? _i46.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i47.IntDefaultMix?>()) {
      return (data != null ? _i47.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i48.IntDefaultModel?>()) {
      return (data != null ? _i48.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i49.IntDefaultPersist?>()) {
      return (data != null ? _i49.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i50.StringDefault?>()) {
      return (data != null ? _i50.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i51.StringDefaultMix?>()) {
      return (data != null ? _i51.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i52.StringDefaultModel?>()) {
      return (data != null ? _i52.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i53.StringDefaultPersist?>()) {
      return (data != null ? _i53.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i54.UriDefault?>()) {
      return (data != null ? _i54.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i55.UriDefaultMix?>()) {
      return (data != null ? _i55.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i56.UriDefaultModel?>()) {
      return (data != null ? _i56.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i57.UriDefaultPersist?>()) {
      return (data != null ? _i57.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i58.UuidDefault?>()) {
      return (data != null ? _i58.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i59.UuidDefaultMix?>()) {
      return (data != null ? _i59.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i60.UuidDefaultModel?>()) {
      return (data != null ? _i60.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i61.UuidDefaultPersist?>()) {
      return (data != null ? _i61.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i62.EmptyModel?>()) {
      return (data != null ? _i62.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i63.EmptyModelRelationItem?>()) {
      return (data != null ? _i63.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i64.EmptyModelWithTable?>()) {
      return (data != null ? _i64.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i65.RelationEmptyModel?>()) {
      return (data != null ? _i65.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i66.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _i66.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i67.NonTableParentClass?>()) {
      return (data != null ? _i67.NonTableParentClass.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i68.ModifiedColumnName?>()) {
      return (data != null ? _i68.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i69.Department?>()) {
      return (data != null ? _i69.Department.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i70.Employee?>()) {
      return (data != null ? _i70.Employee.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i71.Contractor?>()) {
      return (data != null ? _i71.Contractor.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i72.Service?>()) {
      return (data != null ? _i72.Service.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i73.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _i73.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i74.SealedGrandChild?>()) {
      return (data != null ? _i74.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i74.SealedChild?>()) {
      return (data != null ? _i74.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i74.SealedOtherChild?>()) {
      return (data != null ? _i74.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i75.CityWithLongTableName?>()) {
      return (data != null ? _i75.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i76.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i76.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i77.PersonWithLongTableName?>()) {
      return (data != null ? _i77.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i78.MaxFieldName?>()) {
      return (data != null ? _i78.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i79.LongImplicitIdField?>()) {
      return (data != null ? _i79.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i80.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i80.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i81.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i81.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i82.UserNote?>()) {
      return (data != null ? _i82.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i83.UserNoteCollection?>()) {
      return (data != null ? _i83.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i84.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i84.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i85.UserNoteWithALongName?>()) {
      return (data != null ? _i85.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i86.MultipleMaxFieldName?>()) {
      return (data != null ? _i86.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i87.City?>()) {
      return (data != null ? _i87.City.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i88.Organization?>()) {
      return (data != null ? _i88.Organization.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i89.Person?>()) {
      return (data != null ? _i89.Person.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i90.Course?>()) {
      return (data != null ? _i90.Course.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i91.Enrollment?>()) {
      return (data != null ? _i91.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i92.Student?>()) {
      return (data != null ? _i92.Student.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i93.Arena?>()) {
      return (data != null ? _i93.Arena.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i94.Player?>()) {
      return (data != null ? _i94.Player.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i95.Team?>()) {
      return (data != null ? _i95.Team.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i96.Comment?>()) {
      return (data != null ? _i96.Comment.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i97.Customer?>()) {
      return (data != null ? _i97.Customer.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i98.Book?>()) {
      return (data != null ? _i98.Book.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i99.Chapter?>()) {
      return (data != null ? _i99.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i100.Order?>()) {
      return (data != null ? _i100.Order.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i101.Address?>()) {
      return (data != null ? _i101.Address.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i102.Citizen?>()) {
      return (data != null ? _i102.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i103.Company?>()) {
      return (data != null ? _i103.Company.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i104.Town?>()) {
      return (data != null ? _i104.Town.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i105.Blocking?>()) {
      return (data != null ? _i105.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i106.Member?>()) {
      return (data != null ? _i106.Member.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i107.Cat?>()) {
      return (data != null ? _i107.Cat.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i108.Post?>()) {
      return (data != null ? _i108.Post.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i109.ObjectFieldPersist?>()) {
      return (data != null ? _i109.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i110.ObjectFieldScopes?>()) {
      return (data != null ? _i110.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i111.ObjectWithBit?>()) {
      return (data != null ? _i111.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i112.ObjectWithByteData?>()) {
      return (data != null ? _i112.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i113.ObjectWithDuration?>()) {
      return (data != null ? _i113.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i114.ObjectWithDynamic?>()) {
      return (data != null ? _i114.ObjectWithDynamic.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i115.ObjectWithEnum?>()) {
      return (data != null ? _i115.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i116.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i116.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i117.ObjectWithHalfVector?>()) {
      return (data != null ? _i117.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i118.ObjectWithIndex?>()) {
      return (data != null ? _i118.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i119.ObjectWithJsonb?>()) {
      return (data != null ? _i119.ObjectWithJsonb.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i120.ObjectWithJsonbClassLevel?>()) {
      return (data != null
              ? _i120.ObjectWithJsonbClassLevel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i121.ObjectWithMaps?>()) {
      return (data != null ? _i121.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i122.ObjectWithObject?>()) {
      return (data != null ? _i122.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i123.ObjectWithParent?>()) {
      return (data != null ? _i123.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i124.ObjectWithSealedClass?>()) {
      return (data != null ? _i124.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i125.ObjectWithSelfParent?>()) {
      return (data != null ? _i125.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i126.ObjectWithSparseVector?>()) {
      return (data != null ? _i126.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i127.ObjectWithUuid?>()) {
      return (data != null ? _i127.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i128.ObjectWithVector?>()) {
      return (data != null ? _i128.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i129.RelatedUniqueData?>()) {
      return (data != null ? _i129.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i130.ModelWithRequiredField?>()) {
      return (data != null ? _i130.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i131.SimpleData?>()) {
      return (data != null ? _i131.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i132.SimpleDateTime?>()) {
      return (data != null ? _i132.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i133.TestEnum?>()) {
      return (data != null ? _i133.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i134.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i134.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i135.TestEnumEnhanced?>()) {
      return (data != null ? _i135.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i136.TestEnumEnhancedByName?>()) {
      return (data != null ? _i136.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i137.TestEnumStringified?>()) {
      return (data != null ? _i137.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i142.getType<_i138.Types?>()) {
      return (data != null ? _i138.Types.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i139.UniqueData?>()) {
      return (data != null ? _i139.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i142.getType<_i140.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i140.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == _i142.getType<_i141.UpsertTestModel?>()) {
      return (data != null ? _i141.UpsertTestModel.fromJson(data) : null) as T;
    }
    if (t == List<_i5.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i5.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i5.EnrollmentInt>?>()) {
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
    if (t == _i142.getType<List<_i8.PlayerUuid>?>()) {
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
    if (t == _i142.getType<List<_i12.OrderUuid>?>()) {
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
    if (t == _i142.getType<List<_i10.CommentInt>?>()) {
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
    if (t == _i142.getType<List<_i17.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i17.ChangedIdTypeSelf>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i63.EmptyModelRelationItem>) {
      return (data as List)
              .map((e) => deserialize<_i63.EmptyModelRelationItem>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i63.EmptyModelRelationItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i63.EmptyModelRelationItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i70.Employee>) {
      return (data as List).map((e) => deserialize<_i70.Employee>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i70.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i70.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i77.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i77.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i77.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i77.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i76.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i76.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i76.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i76.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i79.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i79.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i79.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i79.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i86.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i86.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i86.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i86.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i82.UserNote>) {
      return (data as List).map((e) => deserialize<_i82.UserNote>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i82.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i82.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i85.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i85.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i85.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i85.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i89.Person>) {
      return (data as List).map((e) => deserialize<_i89.Person>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i89.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i89.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i88.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i88.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i88.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i88.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i91.Enrollment>) {
      return (data as List).map((e) => deserialize<_i91.Enrollment>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i91.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i91.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i94.Player>) {
      return (data as List).map((e) => deserialize<_i94.Player>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i94.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i94.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i100.Order>) {
      return (data as List).map((e) => deserialize<_i100.Order>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i100.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i100.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i99.Chapter>) {
      return (data as List).map((e) => deserialize<_i99.Chapter>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i99.Chapter>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i99.Chapter>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i96.Comment>) {
      return (data as List).map((e) => deserialize<_i96.Comment>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i96.Comment>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i96.Comment>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i105.Blocking>) {
      return (data as List).map((e) => deserialize<_i105.Blocking>(e)).toList()
          as T;
    }
    if (t == _i142.getType<List<_i105.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i105.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i107.Cat>) {
      return (data as List).map((e) => deserialize<_i107.Cat>(e)).toList() as T;
    }
    if (t == _i142.getType<List<_i107.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i107.Cat>(e)).toList()
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
    if (t == List<_i133.TestEnum>) {
      return (data as List).map((e) => deserialize<_i133.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i133.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i133.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i133.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i133.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i135.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i135.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i136.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i136.TestEnumEnhancedByName>(e))
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
    if (t == _i142.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, _i131.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i131.SimpleData>(v),
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
    if (t == Map<String, _i143.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i143.ByteData>(v),
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
    if (t == Map<String, _i142.UuidValue>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i142.UuidValue>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i131.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i131.SimpleData?>(v),
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
    if (t == Map<String, _i143.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i143.ByteData?>(v),
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
    if (t == Map<String, _i142.UuidValue?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i142.UuidValue?>(v),
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
    if (t == List<_i131.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i131.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i131.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i131.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i131.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i131.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<_i131.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i131.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i131.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i131.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<List<List<_i131.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i131.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i131.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i131.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i131.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i131.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i131.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i131.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i131.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i131.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i142.getType<List<Map<int, _i131.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i131.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i142
            .getType<Map<String, List<List<Map<int, _i131.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i131.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i142.getType<List<Map<int, _i131.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i131.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i131.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i131.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i142.getType<Map<String, Map<int, _i131.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i131.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i74.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i74.SealedParent>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i142.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == _i142.getType<Map<int, int>?>()) {
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
    if (t == _i142.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i142.getType<(String, {Uri? optionalUri})?>()) {
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
    if (t == List<_i144.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i144.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i142.getType<(String, {Uri? optionalUri})?>()) {
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
    } on _i142.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } on _i142.DeserializationTypeNotFoundException catch (_) {}
    try {
      return _i145.Protocol().deserialize<T>(data, t);
    } on _i142.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
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
      _i66.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i67.NonTableParentClass => 'NonTableParentClass',
      _i68.ModifiedColumnName => 'ModifiedColumnName',
      _i69.Department => 'Department',
      _i70.Employee => 'Employee',
      _i71.Contractor => 'Contractor',
      _i72.Service => 'Service',
      _i73.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i74.SealedGrandChild => 'SealedGrandChild',
      _i74.SealedChild => 'SealedChild',
      _i74.SealedOtherChild => 'SealedOtherChild',
      _i75.CityWithLongTableName => 'CityWithLongTableName',
      _i76.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i77.PersonWithLongTableName => 'PersonWithLongTableName',
      _i78.MaxFieldName => 'MaxFieldName',
      _i79.LongImplicitIdField => 'LongImplicitIdField',
      _i80.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i81.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i82.UserNote => 'UserNote',
      _i83.UserNoteCollection => 'UserNoteCollection',
      _i84.UserNoteCollectionWithALongName => 'UserNoteCollectionWithALongName',
      _i85.UserNoteWithALongName => 'UserNoteWithALongName',
      _i86.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i87.City => 'City',
      _i88.Organization => 'Organization',
      _i89.Person => 'Person',
      _i90.Course => 'Course',
      _i91.Enrollment => 'Enrollment',
      _i92.Student => 'Student',
      _i93.Arena => 'Arena',
      _i94.Player => 'Player',
      _i95.Team => 'Team',
      _i96.Comment => 'Comment',
      _i97.Customer => 'Customer',
      _i98.Book => 'Book',
      _i99.Chapter => 'Chapter',
      _i100.Order => 'Order',
      _i101.Address => 'Address',
      _i102.Citizen => 'Citizen',
      _i103.Company => 'Company',
      _i104.Town => 'Town',
      _i105.Blocking => 'Blocking',
      _i106.Member => 'Member',
      _i107.Cat => 'Cat',
      _i108.Post => 'Post',
      _i109.ObjectFieldPersist => 'ObjectFieldPersist',
      _i110.ObjectFieldScopes => 'ObjectFieldScopes',
      _i111.ObjectWithBit => 'ObjectWithBit',
      _i112.ObjectWithByteData => 'ObjectWithByteData',
      _i113.ObjectWithDuration => 'ObjectWithDuration',
      _i114.ObjectWithDynamic => 'ObjectWithDynamic',
      _i115.ObjectWithEnum => 'ObjectWithEnum',
      _i116.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i117.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i118.ObjectWithIndex => 'ObjectWithIndex',
      _i119.ObjectWithJsonb => 'ObjectWithJsonb',
      _i120.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i121.ObjectWithMaps => 'ObjectWithMaps',
      _i122.ObjectWithObject => 'ObjectWithObject',
      _i123.ObjectWithParent => 'ObjectWithParent',
      _i124.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i125.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i126.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i127.ObjectWithUuid => 'ObjectWithUuid',
      _i128.ObjectWithVector => 'ObjectWithVector',
      _i129.RelatedUniqueData => 'RelatedUniqueData',
      _i130.ModelWithRequiredField => 'ModelWithRequiredField',
      _i131.SimpleData => 'SimpleData',
      _i132.SimpleDateTime => 'SimpleDateTime',
      _i133.TestEnum => 'TestEnum',
      _i134.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i135.TestEnumEnhanced => 'TestEnumEnhanced',
      _i136.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i137.TestEnumStringified => 'TestEnumStringified',
      _i138.Types => 'Types',
      _i139.UniqueData => 'UniqueData',
      _i140.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
      _i141.UpsertTestModel => 'UpsertTestModel',
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
      case _i66.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i67.NonTableParentClass():
        return 'NonTableParentClass';
      case _i68.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i69.Department():
        return 'Department';
      case _i70.Employee():
        return 'Employee';
      case _i71.Contractor():
        return 'Contractor';
      case _i72.Service():
        return 'Service';
      case _i73.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i74.SealedGrandChild():
        return 'SealedGrandChild';
      case _i74.SealedChild():
        return 'SealedChild';
      case _i74.SealedOtherChild():
        return 'SealedOtherChild';
      case _i75.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i76.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i77.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i78.MaxFieldName():
        return 'MaxFieldName';
      case _i79.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i80.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i81.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i82.UserNote():
        return 'UserNote';
      case _i83.UserNoteCollection():
        return 'UserNoteCollection';
      case _i84.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i85.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i86.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i87.City():
        return 'City';
      case _i88.Organization():
        return 'Organization';
      case _i89.Person():
        return 'Person';
      case _i90.Course():
        return 'Course';
      case _i91.Enrollment():
        return 'Enrollment';
      case _i92.Student():
        return 'Student';
      case _i93.Arena():
        return 'Arena';
      case _i94.Player():
        return 'Player';
      case _i95.Team():
        return 'Team';
      case _i96.Comment():
        return 'Comment';
      case _i97.Customer():
        return 'Customer';
      case _i98.Book():
        return 'Book';
      case _i99.Chapter():
        return 'Chapter';
      case _i100.Order():
        return 'Order';
      case _i101.Address():
        return 'Address';
      case _i102.Citizen():
        return 'Citizen';
      case _i103.Company():
        return 'Company';
      case _i104.Town():
        return 'Town';
      case _i105.Blocking():
        return 'Blocking';
      case _i106.Member():
        return 'Member';
      case _i107.Cat():
        return 'Cat';
      case _i108.Post():
        return 'Post';
      case _i109.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i110.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i111.ObjectWithBit():
        return 'ObjectWithBit';
      case _i112.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i113.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i114.ObjectWithDynamic():
        return 'ObjectWithDynamic';
      case _i115.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i116.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i117.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i118.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i119.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i120.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i121.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i122.ObjectWithObject():
        return 'ObjectWithObject';
      case _i123.ObjectWithParent():
        return 'ObjectWithParent';
      case _i124.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i125.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i126.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i127.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i128.ObjectWithVector():
        return 'ObjectWithVector';
      case _i129.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i130.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i131.SimpleData():
        return 'SimpleData';
      case _i132.SimpleDateTime():
        return 'SimpleDateTime';
      case _i133.TestEnum():
        return 'TestEnum';
      case _i134.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i135.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i136.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i137.TestEnumStringified():
        return 'TestEnumStringified';
      case _i138.Types():
        return 'Types';
      case _i139.UniqueData():
        return 'UniqueData';
      case _i140.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
      case _i141.UpsertTestModel():
        return 'UpsertTestModel';
    }
    className = _i2.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_core.$className';
    }
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return className.contains('.')
          ? className
          : 'serverpod_auth_idp.$className';
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
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i66.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i67.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i68.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i69.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i70.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i71.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i72.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i73.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i74.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i74.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i74.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i75.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i76.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i77.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i78.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i79.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i80.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i81.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i82.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i83.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i84.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i85.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i86.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i87.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i88.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i89.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i90.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i91.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i92.Student>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i93.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i94.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i95.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i96.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i97.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i98.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i99.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i100.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i101.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i102.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i103.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i104.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i105.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i106.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i107.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i108.Post>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i109.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i110.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i111.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i112.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i113.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithDynamic') {
      return deserialize<_i114.ObjectWithDynamic>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i115.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i116.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i117.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i118.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_i119.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i120.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i121.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i122.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i123.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i124.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i125.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i126.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i127.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i128.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i129.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i130.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i131.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i132.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i133.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i134.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i135.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i136.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i137.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i138.Types>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i139.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i140.UniqueDataWithNonPersist>(data['data']);
    }
    if (dataClassName == 'UpsertTestModel') {
      return deserialize<_i141.UpsertTestModel>(data['data']);
    }
    if (dataClassName.startsWith('serverpod_auth_core.')) {
      data['className'] = dataClassName.substring(20);
      return _i2.Protocol().deserializeByClassName(data);
    }
    if (dataClassName.startsWith('serverpod_auth_idp.')) {
      data['className'] = dataClassName.substring(19);
      return _i3.Protocol().deserializeByClassName(data);
    }
    return super.deserializeByClassName(data);
  }

  void _registerHostProtocols() {
    _i2.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
    _i3.Protocol().registerHostProtocol('serverpod_test_sqlite', this);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    {
      var protocol = _i2.Protocol();
      var table = protocol is _i1.DatabaseSerializationManager
          ? (protocol as _i1.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    {
      var protocol = _i3.Protocol();
      var table = protocol is _i1.DatabaseSerializationManager
          ? (protocol as _i1.DatabaseSerializationManager).getTableForType(t)
          : null;
      if (table != null) {
        return table;
      }
    }
    switch (t) {
      case _i63.EmptyModelRelationItem:
        return _i63.EmptyModelRelationItem.t;
      case _i64.EmptyModelWithTable:
        return _i64.EmptyModelWithTable.t;
      case _i65.RelationEmptyModel:
        return _i65.RelationEmptyModel.t;
      case _i87.City:
        return _i87.City.t;
      case _i88.Organization:
        return _i88.Organization.t;
      case _i89.Person:
        return _i89.Person.t;
      case _i90.Course:
        return _i90.Course.t;
      case _i91.Enrollment:
        return _i91.Enrollment.t;
      case _i92.Student:
        return _i92.Student.t;
      case _i93.Arena:
        return _i93.Arena.t;
      case _i94.Player:
        return _i94.Player.t;
      case _i95.Team:
        return _i95.Team.t;
      case _i96.Comment:
        return _i96.Comment.t;
      case _i97.Customer:
        return _i97.Customer.t;
      case _i98.Book:
        return _i98.Book.t;
      case _i99.Chapter:
        return _i99.Chapter.t;
      case _i100.Order:
        return _i100.Order.t;
      case _i101.Address:
        return _i101.Address.t;
      case _i102.Citizen:
        return _i102.Citizen.t;
      case _i103.Company:
        return _i103.Company.t;
      case _i104.Town:
        return _i104.Town.t;
      case _i105.Blocking:
        return _i105.Blocking.t;
      case _i106.Member:
        return _i106.Member.t;
      case _i107.Cat:
        return _i107.Cat.t;
      case _i108.Post:
        return _i108.Post.t;
      case _i109.ObjectFieldPersist:
        return _i109.ObjectFieldPersist.t;
      case _i129.RelatedUniqueData:
        return _i129.RelatedUniqueData.t;
      case _i130.ModelWithRequiredField:
        return _i130.ModelWithRequiredField.t;
      case _i131.SimpleData:
        return _i131.SimpleData.t;
      case _i132.SimpleDateTime:
        return _i132.SimpleDateTime.t;
      case _i138.Types:
        return _i138.Types.t;
      case _i139.UniqueData:
        return _i139.UniqueData.t;
      case _i140.UniqueDataWithNonPersist:
        return _i140.UniqueDataWithNonPersist.t;
    }
    return null;
  }

  @override
  List<_i1.TableDefinition> getTargetTableDefinitions() =>
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
    try {
      return _i3.Protocol().mapRecordToJson(record);
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
