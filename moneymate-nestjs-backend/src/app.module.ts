import { MiddlewareConsumer, Module, NestModule } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { ThrottlerModule } from '@nestjs/throttler';
import { CacheModule } from '@nestjs/cache-manager';
import { APP_GUARD } from '@nestjs/core';
import { ThrottlerGuard } from '@nestjs/throttler';

import { AuthModule } from './auth/auth.module';
import { UsersModule } from './users/users.module';
import { CategoriesModule } from './categories/categories.module';
import { TransactionsModule } from './transactions/transactions.module';
import { SchedulesModule } from './schedules/schedules.module';
import { SupabaseModule } from './supabase/supabase.module';

import { IdempotencyMiddleware } from './common/middleware/idempotency.middleware';

import {
  User,
  Category,
  Transaction,
  Schedule,
  RefreshToken,
} from './entities';

@Module({
  imports: [
    // Configuration
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: '.env',
    }),

    // Database (Supabase PostgreSQL)
    TypeOrmModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        type: 'postgres',
        url: configService.get('DATABASE_URL'),
        entities: [User, Category, Transaction, Schedule, RefreshToken],
        synchronize: false,
        ssl:
          configService.get('NODE_ENV') === 'production'
            ? { rejectUnauthorized: false }
            : false,
      }),
      inject: [ConfigService],
    }),

    // Rate Limiting
    ThrottlerModule.forRootAsync({
      imports: [ConfigModule],
      useFactory: (configService: ConfigService) => ({
        throttlers: [
          {
            ttl: parseInt(configService.get('THROTTLE_TTL') || '60000'),
            limit: parseInt(configService.get('THROTTLE_LIMIT') || '100'),
          },
        ],
      }),
      inject: [ConfigService],
    }),

    // Caching (for idempotency)
    CacheModule.register({
      isGlobal: true,
      ttl: 86400000, // 24 hours in ms
    }),

    // Feature Modules
    AuthModule,
    UsersModule,
    CategoriesModule,
    TransactionsModule,
    SchedulesModule,
    SupabaseModule,
  ],
  providers: [
    // Global Rate Limiting Guard
    {
      provide: APP_GUARD,
      useClass: ThrottlerGuard,
    },
  ],
})
export class AppModule implements NestModule {
  configure(consumer: MiddlewareConsumer) {
    // Apply idempotency middleware to all routes
    consumer.apply(IdempotencyMiddleware).forRoutes('*');
  }
}
