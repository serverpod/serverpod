BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "scheduling" json;

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20260407154808499', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154808499', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260407154349528', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260407154349528', "timestamp" = now();


COMMIT;
