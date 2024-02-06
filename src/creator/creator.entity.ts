import { Entity, Column, PrimaryGeneratedColumn, ManyToMany, JoinTable, BeforeInsert, BaseEntity } from 'typeorm';
import { Adventure } from 'src/adventure/adventure.entity';
import * as bcrypt from 'bcrypt';
import { IsEmail, IsNotEmpty, MinLength, validate } from 'class-validator';
import { ValidationError } from 'class-validator';

@Entity()
export class Creator extends BaseEntity {
  @PrimaryGeneratedColumn()
  id: number;

  @Column()
  username: string;

  @Column()
  @IsEmail({}, { message: 'Invalid email format' })
  email: string;

  @Column()
  @IsNotEmpty()
  @MinLength(6)
  password: string;

  @ManyToMany(() => Adventure, { cascade: true })
  @JoinTable()
  createdAdventures: Adventure[];

  @BeforeInsert()
  async hashPassword() {
    // Validate the entity before inserting
    const errors: ValidationError[] = await validate(this, { skipMissingProperties: true });

    if (errors.length > 0) {
      throw new Error(errors.toString());
    }

    this.password = await bcrypt.hash(this.password, 10);
  }
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
