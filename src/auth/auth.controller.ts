// auth.controller.ts
import { Controller, Post, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from '@nestjs/passport';
import { AuthService } from './auth.service'; 
import { Adventurer } from 'src/adventurer/adventurer.entity';

@Controller('auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  async register(@Request() req): Promise<Adventurer> {
    return this.authService.register(req.body);
  }

  @UseGuards(AuthGuard('local'))
  @Post('login')
  async login(@Request() req): Promise<Adventurer> {
    // The authenticated user is already available in req.user
    return req.user;
  }
}
