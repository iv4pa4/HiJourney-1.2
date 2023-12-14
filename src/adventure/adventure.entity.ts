import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Adventure {
    @PrimaryGeneratedColumn()
    id: Number;

    @Column()
    name: string

    @Column()
    description: string

}