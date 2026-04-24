BEGIN;

--
-- Class Address as table address
--
CREATE TABLE "address" (
    "id" INTEGER PRIMARY KEY,
    "street" TEXT NOT NULL,
    "inhabitantId" INTEGER,
    CONSTRAINT "address_fk_0" FOREIGN KEY ("inhabitantId") REFERENCES "citizen" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "inhabitant_index_idx" ON "address" ("inhabitantId");


--
-- Class AddressUuid as table address_uuid
--
CREATE TABLE "address_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "street" TEXT NOT NULL,
    "inhabitantId" INTEGER,
    CONSTRAINT "address_uuid_fk_0" FOREIGN KEY ("inhabitantId") REFERENCES "citizen_int" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "inhabitant_uuid_index_idx" ON "address_uuid" ("inhabitantId");


--
-- Class Arena as table arena
--
CREATE TABLE "arena" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class ArenaUuid as table arena_uuid
--
CREATE TABLE "arena_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;


--
-- Class BigIntDefault as table bigint_default
--
CREATE TABLE "bigint_default" (
    "id" INTEGER PRIMARY KEY,
    "bigintDefaultStr" TEXT NOT NULL DEFAULT ('-1234567890123456789099999999'),
    "bigintDefaultStrNull" TEXT DEFAULT ('1234567890123456789099999999')
) STRICT;


--
-- Class BigIntDefaultMix as table bigint_default_mix
--
CREATE TABLE "bigint_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('1'),
    "bigIntDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('12345678901234567890'),
    "bigIntDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('-1234567890123456789099999999')
) STRICT;


--
-- Class BigIntDefaultModel as table bigint_default_model
--
CREATE TABLE "bigint_default_model" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultModelStr" TEXT NOT NULL,
    "bigIntDefaultModelStrNull" TEXT
) STRICT;


--
-- Class BigIntDefaultPersist as table bigint_default_persist
--
CREATE TABLE "bigint_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultPersistStr" TEXT DEFAULT ('1234567890123456789099999999')
) STRICT;


--
-- Class Blocking as table blocking
--
CREATE TABLE "blocking" (
    "id" INTEGER PRIMARY KEY,
    "blockedId" INTEGER NOT NULL,
    "blockedById" INTEGER NOT NULL,
    CONSTRAINT "blocking_fk_0" FOREIGN KEY ("blockedId") REFERENCES "member" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "blocking_fk_1" FOREIGN KEY ("blockedById") REFERENCES "member" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "blocking_blocked_unique_idx" ON "blocking" ("blockedId", "blockedById");


--
-- Class Book as table book
--
CREATE TABLE "book" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL
) STRICT;


--
-- Class BoolDefault as table bool_default
--
CREATE TABLE "bool_default" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultTrue" INTEGER NOT NULL DEFAULT (1),
    "boolDefaultFalse" INTEGER NOT NULL DEFAULT (0),
    "boolDefaultNullFalse" INTEGER DEFAULT (0)
) STRICT;


--
-- Class BoolDefaultMix as table bool_default_mix
--
CREATE TABLE "bool_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (1),
    "boolDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (0),
    "boolDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (0)
) STRICT;


--
-- Class BoolDefaultModel as table bool_default_model
--
CREATE TABLE "bool_default_model" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultModelTrue" INTEGER NOT NULL,
    "boolDefaultModelFalse" INTEGER NOT NULL,
    "boolDefaultModelNullFalse" INTEGER NOT NULL
) STRICT;


--
-- Class BoolDefaultPersist as table bool_default_persist
--
CREATE TABLE "bool_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultPersistTrue" INTEGER DEFAULT (1),
    "boolDefaultPersistFalse" INTEGER DEFAULT (0)
) STRICT;


--
-- Class Cat as table cat
--
CREATE TABLE "cat" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "motherId" INTEGER,
    CONSTRAINT "cat_fk_0" FOREIGN KEY ("motherId") REFERENCES "cat" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;


--
-- Class ChangedIdTypeSelf as table changed_id_type_self
--
CREATE TABLE "changed_id_type_self" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL,
    "nextId" BLOB,
    "parentId" BLOB,
    CONSTRAINT "changed_id_type_self_fk_0" FOREIGN KEY ("nextId") REFERENCES "changed_id_type_self" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "changed_id_type_self_fk_1" FOREIGN KEY ("parentId") REFERENCES "changed_id_type_self" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "changed_id_type_self_next_unique_idx" ON "changed_id_type_self" ("nextId");


--
-- Class Chapter as table chapter
--
CREATE TABLE "chapter" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL,
    "_bookChaptersBookId" INTEGER,
    CONSTRAINT "chapter_fk_0" FOREIGN KEY ("_bookChaptersBookId") REFERENCES "book" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class ChildClassExplicitColumn as table child_table_explicit_column
--
CREATE TABLE "child_table_explicit_column" (
    "id" INTEGER PRIMARY KEY,
    "non_table_parent_field" TEXT NOT NULL,
    "child_field" TEXT NOT NULL
) STRICT;


--
-- Class Citizen as table citizen
--
CREATE TABLE "citizen" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "companyId" INTEGER NOT NULL,
    "oldCompanyId" INTEGER,
    CONSTRAINT "citizen_fk_0" FOREIGN KEY ("companyId") REFERENCES "company" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "citizen_fk_1" FOREIGN KEY ("oldCompanyId") REFERENCES "company" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class CitizenInt as table citizen_int
--
CREATE TABLE "citizen_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "companyId" BLOB NOT NULL,
    "oldCompanyId" BLOB,
    CONSTRAINT "citizen_int_fk_0" FOREIGN KEY ("companyId") REFERENCES "company_uuid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "citizen_int_fk_1" FOREIGN KEY ("oldCompanyId") REFERENCES "company_uuid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class City as table city
--
CREATE TABLE "city" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class CityWithLongTableName as table city_with_long_table_name_that_is_still_valid
--
CREATE TABLE "city_with_long_table_name_that_is_still_valid" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class Comment as table comment
--
CREATE TABLE "comment" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "orderId" INTEGER NOT NULL,
    CONSTRAINT "comment_fk_0" FOREIGN KEY ("orderId") REFERENCES "order" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;


--
-- Class CommentInt as table comment_int
--
CREATE TABLE "comment_int" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "orderId" BLOB NOT NULL,
    CONSTRAINT "comment_int_fk_0" FOREIGN KEY ("orderId") REFERENCES "order_uuid" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;


--
-- Class Company as table company
--
CREATE TABLE "company" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "townId" INTEGER NOT NULL,
    CONSTRAINT "company_fk_0" FOREIGN KEY ("townId") REFERENCES "town" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class CompanyUuid as table company_uuid
--
CREATE TABLE "company_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL,
    "townId" INTEGER NOT NULL,
    CONSTRAINT "company_uuid_fk_0" FOREIGN KEY ("townId") REFERENCES "town_int" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class Contractor as table contractor
--
CREATE TABLE "contractor" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "fk_contractor_service_id" INTEGER,
    CONSTRAINT "contractor_fk_0" FOREIGN KEY ("fk_contractor_service_id") REFERENCES "service" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "contractor_service_unique_idx" ON "contractor" ("fk_contractor_service_id");


--
-- Class Course as table course
--
CREATE TABLE "course" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class CourseUuid as table course_uuid
--
CREATE TABLE "course_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;


--
-- Class Customer as table customer
--
CREATE TABLE "customer" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class CustomerInt as table customer_int
--
CREATE TABLE "customer_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class DateTimeDefault as table datetime_default
--
CREATE TABLE "datetime_default" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultNow" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "dateTimeDefaultStr" INTEGER NOT NULL DEFAULT (1716588000000),
    "dateTimeDefaultStrNull" INTEGER DEFAULT (1716588000000)
) STRICT;


--
-- Class DateTimeDefaultMix as table datetime_default_mix
--
CREATE TABLE "datetime_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (1714600800000),
    "dateTimeDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (1715378400000),
    "dateTimeDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (1715378400000)
) STRICT;


--
-- Class DateTimeDefaultModel as table datetime_default_model
--
CREATE TABLE "datetime_default_model" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultModelNow" INTEGER NOT NULL,
    "dateTimeDefaultModelStr" INTEGER NOT NULL,
    "dateTimeDefaultModelStrNull" INTEGER
) STRICT;


--
-- Class DateTimeDefaultPersist as table datetime_default_persist
--
CREATE TABLE "datetime_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultPersistNow" INTEGER DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "dateTimeDefaultPersistStr" INTEGER DEFAULT (1715378400000)
) STRICT;


--
-- Class Department as table department
--
CREATE TABLE "department" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class DoubleDefault as table double_default
--
CREATE TABLE "double_default" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefault" REAL NOT NULL DEFAULT (10.5),
    "doubleDefaultNull" REAL DEFAULT (20.5)
) STRICT;


--
-- Class DoubleDefaultMix as table double_default_mix
--
CREATE TABLE "double_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultAndDefaultModel" REAL NOT NULL DEFAULT (10.5),
    "doubleDefaultAndDefaultPersist" REAL NOT NULL DEFAULT (20.5),
    "doubleDefaultModelAndDefaultPersist" REAL NOT NULL DEFAULT (20.5)
) STRICT;


--
-- Class DoubleDefaultModel as table double_default_model
--
CREATE TABLE "double_default_model" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultModel" REAL NOT NULL,
    "doubleDefaultModelNull" REAL NOT NULL
) STRICT;


--
-- Class DoubleDefaultPersist as table double_default_persist
--
CREATE TABLE "double_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultPersist" REAL DEFAULT (10.5)
) STRICT;


--
-- Class DurationDefault as table duration_default
--
CREATE TABLE "duration_default" (
    "id" INTEGER PRIMARY KEY,
    "durationDefault" INTEGER NOT NULL DEFAULT (94230100),
    "durationDefaultNull" INTEGER DEFAULT (177640100)
) STRICT;


--
-- Class DurationDefaultMix as table duration_default_mix
--
CREATE TABLE "duration_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (94230100),
    "durationDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (177640100),
    "durationDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (177640100)
) STRICT;


--
-- Class DurationDefaultModel as table duration_default_model
--
CREATE TABLE "duration_default_model" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultModel" INTEGER NOT NULL,
    "durationDefaultModelNull" INTEGER
) STRICT;


--
-- Class DurationDefaultPersist as table duration_default_persist
--
CREATE TABLE "duration_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultPersist" INTEGER DEFAULT (94230100)
) STRICT;


--
-- Class Employee as table employee
--
CREATE TABLE "employee" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "fk_employee_department_id" INTEGER NOT NULL,
    CONSTRAINT "employee_fk_0" FOREIGN KEY ("fk_employee_department_id") REFERENCES "department" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class EmptyModelRelationItem as table empty_model_relation_item
--
CREATE TABLE "empty_model_relation_item" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_relationEmptyModelItemsRelationEmptyModelId" INTEGER,
    CONSTRAINT "empty_model_relation_item_fk_0" FOREIGN KEY ("_relationEmptyModelItemsRelationEmptyModelId") REFERENCES "relation_empty_model" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class EmptyModelWithTable as table empty_model_with_table
--
CREATE TABLE "empty_model_with_table" (
    "id" INTEGER PRIMARY KEY
) STRICT;


--
-- Class Enrollment as table enrollment
--
CREATE TABLE "enrollment" (
    "id" INTEGER PRIMARY KEY,
    "studentId" INTEGER NOT NULL,
    "courseId" INTEGER NOT NULL,
    CONSTRAINT "enrollment_fk_0" FOREIGN KEY ("studentId") REFERENCES "student" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "enrollment_fk_1" FOREIGN KEY ("courseId") REFERENCES "course" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "enrollment_index_idx" ON "enrollment" ("studentId", "courseId");


--
-- Class EnrollmentInt as table enrollment_int
--
CREATE TABLE "enrollment_int" (
    "id" INTEGER PRIMARY KEY,
    "studentId" BLOB NOT NULL,
    "courseId" BLOB NOT NULL,
    CONSTRAINT "enrollment_int_fk_0" FOREIGN KEY ("studentId") REFERENCES "student_uuid" ("id") ON DELETE CASCADE ON UPDATE NO ACTION,
    CONSTRAINT "enrollment_int_fk_1" FOREIGN KEY ("courseId") REFERENCES "course_uuid" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "enrollment_int_index_idx" ON "enrollment_int" ("studentId", "courseId");


--
-- Class EnumDefault as table enum_default
--
CREATE TABLE "enum_default" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefault" TEXT NOT NULL DEFAULT ('byName1'),
    "byNameEnumDefaultNull" TEXT DEFAULT ('byName2'),
    "byIndexEnumDefault" INTEGER NOT NULL DEFAULT (0),
    "byIndexEnumDefaultNull" INTEGER DEFAULT (1)
) STRICT;


--
-- Class EnumDefaultMix as table enum_default_mix
--
CREATE TABLE "enum_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('byName1'),
    "byNameEnumDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('byName2'),
    "byNameEnumDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('byName2')
) STRICT;


--
-- Class EnumDefaultModel as table enum_default_model
--
CREATE TABLE "enum_default_model" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultModel" TEXT NOT NULL,
    "byNameEnumDefaultModelNull" TEXT,
    "byIndexEnumDefaultModel" INTEGER NOT NULL,
    "byIndexEnumDefaultModelNull" INTEGER
) STRICT;


--
-- Class EnumDefaultPersist as table enum_default_persist
--
CREATE TABLE "enum_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultPersist" TEXT DEFAULT ('byName1'),
    "byIndexEnumDefaultPersist" INTEGER DEFAULT (0)
) STRICT;


--
-- Class IntDefault as table int_default
--
CREATE TABLE "int_default" (
    "id" INTEGER PRIMARY KEY,
    "intDefault" INTEGER NOT NULL DEFAULT (10),
    "intDefaultNull" INTEGER DEFAULT (20)
) STRICT;


--
-- Class IntDefaultMix as table int_default_mix
--
CREATE TABLE "int_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (10),
    "intDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (20),
    "intDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (20)
) STRICT;


--
-- Class IntDefaultModel as table int_default_model
--
CREATE TABLE "int_default_model" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultModel" INTEGER NOT NULL,
    "intDefaultModelNull" INTEGER NOT NULL
) STRICT;


--
-- Class IntDefaultPersist as table int_default_persist
--
CREATE TABLE "int_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultPersist" INTEGER DEFAULT (10)
) STRICT;


--
-- Class LongImplicitIdField as table long_implicit_id_field
--
CREATE TABLE "long_implicit_id_field" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id" INTEGER,
    CONSTRAINT "long_implicit_id_field_fk_0" FOREIGN KEY ("_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id") REFERENCES "long_implicit_id_field_collection" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class LongImplicitIdFieldCollection as table long_implicit_id_field_collection
--
CREATE TABLE "long_implicit_id_field_collection" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class MaxFieldName as table max_field_name
--
CREATE TABLE "max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" TEXT NOT NULL
) STRICT;


--
-- Class Member as table member
--
CREATE TABLE "member" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class ModelWithRequiredField as table model_with_required_field
--
CREATE TABLE "model_with_required_field" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT
) STRICT;


--
-- Class ModifiedColumnName as table modified_column_name
--
CREATE TABLE "modified_column_name" (
    "id" INTEGER PRIMARY KEY,
    "originalColumn" TEXT NOT NULL,
    "modified_column" TEXT NOT NULL
) STRICT;


--
-- Class MultipleMaxFieldName as table multiple_max_field_name
--
CREATE TABLE "multiple_max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1" TEXT NOT NULL,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2" TEXT NOT NULL,
    "_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId" INTEGER,
    CONSTRAINT "multiple_max_field_name_fk_0" FOREIGN KEY ("_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId") REFERENCES "relation_to_multiple_max_field_name" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class ObjectFieldPersist as table object_field_persist
--
CREATE TABLE "object_field_persist" (
    "id" INTEGER PRIMARY KEY,
    "normal" TEXT NOT NULL
) STRICT;


--
-- Class ObjectFieldScopes as table object_field_scopes
--
CREATE TABLE "object_field_scopes" (
    "id" INTEGER PRIMARY KEY,
    "normal" TEXT NOT NULL,
    "database" TEXT
) STRICT;


--
-- Class ObjectWithBit as table object_with_bit
--
CREATE TABLE "object_with_bit" (
    "id" INTEGER PRIMARY KEY,
    "bit" TEXT NOT NULL,
    "bitNullable" TEXT,
    "bitIndexedHnsw" TEXT NOT NULL,
    "bitIndexedHnswWithParams" TEXT NOT NULL,
    "bitIndexedIvfflat" TEXT NOT NULL,
    "bitIndexedIvfflatWithParams" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithByteData as table object_with_bytedata
--
CREATE TABLE "object_with_bytedata" (
    "id" INTEGER PRIMARY KEY,
    "byteData" BLOB NOT NULL
) STRICT;


--
-- Class ObjectWithDuration as table object_with_duration
--
CREATE TABLE "object_with_duration" (
    "id" INTEGER PRIMARY KEY,
    "duration" INTEGER NOT NULL
) STRICT;


--
-- Class ObjectWithEnum as table object_with_enum
--
CREATE TABLE "object_with_enum" (
    "id" INTEGER PRIMARY KEY,
    "testEnum" INTEGER NOT NULL,
    "nullableEnum" INTEGER,
    "enumList" TEXT NOT NULL,
    "nullableEnumList" TEXT NOT NULL,
    "enumListList" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithEnumEnhanced as table object_with_enum_enhanced
--
CREATE TABLE "object_with_enum_enhanced" (
    "id" INTEGER PRIMARY KEY,
    "byIndex" INTEGER NOT NULL,
    "nullableByIndex" INTEGER,
    "byIndexList" TEXT NOT NULL,
    "byName" TEXT NOT NULL,
    "nullableByName" TEXT,
    "byNameList" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithHalfVector as table object_with_half_vector
--
CREATE TABLE "object_with_half_vector" (
    "id" INTEGER PRIMARY KEY,
    "halfVector" TEXT NOT NULL,
    "halfVectorNullable" TEXT,
    "halfVectorIndexedHnsw" TEXT NOT NULL,
    "halfVectorIndexedHnswWithParams" TEXT NOT NULL,
    "halfVectorIndexedIvfflat" TEXT NOT NULL,
    "halfVectorIndexedIvfflatWithParams" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithIndex as table object_with_index
--
CREATE TABLE "object_with_index" (
    "id" INTEGER PRIMARY KEY,
    "indexed" INTEGER NOT NULL,
    "indexed2" INTEGER NOT NULL
) STRICT;


--
-- Class ObjectWithJsonb as table object_with_jsonb
--
CREATE TABLE "object_with_jsonb" (
    "id" INTEGER PRIMARY KEY,
    "notJsonb" TEXT NOT NULL,
    "jsonb" BLOB NOT NULL,
    "jsonbMap" BLOB NOT NULL,
    "jsonbObject" BLOB NOT NULL,
    "jsonbIndexed" BLOB NOT NULL,
    "jsonbIndexedGin" BLOB NOT NULL,
    "jsonbIndexedGinJsonbPath" BLOB NOT NULL,
    "jsonbIndexedImplicitGin" BLOB NOT NULL,
    "nullableJsonb" BLOB
) STRICT;


--
-- Class ObjectWithJsonbClassLevel as table object_with_jsonb_class_level
--
CREATE TABLE "object_with_jsonb_class_level" (
    "id" INTEGER PRIMARY KEY,
    "implicitJsonb" BLOB NOT NULL,
    "explicitJsonb" BLOB NOT NULL,
    "json" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithObject as table object_with_object
--
CREATE TABLE "object_with_object" (
    "id" INTEGER PRIMARY KEY,
    "data" TEXT NOT NULL,
    "nullableData" TEXT,
    "dataList" TEXT NOT NULL,
    "nullableDataList" TEXT,
    "listWithNullableData" TEXT NOT NULL,
    "nullableListWithNullableData" TEXT,
    "nestedDataList" TEXT,
    "nestedDataListInMap" TEXT,
    "nestedDataMap" TEXT
) STRICT;


--
-- Class ObjectWithParent as table object_with_parent
--
CREATE TABLE "object_with_parent" (
    "id" INTEGER PRIMARY KEY,
    "other" INTEGER NOT NULL,
    CONSTRAINT "object_with_parent_fk_0" FOREIGN KEY ("other") REFERENCES "object_field_scopes" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class ObjectWithSelfParent as table object_with_self_parent
--
CREATE TABLE "object_with_self_parent" (
    "id" INTEGER PRIMARY KEY,
    "other" INTEGER,
    CONSTRAINT "object_with_self_parent_fk_0" FOREIGN KEY ("other") REFERENCES "object_with_self_parent" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class ObjectWithSparseVector as table object_with_sparse_vector
--
CREATE TABLE "object_with_sparse_vector" (
    "id" INTEGER PRIMARY KEY,
    "sparseVector" TEXT NOT NULL,
    "sparseVectorNullable" TEXT,
    "sparseVectorIndexedHnsw" TEXT NOT NULL,
    "sparseVectorIndexedHnswWithParams" TEXT NOT NULL
) STRICT;


--
-- Class ObjectWithUuid as table object_with_uuid
--
CREATE TABLE "object_with_uuid" (
    "id" INTEGER PRIMARY KEY,
    "uuid" BLOB NOT NULL,
    "uuidNullable" BLOB
) STRICT;


--
-- Class ObjectWithVector as table object_with_vector
--
CREATE TABLE "object_with_vector" (
    "id" INTEGER PRIMARY KEY,
    "vector" TEXT NOT NULL,
    "vectorNullable" TEXT,
    "vectorIndexedHnsw" TEXT NOT NULL,
    "vectorIndexedHnswWithParams" TEXT NOT NULL,
    "vectorIndexedIvfflat" TEXT NOT NULL,
    "vectorIndexedIvfflatWithParams" TEXT NOT NULL
) STRICT;


--
-- Class Order as table order
--
CREATE TABLE "order" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "customerId" INTEGER NOT NULL,
    CONSTRAINT "order_fk_0" FOREIGN KEY ("customerId") REFERENCES "customer" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;


--
-- Class OrderUuid as table order_uuid
--
CREATE TABLE "order_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "description" TEXT NOT NULL,
    "customerId" INTEGER NOT NULL,
    CONSTRAINT "order_uuid_fk_0" FOREIGN KEY ("customerId") REFERENCES "customer_int" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;


--
-- Class Organization as table organization
--
CREATE TABLE "organization" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "cityId" INTEGER,
    CONSTRAINT "organization_fk_0" FOREIGN KEY ("cityId") REFERENCES "city" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class OrganizationWithLongTableName as table organization_with_long_table_name_that_is_still_valid
--
CREATE TABLE "organization_with_long_table_name_that_is_still_valid" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "cityId" INTEGER,
    CONSTRAINT "organization_with_long_table_name_that_is_still_valid_fk_0" FOREIGN KEY ("cityId") REFERENCES "city_with_long_table_name_that_is_still_valid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class Person as table person
--
CREATE TABLE "person" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "organizationId" INTEGER,
    "_cityCitizensCityId" INTEGER,
    CONSTRAINT "person_fk_0" FOREIGN KEY ("organizationId") REFERENCES "organization" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "person_fk_1" FOREIGN KEY ("_cityCitizensCityId") REFERENCES "city" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class PersonWithLongTableName as table person_with_long_table_name_that_is_still_valid
--
CREATE TABLE "person_with_long_table_name_that_is_still_valid" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "organizationId" INTEGER,
    "_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id" INTEGER,
    CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_0" FOREIGN KEY ("organizationId") REFERENCES "organization_with_long_table_name_that_is_still_valid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION,
    CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_1" FOREIGN KEY ("_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id") REFERENCES "city_with_long_table_name_that_is_still_valid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class Player as table player
--
CREATE TABLE "player" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "teamId" INTEGER,
    CONSTRAINT "player_fk_0" FOREIGN KEY ("teamId") REFERENCES "team" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;


--
-- Class PlayerUuid as table player_uuid
--
CREATE TABLE "player_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL,
    "teamId" INTEGER,
    CONSTRAINT "player_uuid_fk_0" FOREIGN KEY ("teamId") REFERENCES "team_int" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;


--
-- Class Post as table post
--
CREATE TABLE "post" (
    "id" INTEGER PRIMARY KEY,
    "content" TEXT NOT NULL,
    "nextId" INTEGER,
    CONSTRAINT "post_fk_0" FOREIGN KEY ("nextId") REFERENCES "post" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "next_unique_idx" ON "post" ("nextId");


--
-- Class RelatedUniqueData as table related_unique_data
--
CREATE TABLE "related_unique_data" (
    "id" INTEGER PRIMARY KEY,
    "uniqueDataId" INTEGER NOT NULL,
    "number" INTEGER NOT NULL,
    CONSTRAINT "related_unique_data_fk_0" FOREIGN KEY ("uniqueDataId") REFERENCES "unique_data" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION
) STRICT;


--
-- Class RelationEmptyModel as table relation_empty_model
--
CREATE TABLE "relation_empty_model" (
    "id" INTEGER PRIMARY KEY
) STRICT;


--
-- Class RelationToMultipleMaxFieldName as table relation_to_multiple_max_field_name
--
CREATE TABLE "relation_to_multiple_max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class ServerOnlyChangedIdFieldClass as table server_only_changed_id_field_class
--
CREATE TABLE "server_only_changed_id_field_class" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))
) STRICT;


--
-- Class Service as table service
--
CREATE TABLE "service" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT
) STRICT;


--
-- Class SimpleData as table simple_data
--
CREATE TABLE "simple_data" (
    "id" INTEGER PRIMARY KEY,
    "num" INTEGER NOT NULL
) STRICT;


--
-- Class SimpleDateTime as table simple_date_time
--
CREATE TABLE "simple_date_time" (
    "id" INTEGER PRIMARY KEY,
    "dateTime" INTEGER NOT NULL
) STRICT;


--
-- Class StringDefault as table string_default
--
CREATE TABLE "string_default" (
    "id" INTEGER PRIMARY KEY,
    "stringDefault" TEXT NOT NULL DEFAULT ('This is a default value'),
    "stringDefaultNull" TEXT DEFAULT ('This is a default null value')
) STRICT;


--
-- Class StringDefaultMix as table string_default_mix
--
CREATE TABLE "string_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "stringDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('This is a default value'),
    "stringDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('This is a default persist value'),
    "stringDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('This is a default persist value')
) STRICT;


--
-- Class StringDefaultModel as table string_default_model
--
CREATE TABLE "string_default_model" (
    "id" INTEGER PRIMARY KEY,
    "stringDefaultModel" TEXT NOT NULL,
    "stringDefaultModelNull" TEXT NOT NULL
) STRICT;


--
-- Class StringDefaultPersist as table string_default_persist
--
CREATE TABLE "string_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "stringDefaultPersist" TEXT DEFAULT ('This is a default persist value'),
    "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote" TEXT DEFAULT ('This is a ''default persist value'),
    "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote" TEXT DEFAULT ('This is a ''default'' persist value'),
    "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote" TEXT DEFAULT ('This is a "default persist value'),
    "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote" TEXT DEFAULT ('This is a "default" persist value'),
    "stringDefaultPersistSingleQuoteWithOneDoubleQuote" TEXT DEFAULT ('This is a "default persist value'),
    "stringDefaultPersistSingleQuoteWithTwoDoubleQuote" TEXT DEFAULT ('This is a "default" persist value'),
    "stringDefaultPersistDoubleQuoteWithOneSingleQuote" TEXT DEFAULT ('This is a ''default persist value'),
    "stringDefaultPersistDoubleQuoteWithTwoSingleQuote" TEXT DEFAULT ('This is a ''default'' persist value')
) STRICT;


--
-- Class Student as table student
--
CREATE TABLE "student" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class StudentUuid as table student_uuid
--
CREATE TABLE "student_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;


--
-- Class TableWithExplicitColumnName as table table_with_explicit_column_names
--
CREATE TABLE "table_with_explicit_column_names" (
    "id" INTEGER PRIMARY KEY,
    "user_name" TEXT NOT NULL,
    "user_description" TEXT DEFAULT ('Just some information')
) STRICT;


--
-- Class Team as table team
--
CREATE TABLE "team" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "arenaId" INTEGER,
    CONSTRAINT "team_fk_0" FOREIGN KEY ("arenaId") REFERENCES "arena" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "arena_index_idx" ON "team" ("arenaId");


--
-- Class TeamInt as table team_int
--
CREATE TABLE "team_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "arenaId" BLOB,
    CONSTRAINT "team_int_fk_0" FOREIGN KEY ("arenaId") REFERENCES "arena_uuid" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "arena_uuid_index_idx" ON "team_int" ("arenaId");


--
-- Class Town as table town
--
CREATE TABLE "town" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "mayorId" INTEGER,
    CONSTRAINT "town_fk_0" FOREIGN KEY ("mayorId") REFERENCES "citizen" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class TownInt as table town_int
--
CREATE TABLE "town_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "mayorId" INTEGER,
    CONSTRAINT "town_int_fk_0" FOREIGN KEY ("mayorId") REFERENCES "citizen_int" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class Types as table types
--
CREATE TABLE "types" (
    "id" INTEGER PRIMARY KEY,
    "anInt" INTEGER,
    "aBool" INTEGER,
    "aDouble" REAL,
    "aDateTime" INTEGER,
    "aString" TEXT,
    "aByteData" BLOB,
    "aDuration" INTEGER,
    "aUuid" BLOB,
    "aUri" TEXT,
    "aBigInt" TEXT,
    "aVector" TEXT,
    "aHalfVector" TEXT,
    "aSparseVector" TEXT,
    "aBit" TEXT,
    "anEnum" INTEGER,
    "aStringifiedEnum" TEXT,
    "aList" TEXT,
    "aMap" TEXT,
    "aSet" TEXT,
    "aRecord" TEXT
) STRICT;


--
-- Class UniqueData as table unique_data
--
CREATE TABLE "unique_data" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL,
    "email" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" ("email");


--
-- Class UniqueDataWithNonPersist as table unique_data_with_non_persist
--
CREATE TABLE "unique_data_with_non_persist" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL,
    "email" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "unique_email_idx" ON "unique_data_with_non_persist" ("email");


--
-- Class UriDefault as table uri_default
--
CREATE TABLE "uri_default" (
    "id" INTEGER PRIMARY KEY,
    "uriDefault" TEXT NOT NULL DEFAULT ('https://serverpod.dev/default'),
    "uriDefaultNull" TEXT DEFAULT ('https://serverpod.dev/default')
) STRICT;


--
-- Class UriDefaultMix as table uri_default_mix
--
CREATE TABLE "uri_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('https://serverpod.dev/default'),
    "uriDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('https://serverpod.dev/defaultPersist'),
    "uriDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('https://serverpod.dev/defaultPersist')
) STRICT;


--
-- Class UriDefaultModel as table uri_default_model
--
CREATE TABLE "uri_default_model" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultModel" TEXT NOT NULL,
    "uriDefaultModelNull" TEXT
) STRICT;


--
-- Class UriDefaultPersist as table uri_default_persist
--
CREATE TABLE "uri_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultPersist" TEXT DEFAULT ('https://serverpod.dev/')
) STRICT;


--
-- Class UserNote as table user_note
--
CREATE TABLE "user_note" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId" INTEGER,
    CONSTRAINT "user_note_fk_0" FOREIGN KEY ("_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId") REFERENCES "user_note_collections" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class UserNoteCollectionWithALongName as table user_note_collection_with_a_long_name
--
CREATE TABLE "user_note_collection_with_a_long_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class UserNoteCollection as table user_note_collections
--
CREATE TABLE "user_note_collections" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;


--
-- Class UserNoteWithALongName as table user_note_with_a_long_name
--
CREATE TABLE "user_note_with_a_long_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId" INTEGER,
    CONSTRAINT "user_note_with_a_long_name_fk_0" FOREIGN KEY ("_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId") REFERENCES "user_note_collection_with_a_long_name" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;


--
-- Class UuidDefault as table uuid_default
--
CREATE TABLE "uuid_default" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultRandom" BLOB NOT NULL DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultRandomV7" BLOB NOT NULL DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultRandomNull" BLOB DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultStr" BLOB NOT NULL DEFAULT (X'550e8400e29b41d4a716446655440000'),
    "uuidDefaultStrNull" BLOB DEFAULT (X'3f2504e04f8911d39a0c0305e82c3301')
) STRICT;


--
-- Class UuidDefaultMix as table uuid_default_mix
--
CREATE TABLE "uuid_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultAndDefaultModel" BLOB NOT NULL DEFAULT (X'3f2504e04f8911d39a0c0305e82c3301'),
    "uuidDefaultAndDefaultPersist" BLOB NOT NULL DEFAULT (X'9e107d9d372b4d979b272f0907d0b1d4'),
    "uuidDefaultModelAndDefaultPersist" BLOB NOT NULL DEFAULT (X'f47ac10b58cc4372a5670e02b2c3d479')
) STRICT;


--
-- Class UuidDefaultModel as table uuid_default_model
--
CREATE TABLE "uuid_default_model" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultModelRandom" BLOB NOT NULL,
    "uuidDefaultModelRandomV7" BLOB NOT NULL,
    "uuidDefaultModelRandomNull" BLOB,
    "uuidDefaultModelStr" BLOB NOT NULL,
    "uuidDefaultModelStrNull" BLOB
) STRICT;


--
-- Class UuidDefaultPersist as table uuid_default_persist
--
CREATE TABLE "uuid_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultPersistRandom" BLOB DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultPersistRandomV7" BLOB DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultPersistStr" BLOB DEFAULT (X'550e8400e29b41d4a716446655440000')
) STRICT;


--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" INTEGER PRIMARY KEY,
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "addedTime" INTEGER NOT NULL,
    "expiration" INTEGER,
    "byteData" BLOB NOT NULL,
    "verified" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" ("expiration");


--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" INTEGER PRIMARY KEY,
    "storageId" TEXT NOT NULL,
    "path" TEXT NOT NULL,
    "expiration" INTEGER NOT NULL,
    "authKey" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" ("storageId", "path");


--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "serializedObject" TEXT,
    "serverId" TEXT NOT NULL,
    "identifier" TEXT,
    "scheduling" TEXT
) STRICT;

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" ("identifier");


--
-- Class FutureCallClaimEntry as table serverpod_future_call_claim
--
CREATE TABLE "serverpod_future_call_claim" (
    "id" INTEGER PRIMARY KEY,
    "futureCallId" INTEGER,
    "lastHeartbeatTime" INTEGER NOT NULL,
    CONSTRAINT "serverpod_future_call_claim_fk_0" FOREIGN KEY ("futureCallId") REFERENCES "serverpod_future_call" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "future_call_unique_idx" ON "serverpod_future_call_claim" ("futureCallId");


--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "timestamp" INTEGER NOT NULL,
    "active" INTEGER NOT NULL,
    "closing" INTEGER NOT NULL,
    "idle" INTEGER NOT NULL,
    "granularity" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" ("timestamp", "serverId", "granularity");


--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "serverId" TEXT NOT NULL,
    "timestamp" INTEGER NOT NULL,
    "isHealthy" INTEGER NOT NULL,
    "value" REAL NOT NULL,
    "granularity" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" ("timestamp", "serverId", "name", "granularity");


--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" INTEGER PRIMARY KEY,
    "sessionLogId" INTEGER NOT NULL,
    "messageId" INTEGER,
    "reference" TEXT,
    "serverId" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "logLevel" INTEGER NOT NULL,
    "message" TEXT NOT NULL,
    "error" TEXT,
    "stackTrace" TEXT,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" ("sessionLogId", "order");


--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" INTEGER PRIMARY KEY,
    "sessionLogId" INTEGER NOT NULL,
    "serverId" TEXT NOT NULL,
    "messageId" INTEGER NOT NULL,
    "endpoint" TEXT NOT NULL,
    "messageName" TEXT NOT NULL,
    "duration" REAL NOT NULL,
    "error" TEXT,
    "stackTrace" TEXT,
    "slow" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_message_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_message_log_sessionLogId_idx" ON "serverpod_message_log" ("sessionLogId", "order");


--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" INTEGER PRIMARY KEY,
    "endpoint" TEXT NOT NULL,
    "method" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" ("endpoint", "method");


--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" INTEGER PRIMARY KEY,
    "module" TEXT NOT NULL,
    "version" TEXT NOT NULL,
    "timestamp" INTEGER
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" ("module");


--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "sessionLogId" INTEGER NOT NULL,
    "messageId" INTEGER,
    "query" TEXT NOT NULL,
    "duration" REAL NOT NULL,
    "numRows" INTEGER,
    "error" TEXT,
    "stackTrace" TEXT,
    "slow" INTEGER NOT NULL,
    "order" INTEGER NOT NULL,
    CONSTRAINT "serverpod_query_log_fk_0" FOREIGN KEY ("sessionLogId") REFERENCES "serverpod_session_log" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" ("sessionLogId", "order");


--
-- Class ReactiveDatabaseCallEntry as table serverpod_reactive_db_call
--
CREATE TABLE "serverpod_reactive_db_call" (
    "id" INTEGER PRIMARY KEY,
    "handlerName" TEXT NOT NULL,
    "sourceTable" TEXT NOT NULL,
    "operation" TEXT NOT NULL,
    "rowData" TEXT NOT NULL,
    "createdAt" INTEGER NOT NULL,
    "futureCallEntryId" INTEGER,
    CONSTRAINT "serverpod_reactive_db_call_fk_0" FOREIGN KEY ("futureCallEntryId") REFERENCES "serverpod_future_call" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

-- Indexes
CREATE INDEX "serverpod_reactive_db_call_created_at_idx" ON "serverpod_reactive_db_call" ("createdAt");
CREATE INDEX "serverpod_reactive_db_call_handler_name_idx" ON "serverpod_reactive_db_call" ("handlerName");


--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL
) STRICT;


--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" INTEGER PRIMARY KEY,
    "logSettings" TEXT NOT NULL,
    "logSettingsOverrides" TEXT NOT NULL,
    "logServiceCalls" INTEGER NOT NULL,
    "logMalformedCalls" INTEGER NOT NULL
) STRICT;


--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" INTEGER PRIMARY KEY,
    "serverId" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "module" TEXT,
    "endpoint" TEXT,
    "method" TEXT,
    "duration" REAL,
    "numQueries" INTEGER,
    "slow" INTEGER,
    "error" TEXT,
    "stackTrace" TEXT,
    "authenticatedUserId" INTEGER,
    "userId" TEXT,
    "isOpen" INTEGER,
    "touched" INTEGER NOT NULL
) STRICT;

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" ("serverId");
CREATE INDEX "serverpod_session_log_time_idx" ON "serverpod_session_log" ("time");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" ("isOpen");


--
-- STORE COLUMN TYPES FOR MIGRATIONS
--
DROP TABLE IF EXISTS "serverpod_sqlite_schema";

CREATE TABLE "serverpod_sqlite_schema" (
    "table_name" TEXT NOT NULL,
    "column_name" TEXT NOT NULL,
    "column_type" TEXT NOT NULL,
    "column_vector_dimension" INTEGER,
    PRIMARY KEY ("table_name", "column_name")
);

INSERT INTO "serverpod_sqlite_schema" VALUES
    ('address_uuid', 'id', 'uuid', NULL),
    ('arena_uuid', 'id', 'uuid', NULL),
    ('bool_default', 'boolDefaultTrue', 'boolean', NULL),
    ('bool_default', 'boolDefaultFalse', 'boolean', NULL),
    ('bool_default', 'boolDefaultNullFalse', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultModel', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultPersist', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultModelAndDefaultPersist', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelTrue', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelFalse', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelNullFalse', 'boolean', NULL),
    ('bool_default_persist', 'boolDefaultPersistTrue', 'boolean', NULL),
    ('bool_default_persist', 'boolDefaultPersistFalse', 'boolean', NULL),
    ('changed_id_type_self', 'id', 'uuid', NULL),
    ('changed_id_type_self', 'nextId', 'uuid', NULL),
    ('changed_id_type_self', 'parentId', 'uuid', NULL),
    ('citizen_int', 'companyId', 'uuid', NULL),
    ('citizen_int', 'oldCompanyId', 'uuid', NULL),
    ('comment_int', 'orderId', 'uuid', NULL),
    ('company_uuid', 'id', 'uuid', NULL),
    ('course_uuid', 'id', 'uuid', NULL),
    ('datetime_default', 'dateTimeDefaultNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultModel', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultModelAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistStr', 'timestampWithoutTimeZone', NULL),
    ('enrollment_int', 'studentId', 'uuid', NULL),
    ('enrollment_int', 'courseId', 'uuid', NULL),
    ('object_with_bit', 'bit', 'bit', 512),
    ('object_with_bit', 'bitNullable', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnsw', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnswWithParams', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflat', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflatWithParams', 'bit', 512),
    ('object_with_enum', 'enumList', 'json', NULL),
    ('object_with_enum', 'nullableEnumList', 'json', NULL),
    ('object_with_enum', 'enumListList', 'json', NULL),
    ('object_with_enum_enhanced', 'byIndexList', 'json', NULL),
    ('object_with_enum_enhanced', 'byNameList', 'json', NULL),
    ('object_with_half_vector', 'halfVector', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorNullable', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnsw', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnswWithParams', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflat', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflatWithParams', 'halfvec', 512),
    ('object_with_jsonb', 'notJsonb', 'json', NULL),
    ('object_with_jsonb', 'jsonb', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbMap', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbObject', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexed', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedGin', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedGinJsonbPath', 'jsonb', NULL),
    ('object_with_jsonb', 'jsonbIndexedImplicitGin', 'jsonb', NULL),
    ('object_with_jsonb', 'nullableJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'implicitJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'explicitJsonb', 'jsonb', NULL),
    ('object_with_jsonb_class_level', 'json', 'json', NULL),
    ('object_with_object', 'data', 'json', NULL),
    ('object_with_object', 'nullableData', 'json', NULL),
    ('object_with_object', 'dataList', 'json', NULL),
    ('object_with_object', 'nullableDataList', 'json', NULL),
    ('object_with_object', 'listWithNullableData', 'json', NULL),
    ('object_with_object', 'nullableListWithNullableData', 'json', NULL),
    ('object_with_object', 'nestedDataList', 'json', NULL),
    ('object_with_object', 'nestedDataListInMap', 'json', NULL),
    ('object_with_object', 'nestedDataMap', 'json', NULL),
    ('object_with_sparse_vector', 'sparseVector', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorNullable', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnsw', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnswWithParams', 'sparsevec', 512),
    ('object_with_uuid', 'uuid', 'uuid', NULL),
    ('object_with_uuid', 'uuidNullable', 'uuid', NULL),
    ('object_with_vector', 'vector', 'vector', 512),
    ('object_with_vector', 'vectorNullable', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnsw', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnswWithParams', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflat', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflatWithParams', 'vector', 512),
    ('order_uuid', 'id', 'uuid', NULL),
    ('player_uuid', 'id', 'uuid', NULL),
    ('server_only_changed_id_field_class', 'id', 'uuid', NULL),
    ('simple_date_time', 'dateTime', 'timestampWithoutTimeZone', NULL),
    ('student_uuid', 'id', 'uuid', NULL),
    ('team_int', 'arenaId', 'uuid', NULL),
    ('types', 'aBool', 'boolean', NULL),
    ('types', 'aDateTime', 'timestampWithoutTimeZone', NULL),
    ('types', 'aUuid', 'uuid', NULL),
    ('types', 'aVector', 'vector', 3),
    ('types', 'aHalfVector', 'halfvec', 3),
    ('types', 'aSparseVector', 'sparsevec', 3),
    ('types', 'aBit', 'bit', 3),
    ('types', 'aList', 'json', NULL),
    ('types', 'aMap', 'json', NULL),
    ('types', 'aSet', 'json', NULL),
    ('types', 'aRecord', 'json', NULL),
    ('uuid_default', 'uuidDefaultRandom', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomV7', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomNull', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStr', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStrNull', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultModel', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultModelAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandom', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomV7', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomNull', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStr', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStrNull', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandom', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandomV7', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistStr', 'uuid', NULL),
    ('serverpod_cloud_storage', 'addedTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'verified', 'boolean', NULL),
    ('serverpod_cloud_storage_direct_upload', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'scheduling', 'json', NULL),
    ('serverpod_future_call_claim', 'lastHeartbeatTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_connection_info', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'isHealthy', 'boolean', NULL),
    ('serverpod_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_message_log', 'slow', 'boolean', NULL),
    ('serverpod_migrations', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_query_log', 'slow', 'boolean', NULL),
    ('serverpod_reactive_db_call', 'createdAt', 'timestampWithoutTimeZone', NULL),
    ('serverpod_runtime_settings', 'logSettings', 'json', NULL),
    ('serverpod_runtime_settings', 'logSettingsOverrides', 'json', NULL),
    ('serverpod_runtime_settings', 'logServiceCalls', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logMalformedCalls', 'boolean', NULL),
    ('serverpod_session_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_session_log', 'slow', 'boolean', NULL),
    ('serverpod_session_log', 'isOpen', 'boolean', NULL),
    ('serverpod_session_log', 'touched', 'timestampWithoutTimeZone', NULL);

--
-- MIGRATION VERSION FOR serverpod_test_sqlite
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_sqlite', '20260423151716195', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423151716195', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260423151529622', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423151529622', "timestamp" = (unixepoch('now', 'subsecond') * 1000);


COMMIT;
