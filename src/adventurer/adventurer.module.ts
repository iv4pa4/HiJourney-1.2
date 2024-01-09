import { Module } from '@nestjs/common';
import { AdventurerController } from './adventurer.controller';
import { AdventurerService } from './adventurer.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventurer } from './adventurer.entity';
import { Adventure } from 'src/adventure/adventure.entity';  // Import Adventure entity

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventurer, Adventure]),  // Include Adventure entity in TypeOrmModule
  ],
  controllers: [AdventurerController],
  providers: [AdventurerService],
})
export class AdventurerModule {}
