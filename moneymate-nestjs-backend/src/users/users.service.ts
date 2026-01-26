import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities';
import { UpdateSettingsDto } from './dto/update-settings.dto';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
  ) {}

  async getProfile(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return {
      id: user.id,
      email: user.email,
      language: user.language,
      isDark: user.isDark,
      isLock: user.isLock,
      createdAt: user.createdAt,
    };
  }

  async getSettings(userId: string) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }
    return {
      language: user.language,
      isDark: user.isDark,
      isLock: user.isLock,
    };
  }

  async updateSettings(userId: string, updateSettingsDto: UpdateSettingsDto) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    Object.assign(user, updateSettingsDto);
    await this.userRepository.save(user);

    return {
      language: user.language,
      isDark: user.isDark,
      isLock: user.isLock,
    };
  }

  async deleteAccount(userId: string) {
    const result = await this.userRepository.delete(userId);
    if (result.affected === 0) {
      throw new NotFoundException('User not found');
    }
    return { message: 'Account deleted successfully' };
  }
}
