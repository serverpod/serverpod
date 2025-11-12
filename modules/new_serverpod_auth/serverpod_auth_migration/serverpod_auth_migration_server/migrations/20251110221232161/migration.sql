BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_request" DROP COLUMN "passwordHash";
ALTER TABLE "serverpod_auth_idp_email_account_request" DROP COLUMN "passwordSalt";
ALTER TABLE "serverpod_auth_idp_email_account_request" DROP COLUMN "verifiedAt";
ALTER TABLE "serverpod_auth_idp_email_account_request" ADD COLUMN "createAccountChallengeId" uuid;
--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_request_completion" DROP CONSTRAINT "serverpod_auth_idp_email_account_request_completion_fk_0";
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("createAccountChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20251110221232161', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251110221232161', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20251106211509125', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211509125', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251106211458056', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211458056', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251110221030585', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251110221030585', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();


COMMIT;
