import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable } from 'typeorm';
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

  @ManyToMany(() => Adventurer, { cascade: true })
  @JoinTable()
  adventurers: Adventurer[];

  @ManyToMany(() => Creator, { cascade: true })
  @JoinTable()
  creators: Creator[];
}

export class AdventureDto {
  name: string;
  description: string;

  // You can include any additional fields or validation logic here
}

export class AdventureResponseDto {
  id: number;
  name: string;
  description: string;

  constructor(adventure: Adventure) {
    this.id = adventure.id;
    this.name = adventure.name;
    this.description = adventure.description;
  }
}
