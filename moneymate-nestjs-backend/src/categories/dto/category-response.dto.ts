import { ApiProperty } from '@nestjs/swagger';

export class CategoryResponseDto {
  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  id: string;

  @ApiProperty({ example: '🍔' })
  icon: string;

  @ApiProperty({ example: 'Food' })
  name: string;

  @ApiProperty({ example: false })
  isIncome: boolean;

  @ApiProperty({ example: 1000000, required: false })
  limit?: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  userId: string;
}
