BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment" (
    "id" serial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order" (
    "id" serial PRIMARY KEY,
    "description" text NOT NULL,
    "customerId" integer NOT NULL
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment"
    ADD CONSTRAINT "comment_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order"
    ADD CONSTRAINT "order_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20231009130339', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231009130339', "priority" = 2;


COMMIT;
