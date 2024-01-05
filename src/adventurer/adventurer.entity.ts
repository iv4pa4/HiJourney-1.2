import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';
import { AdventureDto } from 'src/adventure/adventure.entity';

@Entity()
export class Adventurer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  username: string;

  @Column()
  email: string;

  @Column()
  password: string;

  @ManyToMany(() => Adventure, { cascade: true })
  @JoinTable()
  attendedAdventures: Adventure[];
}

export class AdventurerDto {
  username: string;
  email: string;
  password: string;

  // You can include any additional fields or validation logic here
}

export class AdventurerResponseDto {
  id: number;
  username: string;
  email: string;

  constructor(adventurer: Adventurer) {
    this.id = adventurer.id;
    this.username = adventurer.username;
    this.email = adventurer.email;
  }
}
