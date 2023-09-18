BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "migrated_table_2" (
    "id" serial PRIMARY KEY,
    "anInt" integer NOT NULL,
    "aString" text,
    "aNonNullString" text NOT NULL
);

-- Indexes
CREATE INDEX "migrated_table_2_idx" ON "migrated_table_2" USING hash ("aNonNullString");

--
-- ACTION CREATE FOREIGN KEY
--

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115707-6', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115707-6', "priority" = 2;


COMMIT;
