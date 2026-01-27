import { ApiProperty } from '@nestjs/swagger';
import { CategoryResponseDto } from '../../categories/dto/category-response.dto';

export class TransactionResponseDto {
  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  id: string;

  @ApiProperty({ example: '2024-03-20T00:00:00.000Z' })
  date: string;

  @ApiProperty({ example: '10:00' })
  time: string;

  @ApiProperty({ example: 'Buy coffee', required: false })
  description?: string;

  @ApiProperty({ example: 50000 })
  money: number;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  catId: string;

  @ApiProperty({ example: false })
  isIncome: boolean;

  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  userId: string;

  @ApiProperty({ type: () => CategoryResponseDto, required: false })
  category?: CategoryResponseDto;
}

export class TransactionSummaryDto {
  @ApiProperty({ example: 1000000 })
  income: number;

  @ApiProperty({ example: 500000 })
  expense: number;

  @ApiProperty({ example: 500000 })
  balance: number;
}

export class YearlyStatsResponseDto {
  @ApiProperty({ example: '2024' })
  year: string;

  @ApiProperty({ type: [TransactionResponseDto] })
  transactions: TransactionResponseDto[];

  @ApiProperty({ type: TransactionSummaryDto })
  summary: TransactionSummaryDto;
}
