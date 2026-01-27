import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';

export class UpdateTransactionDto {
  @ApiProperty({ example: '2024-03-20', required: false })
  @IsString()
  @IsOptional()
  date?: string;

  @ApiProperty({ example: 'Buy coffee', required: false })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 50000, required: false })
  @IsNumber()
  @IsOptional()
  money?: number;

  @ApiProperty({
    example: '123e4567-e89b-12d3-a456-426614174000',
    required: false,
  })
  @IsString()
  @IsOptional()
  catId?: string;

  @ApiProperty({ example: false, required: false })
  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;

  @ApiProperty({ example: '14:30', required: false })
  @IsString()
  @IsOptional()
  time?: string;
}
