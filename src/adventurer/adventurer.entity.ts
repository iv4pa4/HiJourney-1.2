import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable, BeforeInsert, BaseEntity } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';
import * as bcrypt from 'bcrypt';
import { IsNotEmpty, IsEmail, MinLength, validate } from 'class-validator';
import { ValidationError } from 'class-validator';

@Entity()
export class Adventurer extends BaseEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  @IsNotEmpty()
  username: string;

  @Column()
  @IsNotEmpty()
  @IsEmail()
  email: string ;

  @Column()
  @IsNotEmpty()
  @MinLength(6)
  password: string;

  @Column({ nullable: true }) 
  profilephoto: string;

  @Column("int", { array: true, default: []})
  attendedAdventureIds: number[];

  @Column("int", { array: true, default: [] })
  wishlistAdventureIds: number[];


  @Column("int", { array: true, default: []})
  connectedAdventurers: number[];

  @BeforeInsert()
  async hashPassword() {
    const errors: ValidationError[] = await validate(this, { skipMissingProperties: true });

    if (errors.length > 0) {
      throw new Error(errors.toString());
    }

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
  
    profilephoto: string;
  

}

export class AdventurerResponseDto {
  id: number;
  username: string;
  email: string;
  attendedAdventureIds: number[];
  wishlistAdventureIds: number[];

  constructor(adventurer: Adventurer) {
    this.id = adventurer.id;
    this.username = adventurer.username;
    this.email = adventurer.email;
    this.attendedAdventureIds = adventurer.attendedAdventureIds;
    this.wishlistAdventureIds = adventurer.wishlistAdventureIds;
    
  }
}
