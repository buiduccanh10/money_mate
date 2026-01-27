import { ApiProperty } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  id: string;

  @ApiProperty({ example: 'user@example.com' })
  email: string;

  @ApiProperty({ example: 'en' })
  language: string;

  @ApiProperty({ example: false })
  isDark: boolean;

  @ApiProperty({ example: false })
  isLock: boolean;
}

export class UserSettingsResponseDto {
  @ApiProperty({ example: 'en' })
  language: string;

  @ApiProperty({ example: false })
  isDark: boolean;

  @ApiProperty({ example: false })
  isLock: boolean;
}
