BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "model_with_required_field" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "email" text,
    "phone" text
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250912064259430', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250912064259430', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20250825102336032-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102336032-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20250825102351908-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102351908-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20250825102429343-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250825102429343-v3-0-0', "timestamp" = now();


COMMIT;
