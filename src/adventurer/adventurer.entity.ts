import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Adventurer {
    @PrimaryGeneratedColumn()
    id: Number;

    @Column()
    username: string

    @Column()
    email: string
}