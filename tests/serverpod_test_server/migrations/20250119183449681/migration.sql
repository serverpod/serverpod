BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "address_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "street" text NOT NULL,
    "inhabitantId" bigint
);

-- Indexes
CREATE UNIQUE INDEX "inhabitant_uuid_index_idx" ON "address_uuid" USING btree ("inhabitantId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "arena_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "changed_id_type_self" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "nextId" uuid,
    "parentId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "changed_id_type_self_next_unique_idx" ON "changed_id_type_self" USING btree ("nextId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" uuid NOT NULL,
    "oldCompanyId" uuid
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "comment_int" (
    "id" bigserial PRIMARY KEY,
    "description" text NOT NULL,
    "orderId" uuid NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "company_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "townId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "course_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "customer_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "enrollment_int" (
    "id" bigserial PRIMARY KEY,
    "studentId" uuid NOT NULL,
    "courseId" uuid NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_int_index_idx" ON "enrollment_int" USING btree ("studentId", "courseId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "order_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "description" text NOT NULL,
    "customerId" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "player_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL,
    "teamId" bigint
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student_uuid" (
    "id" uuid PRIMARY KEY DEFAULT gen_random_uuid(),
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "team_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "arenaId" uuid
);

-- Indexes
CREATE UNIQUE INDEX "arena_uuid_index_idx" ON "team_int" USING btree ("arenaId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "town_int" (
    "id" bigserial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" bigint
);

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "address_uuid"
    ADD CONSTRAINT "address_uuid_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen_int"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "changed_id_type_self"
    ADD CONSTRAINT "changed_id_type_self_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "changed_id_type_self"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "changed_id_type_self"
    ADD CONSTRAINT "changed_id_type_self_fk_1"
    FOREIGN KEY("parentId")
    REFERENCES "changed_id_type_self"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "citizen_int"
    ADD CONSTRAINT "citizen_int_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company_uuid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen_int"
    ADD CONSTRAINT "citizen_int_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company_uuid"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "comment_int"
    ADD CONSTRAINT "comment_int_fk_0"
    FOREIGN KEY("orderId")
    REFERENCES "order_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "company_uuid"
    ADD CONSTRAINT "company_uuid_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town_int"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "enrollment_int"
    ADD CONSTRAINT "enrollment_int_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "student_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment_int"
    ADD CONSTRAINT "enrollment_int_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "course_uuid"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "order_uuid"
    ADD CONSTRAINT "order_uuid_fk_0"
    FOREIGN KEY("customerId")
    REFERENCES "customer_int"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player_uuid"
    ADD CONSTRAINT "player_uuid_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team_int"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "team_int"
    ADD CONSTRAINT "team_int_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena_uuid"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "town_int"
    ADD CONSTRAINT "town_int_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen_int"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20250119183449681', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20250119183449681', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_auth
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_auth', '20240520102713718', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240520102713718', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod', '20240516151843329', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20240516151843329', "timestamp" = now();

--
-- MIGRATION VERSION FOR serverpod_test_module
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test_module', '20241219152628926', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20241219152628926', "timestamp" = now();


COMMIT;
