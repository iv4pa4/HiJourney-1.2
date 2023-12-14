import { Module } from '@nestjs/common';
import { CreatorController } from './creator.controller';
import { CreatorService } from './creator.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Creator } from './creator.entity';

@Module({
  imports:[TypeOrmModule.forFeature([Creator])],
  controllers: [CreatorController],
  providers: [CreatorService]
})
export class CreatorModule {}
