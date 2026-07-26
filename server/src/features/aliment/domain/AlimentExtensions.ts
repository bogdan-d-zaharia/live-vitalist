import { Aliment, InstancedAliment, TemporaryAliment } from "./Aliment";
import { AlimentBankState } from "./AlimentBankState";
import { AlimentData } from "./AlimentData";

export function readDataRef(
    aliment: Aliment,
    bank: AlimentBankState
): AlimentData {
    if ('alimentData' in aliment) {
        return (aliment as TemporaryAliment).alimentData;
    }
    return bank.aliments[(aliment as InstancedAliment).alimentID];
}

/// Tolerable to errors,
/// if no unit synonym found, returns 1.0 even if not the basic unit.
export function readUnitSize(
    aliment: Aliment,
    bank: AlimentBankState
): number {
    return readDataRef(aliment, bank).unitSynonyms?.[aliment.unit] ?? 1.0;
}

export function readField(
    aliment: Aliment,
    nutrient: string,
    bank: AlimentBankState,
    unitSize: number,
): number {
    const data = readDataRef(aliment, bank);
    const refField = data.referenceFields?.[nutrient] ?? 0.0;
    return refField * aliment.servingSize * unitSize / data.referenceSize;
}

/// Returns a processed copy of the referencedFields,
/// taking into account the servingSize and unit size.
export function readFields(
    aliment: Aliment,
    bank: AlimentBankState
): Record<string, number> {
    const data = readDataRef(aliment, bank);
    const unitSize = readUnitSize(aliment, bank);
    const result: Record<string, number> = {};

    for (const nutrient of Object.keys(data.referenceFields)) {
        result[nutrient] = readField(aliment, nutrient, bank, unitSize);
    }

    return result;
}

export function summedFields(
    aliments: Aliment[],
    bank: AlimentBankState
): Record<string, number> {
    const result: Record<string, number> = {};

    for (const aliment of aliments) {
        for (const [nutrient, value] of Object.entries(readFields(aliment, bank))) {
            result[nutrient] = (result[nutrient] ?? 0.0) + value;
        }
    }

    return result;
}
