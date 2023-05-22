BEGIN;

--
-- Class ObjectFieldScopes as table object_field_scopes
--
CREATE TABLE "object_field_scopes" (
    "id" serial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);


--
-- Class ObjectWithByteData as table object_with_bytedata
--
CREATE TABLE "object_with_bytedata" (
    "id" serial PRIMARY KEY,
    "byteData" bytea NOT NULL
);


--
-- Class ObjectWithDuration as table object_with_duration
--
CREATE TABLE "object_with_duration" (
    "id" serial PRIMARY KEY,
    "duration" bigint NOT NULL
);


--
-- Class ObjectWithEnum as table object_with_enum
--
CREATE TABLE "object_with_enum" (
    "id" serial PRIMARY KEY,
    "testEnum" integer NOT NULL,
    "nullableEnum" integer,
    "enumList" json NOT NULL,
    "nullableEnumList" json NOT NULL,
    "enumListList" json NOT NULL
);


--
-- Class ObjectWithIndex as table object_with_index
--
CREATE TABLE "object_with_index" (
    "id" serial PRIMARY KEY,
    "indexed" integer NOT NULL,
    "indexed2" integer NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");


--
-- Class ObjectWithObject as table object_with_object
--
CREATE TABLE "object_with_object" (
    "id" serial PRIMARY KEY,
    "data" json NOT NULL,
    "nullableData" json,
    "dataList" json NOT NULL,
    "nullableDataList" json,
    "listWithNullableData" json NOT NULL,
    "nullableListWithNullableData" json
);


--
-- Class ObjectWithParent as table object_with_parent
--
CREATE TABLE "object_with_parent" (
    "id" serial PRIMARY KEY,
    "other" integer NOT NULL
);

-- Foreign keys
ALTER TABLE ONLY "object_with_parent"
    ADD CONSTRAINT "object_with_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_field_scopes"("id")
    ON DELETE CASCADE;


--
-- Class ObjectWithSelfParent as table object_with_self_parent
--
CREATE TABLE "object_with_self_parent" (
    "id" serial PRIMARY KEY,
    "other" integer
);

-- Foreign keys
ALTER TABLE ONLY "object_with_self_parent"
    ADD CONSTRAINT "object_with_self_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_with_self_parent"("id")
    ON DELETE CASCADE;


--
-- Class ObjectWithUuid as table object_with_uuid
--
CREATE TABLE "object_with_uuid" (
    "id" serial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
);


--
-- Class SimpleData as table simple_data
--
CREATE TABLE "simple_data" (
    "id" serial PRIMARY KEY,
    "num" integer NOT NULL
);


--
-- Class Types as table types
--
CREATE TABLE "types" (
    "id" serial PRIMARY KEY,
    "anInt" integer,
    "aBool" boolean,
    "aDouble" double precision,
    "aDateTime" timestamp without time zone,
    "aString" text,
    "aByteData" bytea,
    "aDuration" bigint,
    "aUuid" uuid
);


--
-- MIGRATION VERSION
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230522155644', 1, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230522155644', "priority" = 1;


COMMIT;
