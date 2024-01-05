import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';
import { AdventureDto } from 'src/adventure/adventure.entity'; 

@Entity()
export class Creator {
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
  createdAdventures: Adventure[];
}

export class CreatorDto {
  username: string;
  email: string;
  password: string;

  // You can include any additional fields or validation logic here
}

export class CreatorResponseDto {
  id: number;
  username: string;
  email: string;

  constructor(creator: Creator) {
    this.id = creator.id;
    this.username = creator.username;
    this.email = creator.email;
  }
}
