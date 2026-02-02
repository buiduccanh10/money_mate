import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
  ParseIntPipe,
  HttpStatus,
  Patch,
} from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
} from '@nestjs/swagger';
import { SchedulesService } from './schedules.service';
import {
  CreateScheduleDto,
  ScheduleResponseDto,
  UpdateScheduleDto,
} from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@ApiTags('Schedules')
@Controller('schedules')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('bearer')
export class SchedulesController {
  constructor(private readonly schedulesService: SchedulesService) {}

  @Get()
  @ApiOperation({ summary: 'Get all schedules' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Schedules successfully retrieved',
    type: [ScheduleResponseDto],
  })
  async findAll(@CurrentUser() user: User) {
    return this.schedulesService.findAll(user.id);
  }

  @Post()
  @ApiOperation({ summary: 'Create a new schedule' })
  @ApiResponse({
    status: HttpStatus.CREATED,
    description: 'Schedule successfully created',
    type: ScheduleResponseDto,
  })
  async create(
    @CurrentUser() user: User,
    @Body() createScheduleDto: CreateScheduleDto,
  ) {
    return this.schedulesService.create(user.id, createScheduleDto);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete schedule by ID' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Schedule successfully deleted',
  })
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: User,
  ) {
    return this.schedulesService.remove(id, user.id);
  }

  @Delete()
  @ApiOperation({ summary: 'Delete all schedules for user' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'All schedules successfully deleted',
  })
  async removeAll(@CurrentUser() user: User) {
    return this.schedulesService.removeAll(user.id);
  }

  @Patch(':id')
  @ApiOperation({ summary: 'Update schedule by ID' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Schedule successfully updated',
    type: ScheduleResponseDto,
  })
  async update(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: User,
    @Body() updateScheduleDto: UpdateScheduleDto,
  ) {
    return this.schedulesService.update(id, user.id, updateScheduleDto);
  }
}
