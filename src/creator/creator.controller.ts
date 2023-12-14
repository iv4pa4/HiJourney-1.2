import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { CreatorService } from './creator.service';
import { Creator } from './creator.entity';
import { NotFoundException } from '@nestjs/common';


@Controller('creator')
export class CreatorController {
    constructor(private readonly creatorService: CreatorService) {}

    // get all users
    @Get()
    async findAll(): Promise<Creator[]> {
        return await this.creatorService.findAll();
    }

    //get one user
    @Get(':id')
    async getCreator(@Param('id') id: string): Promise<Creator> {
        const creator = await this.creatorService.getSingleCreator(+id);
    
        if (!creator) {
            throw new NotFoundException(`Creator with ID ${id} not found`);
        }
    
        return creator;
    }
    

    //create user
    @Post()
    async createCreator(@Body() creator: Creator): Promise<Creator>{
        return await this.creatorService.create(creator);
    }

    //update user
    @Put(':id')
    async updateCreator(@Param('id') id: number, @Body() creator: Creator): Promise<Creator> {
        return await this.creatorService.update(id, creator);
    }
    

    //delete user
    @Delete(':id')
    async deleteCreator(@Param('id') id: number): Promise<void>{
        const creator = await this.creatorService.getSingleCreator(id);
        if(!creator){
            throw new Error("User not found");
        }
        this.creatorService.deleteAdventure(id);
    }


}
