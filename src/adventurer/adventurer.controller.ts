import { Controller, Get, Post, Body, Param, Delete, Put } from '@nestjs/common';
import { AdventurerService } from './adventurer.service';
import { Adventurer } from './adventurer.entity';
import { NotFoundException } from '@nestjs/common';


@Controller('adventurer')
export class AdventurerController {
    constructor(private readonly adventurerService: AdventurerService) {}

    // get all users
    @Get()
    async findAll(): Promise<Adventurer[]> {
        return await this.adventurerService.findAll();
    }

    //get one user
    @Get(':id')
    async getAdventurer(@Param('id') id: string): Promise<Adventurer> {
        const adventurer = await this.adventurerService.getSingleAdventurer(+id);
    
        if (!adventurer) {
            throw new NotFoundException(`Adventurer with ID ${id} not found`);
        }
    
        return adventurer;
    }
    

    //create user
    @Post()
    async createAdventurer(@Body() adventurer: Adventurer): Promise<Adventurer>{
        return await this.adventurerService.create(adventurer);
    }

    //update user
    @Put(':id')
    async updateAdventurer(@Param('id') id: number, @Body() adventurer: Adventurer): Promise<Adventurer> {
        return await this.adventurerService.update(id, adventurer);
    }
    

    //delete user
    @Delete(':id')
    async deleteAdventurer(@Param('id') id: number): Promise<void>{
        const adventurer = await this.adventurerService.getSingleAdventurer(id);
        if(!adventurer){
            throw new Error("User not found");
        }
        this.adventurerService.deleteAdventure(id);
    }


}
