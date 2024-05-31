/* AUTOMATICALLY GENERATED CODE DO NOT MODIFY */
/*   To generate run: "serverpod generate"    */

// ignore_for_file: library_private_types_in_public_api
// ignore_for_file: public_member_api_docs
// ignore_for_file: implementation_imports
// ignore_for_file: use_super_parameters
// ignore_for_file: type_literal_in_constant_pattern

library protocol; // ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:serverpod/serverpod.dart' as _i1;
import 'package:serverpod/protocol.dart' as _i2;
import 'package:serverpod_auth_server/serverpod_auth_server.dart' as _i3;
import 'package:serverpod_test_module_server/serverpod_test_module_server.dart'
    as _i4;
import 'exception_with_data.dart' as _i5;
import 'long_identifiers/deep_includes/city_with_long_table_name.dart' as _i6;
import 'long_identifiers/deep_includes/organization_with_long_table_name.dart'
    as _i7;
import 'long_identifiers/deep_includes/person_with_long_table_name.dart' as _i8;
import 'long_identifiers/max_field_name.dart' as _i9;
import 'long_identifiers/models_with_relations/long_implicit_id_field.dart'
    as _i10;
import 'long_identifiers/models_with_relations/long_implicit_id_field_collection.dart'
    as _i11;
import 'long_identifiers/models_with_relations/relation_to_mutiple_max_field_name.dart'
    as _i12;
import 'long_identifiers/models_with_relations/user_note.dart' as _i13;
import 'long_identifiers/models_with_relations/user_note_collection.dart'
    as _i14;
import 'long_identifiers/models_with_relations/user_note_collection_with_a_long_name.dart'
    as _i15;
import 'long_identifiers/models_with_relations/user_note_with_a_long_name.dart'
    as _i16;
import 'long_identifiers/multiple_max_field_name.dart' as _i17;
import 'models_with_list_relations/city.dart' as _i18;
import 'models_with_list_relations/organization.dart' as _i19;
import 'models_with_list_relations/person.dart' as _i20;
import 'models_with_relations/many_to_many/course.dart' as _i21;
import 'models_with_relations/many_to_many/enrollment.dart' as _i22;
import 'models_with_relations/many_to_many/student.dart' as _i23;
import 'models_with_relations/module/object_user.dart' as _i24;
import 'models_with_relations/module/parent_user.dart' as _i25;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i26;
import 'models_with_relations/nested_one_to_many/player.dart' as _i27;
import 'models_with_relations/nested_one_to_many/team.dart' as _i28;
import 'models_with_relations/one_to_many/comment.dart' as _i29;
import 'models_with_relations/one_to_many/customer.dart' as _i30;
import 'models_with_relations/one_to_many/order.dart' as _i31;
import 'models_with_relations/one_to_one/address.dart' as _i32;
import 'models_with_relations/one_to_one/citizen.dart' as _i33;
import 'models_with_relations/one_to_one/company.dart' as _i34;
import 'models_with_relations/one_to_one/town.dart' as _i35;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i36;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i37;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i38;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i39;
import 'module_datatype.dart' as _i40;
import 'nullability.dart' as _i41;
import 'object_field_scopes.dart' as _i42;
import 'object_with_bytedata.dart' as _i43;
import 'object_with_duration.dart' as _i44;
import 'object_with_enum.dart' as _i45;
import 'object_with_index.dart' as _i46;
import 'object_with_maps.dart' as _i47;
import 'object_with_object.dart' as _i48;
import 'object_with_parent.dart' as _i49;
import 'object_with_self_parent.dart' as _i50;
import 'object_with_uuid.dart' as _i51;
import 'related_unique_data.dart' as _i52;
import 'scopes/scope_none_fields.dart' as _i53;
import 'scopes/scope_server_only_field.dart' as _i54;
import 'scopes/serverOnly/default_server_only_class.dart' as _i55;
import 'scopes/serverOnly/default_server_only_enum.dart' as _i56;
import 'scopes/serverOnly/not_server_only_class.dart' as _i57;
import 'scopes/serverOnly/not_server_only_enum.dart' as _i58;
import 'scopes/serverOnly/server_only_class.dart' as _i59;
import 'scopes/serverOnly/server_only_enum.dart' as _i60;
import 'scopes/server_only_class_field.dart' as _i61;
import 'simple_data.dart' as _i62;
import 'simple_data_list.dart' as _i63;
import 'simple_data_map.dart' as _i64;
import 'simple_data_object.dart' as _i65;
import 'simple_date_time.dart' as _i66;
import 'test_enum.dart' as _i67;
import 'test_enum_stringified.dart' as _i68;
import 'types.dart' as _i69;
import 'types_list.dart' as _i70;
import 'types_map.dart' as _i71;
import 'unique_data.dart' as _i72;
import 'protocol.dart' as _i73;
import 'dart:typed_data' as _i74;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i75;
import 'package:serverpod_test_server/src/generated/unique_data.dart' as _i76;
import 'package:serverpod_test_server/src/generated/types.dart' as _i77;
import 'package:serverpod_test_server/src/generated/models_with_list_relations/person.dart'
    as _i78;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/citizen.dart'
    as _i79;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/address.dart'
    as _i80;
import 'package:serverpod_test_server/src/generated/models_with_relations/self_relation/one_to_one/post.dart'
    as _i81;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/company.dart'
    as _i82;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i83;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/customer.dart'
    as _i84;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/comment.dart'
    as _i85;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/order.dart'
    as _i86;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i87;
import 'package:serverpod_test_server/src/protocol_custom_classes.dart' as _i88;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i89;
export 'exception_with_data.dart';
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
export 'object_field_scopes.dart';
export 'object_with_bytedata.dart';
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
    if (t == _i5.ExceptionWithData) {
      return _i5.ExceptionWithData.fromJson(data) as T;
    }
    if (t == _i6.CityWithLongTableName) {
      return _i6.CityWithLongTableName.fromJson(data) as T;
    }
    if (t == _i7.OrganizationWithLongTableName) {
      return _i7.OrganizationWithLongTableName.fromJson(data) as T;
    }
    if (t == _i8.PersonWithLongTableName) {
      return _i8.PersonWithLongTableName.fromJson(data) as T;
    }
    if (t == _i9.MaxFieldName) {
      return _i9.MaxFieldName.fromJson(data) as T;
    }
    if (t == _i10.LongImplicitIdField) {
      return _i10.LongImplicitIdField.fromJson(data) as T;
    }
    if (t == _i11.LongImplicitIdFieldCollection) {
      return _i11.LongImplicitIdFieldCollection.fromJson(data) as T;
    }
    if (t == _i12.RelationToMultipleMaxFieldName) {
      return _i12.RelationToMultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i13.UserNote) {
      return _i13.UserNote.fromJson(data) as T;
    }
    if (t == _i14.UserNoteCollection) {
      return _i14.UserNoteCollection.fromJson(data) as T;
    }
    if (t == _i15.UserNoteCollectionWithALongName) {
      return _i15.UserNoteCollectionWithALongName.fromJson(data) as T;
    }
    if (t == _i16.UserNoteWithALongName) {
      return _i16.UserNoteWithALongName.fromJson(data) as T;
    }
    if (t == _i17.MultipleMaxFieldName) {
      return _i17.MultipleMaxFieldName.fromJson(data) as T;
    }
    if (t == _i18.City) {
      return _i18.City.fromJson(data) as T;
    }
    if (t == _i19.Organization) {
      return _i19.Organization.fromJson(data) as T;
    }
    if (t == _i20.Person) {
      return _i20.Person.fromJson(data) as T;
    }
    if (t == _i21.Course) {
      return _i21.Course.fromJson(data) as T;
    }
    if (t == _i22.Enrollment) {
      return _i22.Enrollment.fromJson(data) as T;
    }
    if (t == _i23.Student) {
      return _i23.Student.fromJson(data) as T;
    }
    if (t == _i24.ObjectUser) {
      return _i24.ObjectUser.fromJson(data) as T;
    }
    if (t == _i25.ParentUser) {
      return _i25.ParentUser.fromJson(data) as T;
    }
    if (t == _i26.Arena) {
      return _i26.Arena.fromJson(data) as T;
    }
    if (t == _i27.Player) {
      return _i27.Player.fromJson(data) as T;
    }
    if (t == _i28.Team) {
      return _i28.Team.fromJson(data) as T;
    }
    if (t == _i29.Comment) {
      return _i29.Comment.fromJson(data) as T;
    }
    if (t == _i30.Customer) {
      return _i30.Customer.fromJson(data) as T;
    }
    if (t == _i31.Order) {
      return _i31.Order.fromJson(data) as T;
    }
    if (t == _i32.Address) {
      return _i32.Address.fromJson(data) as T;
    }
    if (t == _i33.Citizen) {
      return _i33.Citizen.fromJson(data) as T;
    }
    if (t == _i34.Company) {
      return _i34.Company.fromJson(data) as T;
    }
    if (t == _i35.Town) {
      return _i35.Town.fromJson(data) as T;
    }
    if (t == _i36.Blocking) {
      return _i36.Blocking.fromJson(data) as T;
    }
    if (t == _i37.Member) {
      return _i37.Member.fromJson(data) as T;
    }
    if (t == _i38.Cat) {
      return _i38.Cat.fromJson(data) as T;
    }
    if (t == _i39.Post) {
      return _i39.Post.fromJson(data) as T;
    }
    if (t == _i40.ModuleDatatype) {
      return _i40.ModuleDatatype.fromJson(data) as T;
    }
    if (t == _i41.Nullability) {
      return _i41.Nullability.fromJson(data) as T;
    }
    if (t == _i42.ObjectFieldScopes) {
      return _i42.ObjectFieldScopes.fromJson(data) as T;
    }
    if (t == _i43.ObjectWithByteData) {
      return _i43.ObjectWithByteData.fromJson(data) as T;
    }
    if (t == _i44.ObjectWithDuration) {
      return _i44.ObjectWithDuration.fromJson(data) as T;
    }
    if (t == _i45.ObjectWithEnum) {
      return _i45.ObjectWithEnum.fromJson(data) as T;
    }
    if (t == _i46.ObjectWithIndex) {
      return _i46.ObjectWithIndex.fromJson(data) as T;
    }
    if (t == _i47.ObjectWithMaps) {
      return _i47.ObjectWithMaps.fromJson(data) as T;
    }
    if (t == _i48.ObjectWithObject) {
      return _i48.ObjectWithObject.fromJson(data) as T;
    }
    if (t == _i49.ObjectWithParent) {
      return _i49.ObjectWithParent.fromJson(data) as T;
    }
    if (t == _i50.ObjectWithSelfParent) {
      return _i50.ObjectWithSelfParent.fromJson(data) as T;
    }
    if (t == _i51.ObjectWithUuid) {
      return _i51.ObjectWithUuid.fromJson(data) as T;
    }
    if (t == _i52.RelatedUniqueData) {
      return _i52.RelatedUniqueData.fromJson(data) as T;
    }
    if (t == _i53.ScopeNoneFields) {
      return _i53.ScopeNoneFields.fromJson(data) as T;
    }
    if (t == _i54.ScopeServerOnlyField) {
      return _i54.ScopeServerOnlyField.fromJson(data) as T;
    }
    if (t == _i55.DefaultServerOnlyClass) {
      return _i55.DefaultServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i56.DefaultServerOnlyEnum) {
      return _i56.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i57.NotServerOnlyClass) {
      return _i57.NotServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i58.NotServerOnlyEnum) {
      return _i58.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i59.ServerOnlyClass) {
      return _i59.ServerOnlyClass.fromJson(data) as T;
    }
    if (t == _i60.ServerOnlyEnum) {
      return _i60.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i61.ServerOnlyClassField) {
      return _i61.ServerOnlyClassField.fromJson(data) as T;
    }
    if (t == _i62.SimpleData) {
      return _i62.SimpleData.fromJson(data) as T;
    }
    if (t == _i63.SimpleDataList) {
      return _i63.SimpleDataList.fromJson(data) as T;
    }
    if (t == _i64.SimpleDataMap) {
      return _i64.SimpleDataMap.fromJson(data) as T;
    }
    if (t == _i65.SimpleDataObject) {
      return _i65.SimpleDataObject.fromJson(data) as T;
    }
    if (t == _i66.SimpleDateTime) {
      return _i66.SimpleDateTime.fromJson(data) as T;
    }
    if (t == _i67.TestEnum) {
      return _i67.TestEnum.fromJson(data) as T;
    }
    if (t == _i68.TestEnumStringified) {
      return _i68.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i69.Types) {
      return _i69.Types.fromJson(data) as T;
    }
    if (t == _i70.TypesList) {
      return _i70.TypesList.fromJson(data) as T;
    }
    if (t == _i71.TypesMap) {
      return _i71.TypesMap.fromJson(data) as T;
    }
    if (t == _i72.UniqueData) {
      return _i72.UniqueData.fromJson(data) as T;
    }
    if (t == _i1.getType<_i5.ExceptionWithData?>()) {
      return (data != null ? _i5.ExceptionWithData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i6.CityWithLongTableName?>()) {
      return (data != null ? _i6.CityWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i7.OrganizationWithLongTableName?>()) {
      return (data != null
          ? _i7.OrganizationWithLongTableName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i8.PersonWithLongTableName?>()) {
      return (data != null ? _i8.PersonWithLongTableName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i9.MaxFieldName?>()) {
      return (data != null ? _i9.MaxFieldName.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.LongImplicitIdField?>()) {
      return (data != null ? _i10.LongImplicitIdField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i11.LongImplicitIdFieldCollection?>()) {
      return (data != null
          ? _i11.LongImplicitIdFieldCollection.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i12.RelationToMultipleMaxFieldName?>()) {
      return (data != null
          ? _i12.RelationToMultipleMaxFieldName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i13.UserNote?>()) {
      return (data != null ? _i13.UserNote.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i14.UserNoteCollection?>()) {
      return (data != null ? _i14.UserNoteCollection.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i15.UserNoteCollectionWithALongName?>()) {
      return (data != null
          ? _i15.UserNoteCollectionWithALongName.fromJson(data)
          : null) as T;
    }
    if (t == _i1.getType<_i16.UserNoteWithALongName?>()) {
      return (data != null ? _i16.UserNoteWithALongName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i17.MultipleMaxFieldName?>()) {
      return (data != null ? _i17.MultipleMaxFieldName.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i18.City?>()) {
      return (data != null ? _i18.City.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i19.Organization?>()) {
      return (data != null ? _i19.Organization.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i20.Person?>()) {
      return (data != null ? _i20.Person.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i21.Course?>()) {
      return (data != null ? _i21.Course.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i22.Enrollment?>()) {
      return (data != null ? _i22.Enrollment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i23.Student?>()) {
      return (data != null ? _i23.Student.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i24.ObjectUser?>()) {
      return (data != null ? _i24.ObjectUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i25.ParentUser?>()) {
      return (data != null ? _i25.ParentUser.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i26.Arena?>()) {
      return (data != null ? _i26.Arena.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i27.Player?>()) {
      return (data != null ? _i27.Player.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i28.Team?>()) {
      return (data != null ? _i28.Team.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i29.Comment?>()) {
      return (data != null ? _i29.Comment.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i30.Customer?>()) {
      return (data != null ? _i30.Customer.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i31.Order?>()) {
      return (data != null ? _i31.Order.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i32.Address?>()) {
      return (data != null ? _i32.Address.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i33.Citizen?>()) {
      return (data != null ? _i33.Citizen.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i34.Company?>()) {
      return (data != null ? _i34.Company.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i35.Town?>()) {
      return (data != null ? _i35.Town.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i36.Blocking?>()) {
      return (data != null ? _i36.Blocking.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i37.Member?>()) {
      return (data != null ? _i37.Member.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i38.Cat?>()) {
      return (data != null ? _i38.Cat.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i39.Post?>()) {
      return (data != null ? _i39.Post.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i40.ModuleDatatype?>()) {
      return (data != null ? _i40.ModuleDatatype.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i41.Nullability?>()) {
      return (data != null ? _i41.Nullability.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.ObjectFieldScopes?>()) {
      return (data != null ? _i42.ObjectFieldScopes.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i43.ObjectWithByteData?>()) {
      return (data != null ? _i43.ObjectWithByteData.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i44.ObjectWithDuration?>()) {
      return (data != null ? _i44.ObjectWithDuration.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i45.ObjectWithEnum?>()) {
      return (data != null ? _i45.ObjectWithEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i46.ObjectWithIndex?>()) {
      return (data != null ? _i46.ObjectWithIndex.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i47.ObjectWithMaps?>()) {
      return (data != null ? _i47.ObjectWithMaps.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i48.ObjectWithObject?>()) {
      return (data != null ? _i48.ObjectWithObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i49.ObjectWithParent?>()) {
      return (data != null ? _i49.ObjectWithParent.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i50.ObjectWithSelfParent?>()) {
      return (data != null ? _i50.ObjectWithSelfParent.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i51.ObjectWithUuid?>()) {
      return (data != null ? _i51.ObjectWithUuid.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i52.RelatedUniqueData?>()) {
      return (data != null ? _i52.RelatedUniqueData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i53.ScopeNoneFields?>()) {
      return (data != null ? _i53.ScopeNoneFields.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i54.ScopeServerOnlyField?>()) {
      return (data != null ? _i54.ScopeServerOnlyField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i55.DefaultServerOnlyClass?>()) {
      return (data != null ? _i55.DefaultServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i56.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i56.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i57.NotServerOnlyClass?>()) {
      return (data != null ? _i57.NotServerOnlyClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i58.NotServerOnlyEnum?>()) {
      return (data != null ? _i58.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i59.ServerOnlyClass?>()) {
      return (data != null ? _i59.ServerOnlyClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i60.ServerOnlyEnum?>()) {
      return (data != null ? _i60.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i61.ServerOnlyClassField?>()) {
      return (data != null ? _i61.ServerOnlyClassField.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i62.SimpleData?>()) {
      return (data != null ? _i62.SimpleData.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i63.SimpleDataList?>()) {
      return (data != null ? _i63.SimpleDataList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i64.SimpleDataMap?>()) {
      return (data != null ? _i64.SimpleDataMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i65.SimpleDataObject?>()) {
      return (data != null ? _i65.SimpleDataObject.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i66.SimpleDateTime?>()) {
      return (data != null ? _i66.SimpleDateTime.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i67.TestEnum?>()) {
      return (data != null ? _i67.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i68.TestEnumStringified?>()) {
      return (data != null ? _i68.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i69.Types?>()) {
      return (data != null ? _i69.Types.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i70.TypesList?>()) {
      return (data != null ? _i70.TypesList.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i71.TypesMap?>()) {
      return (data != null ? _i71.TypesMap.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i72.UniqueData?>()) {
      return (data != null ? _i72.UniqueData.fromJson(data) : null) as T;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i73.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.OrganizationWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.OrganizationWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.PersonWithLongTableName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.PersonWithLongTableName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.LongImplicitIdField>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.LongImplicitIdField>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.MultipleMaxFieldName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.MultipleMaxFieldName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.UserNote>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.UserNote>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.UserNoteWithALongName>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.UserNoteWithALongName>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Person>(e)).toList()
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
    if (t == _i1.getType<List<_i73.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Cat>(e)).toList()
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
    if (t == List<_i73.SimpleData>) {
      return (data as List).map((e) => deserialize<_i73.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i73.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i73.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i73.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i73.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.SimpleData?>(e)).toList()
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
    if (t == List<_i74.ByteData>) {
      return (data as List).map((e) => deserialize<_i74.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i74.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i74.ByteData?>) {
      return (data as List).map((e) => deserialize<_i74.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i74.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.ByteData?>(e)).toList()
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
    if (t == List<_i73.TestEnum>) {
      return (data as List).map((e) => deserialize<_i73.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i73.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i73.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i73.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i73.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == Map<String, _i73.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i73.SimpleData>(v)))
          as dynamic;
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
    if (t == Map<String, _i74.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.ByteData>(v)))
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
    if (t == Map<String, _i73.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i73.SimpleData?>(v))) as dynamic;
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
    if (t == Map<String, _i74.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.ByteData?>(v)))
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
    if (t == _i1.getType<List<_i73.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.ServerOnlyClass>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i73.ServerOnlyClass>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i73.ServerOnlyClass>(v)))
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
    if (t == _i1.getType<List<_i74.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i74.ByteData>(e)).toList()
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
    if (t == _i1.getType<List<_i73.TestEnum>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.TestEnum>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.TestEnumStringified>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i73.TestEnumStringified>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i73.Types>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i73.Types>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<Map<String, _i73.Types>>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<Map<String, _i73.Types>>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == Map<String, _i73.Types>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i73.Types>(v)))
          as dynamic;
    }
    if (t == _i1.getType<List<List<_i73.Types>>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<List<_i73.Types>>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i73.Types>) {
      return (data as List).map((e) => deserialize<_i73.Types>(e)).toList()
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
    if (t == _i1.getType<Map<_i74.ByteData, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i74.ByteData>(e['k']), deserialize<String>(e['v']))))
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
    if (t == _i1.getType<Map<_i73.TestEnum, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i73.TestEnum>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i73.TestEnumStringified, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i73.TestEnumStringified>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<_i73.Types, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i73.Types>(e['k']), deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<Map<_i73.Types, String>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<Map<_i73.Types, String>>(e['k']),
              deserialize<String>(e['v']))))
          : null) as dynamic;
    }
    if (t == Map<_i73.Types, String>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i73.Types>(e['k']), deserialize<String>(e['v']))))
          as dynamic;
    }
    if (t == _i1.getType<Map<List<_i73.Types>, String>?>()) {
      return (data != null
          ? Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<List<_i73.Types>>(e['k']),
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
    if (t == _i1.getType<Map<String, _i74.ByteData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.ByteData>(v)))
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
    if (t == _i1.getType<Map<String, _i73.TestEnum>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i73.TestEnum>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i73.TestEnumStringified>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i73.TestEnumStringified>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i73.Types>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i73.Types>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, Map<String, _i73.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<Map<String, _i73.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, List<_i73.Types>>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<List<_i73.Types>>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<List<String>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<String>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i75.SimpleData>) {
      return (data as List).map((e) => deserialize<_i75.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<_i76.UniqueData>) {
      return (data as List).map((e) => deserialize<_i76.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i77.Types>) {
      return (data as List).map((e) => deserialize<_i77.Types>(e)).toList()
          as dynamic;
    }
    if (t == List<_i78.Person>) {
      return (data as List).map((e) => deserialize<_i78.Person>(e)).toList()
          as dynamic;
    }
    if (t == List<_i79.Citizen>) {
      return (data as List).map((e) => deserialize<_i79.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i80.Address>) {
      return (data as List).map((e) => deserialize<_i80.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i81.Post>) {
      return (data as List).map((e) => deserialize<_i81.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i82.Company>) {
      return (data as List).map((e) => deserialize<_i82.Company>(e)).toList()
          as dynamic;
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
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
    if (t == List<_i74.ByteData>) {
      return (data as List).map((e) => deserialize<_i74.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i74.ByteData?>) {
      return (data as List).map((e) => deserialize<_i74.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i75.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i75.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i75.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i75.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i75.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i75.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i75.SimpleData?>(e)).toList()
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
    if (t == Map<_i83.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i83.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i83.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i83.TestEnum>(v)))
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
    if (t == Map<String, _i74.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i74.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i74.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i75.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i75.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i75.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i75.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i75.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i75.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i75.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i75.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i75.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i75.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i75.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i75.SimpleData?>(v)))
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
    if (t == List<_i84.Customer>) {
      return (data as List).map((e) => deserialize<_i84.Customer>(e)).toList()
          as dynamic;
    }
    if (t == List<_i85.Comment>) {
      return (data as List).map((e) => deserialize<_i85.Comment>(e)).toList()
          as dynamic;
    }
    if (t == List<_i86.Order>) {
      return (data as List).map((e) => deserialize<_i86.Order>(e)).toList()
          as dynamic;
    }
    if (t == _i87.CustomClass) {
      return _i87.CustomClass.fromJson(data) as T;
    }
    if (t == _i87.CustomClass2) {
      return _i87.CustomClass2.fromJson(data) as T;
    }
    if (t == _i88.ProtocolCustomClass) {
      return _i88.ProtocolCustomClass.fromJson(data) as T;
    }
    if (t == _i89.ExternalCustomClass) {
      return _i89.ExternalCustomClass.fromJson(data) as T;
    }
    if (t == _i89.FreezedCustomClass) {
      return _i89.FreezedCustomClass.fromJson(data) as T;
    }
    if (t == _i1.getType<_i87.CustomClass?>()) {
      return (data != null ? _i87.CustomClass.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i87.CustomClass2?>()) {
      return (data != null ? _i87.CustomClass2.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i88.ProtocolCustomClass?>()) {
      return (data != null ? _i88.ProtocolCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i89.ExternalCustomClass?>()) {
      return (data != null ? _i89.ExternalCustomClass.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i89.FreezedCustomClass?>()) {
      return (data != null ? _i89.FreezedCustomClass.fromJson(data) : null)
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
  String? getClassNameForObject(Object data) {
    String? className;
    className = _i3.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_auth.$className';
    }
    className = _i4.Protocol().getClassNameForObject(data);
    if (className != null) {
      return 'serverpod_test_module.$className';
    }
    if (data is _i87.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i87.CustomClass2) {
      return 'CustomClass2';
    }
    if (data is _i88.ProtocolCustomClass) {
      return 'ProtocolCustomClass';
    }
    if (data is _i89.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i89.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i5.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i6.CityWithLongTableName) {
      return 'CityWithLongTableName';
    }
    if (data is _i7.OrganizationWithLongTableName) {
      return 'OrganizationWithLongTableName';
    }
    if (data is _i8.PersonWithLongTableName) {
      return 'PersonWithLongTableName';
    }
    if (data is _i9.MaxFieldName) {
      return 'MaxFieldName';
    }
    if (data is _i10.LongImplicitIdField) {
      return 'LongImplicitIdField';
    }
    if (data is _i11.LongImplicitIdFieldCollection) {
      return 'LongImplicitIdFieldCollection';
    }
    if (data is _i12.RelationToMultipleMaxFieldName) {
      return 'RelationToMultipleMaxFieldName';
    }
    if (data is _i13.UserNote) {
      return 'UserNote';
    }
    if (data is _i14.UserNoteCollection) {
      return 'UserNoteCollection';
    }
    if (data is _i15.UserNoteCollectionWithALongName) {
      return 'UserNoteCollectionWithALongName';
    }
    if (data is _i16.UserNoteWithALongName) {
      return 'UserNoteWithALongName';
    }
    if (data is _i17.MultipleMaxFieldName) {
      return 'MultipleMaxFieldName';
    }
    if (data is _i18.City) {
      return 'City';
    }
    if (data is _i19.Organization) {
      return 'Organization';
    }
    if (data is _i20.Person) {
      return 'Person';
    }
    if (data is _i21.Course) {
      return 'Course';
    }
    if (data is _i22.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i23.Student) {
      return 'Student';
    }
    if (data is _i24.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i25.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i26.Arena) {
      return 'Arena';
    }
    if (data is _i27.Player) {
      return 'Player';
    }
    if (data is _i28.Team) {
      return 'Team';
    }
    if (data is _i29.Comment) {
      return 'Comment';
    }
    if (data is _i30.Customer) {
      return 'Customer';
    }
    if (data is _i31.Order) {
      return 'Order';
    }
    if (data is _i32.Address) {
      return 'Address';
    }
    if (data is _i33.Citizen) {
      return 'Citizen';
    }
    if (data is _i34.Company) {
      return 'Company';
    }
    if (data is _i35.Town) {
      return 'Town';
    }
    if (data is _i36.Blocking) {
      return 'Blocking';
    }
    if (data is _i37.Member) {
      return 'Member';
    }
    if (data is _i38.Cat) {
      return 'Cat';
    }
    if (data is _i39.Post) {
      return 'Post';
    }
    if (data is _i40.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i41.Nullability) {
      return 'Nullability';
    }
    if (data is _i42.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i43.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i44.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i45.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i46.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i47.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i48.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i49.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i50.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i51.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i52.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i53.ScopeNoneFields) {
      return 'ScopeNoneFields';
    }
    if (data is _i54.ScopeServerOnlyField) {
      return 'ScopeServerOnlyField';
    }
    if (data is _i55.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i56.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i57.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i58.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i59.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i60.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i61.ServerOnlyClassField) {
      return 'ServerOnlyClassField';
    }
    if (data is _i62.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i63.SimpleDataList) {
      return 'SimpleDataList';
    }
    if (data is _i64.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i65.SimpleDataObject) {
      return 'SimpleDataObject';
    }
    if (data is _i66.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i67.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i68.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i69.Types) {
      return 'Types';
    }
    if (data is _i70.TypesList) {
      return 'TypesList';
    }
    if (data is _i71.TypesMap) {
      return 'TypesMap';
    }
    if (data is _i72.UniqueData) {
      return 'UniqueData';
    }
    return super.getClassNameForObject(data);
  }

  @override
  dynamic deserializeByClassName(Map<String, dynamic> data) {
    if (data['className'].startsWith('serverpod_auth.')) {
      data['className'] = data['className'].substring(15);
      return _i3.Protocol().deserializeByClassName(data);
    }
    if (data['className'].startsWith('serverpod_test_module.')) {
      data['className'] = data['className'].substring(22);
      return _i4.Protocol().deserializeByClassName(data);
    }
    if (data['className'] == 'CustomClass') {
      return deserialize<_i87.CustomClass>(data['data']);
    }
    if (data['className'] == 'CustomClass2') {
      return deserialize<_i87.CustomClass2>(data['data']);
    }
    if (data['className'] == 'ProtocolCustomClass') {
      return deserialize<_i88.ProtocolCustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i89.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i89.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i5.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'CityWithLongTableName') {
      return deserialize<_i6.CityWithLongTableName>(data['data']);
    }
    if (data['className'] == 'OrganizationWithLongTableName') {
      return deserialize<_i7.OrganizationWithLongTableName>(data['data']);
    }
    if (data['className'] == 'PersonWithLongTableName') {
      return deserialize<_i8.PersonWithLongTableName>(data['data']);
    }
    if (data['className'] == 'MaxFieldName') {
      return deserialize<_i9.MaxFieldName>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdField') {
      return deserialize<_i10.LongImplicitIdField>(data['data']);
    }
    if (data['className'] == 'LongImplicitIdFieldCollection') {
      return deserialize<_i11.LongImplicitIdFieldCollection>(data['data']);
    }
    if (data['className'] == 'RelationToMultipleMaxFieldName') {
      return deserialize<_i12.RelationToMultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'UserNote') {
      return deserialize<_i13.UserNote>(data['data']);
    }
    if (data['className'] == 'UserNoteCollection') {
      return deserialize<_i14.UserNoteCollection>(data['data']);
    }
    if (data['className'] == 'UserNoteCollectionWithALongName') {
      return deserialize<_i15.UserNoteCollectionWithALongName>(data['data']);
    }
    if (data['className'] == 'UserNoteWithALongName') {
      return deserialize<_i16.UserNoteWithALongName>(data['data']);
    }
    if (data['className'] == 'MultipleMaxFieldName') {
      return deserialize<_i17.MultipleMaxFieldName>(data['data']);
    }
    if (data['className'] == 'City') {
      return deserialize<_i18.City>(data['data']);
    }
    if (data['className'] == 'Organization') {
      return deserialize<_i19.Organization>(data['data']);
    }
    if (data['className'] == 'Person') {
      return deserialize<_i20.Person>(data['data']);
    }
    if (data['className'] == 'Course') {
      return deserialize<_i21.Course>(data['data']);
    }
    if (data['className'] == 'Enrollment') {
      return deserialize<_i22.Enrollment>(data['data']);
    }
    if (data['className'] == 'Student') {
      return deserialize<_i23.Student>(data['data']);
    }
    if (data['className'] == 'ObjectUser') {
      return deserialize<_i24.ObjectUser>(data['data']);
    }
    if (data['className'] == 'ParentUser') {
      return deserialize<_i25.ParentUser>(data['data']);
    }
    if (data['className'] == 'Arena') {
      return deserialize<_i26.Arena>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i27.Player>(data['data']);
    }
    if (data['className'] == 'Team') {
      return deserialize<_i28.Team>(data['data']);
    }
    if (data['className'] == 'Comment') {
      return deserialize<_i29.Comment>(data['data']);
    }
    if (data['className'] == 'Customer') {
      return deserialize<_i30.Customer>(data['data']);
    }
    if (data['className'] == 'Order') {
      return deserialize<_i31.Order>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i32.Address>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i33.Citizen>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i34.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i35.Town>(data['data']);
    }
    if (data['className'] == 'Blocking') {
      return deserialize<_i36.Blocking>(data['data']);
    }
    if (data['className'] == 'Member') {
      return deserialize<_i37.Member>(data['data']);
    }
    if (data['className'] == 'Cat') {
      return deserialize<_i38.Cat>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i39.Post>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i40.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i41.Nullability>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i42.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i43.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i44.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i45.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i46.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i47.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i48.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i49.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i50.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i51.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i52.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'ScopeNoneFields') {
      return deserialize<_i53.ScopeNoneFields>(data['data']);
    }
    if (data['className'] == 'ScopeServerOnlyField') {
      return deserialize<_i54.ScopeServerOnlyField>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i55.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i56.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i57.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i58.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClass') {
      return deserialize<_i59.ServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'ServerOnlyEnum') {
      return deserialize<_i60.ServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClassField') {
      return deserialize<_i61.ServerOnlyClassField>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i62.SimpleData>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i63.SimpleDataList>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i64.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'SimpleDataObject') {
      return deserialize<_i65.SimpleDataObject>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i66.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i67.TestEnum>(data['data']);
    }
    if (data['className'] == 'TestEnumStringified') {
      return deserialize<_i68.TestEnumStringified>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i69.Types>(data['data']);
    }
    if (data['className'] == 'TypesList') {
      return deserialize<_i70.TypesList>(data['data']);
    }
    if (data['className'] == 'TypesMap') {
      return deserialize<_i71.TypesMap>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i72.UniqueData>(data['data']);
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
      case _i6.CityWithLongTableName:
        return _i6.CityWithLongTableName.t;
      case _i7.OrganizationWithLongTableName:
        return _i7.OrganizationWithLongTableName.t;
      case _i8.PersonWithLongTableName:
        return _i8.PersonWithLongTableName.t;
      case _i9.MaxFieldName:
        return _i9.MaxFieldName.t;
      case _i10.LongImplicitIdField:
        return _i10.LongImplicitIdField.t;
      case _i11.LongImplicitIdFieldCollection:
        return _i11.LongImplicitIdFieldCollection.t;
      case _i12.RelationToMultipleMaxFieldName:
        return _i12.RelationToMultipleMaxFieldName.t;
      case _i13.UserNote:
        return _i13.UserNote.t;
      case _i14.UserNoteCollection:
        return _i14.UserNoteCollection.t;
      case _i15.UserNoteCollectionWithALongName:
        return _i15.UserNoteCollectionWithALongName.t;
      case _i16.UserNoteWithALongName:
        return _i16.UserNoteWithALongName.t;
      case _i17.MultipleMaxFieldName:
        return _i17.MultipleMaxFieldName.t;
      case _i18.City:
        return _i18.City.t;
      case _i19.Organization:
        return _i19.Organization.t;
      case _i20.Person:
        return _i20.Person.t;
      case _i21.Course:
        return _i21.Course.t;
      case _i22.Enrollment:
        return _i22.Enrollment.t;
      case _i23.Student:
        return _i23.Student.t;
      case _i24.ObjectUser:
        return _i24.ObjectUser.t;
      case _i25.ParentUser:
        return _i25.ParentUser.t;
      case _i26.Arena:
        return _i26.Arena.t;
      case _i27.Player:
        return _i27.Player.t;
      case _i28.Team:
        return _i28.Team.t;
      case _i29.Comment:
        return _i29.Comment.t;
      case _i30.Customer:
        return _i30.Customer.t;
      case _i31.Order:
        return _i31.Order.t;
      case _i32.Address:
        return _i32.Address.t;
      case _i33.Citizen:
        return _i33.Citizen.t;
      case _i34.Company:
        return _i34.Company.t;
      case _i35.Town:
        return _i35.Town.t;
      case _i36.Blocking:
        return _i36.Blocking.t;
      case _i37.Member:
        return _i37.Member.t;
      case _i38.Cat:
        return _i38.Cat.t;
      case _i39.Post:
        return _i39.Post.t;
      case _i42.ObjectFieldScopes:
        return _i42.ObjectFieldScopes.t;
      case _i43.ObjectWithByteData:
        return _i43.ObjectWithByteData.t;
      case _i44.ObjectWithDuration:
        return _i44.ObjectWithDuration.t;
      case _i45.ObjectWithEnum:
        return _i45.ObjectWithEnum.t;
      case _i46.ObjectWithIndex:
        return _i46.ObjectWithIndex.t;
      case _i48.ObjectWithObject:
        return _i48.ObjectWithObject.t;
      case _i49.ObjectWithParent:
        return _i49.ObjectWithParent.t;
      case _i50.ObjectWithSelfParent:
        return _i50.ObjectWithSelfParent.t;
      case _i51.ObjectWithUuid:
        return _i51.ObjectWithUuid.t;
      case _i52.RelatedUniqueData:
        return _i52.RelatedUniqueData.t;
      case _i53.ScopeNoneFields:
        return _i53.ScopeNoneFields.t;
      case _i62.SimpleData:
        return _i62.SimpleData.t;
      case _i66.SimpleDateTime:
        return _i66.SimpleDateTime.t;
      case _i69.Types:
        return _i69.Types.t;
      case _i72.UniqueData:
        return _i72.UniqueData.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test';
}
