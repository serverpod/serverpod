BEGIN;

--
-- ACTION ALTER TABLE
--
CREATE INDEX "migrated_table_index" ON "migrated_table" USING btree ("anInt");
ALTER TABLE ONLY "migrated_table"
    ADD CONSTRAINT "migrated_table_fk_0"
    FOREIGN KEY("anInt")
    REFERENCES "migrated_table"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "priority", "timestamp")
    VALUES ('serverpod_test', '20230911115707-4', 2, now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20230911115707-4', "priority" = 2;


COMMIT;
