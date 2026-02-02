import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Schedule } from '../entities';
import { CreateScheduleDto, UpdateScheduleDto } from './dto';

@Injectable()
export class SchedulesService {
  constructor(
    @InjectRepository(Schedule)
    private scheduleRepository: Repository<Schedule>,
  ) {}

  async findAll(userId: string) {
    return this.scheduleRepository.find({
      where: { userId },
      order: { createdAt: 'DESC' },
    });
  }

  async create(userId: string, createScheduleDto: CreateScheduleDto) {
    const schedule = this.scheduleRepository.create({
      ...createScheduleDto,
      userId,
    });
    const saved = await this.scheduleRepository.save(schedule);
    return { ...saved, id: saved.id };
  }

  async update(
    id: number,
    userId: string,
    updateScheduleDto: UpdateScheduleDto,
  ) {
    const schedule = await this.scheduleRepository.findOne({
      where: { id, userId },
    });
    if (!schedule) {
      throw new NotFoundException('Schedule not found');
    }
    Object.assign(schedule, updateScheduleDto);
    return this.scheduleRepository.save(schedule);
  }

  async remove(id: number, userId: string) {
    const schedule = await this.scheduleRepository.findOne({
      where: { id, userId },
    });
    if (!schedule) {
      throw new NotFoundException('Schedule not found');
    }
    await this.scheduleRepository.remove(schedule);
    return { message: 'Schedule deleted successfully' };
  }

  async removeAll(userId: string) {
    await this.scheduleRepository.delete({ userId });
    return { message: 'All schedules deleted successfully' };
  }
}
