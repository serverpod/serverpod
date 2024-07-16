BEGIN;

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
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20240716094230862', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240716094230862', "timestamp" = now();

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
