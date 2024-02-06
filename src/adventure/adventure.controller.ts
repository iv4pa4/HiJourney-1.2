import { Controller, Get, Post, Body, Param, Delete, Patch, Query, NotFoundException } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure, AdventureDto } from './adventure.entity';
import { AdventurerService } from '../adventurer/adventurer.service'; 
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';

@Controller('adventure')
export class AdventureController {
    constructor(
        private readonly adventureService: AdventureService,
        private readonly adventurerService: AdventurerService, 
    ) {}

    @Get()
    async findAll(@Query() query: any = {}): Promise<Pagination<Adventure>> {
        const options: FindOneOptions<Adventure> = {
            
        };
    
        const adventures = await paginate<Adventure>(
            this.adventureService.getRepo(),
            query,
            options,
        );
    
        return adventures;
    }

    @Get(':id')
    async getAdventure(@Param('id') id: string): Promise<Adventure> {
        const adventure = await this.adventureService.getSingleAdventure(+id);

        if (!adventure) {
            throw new NotFoundException(`Adventure with ID ${id} not found`);
        }
        this.adventureService.displayAdventure(adventure);

        return adventure;
    }

    @Post()
    async createAdventure(@Body() adventureDto: AdventureDto): Promise<Adventure> {
        return await this.adventureService.create(adventureDto);
    }

    @Patch(':id')
    async updateAdventure(@Param('id') id: number, @Body() adventure: AdventureDto): Promise<Adventure> {
        return this.adventureService.update(id, adventure);
    }

    @Delete(':id')
    async deleteAdventure(@Param('id') id: number): Promise<void> {
        const adventure = await this.adventureService.getSingleAdventure(id);

        if (!adventure) {
            throw new NotFoundException(`Adventure with ID ${id} not found`);
        }

        await this.adventureService.deleteAdventure(id);
    }

    // @Get(':id/attended-adventurers')
    // async getAttendedAdventurersNames(@Param('id') id: string): Promise<string[]> {
    //   const adventureId = +id; // Convert id to a number
  
    //   try {
    //     const attendedAdventurerNames = await this.adventureService.getAttendedAdventurersNames(adventureId);
    //     return attendedAdventurerNames;
    //   } catch (error) {
    //     throw new NotFoundException(`Adventure with ID ${id} not found`);
    //   }
    // }

}