BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default" (
    "id" bigserial PRIMARY KEY,
    "decimalDefault" decimal NOT NULL DEFAULT 10.5,
    "decimalDefaultNull" decimal DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_mix" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultAndDefaultModel" decimal NOT NULL DEFAULT 10.5,
    "decimalDefaultAndDefaultPersist" decimal NOT NULL DEFAULT 20.5,
    "decimalDefaultModelAndDefaultPersist" decimal NOT NULL DEFAULT 20.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_model" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultModelStr" decimal NOT NULL,
    "decimalDefaultModelStrNull" decimal
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "decimal_default_persist" (
    "id" bigserial PRIMARY KEY,
    "decimalDefaultPersist" decimal DEFAULT 10.5
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_decimal" (
    "id" bigserial PRIMARY KEY,
    "decimalValue" decimal NOT NULL,
    "decimalValueNull" decimal
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_decimal_precision" (
    "id" bigserial PRIMARY KEY,
    "price" decimal(10,2) NOT NULL,
    "priceNullable" decimal(10,2),
    "quantity" decimal(19,4) NOT NULL,
    "unbounded" decimal NOT NULL,
    "priceWithDefault" decimal(10,2) NOT NULL DEFAULT 9.99,
    "priceWithDefaultNullable" decimal(10,2) DEFAULT 1.23,
    "quantityWithDefault" decimal(19,4) NOT NULL DEFAULT 100.0000
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260419095309750-decimal-precision-defaults', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260419095309750-decimal-precision-defaults', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260416151914983-insights-perf', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260416151914983-insights-perf', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417182239578', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182239578', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260417182416941', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417182416941', "timestamp" = now();


COMMIT;
