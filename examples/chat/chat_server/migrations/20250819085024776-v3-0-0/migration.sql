BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_session_log" ADD COLUMN "userId" text;

--
-- MIGRATION VERSION FOR chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('chat', '20250819085024776-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250819085024776-v3-0-0', "timestamp" = now();

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
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_chat
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_chat', '20241219152420529', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152420529', "timestamp" = now();


COMMIT;
