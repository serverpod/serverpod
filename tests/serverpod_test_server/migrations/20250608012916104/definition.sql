BEGIN;

--
-- CREATE VECTOR EXTENSION IF AVAILABLE
--
DO $$
BEGIN
  IF EXISTS (SELECT 1 FROM pg_available_extensions WHERE name = 'vector') THEN
    EXECUTE 'CREATE EXTENSION IF NOT EXISTS vector';
  ELSE
    RAISE EXCEPTION 'Required extension "vector" is not available on this instance. Please install pgvector. For instructions, see https://docs.serverpod.dev/upgrading/upgrade-to-pgvector.';
  END IF;
END
$$;

--
-- Function: gen_random_uuid_v7()
-- Source: https://gist.github.com/kjmph/5bd772b2c2df145aa645b837da7eca74
-- License: MIT (copyright notice included on the generator source code).
--
create or replace function gen_random_uuid_v7()
returns uuid
as $$
begin
  -- use random v4 uuid as starting point (which has the same variant we need)
  -- then overlay timestamp
  -- then set version 7 by flipping the 2 and 1 bit in the version 4 string
  return encode(
    set_bit(
      set_bit(
        overlay(uuid_send(gen_random_uuid())
                placing substring(int8send(floor(extract(epoch from clock_timestamp()) * 1000)::bigint) from 3)
                from 1 for 6
        ),
        52, 1
      ),
      53, 1
    ),
    'hex')::uuid;
end
$$
language plpgsql
volatile;

--
-- Class Address as table address
--
CREATE TABLE "address" (
    "id" bigserial PRIMARY KEY,
    "street" text NOT NULL,
    "inhabitantId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "inhabitant_index_idx" ON "address" USING btree ("inhabitantId");

--
-- Class AddressUuid as table address_uuid
--
CREATE TABLE "address_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "street" text NOT NULL,
    "inhabitantId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "inhabitant_uuid_index_idx" ON "address_uuid" USING btree ("inhabitantId");

--
-- Class Arena as table arena
--
CREATE TABLE "arena" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class ArenaUuid as table arena_uuid
--
CREATE TABLE "arena_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL
);

--
-- Class BigIntDefault as table bigint_default
--
CREATE TABLE "bigint_default" (
    "id" bigserial PRIMARY KEY,
    "bigintDefaultStr" text NOT NULL DEFAULT '-1234567890123456789099999999'::text,
    "bigintDefaultStrNull" text DEFAULT '1234567890123456789099999999'::text
);

--
-- Class BigIntDefaultMix as table bigint_default_mix
--
CREATE TABLE "bigint_default_mix" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultAndDefaultModel" text NOT NULL DEFAULT '1'::text,
    "bigIntDefaultAndDefaultPersist" text NOT NULL DEFAULT '12345678901234567890'::text,
    "bigIntDefaultModelAndDefaultPersist" text NOT NULL DEFAULT '-1234567890123456789099999999'::text
);

--
-- Class BigIntDefaultModel as table bigint_default_model
--
CREATE TABLE "bigint_default_model" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultModelStr" text NOT NULL,
    "bigIntDefaultModelStrNull" text
);

--
-- Class BigIntDefaultPersist as table bigint_default_persist
--
CREATE TABLE "bigint_default_persist" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultPersistStr" text DEFAULT '1234567890123456789099999999'::text
);

--
-- Class Blocking as table blocking
--
CREATE TABLE "blocking" (
    "id" bigserial PRIMARY KEY,
    "blockedId" bigint NOT NULL,
    "blockedById" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "blocking_blocked_unique_idx" ON "blocking" USING btree ("blockedId", "blockedById");

--
-- Class Book as table book
--
CREATE TABLE "book" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL
);

--
-- Class BoolDefault as table bool_default
--
CREATE TABLE "bool_default" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultTrue" boolean NOT NULL DEFAULT true,
    "boolDefaultFalse" boolean NOT NULL DEFAULT false,
    "boolDefaultNullFalse" boolean DEFAULT false
);

--
-- Class BoolDefaultMix as table bool_default_mix
--
CREATE TABLE "bool_default_mix" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultAndDefaultModel" boolean NOT NULL DEFAULT true,
    "boolDefaultAndDefaultPersist" boolean NOT NULL DEFAULT false,
    "boolDefaultModelAndDefaultPersist" boolean NOT NULL DEFAULT false
);

--
-- Class BoolDefaultModel as table bool_default_model
--
CREATE TABLE "bool_default_model" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultModelTrue" boolean NOT NULL,
    "boolDefaultModelFalse" boolean NOT NULL,
    "boolDefaultModelNullFalse" boolean NOT NULL
);

--
-- Class BoolDefaultPersist as table bool_default_persist
--
CREATE TABLE "bool_default_persist" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultPersistTrue" boolean DEFAULT true,
    "boolDefaultPersistFalse" boolean DEFAULT false
);

--
-- Class Cat as table cat
--
CREATE TABLE "cat" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "motherId" bigint
);

--
-- Class ChangedIdTypeSelf as table changed_id_type_self
--
CREATE TABLE "changed_id_type_self" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "nextId" uuid,
    "parentId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "changed_id_type_self_next_unique_idx" ON "changed_id_type_self" USING btree ("nextId");

--
-- Class Chapter as table chapter
--
CREATE TABLE "chapter" (
    "id" bigserial PRIMARY KEY,
    "title" text NOT NULL,
    "_bookChaptersBookId" bigint
);

--
-- Class Citizen as table citizen
--
CREATE TABLE "citizen" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" bigint NOT NULL,
    "oldCompanyId" bigint
);

--
-- Class CitizenInt as table citizen_int
--
CREATE TABLE "citizen_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" uuid NOT NULL,
    "oldCompanyId" uuid
);

--
-- Class City as table city
--
CREATE TABLE "city" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class CityWithLongTableName as table city_with_long_table_name_that_is_still_valid
--
CREATE TABLE "city_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class Comment as table comment
--
CREATE TABLE "comment" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" bigint NOT NULL
);

--
-- Class CommentInt as table comment_int
--
CREATE TABLE "comment_int" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" uuid NOT NULL
);

--
-- Class Company as table company
--
CREATE TABLE "company" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" bigint NOT NULL
);

--
-- Class CompanyUuid as table company_uuid
--
CREATE TABLE "company_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL,
    "townId" bigint NOT NULL
);

--
-- Class Course as table course
--
CREATE TABLE "course" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class CourseUuid as table course_uuid
--
CREATE TABLE "course_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "name" text NOT NULL
);

--
-- Class Customer as table customer
--
CREATE TABLE "customer" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class CustomerInt as table customer_int
--
CREATE TABLE "customer_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class DateTimeDefault as table datetime_default
--
CREATE TABLE "datetime_default" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultNow" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dateTimeDefaultStr" timestamp without time zone NOT NULL DEFAULT '2024-05-24 22:00:00'::timestamp without time zone,
    "dateTimeDefaultStrNull" timestamp without time zone DEFAULT '2024-05-24 22:00:00'::timestamp without time zone
);

--
-- Class DateTimeDefaultMix as table datetime_default_mix
--
CREATE TABLE "datetime_default_mix" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultAndDefaultModel" timestamp without time zone NOT NULL DEFAULT '2024-05-01 22:00:00'::timestamp without time zone,
    "dateTimeDefaultAndDefaultPersist" timestamp without time zone NOT NULL DEFAULT '2024-05-10 22:00:00'::timestamp without time zone,
    "dateTimeDefaultModelAndDefaultPersist" timestamp without time zone NOT NULL DEFAULT '2024-05-10 22:00:00'::timestamp without time zone
);

--
-- Class DateTimeDefaultModel as table datetime_default_model
--
CREATE TABLE "datetime_default_model" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultModelNow" timestamp without time zone NOT NULL,
    "dateTimeDefaultModelStr" timestamp without time zone NOT NULL,
    "dateTimeDefaultModelStrNull" timestamp without time zone
);

--
-- Class DateTimeDefaultPersist as table datetime_default_persist
--
CREATE TABLE "datetime_default_persist" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultPersistNow" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "dateTimeDefaultPersistStr" timestamp without time zone DEFAULT '2024-05-10 22:00:00'::timestamp without time zone
);

--
-- Class DoubleDefault as table double_default
--
CREATE TABLE "double_default" (
    "id" bigserial PRIMARY KEY,
    "doubleDefault" double precision NOT NULL DEFAULT 10.5,
    "doubleDefaultNull" double precision DEFAULT 20.5
);

--
-- Class DoubleDefaultMix as table double_default_mix
--
CREATE TABLE "double_default_mix" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultAndDefaultModel" double precision NOT NULL DEFAULT 10.5,
    "doubleDefaultAndDefaultPersist" double precision NOT NULL DEFAULT 20.5,
    "doubleDefaultModelAndDefaultPersist" double precision NOT NULL DEFAULT 20.5
);

--
-- Class DoubleDefaultModel as table double_default_model
--
CREATE TABLE "double_default_model" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultModel" double precision NOT NULL,
    "doubleDefaultModelNull" double precision NOT NULL
);

--
-- Class DoubleDefaultPersist as table double_default_persist
--
CREATE TABLE "double_default_persist" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultPersist" double precision DEFAULT 10.5
);

--
-- Class DurationDefault as table duration_default
--
CREATE TABLE "duration_default" (
    "id" bigserial PRIMARY KEY,
    "durationDefault" bigint NOT NULL DEFAULT 94230100,
    "durationDefaultNull" bigint DEFAULT 177640100
);

--
-- Class DurationDefaultMix as table duration_default_mix
--
CREATE TABLE "duration_default_mix" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultAndDefaultModel" bigint NOT NULL DEFAULT 94230100,
    "durationDefaultAndDefaultPersist" bigint NOT NULL DEFAULT 177640100,
    "durationDefaultModelAndDefaultPersist" bigint NOT NULL DEFAULT 177640100
);

--
-- Class DurationDefaultModel as table duration_default_model
--
CREATE TABLE "duration_default_model" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultModel" bigint NOT NULL,
    "durationDefaultModelNull" bigint
);

--
-- Class DurationDefaultPersist as table duration_default_persist
--
CREATE TABLE "duration_default_persist" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultPersist" bigint DEFAULT 94230100
);

--
-- Class EmptyModelRelationItem as table empty_model_relation_item
--
CREATE TABLE "empty_model_relation_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_relationEmptyModelItemsRelationEmptyModelId" bigint
);

--
-- Class EmptyModelWithTable as table empty_model_with_table
--
CREATE TABLE "empty_model_with_table" (
    "id" bigserial PRIMARY KEY
);

--
-- Class Enrollment as table enrollment
--
CREATE TABLE "enrollment" (
    "id" bigserial PRIMARY KEY,
    "studentId" bigint NOT NULL,
    "courseId" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_index_idx" ON "enrollment" USING btree ("studentId", "courseId");

--
-- Class EnrollmentInt as table enrollment_int
--
CREATE TABLE "enrollment_int" (
    "id" bigserial PRIMARY KEY,
    "studentId" uuid NOT NULL,
    "courseId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_int_index_idx" ON "enrollment_int" USING btree ("studentId", "courseId");

--
-- Class EnumDefault as table enum_default
--
CREATE TABLE "enum_default" (
    "id" bigserial PRIMARY KEY,
    "byNameEnumDefault" text NOT NULL DEFAULT 'byName1'::text,
    "byNameEnumDefaultNull" text DEFAULT 'byName2'::text,
    "byIndexEnumDefault" bigint NOT NULL DEFAULT 0,
    "byIndexEnumDefaultNull" bigint DEFAULT 1
);

--
-- Class EnumDefaultMix as table enum_default_mix
--
CREATE TABLE "enum_default_mix" (
    "id" bigserial PRIMARY KEY,
    "byNameEnumDefaultAndDefaultModel" text NOT NULL DEFAULT 'byName1'::text,
    "byNameEnumDefaultAndDefaultPersist" text NOT NULL DEFAULT 'byName2'::text,
    "byNameEnumDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'byName2'::text
);

--
-- Class EnumDefaultModel as table enum_default_model
--
CREATE TABLE "enum_default_model" (
    "id" bigserial PRIMARY KEY,
    "byNameEnumDefaultModel" text NOT NULL,
    "byNameEnumDefaultModelNull" text,
    "byIndexEnumDefaultModel" bigint NOT NULL,
    "byIndexEnumDefaultModelNull" bigint
);

--
-- Class EnumDefaultPersist as table enum_default_persist
--
CREATE TABLE "enum_default_persist" (
    "id" bigserial PRIMARY KEY,
    "byNameEnumDefaultPersist" text DEFAULT 'byName1'::text,
    "byIndexEnumDefaultPersist" bigint DEFAULT 0
);

--
-- Class IntDefault as table int_default
--
CREATE TABLE "int_default" (
    "id" bigserial PRIMARY KEY,
    "intDefault" bigint NOT NULL DEFAULT 10,
    "intDefaultNull" bigint DEFAULT 20
);

--
-- Class IntDefaultMix as table int_default_mix
--
CREATE TABLE "int_default_mix" (
    "id" bigserial PRIMARY KEY,
    "intDefaultAndDefaultModel" bigint NOT NULL DEFAULT 10,
    "intDefaultAndDefaultPersist" bigint NOT NULL DEFAULT 20,
    "intDefaultModelAndDefaultPersist" bigint NOT NULL DEFAULT 20
);

--
-- Class IntDefaultModel as table int_default_model
--
CREATE TABLE "int_default_model" (
    "id" bigserial PRIMARY KEY,
    "intDefaultModel" bigint NOT NULL,
    "intDefaultModelNull" bigint NOT NULL
);

--
-- Class IntDefaultPersist as table int_default_persist
--
CREATE TABLE "int_default_persist" (
    "id" bigserial PRIMARY KEY,
    "intDefaultPersist" bigint DEFAULT 10
);

--
-- Class LongImplicitIdField as table long_implicit_id_field
--
CREATE TABLE "long_implicit_id_field" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id" bigint
);

--
-- Class LongImplicitIdFieldCollection as table long_implicit_id_field_collection
--
CREATE TABLE "long_implicit_id_field_collection" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class MaxFieldName as table max_field_name
--
CREATE TABLE "max_field_name" (
    "id" bigserial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNameFo" text NOT NULL
);

--
-- Class Member as table member
--
CREATE TABLE "member" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class MultipleMaxFieldName as table multiple_max_field_name
--
CREATE TABLE "multiple_max_field_name" (
    "id" bigserial PRIMARY KEY,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames1" text NOT NULL,
    "thisFieldIsExactly61CharactersLongAndIsThereforeValidAsNames2" text NOT NULL,
    "_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId" bigint
);

--
-- Class ObjectFieldPersist as table object_field_persist
--
CREATE TABLE "object_field_persist" (
    "id" bigserial PRIMARY KEY,
    "normal" text NOT NULL
);

--
-- Class ObjectFieldScopes as table object_field_scopes
--
CREATE TABLE "object_field_scopes" (
    "id" bigserial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);

--
-- Class ObjectUser as table object_user
--
CREATE TABLE "object_user" (
    "id" bigserial PRIMARY KEY,
    "name" text,
    "userInfoId" bigint NOT NULL
);

--
-- Class ObjectWithBit as table object_with_bit
--
CREATE TABLE "object_with_bit" (
    "id" bigserial PRIMARY KEY,
    "bit" bit(512) NOT NULL,
    "bitNullable" bit(512),
    "bitIndexedHnsw" bit(512) NOT NULL,
    "bitIndexedHnswWithParams" bit(512) NOT NULL,
    "bitIndexedIvfflat" bit(512) NOT NULL,
    "bitIndexedIvfflatWithParams" bit(512) NOT NULL
);

-- Indexes
CREATE INDEX "bit_index_default" ON "object_with_bit" USING hnsw ("bit" bit_hamming_ops);
CREATE INDEX "bit_index_hnsw" ON "object_with_bit" USING hnsw ("bitIndexedHnsw" bit_hamming_ops);
CREATE INDEX "bit_index_hnsw_with_params" ON "object_with_bit" USING hnsw ("bitIndexedHnswWithParams" bit_jaccard_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "bit_index_ivfflat" ON "object_with_bit" USING ivfflat ("bitIndexedIvfflat" bit_hamming_ops);
CREATE INDEX "bit_index_ivfflat_with_params" ON "object_with_bit" USING ivfflat ("bitIndexedIvfflatWithParams" bit_hamming_ops) WITH (lists=300);

--
-- Class ObjectWithByteData as table object_with_bytedata
--
CREATE TABLE "object_with_bytedata" (
    "id" bigserial PRIMARY KEY,
    "byteData" bytea NOT NULL
);

--
-- Class ObjectWithDuration as table object_with_duration
--
CREATE TABLE "object_with_duration" (
    "id" bigserial PRIMARY KEY,
    "duration" bigint NOT NULL
);

--
-- Class ObjectWithEnum as table object_with_enum
--
CREATE TABLE "object_with_enum" (
    "id" bigserial PRIMARY KEY,
    "testEnum" bigint NOT NULL,
    "nullableEnum" bigint,
    "enumList" json NOT NULL,
    "nullableEnumList" json NOT NULL,
    "enumListList" json NOT NULL
);

--
-- Class ObjectWithHalfVector as table object_with_half_vector
--
CREATE TABLE "object_with_half_vector" (
    "id" bigserial PRIMARY KEY,
    "halfVector" halfvec(512) NOT NULL,
    "halfVectorNullable" halfvec(512),
    "halfVectorIndexedHnsw" halfvec(512) NOT NULL,
    "halfVectorIndexedHnswWithParams" halfvec(512) NOT NULL,
    "halfVectorIndexedIvfflat" halfvec(512) NOT NULL,
    "halfVectorIndexedIvfflatWithParams" halfvec(512) NOT NULL
);

-- Indexes
CREATE INDEX "half_vector_index_default" ON "object_with_half_vector" USING hnsw ("halfVector" halfvec_l2_ops);
CREATE INDEX "half_vector_index_hnsw" ON "object_with_half_vector" USING hnsw ("halfVectorIndexedHnsw" halfvec_l2_ops);
CREATE INDEX "half_vector_index_hnsw_with_params" ON "object_with_half_vector" USING hnsw ("halfVectorIndexedHnswWithParams" halfvec_l2_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "half_vector_index_ivfflat" ON "object_with_half_vector" USING ivfflat ("halfVectorIndexedIvfflat" halfvec_l2_ops);
CREATE INDEX "half_vector_index_ivfflat_with_params" ON "object_with_half_vector" USING ivfflat ("halfVectorIndexedIvfflatWithParams" halfvec_cosine_ops) WITH (lists=300);

--
-- Class ObjectWithIndex as table object_with_index
--
CREATE TABLE "object_with_index" (
    "id" bigserial PRIMARY KEY,
    "indexed" bigint NOT NULL,
    "indexed2" bigint NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- Class ObjectWithObject as table object_with_object
--
CREATE TABLE "object_with_object" (
    "id" bigserial PRIMARY KEY,
    "data" json NOT NULL,
    "nullableData" json,
    "dataList" json NOT NULL,
    "nullableDataList" json,
    "listWithNullableData" json NOT NULL,
    "nullableListWithNullableData" json,
    "nestedDataList" json,
    "nestedDataListInMap" json,
    "nestedDataMap" json
);

--
-- Class ObjectWithParent as table object_with_parent
--
CREATE TABLE "object_with_parent" (
    "id" bigserial PRIMARY KEY,
    "other" bigint NOT NULL
);

--
-- Class ObjectWithSelfParent as table object_with_self_parent
--
CREATE TABLE "object_with_self_parent" (
    "id" bigserial PRIMARY KEY,
    "other" bigint
);

--
-- Class ObjectWithSparseVector as table object_with_sparse_vector
--
CREATE TABLE "object_with_sparse_vector" (
    "id" bigserial PRIMARY KEY,
    "sparseVector" sparsevec(512) NOT NULL,
    "sparseVectorNullable" sparsevec(512),
    "sparseVectorIndexedHnsw" sparsevec(512) NOT NULL,
    "sparseVectorIndexedHnswWithParams" sparsevec(512) NOT NULL
);

-- Indexes
CREATE INDEX "sparse_vector_index_default" ON "object_with_sparse_vector" USING hnsw ("sparseVector" sparsevec_l2_ops);
CREATE INDEX "sparse_vector_index_hnsw" ON "object_with_sparse_vector" USING hnsw ("sparseVectorIndexedHnsw" sparsevec_l2_ops);
CREATE INDEX "sparse_vector_index_hnsw_with_params" ON "object_with_sparse_vector" USING hnsw ("sparseVectorIndexedHnswWithParams" sparsevec_l1_ops) WITH (m=64, ef_construction=200);

--
-- Class ObjectWithUuid as table object_with_uuid
--
CREATE TABLE "object_with_uuid" (
    "id" bigserial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
);

--
-- Class ObjectWithVector as table object_with_vector
--
CREATE TABLE "object_with_vector" (
    "id" bigserial PRIMARY KEY,
    "vector" vector(512) NOT NULL,
    "vectorNullable" vector(512),
    "vectorIndexedHnsw" vector(512) NOT NULL,
    "vectorIndexedHnswWithParams" vector(512) NOT NULL,
    "vectorIndexedIvfflat" vector(512) NOT NULL,
    "vectorIndexedIvfflatWithParams" vector(512) NOT NULL
);

-- Indexes
CREATE INDEX "vector_index_default" ON "object_with_vector" USING hnsw ("vector" vector_l2_ops);
CREATE INDEX "vector_index_hnsw" ON "object_with_vector" USING hnsw ("vectorIndexedHnsw" vector_l2_ops);
CREATE INDEX "vector_index_hnsw_with_params" ON "object_with_vector" USING hnsw ("vectorIndexedHnswWithParams" vector_cosine_ops) WITH (m=64, ef_construction=200);
CREATE INDEX "vector_index_ivfflat" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflat" vector_l2_ops);
CREATE INDEX "vector_index_ivfflat_with_params" ON "object_with_vector" USING ivfflat ("vectorIndexedIvfflatWithParams" vector_ip_ops) WITH (lists=300);

--
-- Class Order as table order
--
CREATE TABLE "order" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "customerId" bigint NOT NULL
);

--
-- Class OrderUuid as table order_uuid
--
CREATE TABLE "order_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid_v7(),
    "description" text NOT NULL,
    "customerId" bigint NOT NULL
);

--
-- Class Organization as table organization
--
CREATE TABLE "organization" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" bigint
);

--
-- Class OrganizationWithLongTableName as table organization_with_long_table_name_that_is_still_valid
--
CREATE TABLE "organization_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" bigint
);

--
-- Class ParentClass as table parent_class_table
--
CREATE TABLE "parent_class_table" (
    "id" bigserial PRIMARY KEY,
    "grandParentField" text NOT NULL,
    "parentField" text NOT NULL
);

--
-- Class ParentUser as table parent_user
--
CREATE TABLE "parent_user" (
    "id" bigserial PRIMARY KEY,
    "name" text,
    "userInfoId" bigint
);

--
-- Class Person as table person
--
CREATE TABLE "person" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" bigint,
    "_cityCitizensCityId" bigint
);

--
-- Class PersonWithLongTableName as table person_with_long_table_name_that_is_still_valid
--
CREATE TABLE "person_with_long_table_name_that_is_still_valid" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" bigint,
    "_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id" bigint
);

--
-- Class Player as table player
--
CREATE TABLE "player" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "teamId" bigint
);

--
-- Class PlayerUuid as table player_uuid
--
CREATE TABLE "player_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "teamId" bigint
);

--
-- Class Post as table post
--
CREATE TABLE "post" (
    "id" bigserial PRIMARY KEY,
    "content" text NOT NULL,
    "nextId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "next_unique_idx" ON "post" USING btree ("nextId");

--
-- Class RelatedUniqueData as table related_unique_data
--
CREATE TABLE "related_unique_data" (
    "id" bigserial PRIMARY KEY,
    "uniqueDataId" bigint NOT NULL,
    "number" bigint NOT NULL
);

--
-- Class RelationEmptyModel as table relation_empty_model
--
CREATE TABLE "relation_empty_model" (
    "id" bigserial PRIMARY KEY
);

--
-- Class RelationToMultipleMaxFieldName as table relation_to_multiple_max_field_name
--
CREATE TABLE "relation_to_multiple_max_field_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class ScopeNoneFields as table scope_none_fields
--
CREATE TABLE "scope_none_fields" (
    "id" bigserial PRIMARY KEY,
    "name" text,
    "object" json
);

--
-- Class SimpleData as table simple_data
--
CREATE TABLE "simple_data" (
    "id" bigserial PRIMARY KEY,
    "num" bigint NOT NULL
);

--
-- Class SimpleDateTime as table simple_date_time
--
CREATE TABLE "simple_date_time" (
    "id" bigserial PRIMARY KEY,
    "dateTime" timestamp without time zone NOT NULL
);

--
-- Class StringDefault as table string_default
--
CREATE TABLE "string_default" (
    "id" bigserial PRIMARY KEY,
    "stringDefault" text NOT NULL DEFAULT 'This is a default value'::text,
    "stringDefaultNull" text DEFAULT 'This is a default null value'::text
);

--
-- Class StringDefaultMix as table string_default_mix
--
CREATE TABLE "string_default_mix" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultAndDefaultModel" text NOT NULL DEFAULT 'This is a default value'::text,
    "stringDefaultAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value'::text,
    "stringDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value'::text
);

--
-- Class StringDefaultModel as table string_default_model
--
CREATE TABLE "string_default_model" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultModel" text NOT NULL,
    "stringDefaultModelNull" text NOT NULL
);

--
-- Class StringDefaultPersist as table string_default_persist
--
CREATE TABLE "string_default_persist" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultPersist" text DEFAULT 'This is a default persist value'::text,
    "stringDefaultPersistSingleQuoteWithOneSingleEscapeQuote" text DEFAULT 'This is a ''default persist value'::text,
    "stringDefaultPersistSingleQuoteWithTwoSingleEscapeQuote" text DEFAULT 'This is a ''default'' persist value'::text,
    "stringDefaultPersistDoubleQuoteWithOneDoubleEscapeQuote" text DEFAULT 'This is a "default persist value'::text,
    "stringDefaultPersistDoubleQuoteWithTwoDoubleEscapeQuote" text DEFAULT 'This is a "default" persist value'::text,
    "stringDefaultPersistSingleQuoteWithOneDoubleQuote" text DEFAULT 'This is a "default persist value'::text,
    "stringDefaultPersistSingleQuoteWithTwoDoubleQuote" text DEFAULT 'This is a "default" persist value'::text,
    "stringDefaultPersistDoubleQuoteWithOneSingleQuote" text DEFAULT 'This is a ''default persist value'::text,
    "stringDefaultPersistDoubleQuoteWithTwoSingleQuote" text DEFAULT 'This is a ''default'' persist value'::text
);

--
-- Class Student as table student
--
CREATE TABLE "student" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class StudentUuid as table student_uuid
--
CREATE TABLE "student_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL
);

--
-- Class Team as table team
--
CREATE TABLE "team" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "arena_index_idx" ON "team" USING btree ("arenaId");

--
-- Class TeamInt as table team_int
--
CREATE TABLE "team_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "arena_uuid_index_idx" ON "team_int" USING btree ("arenaId");

--
-- Class Town as table town
--
CREATE TABLE "town" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" bigint
);

--
-- Class TownInt as table town_int
--
CREATE TABLE "town_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" bigint
);

--
-- Class Types as table types
--
CREATE TABLE "types" (
    "id" bigserial PRIMARY KEY,
    "anInt" bigint,
    "aBool" boolean,
    "aDouble" double precision,
    "aDateTime" timestamp without time zone,
    "aString" text,
    "aByteData" bytea,
    "aDuration" bigint,
    "aUuid" uuid,
    "aUri" text,
    "aBigInt" text,
    "aVector" vector(3),
    "aHalfVector" halfvec(3),
    "aSparseVector" sparsevec(3),
    "aBit" bit(3),
    "anEnum" bigint,
    "aStringifiedEnum" text,
    "aList" json,
    "aMap" json,
    "aSet" json,
    "aRecord" json
);

--
-- Class UniqueData as table unique_data
--
CREATE TABLE "unique_data" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" USING btree ("email");

--
-- Class UriDefault as table uri_default
--
CREATE TABLE "uri_default" (
    "id" bigserial PRIMARY KEY,
    "uriDefault" text NOT NULL DEFAULT 'https://serverpod.dev/default'::text,
    "uriDefaultNull" text DEFAULT 'https://serverpod.dev/default'::text
);

--
-- Class UriDefaultMix as table uri_default_mix
--
CREATE TABLE "uri_default_mix" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultAndDefaultModel" text NOT NULL DEFAULT 'https://serverpod.dev/default'::text,
    "uriDefaultAndDefaultPersist" text NOT NULL DEFAULT 'https://serverpod.dev/defaultPersist'::text,
    "uriDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'https://serverpod.dev/defaultPersist'::text
);

--
-- Class UriDefaultModel as table uri_default_model
--
CREATE TABLE "uri_default_model" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultModel" text NOT NULL,
    "uriDefaultModelNull" text
);

--
-- Class UriDefaultPersist as table uri_default_persist
--
CREATE TABLE "uri_default_persist" (
    "id" bigserial PRIMARY KEY,
    "uriDefaultPersist" text DEFAULT 'https://serverpod.dev/'::text
);

--
-- Class UserNote as table user_note
--
CREATE TABLE "user_note" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId" bigint
);

--
-- Class UserNoteCollectionWithALongName as table user_note_collection_with_a_long_name
--
CREATE TABLE "user_note_collection_with_a_long_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class UserNoteCollection as table user_note_collections
--
CREATE TABLE "user_note_collections" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- Class UserNoteWithALongName as table user_note_with_a_long_name
--
CREATE TABLE "user_note_with_a_long_name" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId" bigint
);

--
-- Class UuidDefault as table uuid_default
--
CREATE TABLE "uuid_default" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultRandom" uuid NOT NULL DEFAULT gen_random_uuid(),
    "uuidDefaultRandomV7" uuid NOT NULL DEFAULT gen_random_uuid_v7(),
    "uuidDefaultRandomNull" uuid DEFAULT gen_random_uuid(),
    "uuidDefaultStr" uuid NOT NULL DEFAULT '550e8400-e29b-41d4-a716-446655440000'::uuid,
    "uuidDefaultStrNull" uuid DEFAULT '3f2504e0-4f89-11d3-9a0c-0305e82c3301'::uuid
);

--
-- Class UuidDefaultMix as table uuid_default_mix
--
CREATE TABLE "uuid_default_mix" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultAndDefaultModel" uuid NOT NULL DEFAULT '3f2504e0-4f89-11d3-9a0c-0305e82c3301'::uuid,
    "uuidDefaultAndDefaultPersist" uuid NOT NULL DEFAULT '9e107d9d-372b-4d97-9b27-2f0907d0b1d4'::uuid,
    "uuidDefaultModelAndDefaultPersist" uuid NOT NULL DEFAULT 'f47ac10b-58cc-4372-a567-0e02b2c3d479'::uuid
);

--
-- Class UuidDefaultModel as table uuid_default_model
--
CREATE TABLE "uuid_default_model" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultModelRandom" uuid NOT NULL,
    "uuidDefaultModelRandomV7" uuid NOT NULL,
    "uuidDefaultModelRandomNull" uuid,
    "uuidDefaultModelStr" uuid NOT NULL,
    "uuidDefaultModelStrNull" uuid
);

--
-- Class UuidDefaultPersist as table uuid_default_persist
--
CREATE TABLE "uuid_default_persist" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultPersistRandom" uuid DEFAULT gen_random_uuid(),
    "uuidDefaultPersistRandomV7" uuid DEFAULT gen_random_uuid_v7(),
    "uuidDefaultPersistStr" uuid DEFAULT '550e8400-e29b-41d4-a716-446655440000'::uuid
);

--
-- Class CloudStorageEntry as table serverpod_cloud_storage
--
CREATE TABLE "serverpod_cloud_storage" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "addedTime" timestamp without time zone NOT NULL,
    "expiration" timestamp without time zone,
    "byteData" bytea NOT NULL,
    "verified" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_path_idx" ON "serverpod_cloud_storage" USING btree ("storageId", "path");
CREATE INDEX "serverpod_cloud_storage_expiration" ON "serverpod_cloud_storage" USING btree ("expiration");

--
-- Class CloudStorageDirectUploadEntry as table serverpod_cloud_storage_direct_upload
--
CREATE TABLE "serverpod_cloud_storage_direct_upload" (
    "id" bigserial PRIMARY KEY,
    "storageId" text NOT NULL,
    "path" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL,
    "authKey" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_cloud_storage_direct_upload_storage_path" ON "serverpod_cloud_storage_direct_upload" USING btree ("storageId", "path");

--
-- Class FutureCallEntry as table serverpod_future_call
--
CREATE TABLE "serverpod_future_call" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "serializedObject" text,
    "serverId" text NOT NULL,
    "identifier" text
);

-- Indexes
CREATE INDEX "serverpod_future_call_time_idx" ON "serverpod_future_call" USING btree ("time");
CREATE INDEX "serverpod_future_call_serverId_idx" ON "serverpod_future_call" USING btree ("serverId");
CREATE INDEX "serverpod_future_call_identifier_idx" ON "serverpod_future_call" USING btree ("identifier");

--
-- Class ServerHealthConnectionInfo as table serverpod_health_connection_info
--
CREATE TABLE "serverpod_health_connection_info" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "active" bigint NOT NULL,
    "closing" bigint NOT NULL,
    "idle" bigint NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_connection_info_timestamp_idx" ON "serverpod_health_connection_info" USING btree ("timestamp", "serverId", "granularity");

--
-- Class ServerHealthMetric as table serverpod_health_metric
--
CREATE TABLE "serverpod_health_metric" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "serverId" text NOT NULL,
    "timestamp" timestamp without time zone NOT NULL,
    "isHealthy" boolean NOT NULL,
    "value" double precision NOT NULL,
    "granularity" bigint NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_health_metric_timestamp_idx" ON "serverpod_health_metric" USING btree ("timestamp", "serverId", "name", "granularity");

--
-- Class LogEntry as table serverpod_log
--
CREATE TABLE "serverpod_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "reference" text,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "logLevel" bigint NOT NULL,
    "message" text NOT NULL,
    "error" text,
    "stackTrace" text,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_log_sessionLogId_idx" ON "serverpod_log" USING btree ("sessionLogId");

--
-- Class MessageLogEntry as table serverpod_message_log
--
CREATE TABLE "serverpod_message_log" (
    "id" bigserial PRIMARY KEY,
    "sessionLogId" bigint NOT NULL,
    "serverId" text NOT NULL,
    "messageId" bigint NOT NULL,
    "endpoint" text NOT NULL,
    "messageName" text NOT NULL,
    "duration" double precision NOT NULL,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

--
-- Class MethodInfo as table serverpod_method
--
CREATE TABLE "serverpod_method" (
    "id" bigserial PRIMARY KEY,
    "endpoint" text NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_method_endpoint_method_idx" ON "serverpod_method" USING btree ("endpoint", "method");

--
-- Class DatabaseMigrationVersion as table serverpod_migrations
--
CREATE TABLE "serverpod_migrations" (
    "id" bigserial PRIMARY KEY,
    "module" text NOT NULL,
    "version" text NOT NULL,
    "timestamp" timestamp without time zone
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_migrations_ids" ON "serverpod_migrations" USING btree ("module");

--
-- Class QueryLogEntry as table serverpod_query_log
--
CREATE TABLE "serverpod_query_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "sessionLogId" bigint NOT NULL,
    "messageId" bigint,
    "query" text NOT NULL,
    "duration" double precision NOT NULL,
    "numRows" bigint,
    "error" text,
    "stackTrace" text,
    "slow" boolean NOT NULL,
    "order" bigint NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_query_log_sessionLogId_idx" ON "serverpod_query_log" USING btree ("sessionLogId");

--
-- Class ReadWriteTestEntry as table serverpod_readwrite_test
--
CREATE TABLE "serverpod_readwrite_test" (
    "id" bigserial PRIMARY KEY,
    "number" bigint NOT NULL
);

--
-- Class RuntimeSettings as table serverpod_runtime_settings
--
CREATE TABLE "serverpod_runtime_settings" (
    "id" bigserial PRIMARY KEY,
    "logSettings" json NOT NULL,
    "logSettingsOverrides" json NOT NULL,
    "logServiceCalls" boolean NOT NULL,
    "logMalformedCalls" boolean NOT NULL
);

--
-- Class SessionLogEntry as table serverpod_session_log
--
CREATE TABLE "serverpod_session_log" (
    "id" bigserial PRIMARY KEY,
    "serverId" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "module" text,
    "endpoint" text,
    "method" text,
    "duration" double precision,
    "numQueries" bigint,
    "slow" boolean,
    "error" text,
    "stackTrace" text,
    "authenticatedUserId" bigint,
    "isOpen" boolean,
    "touched" timestamp without time zone NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_session_log_serverid_idx" ON "serverpod_session_log" USING btree ("serverId");
CREATE INDEX "serverpod_session_log_touched_idx" ON "serverpod_session_log" USING btree ("touched");
CREATE INDEX "serverpod_session_log_isopen_idx" ON "serverpod_session_log" USING btree ("isOpen");

--
-- Class AuthKey as table serverpod_auth_key
--
CREATE TABLE "serverpod_auth_key" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "hash" text NOT NULL,
    "scopeNames" json NOT NULL,
    "method" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_auth_key_userId_idx" ON "serverpod_auth_key" USING btree ("userId");

--
-- Class EmailAuth as table serverpod_email_auth
--
CREATE TABLE "serverpod_email_auth" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_email" ON "serverpod_email_auth" USING btree ("email");

--
-- Class EmailCreateAccountRequest as table serverpod_email_create_request
--
CREATE TABLE "serverpod_email_create_request" (
    "id" bigserial PRIMARY KEY,
    "userName" text NOT NULL,
    "email" text NOT NULL,
    "hash" text NOT NULL,
    "verificationCode" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_auth_create_account_request_idx" ON "serverpod_email_create_request" USING btree ("email");

--
-- Class EmailFailedSignIn as table serverpod_email_failed_sign_in
--
CREATE TABLE "serverpod_email_failed_sign_in" (
    "id" bigserial PRIMARY KEY,
    "email" text NOT NULL,
    "time" timestamp without time zone NOT NULL,
    "ipAddress" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_email_failed_sign_in_email_idx" ON "serverpod_email_failed_sign_in" USING btree ("email");
CREATE INDEX "serverpod_email_failed_sign_in_time_idx" ON "serverpod_email_failed_sign_in" USING btree ("time");

--
-- Class EmailReset as table serverpod_email_reset
--
CREATE TABLE "serverpod_email_reset" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "verificationCode" text NOT NULL,
    "expiration" timestamp without time zone NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_email_reset_verification_idx" ON "serverpod_email_reset" USING btree ("verificationCode");

--
-- Class GoogleRefreshToken as table serverpod_google_refresh_token
--
CREATE TABLE "serverpod_google_refresh_token" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "refreshToken" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_google_refresh_token_userId_idx" ON "serverpod_google_refresh_token" USING btree ("userId");

--
-- Class UserImage as table serverpod_user_image
--
CREATE TABLE "serverpod_user_image" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "version" bigint NOT NULL,
    "url" text NOT NULL
);

-- Indexes
CREATE INDEX "serverpod_user_image_user_id" ON "serverpod_user_image" USING btree ("userId", "version");

--
-- Class UserInfo as table serverpod_user_info
--
CREATE TABLE "serverpod_user_info" (
    "id" bigserial PRIMARY KEY,
    "userIdentifier" text NOT NULL,
    "userName" text,
    "fullName" text,
    "email" text,
    "created" timestamp without time zone NOT NULL,
    "imageUrl" text,
    "scopeNames" json NOT NULL,
    "blocked" boolean NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "serverpod_user_info_user_identifier" ON "serverpod_user_info" USING btree ("userIdentifier");
CREATE INDEX "serverpod_user_info_email" ON "serverpod_user_info" USING btree ("email");

--
-- Foreign relations for "address" table
--
ALTER TABLE ONLY "address"
    ADD CONSTRAINT "address_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "address_uuid" table
--
ALTER TABLE ONLY "address_uuid"
    ADD CONSTRAINT "address_uuid_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen_int"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "blocking" table
--
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_0"
    FOREIGN KEY("blockedId")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_1"
    FOREIGN KEY("blockedById")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "cat" table
--
ALTER TABLE ONLY "cat"
    ADD CONSTRAINT "cat_fk_0"
    FOREIGN KEY("motherId")
    REFERENCES "cat"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "changed_id_type_self" table
--
ALTER TABLE ONLY "changed_id_type_self"
    ADD CONSTRAINT "changed_id_type_self_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "changed_id_type_self"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "changed_id_type_self"
    ADD CONSTRAINT "changed_id_type_self_fk_1"
    FOREIGN KEY("parentId")
    REFERENCES "changed_id_type_self"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "chapter" table
--
ALTER TABLE ONLY "chapter"
    ADD CONSTRAINT "chapter_fk_0"
    FOREIGN KEY("_bookChaptersBookId")
    REFERENCES "book"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "citizen" table
--
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "citizen_int" table
--
ALTER TABLE ONLY "citizen_int"
    ADD CONSTRAINT "citizen_int_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company_uuid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen_int"
    ADD CONSTRAINT "citizen_int_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company_uuid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "comment" table
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "comment_int" table
--
ALTER TABLE ONLY "comment_int"
    ADD CONSTRAINT "comment_int_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "company" table
--
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "company_uuid" table
--
ALTER TABLE ONLY "company_uuid"
    ADD CONSTRAINT "company_uuid_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town_int"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "empty_model_relation_item" table
--
ALTER TABLE ONLY "empty_model_relation_item"
    ADD CONSTRAINT "empty_model_relation_item_fk_0"
    FOREIGN KEY("_relationEmptyModelItemsRelationEmptyModelId")
    REFERENCES "relation_empty_model"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "enrollment" table
--
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "student"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "enrollment_int" table
--
ALTER TABLE ONLY "enrollment_int"
    ADD CONSTRAINT "enrollment_int_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "student_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment_int"
    ADD CONSTRAINT "enrollment_int_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "course_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "long_implicit_id_field" table
--
ALTER TABLE ONLY "long_implicit_id_field"
    ADD CONSTRAINT "long_implicit_id_field_fk_0"
    FOREIGN KEY("_longImplicitIdFieldCollectionThisfieldisexactly61charact0008Id")
    REFERENCES "long_implicit_id_field_collection"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "multiple_max_field_name" table
--
ALTER TABLE ONLY "multiple_max_field_name"
    ADD CONSTRAINT "multiple_max_field_name_fk_0"
    FOREIGN KEY("_relationToMultipleMaxFieldNameMultiplemaxfieldnamesRelat674eId")
    REFERENCES "relation_to_multiple_max_field_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_user" table
--
ALTER TABLE ONLY "object_user"
    ADD CONSTRAINT "object_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_with_parent" table
--
ALTER TABLE ONLY "object_with_parent"
    ADD CONSTRAINT "object_with_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_field_scopes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "object_with_self_parent" table
--
ALTER TABLE ONLY "object_with_self_parent"
    ADD CONSTRAINT "object_with_self_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_with_self_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "order" table
--
ALTER TABLE ONLY "order"
    ADD CONSTRAINT "order_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "order_uuid" table
--
ALTER TABLE ONLY "order_uuid"
    ADD CONSTRAINT "order_uuid_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer_int"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "organization" table
--
ALTER TABLE ONLY "organization"
    ADD CONSTRAINT "organization_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "organization_with_long_table_name_that_is_still_valid" table
--
ALTER TABLE ONLY "organization_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "organization_with_long_table_name_that_is_still_valid_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "parent_user" table
--
ALTER TABLE ONLY "parent_user"
    ADD CONSTRAINT "parent_user_fk_0"
    FOREIGN KEY("userInfoId")
    REFERENCES "serverpod_user_info"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "person" table
--
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_1"
    FOREIGN KEY("_cityCitizensCityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "person_with_long_table_name_that_is_still_valid" table
--
ALTER TABLE ONLY "person_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person_with_long_table_name_that_is_still_valid"
    ADD CONSTRAINT "person_with_long_table_name_that_is_still_valid_fk_1"
    FOREIGN KEY("_cityWithLongTableNameThatIsStillValidCitizensCityWithLon4fe0Id")
    REFERENCES "city_with_long_table_name_that_is_still_valid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "player" table
--
ALTER TABLE ONLY "player"
    ADD CONSTRAINT "player_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "player_uuid" table
--
ALTER TABLE ONLY "player_uuid"
    ADD CONSTRAINT "player_uuid_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team_int"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "post" table
--
ALTER TABLE ONLY "post"
    ADD CONSTRAINT "post_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "post"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "related_unique_data" table
--
ALTER TABLE ONLY "related_unique_data"
    ADD CONSTRAINT "related_unique_data_fk_0"
    FOREIGN KEY("uniqueDataId")
    REFERENCES "unique_data"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- Foreign relations for "team" table
--
ALTER TABLE ONLY "team"
    ADD CONSTRAINT "team_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "team_int" table
--
ALTER TABLE ONLY "team_int"
    ADD CONSTRAINT "team_int_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena_uuid"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- Foreign relations for "town" table
--
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "town_int" table
--
ALTER TABLE ONLY "town_int"
    ADD CONSTRAINT "town_int_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen_int"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_note" table
--
ALTER TABLE ONLY "user_note"
    ADD CONSTRAINT "user_note_fk_0"
    FOREIGN KEY("_userNoteCollectionsUsernotespropertynameUserNoteCollectionsId")
    REFERENCES "user_note_collections"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "user_note_with_a_long_name" table
--
ALTER TABLE ONLY "user_note_with_a_long_name"
    ADD CONSTRAINT "user_note_with_a_long_name_fk_0"
    FOREIGN KEY("_userNoteCollectionWithALongNameNotesUserNoteCollectionWi06adId")
    REFERENCES "user_note_collection_with_a_long_name"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_log" table
--
ALTER TABLE ONLY "serverpod_log"
    ADD CONSTRAINT "serverpod_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_message_log" table
--
ALTER TABLE ONLY "serverpod_message_log"
    ADD CONSTRAINT "serverpod_message_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- Foreign relations for "serverpod_query_log" table
--
ALTER TABLE ONLY "serverpod_query_log"
    ADD CONSTRAINT "serverpod_query_log_fk_0"
    FOREIGN KEY("sessionLogId")
    REFERENCES "serverpod_session_log"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250608012916104', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250608012916104', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
