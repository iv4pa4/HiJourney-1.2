import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { UpdateDateColumn } from 'typeorm';
import { Creator } from './creator.entity';
import { NotFoundException } from '@nestjs/common';
import { Repository } from 'typeorm';
import { Entity, CustomRepositoryNotFoundError} from 'typeorm';

import { EntityManager } from 'typeorm';





@Injectable()
export class CreatorService {

    constructor(
        @InjectRepository(Creator)
        private creatorsRepository: Repository<Creator>,
    ){}
    //get all
    async findAll(): Promise<Creator[]>{
        return await this.creatorsRepository.find();
    }
    //get one user
    async getSingleCreator(id: number): Promise<Creator> {
        const creator = await this.findAdventure(id);
        if (!creator) {
            throw new NotFoundException('Creator not found');
        }
        return creator;
    }
    
    //create user
    async create(creator: Creator): Promise<Creator>{
        const newUser = this.creatorsRepository.create(creator);
        return await this.creatorsRepository.save(newUser);
    }
    

    //delet user
    async deleteAdventure(id: number): Promise<Creator> {
    const creator = await this.findAdventure(id);
    await this.creatorsRepository.delete(id);
    return creator;
    }

    async deleteUser(id: number): Promise<void>{
        await this.creatorsRepository.delete(id);
    }


    async update(id: number, creator: Creator): Promise<Creator> {
        try {
            const updatedCreator = await this.findAdventure(id);
            this.creatorsRepository.merge(updatedCreator, creator);
            return await this.creatorsRepository.save(updatedCreator);
        } catch (error) {
            if (error.name === 'EntityNotFound') {
                throw new NotFoundException('Creator not found');
            }
            throw error;
        }
    }

    // find Creator
    private async findAdventure(id: number): Promise<Creator | undefined> {
        return await this.creatorsRepository.findOne({ where: { id } as any });
    }

}
