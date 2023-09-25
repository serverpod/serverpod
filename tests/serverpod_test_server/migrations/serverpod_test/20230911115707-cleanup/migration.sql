BEGIN;

--
-- ACTION DROP TABLE
--
DROP TABLE "migrated_table_2" CASCADE;

--
-- ACTION DROP TABLE
--
DROP TABLE "migrated_table" CASCADE;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115707-cleanup', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115707-cleanup', "priority" = 2;


COMMIT;
