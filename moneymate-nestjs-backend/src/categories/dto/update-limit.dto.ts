import { ApiProperty } from '@nestjs/swagger';
import { IsNumber } from 'class-validator';

export class UpdateLimitDto {
  @ApiProperty({ example: 1500000 })
  @IsNumber()
  limit: number;
}
