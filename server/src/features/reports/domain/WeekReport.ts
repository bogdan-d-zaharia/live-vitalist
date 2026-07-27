export interface WeekData {
    number: number;
    averageIntake: Record<string, number>;
    completedDays: boolean[];
    tips?: string[];
}

export interface WeekReport {
    currentWeek: WeekData;
    previousWeek: WeekData;
}
