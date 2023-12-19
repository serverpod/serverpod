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
import 'package:serverpod_auth_server/module.dart' as _i3;
import 'package:serverpod_test_module_server/module.dart' as _i4;
import 'simple_data_map.dart' as _i5;
import 'unique_data.dart' as _i6;
import 'object_field_scopes.dart' as _i7;
import 'object_with_uuid.dart' as _i8;
import 'test_enum.dart' as _i9;
import 'object_with_self_parent.dart' as _i10;
import 'object_with_enum.dart' as _i11;
import 'models_with_relations/nested_one_to_many/team.dart' as _i12;
import 'models_with_relations/nested_one_to_many/player.dart' as _i13;
import 'models_with_relations/nested_one_to_many/arena.dart' as _i14;
import 'models_with_relations/module/object_user.dart' as _i15;
import 'models_with_relations/module/parent_user.dart' as _i16;
import 'models_with_relations/self_relation/one_to_one/post.dart' as _i17;
import 'models_with_relations/self_relation/one_to_many/cat.dart' as _i18;
import 'models_with_relations/self_relation/many_to_many/blocking.dart' as _i19;
import 'models_with_relations/self_relation/many_to_many/member.dart' as _i20;
import 'models_with_relations/one_to_one/address.dart' as _i21;
import 'models_with_relations/one_to_one/company.dart' as _i22;
import 'models_with_relations/one_to_one/town.dart' as _i23;
import 'models_with_relations/one_to_one/citizen.dart' as _i24;
import 'models_with_relations/one_to_many/customer.dart' as _i25;
import 'models_with_relations/one_to_many/comment.dart' as _i26;
import 'models_with_relations/one_to_many/order.dart' as _i27;
import 'models_with_relations/many_to_many/student.dart' as _i28;
import 'models_with_relations/many_to_many/course.dart' as _i29;
import 'models_with_relations/many_to_many/enrollment.dart' as _i30;
import 'object_with_maps.dart' as _i31;
import 'related_unique_data.dart' as _i32;
import 'exception_with_data.dart' as _i33;
import 'module_datatype.dart' as _i34;
import 'object_with_index.dart' as _i35;
import 'object_with_bytedata.dart' as _i36;
import 'test_enum_stringified.dart' as _i37;
import 'nullability.dart' as _i38;
import 'serverOnly/server_only_class.dart' as _i39;
import 'serverOnly/not_server_only_class.dart' as _i40;
import 'serverOnly/server_only_enum.dart' as _i41;
import 'serverOnly/default_server_only_enum.dart' as _i42;
import 'serverOnly/default_server_only_class.dart' as _i43;
import 'serverOnly/not_server_only_enum.dart' as _i44;
import 'object_with_object.dart' as _i45;
import 'simple_date_time.dart' as _i46;
import 'models_with_list_relations/organization.dart' as _i47;
import 'models_with_list_relations/city.dart' as _i48;
import 'models_with_list_relations/person.dart' as _i49;
import 'object_with_duration.dart' as _i50;
import 'types.dart' as _i51;
import 'simple_data.dart' as _i52;
import 'object_with_parent.dart' as _i53;
import 'simple_data_list.dart' as _i54;
import 'protocol.dart' as _i55;
import 'dart:typed_data' as _i56;
import 'package:serverpod_test_server/src/generated/types.dart' as _i57;
import 'package:serverpod_test_server/src/generated/test_enum.dart' as _i58;
import 'package:uuid/uuid.dart' as _i59;
import 'package:serverpod_test_server/src/generated/simple_data.dart' as _i60;
import 'package:serverpod_test_server/src/generated/unique_data.dart' as _i61;
import 'package:serverpod_test_server/src/generated/models_with_list_relations/person.dart'
    as _i62;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/citizen.dart'
    as _i63;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/address.dart'
    as _i64;
import 'package:serverpod_test_server/src/generated/models_with_relations/self_relation/one_to_one/post.dart'
    as _i65;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_one/company.dart'
    as _i66;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/customer.dart'
    as _i67;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/comment.dart'
    as _i68;
import 'package:serverpod_test_server/src/generated/models_with_relations/one_to_many/order.dart'
    as _i69;
import 'package:serverpod_test_server/src/custom_classes.dart' as _i70;
import 'package:serverpod_test_shared/serverpod_test_shared.dart' as _i71;
export 'simple_data_map.dart';
export 'unique_data.dart';
export 'object_field_scopes.dart';
export 'object_with_uuid.dart';
export 'test_enum.dart';
export 'object_with_self_parent.dart';
export 'object_with_enum.dart';
export 'models_with_relations/nested_one_to_many/team.dart';
export 'models_with_relations/nested_one_to_many/player.dart';
export 'models_with_relations/nested_one_to_many/arena.dart';
export 'models_with_relations/module/object_user.dart';
export 'models_with_relations/module/parent_user.dart';
export 'models_with_relations/self_relation/one_to_one/post.dart';
export 'models_with_relations/self_relation/one_to_many/cat.dart';
export 'models_with_relations/self_relation/many_to_many/blocking.dart';
export 'models_with_relations/self_relation/many_to_many/member.dart';
export 'models_with_relations/one_to_one/address.dart';
export 'models_with_relations/one_to_one/company.dart';
export 'models_with_relations/one_to_one/town.dart';
export 'models_with_relations/one_to_one/citizen.dart';
export 'models_with_relations/one_to_many/customer.dart';
export 'models_with_relations/one_to_many/comment.dart';
export 'models_with_relations/one_to_many/order.dart';
export 'models_with_relations/many_to_many/student.dart';
export 'models_with_relations/many_to_many/course.dart';
export 'models_with_relations/many_to_many/enrollment.dart';
export 'object_with_maps.dart';
export 'related_unique_data.dart';
export 'exception_with_data.dart';
export 'module_datatype.dart';
export 'object_with_index.dart';
export 'object_with_bytedata.dart';
export 'test_enum_stringified.dart';
export 'nullability.dart';
export 'serverOnly/server_only_class.dart';
export 'serverOnly/not_server_only_class.dart';
export 'serverOnly/server_only_enum.dart';
export 'serverOnly/default_server_only_enum.dart';
export 'serverOnly/default_server_only_class.dart';
export 'serverOnly/not_server_only_enum.dart';
export 'object_with_object.dart';
export 'simple_date_time.dart';
export 'models_with_list_relations/organization.dart';
export 'models_with_list_relations/city.dart';
export 'models_with_list_relations/person.dart';
export 'object_with_duration.dart';
export 'types.dart';
export 'simple_data.dart';
export 'object_with_parent.dart';
export 'simple_data_list.dart';

class Protocol extends _i1.SerializationManagerServer {
  Protocol._();

  factory Protocol() => _instance;

  static final Map<Type, _i1.constructor> customConstructors = {};

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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'blocking_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'blockedId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'blockedById',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'oldCompanyId',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
      name: 'comment',
      dartName: 'Comment',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'enrollment_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'studentId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'courseId',
          columnType: _i2.ColumnType.integer,
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
      name: 'member',
      dartName: 'Member',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
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
      name: 'object_field_scopes',
      dartName: 'ObjectFieldScopes',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_enum_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'testEnum',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'protocol:TestEnum',
        ),
        _i2.ColumnDefinition(
          name: 'nullableEnum',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_index_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'indexed',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'indexed2',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'object_with_parent_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault:
              'nextval(\'object_with_self_parent_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'other',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
      name: 'parent_user',
      dartName: 'ParentUser',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: true,
          dartType: 'int?',
        ),
        _i2.ColumnDefinition(
          name: '_cityCitizensCityId',
          columnType: _i2.ColumnType.integer,
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
      name: 'player',
      dartName: 'Player',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'related_unique_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'uniqueDataId',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.integer,
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
      name: 'simple_data',
      dartName: 'SimpleData',
      schema: 'public',
      module: 'serverpod_test',
      columns: [
        _i2.ColumnDefinition(
          name: 'id',
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'simple_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'num',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'types_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'anInt',
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
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
          columnType: _i2.ColumnType.integer,
          isNullable: false,
          dartType: 'int?',
          columnDefault: 'nextval(\'unique_data_id_seq\'::regclass)',
        ),
        _i2.ColumnDefinition(
          name: 'number',
          columnType: _i2.ColumnType.integer,
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
    if (customConstructors.containsKey(t)) {
      return customConstructors[t]!(data, this) as T;
    }
    if (t == _i5.SimpleDataMap) {
      return _i5.SimpleDataMap.fromJson(data, this) as T;
    }
    if (t == _i6.UniqueData) {
      return _i6.UniqueData.fromJson(data, this) as T;
    }
    if (t == _i7.ObjectFieldScopes) {
      return _i7.ObjectFieldScopes.fromJson(data, this) as T;
    }
    if (t == _i8.ObjectWithUuid) {
      return _i8.ObjectWithUuid.fromJson(data, this) as T;
    }
    if (t == _i9.TestEnum) {
      return _i9.TestEnum.fromJson(data) as T;
    }
    if (t == _i10.ObjectWithSelfParent) {
      return _i10.ObjectWithSelfParent.fromJson(data, this) as T;
    }
    if (t == _i11.ObjectWithEnum) {
      return _i11.ObjectWithEnum.fromJson(data, this) as T;
    }
    if (t == _i12.Team) {
      return _i12.Team.fromJson(data, this) as T;
    }
    if (t == _i13.Player) {
      return _i13.Player.fromJson(data, this) as T;
    }
    if (t == _i14.Arena) {
      return _i14.Arena.fromJson(data, this) as T;
    }
    if (t == _i15.ObjectUser) {
      return _i15.ObjectUser.fromJson(data, this) as T;
    }
    if (t == _i16.ParentUser) {
      return _i16.ParentUser.fromJson(data, this) as T;
    }
    if (t == _i17.Post) {
      return _i17.Post.fromJson(data, this) as T;
    }
    if (t == _i18.Cat) {
      return _i18.Cat.fromJson(data, this) as T;
    }
    if (t == _i19.Blocking) {
      return _i19.Blocking.fromJson(data, this) as T;
    }
    if (t == _i20.Member) {
      return _i20.Member.fromJson(data, this) as T;
    }
    if (t == _i21.Address) {
      return _i21.Address.fromJson(data, this) as T;
    }
    if (t == _i22.Company) {
      return _i22.Company.fromJson(data, this) as T;
    }
    if (t == _i23.Town) {
      return _i23.Town.fromJson(data, this) as T;
    }
    if (t == _i24.Citizen) {
      return _i24.Citizen.fromJson(data, this) as T;
    }
    if (t == _i25.Customer) {
      return _i25.Customer.fromJson(data, this) as T;
    }
    if (t == _i26.Comment) {
      return _i26.Comment.fromJson(data, this) as T;
    }
    if (t == _i27.Order) {
      return _i27.Order.fromJson(data, this) as T;
    }
    if (t == _i28.Student) {
      return _i28.Student.fromJson(data, this) as T;
    }
    if (t == _i29.Course) {
      return _i29.Course.fromJson(data, this) as T;
    }
    if (t == _i30.Enrollment) {
      return _i30.Enrollment.fromJson(data, this) as T;
    }
    if (t == _i31.ObjectWithMaps) {
      return _i31.ObjectWithMaps.fromJson(data, this) as T;
    }
    if (t == _i32.RelatedUniqueData) {
      return _i32.RelatedUniqueData.fromJson(data, this) as T;
    }
    if (t == _i33.ExceptionWithData) {
      return _i33.ExceptionWithData.fromJson(data, this) as T;
    }
    if (t == _i34.ModuleDatatype) {
      return _i34.ModuleDatatype.fromJson(data, this) as T;
    }
    if (t == _i35.ObjectWithIndex) {
      return _i35.ObjectWithIndex.fromJson(data, this) as T;
    }
    if (t == _i36.ObjectWithByteData) {
      return _i36.ObjectWithByteData.fromJson(data, this) as T;
    }
    if (t == _i37.TestEnumStringified) {
      return _i37.TestEnumStringified.fromJson(data) as T;
    }
    if (t == _i38.Nullability) {
      return _i38.Nullability.fromJson(data, this) as T;
    }
    if (t == _i39.ServerOnlyClass) {
      return _i39.ServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i40.NotServerOnlyClass) {
      return _i40.NotServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i41.ServerOnlyEnum) {
      return _i41.ServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i42.DefaultServerOnlyEnum) {
      return _i42.DefaultServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i43.DefaultServerOnlyClass) {
      return _i43.DefaultServerOnlyClass.fromJson(data, this) as T;
    }
    if (t == _i44.NotServerOnlyEnum) {
      return _i44.NotServerOnlyEnum.fromJson(data) as T;
    }
    if (t == _i45.ObjectWithObject) {
      return _i45.ObjectWithObject.fromJson(data, this) as T;
    }
    if (t == _i46.SimpleDateTime) {
      return _i46.SimpleDateTime.fromJson(data, this) as T;
    }
    if (t == _i47.Organization) {
      return _i47.Organization.fromJson(data, this) as T;
    }
    if (t == _i48.City) {
      return _i48.City.fromJson(data, this) as T;
    }
    if (t == _i49.Person) {
      return _i49.Person.fromJson(data, this) as T;
    }
    if (t == _i50.ObjectWithDuration) {
      return _i50.ObjectWithDuration.fromJson(data, this) as T;
    }
    if (t == _i51.Types) {
      return _i51.Types.fromJson(data, this) as T;
    }
    if (t == _i52.SimpleData) {
      return _i52.SimpleData.fromJson(data, this) as T;
    }
    if (t == _i53.ObjectWithParent) {
      return _i53.ObjectWithParent.fromJson(data, this) as T;
    }
    if (t == _i54.SimpleDataList) {
      return _i54.SimpleDataList.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i5.SimpleDataMap?>()) {
      return (data != null ? _i5.SimpleDataMap.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i6.UniqueData?>()) {
      return (data != null ? _i6.UniqueData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i7.ObjectFieldScopes?>()) {
      return (data != null ? _i7.ObjectFieldScopes.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i8.ObjectWithUuid?>()) {
      return (data != null ? _i8.ObjectWithUuid.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i9.TestEnum?>()) {
      return (data != null ? _i9.TestEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i10.ObjectWithSelfParent?>()) {
      return (data != null
          ? _i10.ObjectWithSelfParent.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i11.ObjectWithEnum?>()) {
      return (data != null ? _i11.ObjectWithEnum.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i12.Team?>()) {
      return (data != null ? _i12.Team.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i13.Player?>()) {
      return (data != null ? _i13.Player.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i14.Arena?>()) {
      return (data != null ? _i14.Arena.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i15.ObjectUser?>()) {
      return (data != null ? _i15.ObjectUser.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i16.ParentUser?>()) {
      return (data != null ? _i16.ParentUser.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i17.Post?>()) {
      return (data != null ? _i17.Post.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i18.Cat?>()) {
      return (data != null ? _i18.Cat.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i19.Blocking?>()) {
      return (data != null ? _i19.Blocking.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i20.Member?>()) {
      return (data != null ? _i20.Member.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i21.Address?>()) {
      return (data != null ? _i21.Address.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i22.Company?>()) {
      return (data != null ? _i22.Company.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i23.Town?>()) {
      return (data != null ? _i23.Town.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i24.Citizen?>()) {
      return (data != null ? _i24.Citizen.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i25.Customer?>()) {
      return (data != null ? _i25.Customer.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i26.Comment?>()) {
      return (data != null ? _i26.Comment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i27.Order?>()) {
      return (data != null ? _i27.Order.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i28.Student?>()) {
      return (data != null ? _i28.Student.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i29.Course?>()) {
      return (data != null ? _i29.Course.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i30.Enrollment?>()) {
      return (data != null ? _i30.Enrollment.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i31.ObjectWithMaps?>()) {
      return (data != null ? _i31.ObjectWithMaps.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i32.RelatedUniqueData?>()) {
      return (data != null ? _i32.RelatedUniqueData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i33.ExceptionWithData?>()) {
      return (data != null ? _i33.ExceptionWithData.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i34.ModuleDatatype?>()) {
      return (data != null ? _i34.ModuleDatatype.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i35.ObjectWithIndex?>()) {
      return (data != null ? _i35.ObjectWithIndex.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i36.ObjectWithByteData?>()) {
      return (data != null
          ? _i36.ObjectWithByteData.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i37.TestEnumStringified?>()) {
      return (data != null ? _i37.TestEnumStringified.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i38.Nullability?>()) {
      return (data != null ? _i38.Nullability.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i39.ServerOnlyClass?>()) {
      return (data != null ? _i39.ServerOnlyClass.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i40.NotServerOnlyClass?>()) {
      return (data != null
          ? _i40.NotServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i41.ServerOnlyEnum?>()) {
      return (data != null ? _i41.ServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i42.DefaultServerOnlyEnum?>()) {
      return (data != null ? _i42.DefaultServerOnlyEnum.fromJson(data) : null)
          as T;
    }
    if (t == _i1.getType<_i43.DefaultServerOnlyClass?>()) {
      return (data != null
          ? _i43.DefaultServerOnlyClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i44.NotServerOnlyEnum?>()) {
      return (data != null ? _i44.NotServerOnlyEnum.fromJson(data) : null) as T;
    }
    if (t == _i1.getType<_i45.ObjectWithObject?>()) {
      return (data != null ? _i45.ObjectWithObject.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i46.SimpleDateTime?>()) {
      return (data != null ? _i46.SimpleDateTime.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i47.Organization?>()) {
      return (data != null ? _i47.Organization.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i48.City?>()) {
      return (data != null ? _i48.City.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i49.Person?>()) {
      return (data != null ? _i49.Person.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i50.ObjectWithDuration?>()) {
      return (data != null
          ? _i50.ObjectWithDuration.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i51.Types?>()) {
      return (data != null ? _i51.Types.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i52.SimpleData?>()) {
      return (data != null ? _i52.SimpleData.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i53.ObjectWithParent?>()) {
      return (data != null ? _i53.ObjectWithParent.fromJson(data, this) : null)
          as T;
    }
    if (t == _i1.getType<_i54.SimpleDataList?>()) {
      return (data != null ? _i54.SimpleDataList.fromJson(data, this) : null)
          as T;
    }
    if (t == Map<String, _i55.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i55.SimpleData>(v)))
          as dynamic;
    }
    if (t == List<_i55.TestEnum>) {
      return (data as List).map((e) => deserialize<_i55.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<_i55.TestEnum?>) {
      return (data as List).map((e) => deserialize<_i55.TestEnum?>(e)).toList()
          as dynamic;
    }
    if (t == List<List<_i55.TestEnum>>) {
      return (data as List)
          .map((e) => deserialize<List<_i55.TestEnum>>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i55.Player>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Player>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Cat>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Cat>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Blocking>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Blocking>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Order>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Order>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Comment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Comment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Enrollment>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Enrollment>(e)).toList()
          : null) as dynamic;
    }
    if (t == Map<String, int>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
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
    if (t == Map<String, _i56.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i56.ByteData>(v)))
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
    if (t == Map<String, _i55.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i55.SimpleData?>(v))) as dynamic;
    }
    if (t == Map<String, int?>) {
      return (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
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
    if (t == Map<String, _i56.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i56.ByteData?>(v)))
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
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
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
    if (t == List<_i55.SimpleData>) {
      return (data as List).map((e) => deserialize<_i55.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i55.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i55.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i55.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i55.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.SimpleData?>(e)).toList()
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
    if (t == List<_i56.ByteData>) {
      return (data as List).map((e) => deserialize<_i56.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i56.ByteData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i56.ByteData>(e)).toList()
          : null) as dynamic;
    }
    if (t == List<_i56.ByteData?>) {
      return (data as List).map((e) => deserialize<_i56.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == _i1.getType<List<_i56.ByteData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i56.ByteData?>(e)).toList()
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
    if (t == _i1.getType<Map<String, int>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, int?>?>()) {
      return (data != null
          ? (data as Map).map(
              (k, v) => MapEntry(deserialize<String>(k), deserialize<int?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Person>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i55.Person>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i55.Organization>?>()) {
      return (data != null
          ? (data as List)
              .map((e) => deserialize<_i55.Organization>(e))
              .toList()
          : null) as dynamic;
    }
    if (t == List<_i57.Types>) {
      return (data as List).map((e) => deserialize<_i57.Types>(e)).toList()
          as dynamic;
    }
    if (t == List<bool>) {
      return (data as List).map((e) => deserialize<bool>(e)).toList()
          as dynamic;
    }
    if (t == List<DateTime>) {
      return (data as List).map((e) => deserialize<DateTime>(e)).toList()
          as dynamic;
    }
    if (t == List<double>) {
      return (data as List).map((e) => deserialize<double>(e)).toList()
          as dynamic;
    }
    if (t == List<Duration>) {
      return (data as List).map((e) => deserialize<Duration>(e)).toList()
          as dynamic;
    }
    if (t == List<_i58.TestEnum>) {
      return (data as List).map((e) => deserialize<_i58.TestEnum>(e)).toList()
          as dynamic;
    }
    if (t == List<int>) {
      return (data as List).map((e) => deserialize<int>(e)).toList() as dynamic;
    }
    if (t == List<String>) {
      return (data as List).map((e) => deserialize<String>(e)).toList()
          as dynamic;
    }
    if (t == List<_i59.UuidValue>) {
      return (data as List).map((e) => deserialize<_i59.UuidValue>(e)).toList()
          as dynamic;
    }
    if (t == List<_i60.SimpleData>) {
      return (data as List).map((e) => deserialize<_i60.SimpleData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i61.UniqueData>) {
      return (data as List).map((e) => deserialize<_i61.UniqueData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i62.Person>) {
      return (data as List).map((e) => deserialize<_i62.Person>(e)).toList()
          as dynamic;
    }
    if (t == List<_i63.Citizen>) {
      return (data as List).map((e) => deserialize<_i63.Citizen>(e)).toList()
          as dynamic;
    }
    if (t == List<_i64.Address>) {
      return (data as List).map((e) => deserialize<_i64.Address>(e)).toList()
          as dynamic;
    }
    if (t == List<_i65.Post>) {
      return (data as List).map((e) => deserialize<_i65.Post>(e)).toList()
          as dynamic;
    }
    if (t == List<_i66.Company>) {
      return (data as List).map((e) => deserialize<_i66.Company>(e)).toList()
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
    if (t == List<double?>) {
      return (data as List).map((e) => deserialize<double?>(e)).toList()
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
    if (t == List<DateTime?>) {
      return (data as List).map((e) => deserialize<DateTime?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i56.ByteData>) {
      return (data as List).map((e) => deserialize<_i56.ByteData>(e)).toList()
          as dynamic;
    }
    if (t == List<_i56.ByteData?>) {
      return (data as List).map((e) => deserialize<_i56.ByteData?>(e)).toList()
          as dynamic;
    }
    if (t == List<_i60.SimpleData?>) {
      return (data as List)
          .map((e) => deserialize<_i60.SimpleData?>(e))
          .toList() as dynamic;
    }
    if (t == _i1.getType<List<_i60.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i60.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i60.SimpleData>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i60.SimpleData>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i60.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i60.SimpleData?>(e)).toList()
          : null) as dynamic;
    }
    if (t == _i1.getType<List<_i60.SimpleData?>?>()) {
      return (data != null
          ? (data as List).map((e) => deserialize<_i60.SimpleData?>(e)).toList()
          : null) as dynamic;
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
    if (t == Map<_i58.TestEnum, int>) {
      return Map.fromEntries((data as List).map((e) => MapEntry(
              deserialize<_i58.TestEnum>(e['k']), deserialize<int>(e['v']))))
          as dynamic;
    }
    if (t == Map<String, _i58.TestEnum>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i58.TestEnum>(v)))
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
    if (t == Map<String, _i56.ByteData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i56.ByteData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i56.ByteData?>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i56.ByteData?>(v)))
          as dynamic;
    }
    if (t == Map<String, _i60.SimpleData>) {
      return (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i60.SimpleData>(v)))
          as dynamic;
    }
    if (t == Map<String, _i60.SimpleData?>) {
      return (data as Map).map((k, v) => MapEntry(
          deserialize<String>(k), deserialize<_i60.SimpleData?>(v))) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i60.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i60.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i60.SimpleData>?>()) {
      return (data != null
          ? (data as Map).map((k, v) =>
              MapEntry(deserialize<String>(k), deserialize<_i60.SimpleData>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i60.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i60.SimpleData?>(v)))
          : null) as dynamic;
    }
    if (t == _i1.getType<Map<String, _i60.SimpleData?>?>()) {
      return (data != null
          ? (data as Map).map((k, v) => MapEntry(
              deserialize<String>(k), deserialize<_i60.SimpleData?>(v)))
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
    if (t == List<_i67.Customer>) {
      return (data as List).map((e) => deserialize<_i67.Customer>(e)).toList()
          as dynamic;
    }
    if (t == List<_i68.Comment>) {
      return (data as List).map((e) => deserialize<_i68.Comment>(e)).toList()
          as dynamic;
    }
    if (t == List<_i69.Order>) {
      return (data as List).map((e) => deserialize<_i69.Order>(e)).toList()
          as dynamic;
    }
    if (t == _i70.CustomClass) {
      return _i70.CustomClass.fromJson(data, this) as T;
    }
    if (t == _i71.ExternalCustomClass) {
      return _i71.ExternalCustomClass.fromJson(data, this) as T;
    }
    if (t == _i71.FreezedCustomClass) {
      return _i71.FreezedCustomClass.fromJson(data, this) as T;
    }
    if (t == _i1.getType<_i70.CustomClass?>()) {
      return (data != null ? _i70.CustomClass.fromJson(data, this) : null) as T;
    }
    if (t == _i1.getType<_i71.ExternalCustomClass?>()) {
      return (data != null
          ? _i71.ExternalCustomClass.fromJson(data, this)
          : null) as T;
    }
    if (t == _i1.getType<_i71.FreezedCustomClass?>()) {
      return (data != null
          ? _i71.FreezedCustomClass.fromJson(data, this)
          : null) as T;
    }
    try {
      return _i3.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i4.Protocol().deserialize<T>(data, t);
    } catch (_) {}
    try {
      return _i2.Protocol().deserialize<T>(data, t);
    } catch (_) {}
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
    if (data is _i70.CustomClass) {
      return 'CustomClass';
    }
    if (data is _i71.ExternalCustomClass) {
      return 'ExternalCustomClass';
    }
    if (data is _i71.FreezedCustomClass) {
      return 'FreezedCustomClass';
    }
    if (data is _i5.SimpleDataMap) {
      return 'SimpleDataMap';
    }
    if (data is _i6.UniqueData) {
      return 'UniqueData';
    }
    if (data is _i7.ObjectFieldScopes) {
      return 'ObjectFieldScopes';
    }
    if (data is _i8.ObjectWithUuid) {
      return 'ObjectWithUuid';
    }
    if (data is _i9.TestEnum) {
      return 'TestEnum';
    }
    if (data is _i10.ObjectWithSelfParent) {
      return 'ObjectWithSelfParent';
    }
    if (data is _i11.ObjectWithEnum) {
      return 'ObjectWithEnum';
    }
    if (data is _i12.Team) {
      return 'Team';
    }
    if (data is _i13.Player) {
      return 'Player';
    }
    if (data is _i14.Arena) {
      return 'Arena';
    }
    if (data is _i15.ObjectUser) {
      return 'ObjectUser';
    }
    if (data is _i16.ParentUser) {
      return 'ParentUser';
    }
    if (data is _i17.Post) {
      return 'Post';
    }
    if (data is _i18.Cat) {
      return 'Cat';
    }
    if (data is _i19.Blocking) {
      return 'Blocking';
    }
    if (data is _i20.Member) {
      return 'Member';
    }
    if (data is _i21.Address) {
      return 'Address';
    }
    if (data is _i22.Company) {
      return 'Company';
    }
    if (data is _i23.Town) {
      return 'Town';
    }
    if (data is _i24.Citizen) {
      return 'Citizen';
    }
    if (data is _i25.Customer) {
      return 'Customer';
    }
    if (data is _i26.Comment) {
      return 'Comment';
    }
    if (data is _i27.Order) {
      return 'Order';
    }
    if (data is _i28.Student) {
      return 'Student';
    }
    if (data is _i29.Course) {
      return 'Course';
    }
    if (data is _i30.Enrollment) {
      return 'Enrollment';
    }
    if (data is _i31.ObjectWithMaps) {
      return 'ObjectWithMaps';
    }
    if (data is _i32.RelatedUniqueData) {
      return 'RelatedUniqueData';
    }
    if (data is _i33.ExceptionWithData) {
      return 'ExceptionWithData';
    }
    if (data is _i34.ModuleDatatype) {
      return 'ModuleDatatype';
    }
    if (data is _i35.ObjectWithIndex) {
      return 'ObjectWithIndex';
    }
    if (data is _i36.ObjectWithByteData) {
      return 'ObjectWithByteData';
    }
    if (data is _i37.TestEnumStringified) {
      return 'TestEnumStringified';
    }
    if (data is _i38.Nullability) {
      return 'Nullability';
    }
    if (data is _i39.ServerOnlyClass) {
      return 'ServerOnlyClass';
    }
    if (data is _i40.NotServerOnlyClass) {
      return 'NotServerOnlyClass';
    }
    if (data is _i41.ServerOnlyEnum) {
      return 'ServerOnlyEnum';
    }
    if (data is _i42.DefaultServerOnlyEnum) {
      return 'DefaultServerOnlyEnum';
    }
    if (data is _i43.DefaultServerOnlyClass) {
      return 'DefaultServerOnlyClass';
    }
    if (data is _i44.NotServerOnlyEnum) {
      return 'NotServerOnlyEnum';
    }
    if (data is _i45.ObjectWithObject) {
      return 'ObjectWithObject';
    }
    if (data is _i46.SimpleDateTime) {
      return 'SimpleDateTime';
    }
    if (data is _i47.Organization) {
      return 'Organization';
    }
    if (data is _i48.City) {
      return 'City';
    }
    if (data is _i49.Person) {
      return 'Person';
    }
    if (data is _i50.ObjectWithDuration) {
      return 'ObjectWithDuration';
    }
    if (data is _i51.Types) {
      return 'Types';
    }
    if (data is _i52.SimpleData) {
      return 'SimpleData';
    }
    if (data is _i53.ObjectWithParent) {
      return 'ObjectWithParent';
    }
    if (data is _i54.SimpleDataList) {
      return 'SimpleDataList';
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
      return deserialize<_i70.CustomClass>(data['data']);
    }
    if (data['className'] == 'ExternalCustomClass') {
      return deserialize<_i71.ExternalCustomClass>(data['data']);
    }
    if (data['className'] == 'FreezedCustomClass') {
      return deserialize<_i71.FreezedCustomClass>(data['data']);
    }
    if (data['className'] == 'SimpleDataMap') {
      return deserialize<_i5.SimpleDataMap>(data['data']);
    }
    if (data['className'] == 'UniqueData') {
      return deserialize<_i6.UniqueData>(data['data']);
    }
    if (data['className'] == 'ObjectFieldScopes') {
      return deserialize<_i7.ObjectFieldScopes>(data['data']);
    }
    if (data['className'] == 'ObjectWithUuid') {
      return deserialize<_i8.ObjectWithUuid>(data['data']);
    }
    if (data['className'] == 'TestEnum') {
      return deserialize<_i9.TestEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithSelfParent') {
      return deserialize<_i10.ObjectWithSelfParent>(data['data']);
    }
    if (data['className'] == 'ObjectWithEnum') {
      return deserialize<_i11.ObjectWithEnum>(data['data']);
    }
    if (data['className'] == 'Team') {
      return deserialize<_i12.Team>(data['data']);
    }
    if (data['className'] == 'Player') {
      return deserialize<_i13.Player>(data['data']);
    }
    if (data['className'] == 'Arena') {
      return deserialize<_i14.Arena>(data['data']);
    }
    if (data['className'] == 'ObjectUser') {
      return deserialize<_i15.ObjectUser>(data['data']);
    }
    if (data['className'] == 'ParentUser') {
      return deserialize<_i16.ParentUser>(data['data']);
    }
    if (data['className'] == 'Post') {
      return deserialize<_i17.Post>(data['data']);
    }
    if (data['className'] == 'Cat') {
      return deserialize<_i18.Cat>(data['data']);
    }
    if (data['className'] == 'Blocking') {
      return deserialize<_i19.Blocking>(data['data']);
    }
    if (data['className'] == 'Member') {
      return deserialize<_i20.Member>(data['data']);
    }
    if (data['className'] == 'Address') {
      return deserialize<_i21.Address>(data['data']);
    }
    if (data['className'] == 'Company') {
      return deserialize<_i22.Company>(data['data']);
    }
    if (data['className'] == 'Town') {
      return deserialize<_i23.Town>(data['data']);
    }
    if (data['className'] == 'Citizen') {
      return deserialize<_i24.Citizen>(data['data']);
    }
    if (data['className'] == 'Customer') {
      return deserialize<_i25.Customer>(data['data']);
    }
    if (data['className'] == 'Comment') {
      return deserialize<_i26.Comment>(data['data']);
    }
    if (data['className'] == 'Order') {
      return deserialize<_i27.Order>(data['data']);
    }
    if (data['className'] == 'Student') {
      return deserialize<_i28.Student>(data['data']);
    }
    if (data['className'] == 'Course') {
      return deserialize<_i29.Course>(data['data']);
    }
    if (data['className'] == 'Enrollment') {
      return deserialize<_i30.Enrollment>(data['data']);
    }
    if (data['className'] == 'ObjectWithMaps') {
      return deserialize<_i31.ObjectWithMaps>(data['data']);
    }
    if (data['className'] == 'RelatedUniqueData') {
      return deserialize<_i32.RelatedUniqueData>(data['data']);
    }
    if (data['className'] == 'ExceptionWithData') {
      return deserialize<_i33.ExceptionWithData>(data['data']);
    }
    if (data['className'] == 'ModuleDatatype') {
      return deserialize<_i34.ModuleDatatype>(data['data']);
    }
    if (data['className'] == 'ObjectWithIndex') {
      return deserialize<_i35.ObjectWithIndex>(data['data']);
    }
    if (data['className'] == 'ObjectWithByteData') {
      return deserialize<_i36.ObjectWithByteData>(data['data']);
    }
    if (data['className'] == 'TestEnumStringified') {
      return deserialize<_i37.TestEnumStringified>(data['data']);
    }
    if (data['className'] == 'Nullability') {
      return deserialize<_i38.Nullability>(data['data']);
    }
    if (data['className'] == 'ServerOnlyClass') {
      return deserialize<_i39.ServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyClass') {
      return deserialize<_i40.NotServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'ServerOnlyEnum') {
      return deserialize<_i41.ServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyEnum') {
      return deserialize<_i42.DefaultServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'DefaultServerOnlyClass') {
      return deserialize<_i43.DefaultServerOnlyClass>(data['data']);
    }
    if (data['className'] == 'NotServerOnlyEnum') {
      return deserialize<_i44.NotServerOnlyEnum>(data['data']);
    }
    if (data['className'] == 'ObjectWithObject') {
      return deserialize<_i45.ObjectWithObject>(data['data']);
    }
    if (data['className'] == 'SimpleDateTime') {
      return deserialize<_i46.SimpleDateTime>(data['data']);
    }
    if (data['className'] == 'Organization') {
      return deserialize<_i47.Organization>(data['data']);
    }
    if (data['className'] == 'City') {
      return deserialize<_i48.City>(data['data']);
    }
    if (data['className'] == 'Person') {
      return deserialize<_i49.Person>(data['data']);
    }
    if (data['className'] == 'ObjectWithDuration') {
      return deserialize<_i50.ObjectWithDuration>(data['data']);
    }
    if (data['className'] == 'Types') {
      return deserialize<_i51.Types>(data['data']);
    }
    if (data['className'] == 'SimpleData') {
      return deserialize<_i52.SimpleData>(data['data']);
    }
    if (data['className'] == 'ObjectWithParent') {
      return deserialize<_i53.ObjectWithParent>(data['data']);
    }
    if (data['className'] == 'SimpleDataList') {
      return deserialize<_i54.SimpleDataList>(data['data']);
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
      case _i6.UniqueData:
        return _i6.UniqueData.t;
      case _i7.ObjectFieldScopes:
        return _i7.ObjectFieldScopes.t;
      case _i8.ObjectWithUuid:
        return _i8.ObjectWithUuid.t;
      case _i10.ObjectWithSelfParent:
        return _i10.ObjectWithSelfParent.t;
      case _i11.ObjectWithEnum:
        return _i11.ObjectWithEnum.t;
      case _i12.Team:
        return _i12.Team.t;
      case _i13.Player:
        return _i13.Player.t;
      case _i14.Arena:
        return _i14.Arena.t;
      case _i15.ObjectUser:
        return _i15.ObjectUser.t;
      case _i16.ParentUser:
        return _i16.ParentUser.t;
      case _i17.Post:
        return _i17.Post.t;
      case _i18.Cat:
        return _i18.Cat.t;
      case _i19.Blocking:
        return _i19.Blocking.t;
      case _i20.Member:
        return _i20.Member.t;
      case _i21.Address:
        return _i21.Address.t;
      case _i22.Company:
        return _i22.Company.t;
      case _i23.Town:
        return _i23.Town.t;
      case _i24.Citizen:
        return _i24.Citizen.t;
      case _i25.Customer:
        return _i25.Customer.t;
      case _i26.Comment:
        return _i26.Comment.t;
      case _i27.Order:
        return _i27.Order.t;
      case _i28.Student:
        return _i28.Student.t;
      case _i29.Course:
        return _i29.Course.t;
      case _i30.Enrollment:
        return _i30.Enrollment.t;
      case _i32.RelatedUniqueData:
        return _i32.RelatedUniqueData.t;
      case _i35.ObjectWithIndex:
        return _i35.ObjectWithIndex.t;
      case _i36.ObjectWithByteData:
        return _i36.ObjectWithByteData.t;
      case _i45.ObjectWithObject:
        return _i45.ObjectWithObject.t;
      case _i46.SimpleDateTime:
        return _i46.SimpleDateTime.t;
      case _i47.Organization:
        return _i47.Organization.t;
      case _i48.City:
        return _i48.City.t;
      case _i49.Person:
        return _i49.Person.t;
      case _i50.ObjectWithDuration:
        return _i50.ObjectWithDuration.t;
      case _i51.Types:
        return _i51.Types.t;
      case _i52.SimpleData:
        return _i52.SimpleData.t;
      case _i53.ObjectWithParent:
        return _i53.ObjectWithParent.t;
    }
    return null;
  }

  @override
  List<_i2.TableDefinition> getTargetTableDefinitions() =>
      targetTableDefinitions;

  @override
  String getModuleName() => 'serverpod_test';
}
