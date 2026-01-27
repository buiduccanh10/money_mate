import { ApiProperty } from '@nestjs/swagger';
import {
  IsString,
  IsNumber,
  IsBoolean,
  IsOptional,
  IsEnum,
} from 'class-validator';
import { ScheduleOption } from '../../entities/schedule.entity';

export class CreateScheduleDto {
  @ApiProperty({ example: '2024-03-20' })
  @IsString()
  date: string;

  @ApiProperty({ example: 'Monthly rent', required: false })
  @IsString()
  @IsOptional()
  description?: string;

  @ApiProperty({ example: 5000000 })
  @IsNumber()
  money: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  @IsString()
  catId: string;

  @ApiProperty({ example: '🏠' })
  @IsString()
  icon: string;

  @ApiProperty({ example: 'Rent' })
  @IsString()
  name: string;

  @ApiProperty({ example: false })
  @IsBoolean()
  isIncome: boolean;

  @ApiProperty({ enum: ScheduleOption, example: ScheduleOption.MONTHLY })
  @IsEnum(ScheduleOption)
  option: ScheduleOption;
}
