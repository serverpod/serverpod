BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "migrated_table" ADD COLUMN "aString" text;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115706-2', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115706-2', "priority" = 2;


COMMIT;
