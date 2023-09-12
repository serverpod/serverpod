BEGIN;

--
-- ACTION ALTER TABLE
--
DROP INDEX "migrated_table_index";
ALTER TABLE "migrated_table" DROP CONSTRAINT "migrated_table_fk_0";

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115707-5', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115707-5', "priority" = 2;


COMMIT;
