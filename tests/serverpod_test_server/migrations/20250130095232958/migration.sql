BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default" (
    "id" bigserial PRIMARY KEY,
    "bigintDefaultStr" text NOT NULL DEFAULT '-1234567890123456789099999999'::text,
    "bigintDefaultStrNull" text DEFAULT '1234567890123456789099999999'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_mix" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultAndDefaultModel" text NOT NULL DEFAULT '1'::text,
    "bigIntDefaultAndDefaultPersist" text NOT NULL DEFAULT '12345678901234567890'::text,
    "bigIntDefaultModelAndDefaultPersist" text NOT NULL DEFAULT '-1234567890123456789099999999'::text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_model" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultModelStr" text NOT NULL,
    "bigIntDefaultModelStrNull" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "bigint_default_persist" (
    "id" bigserial PRIMARY KEY,
    "bigIntDefaultPersistStr" text DEFAULT '1234567890123456789099999999'::text
);

--
-- ACTION ALTER TABLE
--
ALTER TABLE "types" ADD COLUMN "aBigInt" text;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250130095232958', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250130095232958', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
