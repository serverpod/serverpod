BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "author" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "blocked" (
    "id" serial PRIMARY KEY,
    "blockerId" integer NOT NULL,
    "blockeeId" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "blocked_blocker_blockee_idx" ON "blocked" USING btree ("blockerId", "blockeeId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "posts" (
    "id" serial PRIMARY KEY,
    "text" text NOT NULL,
    "authorId" integer NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "blocked"
    ADD CONSTRAINT "blocked_fk_0"
    FOREIGN KEY("blockerId")
    REFERENCES "author"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "blocked"
    ADD CONSTRAINT "blocked_fk_1"
    FOREIGN KEY("blockeeId")
    REFERENCES "author"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "posts"
    ADD CONSTRAINT "posts_fk_0"
    FOREIGN KEY("authorId")
    REFERENCES "author"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230928122659', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230928122659', "priority" = 2;


COMMIT;
