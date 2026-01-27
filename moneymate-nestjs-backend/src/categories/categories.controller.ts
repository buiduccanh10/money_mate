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
  HttpStatus,
} from '@nestjs/common';
import { CategoriesService } from './categories.service';
import {
  CreateCategoryDto,
  UpdateCategoryDto,
  UpdateLimitDto,
  CategoryResponseDto,
} from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';

@ApiTags('Categories')
@Controller('categories')
@UseGuards(JwtAuthGuard)
export class CategoriesController {
  constructor(private readonly categoriesService: CategoriesService) {}

  @Get()
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Get all categories' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Categories successfully retrieved',
    type: [CategoryResponseDto],
  })
  async findAll(
    @CurrentUser() user: User,
    @Query('isIncome') isIncome?: string,
  ) {
    const isIncomeValue =
      isIncome === undefined ? undefined : isIncome === 'true';
    return this.categoriesService.findAll(user.id, isIncomeValue);
  }

  @Get(':id')
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Get category by ID' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Category successfully retrieved',
    type: CategoryResponseDto,
  })
  async findOne(@Param('id') id: string, @CurrentUser() user: User) {
    return this.categoriesService.findOne(id, user.id);
  }

  @Post()
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Create a new category' })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Category successfully created',
    type: CategoryResponseDto,
  })
  async create(
    @CurrentUser() user: User,
    @Body() createCategoryDto: CreateCategoryDto,
  ) {
    return this.categoriesService.create(user.id, createCategoryDto);
  }

  @Put(':id')
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Update category' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Category successfully updated',
    type: CategoryResponseDto,
  })
  async update(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateCategoryDto: UpdateCategoryDto,
  ) {
    return this.categoriesService.update(id, user.id, updateCategoryDto);
  }

  @Delete(':id')
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Delete category' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Category successfully deleted',
  })
  async remove(@Param('id') id: string, @CurrentUser() user: User) {
    return this.categoriesService.remove(id, user.id);
  }

  @Delete()
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Delete all categories for user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'All categories successfully deleted',
  })
  async removeAll(
    @CurrentUser() user: User,
    @Query('isIncome') isIncome?: string,
  ) {
    const isIncomeValue =
      isIncome === undefined ? undefined : isIncome === 'true';
    return this.categoriesService.removeAll(user.id, isIncomeValue);
  }

  @Patch(':id/limit')
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Update category limit' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Category limit successfully updated',
    type: CategoryResponseDto,
  })
  async updateLimit(
    @Param('id') id: string,
    @CurrentUser() user: User,
    @Body() updateLimitDto: UpdateLimitDto,
  ) {
    return this.categoriesService.updateLimit(id, user.id, updateLimitDto);
  }

  @Post('restore-all-limits')
  @ApiBearerAuth('bearer')
  @ApiOperation({ summary: 'Restore all category limits' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'All category limits successfully restored',
  })
  async restoreAllLimits(@CurrentUser() user: User) {
    return this.categoriesService.restoreAllLimits(user.id);
  }
}
