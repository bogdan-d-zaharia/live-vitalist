import { AlimentData } from "../../aliment/domain/AlimentData";

export interface AlimentSource {
    aliments: Record<string, AlimentData>;
}