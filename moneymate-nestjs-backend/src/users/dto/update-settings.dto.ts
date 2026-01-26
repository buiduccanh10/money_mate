import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class UpdateSettingsDto {
  @IsString()
  @IsOptional()
  language?: string;

  @IsBoolean()
  @IsOptional()
  isDark?: boolean;

  @IsBoolean()
  @IsOptional()
  isLock?: boolean;
}
