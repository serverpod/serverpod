BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "serializedRetryPolicy" text;
ALTER TABLE "serverpod_future_call" ADD COLUMN "failedAttempts" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR auth_example
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth_example', '20261016112115073', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112115073', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20261016112037532', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112037532', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260824182343939', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260824182343939', "timestamp" = now();


COMMIT;
