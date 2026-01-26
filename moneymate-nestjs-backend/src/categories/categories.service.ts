import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOptionsWhere } from 'typeorm';
import { Category } from '../entities';
import { CreateCategoryDto, UpdateCategoryDto, UpdateLimitDto } from './dto';

@Injectable()
export class CategoriesService {
  constructor(
    @InjectRepository(Category)
    private categoryRepository: Repository<Category>,
  ) {}

  async findAll(userId: string, isIncome?: boolean) {
    const where: FindOptionsWhere<Category> = { userId };
    if (isIncome !== undefined) {
      where.isIncome = isIncome;
    }
    return this.categoryRepository.find({ where, order: { name: 'ASC' } });
  }

  async findOne(id: string, userId: string) {
    const category = await this.categoryRepository.findOne({
      where: { id, userId },
    });
    if (!category) {
      throw new NotFoundException('Category not found');
    }
    return category;
  }

  async create(userId: string, createCategoryDto: CreateCategoryDto) {
    const category = this.categoryRepository.create({
      ...createCategoryDto,
      userId,
      limit: createCategoryDto.limit || 0,
    });
    return this.categoryRepository.save(category);
  }

  async update(
    id: string,
    userId: string,
    updateCategoryDto: UpdateCategoryDto,
  ) {
    const category = await this.findOne(id, userId);
    Object.assign(category, updateCategoryDto);
    return this.categoryRepository.save(category);
  }

  async remove(id: string, userId: string) {
    const category = await this.findOne(id, userId);
    await this.categoryRepository.remove(category);
    return { message: 'Category deleted successfully' };
  }

  async removeAll(userId: string, isIncome?: boolean) {
    const where: FindOptionsWhere<Category> = { userId };
    if (isIncome !== undefined) {
      where.isIncome = isIncome;
    }
    await this.categoryRepository.delete(where);
    return { message: 'Categories deleted successfully' };
  }

  async updateLimit(
    id: string,
    userId: string,
    updateLimitDto: UpdateLimitDto,
  ) {
    const category = await this.findOne(id, userId);
    category.limit = updateLimitDto.limit;
    return this.categoryRepository.save(category);
  }

  async restoreAllLimits(userId: string) {
    await this.categoryRepository.update({ userId }, { limit: 0 });
    return { message: 'All limits restored to 0' };
  }
}
