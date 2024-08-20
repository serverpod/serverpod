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
CREATE TABLE "empty_model" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "empty_model_relation_item" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "_emptyModelItemsEmptyModelId" bigint
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
    "stringDefaultPersist" text DEFAULT 'This is a default persist value'::text
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
    FOREIGN KEY("_emptyModelItemsEmptyModelId")
    REFERENCES "empty_model"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240819060257252', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240819060257252', "timestamp" = now();

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
