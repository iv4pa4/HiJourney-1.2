import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TypeOrmModule } from '@nestjs/typeorm';
import { JwtModule } from '@nestjs/jwt'; // Add this line
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AdventurerModule } from './adventurer/adventurer.module';
import { CreatorModule } from './creator/creator.module';
import { AdventureModule } from './adventure/adventure.module';
//import { AuthModule } from './auth/auth.module';

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
    JwtModule.register({
      secret: process.env.JWT_SECRET_KEY || 'your_secret_key_here', // Replace with your secret key
      signOptions: { expiresIn: '1h' }, // You can adjust the expiration time
    }),
    //AuthModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
