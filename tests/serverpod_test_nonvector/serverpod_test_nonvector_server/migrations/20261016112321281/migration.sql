BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "serializedRetryPolicy" text;
ALTER TABLE "serverpod_future_call" ADD COLUMN "failedAttempts" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR serverpod_test_nonvector
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_nonvector', '20261016112321281', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112321281', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20261016112037532', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112037532', "timestamp" = now();


COMMIT;
