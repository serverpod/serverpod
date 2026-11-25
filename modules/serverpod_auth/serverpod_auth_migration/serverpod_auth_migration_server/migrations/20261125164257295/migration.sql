BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_future_call" ADD COLUMN "serializedRetryPolicy" text;
ALTER TABLE "serverpod_future_call" ADD COLUMN "failedAttempts" bigint NOT NULL DEFAULT 0;

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20261125164257295', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261125164257295', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20261016112037532', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112037532', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20261125164245337', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261125164245337', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20261016112140362', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112140362', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20261125164232178', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261125164232178', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20261016112127598', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20261016112127598', "timestamp" = now();


COMMIT;
