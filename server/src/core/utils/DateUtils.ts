export function addToDate(date: Date, days: number) {
    const newDate = new Date(date);
    newDate.setDate(newDate.getDate() + days);
    return newDate;
}

// S0(7), M1, T2, W3, T4, F5, S6
function isoWeekDay(jsDay: number) {
    return jsDay === 0 ? 7 : jsDay;
}

/// Always <= date
export function lastDay(date: Date, weekDayNumber: number) {
    let diff = isoWeekDay(date.getDay()) - weekDayNumber;
    if (diff < 0) diff += 7;
    return addToDate(date, -diff);
}

/// In the same week as date
export function nearestDay(date: Date, weekDayNumber: number) {
    return addToDate(date, weekDayNumber - isoWeekDay(date.getDay()));
}

/// The number of the week in the year
export function getISOWeek(date: Date) {
    const thursday = nearestDay(date, 4);
    const yearStart = new Date(thursday.getFullYear(), 0, 1);
    const numDays = Math.round(
        (thursday.getTime() - yearStart.getTime())
        / (24 * 60 * 60 * 1000));
    // Jan 1 => numDays = 0 => Week 0 unless we add 1.
    return Math.ceil((numDays + 1) / 7);
}
