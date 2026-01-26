import {
  Controller,
  Get,
  Post,
  Put,
  Patch,
  Delete,
  Body,
  Param,
  Query,
  UseGuards,
} from '@nestjs/common';
import { CategoriesService } from './categories.service';
import { CreateCategoryDto, UpdateCategoryDto, UpdateLimitDto } from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@Controller('categories')
@UseGuards(JwtAuthGuard)
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  async findAll(
    @CurrentUser() user: User,
    @Query('isIncome') isIncome?: string,
  ) {
    const isIncomeValue =
      isIncome === undefined ? undefined : isIncome === 'true';
    return this.categoriesService.findAll(user.id, isIncomeValue);
  }

  @Get(':id')
  async findOne(@Param('id') id: string, @CurrentUser() user: User) {
    return this.categoriesService.findOne(id, user.id);
  }

  @Post()
  async create(
    @CurrentUser() user: User,
    @Body() createCategoryDto: CreateCategoryDto,
  ) {
    return this.categoriesService.create(user.id, createCategoryDto);
  }

  @Put(':id')
  async update(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ) {
    return this.categoriesService.update(id, user.id, updateCategoryDto);
  }

  @Delete(':id')
  async remove(@Param('id') id: string, @CurrentUser() user: User) {
    return this.categoriesService.remove(id, user.id);
  }

  @Delete()
  async removeAll(
    @CurrentUser() user: User,
    @Query('isIncome') isIncome?: string,
  ) {
    const isIncomeValue =
      isIncome === undefined ? undefined : isIncome === 'true';
    return this.categoriesService.removeAll(user.id, isIncomeValue);
  }

  @Patch(':id/limit')
  async updateLimit(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateLimitDto: UpdateLimitDto,
  ) {
    return this.categoriesService.updateLimit(id, user.id, updateLimitDto);
  }

  @Post('restore-all-limits')
  async restoreAllLimits(@CurrentUser() user: User) {
    return this.categoriesService.restoreAllLimits(user.id);
  }
}
