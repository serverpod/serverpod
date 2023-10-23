BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "arena" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "teamId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "team" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" integer
);

--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player"
    ADD CONSTRAINT "player_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "team"
    ADD CONSTRAINT "team_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20231023134208', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231023134208', "priority" = 2;


COMMIT;
