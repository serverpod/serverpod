BEGIN;

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
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240717082453257', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240717082453257', "timestamp" = now();

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
