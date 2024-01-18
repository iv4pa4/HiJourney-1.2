import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable, RelationCount, BeforeInsert } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';
import * as bcrypt from 'bcrypt';
import { IsNotEmpty, IsEmail, MinLength } from 'class-validator';

@Entity()
export class Adventurer {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsNotEmpty()
  username: string;

  @Column()
  @IsNotEmpty()
  @IsEmail()
  email: string;

  @Column()
  @IsNotEmpty()
  @MinLength(6)
  password: string;

  @ManyToMany(() => Adventure, { cascade: true })
  @JoinTable()
  attendedAdventures: Adventure[];

  @ManyToMany(() => Adventure, { cascade: true })
  @JoinTable()
  wishlist: Adventure[];

  @RelationCount((adventurer: Adventurer) => adventurer.attendedAdventures)
  attendedAdventuresCount: number;

  @BeforeInsert()
  async hashPassword() {
    this.password = await bcrypt.hash(this.password, 10);
  }
}

export class AdventurerDto {
  @IsNotEmpty()
  username: string;

  @IsNotEmpty()
  @IsEmail()
  email: string;

  @IsNotEmpty()
  @MinLength(6)
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
