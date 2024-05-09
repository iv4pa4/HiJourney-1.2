import { Module, forwardRef } from '@nestjs/common';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventure } from './adventure.entity';
import { Adventurer } from '../adventurer/adventurer.entity';
import { AdventurerService } from 'src/adventurer/adventurer.service';
import { AdventurerModule } from 'src/adventurer/adventurer.module';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventure]),
    TypeOrmModule.forFeature([Adventurer]),
    JwtModule.register({
      secret: 'your-secret-key', 
      signOptions: { expiresIn: '1h' }, 
    }),  ],
  controllers: [AdventureController],
  providers: [AdventureService, AdventurerService],
})
export class AdventureModule {}