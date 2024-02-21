import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, FindOneOptions } from 'typeorm';
import { Creator, CreatorDto } from './creator.entity';
import { paginate, Pagination, IPaginationOptions } from 'nestjs-typeorm-paginate';
import { Adventure, AdventureDto } from 'src/adventure/adventure.entity';
import * as bcrypt from 'bcrypt';


@Injectable()
export class CreatorService {
    constructor(
        @InjectRepository(Creator)
        private creatorsRepository: Repository<Creator>,
        @InjectRepository(Adventure)
        private adventuresRepository: Repository<Adventure>, 
      ) {}

  getRepo() {
    return this.creatorsRepository;
  }

  async findAll(query: any = {}): Promise<Creator[]> {
    const creators = await this.creatorsRepository.find({
      where: query,
    });
    return creators;
  }
  

  async getSingleCreator(id: number): Promise<Creator> {
    const creator = await this.creatorsRepository.findOneOrFail({
      where: { id },
      select: ['id', 'username', 'email', 'password'],
      relations: ['createdAdventures'], 
    });

    if (!creator) {
      throw new NotFoundException('Creator not found');
    }

    return creator;
  }

  async findByEmail(email: string): Promise<Creator> {
    try {
      const creator = await this.creatorsRepository.findOneOrFail({ where: { email } });
      return creator;
    } catch (error) {
      if (error.name === 'EntityNotFoundError') {
        throw new NotFoundException('Creator not found');
      }
      throw error;
    }
  }

  async validate(email: string, password: string): Promise<boolean> {
    const adventurer = await this.findByEmail(email);
    if (adventurer) {
        return await bcrypt.compare(password, adventurer.password);
    }
    return false;
  }

  async create(creator: CreatorDto): Promise<Creator> {
    const newCreator = this.creatorsRepository.create(creator);
    return await this.creatorsRepository.save(newCreator);
  }

  async deleteCreator(id: number): Promise<Creator> {
    const creator = await this.getSingleCreator(id);
    await this.creatorsRepository.delete(id);
    return creator;
  }

  async update(id: number, creator: CreatorDto): Promise<Creator> {
    try {
      const updatedCreator = await this.getSingleCreator(id);

      if (!updatedCreator) {
        throw new NotFoundException('Creator not found');
      }

      this.creatorsRepository.merge(updatedCreator, creator);
      return await this.creatorsRepository.save(updatedCreator);
    } catch (error) {
      if (error.name === 'EntityNotFound') {
        throw new NotFoundException('Creator not found');
      }
      throw error;
    }
  }

  async createAdventure(creatorId: number, adventureDto: AdventureDto): Promise<Adventure> {
    const creator = await this.getSingleCreator(creatorId);
  
    if (!creator) {
      throw new NotFoundException('Creator not found');
    }
  
    const newAdventure = this.adventuresRepository.create({
      ...adventureDto,
      creator: creator, 
    });
  
    return await this.adventuresRepository.save(newAdventure);
  }
  

  async getCreatorAdventures(creatorId: number): Promise<Adventure[]> {
    const creator = await this.getSingleCreator(creatorId);
  
    if (!creator) {
      throw new NotFoundException('Creator not found');
    }
  
    console.log('Creator:', creator); 
    const adventures = await this.adventuresRepository
      .createQueryBuilder('adventure')
      .leftJoinAndSelect('adventure.creator', 'creator')
      .where('creator.id = :creatorId', { creatorId })
      .getMany();
  
  
    return adventures;
  }
  
  
  
}
