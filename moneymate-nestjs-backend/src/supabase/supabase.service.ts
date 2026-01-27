import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, SupabaseClient } from '@supabase/supabase-js';

@Injectable()
export class SupabaseService implements OnModuleInit {
  private readonly logger = new Logger(SupabaseService.name);
  private supabase!: ReturnType<typeof createClient>;
  private isInitialized = false;

  constructor(private readonly configService: ConfigService) {}

  onModuleInit() {
    this.initClient();
  }

  private initClient(): void {
    if (this.isInitialized) {
      return;
    }

    const supabaseUrl = this.configService.get<string>('SUPABASE_URL');
    const supabaseServiceKey = this.configService.get<string>(
      'SUPABASE_SERVICE_KEY',
    );

    if (!supabaseUrl || !supabaseServiceKey) {
      this.logger.warn(
        'Supabase credentials not configured. Storage features will not work.',
      );
      this.isInitialized = true;
      return;
    }

    this.supabase = createClient(supabaseUrl, supabaseServiceKey, {
      auth: {
        autoRefreshToken: false,
        persistSession: false,
      },
    });

    this.isInitialized = true;
    this.logger.log('Supabase client initialized successfully');
  }

  getClient(): ReturnType<typeof createClient> {
    if (!this.supabase) {
      throw new Error(
        'Supabase client is not initialized. Please check SUPABASE_URL and SUPABASE_SERVICE_ROLE_KEY environment variables.',
      );
    }
    return this.supabase;
  }

  isAvailable(): boolean {
    return this.supabase !== null;
  }

  getStorage(
    bucketName: string,
  ): ReturnType<SupabaseClient['storage']['from']> {
    return this.getClient().storage.from(bucketName);
  }
}
