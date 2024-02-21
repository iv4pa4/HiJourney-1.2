import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable, ManyToOne } from 'typeorm';
import { Adventurer } from 'src/adventurer/adventurer.entity';
import { Creator } from 'src/creator/creator.entity';
@Entity()
export class Adventure {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  name: string;

  @Column()
  description: string;

  @Column({default: ""})
  photoURL: string;

  @Column("int", { array: true, default: [] })
  attendedAdventurerIds: number[];

  
  @ManyToOne(() => Creator, { cascade: true })
  @JoinTable()
  creator: Creator;
}

export class AdventureDto {
  name: string;
  description: string;
  attendedAdventurerIds: number[];
  photoURL: string;
}

export class AdventureResponseDto {
  id: number;
  name: string;
  description: string;
  creatorName: string;
  photoURL: string;

  constructor(adventure: Adventure) {
    this.id = adventure.id;
    this.name = adventure.name;
    this.description = adventure.description;
    this.creatorName = adventure.creator.username
    this.photoURL = adventure.photoURL
  }
}
