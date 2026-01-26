import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class QueryTransactionDto {
  @IsString()
  @IsOptional()
  monthYear?: string;

  @IsString()
  @IsOptional()
  year?: string;

  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;

  @IsString()
  @IsOptional()
  catId?: string;
}
