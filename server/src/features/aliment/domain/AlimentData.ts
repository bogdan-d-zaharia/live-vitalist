export interface AlimentData {
    name: string;
    unit: string;
    referenceSize: number;
    referenceFields?: Record<string, number>;
    unitSynonyms?: Record<string, number>;
}
