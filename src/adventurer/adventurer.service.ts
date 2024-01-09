import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOneOptions } from 'typeorm';
import { Adventurer, AdventurerDto } from './adventurer.entity';
import { paginate, Pagination, IPaginationOptions } from 'nestjs-typeorm-paginate';

@Injectable()
export class AdventurerService {
  constructor(
    @InjectRepository(Adventurer)
    private adventurersRepository: Repository<Adventurer>,
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
      select: fields || ['id', 'username', 'email', 'password'],
      relations: ['attendedAdventures'], 
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
      select: ['id', 'username', 'email', 'password'],
      relations: ['attendedAdventures'], 
    });

    if (!adventurer) {
      throw new NotFoundException('Adventurer not found');
    }

    return adventurer;
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
}
