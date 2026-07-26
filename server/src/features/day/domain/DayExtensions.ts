import { Aliment, InstancedAliment } from "../../aliment/domain/Aliment";
import { AlimentBankState } from "../../aliment/domain/AlimentBankState";
import {
    readDataRef,
    readField,
    readUnitSize,
    summedFields,
} from "../../aliment/domain/AlimentExtensions";
import { Day } from "./Day";
import { Meal } from "./Meal";

export function sumDays(days: Day[]): Day {
    const merged: Record<string, Meal> = {};

    for (const day of days) {
        for (const meal of day.meals) {
            merged[meal.name] = {
                name: meal.name,
                aliments: [
                    ...merged[meal.name]?.aliments ?? [],
                    ...meal.aliments ?? [],
                ]
            };
        }
    }

    return { meals: Object.values(merged) };
}

export function averageDays(days: Day[]): Day {
    const sum = sumDays(days);

    const averagedMeals = sum.meals.map<Meal>(meal => ({
        name: meal.name,
        aliments: meal.aliments.map<Aliment>(aliment => ({
            ...aliment,
            servingSize: aliment.servingSize / days.length,
        })),
    }))

    return { meals: averagedMeals };
}

export function getAliments(day: Day): Aliment[] {
    return day.meals.flatMap(meal => meal.aliments);
}

export function getKey(aliment: Aliment): unknown {
    if ("alimentID" in aliment) {
        return (aliment as InstancedAliment).alimentID;
    }
    return aliment; // The reference
}

export function basicServingSize(
    aliment: Aliment, 
    bank: AlimentBankState
): number {
    return aliment.servingSize * readUnitSize(aliment, bank);
}

export function withBasicUnit(
    aliment: Aliment, 
    bank: AlimentBankState
): Aliment {
    return {
        ...aliment,
        unit: readDataRef(aliment, bank).unit,
        servingSize: basicServingSize(aliment, bank),
    };
}

export function addToAliment(
    aliment: Aliment, 
    current: Aliment, 
    bank: AlimentBankState
): Aliment {
    return {
        ...current,
        servingSize: current.servingSize + basicServingSize(aliment, bank),
    };
}

export function readDayIntake(
    day: Day, 
    bank: AlimentBankState
): Record<string, number> {
    const aliments = getAliments(day);
    return summedFields(aliments, bank);
}

export function totalAliments(
    day: Day, 
    bank: AlimentBankState
): Aliment[] {
    const total = new Map<unknown, Aliment>(); // Working in basic unit

    for (const aliment of getAliments(day)) {
        const key = getKey(aliment);
        const current = total.get(key);
        total.set(
            key,
            current === undefined
                ? withBasicUnit(aliment, bank)
                : addToAliment(aliment, current, bank),
        );
    }

    return [...total.values()];
}

export function topIntakeAliments(
    day: Day,
    nutrient: string,
    bank: AlimentBankState,
): Map<Aliment, number> {
    const entries = totalAliments(day, bank)
        .map<[Aliment, number]>(aliment => [aliment, readField(aliment, nutrient, bank, 1.0)])
        .filter(([, value]) => value !== 0.0)
        .sort((a, b) => b[1] - a[1]);

    return new Map(entries);
}
