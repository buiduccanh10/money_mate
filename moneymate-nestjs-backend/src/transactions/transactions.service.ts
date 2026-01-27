import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, Like } from 'typeorm';
import { Transaction } from '../entities';
import { CreateTransactionDto, UpdateTransactionDto } from './dto';

@Injectable()
export class TransactionsService {
  constructor(
    @InjectRepository(Transaction)
    private transactionRepository: Repository<Transaction>,
  ) {}

  async findAll(
    userId: string,
    monthYear?: string,
    year?: string,
    isIncome?: boolean,
    catId?: string,
  ) {
    const queryBuilder = this.transactionRepository
      .createQueryBuilder('transaction')
      .where('transaction.userId = :userId', { userId })
      .leftJoinAndSelect('transaction.category', 'category')
      .orderBy('transaction.date', 'DESC');

    if (catId) {
      queryBuilder.andWhere('transaction.catId = :catId', { catId });
    }

    if (isIncome !== undefined) {
      queryBuilder.andWhere('transaction.isIncome = :isIncome', { isIncome });
    }

    if (monthYear) {
      if (monthYear.includes('/')) {
        queryBuilder.andWhere('transaction.date LIKE :monthYear', {
          monthYear: `%${monthYear}%`,
        });
      } else {
        const months = [
          'January',
          'February',
          'March',
          'April',
          'May',
          'June',
          'July',
          'August',
          'September',
          'October',
          'November',
          'December',
        ];
        const parts = monthYear.split(' ');
        if (parts.length === 2) {
          const mIndex = months.indexOf(parts[0]);
          if (mIndex >= 0) {
            const mStr = (mIndex + 1).toString().padStart(2, '0');
            const searchStr = `/${mStr}/${parts[1]}`;
            queryBuilder.andWhere('transaction.date LIKE :searchStr', {
              searchStr: `%${searchStr}`,
            });
          } else {
            queryBuilder.andWhere('transaction.date LIKE :monthYear', {
              monthYear: `%${monthYear}%`,
            });
          }
        } else {
          queryBuilder.andWhere('transaction.date LIKE :monthYear', {
            monthYear: `%${monthYear}%`,
          });
        }
      }
    }

    if (year) {
      queryBuilder.andWhere('transaction.date LIKE :year', {
        year: `%${year}%`,
      });
    }

    const result = await queryBuilder.getMany();
    return result;
  }

  async findOne(id: string, userId: string) {
    const transaction = await this.transactionRepository.findOne({
      where: { id, userId },
      relations: ['category'],
    });
    if (!transaction) {
      throw new NotFoundException('Transaction not found');
    }
    return transaction;
  }

  async create(userId: string, createTransactionDto: CreateTransactionDto) {
    const transaction = this.transactionRepository.create({
      ...createTransactionDto,
      userId,
    });
    return this.transactionRepository.save(transaction);
  }

  async update(
    id: string,
    userId: string,
    updateTransactionDto: UpdateTransactionDto,
  ) {
    const transaction = await this.findOne(id, userId);
    Object.assign(transaction, updateTransactionDto);
    return this.transactionRepository.save(transaction);
  }

  async remove(id: string, userId: string) {
    const transaction = await this.findOne(id, userId);
    await this.transactionRepository.remove(transaction);
    return { message: 'Transaction deleted successfully' };
  }

  async removeAll(userId: string) {
    await this.transactionRepository.delete({ userId });
    return { message: 'All transactions deleted successfully' };
  }

  async search(userId: string, query: string) {
    return this.transactionRepository.find({
      where: {
        userId,
        description: Like(`%${query}%`),
      },
      relations: ['category'],
      order: { date: 'DESC' },
    });
  }

  async getYearlyStats(userId: string, year: string) {
    const transactions = await this.transactionRepository.find({
      where: { userId },
      relations: ['category'],
    });

    // Filter by year and calculate stats
    const yearTransactions = transactions.filter((t) => t.date.includes(year));

    const income = yearTransactions
      .filter((t) => t.isIncome)
      .reduce((sum, t) => sum + Number(t.money), 0);

    const expense = yearTransactions
      .filter((t) => !t.isIncome)
      .reduce((sum, t) => sum + Number(t.money), 0);

    return {
      year,
      transactions: yearTransactions,
      summary: {
        income,
        expense,
        balance: income - expense,
      },
    };
  }
}
