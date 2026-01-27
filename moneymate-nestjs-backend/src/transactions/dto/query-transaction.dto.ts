import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsBoolean, IsOptional } from 'class-validator';

export class QueryTransactionDto {
  @ApiProperty({
    example: '03-2024',
    required: false,
    description: 'Format: MM-YYYY',
  })
  @IsString()
  @IsOptional()
  monthYear?: string;

  @ApiProperty({ example: '2024', required: false })
  @IsString()
  @IsOptional()
  year?: string;

  @ApiProperty({ example: false, required: false })
  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;

  @ApiProperty({
    example: '123e4567-e89b-12d3-a456-426614174000',
    required: false,
  })
  @IsString()
  @IsOptional()
  catId?: string;
}
