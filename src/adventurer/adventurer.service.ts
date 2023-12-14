import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateDateColumn } from 'typeorm';
import { Adventurer } from './adventurer.entity';
import { NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';

@Injectable()
export class AdventurerService {

    constructor(
        @InjectRepository(Adventurer)
        private adventurersRepository: Repository<Adventurer>,
    ){}
    //get all
    async findAll(): Promise<Adventurer[]>{
        return await this.adventurersRepository.find();
    }
    //get one user
    async getSingleAdventurer(id: number): Promise<Adventurer> {
        const adventurer = await this.findAdventurer(id);
        if (!adventurer) {
            throw new NotFoundException('Adventurer not found');
        }
        return adventurer;
    }
    
    //create user
    async create(adventurer: Adventurer): Promise<Adventurer>{
        const newUser = this.adventurersRepository.create(adventurer);
        return await this.adventurersRepository.save(newUser);
    }
    

    //delet user
    async deleteAdventure(id: number): Promise<Adventurer> {
    const adventurer = await this.findAdventurer(id);
    await this.adventurersRepository.delete(id);
    return adventurer;
    }

    async deleteUser(id: number): Promise<void>{
        await this.adventurersRepository.delete(id);
    }


    async update(id: number, adventurer: Adventurer): Promise<Adventurer> {
        try {
            const updatedAdventurer = await this.findAdventurer(id);
            this.adventurersRepository.merge(updatedAdventurer, adventurer);
            return await this.adventurersRepository.save(updatedAdventurer);
        } catch (error) {
            if (error.name === 'EntityNotFound') {
                throw new NotFoundException('Adventurer not found');
            }
            throw error;
        }
    }

    // find adventurer
    private async findAdventurer(id: number): Promise<Adventurer | undefined> {
        return await this.adventurersRepository.findOne({ where: { id } as any });
    }

}
