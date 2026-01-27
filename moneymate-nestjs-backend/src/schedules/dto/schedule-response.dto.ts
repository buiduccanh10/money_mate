import { ApiProperty } from '@nestjs/swagger';

export class ScheduleResponseDto {
  @ApiProperty({ example: 1 })
  id: number;

  @ApiProperty({ example: '2024-03-20' })
  date: string;

  @ApiProperty({ example: 'Monthly rent', required: false })
  description?: string;

  @ApiProperty({ example: 5000000 })
  money: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  catId: string;

  @ApiProperty({ example: '🏠' })
  icon: string;

  @ApiProperty({ example: 'Rent' })
  name: string;

  @ApiProperty({ example: false })
  isIncome: boolean;

  @ApiProperty({
    example: 'MONTHLY',
    enum: ['DAILY', 'WEEKLY', 'MONTHLY', 'YEARLY'],
  })
  option: string;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  userId: string;
}
