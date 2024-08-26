BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultTrue" boolean NOT NULL DEFAULT true,
    "boolDefaultFalse" boolean NOT NULL DEFAULT false,
    "boolDefaultNullFalse" boolean DEFAULT false
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_mix" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultAndDefaultModel" boolean NOT NULL DEFAULT true,
    "boolDefaultAndDefaultPersist" boolean NOT NULL DEFAULT false,
    "boolDefaultModelAndDefaultPersist" boolean NOT NULL DEFAULT false
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_model" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultModelTrue" boolean NOT NULL,
    "boolDefaultModelFalse" boolean NOT NULL,
    "boolDefaultModelNullFalse" boolean NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bool_default_persist" (
    "id" bigserial PRIMARY KEY,
    "boolDefaultPersistTrue" boolean DEFAULT true,
    "boolDefaultPersistFalse" boolean DEFAULT false
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultNow" timestamp without time zone NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "dateTimeDefaultStr" timestamp without time zone NOT NULL DEFAULT '2024-05-24 22:00:00'::timestamp without time zone,
    "dateTimeDefaultStrNull" timestamp without time zone DEFAULT '2024-05-24 22:00:00'::timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_mix" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultAndDefaultModel" timestamp without time zone NOT NULL DEFAULT '2024-05-01 22:00:00'::timestamp without time zone,
    "dateTimeDefaultAndDefaultPersist" timestamp without time zone NOT NULL DEFAULT '2024-05-10 22:00:00'::timestamp without time zone,
    "dateTimeDefaultModelAndDefaultPersist" timestamp without time zone NOT NULL DEFAULT '2024-05-10 22:00:00'::timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_model" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultModelNow" timestamp without time zone NOT NULL,
    "dateTimeDefaultModelStr" timestamp without time zone NOT NULL,
    "dateTimeDefaultModelStrNull" timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "datetime_default_persist" (
    "id" bigserial PRIMARY KEY,
    "dateTimeDefaultPersistNow" timestamp without time zone DEFAULT CURRENT_TIMESTAMP,
    "dateTimeDefaultPersistStr" timestamp without time zone DEFAULT '2024-05-10 22:00:00'::timestamp without time zone
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default" (
    "id" bigserial PRIMARY KEY,
    "doubleDefault" double precision NOT NULL DEFAULT 10.5,
    "doubleDefaultNull" double precision DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_mix" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultAndDefaultModel" double precision NOT NULL DEFAULT 10.5,
    "doubleDefaultAndDefaultPersist" double precision NOT NULL DEFAULT 20.5,
    "doubleDefaultModelAndDefaultPersist" double precision NOT NULL DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_model" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultModel" double precision NOT NULL,
    "doubleDefaultModelNull" double precision NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "double_default_persist" (
    "id" bigserial PRIMARY KEY,
    "doubleDefaultPersist" double precision DEFAULT 10.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default" (
    "id" bigserial PRIMARY KEY,
    "durationDefault" bigint NOT NULL DEFAULT 94230100,
    "durationDefaultNull" bigint DEFAULT 177640100
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_mix" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultAndDefaultModel" bigint NOT NULL DEFAULT 94230100,
    "durationDefaultAndDefaultPersist" bigint NOT NULL DEFAULT 177640100,
    "durationDefaultModelAndDefaultPersist" bigint NOT NULL DEFAULT 177640100
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_model" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultModel" bigint NOT NULL,
    "durationDefaultModelNull" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "duration_default_persist" (
    "id" bigserial PRIMARY KEY,
    "durationDefaultPersist" bigint DEFAULT 94230100
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_relation_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_relationEmptyModelItemsRelationEmptyModelId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_with_table" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default" (
    "id" bigserial PRIMARY KEY,
    "intDefault" bigint NOT NULL DEFAULT 10,
    "intDefaultNull" bigint DEFAULT 20
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_mix" (
    "id" bigserial PRIMARY KEY,
    "intDefaultAndDefaultModel" bigint NOT NULL DEFAULT 10,
    "intDefaultAndDefaultPersist" bigint NOT NULL DEFAULT 20,
    "intDefaultModelAndDefaultPersist" bigint NOT NULL DEFAULT 20
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_model" (
    "id" bigserial PRIMARY KEY,
    "intDefaultModel" bigint NOT NULL,
    "intDefaultModelNull" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "int_default_persist" (
    "id" bigserial PRIMARY KEY,
    "intDefaultPersist" bigint DEFAULT 10
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataList" json;
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataListInMap" json;
ALTER TABLE "object_with_object" ADD COLUMN "nestedDataMap" json;
--
-- ACTION CREATE TABLE
--
CREATE TABLE "relation_empty_model" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default" (
    "id" bigserial PRIMARY KEY,
    "stringDefault" text NOT NULL DEFAULT 'This is a default value'::text,
    "stringDefaultNull" text DEFAULT 'This is a default null value'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default_mix" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultAndDefaultModel" text NOT NULL DEFAULT 'This is a default value'::text,
    "stringDefaultAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value'::text,
    "stringDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default_model" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultModel" text NOT NULL,
    "stringDefaultModelNull" text NOT NULL
);

--
-- ACTION CREATE TABLE
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
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultRandom" uuid NOT NULL DEFAULT gen_random_uuid(),
    "uuidDefaultRandomNull" uuid DEFAULT gen_random_uuid(),
    "uuidDefaultStr" uuid NOT NULL DEFAULT '550e8400-e29b-41d4-a716-446655440000'::uuid,
    "uuidDefaultStrNull" uuid DEFAULT '3f2504e0-4f89-11d3-9a0c-0305e82c3301'::uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_mix" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultAndDefaultModel" uuid NOT NULL DEFAULT '3f2504e0-4f89-11d3-9a0c-0305e82c3301'::uuid,
    "uuidDefaultAndDefaultPersist" uuid NOT NULL DEFAULT '9e107d9d-372b-4d97-9b27-2f0907d0b1d4'::uuid,
    "uuidDefaultModelAndDefaultPersist" uuid NOT NULL DEFAULT 'f47ac10b-58cc-4372-a567-0e02b2c3d479'::uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_model" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultModelRandom" uuid NOT NULL,
    "uuidDefaultModelRandomNull" uuid,
    "uuidDefaultModelStr" uuid NOT NULL,
    "uuidDefaultModelStrNull" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "uuid_default_persist" (
    "id" bigserial PRIMARY KEY,
    "uuidDefaultPersistRandom" uuid DEFAULT gen_random_uuid(),
    "uuidDefaultPersistStr" uuid DEFAULT '550e8400-e29b-41d4-a716-446655440000'::uuid
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_user_info" ALTER COLUMN "userName" DROP NOT NULL;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "empty_model_relation_item"
    ADD CONSTRAINT "empty_model_relation_item_fk_0"
    FOREIGN KEY("_relationEmptyModelItemsRelationEmptyModelId")
    REFERENCES "relation_empty_model"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240826150228261', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240826150228261', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20240115074247714', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240115074247714', "timestamp" = now();


COMMIT;
