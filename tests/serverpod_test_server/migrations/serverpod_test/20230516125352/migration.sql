BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_field_scopes" (
    "id" serial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_bytedata" (
    "id" serial PRIMARY KEY,
    "byteData" bytea NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_duration" (
    "id" serial PRIMARY KEY,
    "duration" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_index" (
    "id" serial PRIMARY KEY,
    "indexed" integer NOT NULL,
    "indexed2" integer NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_uuid" (
    "id" serial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_data" (
    "id" serial PRIMARY KEY,
    "num" integer NOT NULL
);

--
-- ACTION CREATE TABLE
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
    VALUES ('serverpod_test', '20230516125352', 1, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230516125352', "priority" = 1;


COMMIT;
