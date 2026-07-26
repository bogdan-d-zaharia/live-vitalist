import { AlimentData } from "./AlimentData";

export interface AlimentBankState {
    aliments: Record<string, AlimentData>;
    order: string[];
}
