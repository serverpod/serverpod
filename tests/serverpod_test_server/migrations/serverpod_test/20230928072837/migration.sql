BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "related_unique_data" (
    "id" serial PRIMARY KEY,
    "uniqueDataId" integer NOT NULL,
    "number" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "unique_data" (
    "id" serial PRIMARY KEY,
    "number" integer NOT NULL,
    "email" text NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "email_index_idx" ON "unique_data" USING btree ("email");

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "related_unique_data"
    ADD CONSTRAINT "related_unique_data_fk_0"
    FOREIGN KEY("uniqueDataId")
    REFERENCES "unique_data"("id")
    ON DELETE RESTRICT
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230928072837', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230928072837', "priority" = 2;


COMMIT;
