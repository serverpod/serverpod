BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "incoming_1" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);


--
-- MIGRATION VERSION FOR test_58c75ba5_635c_4af5_8afb_ee8e33b85311
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('test_58c75ba5_635c_4af5_8afb_ee8e33b85311', '20260101131440031', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260101131440031', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20251208110333922-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110333922-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20251208110420531-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110420531-v3-0-0', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20251208110412389-v3-0-0', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251208110412389-v3-0-0', "timestamp" = now();


COMMIT;
