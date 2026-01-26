import { IsString, IsBoolean, IsNumber, IsOptional } from 'class-validator';

export class UpdateCategoryDto {
  @IsString()
  @IsOptional()
  icon?: string;

  @IsString()
  @IsOptional()
  name?: string;

  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;

  @IsNumber()
  @IsOptional()
  limit?: number;
}
