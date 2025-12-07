BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "child_entity" (
    "id" bigserial PRIMARY KEY,
    "sharedField" text NOT NULL,
    "localField" text NOT NULL,
    "_parentEntityChildrenParentEntityId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "parent_entity" (
    "id" bigserial PRIMARY KEY
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "child_entity"
    ADD CONSTRAINT "child_entity_fk_0"
    FOREIGN KEY("_parentEntityChildrenParentEntityId")
    REFERENCES "parent_entity"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20251204042636431', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20251204042636431', "timestamp" = now();

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
