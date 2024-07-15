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
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240715115639695', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240715115639695', "timestamp" = now();

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
