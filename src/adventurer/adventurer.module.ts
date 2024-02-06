import { Module, forwardRef } from '@nestjs/common';
import { AdventurerController } from './adventurer.controller';
import { AdventurerService } from './adventurer.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventurer } from './adventurer.entity';
import { Adventure } from 'src/adventure/adventure.entity';  
import { AdventureService } from 'src/adventure/adventure.service';
import { AdventureModule } from 'src/adventure/adventure.module';

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventurer, Adventure]), 
  ],
  controllers: [AdventurerController],
  providers: [AdventurerService, AdventureService],
})
export class AdventurerModule {}
