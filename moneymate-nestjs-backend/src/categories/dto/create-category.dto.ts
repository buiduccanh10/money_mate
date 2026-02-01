import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsBoolean,
  IsNumber,
  IsOptional,
  IsEnum,
} from 'class-validator';
import { LimitType } from '../../entities/category.entity';

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

  @ApiProperty({ enum: LimitType, required: false, default: LimitType.MONTHLY })
  @IsEnum(LimitType)
  @IsOptional()
  limitType?: LimitType;
}
