BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_email_account_request" ADD COLUMN "completeAccountCreationChallengeId" uuid;
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_auth_idp_email_account_request"
    ADD CONSTRAINT "serverpod_auth_idp_email_account_request_fk_1"
    FOREIGN KEY("completeAccountCreationChallengeId")
    REFERENCES "serverpod_auth_idp_secret_challenge"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251107102525321', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251107102525321', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251106211458056', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211458056', "timestamp" = now();


COMMIT;
