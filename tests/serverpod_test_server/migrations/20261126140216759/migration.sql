BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "serializedRetryPolicy" text;
ALTER TABLE "serverpod_future_call" ADD COLUMN "failedAttempts" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20261126140216759', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261126140216759', "timestamp" = now();

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
    VALUES ('serverpod_auth', '20261016112127598', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112127598', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20261016112257306', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112257306', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_shared_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_shared_module', '20261016112309302', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112309302', "timestamp" = now();


COMMIT;
