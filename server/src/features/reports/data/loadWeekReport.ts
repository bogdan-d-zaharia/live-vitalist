
import { FirebaseStorageHandler } from "../../../core/storage/data/FirebaseHandler";
import { IStorageHandler } from "../../../core/storage/domain/StorageInterfaces";
import { addToDate, getISOWeek, lastDay } from "../../../core/utils/DateUtils";
import { AlimentBankState } from "../../aliment/domain/AlimentBankState";
import { Day } from "../../day/domain/Day";
import { averageDays, readDayIntake } from "../../day/domain/DayExtensions";
import { WeekData, WeekReport } from "../domain/WeekReport";

async function loadWeekData(userId: string, date: Date): Promise<WeekData> {
    const sunday = lastDay(date, 7);

    const fbh: IStorageHandler = new FirebaseStorageHandler();
    const recordsPath = `users/${userId}/records`;
    const paths = Array
        .from({ length: 7 }, (_, i) => addToDate(sunday, i - 6))
        .map(date =>
            `${recordsPath}/` +
            `${date.getDate()}_` +
            `${date.getMonth() + 1}_` +
            `${date.getFullYear()}`);
    const daysPromise = paths.map(path => fbh.loadJson(path));
    const days = (await Promise.all(daysPromise)) as (Day | null)[];
    const bank = await fbh.loadJson(`users/${userId}/aliment_bank`) as AlimentBankState;

    const strictDays = days.filter(Boolean) as Day[];
    const averageDay = averageDays(strictDays);
    const intake = readDayIntake(averageDay, bank);
    const completedDays = days.map(Boolean);
    const weekNumber = getISOWeek(sunday);

    return {
        number: weekNumber,
        averageIntake: intake,
        completedDays: completedDays,
        // tips: ['Eat more protein'],
    };
}

export async function loadWeekReport(userId: string): Promise<WeekReport> {
    const now = new Date();
    return {
        previousWeek: await loadWeekData(userId, addToDate(now, -7)),
        currentWeek: await loadWeekData(userId, now),
    }
}
