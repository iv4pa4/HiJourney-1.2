import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOneOptions, Like, ILike } from 'typeorm';
import { Adventure, AdventureDto, AdventureResponseDto } from './adventure.entity';
import { Adventurer } from '../adventurer/adventurer.entity'; // Import Adventurer entity
import { paginate, Pagination, IPaginationOptions } from 'nestjs-typeorm-paginate';
import { SelectQueryBuilder } from 'typeorm';


@Injectable()
export class AdventureService {
    constructor(
        @InjectRepository(Adventure)
        private adventuresRepository: Repository<Adventure>,
        @InjectRepository(Adventurer)
        private adventurersRepository: Repository<Adventurer>,
      ) {}
      

  getRepo() {
    return this.adventuresRepository;
  }

  async saveAdventure(adventure: Adventure): Promise<Adventure> {
    return await this.adventuresRepository.save(adventure);
  }
  


  async findAll(fields?: (keyof Adventure)[]): Promise<AdventureResponseDto[]> {
    const options: FindOneOptions<Adventure> = {
        select: fields || ['id', 'name', 'description', 'photoURL'],
        relations: ['creator'] // Include the 'creator' relation to fetch creator data
    };

    const adventures = await this.adventuresRepository.find(options);

    return adventures.map(adventure => new AdventureResponseDto(adventure));
  }




  async getSingleAdventure(id: number): Promise<Adventure> {
    const adventure = await this.adventuresRepository.findOneOrFail({
      where: { id },
      select: ['id', 'name', 'description', 'photoURL'],
    });

    if (!adventure) {
      throw new NotFoundException('Adventure not found');
    }

    return adventure;
  }

  async searchByName(name: string): Promise<Adventure[]> {
    const adventures = await this.adventuresRepository.find({
        where: {
            name: ILike(`%${name}%`)
        }
    });

    if (!adventures || adventures.length === 0) {
        throw new NotFoundException(`No adventures found with the name containing "${name}"`);
    }

    return adventures;  
  }

  async searchByDescription(keyword: string): Promise<Adventure[]> {
    const adventures = await this.adventuresRepository.find({
        where: {
            description: ILike(`%${keyword}%`)
        }
    });

    if (!adventures || adventures.length === 0) {
        throw new NotFoundException(`No adventures found with descriptions containing "${keyword}"`);
    }

    return adventures;
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

  async displayAdventure(adventure: Adventure): Promise<void> {
    console.log('Adventure Details:');
    console.log(`ID: ${adventure.id}`);
    console.log(`Name: ${adventure.name}`);
    console.log(`Description: ${adventure.description}`);
  
    if (adventure.attendedAdventurerIds && adventure.attendedAdventurerIds.length > 0) {
      console.log('Adventurers:');
      for (const id of adventure.attendedAdventurerIds) {
        try {
          // Correcting the method call here
          const adventurer = await this.adventurersRepository.findOne({ where: { id } });
          if (adventurer) {
            console.log(`- ${adventurer.username}`);
          } else {
            console.log(`- Adventurer with ID ${id} not found`);
          }
        } catch (error) {
          console.error(`Error fetching adventurer with ID ${id}:`, error.message);
        }
      }
    } else {
      console.log('No adventurers associated with this adventure.');
    }
  }
  

  async addAdventurerToAdventure(adventurerId: number, adventureId: number): Promise<Adventure> {
    try {
      const adventurer = await this.adventurersRepository.findOneOrFail({ where: { id: adventurerId } });

      const adventure = await this.getSingleAdventure(adventureId);

      adventure.attendedAdventurerIds = adventure.attendedAdventurerIds || [];

      if (!adventure.attendedAdventurerIds.includes(adventurerId)) {
        adventure.attendedAdventurerIds.push(adventurerId);
        await this.adventurersRepository.save(adventurer);
      }

      await this.adventuresRepository.save(adventure);

      return adventure;
    } catch (error) {
      if (error.name === 'EntityNotFound') {
        throw new NotFoundException('Adventurer or Adventure not found');
      }
      throw error;
    }
  }

 
}
