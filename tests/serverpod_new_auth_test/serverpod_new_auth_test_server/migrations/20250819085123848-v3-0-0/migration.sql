BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;

--
-- MIGRATION VERSION FOR serverpod_new_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_new_auth_test', '20250819085123848-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085123848-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250819085019410-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085019410-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20250819085056855-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085056855-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20250819085051459-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085051459-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20250819085046017-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085046017-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20250819085040657-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085040657-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250819085035321-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085035321-v3-0-0', "timestamp" = now();


COMMIT;
