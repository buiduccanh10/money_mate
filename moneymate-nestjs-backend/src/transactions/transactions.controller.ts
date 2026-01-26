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
} from '@nestjs/common';
import { TransactionsService } from './transactions.service';
import { CreateTransactionDto, UpdateTransactionDto } from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@Controller('transactions')
@UseGuards(JwtAuthGuard)
export class TransactionsController {
  constructor(private readonly transactionsService: TransactionsService) {}

  @Get()
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
  async create(
    @CurrentUser() user: User,
    @Body() createTransactionDto: CreateTransactionDto,
  ) {
    return this.transactionsService.create(user.id, createTransactionDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateTransactionDto: UpdateTransactionDto,
  ) {
    return this.transactionsService.update(id, user.id, updateTransactionDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string, @CurrentUser() user: User) {
    return this.transactionsService.remove(id, user.id);
  }

  @Delete()
  async removeAll(@CurrentUser() user: User) {
    return this.transactionsService.removeAll(user.id);
  }

  @Get('search')
  async search(@CurrentUser() user: User, @Query('q') query: string) {
    return this.transactionsService.search(user.id, query || '');
  }

  @Get('yearly')
  async getYearlyStats(@CurrentUser() user: User, @Query('year') year: string) {
    return this.transactionsService.getYearlyStats(
      user.id,
      year || new Date().getFullYear().toString(),
    );
  }
}
