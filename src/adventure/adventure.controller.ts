import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { AdventureService } from './adventure.service';
import { Adventure } from './adventure.entity';
import { NotFoundException } from '@nestjs/common';


@Controller('adventure')
export class AdventureController {
    constructor(private readonly adventureService: AdventureService) {}

    // get all users
    @Get()
    async findAll(): Promise<Adventure[]> {
        return await this.adventureService.findAll();
    }

    //get one user
    @Get(':id')
    async getAdventure(@Param('id') id: string): Promise<Adventure> {
        const adventure = await this.adventureService.getSingleAdventure(+id);
    
        if (!adventure) {
            throw new NotFoundException(`Adventure with ID ${id} not found`);
        }
    
        return adventure;
    }
    

    //create user
    @Post()
    async createAdventure(@Body() adventure: Adventure): Promise<Adventure>{
        return await this.adventureService.create(adventure);
    }

    //update user
    @Put(':id')
    async updateAdventure(@Param('id') id: number, @Body() adventure: Adventure): Promise<Adventure> {
        return await this.adventureService.update(id, adventure);
    }
    

    //delete user
    @Delete(':id')
    async deleteAdventure(@Param('id') id: number): Promise<void>{
        const adventure = await this.adventureService.getSingleAdventure(id);
        if(!adventure){
            throw new Error("User not found");
        }
        this.adventureService.deleteAdventure(id);
    }


}
