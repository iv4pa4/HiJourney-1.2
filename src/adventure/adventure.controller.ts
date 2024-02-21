import { Controller, Get, Post, Body, Param, Delete, Patch, Query, NotFoundException, HttpException, HttpStatus, UseGuards } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure, AdventureDto, AdventureResponseDto } from './adventure.entity';
import { AdventurerService } from '../adventurer/adventurer.service'; 
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';
import { AuthenticationGuard } from 'src/guards/authentication.guard';
import { JwtService } from '@nestjs/jwt';

@Controller('adventure')
export class AdventureController {
    constructor(
        private readonly adventureService: AdventureService,
        private readonly adventurerService: AdventurerService, 
        private jwtService: JwtService,
    ) {}

    @Get()
    @UseGuards(AuthenticationGuard)
    async findAll(@Query() query: any = {}): Promise<AdventureResponseDto[]> {
        const fields = query.fields || ['id', 'name', 'description', 'photoURL'];
    
        try {
            const adventures = await this.adventureService.findAll(fields);
            return adventures;
        } catch (error) {
            // Handle errors appropriately
            throw new HttpException('Failed to fetch adventures', HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }


    @Get(':id')
    @UseGuards(AuthenticationGuard)
    async getAdventure(@Param('id') id: string): Promise<Adventure> {
        const adventure = await this.adventureService.getSingleAdventure(+id);

        if (!adventure) {
            throw new NotFoundException(`Adventure with ID ${id} not found`);
        }
        this.adventureService.displayAdventure(adventure);

        return adventure;
    }

    @Get('search/:name')
    @UseGuards(AuthenticationGuard)
    async searchAdventureByName(@Param('name') name: string): Promise<Adventure[]> {
        return this.adventureService.searchByName(name);
    }

    @Get('search/description/:keyword')
    @UseGuards(AuthenticationGuard)
    async searchAdventureByDescription(@Param('keyword') keyword: string): Promise<Adventure[]> {
        try {
            const adventures = await this.adventureService.searchByDescription(keyword);
            return adventures;
        } catch (error) {
            throw new NotFoundException(`No adventures found with descriptions containing "${keyword}"`);
        }
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