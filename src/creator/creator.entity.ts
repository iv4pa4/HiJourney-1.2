import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Creator {
    @PrimaryGeneratedColumn()
    id: Number;

    @Column()
    username: string

    @Column()
    email: string
}