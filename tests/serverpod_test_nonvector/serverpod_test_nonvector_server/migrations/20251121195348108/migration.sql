BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;

--
-- MIGRATION VERSION FOR serverpod_test_nonvector
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_nonvector', '20251121195348108', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251121195348108', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251121195126312', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251121195126312', "timestamp" = now();


COMMIT;
