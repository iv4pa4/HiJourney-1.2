import { Controller, Get, Post, Body, Param, Delete, Patch, Query } from '@nestjs/common';
import { CreatorService } from './creator.service';
import { Creator, CreatorDto } from './creator.entity'; 
import { NotFoundException } from '@nestjs/common';
import { paginate, Pagination } from 'nestjs-typeorm-paginate';
import { FindOneOptions } from 'typeorm';

@Controller('creator')
export class CreatorController { 
    constructor(private readonly creatorService: CreatorService) {} 

    @Get()
    async findAll(@Query() query: any = {}): Promise<Pagination<Creator>> { 
        const options: FindOneOptions<Creator> = {
           
        };
    
        const creators = await paginate<Creator>(
            this.creatorService.getRepo(), 
            query,
            options,
        );
    
        return creators;
    }

    @Get(':id')
    async getCreator(@Param('id') id: string): Promise<Creator> { 
        const creator = await this.creatorService.getSingleCreator(+id); 

        if (!creator) {
            throw new NotFoundException(`Creator with ID ${id} not found`); 
        }

        return creator;
    }

    @Post()
    async createCreator(@Body() creatorDto: CreatorDto): Promise<Creator> { 
        return await this.creatorService.create(creatorDto); 
    }

    @Patch(':id')
    async updateCreator(@Param('id') id: number, @Body() creator: CreatorDto): Promise<Creator> { 
        return this.creatorService.update(id, creator); 
    }

    @Delete(':id')
    async deleteCreator(@Param('id') id: number): Promise<void> { 
        const creator = await this.creatorService.getSingleCreator(id); 

        if (!creator) {
            throw new NotFoundException(`Creator with ID ${id} not found`); 
        }

        await this.creatorService.deleteCreator(id); 
    }
}
