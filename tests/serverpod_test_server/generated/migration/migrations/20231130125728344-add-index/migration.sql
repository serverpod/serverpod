BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "migrated_table_index" ON "migrated_table" USING btree ("anInt");

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20231130125728344-add-index', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231130125728344-add-index', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20231130122108191', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231130122108191', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20231130122049046', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231130122049046', "timestamp" = now();


COMMIT;
