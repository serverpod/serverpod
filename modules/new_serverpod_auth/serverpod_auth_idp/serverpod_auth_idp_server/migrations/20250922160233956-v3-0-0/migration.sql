BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "serverpod_auth_idp_passkey_account" DROP COLUMN "publicKey";
ALTER TABLE "serverpod_auth_idp_passkey_account" DROP COLUMN "publicKeyAlgorithm";
ALTER TABLE "serverpod_auth_idp_passkey_account" DROP COLUMN "authenticatorData";

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20250922160233956-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250922160233956-v3-0-0', "timestamp" = now();

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
    VALUES ('serverpod_auth_core', '20250825102357155-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102357155-v3-0-0', "timestamp" = now();


COMMIT;
