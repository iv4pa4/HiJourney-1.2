import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateDateColumn } from 'typeorm';
import { Adventure } from './adventure.entity';
import { NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Entity, CustomRepositoryNotFoundError} from 'typeorm';

import { EntityManager } from 'typeorm';





@Injectable()
export class AdventureService {

    constructor(
        @InjectRepository(Adventure)
        private adventuresRepository: Repository<Adventure>,
    ){}
    //get all
    async findAll(): Promise<Adventure[]>{
        return await this.adventuresRepository.find();
    }
    //get one user
    async getSingleAdventure(id: number): Promise<Adventure> {
        const adventure = await this.findAdventure(id);
        if (!adventure) {
            throw new NotFoundException('adventure not found');
        }
        return adventure;
    }
    
    //create user
    async create(adventure: Adventure): Promise<Adventure>{
        const newUser = this.adventuresRepository.create(adventure);
        return await this.adventuresRepository.save(newUser);
    }
    

    //delet user
    async deleteAdventure(id: number): Promise<Adventure> {
    const adventure = await this.findAdventure(id);
    await this.adventuresRepository.delete(id);
    return adventure;
    }

    async deleteUser(id: number): Promise<void>{
        await this.adventuresRepository.delete(id);
    }


    async update(id: number, adventure: Adventure): Promise<Adventure> {
        try {
            const updatedAdventure = await this.findAdventure(id);
            this.adventuresRepository.merge(updatedAdventure, adventure);
            return await this.adventuresRepository.save(updatedAdventure);
        } catch (error) {
            if (error.name === 'EntityNotFound') {
                throw new NotFoundException('Adventure not found');
            }
            throw error;
        }
    }

    // find Adventure
    private async findAdventure(id: number): Promise<Adventure | undefined> {
        return await this.adventuresRepository.findOne({ where: { id } as any });
    }

}
