import { Module } from '@nestjs/common';
import { AdventureController } from './adventure.controller';
import { AdventureService } from './adventure.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventure } from './adventure.entity';

@Module({
  imports: [TypeOrmModule.forFeature([Adventure])],
  controllers: [AdventureController],
  providers: [AdventureService], 
})
export class AdventureModule {}
