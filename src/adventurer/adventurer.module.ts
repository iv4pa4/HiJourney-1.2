import { Module, forwardRef } from '@nestjs/common';
import { AdventurerController } from './adventurer.controller';
import { AdventurerService } from './adventurer.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Adventurer } from './adventurer.entity';
import { Adventure } from 'src/adventure/adventure.entity';  
import { AdventureService } from 'src/adventure/adventure.service';
import { AdventureModule } from 'src/adventure/adventure.module';
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    TypeOrmModule.forFeature([Adventurer, Adventure]),
    JwtModule.register({
      secret: 'your-secret-key', // Replace with your secret key
      signOptions: { expiresIn: '1h' }, // Set token expiration
    }),
  ],
  controllers: [AdventurerController],
  providers: [AdventurerService, AdventureService],
  exports: [AdventurerService]
})
export class AdventurerModule {}
