import {
  IsString,
  IsNumber,
  IsBoolean,
  IsOptional,
  IsEnum,
} from 'class-validator';
import { ScheduleOption } from '../../entities/schedule.entity';

export class CreateScheduleDto {
  @IsString()
  date: string;

  @IsString()
  @IsOptional()
  description?: string;

  @IsNumber()
  money: number;

  @IsString()
  catId: string;

  @IsString()
  icon: string;

  @IsString()
  name: string;

  @IsBoolean()
  isIncome: boolean;

  @IsEnum(ScheduleOption)
  option: ScheduleOption;
}
