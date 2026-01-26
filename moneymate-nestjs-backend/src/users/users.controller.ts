import {
  Controller,
  Get,
  Patch,
  Delete,
  Body,
  UseGuards,
} from '@nestjs/common';
import { UsersService } from './users.service';
import { UpdateSettingsDto } from './dto/update-settings.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@Controller('users')
@UseGuards(JwtAuthGuard)
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  async getProfile(@CurrentUser() user: User) {
    return this.usersService.getProfile(user.id);
  }

  @Delete('me')
  async deleteAccount(@CurrentUser() user: User) {
    return this.usersService.deleteAccount(user.id);
  }

  @Get('me/settings')
  async getSettings(@CurrentUser() user: User) {
    return this.usersService.getSettings(user.id);
  }

  @Patch('me/settings')
  async updateSettings(
    @CurrentUser() user: User,
    @Body() updateSettingsDto: UpdateSettingsDto,
  ) {
    return this.usersService.updateSettings(user.id, updateSettingsDto);
  }
}
