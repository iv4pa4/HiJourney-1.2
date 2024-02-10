import {BadRequestException, Body, Controller, UseGuards,Delete, Get, NotFoundException, Param, Patch, Post, Query, Request, UnauthorizedException} from '@nestjs/common';
import * as bcrypt from 'bcrypt';
import { AdventurerService } from './adventurer.service';
import { FindOneOptions } from 'typeorm';
import { Pagination, paginate } from 'nestjs-typeorm-paginate';
import { Adventurer, AdventurerDto, AdventurerResponseDto } from './adventurer.entity';
import { AuthenticationGuard } from 'src/guards/authentication.guard';
import { JwtService } from '@nestjs/jwt';
@Controller('adventurer')
export class AdventurerController { 
    constructor(
        private readonly adventurerService: AdventurerService,
        private jwtService: JwtService
        ) {} 
    
    @Get()
    @UseGuards(AuthenticationGuard)
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
        const parsedId = parseInt(id, 10); 
        if (isNaN(parsedId)) {
        throw new BadRequestException('Invalid adventurer ID');
    }
        if (!adventurer) {
            throw new NotFoundException(`Adventurer with ID ${id} not found`); 
        }

        return adventurer;
    }

    // @Get('email/:email')
    // async getAdventurerByEmail(@Param('email') email: string): Promise<Adventurer> {
    //   try {
    //     const adventurer = await this.adventurerService.findByEmail(email);
    //     return adventurer;
    //   } catch (error) {
    //     if (error instanceof NotFoundException) {
    //       throw new NotFoundException(error.message);
    //     }
    //     throw error;
    //   }
    // }

    @Post()
    async createAdventurer(@Body() adventurerDto: AdventurerDto): Promise<Adventurer> { 
        return await this.adventurerService.create(adventurerDto); 
    }

    @Post('validate')
    
    async testUserValidation(@Body() userData: { email: string; password: string }) {
    const { email, password } = userData;
    const isValid = await this.adventurerService.validate(email, password);
    if (isValid) {
        const payload = { email };
        const token = this.jwtService.sign(payload);
        console.log(token);
        return { token };
    }
    //return isValid;
    throw new UnauthorizedException('Invalid email or password');

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

    

    @Post(':adventurerId/add-to-wishlist/:adventureId')
    async addToWishlist(
        @Param('adventurerId') adventurerId: number,
        @Param('adventureId') adventureId: number,
    ): Promise<Adventurer> {
        const adventurer = await this.adventurerService.addToWishlist(adventurerId, adventureId);

        if (!adventurer) {
            throw new NotFoundException(`Adventurer with ID ${adventurerId} not found`);
        }

        return adventurer;
    }

    @Get(':adventurerId/wishlist')
    async displayWishlist(@Param('adventurerId') adventurerId: number): Promise<{ name: string; description: string; attendedAdventurerIds: number[] }[]> {
        return await this.adventurerService.displayWishlist(adventurerId);
    }
    
    @Post('/connect/:adventurerId1/with/:adventurerId2')
    async connectAdventurers(
    @Param('adventurerId1') adventurerId1: number,
    @Param('adventurerId2') adventurerId2: number,
    ): Promise<void> {
    await this.adventurerService.connectAdventurers(adventurerId1, adventurerId2);
    return;
    }

    @Get(':adventurerId/connected-adventurers')
    async displayConnectedAdventurers(@Param('adventurerId') adventurerId: number): Promise<AdventurerResponseDto[]> {
        return await this.adventurerService.displayConnectedAdventurers(adventurerId);
    }

}
