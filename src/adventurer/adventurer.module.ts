import { Module } from '@nestjs/common';
import { AdventurerController } from './adventurer.controller';
import { AdventurerService } from './adventurer.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventurer } from './adventurer.entity';

@Module({
  imports:[TypeOrmModule.forFeature([Adventurer])],
  controllers: [AdventurerController],
  providers: [AdventurerService]
})
export class AdventurerModule {}
