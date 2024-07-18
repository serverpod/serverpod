BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default" (
    "id" bigserial PRIMARY KEY,
    "stringDefault" text NOT NULL DEFAULT 'This is a default value',
    "stringDefaultNull" text DEFAULT 'This is a default null value'
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "string_default_mix" (
    "id" bigserial PRIMARY KEY,
    "stringDefaultAndDefaultModel" text NOT NULL DEFAULT 'This is a default value',
    "stringDefaultAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value',
    "stringDefaultModelAndDefaultPersist" text NOT NULL DEFAULT 'This is a default persist value'
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
    "stringDefaultPersist" text DEFAULT 'This is a default persist value'
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240718113327281', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240718113327281', "timestamp" = now();

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
