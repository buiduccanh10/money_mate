import { DataSource, DataSourceOptions } from 'typeorm';
import { config } from 'dotenv';
import {
  User,
  Category,
  Transaction,
  Schedule,
  RefreshToken,
} from '../entities';

config();

export const dataSourceOptions: DataSourceOptions = {
  type: 'postgres',
  url: process.env.DATABASE_URL,
  entities: [User, Category, Transaction, Schedule, RefreshToken],
  migrations: ['dist/migrations/*.js'],
  synchronize: false,
  ssl:
    process.env.NODE_ENV === 'production'
      ? { rejectUnauthorized: false }
      : false,
};

const dataSource = new DataSource(dataSourceOptions);
export default dataSource;
