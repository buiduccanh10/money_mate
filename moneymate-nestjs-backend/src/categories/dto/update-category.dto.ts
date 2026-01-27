import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsBoolean, IsNumber, IsOptional } from 'class-validator';

export class UpdateCategoryDto {
  @ApiProperty({ example: '🍔', required: false })
  @IsString()
  @IsOptional()
  icon?: string;

  @ApiProperty({ example: 'Food', required: false })
  @IsString()
  @IsOptional()
  name?: string;

  @ApiProperty({ example: false, required: false })
  @IsBoolean()
  @IsOptional()
  isIncome?: boolean;

  @ApiProperty({ example: 1000000, required: false })
  @IsNumber()
  @IsOptional()
  limit?: number;
}
