import { ApiProperty } from '@nestjs/swagger';
import { IsNumber, IsEnum, IsOptional } from 'class-validator';
import { LimitType } from '../../entities/category.entity';

export class UpdateLimitDto {
  @ApiProperty({ example: 1500000 })
  @IsNumber()
  limit: number;

  @ApiProperty({ enum: LimitType, required: false })
  @IsEnum(LimitType)
  @IsOptional()
  limitType?: LimitType;
}
