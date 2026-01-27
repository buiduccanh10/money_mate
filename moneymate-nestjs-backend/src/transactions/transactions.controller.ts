import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
  HttpStatus,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { TransactionsService } from './transactions.service';
import {
  CreateTransactionDto,
  UpdateTransactionDto,
  TransactionResponseDto,
  YearlyStatsResponseDto,
} from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@ApiTags('Transactions')
@Controller('transactions')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('bearer')
export class TransactionsController {
  constructor(private readonly transactionsService: TransactionsService) {}

  @Get()
  @ApiOperation({ summary: 'Get all transactions with filters' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Transactions successfully retrieved',
    type: [TransactionResponseDto],
  })
  async findAll(
    @CurrentUser() user: User,
    @Query('monthYear') monthYear?: string,
    @Query('year') year?: string,
    @Query('isIncome') isIncome?: string,
    @Query('catId') catId?: string,
  ) {
    const isIncomeValue =
      isIncome === undefined ? undefined : isIncome === 'true';
    return this.transactionsService.findAll(
      user.id,
      monthYear,
      year,
      isIncomeValue,
      catId,
    );
  }

  @Post()
  @ApiOperation({ summary: 'Create a new transaction' })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Transaction successfully created',
    type: TransactionResponseDto,
  })
  async create(
    @CurrentUser() user: User,
    @Body() createTransactionDto: CreateTransactionDto,
  ) {
    return this.transactionsService.create(user.id, createTransactionDto);
  }

  @Put(':id')
  @ApiOperation({ summary: 'Update transaction' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Transaction successfully updated',
    type: TransactionResponseDto,
  })
  async update(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateTransactionDto: UpdateTransactionDto,
  ) {
    return this.transactionsService.update(id, user.id, updateTransactionDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete transaction' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Transaction successfully deleted',
  })
  async remove(@Param('id') id: string, @CurrentUser() user: User) {
    return this.transactionsService.remove(id, user.id);
  }

  @Delete()
  @ApiOperation({ summary: 'Delete all transactions for user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'All transactions successfully deleted',
  })
  async removeAll(@CurrentUser() user: User) {
    return this.transactionsService.removeAll(user.id);
  }

  @Get('search')
  @ApiOperation({ summary: 'Search transactions' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Search results retrieved',
    type: [TransactionResponseDto],
  })
  async search(@CurrentUser() user: User, @Query('q') query: string) {
    return this.transactionsService.search(user.id, query || '');
  }

  @Get('yearly')
  @ApiOperation({ summary: 'Get yearly statistics' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Yearly stats retrieved',
    type: YearlyStatsResponseDto,
  })
  async getYearlyStats(@CurrentUser() user: User, @Query('year') year: string) {
    return this.transactionsService.getYearlyStats(
      user.id,
      year || new Date().getFullYear().toString(),
    );
  }
}
