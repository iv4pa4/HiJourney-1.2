import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOneOptions } from 'typeorm';
import { Adventurer, AdventurerDto } from './adventurer.entity';
import { paginate, Pagination, IPaginationOptions } from 'nestjs-typeorm-paginate';
import { AdventureService } from 'src/adventure/adventure.service';

@Injectable()
export class AdventurerService {
  constructor(
    @InjectRepository(Adventurer)
    private adventurersRepository: Repository<Adventurer>,
    private adventureService: AdventureService,
  ) {}

  getRepo() {
    return this.adventurersRepository;
  }

  async findAll(
    page: number = 1,
    limit: number = 10,
    fields?: (keyof Adventurer)[],
  ): Promise<Pagination<Adventurer>> {
    const options: FindOneOptions<Adventurer> = {
      select: fields || ['id', 'username', 'email', 'password','attendedAdventureIds', 'wishlistAdventureIds'],
      //relations: ['attendedAdventures'], 
    };

    const paginationOptions: IPaginationOptions = { page, limit };

    const result = await paginate<Adventurer>(
      this.adventurersRepository,
      paginationOptions,
      options,
    );

    const adventurers: Pagination<Adventurer> = result as Pagination<Adventurer>;

    return adventurers;
  }


  async getSingleAdventurer(id: number): Promise<Adventurer> {
      const adventurer = await this.adventurersRepository.findOneOrFail({
        where: { id },
        select: ['id', 'username', 'email', 'password', 'attendedAdventureIds', 'wishlistAdventureIds', 'connectedAdventurers'], // Include 'connectedAdventurers' in the select statement
      });

      if (!adventurer) {
          throw new NotFoundException('Adventurer not found');
      }

      const newAdventurer = new Adventurer();
      newAdventurer.id = adventurer.id;
      newAdventurer.username = adventurer.username;
      newAdventurer.email = adventurer.email;
      newAdventurer.password = adventurer.password;
      newAdventurer.attendedAdventureIds = adventurer.attendedAdventureIds;
      newAdventurer.wishlistAdventureIds = adventurer.wishlistAdventureIds;
      newAdventurer.connectedAdventurers = adventurer.connectedAdventurers;

      return newAdventurer;
  }


  async create(adventurer: AdventurerDto): Promise<Adventurer> {
    const newAdventurer = this.adventurersRepository.create(adventurer);
    return await this.adventurersRepository.save(newAdventurer);
  }

  async deleteAdventurer(id: number): Promise<Adventurer> {
    const adventurer = await this.getSingleAdventurer(id);
    await this.adventurersRepository.delete(id);
    return adventurer;
  }

  async update(id: number, adventurer: AdventurerDto): Promise<Adventurer> {
    try {
      const updatedAdventurer = await this.getSingleAdventurer(id);

      if (!updatedAdventurer) {
        throw new NotFoundException('Adventurer not found');
      }

      this.adventurersRepository.merge(updatedAdventurer, adventurer);
      return await this.adventurersRepository.save(updatedAdventurer);
    } catch (error) {
      if (error.name === 'EntityNotFound') {
        throw new NotFoundException('Adventurer not found');
      }
      throw error;
    }
  }

  async attendAdventure(adventurerId: number, adventureId: number): Promise<Adventurer> {
    const adventurer = await this.getSingleAdventurer(adventurerId);

    const adventure = await this.adventureService.getSingleAdventure(adventureId);

    if (!adventure) {
      throw new NotFoundException('Adventure not found');
    }

    adventurer.attendedAdventureIds.push(adventure.id);

    return await this.adventurersRepository.save(adventurer);
  }

  async addToWishlist(adventurerId: number, adventureId: number): Promise<Adventurer> {
    const adventurer = await this.getSingleAdventurer(adventurerId);
    const adventure = await this.adventureService.getSingleAdventure(adventureId);
  
    if (!adventure) {
      throw new NotFoundException('Adventure not found');
    }
      adventurer.wishlistAdventureIds = adventurer.wishlistAdventureIds || [];
    if (!adventurer.wishlistAdventureIds.includes(adventureId)) {
      adventurer.wishlistAdventureIds.push(adventure.id);
      this.adventureService.addAdventurerToAdventure(adventurer.id, adventure.id)
    }
  
    return await this.adventurersRepository.save(adventurer);
  }
  

  async displayWishlist(adventurerId: number): Promise<{ name: string; description: string; attendedAdventurerIds: number[] }[]> {
    const adventurer = await this.getSingleAdventurer(adventurerId);
    
    if (!adventurer) {
      throw new NotFoundException('Adventurer not found');
    }
  
    const wishlist: { name: string; description: string; attendedAdventurerIds: number[] }[] = [];
  
    if (adventurer.wishlistAdventureIds && adventurer.wishlistAdventureIds.length > 0) {
      for (const id of adventurer.wishlistAdventureIds) {
        try {
          const adventure = await this.adventureService.getSingleAdventure(id);
          wishlist.push({
            name: adventure.name,
            description: adventure.description,
            attendedAdventurerIds: adventure.attendedAdventurerIds,
          });
        } catch (error) {
          console.error(`Error fetching adventure with ID ${id}:`, error.message);
        }
      }
    }
  
    return wishlist;
  }

  async connectAdventurers(adventurerId1: number, adventurerId2: number): Promise<void> {
    const adventurer1 = await this.getSingleAdventurer(adventurerId1);
    const adventurer2 = await this.getSingleAdventurer(adventurerId2);
    if(adventurer1.connectedAdventurers.length > 0) {
      if (!adventurer1.connectedAdventurers.includes(adventurerId2)) {
        adventurer1.connectedAdventurers.push(adventurerId2);
        await this.adventurersRepository.save(adventurer1);
      }
    
      if (!adventurer2.connectedAdventurers.includes(adventurerId1)) {
        adventurer2.connectedAdventurers.push(adventurerId1);
        await this.adventurersRepository.save(adventurer2);
      }
    }
    else {
      adventurer1.connectedAdventurers.push(adventurerId2);
      await this.adventurersRepository.save(adventurer1);
      adventurer2.connectedAdventurers.push(adventurerId1);
      await this.adventurersRepository.save(adventurer2);
    }
  }
  
}
  


