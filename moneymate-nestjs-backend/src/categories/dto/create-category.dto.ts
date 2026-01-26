import { IsString, IsBoolean, IsNumber, IsOptional } from 'class-validator';

export class CreateCategoryDto {
  @IsString()
  icon: string;

  @IsString()
  name: string;

  @IsBoolean()
  isIncome: boolean;

  @IsNumber()
  @IsOptional()
  limit?: number;
}
