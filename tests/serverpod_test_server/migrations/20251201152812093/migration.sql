BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "child_table_with_inherited_id_base_index" ON "child_table_with_inherited_id" USING btree ("grandParentField");

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251201152812093', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251201152812093', "timestamp" = now();

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
