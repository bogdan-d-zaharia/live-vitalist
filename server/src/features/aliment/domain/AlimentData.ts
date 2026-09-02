export interface AlimentData {
    name: string;
    image?: string;
    unit: string;
    referenceSize: number;
    referenceFields?: Record<string, number>;
    unitSynonyms?: Record<string, number>;
}
