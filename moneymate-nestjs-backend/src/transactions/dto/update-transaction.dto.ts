import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';

export class UpdateTransactionDto {
  @IsString()
  @IsOptional()
  date?: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  @IsOptional()
  money?: number;

  @IsString()
  @IsOptional()
  catId?: string;

  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;
}
