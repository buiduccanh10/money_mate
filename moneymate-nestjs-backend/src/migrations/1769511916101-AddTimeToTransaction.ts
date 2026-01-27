import { MigrationInterface, QueryRunner } from 'typeorm';

export class AddTimeToTransaction1769511916101 implements MigrationInterface {
  name = 'AddTimeToTransaction1769511916101';

  public async up(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(
      `ALTER TABLE "transactions" ADD "time" character varying NOT NULL DEFAULT '00:00'`,
    );
  }

  public async down(queryRunner: QueryRunner): Promise<void> {
    await queryRunner.query(`ALTER TABLE "transactions" DROP COLUMN "time"`);
  }
}
