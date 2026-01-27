import { ApiProperty } from '@nestjs/swagger';
import { IsString, IsBoolean, IsNumber, IsOptional } from 'class-validator';

export class CreateCategoryDto {
  @ApiProperty({ example: '🍔' })
  @IsString()
  icon: string;

  @ApiProperty({ example: 'Food' })
  @IsString()
  name: string;

  @ApiProperty({ example: false })
  @IsBoolean()
  isIncome: boolean;

  @ApiProperty({ example: 1000000, required: false })
  @IsNumber()
  @IsOptional()
  limit?: number;
}
