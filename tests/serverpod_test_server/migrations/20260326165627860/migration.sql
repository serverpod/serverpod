BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default" (
    "id" bigserial PRIMARY KEY,
    "decimalDefault" numeric NOT NULL DEFAULT 10.5,
    "decimalDefaultNull" numeric DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_mix" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultAndDefaultModel" numeric NOT NULL DEFAULT 10.5,
    "decimalDefaultAndDefaultPersist" numeric NOT NULL DEFAULT 20.5,
    "decimalDefaultModelAndDefaultPersist" numeric NOT NULL DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_model" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultModelStr" numeric NOT NULL,
    "decimalDefaultModelStrNull" numeric
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_persist" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultPersist" numeric DEFAULT 10.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_decimal" (
    "id" bigserial PRIMARY KEY,
    "decimalValue" numeric NOT NULL,
    "decimalValueNull" numeric
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260326165627860', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260326165627860', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260129180959368', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129180959368', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260129181059877', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181059877', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260129181225792', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260129181225792', "timestamp" = now();


COMMIT;
