BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_decimal" (
    "id" bigserial PRIMARY KEY,
    "notNullableDecimal" numeric NOT NULL,
    "nullableDecimal" numeric,
    "highPrecisionDecimal" numeric NOT NULL
);

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260325033836795', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260325033836795', "timestamp" = now();

COMMIT;
