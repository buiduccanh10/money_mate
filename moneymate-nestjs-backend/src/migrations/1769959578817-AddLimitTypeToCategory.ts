import { MigrationInterface, QueryRunner } from "typeorm";

export class AddLimitTypeToCategory1769959578817 implements MigrationInterface {
    name = 'AddLimitTypeToCategory1769959578817'

    public async up(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`CREATE TYPE "public"."categories_limittype_enum" AS ENUM('DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY')`);
        await queryRunner.query(`ALTER TABLE "categories" ADD "limitType" "public"."categories_limittype_enum" NOT NULL DEFAULT 'MONTHLY'`);
    }

    public async down(queryRunner: QueryRunner): Promise<void> {
        await queryRunner.query(`ALTER TABLE "categories" DROP COLUMN "limitType"`);
        await queryRunner.query(`DROP TYPE "public"."categories_limittype_enum"`);
    }

}
