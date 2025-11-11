BEGIN;


--
-- MIGRATION VERSION FOR auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth', '20251110221214132', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251110221214132', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251110221030585', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251110221030585', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251106211458056', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251106211458056', "timestamp" = now();


COMMIT;
