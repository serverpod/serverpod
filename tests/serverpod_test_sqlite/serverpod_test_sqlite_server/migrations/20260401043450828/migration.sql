BEGIN;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "arena" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "arena_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default" (
    "id" INTEGER PRIMARY KEY,
    "bigintDefaultStr" TEXT NOT NULL DEFAULT ('-1234567890123456789099999999'),
    "bigintDefaultStrNull" TEXT DEFAULT ('1234567890123456789099999999')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('1'),
    "bigIntDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('12345678901234567890'),
    "bigIntDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('-1234567890123456789099999999')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_model" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultModelStr" TEXT NOT NULL,
    "bigIntDefaultModelStrNull" TEXT
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "bigIntDefaultPersistStr" TEXT DEFAULT ('1234567890123456789099999999')
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "book" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultTrue" INTEGER NOT NULL DEFAULT (1),
    "boolDefaultFalse" INTEGER NOT NULL DEFAULT (0),
    "boolDefaultNullFalse" INTEGER DEFAULT (0)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (1),
    "boolDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (0),
    "boolDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (0)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_model" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultModelTrue" INTEGER NOT NULL,
    "boolDefaultModelFalse" INTEGER NOT NULL,
    "boolDefaultModelNullFalse" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "boolDefaultPersistTrue" INTEGER DEFAULT (1),
    "boolDefaultPersistFalse" INTEGER DEFAULT (0)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cat" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "motherId" INTEGER,
    CONSTRAINT "cat_fk_0" FOREIGN KEY ("motherId") REFERENCES "cat" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "chapter" (
    "id" INTEGER PRIMARY KEY,
    "title" TEXT NOT NULL,
    "_bookChaptersBookId" INTEGER,
    CONSTRAINT "chapter_fk_0" FOREIGN KEY ("_bookChaptersBookId") REFERENCES "book" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_table_explicit_column" (
    "id" INTEGER PRIMARY KEY,
    "non_table_parent_field" TEXT NOT NULL,
    "child_field" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "city" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "city_with_long_table_name_that_is_still_valid" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "orderId" INTEGER NOT NULL,
    CONSTRAINT "comment_fk_0" FOREIGN KEY ("orderId") REFERENCES "order" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment_int" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "orderId" BLOB NOT NULL,
    CONSTRAINT "comment_int_fk_0" FOREIGN KEY ("orderId") REFERENCES "order_uuid" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "townId" INTEGER NOT NULL,
    CONSTRAINT "company_fk_0" FOREIGN KEY ("townId") REFERENCES "town" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL,
    "townId" INTEGER NOT NULL,
    CONSTRAINT "company_uuid_fk_0" FOREIGN KEY ("townId") REFERENCES "town_int" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "course" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "course_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultNow" INTEGER NOT NULL DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "dateTimeDefaultStr" INTEGER NOT NULL DEFAULT (1716588000000),
    "dateTimeDefaultStrNull" INTEGER DEFAULT (1716588000000)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (1714600800000),
    "dateTimeDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (1715378400000),
    "dateTimeDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (1715378400000)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_model" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultModelNow" INTEGER NOT NULL,
    "dateTimeDefaultModelStr" INTEGER NOT NULL,
    "dateTimeDefaultModelStrNull" INTEGER
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "dateTimeDefaultPersistNow" INTEGER DEFAULT (CAST(unixepoch('subsecond') * 1000 AS INTEGER)),
    "dateTimeDefaultPersistStr" INTEGER DEFAULT (1715378400000)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "department" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefault" REAL NOT NULL DEFAULT (10.5),
    "doubleDefaultNull" REAL DEFAULT (20.5)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultAndDefaultModel" REAL NOT NULL DEFAULT (10.5),
    "doubleDefaultAndDefaultPersist" REAL NOT NULL DEFAULT (20.5),
    "doubleDefaultModelAndDefaultPersist" REAL NOT NULL DEFAULT (20.5)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_model" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultModel" REAL NOT NULL,
    "doubleDefaultModelNull" REAL NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "doubleDefaultPersist" REAL DEFAULT (10.5)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default" (
    "id" INTEGER PRIMARY KEY,
    "durationDefault" INTEGER NOT NULL DEFAULT (94230100),
    "durationDefaultNull" INTEGER DEFAULT (177640100)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (94230100),
    "durationDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (177640100),
    "durationDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (177640100)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_model" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultModel" INTEGER NOT NULL,
    "durationDefaultModelNull" INTEGER
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "durationDefaultPersist" INTEGER DEFAULT (94230100)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "employee" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "fk_employee_department_id" INTEGER NOT NULL,
    CONSTRAINT "employee_fk_0" FOREIGN KEY ("fk_employee_department_id") REFERENCES "department" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_relation_item" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_relationEmptyModelItemsRelationEmptyModelId" INTEGER,
    CONSTRAINT "empty_model_relation_item_fk_0" FOREIGN KEY ("_relationEmptyModelItemsRelationEmptyModelId") REFERENCES "relation_empty_model" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_with_table" (
    "id" INTEGER PRIMARY KEY
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "enum_default" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefault" TEXT NOT NULL DEFAULT ('byName1'),
    "byNameEnumDefaultNull" TEXT DEFAULT ('byName2'),
    "byIndexEnumDefault" INTEGER NOT NULL DEFAULT (0),
    "byIndexEnumDefaultNull" INTEGER DEFAULT (1)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "enum_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('byName1'),
    "byNameEnumDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('byName2'),
    "byNameEnumDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('byName2')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "enum_default_model" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultModel" TEXT NOT NULL,
    "byNameEnumDefaultModelNull" TEXT,
    "byIndexEnumDefaultModel" INTEGER NOT NULL,
    "byIndexEnumDefaultModelNull" INTEGER
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "enum_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "byNameEnumDefaultPersist" TEXT DEFAULT ('byName1'),
    "byIndexEnumDefaultPersist" INTEGER DEFAULT (0)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default" (
    "id" INTEGER PRIMARY KEY,
    "intDefault" INTEGER NOT NULL DEFAULT (10),
    "intDefaultNull" INTEGER DEFAULT (20)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultAndDefaultModel" INTEGER NOT NULL DEFAULT (10),
    "intDefaultAndDefaultPersist" INTEGER NOT NULL DEFAULT (20),
    "intDefaultModelAndDefaultPersist" INTEGER NOT NULL DEFAULT (20)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_model" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultModel" INTEGER NOT NULL,
    "intDefaultModelNull" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "intDefaultPersist" INTEGER DEFAULT (10)
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "long_implicit_id_field" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id" INTEGER,
    CONSTRAINT "long_implicit_id_field_fk_0" FOREIGN KEY ("_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id") REFERENCES "long_implicit_id_field_collection" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "long_implicit_id_field_collection" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "model_with_required_field" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "email" TEXT,
    "phone" TEXT
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "modified_column_name" (
    "id" INTEGER PRIMARY KEY,
    "originalColumn" TEXT NOT NULL,
    "modified_column" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "multiple_max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1" TEXT NOT NULL,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2" TEXT NOT NULL,
    "_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId" INTEGER,
    CONSTRAINT "multiple_max_field_name_fk_0" FOREIGN KEY ("_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId") REFERENCES "relation_to_multiple_max_field_name" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_field_persist" (
    "id" INTEGER PRIMARY KEY,
    "normal" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_field_scopes" (
    "id" INTEGER PRIMARY KEY,
    "normal" TEXT NOT NULL,
    "database" TEXT
) STRICT;

--
-- ACTION CREATE TABLE
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

-- Indexes

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_bytedata" (
    "id" INTEGER PRIMARY KEY,
    "byteData" BLOB NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_duration" (
    "id" INTEGER PRIMARY KEY,
    "duration" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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

-- Indexes

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_index" (
    "id" INTEGER PRIMARY KEY,
    "indexed" INTEGER NOT NULL,
    "indexed2" INTEGER NOT NULL
) STRICT;

-- Indexes

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_parent" (
    "id" INTEGER PRIMARY KEY,
    "other" INTEGER NOT NULL,
    CONSTRAINT "object_with_parent_fk_0" FOREIGN KEY ("other") REFERENCES "object_field_scopes" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_self_parent" (
    "id" INTEGER PRIMARY KEY,
    "other" INTEGER,
    CONSTRAINT "object_with_self_parent_fk_0" FOREIGN KEY ("other") REFERENCES "object_with_self_parent" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_sparse_vector" (
    "id" INTEGER PRIMARY KEY,
    "sparseVector" TEXT NOT NULL,
    "sparseVectorNullable" TEXT,
    "sparseVectorIndexedHnsw" TEXT NOT NULL,
    "sparseVectorIndexedHnswWithParams" TEXT NOT NULL
) STRICT;

-- Indexes

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_uuid" (
    "id" INTEGER PRIMARY KEY,
    "uuid" BLOB NOT NULL,
    "uuidNullable" BLOB
) STRICT;

--
-- ACTION CREATE TABLE
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

-- Indexes

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order" (
    "id" INTEGER PRIMARY KEY,
    "description" TEXT NOT NULL,
    "customerId" INTEGER NOT NULL,
    CONSTRAINT "order_fk_0" FOREIGN KEY ("customerId") REFERENCES "customer" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "description" TEXT NOT NULL,
    "customerId" INTEGER NOT NULL,
    CONSTRAINT "order_uuid_fk_0" FOREIGN KEY ("customerId") REFERENCES "customer_int" ("id") ON DELETE CASCADE ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "cityId" INTEGER,
    CONSTRAINT "organization_fk_0" FOREIGN KEY ("cityId") REFERENCES "city" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "organization_with_long_table_name_that_is_still_valid" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "cityId" INTEGER,
    CONSTRAINT "organization_with_long_table_name_that_is_still_valid_fk_0" FOREIGN KEY ("cityId") REFERENCES "city_with_long_table_name_that_is_still_valid" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "player" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "teamId" INTEGER,
    CONSTRAINT "player_fk_0" FOREIGN KEY ("teamId") REFERENCES "team" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL,
    "teamId" INTEGER,
    CONSTRAINT "player_uuid_fk_0" FOREIGN KEY ("teamId") REFERENCES "team_int" ("id") ON DELETE SET NULL ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "related_unique_data" (
    "id" INTEGER PRIMARY KEY,
    "uniqueDataId" INTEGER NOT NULL,
    "number" INTEGER NOT NULL,
    CONSTRAINT "related_unique_data_fk_0" FOREIGN KEY ("uniqueDataId") REFERENCES "unique_data" ("id") ON DELETE RESTRICT ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "relation_empty_model" (
    "id" INTEGER PRIMARY KEY
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "relation_to_multiple_max_field_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "server_only_changed_id_field_class" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15)))
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "service" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "description" TEXT
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_data" (
    "id" INTEGER PRIMARY KEY,
    "num" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_date_time" (
    "id" INTEGER PRIMARY KEY,
    "dateTime" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default" (
    "id" INTEGER PRIMARY KEY,
    "stringDefault" TEXT NOT NULL DEFAULT ('This is a default value'),
    "stringDefaultNull" TEXT DEFAULT ('This is a default null value')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "stringDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('This is a default value'),
    "stringDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('This is a default persist value'),
    "stringDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('This is a default persist value')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default_model" (
    "id" INTEGER PRIMARY KEY,
    "stringDefaultModel" TEXT NOT NULL,
    "stringDefaultModelNull" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "student" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student_uuid" (
    "id" BLOB PRIMARY KEY DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "table_with_explicit_column_names" (
    "id" INTEGER PRIMARY KEY,
    "user_name" TEXT NOT NULL,
    "user_description" TEXT DEFAULT ('Just some information')
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "town" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "mayorId" INTEGER,
    CONSTRAINT "town_fk_0" FOREIGN KEY ("mayorId") REFERENCES "citizen" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "town_int" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "mayorId" INTEGER,
    CONSTRAINT "town_int_fk_0" FOREIGN KEY ("mayorId") REFERENCES "citizen_int" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "unique_data" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL,
    "email" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unique_data_with_non_persist" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL,
    "email" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "unique_email_idx" ON "unique_data_with_non_persist" ("email");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default" (
    "id" INTEGER PRIMARY KEY,
    "uriDefault" TEXT NOT NULL DEFAULT ('https://serverpod.dev/default'),
    "uriDefaultNull" TEXT DEFAULT ('https://serverpod.dev/default')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultAndDefaultModel" TEXT NOT NULL DEFAULT ('https://serverpod.dev/default'),
    "uriDefaultAndDefaultPersist" TEXT NOT NULL DEFAULT ('https://serverpod.dev/defaultPersist'),
    "uriDefaultModelAndDefaultPersist" TEXT NOT NULL DEFAULT ('https://serverpod.dev/defaultPersist')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_model" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultModel" TEXT NOT NULL,
    "uriDefaultModelNull" TEXT
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uri_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "uriDefaultPersist" TEXT DEFAULT ('https://serverpod.dev/')
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId" INTEGER,
    CONSTRAINT "user_note_fk_0" FOREIGN KEY ("_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId") REFERENCES "user_note_collections" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_collection_with_a_long_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_collections" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "user_note_with_a_long_name" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId" INTEGER,
    CONSTRAINT "user_note_with_a_long_name_fk_0" FOREIGN KEY ("_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId") REFERENCES "user_note_collection_with_a_long_name" ("id") ON DELETE NO ACTION ON UPDATE NO ACTION
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_mix" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultAndDefaultModel" BLOB NOT NULL DEFAULT (X'3f2504e04f8911d39a0c0305e82c3301'),
    "uuidDefaultAndDefaultPersist" BLOB NOT NULL DEFAULT (X'9e107d9d372b4d979b272f0907d0b1d4'),
    "uuidDefaultModelAndDefaultPersist" BLOB NOT NULL DEFAULT (X'f47ac10b58cc4372a5670e02b2c3d479')
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_persist" (
    "id" INTEGER PRIMARY KEY,
    "uuidDefaultPersistRandom" BLOB DEFAULT (unhex(hex(randomblob(6)) || '4' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultPersistRandomV7" BLOB DEFAULT (unhex(printf('%012x', CAST(unixepoch('now', 'subsecond') * 1000 AS INTEGER)) || '7' || substr(hex(randomblob(2)), 2, 3) || substr('89AB', 1 + (abs(random()) % 4), 1) || substr(hex(randomblob(8)), 2, 15))),
    "uuidDefaultPersistStr" BLOB DEFAULT (X'550e8400e29b41d4a716446655440000')
) STRICT;

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_future_call" (
    "id" INTEGER PRIMARY KEY,
    "name" TEXT NOT NULL,
    "time" INTEGER NOT NULL,
    "serializedObject" TEXT,
    "serverId" TEXT NOT NULL,
    "identifier" TEXT
) STRICT;

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" ("identifier");

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" ("sessionLogId");

--
-- ACTION CREATE TABLE
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

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_method" (
    "id" INTEGER PRIMARY KEY,
    "endpoint" TEXT NOT NULL,
    "method" TEXT NOT NULL
) STRICT;

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" ("endpoint", "method");

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" ("sessionLogId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" INTEGER PRIMARY KEY,
    "number" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" INTEGER PRIMARY KEY,
    "logSettings" TEXT NOT NULL,
    "logSettingsOverrides" TEXT NOT NULL,
    "logServiceCalls" INTEGER NOT NULL,
    "logMalformedCalls" INTEGER NOT NULL
) STRICT;

--
-- ACTION CREATE TABLE
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
    ('address', 'id', 'bigint', NULL),
    ('address', 'street', 'text', NULL),
    ('address', 'inhabitantId', 'bigint', NULL),
    ('address_uuid', 'id', 'uuid', NULL),
    ('address_uuid', 'street', 'text', NULL),
    ('address_uuid', 'inhabitantId', 'bigint', NULL),
    ('arena', 'id', 'bigint', NULL),
    ('arena', 'name', 'text', NULL),
    ('arena_uuid', 'id', 'uuid', NULL),
    ('arena_uuid', 'name', 'text', NULL),
    ('bigint_default', 'id', 'bigint', NULL),
    ('bigint_default', 'bigintDefaultStr', 'text', NULL),
    ('bigint_default', 'bigintDefaultStrNull', 'text', NULL),
    ('bigint_default_mix', 'id', 'bigint', NULL),
    ('bigint_default_mix', 'bigIntDefaultAndDefaultModel', 'text', NULL),
    ('bigint_default_mix', 'bigIntDefaultAndDefaultPersist', 'text', NULL),
    ('bigint_default_mix', 'bigIntDefaultModelAndDefaultPersist', 'text', NULL),
    ('bigint_default_model', 'id', 'bigint', NULL),
    ('bigint_default_model', 'bigIntDefaultModelStr', 'text', NULL),
    ('bigint_default_model', 'bigIntDefaultModelStrNull', 'text', NULL),
    ('bigint_default_persist', 'id', 'bigint', NULL),
    ('bigint_default_persist', 'bigIntDefaultPersistStr', 'text', NULL),
    ('blocking', 'id', 'bigint', NULL),
    ('blocking', 'blockedId', 'bigint', NULL),
    ('blocking', 'blockedById', 'bigint', NULL),
    ('book', 'id', 'bigint', NULL),
    ('book', 'title', 'text', NULL),
    ('bool_default', 'id', 'bigint', NULL),
    ('bool_default', 'boolDefaultTrue', 'boolean', NULL),
    ('bool_default', 'boolDefaultFalse', 'boolean', NULL),
    ('bool_default', 'boolDefaultNullFalse', 'boolean', NULL),
    ('bool_default_mix', 'id', 'bigint', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultModel', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultAndDefaultPersist', 'boolean', NULL),
    ('bool_default_mix', 'boolDefaultModelAndDefaultPersist', 'boolean', NULL),
    ('bool_default_model', 'id', 'bigint', NULL),
    ('bool_default_model', 'boolDefaultModelTrue', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelFalse', 'boolean', NULL),
    ('bool_default_model', 'boolDefaultModelNullFalse', 'boolean', NULL),
    ('bool_default_persist', 'id', 'bigint', NULL),
    ('bool_default_persist', 'boolDefaultPersistTrue', 'boolean', NULL),
    ('bool_default_persist', 'boolDefaultPersistFalse', 'boolean', NULL),
    ('cat', 'id', 'bigint', NULL),
    ('cat', 'name', 'text', NULL),
    ('cat', 'motherId', 'bigint', NULL),
    ('changed_id_type_self', 'id', 'uuid', NULL),
    ('changed_id_type_self', 'name', 'text', NULL),
    ('changed_id_type_self', 'nextId', 'uuid', NULL),
    ('changed_id_type_self', 'parentId', 'uuid', NULL),
    ('chapter', 'id', 'bigint', NULL),
    ('chapter', 'title', 'text', NULL),
    ('chapter', '_bookChaptersBookId', 'bigint', NULL),
    ('child_table_explicit_column', 'id', 'bigint', NULL),
    ('child_table_explicit_column', 'non_table_parent_field', 'text', NULL),
    ('child_table_explicit_column', 'child_field', 'text', NULL),
    ('citizen', 'id', 'bigint', NULL),
    ('citizen', 'name', 'text', NULL),
    ('citizen', 'companyId', 'bigint', NULL),
    ('citizen', 'oldCompanyId', 'bigint', NULL),
    ('citizen_int', 'id', 'bigint', NULL),
    ('citizen_int', 'name', 'text', NULL),
    ('citizen_int', 'companyId', 'uuid', NULL),
    ('citizen_int', 'oldCompanyId', 'uuid', NULL),
    ('city', 'id', 'bigint', NULL),
    ('city', 'name', 'text', NULL),
    ('city_with_long_table_name_that_is_still_valid', 'id', 'bigint', NULL),
    ('city_with_long_table_name_that_is_still_valid', 'name', 'text', NULL),
    ('comment', 'id', 'bigint', NULL),
    ('comment', 'description', 'text', NULL),
    ('comment', 'orderId', 'bigint', NULL),
    ('comment_int', 'id', 'bigint', NULL),
    ('comment_int', 'description', 'text', NULL),
    ('comment_int', 'orderId', 'uuid', NULL),
    ('company', 'id', 'bigint', NULL),
    ('company', 'name', 'text', NULL),
    ('company', 'townId', 'bigint', NULL),
    ('company_uuid', 'id', 'uuid', NULL),
    ('company_uuid', 'name', 'text', NULL),
    ('company_uuid', 'townId', 'bigint', NULL),
    ('contractor', 'id', 'bigint', NULL),
    ('contractor', 'name', 'text', NULL),
    ('contractor', 'fk_contractor_service_id', 'bigint', NULL),
    ('course', 'id', 'bigint', NULL),
    ('course', 'name', 'text', NULL),
    ('course_uuid', 'id', 'uuid', NULL),
    ('course_uuid', 'name', 'text', NULL),
    ('customer', 'id', 'bigint', NULL),
    ('customer', 'name', 'text', NULL),
    ('customer_int', 'id', 'bigint', NULL),
    ('customer_int', 'name', 'text', NULL),
    ('datetime_default', 'id', 'bigint', NULL),
    ('datetime_default', 'dateTimeDefaultNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default', 'dateTimeDefaultStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'id', 'bigint', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultModel', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_mix', 'dateTimeDefaultModelAndDefaultPersist', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'id', 'bigint', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStr', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_model', 'dateTimeDefaultModelStrNull', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'id', 'bigint', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistNow', 'timestampWithoutTimeZone', NULL),
    ('datetime_default_persist', 'dateTimeDefaultPersistStr', 'timestampWithoutTimeZone', NULL),
    ('department', 'id', 'bigint', NULL),
    ('department', 'name', 'text', NULL),
    ('double_default', 'id', 'bigint', NULL),
    ('double_default', 'doubleDefault', 'doublePrecision', NULL),
    ('double_default', 'doubleDefaultNull', 'doublePrecision', NULL),
    ('double_default_mix', 'id', 'bigint', NULL),
    ('double_default_mix', 'doubleDefaultAndDefaultModel', 'doublePrecision', NULL),
    ('double_default_mix', 'doubleDefaultAndDefaultPersist', 'doublePrecision', NULL),
    ('double_default_mix', 'doubleDefaultModelAndDefaultPersist', 'doublePrecision', NULL),
    ('double_default_model', 'id', 'bigint', NULL),
    ('double_default_model', 'doubleDefaultModel', 'doublePrecision', NULL),
    ('double_default_model', 'doubleDefaultModelNull', 'doublePrecision', NULL),
    ('double_default_persist', 'id', 'bigint', NULL),
    ('double_default_persist', 'doubleDefaultPersist', 'doublePrecision', NULL),
    ('duration_default', 'id', 'bigint', NULL),
    ('duration_default', 'durationDefault', 'bigint', NULL),
    ('duration_default', 'durationDefaultNull', 'bigint', NULL),
    ('duration_default_mix', 'id', 'bigint', NULL),
    ('duration_default_mix', 'durationDefaultAndDefaultModel', 'bigint', NULL),
    ('duration_default_mix', 'durationDefaultAndDefaultPersist', 'bigint', NULL),
    ('duration_default_mix', 'durationDefaultModelAndDefaultPersist', 'bigint', NULL),
    ('duration_default_model', 'id', 'bigint', NULL),
    ('duration_default_model', 'durationDefaultModel', 'bigint', NULL),
    ('duration_default_model', 'durationDefaultModelNull', 'bigint', NULL),
    ('duration_default_persist', 'id', 'bigint', NULL),
    ('duration_default_persist', 'durationDefaultPersist', 'bigint', NULL),
    ('employee', 'id', 'bigint', NULL),
    ('employee', 'name', 'text', NULL),
    ('employee', 'fk_employee_department_id', 'bigint', NULL),
    ('empty_model_relation_item', 'id', 'bigint', NULL),
    ('empty_model_relation_item', 'name', 'text', NULL),
    ('empty_model_relation_item', '_relationEmptyModelItemsRelationEmptyModelId', 'bigint', NULL),
    ('empty_model_with_table', 'id', 'bigint', NULL),
    ('enrollment', 'id', 'bigint', NULL),
    ('enrollment', 'studentId', 'bigint', NULL),
    ('enrollment', 'courseId', 'bigint', NULL),
    ('enrollment_int', 'id', 'bigint', NULL),
    ('enrollment_int', 'studentId', 'uuid', NULL),
    ('enrollment_int', 'courseId', 'uuid', NULL),
    ('enum_default', 'id', 'bigint', NULL),
    ('enum_default', 'byNameEnumDefault', 'text', NULL),
    ('enum_default', 'byNameEnumDefaultNull', 'text', NULL),
    ('enum_default', 'byIndexEnumDefault', 'bigint', NULL),
    ('enum_default', 'byIndexEnumDefaultNull', 'bigint', NULL),
    ('enum_default_mix', 'id', 'bigint', NULL),
    ('enum_default_mix', 'byNameEnumDefaultAndDefaultModel', 'text', NULL),
    ('enum_default_mix', 'byNameEnumDefaultAndDefaultPersist', 'text', NULL),
    ('enum_default_mix', 'byNameEnumDefaultModelAndDefaultPersist', 'text', NULL),
    ('enum_default_model', 'id', 'bigint', NULL),
    ('enum_default_model', 'byNameEnumDefaultModel', 'text', NULL),
    ('enum_default_model', 'byNameEnumDefaultModelNull', 'text', NULL),
    ('enum_default_model', 'byIndexEnumDefaultModel', 'bigint', NULL),
    ('enum_default_model', 'byIndexEnumDefaultModelNull', 'bigint', NULL),
    ('enum_default_persist', 'id', 'bigint', NULL),
    ('enum_default_persist', 'byNameEnumDefaultPersist', 'text', NULL),
    ('enum_default_persist', 'byIndexEnumDefaultPersist', 'bigint', NULL),
    ('int_default', 'id', 'bigint', NULL),
    ('int_default', 'intDefault', 'bigint', NULL),
    ('int_default', 'intDefaultNull', 'bigint', NULL),
    ('int_default_mix', 'id', 'bigint', NULL),
    ('int_default_mix', 'intDefaultAndDefaultModel', 'bigint', NULL),
    ('int_default_mix', 'intDefaultAndDefaultPersist', 'bigint', NULL),
    ('int_default_mix', 'intDefaultModelAndDefaultPersist', 'bigint', NULL),
    ('int_default_model', 'id', 'bigint', NULL),
    ('int_default_model', 'intDefaultModel', 'bigint', NULL),
    ('int_default_model', 'intDefaultModelNull', 'bigint', NULL),
    ('int_default_persist', 'id', 'bigint', NULL),
    ('int_default_persist', 'intDefaultPersist', 'bigint', NULL),
    ('long_implicit_id_field', 'id', 'bigint', NULL),
    ('long_implicit_id_field', 'name', 'text', NULL),
    ('long_implicit_id_field', '_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id', 'bigint', NULL),
    ('long_implicit_id_field_collection', 'id', 'bigint', NULL),
    ('long_implicit_id_field_collection', 'name', 'text', NULL),
    ('max_field_name', 'id', 'bigint', NULL),
    ('max_field_name', 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo', 'text', NULL),
    ('member', 'id', 'bigint', NULL),
    ('member', 'name', 'text', NULL),
    ('model_with_required_field', 'id', 'bigint', NULL),
    ('model_with_required_field', 'name', 'text', NULL),
    ('model_with_required_field', 'email', 'text', NULL),
    ('model_with_required_field', 'phone', 'text', NULL),
    ('modified_column_name', 'id', 'bigint', NULL),
    ('modified_column_name', 'originalColumn', 'text', NULL),
    ('modified_column_name', 'modified_column', 'text', NULL),
    ('multiple_max_field_name', 'id', 'bigint', NULL),
    ('multiple_max_field_name', 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1', 'text', NULL),
    ('multiple_max_field_name', 'thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2', 'text', NULL),
    ('multiple_max_field_name', '_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId', 'bigint', NULL),
    ('object_field_persist', 'id', 'bigint', NULL),
    ('object_field_persist', 'normal', 'text', NULL),
    ('object_field_scopes', 'id', 'bigint', NULL),
    ('object_field_scopes', 'normal', 'text', NULL),
    ('object_field_scopes', 'database', 'text', NULL),
    ('object_with_bit', 'id', 'bigint', NULL),
    ('object_with_bit', 'bit', 'bit', 512),
    ('object_with_bit', 'bitNullable', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnsw', 'bit', 512),
    ('object_with_bit', 'bitIndexedHnswWithParams', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflat', 'bit', 512),
    ('object_with_bit', 'bitIndexedIvfflatWithParams', 'bit', 512),
    ('object_with_bytedata', 'id', 'bigint', NULL),
    ('object_with_bytedata', 'byteData', 'bytea', NULL),
    ('object_with_duration', 'id', 'bigint', NULL),
    ('object_with_duration', 'duration', 'bigint', NULL),
    ('object_with_enum', 'id', 'bigint', NULL),
    ('object_with_enum', 'testEnum', 'bigint', NULL),
    ('object_with_enum', 'nullableEnum', 'bigint', NULL),
    ('object_with_enum', 'enumList', 'json', NULL),
    ('object_with_enum', 'nullableEnumList', 'json', NULL),
    ('object_with_enum', 'enumListList', 'json', NULL),
    ('object_with_enum_enhanced', 'id', 'bigint', NULL),
    ('object_with_enum_enhanced', 'byIndex', 'bigint', NULL),
    ('object_with_enum_enhanced', 'nullableByIndex', 'bigint', NULL),
    ('object_with_enum_enhanced', 'byIndexList', 'json', NULL),
    ('object_with_enum_enhanced', 'byName', 'text', NULL),
    ('object_with_enum_enhanced', 'nullableByName', 'text', NULL),
    ('object_with_enum_enhanced', 'byNameList', 'json', NULL),
    ('object_with_half_vector', 'id', 'bigint', NULL),
    ('object_with_half_vector', 'halfVector', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorNullable', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnsw', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedHnswWithParams', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflat', 'halfvec', 512),
    ('object_with_half_vector', 'halfVectorIndexedIvfflatWithParams', 'halfvec', 512),
    ('object_with_index', 'id', 'bigint', NULL),
    ('object_with_index', 'indexed', 'bigint', NULL),
    ('object_with_index', 'indexed2', 'bigint', NULL),
    ('object_with_object', 'id', 'bigint', NULL),
    ('object_with_object', 'data', 'json', NULL),
    ('object_with_object', 'nullableData', 'json', NULL),
    ('object_with_object', 'dataList', 'json', NULL),
    ('object_with_object', 'nullableDataList', 'json', NULL),
    ('object_with_object', 'listWithNullableData', 'json', NULL),
    ('object_with_object', 'nullableListWithNullableData', 'json', NULL),
    ('object_with_object', 'nestedDataList', 'json', NULL),
    ('object_with_object', 'nestedDataListInMap', 'json', NULL),
    ('object_with_object', 'nestedDataMap', 'json', NULL),
    ('object_with_parent', 'id', 'bigint', NULL),
    ('object_with_parent', 'other', 'bigint', NULL),
    ('object_with_self_parent', 'id', 'bigint', NULL),
    ('object_with_self_parent', 'other', 'bigint', NULL),
    ('object_with_sparse_vector', 'id', 'bigint', NULL),
    ('object_with_sparse_vector', 'sparseVector', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorNullable', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnsw', 'sparsevec', 512),
    ('object_with_sparse_vector', 'sparseVectorIndexedHnswWithParams', 'sparsevec', 512),
    ('object_with_uuid', 'id', 'bigint', NULL),
    ('object_with_uuid', 'uuid', 'uuid', NULL),
    ('object_with_uuid', 'uuidNullable', 'uuid', NULL),
    ('object_with_vector', 'id', 'bigint', NULL),
    ('object_with_vector', 'vector', 'vector', 512),
    ('object_with_vector', 'vectorNullable', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnsw', 'vector', 512),
    ('object_with_vector', 'vectorIndexedHnswWithParams', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflat', 'vector', 512),
    ('object_with_vector', 'vectorIndexedIvfflatWithParams', 'vector', 512),
    ('order', 'id', 'bigint', NULL),
    ('order', 'description', 'text', NULL),
    ('order', 'customerId', 'bigint', NULL),
    ('order_uuid', 'id', 'uuid', NULL),
    ('order_uuid', 'description', 'text', NULL),
    ('order_uuid', 'customerId', 'bigint', NULL),
    ('organization', 'id', 'bigint', NULL),
    ('organization', 'name', 'text', NULL),
    ('organization', 'cityId', 'bigint', NULL),
    ('organization_with_long_table_name_that_is_still_valid', 'id', 'bigint', NULL),
    ('organization_with_long_table_name_that_is_still_valid', 'name', 'text', NULL),
    ('organization_with_long_table_name_that_is_still_valid', 'cityId', 'bigint', NULL),
    ('person', 'id', 'bigint', NULL),
    ('person', 'name', 'text', NULL),
    ('person', 'organizationId', 'bigint', NULL),
    ('person', '_cityCitizensCityId', 'bigint', NULL),
    ('person_with_long_table_name_that_is_still_valid', 'id', 'bigint', NULL),
    ('person_with_long_table_name_that_is_still_valid', 'name', 'text', NULL),
    ('person_with_long_table_name_that_is_still_valid', 'organizationId', 'bigint', NULL),
    ('person_with_long_table_name_that_is_still_valid', '_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id', 'bigint', NULL),
    ('player', 'id', 'bigint', NULL),
    ('player', 'name', 'text', NULL),
    ('player', 'teamId', 'bigint', NULL),
    ('player_uuid', 'id', 'uuid', NULL),
    ('player_uuid', 'name', 'text', NULL),
    ('player_uuid', 'teamId', 'bigint', NULL),
    ('post', 'id', 'bigint', NULL),
    ('post', 'content', 'text', NULL),
    ('post', 'nextId', 'bigint', NULL),
    ('related_unique_data', 'id', 'bigint', NULL),
    ('related_unique_data', 'uniqueDataId', 'bigint', NULL),
    ('related_unique_data', 'number', 'bigint', NULL),
    ('relation_empty_model', 'id', 'bigint', NULL),
    ('relation_to_multiple_max_field_name', 'id', 'bigint', NULL),
    ('relation_to_multiple_max_field_name', 'name', 'text', NULL),
    ('server_only_changed_id_field_class', 'id', 'uuid', NULL),
    ('service', 'id', 'bigint', NULL),
    ('service', 'name', 'text', NULL),
    ('service', 'description', 'text', NULL),
    ('simple_data', 'id', 'bigint', NULL),
    ('simple_data', 'num', 'bigint', NULL),
    ('simple_date_time', 'id', 'bigint', NULL),
    ('simple_date_time', 'dateTime', 'timestampWithoutTimeZone', NULL),
    ('string_default', 'id', 'bigint', NULL),
    ('string_default', 'stringDefault', 'text', NULL),
    ('string_default', 'stringDefaultNull', 'text', NULL),
    ('string_default_mix', 'id', 'bigint', NULL),
    ('string_default_mix', 'stringDefaultAndDefaultModel', 'text', NULL),
    ('string_default_mix', 'stringDefaultAndDefaultPersist', 'text', NULL),
    ('string_default_mix', 'stringDefaultModelAndDefaultPersist', 'text', NULL),
    ('string_default_model', 'id', 'bigint', NULL),
    ('string_default_model', 'stringDefaultModel', 'text', NULL),
    ('string_default_model', 'stringDefaultModelNull', 'text', NULL),
    ('string_default_persist', 'id', 'bigint', NULL),
    ('string_default_persist', 'stringDefaultPersist', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistSingleQuoteWithOneDoubleQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistSingleQuoteWithTwoDoubleQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistDoubleQuoteWithOneSingleQuote', 'text', NULL),
    ('string_default_persist', 'stringDefaultPersistDoubleQuoteWithTwoSingleQuote', 'text', NULL),
    ('student', 'id', 'bigint', NULL),
    ('student', 'name', 'text', NULL),
    ('student_uuid', 'id', 'uuid', NULL),
    ('student_uuid', 'name', 'text', NULL),
    ('table_with_explicit_column_names', 'id', 'bigint', NULL),
    ('table_with_explicit_column_names', 'user_name', 'text', NULL),
    ('table_with_explicit_column_names', 'user_description', 'text', NULL),
    ('team', 'id', 'bigint', NULL),
    ('team', 'name', 'text', NULL),
    ('team', 'arenaId', 'bigint', NULL),
    ('team_int', 'id', 'bigint', NULL),
    ('team_int', 'name', 'text', NULL),
    ('team_int', 'arenaId', 'uuid', NULL),
    ('town', 'id', 'bigint', NULL),
    ('town', 'name', 'text', NULL),
    ('town', 'mayorId', 'bigint', NULL),
    ('town_int', 'id', 'bigint', NULL),
    ('town_int', 'name', 'text', NULL),
    ('town_int', 'mayorId', 'bigint', NULL),
    ('types', 'id', 'bigint', NULL),
    ('types', 'anInt', 'bigint', NULL),
    ('types', 'aBool', 'boolean', NULL),
    ('types', 'aDouble', 'doublePrecision', NULL),
    ('types', 'aDateTime', 'timestampWithoutTimeZone', NULL),
    ('types', 'aString', 'text', NULL),
    ('types', 'aByteData', 'bytea', NULL),
    ('types', 'aDuration', 'bigint', NULL),
    ('types', 'aUuid', 'uuid', NULL),
    ('types', 'aUri', 'text', NULL),
    ('types', 'aBigInt', 'text', NULL),
    ('types', 'aVector', 'vector', 3),
    ('types', 'aHalfVector', 'halfvec', 3),
    ('types', 'aSparseVector', 'sparsevec', 3),
    ('types', 'aBit', 'bit', 3),
    ('types', 'anEnum', 'bigint', NULL),
    ('types', 'aStringifiedEnum', 'text', NULL),
    ('types', 'aList', 'json', NULL),
    ('types', 'aMap', 'json', NULL),
    ('types', 'aSet', 'json', NULL),
    ('types', 'aRecord', 'json', NULL),
    ('unique_data', 'id', 'bigint', NULL),
    ('unique_data', 'number', 'bigint', NULL),
    ('unique_data', 'email', 'text', NULL),
    ('unique_data_with_non_persist', 'id', 'bigint', NULL),
    ('unique_data_with_non_persist', 'number', 'bigint', NULL),
    ('unique_data_with_non_persist', 'email', 'text', NULL),
    ('uri_default', 'id', 'bigint', NULL),
    ('uri_default', 'uriDefault', 'text', NULL),
    ('uri_default', 'uriDefaultNull', 'text', NULL),
    ('uri_default_mix', 'id', 'bigint', NULL),
    ('uri_default_mix', 'uriDefaultAndDefaultModel', 'text', NULL),
    ('uri_default_mix', 'uriDefaultAndDefaultPersist', 'text', NULL),
    ('uri_default_mix', 'uriDefaultModelAndDefaultPersist', 'text', NULL),
    ('uri_default_model', 'id', 'bigint', NULL),
    ('uri_default_model', 'uriDefaultModel', 'text', NULL),
    ('uri_default_model', 'uriDefaultModelNull', 'text', NULL),
    ('uri_default_persist', 'id', 'bigint', NULL),
    ('uri_default_persist', 'uriDefaultPersist', 'text', NULL),
    ('user_note', 'id', 'bigint', NULL),
    ('user_note', 'name', 'text', NULL),
    ('user_note', '_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId', 'bigint', NULL),
    ('user_note_collection_with_a_long_name', 'id', 'bigint', NULL),
    ('user_note_collection_with_a_long_name', 'name', 'text', NULL),
    ('user_note_collections', 'id', 'bigint', NULL),
    ('user_note_collections', 'name', 'text', NULL),
    ('user_note_with_a_long_name', 'id', 'bigint', NULL),
    ('user_note_with_a_long_name', 'name', 'text', NULL),
    ('user_note_with_a_long_name', '_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId', 'bigint', NULL),
    ('uuid_default', 'id', 'bigint', NULL),
    ('uuid_default', 'uuidDefaultRandom', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomV7', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultRandomNull', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStr', 'uuid', NULL),
    ('uuid_default', 'uuidDefaultStrNull', 'uuid', NULL),
    ('uuid_default_mix', 'id', 'bigint', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultModel', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_mix', 'uuidDefaultModelAndDefaultPersist', 'uuid', NULL),
    ('uuid_default_model', 'id', 'bigint', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandom', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomV7', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelRandomNull', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStr', 'uuid', NULL),
    ('uuid_default_model', 'uuidDefaultModelStrNull', 'uuid', NULL),
    ('uuid_default_persist', 'id', 'bigint', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandom', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistRandomV7', 'uuid', NULL),
    ('uuid_default_persist', 'uuidDefaultPersistStr', 'uuid', NULL),
    ('serverpod_cloud_storage', 'id', 'bigint', NULL),
    ('serverpod_cloud_storage', 'storageId', 'text', NULL),
    ('serverpod_cloud_storage', 'path', 'text', NULL),
    ('serverpod_cloud_storage', 'addedTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage', 'byteData', 'bytea', NULL),
    ('serverpod_cloud_storage', 'verified', 'boolean', NULL),
    ('serverpod_cloud_storage_direct_upload', 'id', 'bigint', NULL),
    ('serverpod_cloud_storage_direct_upload', 'storageId', 'text', NULL),
    ('serverpod_cloud_storage_direct_upload', 'path', 'text', NULL),
    ('serverpod_cloud_storage_direct_upload', 'expiration', 'timestampWithoutTimeZone', NULL),
    ('serverpod_cloud_storage_direct_upload', 'authKey', 'text', NULL),
    ('serverpod_future_call', 'id', 'bigint', NULL),
    ('serverpod_future_call', 'name', 'text', NULL),
    ('serverpod_future_call', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_future_call', 'serializedObject', 'text', NULL),
    ('serverpod_future_call', 'serverId', 'text', NULL),
    ('serverpod_future_call', 'identifier', 'text', NULL),
    ('serverpod_future_call_claim', 'id', 'bigint', NULL),
    ('serverpod_future_call_claim', 'futureCallId', 'bigint', NULL),
    ('serverpod_future_call_claim', 'lastHeartbeatTime', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_connection_info', 'id', 'bigint', NULL),
    ('serverpod_health_connection_info', 'serverId', 'text', NULL),
    ('serverpod_health_connection_info', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_connection_info', 'active', 'bigint', NULL),
    ('serverpod_health_connection_info', 'closing', 'bigint', NULL),
    ('serverpod_health_connection_info', 'idle', 'bigint', NULL),
    ('serverpod_health_connection_info', 'granularity', 'bigint', NULL),
    ('serverpod_health_metric', 'id', 'bigint', NULL),
    ('serverpod_health_metric', 'name', 'text', NULL),
    ('serverpod_health_metric', 'serverId', 'text', NULL),
    ('serverpod_health_metric', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_health_metric', 'isHealthy', 'boolean', NULL),
    ('serverpod_health_metric', 'value', 'doublePrecision', NULL),
    ('serverpod_health_metric', 'granularity', 'bigint', NULL),
    ('serverpod_log', 'id', 'bigint', NULL),
    ('serverpod_log', 'sessionLogId', 'bigint', NULL),
    ('serverpod_log', 'messageId', 'bigint', NULL),
    ('serverpod_log', 'reference', 'text', NULL),
    ('serverpod_log', 'serverId', 'text', NULL),
    ('serverpod_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_log', 'logLevel', 'bigint', NULL),
    ('serverpod_log', 'message', 'text', NULL),
    ('serverpod_log', 'error', 'text', NULL),
    ('serverpod_log', 'stackTrace', 'text', NULL),
    ('serverpod_log', 'order', 'bigint', NULL),
    ('serverpod_message_log', 'id', 'bigint', NULL),
    ('serverpod_message_log', 'sessionLogId', 'bigint', NULL),
    ('serverpod_message_log', 'serverId', 'text', NULL),
    ('serverpod_message_log', 'messageId', 'bigint', NULL),
    ('serverpod_message_log', 'endpoint', 'text', NULL),
    ('serverpod_message_log', 'messageName', 'text', NULL),
    ('serverpod_message_log', 'duration', 'doublePrecision', NULL),
    ('serverpod_message_log', 'error', 'text', NULL),
    ('serverpod_message_log', 'stackTrace', 'text', NULL),
    ('serverpod_message_log', 'slow', 'boolean', NULL),
    ('serverpod_message_log', 'order', 'bigint', NULL),
    ('serverpod_method', 'id', 'bigint', NULL),
    ('serverpod_method', 'endpoint', 'text', NULL),
    ('serverpod_method', 'method', 'text', NULL),
    ('serverpod_migrations', 'id', 'bigint', NULL),
    ('serverpod_migrations', 'module', 'text', NULL),
    ('serverpod_migrations', 'version', 'text', NULL),
    ('serverpod_migrations', 'timestamp', 'timestampWithoutTimeZone', NULL),
    ('serverpod_query_log', 'id', 'bigint', NULL),
    ('serverpod_query_log', 'serverId', 'text', NULL),
    ('serverpod_query_log', 'sessionLogId', 'bigint', NULL),
    ('serverpod_query_log', 'messageId', 'bigint', NULL),
    ('serverpod_query_log', 'query', 'text', NULL),
    ('serverpod_query_log', 'duration', 'doublePrecision', NULL),
    ('serverpod_query_log', 'numRows', 'bigint', NULL),
    ('serverpod_query_log', 'error', 'text', NULL),
    ('serverpod_query_log', 'stackTrace', 'text', NULL),
    ('serverpod_query_log', 'slow', 'boolean', NULL),
    ('serverpod_query_log', 'order', 'bigint', NULL),
    ('serverpod_readwrite_test', 'id', 'bigint', NULL),
    ('serverpod_readwrite_test', 'number', 'bigint', NULL),
    ('serverpod_runtime_settings', 'id', 'bigint', NULL),
    ('serverpod_runtime_settings', 'logSettings', 'json', NULL),
    ('serverpod_runtime_settings', 'logSettingsOverrides', 'json', NULL),
    ('serverpod_runtime_settings', 'logServiceCalls', 'boolean', NULL),
    ('serverpod_runtime_settings', 'logMalformedCalls', 'boolean', NULL),
    ('serverpod_session_log', 'id', 'bigint', NULL),
    ('serverpod_session_log', 'serverId', 'text', NULL),
    ('serverpod_session_log', 'time', 'timestampWithoutTimeZone', NULL),
    ('serverpod_session_log', 'module', 'text', NULL),
    ('serverpod_session_log', 'endpoint', 'text', NULL),
    ('serverpod_session_log', 'method', 'text', NULL),
    ('serverpod_session_log', 'duration', 'doublePrecision', NULL),
    ('serverpod_session_log', 'numQueries', 'bigint', NULL),
    ('serverpod_session_log', 'slow', 'boolean', NULL),
    ('serverpod_session_log', 'error', 'text', NULL),
    ('serverpod_session_log', 'stackTrace', 'text', NULL),
    ('serverpod_session_log', 'authenticatedUserId', 'bigint', NULL),
    ('serverpod_session_log', 'userId', 'text', NULL),
    ('serverpod_session_log', 'isOpen', 'boolean', NULL),
    ('serverpod_session_log', 'touched', 'timestampWithoutTimeZone', NULL);

--
-- MIGRATION VERSION FOR serverpod_test_sqlite
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_sqlite', '20260401043450828', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260401043450828', "timestamp" = (unixepoch('now', 'subsecond') * 1000);

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260324085808546', (unixepoch('now', 'subsecond') * 1000))
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260324085808546', "timestamp" = (unixepoch('now', 'subsecond') * 1000);


COMMIT;
