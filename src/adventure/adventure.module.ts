import { Module } from '@nestjs/common';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventure } from './adventure.entity';
import { Adventurer } from '../adventurer/adventurer.entity';
import { AdventurerService } from 'src/adventurer/adventurer.service';

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventure]),
    TypeOrmModule.forFeature([Adventurer]),
  ],
  controllers: [AdventureController],
  providers: [AdventureService, AdventurerService],
})
export class AdventureModule {}