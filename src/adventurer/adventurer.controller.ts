import { Controller, Get, Post, Body, Param, Delete, Patch, Query } from '@nestjs/common';
import { AdventurerService } from './adventurer.service';
import { Adventurer, AdventurerDto } from './adventurer.entity'; 
import { NotFoundException } from '@nestjs/common';
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';

@Controller('adventurer')
export class AdventurerController { 
    constructor(private readonly adventurerService: AdventurerService) {} 

    @Get()
    async findAll(@Query() query: any = {}): Promise<Pagination<Adventurer>> { 
        const options: FindOneOptions<Adventurer> = {
           
        };
    
        const adventurers = await paginate<Adventurer>(
            this.adventurerService.getRepo(), 
            query,
            options,
        );
    
        return adventurers;
    }

    @Get(':id')
    async getAdventurer(@Param('id') id: string): Promise<Adventurer> { 
        const adventurer = await this.adventurerService.getSingleAdventurer(+id); 

        if (!adventurer) {
            throw new NotFoundException(`Adventurer with ID ${id} not found`); 
        }

        return adventurer;
    }

    @Post()
    async createAdventurer(@Body() adventurerDto: AdventurerDto): Promise<Adventurer> { 
        return await this.adventurerService.create(adventurerDto); 
    }

    @Patch(':id')
    async updateAdventurer(@Param('id') id: number, @Body() adventurer: AdventurerDto): Promise<Adventurer> { 
        return this.adventurerService.update(id, adventurer); 
    }

    @Delete(':id')
    async deleteAdventurer(@Param('id') id: number): Promise<void> { 
        const adventurer = await this.adventurerService.getSingleAdventurer(id); 

        if (!adventurer) {
            throw new NotFoundException(`Adventurer with ID ${id} not found`); 
        }

        await this.adventurerService.deleteAdventurer(id); 
    }

    @Post(':adventurerId/attend/:adventureId')
    async attendAdventure(
    @Param('adventurerId') adventurerId: number,
    @Param('adventureId') adventureId: number,
    ): Promise<Adventurer> {
    const adventurer = await this.adventurerService.attendAdventure(adventurerId, adventureId);

    if (!adventurer) {
        throw new NotFoundException(`Adventurer with ID ${adventurerId} not found`);
    }

    return adventurer;
    }


}
