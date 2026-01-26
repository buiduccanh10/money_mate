import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';

export class CreateTransactionDto {
  @IsString()
  date: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  money: number;

  @IsString()
  catId: string;

  @IsBoolean()
  isIncome: boolean;
}
