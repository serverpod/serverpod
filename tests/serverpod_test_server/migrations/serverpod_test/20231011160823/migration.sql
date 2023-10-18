BEGIN;

--
-- ACTION ALTER TABLE
--
ALTER TABLE "organization" ADD COLUMN "cityId" integer;
ALTER TABLE ONLY "organization"
    ADD CONSTRAINT "organization_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20231011160823', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231011160823', "priority" = 2;


COMMIT;
