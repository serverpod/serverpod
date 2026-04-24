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
import 'changed_id_type/many_to_many/course.dart' as _i2;
import 'changed_id_type/many_to_many/enrollment.dart' as _i3;
import 'changed_id_type/many_to_many/student.dart' as _i4;
import 'changed_id_type/nested_one_to_many/arena.dart' as _i5;
import 'changed_id_type/nested_one_to_many/player.dart' as _i6;
import 'changed_id_type/nested_one_to_many/team.dart' as _i7;
import 'changed_id_type/one_to_many/comment.dart' as _i8;
import 'changed_id_type/one_to_many/customer.dart' as _i9;
import 'changed_id_type/one_to_many/order.dart' as _i10;
import 'changed_id_type/one_to_one/address.dart' as _i11;
import 'changed_id_type/one_to_one/citizen.dart' as _i12;
import 'changed_id_type/one_to_one/company.dart' as _i13;
import 'changed_id_type/one_to_one/town.dart' as _i14;
import 'changed_id_type/self.dart' as _i15;
import 'defaults/bigint/bigint_default.dart' as _i16;
import 'defaults/bigint/bigint_default_mix.dart' as _i17;
import 'defaults/bigint/bigint_default_model.dart' as _i18;
import 'defaults/bigint/bigint_default_persist.dart' as _i19;
import 'defaults/boolean/bool_default.dart' as _i20;
import 'defaults/boolean/bool_default_mix.dart' as _i21;
import 'defaults/boolean/bool_default_model.dart' as _i22;
import 'defaults/boolean/bool_default_persist.dart' as _i23;
import 'defaults/datetime/datetime_default.dart' as _i24;
import 'defaults/datetime/datetime_default_mix.dart' as _i25;
import 'defaults/datetime/datetime_default_model.dart' as _i26;
import 'defaults/datetime/datetime_default_persist.dart' as _i27;
import 'defaults/double/double_default.dart' as _i28;
import 'defaults/double/double_default_mix.dart' as _i29;
import 'defaults/double/double_default_model.dart' as _i30;
import 'defaults/double/double_default_persist.dart' as _i31;
import 'defaults/duration/duration_default.dart' as _i32;
import 'defaults/duration/duration_default_mix.dart' as _i33;
import 'defaults/duration/duration_default_model.dart' as _i34;
import 'defaults/duration/duration_default_persist.dart' as _i35;
import 'defaults/enum/enum_default.dart' as _i36;
import 'defaults/enum/enum_default_mix.dart' as _i37;
import 'defaults/enum/enum_default_model.dart' as _i38;
import 'defaults/enum/enum_default_persist.dart' as _i39;
import 'defaults/enum/enums/by_index_enum.dart' as _i40;
import 'defaults/enum/enums/by_name_enum.dart' as _i41;
import 'defaults/enum/enums/default_value_enum.dart' as _i42;
import 'defaults/exception/default_exception.dart' as _i43;
import 'defaults/integer/int_default.dart' as _i44;
import 'defaults/integer/int_default_mix.dart' as _i45;
import 'defaults/integer/int_default_model.dart' as _i46;
import 'defaults/integer/int_default_persist.dart' as _i47;
import 'defaults/string/string_default.dart' as _i48;
import 'defaults/string/string_default_mix.dart' as _i49;
import 'defaults/string/string_default_model.dart' as _i50;
import 'defaults/string/string_default_persist.dart' as _i51;
import 'defaults/uri/uri_default.dart' as _i52;
import 'defaults/uri/uri_default_mix.dart' as _i53;
import 'defaults/uri/uri_default_model.dart' as _i54;
import 'defaults/uri/uri_default_persist.dart' as _i55;
import 'defaults/uuid/uuid_default.dart' as _i56;
import 'defaults/uuid/uuid_default_mix.dart' as _i57;
import 'defaults/uuid/uuid_default_model.dart' as _i58;
import 'defaults/uuid/uuid_default_persist.dart' as _i59;
import 'empty_model/empty_model.dart' as _i60;
import 'empty_model/empty_model_relation_item.dart' as _i61;
import 'empty_model/empty_model_with_table.dart' as _i62;
import 'empty_model/relation_empy_model.dart' as _i63;
import 'explicit_column_name/inheritance/child_class_explicit_column.dart'
    as _i64;
import 'explicit_column_name/inheritance/non_table_parent_class.dart' as _i65;
import 'explicit_column_name/modified_column_name.dart' as _i66;
import 'explicit_column_name/relations/one_to_many/department.dart' as _i67;
import 'explicit_column_name/relations/one_to_many/employee.dart' as _i68;
import 'explicit_column_name/relations/one_to_one/contractor.dart' as _i69;
import 'explicit_column_name/relations/one_to_one/service.dart' as _i70;
import 'explicit_column_name/table_with_explicit_column_names.dart' as _i71;
import 'inheritance/sealed_parent.dart' as _i72;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i73;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i74;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart'
    as _i75;
import 'long_identifiers/max_field_name.dart' as _i76;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i77;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i78;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i79;
import 'long_identifiers/models_with_relations/user_note.dart' as _i80;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i81;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i82;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i83;
import 'long_identifiers/multiple_max_field_name.dart' as _i84;
import 'models_with_list_relations/city.dart' as _i85;
import 'models_with_list_relations/organization.dart' as _i86;
import 'models_with_list_relations/person.dart' as _i87;
import 'models_with_relations/many_to_many/course.dart' as _i88;
import 'models_with_relations/many_to_many/enrollment.dart' as _i89;
import 'models_with_relations/many_to_many/student.dart' as _i90;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i91;
import 'models_with_relations/nested_one_to_many/player.dart' as _i92;
import 'models_with_relations/nested_one_to_many/team.dart' as _i93;
import 'models_with_relations/one_to_many/comment.dart' as _i94;
import 'models_with_relations/one_to_many/customer.dart' as _i95;
import 'models_with_relations/one_to_many/implicit/book.dart' as _i96;
import 'models_with_relations/one_to_many/implicit/chapter.dart' as _i97;
import 'models_with_relations/one_to_many/order.dart' as _i98;
import 'models_with_relations/one_to_one/address.dart' as _i99;
import 'models_with_relations/one_to_one/citizen.dart' as _i100;
import 'models_with_relations/one_to_one/company.dart' as _i101;
import 'models_with_relations/one_to_one/town.dart' as _i102;
import 'models_with_relations/self_relation/many_to_many/blocking.dart'
    as _i103;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i104;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i105;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i106;
import 'object_field_persist.dart' as _i107;
import 'object_field_scopes.dart' as _i108;
import 'object_with_bit.dart' as _i109;
import 'object_with_bytedata.dart' as _i110;
import 'object_with_duration.dart' as _i111;
import 'object_with_enum.dart' as _i112;
import 'object_with_enum_enhanced.dart' as _i113;
import 'object_with_half_vector.dart' as _i114;
import 'object_with_index.dart' as _i115;
import 'object_with_jsonb.dart' as _i116;
import 'object_with_jsonb_class_level.dart' as _i117;
import 'object_with_maps.dart' as _i118;
import 'object_with_object.dart' as _i119;
import 'object_with_parent.dart' as _i120;
import 'object_with_sealed_class.dart' as _i121;
import 'object_with_self_parent.dart' as _i122;
import 'object_with_sparse_vector.dart' as _i123;
import 'object_with_uuid.dart' as _i124;
import 'object_with_vector.dart' as _i125;
import 'related_unique_data.dart' as _i126;
import 'required/model_with_required_field.dart' as _i127;
import 'simple_data.dart' as _i128;
import 'simple_date_time.dart' as _i129;
import 'test_enum.dart' as _i130;
import 'test_enum_default_serialization.dart' as _i131;
import 'test_enum_enhanced.dart' as _i132;
import 'test_enum_enhanced_by_name.dart' as _i133;
import 'test_enum_stringified.dart' as _i134;
import 'types.dart' as _i135;
import 'unique_data.dart' as _i136;
import 'unique_data_with_non_persist.dart' as _i137;
import 'package:serverpod_client/serverpod_client.dart' as _i138;
import 'dart:typed_data' as _i139;
import 'package:serverpod_test_sqlite_client/src/protocol/simple_data.dart'
    as _i140;
import 'package:serverpod_service_client/serverpod_service_client.dart'
    as _i141;
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
export 'client.dart';

class Protocol extends _i1.DatabaseSerializationManager {
  Protocol._();

  factory Protocol() => _instance;

  static final Protocol _instance = Protocol._();

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

    if (t == _i2.CourseUuid) {
      return _i2.CourseUuid.fromJson(data) as T;
    }
    if (t == _i3.EnrollmentInt) {
      return _i3.EnrollmentInt.fromJson(data) as T;
    }
    if (t == _i4.StudentUuid) {
      return _i4.StudentUuid.fromJson(data) as T;
    }
    if (t == _i5.ArenaUuid) {
      return _i5.ArenaUuid.fromJson(data) as T;
    }
    if (t == _i6.PlayerUuid) {
      return _i6.PlayerUuid.fromJson(data) as T;
    }
    if (t == _i7.TeamInt) {
      return _i7.TeamInt.fromJson(data) as T;
    }
    if (t == _i8.CommentInt) {
      return _i8.CommentInt.fromJson(data) as T;
    }
    if (t == _i9.CustomerInt) {
      return _i9.CustomerInt.fromJson(data) as T;
    }
    if (t == _i10.OrderUuid) {
      return _i10.OrderUuid.fromJson(data) as T;
    }
    if (t == _i11.AddressUuid) {
      return _i11.AddressUuid.fromJson(data) as T;
    }
    if (t == _i12.CitizenInt) {
      return _i12.CitizenInt.fromJson(data) as T;
    }
    if (t == _i13.CompanyUuid) {
      return _i13.CompanyUuid.fromJson(data) as T;
    }
    if (t == _i14.TownInt) {
      return _i14.TownInt.fromJson(data) as T;
    }
    if (t == _i15.ChangedIdTypeSelf) {
      return _i15.ChangedIdTypeSelf.fromJson(data) as T;
    }
    if (t == _i16.BigIntDefault) {
      return _i16.BigIntDefault.fromJson(data) as T;
    }
    if (t == _i17.BigIntDefaultMix) {
      return _i17.BigIntDefaultMix.fromJson(data) as T;
    }
    if (t == _i18.BigIntDefaultModel) {
      return _i18.BigIntDefaultModel.fromJson(data) as T;
    }
    if (t == _i19.BigIntDefaultPersist) {
      return _i19.BigIntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i20.BoolDefault) {
      return _i20.BoolDefault.fromJson(data) as T;
    }
    if (t == _i21.BoolDefaultMix) {
      return _i21.BoolDefaultMix.fromJson(data) as T;
    }
    if (t == _i22.BoolDefaultModel) {
      return _i22.BoolDefaultModel.fromJson(data) as T;
    }
    if (t == _i23.BoolDefaultPersist) {
      return _i23.BoolDefaultPersist.fromJson(data) as T;
    }
    if (t == _i24.DateTimeDefault) {
      return _i24.DateTimeDefault.fromJson(data) as T;
    }
    if (t == _i25.DateTimeDefaultMix) {
      return _i25.DateTimeDefaultMix.fromJson(data) as T;
    }
    if (t == _i26.DateTimeDefaultModel) {
      return _i26.DateTimeDefaultModel.fromJson(data) as T;
    }
    if (t == _i27.DateTimeDefaultPersist) {
      return _i27.DateTimeDefaultPersist.fromJson(data) as T;
    }
    if (t == _i28.DoubleDefault) {
      return _i28.DoubleDefault.fromJson(data) as T;
    }
    if (t == _i29.DoubleDefaultMix) {
      return _i29.DoubleDefaultMix.fromJson(data) as T;
    }
    if (t == _i30.DoubleDefaultModel) {
      return _i30.DoubleDefaultModel.fromJson(data) as T;
    }
    if (t == _i31.DoubleDefaultPersist) {
      return _i31.DoubleDefaultPersist.fromJson(data) as T;
    }
    if (t == _i32.DurationDefault) {
      return _i32.DurationDefault.fromJson(data) as T;
    }
    if (t == _i33.DurationDefaultMix) {
      return _i33.DurationDefaultMix.fromJson(data) as T;
    }
    if (t == _i34.DurationDefaultModel) {
      return _i34.DurationDefaultModel.fromJson(data) as T;
    }
    if (t == _i35.DurationDefaultPersist) {
      return _i35.DurationDefaultPersist.fromJson(data) as T;
    }
    if (t == _i36.EnumDefault) {
      return _i36.EnumDefault.fromJson(data) as T;
    }
    if (t == _i37.EnumDefaultMix) {
      return _i37.EnumDefaultMix.fromJson(data) as T;
    }
    if (t == _i38.EnumDefaultModel) {
      return _i38.EnumDefaultModel.fromJson(data) as T;
    }
    if (t == _i39.EnumDefaultPersist) {
      return _i39.EnumDefaultPersist.fromJson(data) as T;
    }
    if (t == _i40.ByIndexEnum) {
      return _i40.ByIndexEnum.fromJson(data) as T;
    }
    if (t == _i41.ByNameEnum) {
      return _i41.ByNameEnum.fromJson(data) as T;
    }
    if (t == _i42.DefaultValueEnum) {
      return _i42.DefaultValueEnum.fromJson(data) as T;
    }
    if (t == _i43.DefaultException) {
      return _i43.DefaultException.fromJson(data) as T;
    }
    if (t == _i44.IntDefault) {
      return _i44.IntDefault.fromJson(data) as T;
    }
    if (t == _i45.IntDefaultMix) {
      return _i45.IntDefaultMix.fromJson(data) as T;
    }
    if (t == _i46.IntDefaultModel) {
      return _i46.IntDefaultModel.fromJson(data) as T;
    }
    if (t == _i47.IntDefaultPersist) {
      return _i47.IntDefaultPersist.fromJson(data) as T;
    }
    if (t == _i48.StringDefault) {
      return _i48.StringDefault.fromJson(data) as T;
    }
    if (t == _i49.StringDefaultMix) {
      return _i49.StringDefaultMix.fromJson(data) as T;
    }
    if (t == _i50.StringDefaultModel) {
      return _i50.StringDefaultModel.fromJson(data) as T;
    }
    if (t == _i51.StringDefaultPersist) {
      return _i51.StringDefaultPersist.fromJson(data) as T;
    }
    if (t == _i52.UriDefault) {
      return _i52.UriDefault.fromJson(data) as T;
    }
    if (t == _i53.UriDefaultMix) {
      return _i53.UriDefaultMix.fromJson(data) as T;
    }
    if (t == _i54.UriDefaultModel) {
      return _i54.UriDefaultModel.fromJson(data) as T;
    }
    if (t == _i55.UriDefaultPersist) {
      return _i55.UriDefaultPersist.fromJson(data) as T;
    }
    if (t == _i56.UuidDefault) {
      return _i56.UuidDefault.fromJson(data) as T;
    }
    if (t == _i57.UuidDefaultMix) {
      return _i57.UuidDefaultMix.fromJson(data) as T;
    }
    if (t == _i58.UuidDefaultModel) {
      return _i58.UuidDefaultModel.fromJson(data) as T;
    }
    if (t == _i59.UuidDefaultPersist) {
      return _i59.UuidDefaultPersist.fromJson(data) as T;
    }
    if (t == _i60.EmptyModel) {
      return _i60.EmptyModel.fromJson(data) as T;
    }
    if (t == _i61.EmptyModelRelationItem) {
      return _i61.EmptyModelRelationItem.fromJson(data) as T;
    }
    if (t == _i62.EmptyModelWithTable) {
      return _i62.EmptyModelWithTable.fromJson(data) as T;
    }
    if (t == _i63.RelationEmptyModel) {
      return _i63.RelationEmptyModel.fromJson(data) as T;
    }
    if (t == _i64.ChildClassExplicitColumn) {
      return _i64.ChildClassExplicitColumn.fromJson(data) as T;
    }
    if (t == _i65.NonTableParentClass) {
      return _i65.NonTableParentClass.fromJson(data) as T;
    }
    if (t == _i66.ModifiedColumnName) {
      return _i66.ModifiedColumnName.fromJson(data) as T;
    }
    if (t == _i67.Department) {
      return _i67.Department.fromJson(data) as T;
    }
    if (t == _i68.Employee) {
      return _i68.Employee.fromJson(data) as T;
    }
    if (t == _i69.Contractor) {
      return _i69.Contractor.fromJson(data) as T;
    }
    if (t == _i70.Service) {
      return _i70.Service.fromJson(data) as T;
    }
    if (t == _i71.TableWithExplicitColumnName) {
      return _i71.TableWithExplicitColumnName.fromJson(data) as T;
    }
    if (t == _i72.SealedGrandChild) {
      return _i72.SealedGrandChild.fromJson(data) as T;
    }
    if (t == _i72.SealedChild) {
      return _i72.SealedChild.fromJson(data) as T;
    }
    if (t == _i72.SealedOtherChild) {
      return _i72.SealedOtherChild.fromJson(data) as T;
    }
    if (t == _i73.CityWithLongTableName) {
      return _i73.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i74.OrganizationWithLongTableName) {
      return _i74.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i75.PersonWithLongTableName) {
      return _i75.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i76.MaxFieldName) {
      return _i76.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i77.LongImplicitIdField) {
      return _i77.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i78.LongImplicitIdFieldCollection) {
      return _i78.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i79.RelationToMultipleMaxFieldName) {
      return _i79.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i80.UserNote) {
      return _i80.UserNote.fromJson(data) as T;
    }
    if (t == _i81.UserNoteCollection) {
      return _i81.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i82.UserNoteCollectionWithALongName) {
      return _i82.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i83.UserNoteWithALongName) {
      return _i83.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i84.MultipleMaxFieldName) {
      return _i84.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i85.City) {
      return _i85.City.fromJson(data) as T;
    }
    if (t == _i86.Organization) {
      return _i86.Organization.fromJson(data) as T;
    }
    if (t == _i87.Person) {
      return _i87.Person.fromJson(data) as T;
    }
    if (t == _i88.Course) {
      return _i88.Course.fromJson(data) as T;
    }
    if (t == _i89.Enrollment) {
      return _i89.Enrollment.fromJson(data) as T;
    }
    if (t == _i90.Student) {
      return _i90.Student.fromJson(data) as T;
    }
    if (t == _i91.Arena) {
      return _i91.Arena.fromJson(data) as T;
    }
    if (t == _i92.Player) {
      return _i92.Player.fromJson(data) as T;
    }
    if (t == _i93.Team) {
      return _i93.Team.fromJson(data) as T;
    }
    if (t == _i94.Comment) {
      return _i94.Comment.fromJson(data) as T;
    }
    if (t == _i95.Customer) {
      return _i95.Customer.fromJson(data) as T;
    }
    if (t == _i96.Book) {
      return _i96.Book.fromJson(data) as T;
    }
    if (t == _i97.Chapter) {
      return _i97.Chapter.fromJson(data) as T;
    }
    if (t == _i98.Order) {
      return _i98.Order.fromJson(data) as T;
    }
    if (t == _i99.Address) {
      return _i99.Address.fromJson(data) as T;
    }
    if (t == _i100.Citizen) {
      return _i100.Citizen.fromJson(data) as T;
    }
    if (t == _i101.Company) {
      return _i101.Company.fromJson(data) as T;
    }
    if (t == _i102.Town) {
      return _i102.Town.fromJson(data) as T;
    }
    if (t == _i103.Blocking) {
      return _i103.Blocking.fromJson(data) as T;
    }
    if (t == _i104.Member) {
      return _i104.Member.fromJson(data) as T;
    }
    if (t == _i105.Cat) {
      return _i105.Cat.fromJson(data) as T;
    }
    if (t == _i106.Post) {
      return _i106.Post.fromJson(data) as T;
    }
    if (t == _i107.ObjectFieldPersist) {
      return _i107.ObjectFieldPersist.fromJson(data) as T;
    }
    if (t == _i108.ObjectFieldScopes) {
      return _i108.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i109.ObjectWithBit) {
      return _i109.ObjectWithBit.fromJson(data) as T;
    }
    if (t == _i110.ObjectWithByteData) {
      return _i110.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i111.ObjectWithDuration) {
      return _i111.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i112.ObjectWithEnum) {
      return _i112.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i113.ObjectWithEnumEnhanced) {
      return _i113.ObjectWithEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i114.ObjectWithHalfVector) {
      return _i114.ObjectWithHalfVector.fromJson(data) as T;
    }
    if (t == _i115.ObjectWithIndex) {
      return _i115.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i116.ObjectWithJsonb) {
      return _i116.ObjectWithJsonb.fromJson(data) as T;
    }
    if (t == _i117.ObjectWithJsonbClassLevel) {
      return _i117.ObjectWithJsonbClassLevel.fromJson(data) as T;
    }
    if (t == _i118.ObjectWithMaps) {
      return _i118.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i119.ObjectWithObject) {
      return _i119.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i120.ObjectWithParent) {
      return _i120.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i121.ObjectWithSealedClass) {
      return _i121.ObjectWithSealedClass.fromJson(data) as T;
    }
    if (t == _i122.ObjectWithSelfParent) {
      return _i122.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i123.ObjectWithSparseVector) {
      return _i123.ObjectWithSparseVector.fromJson(data) as T;
    }
    if (t == _i124.ObjectWithUuid) {
      return _i124.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i125.ObjectWithVector) {
      return _i125.ObjectWithVector.fromJson(data) as T;
    }
    if (t == _i126.RelatedUniqueData) {
      return _i126.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i127.ModelWithRequiredField) {
      return _i127.ModelWithRequiredField.fromJson(data) as T;
    }
    if (t == _i128.SimpleData) {
      return _i128.SimpleData.fromJson(data) as T;
    }
    if (t == _i129.SimpleDateTime) {
      return _i129.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i130.TestEnum) {
      return _i130.TestEnum.fromJson(data) as T;
    }
    if (t == _i131.TestEnumDefaultSerialization) {
      return _i131.TestEnumDefaultSerialization.fromJson(data) as T;
    }
    if (t == _i132.TestEnumEnhanced) {
      return _i132.TestEnumEnhanced.fromJson(data) as T;
    }
    if (t == _i133.TestEnumEnhancedByName) {
      return _i133.TestEnumEnhancedByName.fromJson(data) as T;
    }
    if (t == _i134.TestEnumStringified) {
      return _i134.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i135.Types) {
      return _i135.Types.fromJson(data) as T;
    }
    if (t == _i136.UniqueData) {
      return _i136.UniqueData.fromJson(data) as T;
    }
    if (t == _i137.UniqueDataWithNonPersist) {
      return _i137.UniqueDataWithNonPersist.fromJson(data) as T;
    }
    if (t == _i138.getType<_i2.CourseUuid?>()) {
      return (data != null ? _i2.CourseUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i3.EnrollmentInt?>()) {
      return (data != null ? _i3.EnrollmentInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i4.StudentUuid?>()) {
      return (data != null ? _i4.StudentUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i5.ArenaUuid?>()) {
      return (data != null ? _i5.ArenaUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i6.PlayerUuid?>()) {
      return (data != null ? _i6.PlayerUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i7.TeamInt?>()) {
      return (data != null ? _i7.TeamInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i8.CommentInt?>()) {
      return (data != null ? _i8.CommentInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i9.CustomerInt?>()) {
      return (data != null ? _i9.CustomerInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i10.OrderUuid?>()) {
      return (data != null ? _i10.OrderUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i11.AddressUuid?>()) {
      return (data != null ? _i11.AddressUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i12.CitizenInt?>()) {
      return (data != null ? _i12.CitizenInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i13.CompanyUuid?>()) {
      return (data != null ? _i13.CompanyUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i14.TownInt?>()) {
      return (data != null ? _i14.TownInt.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i15.ChangedIdTypeSelf?>()) {
      return (data != null ? _i15.ChangedIdTypeSelf.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i16.BigIntDefault?>()) {
      return (data != null ? _i16.BigIntDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i17.BigIntDefaultMix?>()) {
      return (data != null ? _i17.BigIntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i18.BigIntDefaultModel?>()) {
      return (data != null ? _i18.BigIntDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i19.BigIntDefaultPersist?>()) {
      return (data != null ? _i19.BigIntDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i20.BoolDefault?>()) {
      return (data != null ? _i20.BoolDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i21.BoolDefaultMix?>()) {
      return (data != null ? _i21.BoolDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i22.BoolDefaultModel?>()) {
      return (data != null ? _i22.BoolDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i23.BoolDefaultPersist?>()) {
      return (data != null ? _i23.BoolDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i24.DateTimeDefault?>()) {
      return (data != null ? _i24.DateTimeDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i25.DateTimeDefaultMix?>()) {
      return (data != null ? _i25.DateTimeDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i26.DateTimeDefaultModel?>()) {
      return (data != null ? _i26.DateTimeDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i27.DateTimeDefaultPersist?>()) {
      return (data != null ? _i27.DateTimeDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i28.DoubleDefault?>()) {
      return (data != null ? _i28.DoubleDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i29.DoubleDefaultMix?>()) {
      return (data != null ? _i29.DoubleDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i30.DoubleDefaultModel?>()) {
      return (data != null ? _i30.DoubleDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i31.DoubleDefaultPersist?>()) {
      return (data != null ? _i31.DoubleDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i32.DurationDefault?>()) {
      return (data != null ? _i32.DurationDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i33.DurationDefaultMix?>()) {
      return (data != null ? _i33.DurationDefaultMix.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i34.DurationDefaultModel?>()) {
      return (data != null ? _i34.DurationDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i35.DurationDefaultPersist?>()) {
      return (data != null ? _i35.DurationDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i36.EnumDefault?>()) {
      return (data != null ? _i36.EnumDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i37.EnumDefaultMix?>()) {
      return (data != null ? _i37.EnumDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i38.EnumDefaultModel?>()) {
      return (data != null ? _i38.EnumDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i39.EnumDefaultPersist?>()) {
      return (data != null ? _i39.EnumDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i40.ByIndexEnum?>()) {
      return (data != null ? _i40.ByIndexEnum.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i41.ByNameEnum?>()) {
      return (data != null ? _i41.ByNameEnum.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i42.DefaultValueEnum?>()) {
      return (data != null ? _i42.DefaultValueEnum.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i43.DefaultException?>()) {
      return (data != null ? _i43.DefaultException.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i44.IntDefault?>()) {
      return (data != null ? _i44.IntDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i45.IntDefaultMix?>()) {
      return (data != null ? _i45.IntDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i46.IntDefaultModel?>()) {
      return (data != null ? _i46.IntDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i47.IntDefaultPersist?>()) {
      return (data != null ? _i47.IntDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i48.StringDefault?>()) {
      return (data != null ? _i48.StringDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i49.StringDefaultMix?>()) {
      return (data != null ? _i49.StringDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i50.StringDefaultModel?>()) {
      return (data != null ? _i50.StringDefaultModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i51.StringDefaultPersist?>()) {
      return (data != null ? _i51.StringDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i52.UriDefault?>()) {
      return (data != null ? _i52.UriDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i53.UriDefaultMix?>()) {
      return (data != null ? _i53.UriDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i54.UriDefaultModel?>()) {
      return (data != null ? _i54.UriDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i55.UriDefaultPersist?>()) {
      return (data != null ? _i55.UriDefaultPersist.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i56.UuidDefault?>()) {
      return (data != null ? _i56.UuidDefault.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i57.UuidDefaultMix?>()) {
      return (data != null ? _i57.UuidDefaultMix.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i58.UuidDefaultModel?>()) {
      return (data != null ? _i58.UuidDefaultModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i59.UuidDefaultPersist?>()) {
      return (data != null ? _i59.UuidDefaultPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i60.EmptyModel?>()) {
      return (data != null ? _i60.EmptyModel.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i61.EmptyModelRelationItem?>()) {
      return (data != null ? _i61.EmptyModelRelationItem.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i62.EmptyModelWithTable?>()) {
      return (data != null ? _i62.EmptyModelWithTable.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i63.RelationEmptyModel?>()) {
      return (data != null ? _i63.RelationEmptyModel.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i64.ChildClassExplicitColumn?>()) {
      return (data != null
              ? _i64.ChildClassExplicitColumn.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i65.NonTableParentClass?>()) {
      return (data != null ? _i65.NonTableParentClass.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i66.ModifiedColumnName?>()) {
      return (data != null ? _i66.ModifiedColumnName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i67.Department?>()) {
      return (data != null ? _i67.Department.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i68.Employee?>()) {
      return (data != null ? _i68.Employee.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i69.Contractor?>()) {
      return (data != null ? _i69.Contractor.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i70.Service?>()) {
      return (data != null ? _i70.Service.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i71.TableWithExplicitColumnName?>()) {
      return (data != null
              ? _i71.TableWithExplicitColumnName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i72.SealedGrandChild?>()) {
      return (data != null ? _i72.SealedGrandChild.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i72.SealedChild?>()) {
      return (data != null ? _i72.SealedChild.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i72.SealedOtherChild?>()) {
      return (data != null ? _i72.SealedOtherChild.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i73.CityWithLongTableName?>()) {
      return (data != null ? _i73.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i74.OrganizationWithLongTableName?>()) {
      return (data != null
              ? _i74.OrganizationWithLongTableName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i75.PersonWithLongTableName?>()) {
      return (data != null ? _i75.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i76.MaxFieldName?>()) {
      return (data != null ? _i76.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i77.LongImplicitIdField?>()) {
      return (data != null ? _i77.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i78.LongImplicitIdFieldCollection?>()) {
      return (data != null
              ? _i78.LongImplicitIdFieldCollection.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i79.RelationToMultipleMaxFieldName?>()) {
      return (data != null
              ? _i79.RelationToMultipleMaxFieldName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i80.UserNote?>()) {
      return (data != null ? _i80.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i81.UserNoteCollection?>()) {
      return (data != null ? _i81.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i82.UserNoteCollectionWithALongName?>()) {
      return (data != null
              ? _i82.UserNoteCollectionWithALongName.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i83.UserNoteWithALongName?>()) {
      return (data != null ? _i83.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i84.MultipleMaxFieldName?>()) {
      return (data != null ? _i84.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i85.City?>()) {
      return (data != null ? _i85.City.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i86.Organization?>()) {
      return (data != null ? _i86.Organization.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i87.Person?>()) {
      return (data != null ? _i87.Person.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i88.Course?>()) {
      return (data != null ? _i88.Course.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i89.Enrollment?>()) {
      return (data != null ? _i89.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i90.Student?>()) {
      return (data != null ? _i90.Student.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i91.Arena?>()) {
      return (data != null ? _i91.Arena.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i92.Player?>()) {
      return (data != null ? _i92.Player.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i93.Team?>()) {
      return (data != null ? _i93.Team.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i94.Comment?>()) {
      return (data != null ? _i94.Comment.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i95.Customer?>()) {
      return (data != null ? _i95.Customer.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i96.Book?>()) {
      return (data != null ? _i96.Book.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i97.Chapter?>()) {
      return (data != null ? _i97.Chapter.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i98.Order?>()) {
      return (data != null ? _i98.Order.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i99.Address?>()) {
      return (data != null ? _i99.Address.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i100.Citizen?>()) {
      return (data != null ? _i100.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i101.Company?>()) {
      return (data != null ? _i101.Company.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i102.Town?>()) {
      return (data != null ? _i102.Town.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i103.Blocking?>()) {
      return (data != null ? _i103.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i104.Member?>()) {
      return (data != null ? _i104.Member.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i105.Cat?>()) {
      return (data != null ? _i105.Cat.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i106.Post?>()) {
      return (data != null ? _i106.Post.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i107.ObjectFieldPersist?>()) {
      return (data != null ? _i107.ObjectFieldPersist.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i108.ObjectFieldScopes?>()) {
      return (data != null ? _i108.ObjectFieldScopes.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i109.ObjectWithBit?>()) {
      return (data != null ? _i109.ObjectWithBit.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i110.ObjectWithByteData?>()) {
      return (data != null ? _i110.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i111.ObjectWithDuration?>()) {
      return (data != null ? _i111.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i112.ObjectWithEnum?>()) {
      return (data != null ? _i112.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i113.ObjectWithEnumEnhanced?>()) {
      return (data != null ? _i113.ObjectWithEnumEnhanced.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i114.ObjectWithHalfVector?>()) {
      return (data != null ? _i114.ObjectWithHalfVector.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i115.ObjectWithIndex?>()) {
      return (data != null ? _i115.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i116.ObjectWithJsonb?>()) {
      return (data != null ? _i116.ObjectWithJsonb.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i117.ObjectWithJsonbClassLevel?>()) {
      return (data != null
              ? _i117.ObjectWithJsonbClassLevel.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i118.ObjectWithMaps?>()) {
      return (data != null ? _i118.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i119.ObjectWithObject?>()) {
      return (data != null ? _i119.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i120.ObjectWithParent?>()) {
      return (data != null ? _i120.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i121.ObjectWithSealedClass?>()) {
      return (data != null ? _i121.ObjectWithSealedClass.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i122.ObjectWithSelfParent?>()) {
      return (data != null ? _i122.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i123.ObjectWithSparseVector?>()) {
      return (data != null ? _i123.ObjectWithSparseVector.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i124.ObjectWithUuid?>()) {
      return (data != null ? _i124.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i125.ObjectWithVector?>()) {
      return (data != null ? _i125.ObjectWithVector.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i126.RelatedUniqueData?>()) {
      return (data != null ? _i126.RelatedUniqueData.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i127.ModelWithRequiredField?>()) {
      return (data != null ? _i127.ModelWithRequiredField.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i128.SimpleData?>()) {
      return (data != null ? _i128.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i129.SimpleDateTime?>()) {
      return (data != null ? _i129.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i130.TestEnum?>()) {
      return (data != null ? _i130.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i131.TestEnumDefaultSerialization?>()) {
      return (data != null
              ? _i131.TestEnumDefaultSerialization.fromJson(data)
              : null)
          as T;
    }
    if (t == _i138.getType<_i132.TestEnumEnhanced?>()) {
      return (data != null ? _i132.TestEnumEnhanced.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i133.TestEnumEnhancedByName?>()) {
      return (data != null ? _i133.TestEnumEnhancedByName.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i134.TestEnumStringified?>()) {
      return (data != null ? _i134.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i138.getType<_i135.Types?>()) {
      return (data != null ? _i135.Types.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i136.UniqueData?>()) {
      return (data != null ? _i136.UniqueData.fromJson(data) : null) as T;
    }
    if (t == _i138.getType<_i137.UniqueDataWithNonPersist?>()) {
      return (data != null
              ? _i137.UniqueDataWithNonPersist.fromJson(data)
              : null)
          as T;
    }
    if (t == List<_i3.EnrollmentInt>) {
      return (data as List)
              .map((e) => deserialize<_i3.EnrollmentInt>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i3.EnrollmentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i3.EnrollmentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i6.PlayerUuid>) {
      return (data as List).map((e) => deserialize<_i6.PlayerUuid>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i6.PlayerUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i6.PlayerUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i10.OrderUuid>) {
      return (data as List).map((e) => deserialize<_i10.OrderUuid>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i10.OrderUuid>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i10.OrderUuid>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i8.CommentInt>) {
      return (data as List).map((e) => deserialize<_i8.CommentInt>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i8.CommentInt>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i8.CommentInt>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i15.ChangedIdTypeSelf>) {
      return (data as List)
              .map((e) => deserialize<_i15.ChangedIdTypeSelf>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i15.ChangedIdTypeSelf>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i15.ChangedIdTypeSelf>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i61.EmptyModelRelationItem>) {
      return (data as List)
              .map((e) => deserialize<_i61.EmptyModelRelationItem>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i61.EmptyModelRelationItem>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i61.EmptyModelRelationItem>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i68.Employee>) {
      return (data as List).map((e) => deserialize<_i68.Employee>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i68.Employee>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i68.Employee>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i75.PersonWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i75.PersonWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i75.PersonWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i75.PersonWithLongTableName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i74.OrganizationWithLongTableName>) {
      return (data as List)
              .map((e) => deserialize<_i74.OrganizationWithLongTableName>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i74.OrganizationWithLongTableName>?>()) {
      return (data != null
              ? (data as List)
                    .map(
                      (e) => deserialize<_i74.OrganizationWithLongTableName>(e),
                    )
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i77.LongImplicitIdField>) {
      return (data as List)
              .map((e) => deserialize<_i77.LongImplicitIdField>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i77.LongImplicitIdField>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i77.LongImplicitIdField>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i84.MultipleMaxFieldName>) {
      return (data as List)
              .map((e) => deserialize<_i84.MultipleMaxFieldName>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i84.MultipleMaxFieldName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i84.MultipleMaxFieldName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i80.UserNote>) {
      return (data as List).map((e) => deserialize<_i80.UserNote>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i80.UserNote>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i80.UserNote>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i83.UserNoteWithALongName>) {
      return (data as List)
              .map((e) => deserialize<_i83.UserNoteWithALongName>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i83.UserNoteWithALongName>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i83.UserNoteWithALongName>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i87.Person>) {
      return (data as List).map((e) => deserialize<_i87.Person>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i87.Person>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i87.Person>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i86.Organization>) {
      return (data as List)
              .map((e) => deserialize<_i86.Organization>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i86.Organization>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i86.Organization>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i89.Enrollment>) {
      return (data as List).map((e) => deserialize<_i89.Enrollment>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i89.Enrollment>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i89.Enrollment>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i92.Player>) {
      return (data as List).map((e) => deserialize<_i92.Player>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i92.Player>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i92.Player>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i98.Order>) {
      return (data as List).map((e) => deserialize<_i98.Order>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i98.Order>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i98.Order>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i97.Chapter>) {
      return (data as List).map((e) => deserialize<_i97.Chapter>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i97.Chapter>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i97.Chapter>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i94.Comment>) {
      return (data as List).map((e) => deserialize<_i94.Comment>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i94.Comment>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i94.Comment>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i103.Blocking>) {
      return (data as List).map((e) => deserialize<_i103.Blocking>(e)).toList()
          as T;
    }
    if (t == _i138.getType<List<_i103.Blocking>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i103.Blocking>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i105.Cat>) {
      return (data as List).map((e) => deserialize<_i105.Cat>(e)).toList() as T;
    }
    if (t == _i138.getType<List<_i105.Cat>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<_i105.Cat>(e)).toList()
              : null)
          as T;
    }
    if (t == List<_i130.TestEnum>) {
      return (data as List).map((e) => deserialize<_i130.TestEnum>(e)).toList()
          as T;
    }
    if (t == List<_i130.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i130.TestEnum?>(e)).toList()
          as T;
    }
    if (t == List<List<_i130.TestEnum>>) {
      return (data as List)
              .map((e) => deserialize<List<_i130.TestEnum>>(e))
              .toList()
          as T;
    }
    if (t == List<_i132.TestEnumEnhanced>) {
      return (data as List)
              .map((e) => deserialize<_i132.TestEnumEnhanced>(e))
              .toList()
          as T;
    }
    if (t == List<_i133.TestEnumEnhancedByName>) {
      return (data as List)
              .map((e) => deserialize<_i133.TestEnumEnhancedByName>(e))
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
    if (t == _i138.getType<List<String>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<String>(e)).toList()
              : null)
          as T;
    }
    if (t == Map<String, _i128.SimpleData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i128.SimpleData>(v),
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
    if (t == Map<String, _i139.ByteData>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i139.ByteData>(v),
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
    if (t == Map<String, _i138.UuidValue>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i138.UuidValue>(v),
            ),
          )
          as T;
    }
    if (t == Map<String, _i128.SimpleData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i128.SimpleData?>(v),
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
    if (t == Map<String, _i139.ByteData?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i139.ByteData?>(v),
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
    if (t == Map<String, _i138.UuidValue?>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<_i138.UuidValue?>(v),
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
    if (t == List<_i128.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i128.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i128.SimpleData>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i128.SimpleData>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<_i128.SimpleData?>) {
      return (data as List)
              .map((e) => deserialize<_i128.SimpleData?>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<_i128.SimpleData?>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<_i128.SimpleData?>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == List<List<_i128.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<List<_i128.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<List<List<_i128.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<List<_i128.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, List<List<Map<int, _i128.SimpleData>>?>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<List<List<Map<int, _i128.SimpleData>>?>>(v),
            ),
          )
          as T;
    }
    if (t == List<List<Map<int, _i128.SimpleData>>?>) {
      return (data as List)
              .map((e) => deserialize<List<Map<int, _i128.SimpleData>>?>(e))
              .toList()
          as T;
    }
    if (t == List<Map<int, _i128.SimpleData>>) {
      return (data as List)
              .map((e) => deserialize<Map<int, _i128.SimpleData>>(e))
              .toList()
          as T;
    }
    if (t == Map<int, _i128.SimpleData>) {
      return Map.fromEntries(
            (data as List).map(
              (e) => MapEntry(
                deserialize<int>(e['k']),
                deserialize<_i128.SimpleData>(e['v']),
              ),
            ),
          )
          as T;
    }
    if (t == _i138.getType<List<Map<int, _i128.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i128.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t ==
        _i138
            .getType<Map<String, List<List<Map<int, _i128.SimpleData>>?>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<List<List<Map<int, _i128.SimpleData>>?>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == _i138.getType<List<Map<int, _i128.SimpleData>>?>()) {
      return (data != null
              ? (data as List)
                    .map((e) => deserialize<Map<int, _i128.SimpleData>>(e))
                    .toList()
              : null)
          as T;
    }
    if (t == Map<String, Map<int, _i128.SimpleData>>) {
      return (data as Map).map(
            (k, v) => MapEntry(
              deserialize<String>(k),
              deserialize<Map<int, _i128.SimpleData>>(v),
            ),
          )
          as T;
    }
    if (t == _i138.getType<Map<String, Map<int, _i128.SimpleData>>?>()) {
      return (data != null
              ? (data as Map).map(
                  (k, v) => MapEntry(
                    deserialize<String>(k),
                    deserialize<Map<int, _i128.SimpleData>>(v),
                  ),
                )
              : null)
          as T;
    }
    if (t == List<_i72.SealedParent>) {
      return (data as List)
              .map((e) => deserialize<_i72.SealedParent>(e))
              .toList()
          as T;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as T;
    }
    if (t == _i138.getType<List<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toList()
              : null)
          as T;
    }
    if (t == _i138.getType<Map<int, int>?>()) {
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
    if (t == _i138.getType<Set<int>?>()) {
      return (data != null
              ? (data as List).map((e) => deserialize<int>(e)).toSet()
              : null)
          as T;
    }
    if (t == _i138.getType<(String, {Uri? optionalUri})?>()) {
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
    if (t == List<_i140.SimpleData>) {
      return (data as List)
              .map((e) => deserialize<_i140.SimpleData>(e))
              .toList()
          as T;
    }
    if (t == _i138.getType<(String, {Uri? optionalUri})?>()) {
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
      return _i141.Protocol().deserialize<T>(data, t);
    } on _i138.DeserializationTypeNotFoundException catch (_) {}
    return super.deserialize<T>(data, t);
  }

  static String? getClassNameForType(Type type) {
    return switch (type) {
      _i2.CourseUuid => 'CourseUuid',
      _i3.EnrollmentInt => 'EnrollmentInt',
      _i4.StudentUuid => 'StudentUuid',
      _i5.ArenaUuid => 'ArenaUuid',
      _i6.PlayerUuid => 'PlayerUuid',
      _i7.TeamInt => 'TeamInt',
      _i8.CommentInt => 'CommentInt',
      _i9.CustomerInt => 'CustomerInt',
      _i10.OrderUuid => 'OrderUuid',
      _i11.AddressUuid => 'AddressUuid',
      _i12.CitizenInt => 'CitizenInt',
      _i13.CompanyUuid => 'CompanyUuid',
      _i14.TownInt => 'TownInt',
      _i15.ChangedIdTypeSelf => 'ChangedIdTypeSelf',
      _i16.BigIntDefault => 'BigIntDefault',
      _i17.BigIntDefaultMix => 'BigIntDefaultMix',
      _i18.BigIntDefaultModel => 'BigIntDefaultModel',
      _i19.BigIntDefaultPersist => 'BigIntDefaultPersist',
      _i20.BoolDefault => 'BoolDefault',
      _i21.BoolDefaultMix => 'BoolDefaultMix',
      _i22.BoolDefaultModel => 'BoolDefaultModel',
      _i23.BoolDefaultPersist => 'BoolDefaultPersist',
      _i24.DateTimeDefault => 'DateTimeDefault',
      _i25.DateTimeDefaultMix => 'DateTimeDefaultMix',
      _i26.DateTimeDefaultModel => 'DateTimeDefaultModel',
      _i27.DateTimeDefaultPersist => 'DateTimeDefaultPersist',
      _i28.DoubleDefault => 'DoubleDefault',
      _i29.DoubleDefaultMix => 'DoubleDefaultMix',
      _i30.DoubleDefaultModel => 'DoubleDefaultModel',
      _i31.DoubleDefaultPersist => 'DoubleDefaultPersist',
      _i32.DurationDefault => 'DurationDefault',
      _i33.DurationDefaultMix => 'DurationDefaultMix',
      _i34.DurationDefaultModel => 'DurationDefaultModel',
      _i35.DurationDefaultPersist => 'DurationDefaultPersist',
      _i36.EnumDefault => 'EnumDefault',
      _i37.EnumDefaultMix => 'EnumDefaultMix',
      _i38.EnumDefaultModel => 'EnumDefaultModel',
      _i39.EnumDefaultPersist => 'EnumDefaultPersist',
      _i40.ByIndexEnum => 'ByIndexEnum',
      _i41.ByNameEnum => 'ByNameEnum',
      _i42.DefaultValueEnum => 'DefaultValueEnum',
      _i43.DefaultException => 'DefaultException',
      _i44.IntDefault => 'IntDefault',
      _i45.IntDefaultMix => 'IntDefaultMix',
      _i46.IntDefaultModel => 'IntDefaultModel',
      _i47.IntDefaultPersist => 'IntDefaultPersist',
      _i48.StringDefault => 'StringDefault',
      _i49.StringDefaultMix => 'StringDefaultMix',
      _i50.StringDefaultModel => 'StringDefaultModel',
      _i51.StringDefaultPersist => 'StringDefaultPersist',
      _i52.UriDefault => 'UriDefault',
      _i53.UriDefaultMix => 'UriDefaultMix',
      _i54.UriDefaultModel => 'UriDefaultModel',
      _i55.UriDefaultPersist => 'UriDefaultPersist',
      _i56.UuidDefault => 'UuidDefault',
      _i57.UuidDefaultMix => 'UuidDefaultMix',
      _i58.UuidDefaultModel => 'UuidDefaultModel',
      _i59.UuidDefaultPersist => 'UuidDefaultPersist',
      _i60.EmptyModel => 'EmptyModel',
      _i61.EmptyModelRelationItem => 'EmptyModelRelationItem',
      _i62.EmptyModelWithTable => 'EmptyModelWithTable',
      _i63.RelationEmptyModel => 'RelationEmptyModel',
      _i64.ChildClassExplicitColumn => 'ChildClassExplicitColumn',
      _i65.NonTableParentClass => 'NonTableParentClass',
      _i66.ModifiedColumnName => 'ModifiedColumnName',
      _i67.Department => 'Department',
      _i68.Employee => 'Employee',
      _i69.Contractor => 'Contractor',
      _i70.Service => 'Service',
      _i71.TableWithExplicitColumnName => 'TableWithExplicitColumnName',
      _i72.SealedGrandChild => 'SealedGrandChild',
      _i72.SealedChild => 'SealedChild',
      _i72.SealedOtherChild => 'SealedOtherChild',
      _i73.CityWithLongTableName => 'CityWithLongTableName',
      _i74.OrganizationWithLongTableName => 'OrganizationWithLongTableName',
      _i75.PersonWithLongTableName => 'PersonWithLongTableName',
      _i76.MaxFieldName => 'MaxFieldName',
      _i77.LongImplicitIdField => 'LongImplicitIdField',
      _i78.LongImplicitIdFieldCollection => 'LongImplicitIdFieldCollection',
      _i79.RelationToMultipleMaxFieldName => 'RelationToMultipleMaxFieldName',
      _i80.UserNote => 'UserNote',
      _i81.UserNoteCollection => 'UserNoteCollection',
      _i82.UserNoteCollectionWithALongName => 'UserNoteCollectionWithALongName',
      _i83.UserNoteWithALongName => 'UserNoteWithALongName',
      _i84.MultipleMaxFieldName => 'MultipleMaxFieldName',
      _i85.City => 'City',
      _i86.Organization => 'Organization',
      _i87.Person => 'Person',
      _i88.Course => 'Course',
      _i89.Enrollment => 'Enrollment',
      _i90.Student => 'Student',
      _i91.Arena => 'Arena',
      _i92.Player => 'Player',
      _i93.Team => 'Team',
      _i94.Comment => 'Comment',
      _i95.Customer => 'Customer',
      _i96.Book => 'Book',
      _i97.Chapter => 'Chapter',
      _i98.Order => 'Order',
      _i99.Address => 'Address',
      _i100.Citizen => 'Citizen',
      _i101.Company => 'Company',
      _i102.Town => 'Town',
      _i103.Blocking => 'Blocking',
      _i104.Member => 'Member',
      _i105.Cat => 'Cat',
      _i106.Post => 'Post',
      _i107.ObjectFieldPersist => 'ObjectFieldPersist',
      _i108.ObjectFieldScopes => 'ObjectFieldScopes',
      _i109.ObjectWithBit => 'ObjectWithBit',
      _i110.ObjectWithByteData => 'ObjectWithByteData',
      _i111.ObjectWithDuration => 'ObjectWithDuration',
      _i112.ObjectWithEnum => 'ObjectWithEnum',
      _i113.ObjectWithEnumEnhanced => 'ObjectWithEnumEnhanced',
      _i114.ObjectWithHalfVector => 'ObjectWithHalfVector',
      _i115.ObjectWithIndex => 'ObjectWithIndex',
      _i116.ObjectWithJsonb => 'ObjectWithJsonb',
      _i117.ObjectWithJsonbClassLevel => 'ObjectWithJsonbClassLevel',
      _i118.ObjectWithMaps => 'ObjectWithMaps',
      _i119.ObjectWithObject => 'ObjectWithObject',
      _i120.ObjectWithParent => 'ObjectWithParent',
      _i121.ObjectWithSealedClass => 'ObjectWithSealedClass',
      _i122.ObjectWithSelfParent => 'ObjectWithSelfParent',
      _i123.ObjectWithSparseVector => 'ObjectWithSparseVector',
      _i124.ObjectWithUuid => 'ObjectWithUuid',
      _i125.ObjectWithVector => 'ObjectWithVector',
      _i126.RelatedUniqueData => 'RelatedUniqueData',
      _i127.ModelWithRequiredField => 'ModelWithRequiredField',
      _i128.SimpleData => 'SimpleData',
      _i129.SimpleDateTime => 'SimpleDateTime',
      _i130.TestEnum => 'TestEnum',
      _i131.TestEnumDefaultSerialization => 'TestEnumDefaultSerialization',
      _i132.TestEnumEnhanced => 'TestEnumEnhanced',
      _i133.TestEnumEnhancedByName => 'TestEnumEnhancedByName',
      _i134.TestEnumStringified => 'TestEnumStringified',
      _i135.Types => 'Types',
      _i136.UniqueData => 'UniqueData',
      _i137.UniqueDataWithNonPersist => 'UniqueDataWithNonPersist',
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
      case _i2.CourseUuid():
        return 'CourseUuid';
      case _i3.EnrollmentInt():
        return 'EnrollmentInt';
      case _i4.StudentUuid():
        return 'StudentUuid';
      case _i5.ArenaUuid():
        return 'ArenaUuid';
      case _i6.PlayerUuid():
        return 'PlayerUuid';
      case _i7.TeamInt():
        return 'TeamInt';
      case _i8.CommentInt():
        return 'CommentInt';
      case _i9.CustomerInt():
        return 'CustomerInt';
      case _i10.OrderUuid():
        return 'OrderUuid';
      case _i11.AddressUuid():
        return 'AddressUuid';
      case _i12.CitizenInt():
        return 'CitizenInt';
      case _i13.CompanyUuid():
        return 'CompanyUuid';
      case _i14.TownInt():
        return 'TownInt';
      case _i15.ChangedIdTypeSelf():
        return 'ChangedIdTypeSelf';
      case _i16.BigIntDefault():
        return 'BigIntDefault';
      case _i17.BigIntDefaultMix():
        return 'BigIntDefaultMix';
      case _i18.BigIntDefaultModel():
        return 'BigIntDefaultModel';
      case _i19.BigIntDefaultPersist():
        return 'BigIntDefaultPersist';
      case _i20.BoolDefault():
        return 'BoolDefault';
      case _i21.BoolDefaultMix():
        return 'BoolDefaultMix';
      case _i22.BoolDefaultModel():
        return 'BoolDefaultModel';
      case _i23.BoolDefaultPersist():
        return 'BoolDefaultPersist';
      case _i24.DateTimeDefault():
        return 'DateTimeDefault';
      case _i25.DateTimeDefaultMix():
        return 'DateTimeDefaultMix';
      case _i26.DateTimeDefaultModel():
        return 'DateTimeDefaultModel';
      case _i27.DateTimeDefaultPersist():
        return 'DateTimeDefaultPersist';
      case _i28.DoubleDefault():
        return 'DoubleDefault';
      case _i29.DoubleDefaultMix():
        return 'DoubleDefaultMix';
      case _i30.DoubleDefaultModel():
        return 'DoubleDefaultModel';
      case _i31.DoubleDefaultPersist():
        return 'DoubleDefaultPersist';
      case _i32.DurationDefault():
        return 'DurationDefault';
      case _i33.DurationDefaultMix():
        return 'DurationDefaultMix';
      case _i34.DurationDefaultModel():
        return 'DurationDefaultModel';
      case _i35.DurationDefaultPersist():
        return 'DurationDefaultPersist';
      case _i36.EnumDefault():
        return 'EnumDefault';
      case _i37.EnumDefaultMix():
        return 'EnumDefaultMix';
      case _i38.EnumDefaultModel():
        return 'EnumDefaultModel';
      case _i39.EnumDefaultPersist():
        return 'EnumDefaultPersist';
      case _i40.ByIndexEnum():
        return 'ByIndexEnum';
      case _i41.ByNameEnum():
        return 'ByNameEnum';
      case _i42.DefaultValueEnum():
        return 'DefaultValueEnum';
      case _i43.DefaultException():
        return 'DefaultException';
      case _i44.IntDefault():
        return 'IntDefault';
      case _i45.IntDefaultMix():
        return 'IntDefaultMix';
      case _i46.IntDefaultModel():
        return 'IntDefaultModel';
      case _i47.IntDefaultPersist():
        return 'IntDefaultPersist';
      case _i48.StringDefault():
        return 'StringDefault';
      case _i49.StringDefaultMix():
        return 'StringDefaultMix';
      case _i50.StringDefaultModel():
        return 'StringDefaultModel';
      case _i51.StringDefaultPersist():
        return 'StringDefaultPersist';
      case _i52.UriDefault():
        return 'UriDefault';
      case _i53.UriDefaultMix():
        return 'UriDefaultMix';
      case _i54.UriDefaultModel():
        return 'UriDefaultModel';
      case _i55.UriDefaultPersist():
        return 'UriDefaultPersist';
      case _i56.UuidDefault():
        return 'UuidDefault';
      case _i57.UuidDefaultMix():
        return 'UuidDefaultMix';
      case _i58.UuidDefaultModel():
        return 'UuidDefaultModel';
      case _i59.UuidDefaultPersist():
        return 'UuidDefaultPersist';
      case _i60.EmptyModel():
        return 'EmptyModel';
      case _i61.EmptyModelRelationItem():
        return 'EmptyModelRelationItem';
      case _i62.EmptyModelWithTable():
        return 'EmptyModelWithTable';
      case _i63.RelationEmptyModel():
        return 'RelationEmptyModel';
      case _i64.ChildClassExplicitColumn():
        return 'ChildClassExplicitColumn';
      case _i65.NonTableParentClass():
        return 'NonTableParentClass';
      case _i66.ModifiedColumnName():
        return 'ModifiedColumnName';
      case _i67.Department():
        return 'Department';
      case _i68.Employee():
        return 'Employee';
      case _i69.Contractor():
        return 'Contractor';
      case _i70.Service():
        return 'Service';
      case _i71.TableWithExplicitColumnName():
        return 'TableWithExplicitColumnName';
      case _i72.SealedGrandChild():
        return 'SealedGrandChild';
      case _i72.SealedChild():
        return 'SealedChild';
      case _i72.SealedOtherChild():
        return 'SealedOtherChild';
      case _i73.CityWithLongTableName():
        return 'CityWithLongTableName';
      case _i74.OrganizationWithLongTableName():
        return 'OrganizationWithLongTableName';
      case _i75.PersonWithLongTableName():
        return 'PersonWithLongTableName';
      case _i76.MaxFieldName():
        return 'MaxFieldName';
      case _i77.LongImplicitIdField():
        return 'LongImplicitIdField';
      case _i78.LongImplicitIdFieldCollection():
        return 'LongImplicitIdFieldCollection';
      case _i79.RelationToMultipleMaxFieldName():
        return 'RelationToMultipleMaxFieldName';
      case _i80.UserNote():
        return 'UserNote';
      case _i81.UserNoteCollection():
        return 'UserNoteCollection';
      case _i82.UserNoteCollectionWithALongName():
        return 'UserNoteCollectionWithALongName';
      case _i83.UserNoteWithALongName():
        return 'UserNoteWithALongName';
      case _i84.MultipleMaxFieldName():
        return 'MultipleMaxFieldName';
      case _i85.City():
        return 'City';
      case _i86.Organization():
        return 'Organization';
      case _i87.Person():
        return 'Person';
      case _i88.Course():
        return 'Course';
      case _i89.Enrollment():
        return 'Enrollment';
      case _i90.Student():
        return 'Student';
      case _i91.Arena():
        return 'Arena';
      case _i92.Player():
        return 'Player';
      case _i93.Team():
        return 'Team';
      case _i94.Comment():
        return 'Comment';
      case _i95.Customer():
        return 'Customer';
      case _i96.Book():
        return 'Book';
      case _i97.Chapter():
        return 'Chapter';
      case _i98.Order():
        return 'Order';
      case _i99.Address():
        return 'Address';
      case _i100.Citizen():
        return 'Citizen';
      case _i101.Company():
        return 'Company';
      case _i102.Town():
        return 'Town';
      case _i103.Blocking():
        return 'Blocking';
      case _i104.Member():
        return 'Member';
      case _i105.Cat():
        return 'Cat';
      case _i106.Post():
        return 'Post';
      case _i107.ObjectFieldPersist():
        return 'ObjectFieldPersist';
      case _i108.ObjectFieldScopes():
        return 'ObjectFieldScopes';
      case _i109.ObjectWithBit():
        return 'ObjectWithBit';
      case _i110.ObjectWithByteData():
        return 'ObjectWithByteData';
      case _i111.ObjectWithDuration():
        return 'ObjectWithDuration';
      case _i112.ObjectWithEnum():
        return 'ObjectWithEnum';
      case _i113.ObjectWithEnumEnhanced():
        return 'ObjectWithEnumEnhanced';
      case _i114.ObjectWithHalfVector():
        return 'ObjectWithHalfVector';
      case _i115.ObjectWithIndex():
        return 'ObjectWithIndex';
      case _i116.ObjectWithJsonb():
        return 'ObjectWithJsonb';
      case _i117.ObjectWithJsonbClassLevel():
        return 'ObjectWithJsonbClassLevel';
      case _i118.ObjectWithMaps():
        return 'ObjectWithMaps';
      case _i119.ObjectWithObject():
        return 'ObjectWithObject';
      case _i120.ObjectWithParent():
        return 'ObjectWithParent';
      case _i121.ObjectWithSealedClass():
        return 'ObjectWithSealedClass';
      case _i122.ObjectWithSelfParent():
        return 'ObjectWithSelfParent';
      case _i123.ObjectWithSparseVector():
        return 'ObjectWithSparseVector';
      case _i124.ObjectWithUuid():
        return 'ObjectWithUuid';
      case _i125.ObjectWithVector():
        return 'ObjectWithVector';
      case _i126.RelatedUniqueData():
        return 'RelatedUniqueData';
      case _i127.ModelWithRequiredField():
        return 'ModelWithRequiredField';
      case _i128.SimpleData():
        return 'SimpleData';
      case _i129.SimpleDateTime():
        return 'SimpleDateTime';
      case _i130.TestEnum():
        return 'TestEnum';
      case _i131.TestEnumDefaultSerialization():
        return 'TestEnumDefaultSerialization';
      case _i132.TestEnumEnhanced():
        return 'TestEnumEnhanced';
      case _i133.TestEnumEnhancedByName():
        return 'TestEnumEnhancedByName';
      case _i134.TestEnumStringified():
        return 'TestEnumStringified';
      case _i135.Types():
        return 'Types';
      case _i136.UniqueData():
        return 'UniqueData';
      case _i137.UniqueDataWithNonPersist():
        return 'UniqueDataWithNonPersist';
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
      return deserialize<_i2.CourseUuid>(data['data']);
    }
    if (dataClassName == 'EnrollmentInt') {
      return deserialize<_i3.EnrollmentInt>(data['data']);
    }
    if (dataClassName == 'StudentUuid') {
      return deserialize<_i4.StudentUuid>(data['data']);
    }
    if (dataClassName == 'ArenaUuid') {
      return deserialize<_i5.ArenaUuid>(data['data']);
    }
    if (dataClassName == 'PlayerUuid') {
      return deserialize<_i6.PlayerUuid>(data['data']);
    }
    if (dataClassName == 'TeamInt') {
      return deserialize<_i7.TeamInt>(data['data']);
    }
    if (dataClassName == 'CommentInt') {
      return deserialize<_i8.CommentInt>(data['data']);
    }
    if (dataClassName == 'CustomerInt') {
      return deserialize<_i9.CustomerInt>(data['data']);
    }
    if (dataClassName == 'OrderUuid') {
      return deserialize<_i10.OrderUuid>(data['data']);
    }
    if (dataClassName == 'AddressUuid') {
      return deserialize<_i11.AddressUuid>(data['data']);
    }
    if (dataClassName == 'CitizenInt') {
      return deserialize<_i12.CitizenInt>(data['data']);
    }
    if (dataClassName == 'CompanyUuid') {
      return deserialize<_i13.CompanyUuid>(data['data']);
    }
    if (dataClassName == 'TownInt') {
      return deserialize<_i14.TownInt>(data['data']);
    }
    if (dataClassName == 'ChangedIdTypeSelf') {
      return deserialize<_i15.ChangedIdTypeSelf>(data['data']);
    }
    if (dataClassName == 'BigIntDefault') {
      return deserialize<_i16.BigIntDefault>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultMix') {
      return deserialize<_i17.BigIntDefaultMix>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultModel') {
      return deserialize<_i18.BigIntDefaultModel>(data['data']);
    }
    if (dataClassName == 'BigIntDefaultPersist') {
      return deserialize<_i19.BigIntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'BoolDefault') {
      return deserialize<_i20.BoolDefault>(data['data']);
    }
    if (dataClassName == 'BoolDefaultMix') {
      return deserialize<_i21.BoolDefaultMix>(data['data']);
    }
    if (dataClassName == 'BoolDefaultModel') {
      return deserialize<_i22.BoolDefaultModel>(data['data']);
    }
    if (dataClassName == 'BoolDefaultPersist') {
      return deserialize<_i23.BoolDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DateTimeDefault') {
      return deserialize<_i24.DateTimeDefault>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultMix') {
      return deserialize<_i25.DateTimeDefaultMix>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultModel') {
      return deserialize<_i26.DateTimeDefaultModel>(data['data']);
    }
    if (dataClassName == 'DateTimeDefaultPersist') {
      return deserialize<_i27.DateTimeDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DoubleDefault') {
      return deserialize<_i28.DoubleDefault>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultMix') {
      return deserialize<_i29.DoubleDefaultMix>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultModel') {
      return deserialize<_i30.DoubleDefaultModel>(data['data']);
    }
    if (dataClassName == 'DoubleDefaultPersist') {
      return deserialize<_i31.DoubleDefaultPersist>(data['data']);
    }
    if (dataClassName == 'DurationDefault') {
      return deserialize<_i32.DurationDefault>(data['data']);
    }
    if (dataClassName == 'DurationDefaultMix') {
      return deserialize<_i33.DurationDefaultMix>(data['data']);
    }
    if (dataClassName == 'DurationDefaultModel') {
      return deserialize<_i34.DurationDefaultModel>(data['data']);
    }
    if (dataClassName == 'DurationDefaultPersist') {
      return deserialize<_i35.DurationDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EnumDefault') {
      return deserialize<_i36.EnumDefault>(data['data']);
    }
    if (dataClassName == 'EnumDefaultMix') {
      return deserialize<_i37.EnumDefaultMix>(data['data']);
    }
    if (dataClassName == 'EnumDefaultModel') {
      return deserialize<_i38.EnumDefaultModel>(data['data']);
    }
    if (dataClassName == 'EnumDefaultPersist') {
      return deserialize<_i39.EnumDefaultPersist>(data['data']);
    }
    if (dataClassName == 'ByIndexEnum') {
      return deserialize<_i40.ByIndexEnum>(data['data']);
    }
    if (dataClassName == 'ByNameEnum') {
      return deserialize<_i41.ByNameEnum>(data['data']);
    }
    if (dataClassName == 'DefaultValueEnum') {
      return deserialize<_i42.DefaultValueEnum>(data['data']);
    }
    if (dataClassName == 'DefaultException') {
      return deserialize<_i43.DefaultException>(data['data']);
    }
    if (dataClassName == 'IntDefault') {
      return deserialize<_i44.IntDefault>(data['data']);
    }
    if (dataClassName == 'IntDefaultMix') {
      return deserialize<_i45.IntDefaultMix>(data['data']);
    }
    if (dataClassName == 'IntDefaultModel') {
      return deserialize<_i46.IntDefaultModel>(data['data']);
    }
    if (dataClassName == 'IntDefaultPersist') {
      return deserialize<_i47.IntDefaultPersist>(data['data']);
    }
    if (dataClassName == 'StringDefault') {
      return deserialize<_i48.StringDefault>(data['data']);
    }
    if (dataClassName == 'StringDefaultMix') {
      return deserialize<_i49.StringDefaultMix>(data['data']);
    }
    if (dataClassName == 'StringDefaultModel') {
      return deserialize<_i50.StringDefaultModel>(data['data']);
    }
    if (dataClassName == 'StringDefaultPersist') {
      return deserialize<_i51.StringDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UriDefault') {
      return deserialize<_i52.UriDefault>(data['data']);
    }
    if (dataClassName == 'UriDefaultMix') {
      return deserialize<_i53.UriDefaultMix>(data['data']);
    }
    if (dataClassName == 'UriDefaultModel') {
      return deserialize<_i54.UriDefaultModel>(data['data']);
    }
    if (dataClassName == 'UriDefaultPersist') {
      return deserialize<_i55.UriDefaultPersist>(data['data']);
    }
    if (dataClassName == 'UuidDefault') {
      return deserialize<_i56.UuidDefault>(data['data']);
    }
    if (dataClassName == 'UuidDefaultMix') {
      return deserialize<_i57.UuidDefaultMix>(data['data']);
    }
    if (dataClassName == 'UuidDefaultModel') {
      return deserialize<_i58.UuidDefaultModel>(data['data']);
    }
    if (dataClassName == 'UuidDefaultPersist') {
      return deserialize<_i59.UuidDefaultPersist>(data['data']);
    }
    if (dataClassName == 'EmptyModel') {
      return deserialize<_i60.EmptyModel>(data['data']);
    }
    if (dataClassName == 'EmptyModelRelationItem') {
      return deserialize<_i61.EmptyModelRelationItem>(data['data']);
    }
    if (dataClassName == 'EmptyModelWithTable') {
      return deserialize<_i62.EmptyModelWithTable>(data['data']);
    }
    if (dataClassName == 'RelationEmptyModel') {
      return deserialize<_i63.RelationEmptyModel>(data['data']);
    }
    if (dataClassName == 'ChildClassExplicitColumn') {
      return deserialize<_i64.ChildClassExplicitColumn>(data['data']);
    }
    if (dataClassName == 'NonTableParentClass') {
      return deserialize<_i65.NonTableParentClass>(data['data']);
    }
    if (dataClassName == 'ModifiedColumnName') {
      return deserialize<_i66.ModifiedColumnName>(data['data']);
    }
    if (dataClassName == 'Department') {
      return deserialize<_i67.Department>(data['data']);
    }
    if (dataClassName == 'Employee') {
      return deserialize<_i68.Employee>(data['data']);
    }
    if (dataClassName == 'Contractor') {
      return deserialize<_i69.Contractor>(data['data']);
    }
    if (dataClassName == 'Service') {
      return deserialize<_i70.Service>(data['data']);
    }
    if (dataClassName == 'TableWithExplicitColumnName') {
      return deserialize<_i71.TableWithExplicitColumnName>(data['data']);
    }
    if (dataClassName == 'SealedGrandChild') {
      return deserialize<_i72.SealedGrandChild>(data['data']);
    }
    if (dataClassName == 'SealedChild') {
      return deserialize<_i72.SealedChild>(data['data']);
    }
    if (dataClassName == 'SealedOtherChild') {
      return deserialize<_i72.SealedOtherChild>(data['data']);
    }
    if (dataClassName == 'CityWithLongTableName') {
      return deserialize<_i73.CityWithLongTableName>(data['data']);
    }
    if (dataClassName == 'OrganizationWithLongTableName') {
      return deserialize<_i74.OrganizationWithLongTableName>(data['data']);
    }
    if (dataClassName == 'PersonWithLongTableName') {
      return deserialize<_i75.PersonWithLongTableName>(data['data']);
    }
    if (dataClassName == 'MaxFieldName') {
      return deserialize<_i76.MaxFieldName>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdField') {
      return deserialize<_i77.LongImplicitIdField>(data['data']);
    }
    if (dataClassName == 'LongImplicitIdFieldCollection') {
      return deserialize<_i78.LongImplicitIdFieldCollection>(data['data']);
    }
    if (dataClassName == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i79.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'UserNote') {
      return deserialize<_i80.UserNote>(data['data']);
    }
    if (dataClassName == 'UserNoteCollection') {
      return deserialize<_i81.UserNoteCollection>(data['data']);
    }
    if (dataClassName == 'UserNoteCollectionWithALongName') {
      return deserialize<_i82.UserNoteCollectionWithALongName>(data['data']);
    }
    if (dataClassName == 'UserNoteWithALongName') {
      return deserialize<_i83.UserNoteWithALongName>(data['data']);
    }
    if (dataClassName == 'MultipleMaxFieldName') {
      return deserialize<_i84.MultipleMaxFieldName>(data['data']);
    }
    if (dataClassName == 'City') {
      return deserialize<_i85.City>(data['data']);
    }
    if (dataClassName == 'Organization') {
      return deserialize<_i86.Organization>(data['data']);
    }
    if (dataClassName == 'Person') {
      return deserialize<_i87.Person>(data['data']);
    }
    if (dataClassName == 'Course') {
      return deserialize<_i88.Course>(data['data']);
    }
    if (dataClassName == 'Enrollment') {
      return deserialize<_i89.Enrollment>(data['data']);
    }
    if (dataClassName == 'Student') {
      return deserialize<_i90.Student>(data['data']);
    }
    if (dataClassName == 'Arena') {
      return deserialize<_i91.Arena>(data['data']);
    }
    if (dataClassName == 'Player') {
      return deserialize<_i92.Player>(data['data']);
    }
    if (dataClassName == 'Team') {
      return deserialize<_i93.Team>(data['data']);
    }
    if (dataClassName == 'Comment') {
      return deserialize<_i94.Comment>(data['data']);
    }
    if (dataClassName == 'Customer') {
      return deserialize<_i95.Customer>(data['data']);
    }
    if (dataClassName == 'Book') {
      return deserialize<_i96.Book>(data['data']);
    }
    if (dataClassName == 'Chapter') {
      return deserialize<_i97.Chapter>(data['data']);
    }
    if (dataClassName == 'Order') {
      return deserialize<_i98.Order>(data['data']);
    }
    if (dataClassName == 'Address') {
      return deserialize<_i99.Address>(data['data']);
    }
    if (dataClassName == 'Citizen') {
      return deserialize<_i100.Citizen>(data['data']);
    }
    if (dataClassName == 'Company') {
      return deserialize<_i101.Company>(data['data']);
    }
    if (dataClassName == 'Town') {
      return deserialize<_i102.Town>(data['data']);
    }
    if (dataClassName == 'Blocking') {
      return deserialize<_i103.Blocking>(data['data']);
    }
    if (dataClassName == 'Member') {
      return deserialize<_i104.Member>(data['data']);
    }
    if (dataClassName == 'Cat') {
      return deserialize<_i105.Cat>(data['data']);
    }
    if (dataClassName == 'Post') {
      return deserialize<_i106.Post>(data['data']);
    }
    if (dataClassName == 'ObjectFieldPersist') {
      return deserialize<_i107.ObjectFieldPersist>(data['data']);
    }
    if (dataClassName == 'ObjectFieldScopes') {
      return deserialize<_i108.ObjectFieldScopes>(data['data']);
    }
    if (dataClassName == 'ObjectWithBit') {
      return deserialize<_i109.ObjectWithBit>(data['data']);
    }
    if (dataClassName == 'ObjectWithByteData') {
      return deserialize<_i110.ObjectWithByteData>(data['data']);
    }
    if (dataClassName == 'ObjectWithDuration') {
      return deserialize<_i111.ObjectWithDuration>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnum') {
      return deserialize<_i112.ObjectWithEnum>(data['data']);
    }
    if (dataClassName == 'ObjectWithEnumEnhanced') {
      return deserialize<_i113.ObjectWithEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'ObjectWithHalfVector') {
      return deserialize<_i114.ObjectWithHalfVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithIndex') {
      return deserialize<_i115.ObjectWithIndex>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonb') {
      return deserialize<_i116.ObjectWithJsonb>(data['data']);
    }
    if (dataClassName == 'ObjectWithJsonbClassLevel') {
      return deserialize<_i117.ObjectWithJsonbClassLevel>(data['data']);
    }
    if (dataClassName == 'ObjectWithMaps') {
      return deserialize<_i118.ObjectWithMaps>(data['data']);
    }
    if (dataClassName == 'ObjectWithObject') {
      return deserialize<_i119.ObjectWithObject>(data['data']);
    }
    if (dataClassName == 'ObjectWithParent') {
      return deserialize<_i120.ObjectWithParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSealedClass') {
      return deserialize<_i121.ObjectWithSealedClass>(data['data']);
    }
    if (dataClassName == 'ObjectWithSelfParent') {
      return deserialize<_i122.ObjectWithSelfParent>(data['data']);
    }
    if (dataClassName == 'ObjectWithSparseVector') {
      return deserialize<_i123.ObjectWithSparseVector>(data['data']);
    }
    if (dataClassName == 'ObjectWithUuid') {
      return deserialize<_i124.ObjectWithUuid>(data['data']);
    }
    if (dataClassName == 'ObjectWithVector') {
      return deserialize<_i125.ObjectWithVector>(data['data']);
    }
    if (dataClassName == 'RelatedUniqueData') {
      return deserialize<_i126.RelatedUniqueData>(data['data']);
    }
    if (dataClassName == 'ModelWithRequiredField') {
      return deserialize<_i127.ModelWithRequiredField>(data['data']);
    }
    if (dataClassName == 'SimpleData') {
      return deserialize<_i128.SimpleData>(data['data']);
    }
    if (dataClassName == 'SimpleDateTime') {
      return deserialize<_i129.SimpleDateTime>(data['data']);
    }
    if (dataClassName == 'TestEnum') {
      return deserialize<_i130.TestEnum>(data['data']);
    }
    if (dataClassName == 'TestEnumDefaultSerialization') {
      return deserialize<_i131.TestEnumDefaultSerialization>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhanced') {
      return deserialize<_i132.TestEnumEnhanced>(data['data']);
    }
    if (dataClassName == 'TestEnumEnhancedByName') {
      return deserialize<_i133.TestEnumEnhancedByName>(data['data']);
    }
    if (dataClassName == 'TestEnumStringified') {
      return deserialize<_i134.TestEnumStringified>(data['data']);
    }
    if (dataClassName == 'Types') {
      return deserialize<_i135.Types>(data['data']);
    }
    if (dataClassName == 'UniqueData') {
      return deserialize<_i136.UniqueData>(data['data']);
    }
    if (dataClassName == 'UniqueDataWithNonPersist') {
      return deserialize<_i137.UniqueDataWithNonPersist>(data['data']);
    }
    return super.deserializeByClassName(data);
  }

  @override
  _i1.Table? getTableForType(Type t) {
    switch (t) {
      case _i61.EmptyModelRelationItem:
        return _i61.EmptyModelRelationItem.t;
      case _i62.EmptyModelWithTable:
        return _i62.EmptyModelWithTable.t;
      case _i63.RelationEmptyModel:
        return _i63.RelationEmptyModel.t;
      case _i85.City:
        return _i85.City.t;
      case _i86.Organization:
        return _i86.Organization.t;
      case _i87.Person:
        return _i87.Person.t;
      case _i88.Course:
        return _i88.Course.t;
      case _i89.Enrollment:
        return _i89.Enrollment.t;
      case _i90.Student:
        return _i90.Student.t;
      case _i91.Arena:
        return _i91.Arena.t;
      case _i92.Player:
        return _i92.Player.t;
      case _i93.Team:
        return _i93.Team.t;
      case _i94.Comment:
        return _i94.Comment.t;
      case _i95.Customer:
        return _i95.Customer.t;
      case _i96.Book:
        return _i96.Book.t;
      case _i97.Chapter:
        return _i97.Chapter.t;
      case _i98.Order:
        return _i98.Order.t;
      case _i99.Address:
        return _i99.Address.t;
      case _i100.Citizen:
        return _i100.Citizen.t;
      case _i101.Company:
        return _i101.Company.t;
      case _i102.Town:
        return _i102.Town.t;
      case _i103.Blocking:
        return _i103.Blocking.t;
      case _i104.Member:
        return _i104.Member.t;
      case _i105.Cat:
        return _i105.Cat.t;
      case _i106.Post:
        return _i106.Post.t;
      case _i107.ObjectFieldPersist:
        return _i107.ObjectFieldPersist.t;
      case _i126.RelatedUniqueData:
        return _i126.RelatedUniqueData.t;
      case _i127.ModelWithRequiredField:
        return _i127.ModelWithRequiredField.t;
      case _i128.SimpleData:
        return _i128.SimpleData.t;
      case _i129.SimpleDateTime:
        return _i129.SimpleDateTime.t;
      case _i135.Types:
        return _i135.Types.t;
      case _i136.UniqueData:
        return _i136.UniqueData.t;
      case _i137.UniqueDataWithNonPersist:
        return _i137.UniqueDataWithNonPersist.t;
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
      return _i141.Protocol().mapRecordToJson(record);
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
