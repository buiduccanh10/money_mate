import {
  Controller,
  Get,
  Patch,
  Delete,
  Body,
  UseGuards,
  HttpStatus,
  Req,
  Logger,
  BadRequestException,
} from '@nestjs/common';
import type { FastifyRequest } from 'fastify';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiConsumes,
  ApiBody,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import {
  UpdateSettingsDto,
  UpdateProfileDto,
  UserResponseDto,
  UserSettingsResponseDto,
} from './dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../common/decorators/current-user.decorator';
import { User } from '../entities';

@ApiTags('Users')
@Controller('users')
@UseGuards(JwtAuthGuard)
@ApiBearerAuth('bearer')
export class UsersController {
  private readonly logger = new Logger(UsersController.name);

  constructor(private readonly usersService: UsersService) {}

  @Get('me')
  @ApiOperation({ summary: "Get current user's profile" })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Profile successfully retrieved',
    type: UserResponseDto,
  })
  async getProfile(@CurrentUser() user: User) {
    return this.usersService.getProfile(user.id);
  }

  @Delete('me')
  @ApiOperation({ summary: 'Delete current user account' })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Account successfully deleted',
  })
  async deleteAccount(@CurrentUser() user: User) {
    return this.usersService.deleteAccount(user.id);
  }

  @Patch('me/avatar')
  @ApiOperation({ summary: "Update current user's avatar" })
  @ApiConsumes('multipart/form-data')
  @ApiBody({
    schema: {
      type: 'object',
      properties: {
        file: {
          type: 'string',
          format: 'binary',
        },
      },
    },
  })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Avatar successfully updated',
    type: UserResponseDto,
  })
  async updateAvatar(@CurrentUser() user: User, @Req() req: FastifyRequest) {
    const file = await req.file();
    if (!file) {
      throw new BadRequestException('File is required');
    }

    this.logger.debug(`Processing avatar upload: ${file.filename}`);
    const buffer = await file.toBuffer();
    return this.usersService.updateAvatar(user.id, {
      buffer,
      mimetype: file.mimetype,
      originalname: file.filename || 'avatar.jpg',
    });
  }

  @Patch('me/profile')
  @ApiOperation({ summary: "Update current user's profile info" })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Profile successfully updated',
    type: UserResponseDto,
  })
  async updateProfile(
    @CurrentUser() user: User,
    @Body() updateProfileDto: UpdateProfileDto,
  ) {
    this.logger.debug(`Updating profile info for user ${user.id}`);
    return this.usersService.updateProfile(user.id, updateProfileDto);
  }

  @Get('me/settings')
  @ApiOperation({ summary: "Get current user's settings" })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Settings successfully retrieved',
    type: UserSettingsResponseDto,
  })
  async getSettings(@CurrentUser() user: User) {
    return this.usersService.getSettings(user.id);
  }

  @Patch('me/settings')
  @ApiOperation({ summary: "Update current user's settings" })
  @ApiResponse({
    status: HttpStatus.OK,
    description: 'Settings successfully updated',
    type: UserSettingsResponseDto,
  })
  async updateSettings(
    @CurrentUser() user: User,
    @Body() updateSettingsDto: UpdateSettingsDto,
  ) {
    return this.usersService.updateSettings(user.id, updateSettingsDto);
  }
}
