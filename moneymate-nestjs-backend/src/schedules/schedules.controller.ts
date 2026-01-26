import {
  Controller,
  Get,
  Post,
  Delete,
  Body,
  Param,
  UseGuards,
  ParseIntPipe,
} from '@nestjs/common';
import { SchedulesService } from './schedules.service';
import { CreateScheduleDto } from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@Controller('schedules')
@UseGuards(JwtAuthGuard)
export class SchedulesController {
  constructor(private readonly schedulesService: SchedulesService) {}

  @Get()
  async findAll(@CurrentUser() user: User) {
    return this.schedulesService.findAll(user.id);
  }

  @Post()
  async create(
    @CurrentUser() user: User,
    @Body() createScheduleDto: CreateScheduleDto,
  ) {
    return this.schedulesService.create(user.id, createScheduleDto);
  }

  @Delete(':id')
  async remove(
    @Param('id', ParseIntPipe) id: number,
    @CurrentUser() user: User,
  ) {
    return this.schedulesService.remove(id, user.id);
  }

  @Delete()
  async removeAll(@CurrentUser() user: User) {
    return this.schedulesService.removeAll(user.id);
  }
}
