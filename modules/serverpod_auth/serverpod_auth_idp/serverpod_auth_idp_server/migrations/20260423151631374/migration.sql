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
-- MIGRATION VERSION FOR serverpod_auth_idp
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_idp', '20260423151631374', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423151631374', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20260423151529622', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423151529622', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth_core
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth_core', '20260423151622514', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20260423151622514', "timestamp" = now();


COMMIT;
