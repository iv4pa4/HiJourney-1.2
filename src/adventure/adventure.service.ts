import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Adventure, AdventureDto } from './adventure.entity';
import { FindOneOptions } from 'typeorm';

@Injectable()
export class AdventureService {
    constructor(
        @InjectRepository(Adventure)
        private adventuresRepository: Repository<Adventure>,
    ) {}

    async findAll(): Promise<Adventure[]> {
        return await this.adventuresRepository.find();
    }

    async getSingleAdventure(id: number): Promise<Adventure> {
        const adventure = await this.adventuresRepository.findOneOrFail({
            where: { id },
            select: ['id', 'name', 'description'],
        });
    
        if (!adventure) {
            throw new NotFoundException('Adventure not found');
        }
    
        return adventure;
    }
    

    async create(adventure: AdventureDto): Promise<Adventure> {
        const newAdventure = this.adventuresRepository.create(adventure);
        return await this.adventuresRepository.save(newAdventure);
    }

    async deleteAdventure(id: number): Promise<Adventure> {
        const adventure = await this.getSingleAdventure(id);
        await this.adventuresRepository.delete(id);
        return adventure;
    }

    async update(id: number, adventure: AdventureDto): Promise<Adventure> {
        try {
            const updatedAdventure = await this.getSingleAdventure(id);

            if (!updatedAdventure) {
                throw new NotFoundException('Adventure not found');
            }

            this.adventuresRepository.merge(updatedAdventure, adventure);
            return await this.adventuresRepository.save(updatedAdventure);
        } catch (error) {
            if (error.name === 'EntityNotFound') {
                throw new NotFoundException('Adventure not found');
            }
            throw error;
        }
    }
}
