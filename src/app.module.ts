import { Module } from '@nestjs/common';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AdventurerModule } from './adventurer/adventurer.module';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CreatorModule } from './creator/creator.module';
import { AdventureModule } from './adventure/adventure.module';


@Module({
  imports: [
    ConfigModule.forRoot(),
    AdventurerModule,
    CreatorModule,
    AdventureModule,
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'localhost',
      port: 5432,
      username: 'iva',
      password: 'iva2005iva2005',
      database: 'hijourney',
      entities: [__dirname + '/**/*.entity{.ts,.js}'],
      synchronize: true, // Set to false in production
    }),
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
