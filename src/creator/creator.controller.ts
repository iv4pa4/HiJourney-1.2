import { Controller, Get, Post, Body, Param, Delete, Patch, Query, UnauthorizedException, UseGuards} from '@nestjs/common';
import { CreatorService } from './creator.service';
import { Creator, CreatorDto } from './creator.entity'; 
import { NotFoundException } from '@nestjs/common';
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';
import { Adventure, AdventureDto } from 'src/adventure/adventure.entity';
import { JwtService } from '@nestjs/jwt';
import { AuthenticationGuard } from 'src/guards/authentication.guard';

@Controller('creator')
export class CreatorController { 
    constructor(
        private readonly creatorService: CreatorService,
        private jwtService: JwtService) {} 

   
   
        @Get()
    @UseGuards(AuthenticationGuard)
    async findAll(@Query() query: any = {}): Promise<Creator[]> {
        const creators = await this.creatorService.findAll(query);
        return creators;
    }

    @Get(':id')
    @UseGuards(AuthenticationGuard)
    async getCreator(@Param('id') id: string): Promise<Creator> { 
        const creator = await this.creatorService.getSingleCreator(+id); 

        if (!creator) {
            throw new NotFoundException(`Creator with ID ${id} not found`); 
        }

        return creator;
    }
    @Get('email/:email')
    async getCreatorByEmail(@Param('email') email: string): Promise<Creator> {
      try {
        const creator = await this.creatorService.findByEmail(email);
        return creator;
      } catch (error) {
        if (error instanceof NotFoundException) {
          throw new NotFoundException(error.message);
        }
        throw error;
      }
    }


    @Post('validate')
    async testUserValidation(@Body() userData: { email: string; password: string }) {
    const { email, password } = userData;
    const isValid = await this.creatorService.validate(email, password);
    if (isValid) {
        const payload = { email };
        const token = this.jwtService.sign(payload);
        console.log(token);
        return { token };
    }
    throw new UnauthorizedException('Invalid email or password');

    }

    @Post()
    async createCreator(@Body() creatorDto: CreatorDto): Promise<Creator> { 
        return await this.creatorService.create(creatorDto); 
    }

    @Patch(':id')
    @UseGuards(AuthenticationGuard)
    async updateCreator(@Param('id') id: number, @Body() creator: CreatorDto): Promise<Creator> { 
        return this.creatorService.update(id, creator); 
    }

    @Delete(':id')
    @UseGuards(AuthenticationGuard)
    async deleteCreator(@Param('id') id: number): Promise<void> { 
        const creator = await this.creatorService.getSingleCreator(id); 

        if (!creator) {
            throw new NotFoundException(`Creator with ID ${id} not found`); 
        }

        await this.creatorService.deleteCreator(id); 
    }

    @Post(':id/adventures')
    @UseGuards(AuthenticationGuard)
  async createAdventure(
    @Param('id') id: number,
    @Body() adventureDto: AdventureDto,
  ): Promise<Adventure> {
    return this.creatorService.createAdventure(id, adventureDto);
  }

  @Get(':id/adventures')
  @UseGuards(AuthenticationGuard)
  async getCreatorAdventures(@Param('id') id: string): Promise<Adventure[]> { 
      const adventures = await this.creatorService.getCreatorAdventures(+id);

      if (!adventures || adventures.length === 0) {
          throw new NotFoundException(`Adventures not found for Creator with ID ${id}`);
      }

      return adventures;
  }
}
