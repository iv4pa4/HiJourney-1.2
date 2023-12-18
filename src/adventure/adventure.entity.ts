
import { Entity, Column, PrimaryGeneratedColumn } from "typeorm";

@Entity()
export class Adventure {
    @PrimaryGeneratedColumn()
    id: number;

    @Column()
    name: string;

    @Column()
    description: string;
}

export class AdventureDto {
    name: string;
    description: string;
}
