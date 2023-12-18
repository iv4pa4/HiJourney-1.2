import { Controller, Get, Post, Body, Param, Delete, Patch, Query } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure, AdventureDto } from './adventure.entity';
import { NotFoundException } from '@nestjs/common';
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';

@Controller('adventure')
export class AdventureController {
    constructor(private readonly adventureService: AdventureService) {}

    @Get()
    async findAll(@Query() query: any = {}): Promise<Pagination<Adventure>> {
        const options: FindOneOptions<Adventure> = {
            // Do not include the relation if it doesn't exist
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
}
