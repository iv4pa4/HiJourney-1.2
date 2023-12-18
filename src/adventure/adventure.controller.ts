import { Controller, Get, Post, Body, Param, Delete, Patch } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure, AdventureDto } from './adventure.entity';
import { NotFoundException } from '@nestjs/common';

@Controller('adventure')
export class AdventureController {
    constructor(private readonly adventureService: AdventureService) {}

    @Get()
    async findAll(): Promise<Adventure[]> {
        return await this.adventureService.findAll();
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
    async updateAdventure(@Param('id') id: number, @Body() adventure: AdventureDto) {
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
