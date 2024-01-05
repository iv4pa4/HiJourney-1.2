import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable, RelationCount } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';

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

  @RelationCount((adventurer: Adventurer) => adventurer.attendedAdventures)
  attendedAdventuresCount: number;
}

export class AdventurerDto {
  username: string;
  email: string;
  password: string;
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
