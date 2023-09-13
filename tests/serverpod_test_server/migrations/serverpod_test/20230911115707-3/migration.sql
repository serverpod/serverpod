BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "migrated_table" CASCADE;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "migrated_table" (
    "id" serial PRIMARY KEY,
    "anInt" integer NOT NULL,
    "aString" text,
    "aStringWithoutDefault" text NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115707-3', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115707-3', "priority" = 2;


COMMIT;
