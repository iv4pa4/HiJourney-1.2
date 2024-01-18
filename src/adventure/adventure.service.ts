import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOneOptions } from 'typeorm';
import { Adventure, AdventureDto } from './adventure.entity';
import { Adventurer } from '../adventurer/adventurer.entity'; // Import Adventurer entity
import { paginate, Pagination, IPaginationOptions } from 'nestjs-typeorm-paginate';

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

  async findAll(
    page: number = 1,
    limit: number = 10,
    fields?: (keyof Adventure)[],
  ): Promise<Pagination<Adventure>> {
    const options: FindOneOptions<Adventure> = {
      select: fields || ['id', 'name', 'description'],
    };

    const paginationOptions: IPaginationOptions = { page, limit };

    const result = await paginate<Adventure>(
      this.adventuresRepository,
      paginationOptions,
      options,
    );

    const adventures: Pagination<Adventure> = result as Pagination<Adventure>;

    return adventures;
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

   displayAdventure(adventure: Adventure): void {
    console.log('Adventure Details:');
    console.log(`ID: ${adventure.id}`);
    console.log(`Name: ${adventure.name}`);
    console.log(`Description: ${adventure.description}`);
  
    if (adventure.adventurers && adventure.adventurers.length > 0) {
      console.log('Adventurers:');
      adventure.adventurers.forEach((adventurer) => {
        console.log(`- ${adventurer.username}`);
      });
    } else {
      console.log('No adventurers associated with this adventure.');
    }
  
    if (adventure.creators && adventure.creators.length > 0) {
      console.log('Creators:');
      adventure.creators.forEach((creator) => {
        console.log(`- ${creator.username}`);
      });
    } else {
      console.log('No creators associated with this adventure.');
    };
  }

  async attendAdventure(adventurerId: number, adventureId: number): Promise<Adventure> {
    const adventurer = await this.adventurersRepository.findOneOrFail({
      where: { id: adventurerId },
      relations: ['attendedAdventures'],
    });
  
    const adventure = await this.getSingleAdventure(adventureId);
  
    adventurer.attendedAdventures = [...(adventurer.attendedAdventures || []), adventure];
  
    await this.adventurersRepository.save(adventurer);
  
    return adventure;
  }

  
  
  
}
