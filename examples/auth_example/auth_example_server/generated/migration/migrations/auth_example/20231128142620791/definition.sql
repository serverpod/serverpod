BEGIN;

--
-- MIGRATION VERSION FOR auth_example
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth_example', '20231128142620791', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231128142620791', "timestamp" = now();


COMMIT;
