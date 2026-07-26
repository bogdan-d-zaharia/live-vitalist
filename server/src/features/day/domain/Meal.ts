import { Aliment } from "../../aliment/domain/Aliment";

export interface Meal {
    name: string;
    aliments: Aliment[];
}
