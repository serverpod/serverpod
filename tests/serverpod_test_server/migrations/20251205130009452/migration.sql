BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "partitioned_hash_method" (
    "id" bigserial PRIMARY KEY,
    "userId" bigint NOT NULL,
    "data" text NOT NULL
) PARTITION BY HASH ("userId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "partitioned_list_method" (
    "id" bigserial PRIMARY KEY,
    "category" text NOT NULL,
    "name" text NOT NULL,
    "value" bigint NOT NULL
) PARTITION BY LIST ("category");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "partitioned_multi_column" (
    "id" bigserial PRIMARY KEY,
    "source" text NOT NULL,
    "category" text NOT NULL,
    "value" bigint NOT NULL
) PARTITION BY LIST ("source", "category");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "partitioned_range_method" (
    "id" bigserial PRIMARY KEY,
    "createdAt" timestamp without time zone NOT NULL,
    "value" bigint NOT NULL
) PARTITION BY RANGE ("createdAt");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "partitioned_simple" (
    "id" bigserial PRIMARY KEY,
    "source" text NOT NULL,
    "value" bigint NOT NULL
) PARTITION BY LIST ("source");


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251205130009452', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251205130009452', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20250825102429343-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102429343-v3-0-0', "timestamp" = now();


COMMIT;
