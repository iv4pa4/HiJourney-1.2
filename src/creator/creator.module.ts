
import { Module } from '@nestjs/common';
import { CreatorController } from './creator.controller';
import { CreatorService } from './creator.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Creator } from './creator.entity';
import { Adventure } from 'src/adventure/adventure.entity';  // Import Adventure entity

@Module({
  imports: [
    TypeOrmModule.forFeature([Creator, Adventure]),  // Include Adventure entity in TypeOrmModule
  ],
  controllers: [CreatorController],
  providers: [CreatorService],
})
export class CreatorModule {}
