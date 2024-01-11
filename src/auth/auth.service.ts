// auth.service.ts
import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Adventurer } from 'src/adventurer/adventurer.entity'; 
import * as bcrypt from 'bcrypt';
import { Adventure } from 'src/adventure/adventure.entity';

type SafeAdventurer = {
  id: number;
  username: string;
  email: string;
  attendedAdventures: Adventure[];
  attendedAdventuresCount: number;
};

@Injectable()
export class AuthService {
  constructor(
    @InjectRepository(Adventurer)
    private adventurerRepository: Repository<Adventurer>,
  ) {}

  async validateUser(email: string, password: string): Promise<SafeAdventurer | null> {
    const adventurer = await this.adventurerRepository.findOne({ where: { email } });
  
    if (adventurer && await bcrypt.compare(password, adventurer.password)) {
      const { password, hashPassword, ...safeAdventurer } = adventurer;
      return safeAdventurer;
    }
    console.log("in validateUser")
    return null;
  }

  async register(adventurer: Adventurer): Promise<Adventurer> {
    adventurer.password = await bcrypt.hash(adventurer.password, 10);

    const newAdventurer = this.adventurerRepository.create(adventurer);
    return await this.adventurerRepository.save(newAdventurer);
  }
}
