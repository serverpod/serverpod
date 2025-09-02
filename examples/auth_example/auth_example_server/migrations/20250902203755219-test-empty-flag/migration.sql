BEGIN;


--
-- MIGRATION VERSION FOR auth_example
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('auth_example', '20250902203755219-test-empty-flag', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250902203755219-test-empty-flag', "timestamp" = now();

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


COMMIT;
