
import { Module } from '@nestjs/common';
import { CreatorController } from './creator.controller';
import { CreatorService } from './creator.service';
import { TypeOrmModule } from '@nestjs/typeorm';
import { Creator } from './creator.entity';
import { Adventure } from 'src/adventure/adventure.entity';  // Import Adventure entity
import { JwtModule } from '@nestjs/jwt';

@Module({
  imports: [
    TypeOrmModule.forFeature([Creator, Adventure]),
    JwtModule.register({
      secret: 'your-secret-key', 
      signOptions: { expiresIn: '1h' }, 
    }),  
  ],
  controllers: [CreatorController],
  providers: [CreatorService],
})
export class CreatorModule {}
