import { IsNumber } from 'class-validator';

export class UpdateLimitDto {
  @IsNumber()
  limit: number;
}
