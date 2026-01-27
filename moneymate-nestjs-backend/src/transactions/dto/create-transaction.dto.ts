import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';

export class CreateTransactionDto {
  @ApiProperty({ example: '2024-03-20' })
  @IsString()
  date: string;

  @ApiProperty({ example: 'Buy coffee', required: false })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 50000 })
  @IsNumber()
  money: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  @IsString()
  catId: string;

  @ApiProperty({ example: false })
  @IsBoolean()
  isIncome: boolean;

  @ApiProperty({ example: '14:30', required: false })
  @IsString()
  @IsOptional()
  time?: string;
}
