BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250819112047487', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819112047487', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250819085019410-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085019410-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250819085035321-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085035321-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20250819085113146-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085113146-v3-0-0', "timestamp" = now();


COMMIT;
