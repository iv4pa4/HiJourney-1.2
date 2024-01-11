// auth.module.ts
import { Module } from '@nestjs/common';
import { AuthService } from './auth.service';
import { AuthController } from './auth.controller';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventurer } from 'src/adventurer/adventurer.entity'; 
import { PassportModule } from '@nestjs/passport';
import { LocalStrategy } from './local.strategy'; 

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventurer]),
    PassportModule,
  ],
  providers: [AuthService, LocalStrategy],
  controllers: [AuthController],
})
export class AuthModule {}
