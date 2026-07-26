import { AlimentData } from "./AlimentData";

export interface Aliment {
    servingSize: number;
    unit: string;
}

export interface TemporaryAliment extends Aliment {
    alimentData: AlimentData;
}

export interface InstancedAliment extends Aliment {
    alimentID: string;
}
