import { Controller, Get, Post, Body, Param, Delete, Patch, Query, NotFoundException, HttpException, HttpStatus } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure, AdventureDto, AdventureResponseDto } from './adventure.entity';
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
    async findAll(@Query() query: any = {}): Promise<AdventureResponseDto[]> {
        const fields = query.fields || ['id', 'name', 'description'];
    
        try {
            const adventures = await this.adventureService.findAll(fields);
            return adventures;
        } catch (error) {
            // Handle errors appropriately
            throw new HttpException('Failed to fetch adventures', HttpStatus.INTERNAL_SERVER_ERROR);
        }
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

    @Get('search/:name')
    async searchAdventureByName(@Param('name') name: string): Promise<Adventure[]> {
        return this.adventureService.searchByName(name);
    }

    @Get('search/description/:keyword')
    async searchAdventureByDescription(@Param('keyword') keyword: string): Promise<Adventure[]> {
        return this.adventureService.searchByDescription(keyword);
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