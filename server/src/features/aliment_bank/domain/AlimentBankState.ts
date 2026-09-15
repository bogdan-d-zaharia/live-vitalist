import { AlimentData } from "../../aliment/domain/AlimentData";

export interface AlimentBankState {
    aliments: Record<string, AlimentData>;
    order: string[];
}
