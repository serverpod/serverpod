BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "serverpod_reactive_db_call" (
    "id" bigserial PRIMARY KEY,
    "handlerName" text NOT NULL,
    "sourceTable" text NOT NULL,
    "operation" text NOT NULL,
    "rowData" text NOT NULL,
    "createdAt" timestamp without time zone NOT NULL,
    "futureCallEntryId" bigint
);

-- Indexes
CREATE INDEX "serverpod_reactive_db_call_created_at_idx" ON "serverpod_reactive_db_call" USING btree ("createdAt");
CREATE INDEX "serverpod_reactive_db_call_handler_name_idx" ON "serverpod_reactive_db_call" USING btree ("handlerName");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "serverpod_reactive_db_call"
    ADD CONSTRAINT "serverpod_reactive_db_call_fk_0"
    FOREIGN KEY("futureCallEntryId")
    REFERENCES "serverpod_future_call"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_auth_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_test', '20260417204705947', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204705947', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260417204508103', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204508103', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_bridge
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_bridge', '20260417204610330', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204610330', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260417204554609', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204554609', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260417204602473', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204602473', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_migration
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_migration', '20260417204618142', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204618142', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20260417204546879', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260417204546879', "timestamp" = now();


COMMIT;
