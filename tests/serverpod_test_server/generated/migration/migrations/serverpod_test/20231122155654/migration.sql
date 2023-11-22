BEGIN;

--
-- ACTION CREATE TABLE
--
CREATE TABLE "address" (
    "id" serial PRIMARY KEY,
    "street" text NOT NULL,
    "inhabitantId" integer
);

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
CREATE TABLE "blocking" (
    "id" serial PRIMARY KEY,
    "blockedId" integer NOT NULL,
    "blockedById" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "blocking_blocked_unique_idx" ON "blocking" USING btree ("blockedId", "blockedById");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "cat" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "motherId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "citizen" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "companyId" integer NOT NULL,
    "oldCompanyId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "city" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

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
CREATE TABLE "company" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "townId" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "course" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
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
CREATE TABLE "enrollment" (
    "id" serial PRIMARY KEY,
    "studentId" integer NOT NULL,
    "courseId" integer NOT NULL
);

-- Indexes
CREATE UNIQUE INDEX "enrollment_index_idx" ON "enrollment" USING btree ("studentId", "courseId");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "member" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_field_scopes" (
    "id" serial PRIMARY KEY,
    "normal" text NOT NULL,
    "database" text
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_bytedata" (
    "id" serial PRIMARY KEY,
    "byteData" bytea NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_duration" (
    "id" serial PRIMARY KEY,
    "duration" bigint NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_enum" (
    "id" serial PRIMARY KEY,
    "testEnum" integer NOT NULL,
    "nullableEnum" integer,
    "enumList" json NOT NULL,
    "nullableEnumList" json NOT NULL,
    "enumListList" json NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_index" (
    "id" serial PRIMARY KEY,
    "indexed" integer NOT NULL,
    "indexed2" integer NOT NULL
);

-- Indexes
CREATE INDEX "object_with_index_test_index" ON "object_with_index" USING brin ("indexed", "indexed2");

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_object" (
    "id" serial PRIMARY KEY,
    "data" json NOT NULL,
    "nullableData" json,
    "dataList" json NOT NULL,
    "nullableDataList" json,
    "listWithNullableData" json NOT NULL,
    "nullableListWithNullableData" json
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_parent" (
    "id" serial PRIMARY KEY,
    "other" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_self_parent" (
    "id" serial PRIMARY KEY,
    "other" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "object_with_uuid" (
    "id" serial PRIMARY KEY,
    "uuid" uuid NOT NULL,
    "uuidNullable" uuid
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
-- ACTION CREATE TABLE
--
CREATE TABLE "organization" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "cityId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "person" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "organizationId" integer,
    "_cityCitizensCityId" integer
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
CREATE TABLE "post" (
    "id" serial PRIMARY KEY,
    "content" text NOT NULL,
    "nextId" integer
);

-- Indexes
CREATE UNIQUE INDEX "next_unique_idx" ON "post" USING btree ("nextId");

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
CREATE TABLE "simple_data" (
    "id" serial PRIMARY KEY,
    "num" integer NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "simple_date_time" (
    "id" serial PRIMARY KEY,
    "dateTime" timestamp without time zone NOT NULL
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "student" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL
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
-- ACTION CREATE TABLE
--
CREATE TABLE "town" (
    "id" serial PRIMARY KEY,
    "name" text NOT NULL,
    "mayorId" integer
);

--
-- ACTION CREATE TABLE
--
CREATE TABLE "types" (
    "id" serial PRIMARY KEY,
    "anInt" integer,
    "aBool" boolean,
    "aDouble" double precision,
    "aDateTime" timestamp without time zone,
    "aString" text,
    "aByteData" bytea,
    "aDuration" bigint,
    "aUuid" uuid,
    "anEnum" integer,
    "aStringifiedEnum" text
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
ALTER TABLE ONLY "address"
    ADD CONSTRAINT "address_fk_0"
    FOREIGN KEY("inhabitantId")
    REFERENCES "citizen"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_0"
    FOREIGN KEY("blockedId")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "blocking"
    ADD CONSTRAINT "blocking_fk_1"
    FOREIGN KEY("blockedById")
    REFERENCES "member"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "cat"
    ADD CONSTRAINT "cat_fk_0"
    FOREIGN KEY("motherId")
    REFERENCES "cat"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_0"
    FOREIGN KEY("companyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "citizen"
    ADD CONSTRAINT "citizen_fk_1"
    FOREIGN KEY("oldCompanyId")
    REFERENCES "company"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

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
ALTER TABLE ONLY "company"
    ADD CONSTRAINT "company_fk_0"
    FOREIGN KEY("townId")
    REFERENCES "town"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_0"
    FOREIGN KEY("studentId")
    REFERENCES "student"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "enrollment"
    ADD CONSTRAINT "enrollment_fk_1"
    FOREIGN KEY("courseId")
    REFERENCES "course"("id")
    ON DELETE CASCADE
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "object_with_parent"
    ADD CONSTRAINT "object_with_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_field_scopes"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "object_with_self_parent"
    ADD CONSTRAINT "object_with_self_parent_fk_0"
    FOREIGN KEY("other")
    REFERENCES "object_with_self_parent"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

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
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "organization"
    ADD CONSTRAINT "organization_fk_0"
    FOREIGN KEY("cityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_0"
    FOREIGN KEY("organizationId")
    REFERENCES "organization"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
ALTER TABLE ONLY "person"
    ADD CONSTRAINT "person_fk_1"
    FOREIGN KEY("_cityCitizensCityId")
    REFERENCES "city"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "player"
    ADD CONSTRAINT "player_fk_0"
    FOREIGN KEY("teamId")
    REFERENCES "team"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "post"
    ADD CONSTRAINT "post_fk_0"
    FOREIGN KEY("nextId")
    REFERENCES "post"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

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
ALTER TABLE ONLY "team"
    ADD CONSTRAINT "team_fk_0"
    FOREIGN KEY("arenaId")
    REFERENCES "arena"("id")
    ON DELETE SET NULL
    ON UPDATE NO ACTION;

--
-- ACTION CREATE FOREIGN KEY
--
ALTER TABLE ONLY "town"
    ADD CONSTRAINT "town_fk_0"
    FOREIGN KEY("mayorId")
    REFERENCES "citizen"("id")
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;


--
-- MIGRATION VERSION FOR serverpod_test
--
INSERT INTO "serverpod_migrations" ("module", "version", "timestamp")
    VALUES ('serverpod_test', '20231122155654', now())
    ON CONFLICT ("module")
    DO UPDATE SET "version" = '20231122155654', "timestamp" = now();


COMMIT;
