import {
  Injectable,
  NotFoundException,
  BadRequestException,
  ConflictException,
} from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { User } from '../entities';
import { UpdateSettingsDto } from './dto/update-settings.dto';
import { UpdateProfileDto } from './dto/update-profile.dto';
import * as bcrypt from 'bcrypt';

import { SupabaseService } from '../supabase/supabase.service';

@Injectable()
export class UsersService {
  constructor(
    @InjectRepository(User)
    private userRepository: Repository<User>,
    private supabaseService: SupabaseService,
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
      name: user.name,
      avatar: user.avatar,
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

    if (updateSettingsDto.language != null)
      user.language = updateSettingsDto.language;
    if (updateSettingsDto.isDark != null)
      user.isDark = updateSettingsDto.isDark;
    if (updateSettingsDto.isLock != null)
      user.isLock = updateSettingsDto.isLock;

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

  async updateAvatar(
    userId: string,
    file: { buffer: Buffer; mimetype: string; originalname: string },
  ) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    const fileExt = file.originalname.split('.').pop();
    const fileName = `${userId}_${Date.now()}.${fileExt}`;
    const { error } = await this.supabaseService
      .getStorage('avatars')
      .upload(fileName, file.buffer, {
        contentType: file.mimetype,
        upsert: true,
      });

    if (error) {
      throw new BadRequestException(
        `Failed to upload avatar: ${error.message}`,
      );
    }

    const { data } = this.supabaseService
      .getStorage('avatars')
      .getPublicUrl(fileName);

    user.avatar = data.publicUrl;
    await this.userRepository.save(user);

    return this.getProfile(userId);
  }

  async updateProfile(userId: string, updateProfileDto: UpdateProfileDto) {
    const user = await this.userRepository.findOne({ where: { id: userId } });
    if (!user) {
      throw new NotFoundException('User not found');
    }

    if (updateProfileDto.email && updateProfileDto.email !== user.email) {
      const existingUser = await this.userRepository.findOne({
        where: { email: updateProfileDto.email },
      });
      if (existingUser) {
        throw new ConflictException('Email already in use');
      }
      user.email = updateProfileDto.email;
    }

    if (updateProfileDto.password) {
      const salt = await bcrypt.genSalt();
      user.password = await bcrypt.hash(updateProfileDto.password, salt);
    }

    if (updateProfileDto.name !== undefined) {
      user.name = updateProfileDto.name;
    }

    if (updateProfileDto.avatar !== undefined) {
      user.avatar = updateProfileDto.avatar;
    }

    await this.userRepository.save(user);
    return this.getProfile(userId);
  }
}
