BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_enum_enhanced" (
    "id" bigserial PRIMARY KEY,
    "byIndex" bigint NOT NULL,
    "nullableByIndex" bigint,
    "byIndexList" json NOT NULL,
    "byName" text NOT NULL,
    "nullableByName" text,
    "byNameList" json NOT NULL
);


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20260113215648513', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260113215648513', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

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
    VALUES ('serverpod_test_module', '20251208110450074-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110450074-v3-0-0', "timestamp" = now();


COMMIT;
